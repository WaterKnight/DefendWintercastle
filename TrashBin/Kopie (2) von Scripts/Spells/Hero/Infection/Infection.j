//! runtextmacro Folder("Infection")
    //! runtextmacro Struct("Cone")
        static real array DAMAGE
        static real DURATION
        //! runtextmacro DummyUnit_CreateSimpleType("/", "dIfc", "Infection Cone", "DUMMY_UNIT_ID", "Abilities\\Spells\\Undead\\CarrionSwarm\\CarrionSwarmMissile.mdl")
        static real END_WIDTH
        static Group ENUM_GROUP
        static real LENGTH
        static real MAX_LENGTH
        static real SPEED
        static real START_WIDTH
        static BoolExpr TARGET_FILTER
        //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "2")

        //! import "Spells\Hero\Infection\Cone\obj.j"

        real angle
        Unit caster
        real damage
        DummyUnit dummyUnit
        real length
        real lengthAdd
        integer level
        real maxLength
        real sourceX
        real sourceY
        Group targetGroup
        Timer updateTimer
        real xAdd
        real yAdd

        static method Ending takes nothing returns nothing
            local Timer durationTimer = Timer.GetExpired()

            local thistype this = durationTimer.GetData()

            local DummyUnit dummyUnit = this.dummyUnit
            local Timer updateTimer = this.updateTimer

            call this.deallocate()
            call dummyUnit.Destroy()
            call durationTimer.Destroy()
            call targetGroup.Destroy()
            call updateTimer.Destroy()
        endmethod

        static method Conditions takes nothing returns boolean
            local Unit target = UNIT.Event.Native.GetFilter()

            if (Group.TEMP.ContainsUnit(target)) then
                return false
            endif

            if (target.Classes.Contains(UnitClass.DEAD)) then
                return false
            endif
            if (target.IsAllyOf(User.TEMP)) then
                return false
            endif
            if (target.MagicImmunity.Try()) then
                return false
            endif

            return true
        endmethod

        static method Move takes nothing returns nothing
            local real d
            local real dX
            local real dY
            local real lengthD
            local integer level
            local real sourceX
            local real sourceY
            local Unit target
            local real targetAngle
            local thistype this = Timer.GetExpired().GetData()

            local real angle = this.angle
            local Unit caster = this.caster
            local real damage = this.damage
            local DummyUnit dummyUnit = this.dummyUnit
            local real lengthAdd = this.lengthAdd
            local Group targetGroup = this.targetGroup

            local real length = this.length + lengthAdd
            local real x = dummyUnit.Position.X.Get() + this.xAdd
            local real y = dummyUnit.Position.Y.Get() + this.yAdd

            local real width = thistype.START_WIDTH + (thistype.END_WIDTH - thistype.START_WIDTH) * (length / this.maxLength)

            set this.length = length
            call dummyUnit.Position.X.Set(x)
            call dummyUnit.Position.Y.Set(y)

            set User.TEMP = caster.Owner.Get()
            set Group.TEMP = targetGroup

            call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, length + width, thistype.TARGET_FILTER)

            set target = thistype.ENUM_GROUP.FetchFirst()

            if (target != NULL) then
                set damage = this.damage
                set lengthAdd = this.lengthAdd
                set level = this.level
                set sourceX = this.sourceX
                set sourceY = this.sourceY

                loop
                    set dX = target.Position.X.Get() - sourceX
                    set dY = target.Position.Y.Get() - sourceY

                    set d = Math.DistanceByDeltas(dX, dY)
                    set targetAngle = Math.AngleDifference(Math.AtanByDeltas(dY, dX), angle)

                    set lengthD = Math.Cos(targetAngle) * d

                    if ((targetAngle <= Math.QUARTER_ANGLE) and (lengthD <= length) and (lengthD > length - lengthAdd) and (Math.Sin(targetAngle) * d <= width)) then
                        call targetGroup.AddUnit(target)

                        call caster.DamageUnitBySpell(target, damage, true, false)
                    endif

                    set target = thistype.ENUM_GROUP.FetchFirst()
                    exitwhen (target == NULL)
                endloop
            endif
        endmethod

        static method Start takes Unit caster, integer level, Unit target returns nothing
            local Timer durationTimer = Timer.Create()
            local Group targetGroup = Group.Create()
            local real targetX = target.Position.X.Get()
            local real targetY = target.Position.Y.Get()
            local thistype this = thistype.allocate()
            local Timer updateTimer = Timer.Create()

            local real casterX = caster.Position.X.Get()
            local real casterY = caster.Position.Y.Get()

            local real dX = targetX - casterX
            local real dY = targetY - casterY

            local real angle = caster.CastAngle(dX, dY)
            local real d = Math.DistanceByDeltas(dX, dY)

            set this.angle = angle
            set this.caster = caster
            set this.damage = thistype.DAMAGE[level]
            set this.dummyUnit = DummyUnit.Create(thistype.DUMMY_UNIT_ID, casterX, casterY, caster.Position.Z.Get() + caster.Outpact.Z.Get(true), angle)
            set this.length = 0.
            set this.lengthAdd = thistype.LENGTH
            set this.level = level
            set this.maxLength = thistype.MAX_LENGTH
            set this.sourceX = casterX
            set this.sourceY = casterY
            set this.targetGroup = targetGroup
            set this.updateTimer = updateTimer
            set this.xAdd = dX / d * thistype.LENGTH
            set this.yAdd = dY / d * thistype.LENGTH
            call durationTimer.SetData(this)
            call updateTimer.SetData(this)

            call targetGroup.AddUnit(target)

            call updateTimer.Start(thistype.UPDATE_TIME, true, function thistype.Move)

            call durationTimer.Start(thistype.DURATION, false, function thistype.Ending)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DURATION = thistype.MAX_LENGTH / thistype.SPEED
            set thistype.ENUM_GROUP = Group.Create()
            set thistype.LENGTH = thistype.SPEED * thistype.UPDATE_TIME
            set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        endmethod
    endstruct

    //! runtextmacro Folder("Summon")
        //! runtextmacro Struct("Funiculus_Umbilicalis")
            static Buff DUMMY_BUFF
            static Event HEAL_EVENT
            static real HEAL_FACTOR
            //! runtextmacro GetKeyArray("KEY_ARRAY")
            static Unit SUMMONER

            static Spell THIS_SPELL

            //! import "Spells\Hero\Infection\Summon\FuniculusUmbilicalis\obj.j"

            Unit summoner

            static method Event_Heal takes nothing returns nothing
                local Unit summoner = UNIT.Event.GetTrigger()
                local real healedAmount = Unit.GetHealedAmount() * thistype.HEAL_FACTOR
                local Unit target
                local thistype this

                local integer iteration = summoner.Data.Integer.Table.Count(KEY_ARRAY)

                loop
                    set this = summoner.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                    set target = this

                    call summoner.HealBySpell(target, healedAmount)

                    set iteration = iteration - 1
                    exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
                endloop
            endmethod

            static method Event_BuffLose takes nothing returns nothing
                local Unit target = UNIT.Event.GetTrigger()

                local thistype this = target

                local Unit summoner = this.summoner

                if (summoner.Data.Integer.Table.Remove(KEY_ARRAY, this)) then
                    call summoner.Event.Remove(HEAL_EVENT)
                endif
            endmethod

            static method Event_BuffGain takes nothing returns nothing
                local Unit summoner = thistype.SUMMONER
                local Unit target = UNIT.Event.GetTrigger()

                local thistype this = target

                set this.summoner = summoner
                if (summoner.Data.Integer.Table.Add(KEY_ARRAY, this)) then
                    call summoner.Event.Add(HEAL_EVENT)
                endif
            endmethod

            static method Event_Unlearn takes nothing returns nothing
                call UNIT.Event.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
            endmethod

            static method Event_Learn takes nothing returns nothing
                call UNIT.Event.GetTrigger().Buffs.AddFresh(thistype.DUMMY_BUFF, SPELL.Event.GetLevel())
            endmethod

            static method Init takes nothing returns nothing
                set thistype.HEAL_EVENT = Event.Create(Unit.HEALED_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Heal)
                call Infection.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Learn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Learn))
                call Infection.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Unlearn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Unlearn))

                    set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME)

                    call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
                    call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
                    call thistype.DUMMY_BUFF.SetLostOnDeath(false)

                //! runtextmacro Spell_Finalize("/")
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Summon")
        static Event DEATH_EVENT
        static real array DURATION
        //! runtextmacro GetKey("KEY")
        static integer array MAX_AMOUNT
        static UnitType array SUMMON_UNIT_TYPE

        //! import "Spells\Hero\Infection\Summon\obj.j"

        integer amount

        //! runtextmacro LinkToStruct("Summon", "Funiculus_Umbilicalis")

        static method Event_Death takes nothing returns nothing
            local Unit summon = UNIT.Event.GetTrigger()

            local thistype this = summon.Data.Integer.Get(KEY)

            local integer amount = this.amount - 1

            set this.amount = amount
            call summon.Data.Integer.Remove(KEY)
            call summon.Event.Remove(DEATH_EVENT)
        endmethod

        static method Start takes Unit caster, integer level, Unit target returns nothing
            local Unit summon
            local thistype this = caster

            local integer amount = this.amount

            if (amount < thistype.MAX_AMOUNT[level]) then
                set amount = amount + 1
                set summon = Unit.CreateSummon(thistype.SUMMON_UNIT_TYPE[level], caster.Owner.Get(), target.Position.X.Get(), target.Position.Y.Get(), target.Facing.Get(), thistype.DURATION[level])

                set this.amount = amount
                call summon.Data.Integer.Set(KEY, this)
                call summon.Event.Add(DEATH_EVENT)

                set thistype(NULL).Funiculus_Umbilicalis.SUMMONER = caster

                call summon.Abilities.Add(thistype(NULL).Funiculus_Umbilicalis.THIS_SPELL)
            endif
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Death)

            call thistype(NULL).Funiculus_Umbilicalis.Init()
        endmethod
    endstruct

    //! runtextmacro Struct("Target")
        static real array ARMOR_INCREMENT
        static Event DEATH_EVENT
        static Buff DUMMY_BUFF
        static real array DURATION

        //! import "Spells\Hero\Infection\Target\obj.j"

        real armorAdd
        Unit caster
        integer level

        static method Event_BuffLose takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = target

            local real armorAdd = this.armorAdd

            call target.Armor.Bonus.Subtract(armorAdd)
            call target.Event.Remove(DEATH_EVENT)
            call target.Poisoned.Subtract()
        endmethod

        static method Event_Death takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = target

            call INFECTION.Summon.Start(this.caster, this.level, target)
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local Unit caster = Unit.TEMP
            local integer level = BUFF.Event.GetLevel()
            local Unit target = UNIT.Event.GetTrigger()

            local real armorAdd = thistype.ARMOR_INCREMENT[level]
            local thistype this = target

            set this.armorAdd = armorAdd
            set this.caster = caster
            set this.level = level
            call target.Armor.Bonus.Add(armorAdd)
            call target.Event.Add(DEATH_EVENT)
            call target.Poisoned.Add()
        endmethod

        static method Start takes Unit caster, integer level, Unit target returns nothing
            set Unit.TEMP = caster

            call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.DURATION[level])
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Death)

                //! runtextmacro Buff_Create("/", "DUMMY_BUFF", "InB", "Infection", "5", "false", "ReplaceableTextures\\CommandButtons\\BTNDoom.blp", "This unit is a breeding ground for a new descendant in case of death under this buff.")

                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
                call thistype.DUMMY_BUFF.SetLostOnDispel(true)
                call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Other\\AcidBomb\\BottleImpact.mdl", AttachPoint.HEAD, EffectLevel.NORMAL)
                call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Other\\Parasite\\ParasiteTarget.mdl", AttachPoint.OVERHEAD, EffectLevel.LOW)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Infection", "INFECTION")
    static Event DAMAGE_EVENT
    static Buff DUMMY_BUFF
    static real array DURATION
    static real array SPELL_POWER_INCREMENT

    static Spell THIS_SPELL

    //! import "Spells\Hero\Infection\obj.j"

    integer level
    real spellPowerAdd

    //! runtextmacro LinkToStruct("Infection", "Cone")
    //! runtextmacro LinkToStruct("Infection", "Summon")
    //! runtextmacro LinkToStruct("Infection", "Target")

    static method Event_Damage takes nothing returns nothing
        local Unit caster = UNIT.Event.GetDamager()
        local integer level
        local Unit target = UNIT.Event.GetTrigger()
        local thistype this

        if (target.IsAllyOf(caster.Owner.Get())) then
            return
        endif

        set this = caster

        set level = this.level

        call thistype(NULL).Target.Start(caster, level, target)

        call thistype(NULL).Cone.Start(caster, level, target)
    endmethod

    static method Event_BuffLose takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        call target.Event.Remove(DAMAGE_EVENT)
        call target.SpellPower.Bonus.Subtract(this.spellPowerAdd)
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        local integer level = BUFF.Event.GetLevel()
        local Unit target = UNIT.Event.GetTrigger()

        local real spellPowerAdd = thistype.SPELL_POWER_INCREMENT[level]
        local thistype this = target

        set this.level = level
        set this.spellPowerAdd = spellPowerAdd
        call target.SpellPower.Bonus.Add(spellPowerAdd)
        call target.Event.Add(DAMAGE_EVENT)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local integer level = SPELL.Event.GetLevel()

        call UNIT.Event.GetTrigger().Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.DURATION[level])
    endmethod

    static method Init takes nothing returns nothing
        set thistype.DAMAGE_EVENT = Event.Create(UNIT.Damage.Events.ATTACKER_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Damage)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

            //! runtextmacro Buff_Create("/", "DUMMY_BUFF", "Inf", "Infection", "5", "true", "ReplaceableTextures\\CommandButtons\\BTNDoom.blp", "Drakul's attacks infect the target; thereby reducing its armor and spawning a descendant in case of death. Also your spell power is increased.")

            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
            call thistype.DUMMY_BUFF.SetLostOnDeath(false)
            call thistype.DUMMY_BUFF.TargetEffects.Add("Spells\\Infection\\Caster.mdx", AttachPoint.HEAD, EffectLevel.LOW)

        call thistype(NULL).Cone.Init()
        call thistype(NULL).Target.Init()

        call thistype(NULL).Summon.Init()
    endmethod
endstruct