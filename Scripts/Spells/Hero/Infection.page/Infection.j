//! runtextmacro Folder("Infection")
    //! runtextmacro Struct("Cone")
        static real DURATION
        static Group ENUM_GROUP
        static real LENGTH
        static BoolExpr TARGET_FILTER
        //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "1")

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
        UnitList targetGroup
        Timer updateTimer
        real xAdd
        real yAdd

        timerMethod Ending
            local Timer durationTimer = Timer.GetExpired()

            local thistype this = durationTimer.GetData()

            local DummyUnit dummyUnit = this.dummyUnit
            local UnitList targetGroup = this.targetGroup
            local Timer updateTimer = this.updateTimer

            call this.deallocate()
            call dummyUnit.Destroy()
            call durationTimer.Destroy()
            call targetGroup.Destroy()
            call updateTimer.Destroy()
        endmethod

        condMethod Conditions
            local Unit target = UNIT.Event.Native.GetFilter()

            if UnitList.TEMP.Contains(target) then
                return false
            endif

            if target.Classes.Contains(UnitClass.DEAD) then
                return false
            endif
            if target.IsAllyOf(User.TEMP) then
                return false
            endif
            if target.MagicImmunity.Try() then
                return false
            endif

            return true
        endmethod

        timerMethod Move
            local thistype this = Timer.GetExpired().GetData()

            local real angle = this.angle
            local Unit caster = this.caster
            local real damage = this.damage
            local DummyUnit dummyUnit = this.dummyUnit
            local real lengthAdd = this.lengthAdd
            local UnitList targetGroup = this.targetGroup

            local real length = this.length + lengthAdd
            local real x = dummyUnit.Position.X.Get() + this.xAdd
            local real y = dummyUnit.Position.Y.Get() + this.yAdd

            local real width = thistype.START_WIDTH + (thistype.END_WIDTH - thistype.START_WIDTH) * (length / this.maxLength)

            set this.length = length
            call dummyUnit.Position.X.Set(x)
            call dummyUnit.Position.Y.Set(y)

            set User.TEMP = caster.Owner.Get()
            set UnitList.TEMP = targetGroup

            call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, length + width, thistype.TARGET_FILTER)

            local Unit target = thistype.ENUM_GROUP.FetchFirst()

            if (target != NULL) then
                set damage = this.damage
                set lengthAdd = this.lengthAdd
                local integer level = this.level
                local real sourceX = this.sourceX
                local real sourceY = this.sourceY

                loop
                    local real dX = target.Position.X.Get() - sourceX
                    local real dY = target.Position.Y.Get() - sourceY

                    local real d = Math.DistanceByDeltas(dX, dY)
                    local real targetAngle = Math.AngleDifference(Math.AtanByDeltas(dY, dX), angle)

                    local real lengthD = Math.Cos(targetAngle) * d

                    if ((targetAngle <= Math.QUARTER_ANGLE) and (lengthD <= length) and (lengthD > length - lengthAdd) and (Math.Sin(targetAngle) * d <= width)) then
                        call targetGroup.Add(target)

                        call caster.DamageUnitBySpell(target, damage, true, false)
                    endif

                    set target = thistype.ENUM_GROUP.FetchFirst()
                    exitwhen (target == NULL)
                endloop
            endif
        endmethod

        static method Start takes Unit caster, integer level, Unit target returns nothing
            local real casterX = caster.Position.X.Get()
            local real casterY = caster.Position.Y.Get()
            local real targetX = target.Position.X.Get()
            local real targetY = target.Position.Y.Get()

            local real dX = targetX - casterX
            local real dY = targetY - casterY

            local real angle = caster.CastAngle(dX, dY)
            local real d = Math.DistanceByDeltas(dX, dY)

            local thistype this = thistype.allocate()

            local Timer durationTimer = Timer.Create()
            local UnitList targetGroup = UnitList.Create()
            local Timer updateTimer = Timer.Create()

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

            call targetGroup.Add(target)

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
        //! runtextmacro Struct("FuniculusUmbilicalis")
            static Event HEAL_EVENT
            //! runtextmacro GetKeyArray("KEY_ARRAY")

            static Unit SUMMONER

            Unit summoner

            eventMethod Event_Heal
                local Unit summoner = params.Unit.GetTrigger()
                local real healedAmount = params.Real.GetHealedAmount() * thistype.HEAL_FACTOR

                local integer iteration = summoner.Data.Integer.Table.Count(KEY_ARRAY)

                loop
                    local thistype this = summoner.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                    local Unit target = this

                    call summoner.HealBySpell(target, healedAmount)

                    set iteration = iteration - 1
                    exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
                endloop
            endmethod

            eventMethod Event_BuffLose
                local Unit target = params.Unit.GetTrigger()

                local thistype this = target

                local Unit summoner = this.summoner

                if summoner.Data.Integer.Table.Remove(KEY_ARRAY, this) then
                    call summoner.Event.Remove(HEAL_EVENT)
                endif
            endmethod

            eventMethod Event_BuffGain
                local Unit summoner = thistype.SUMMONER
                local Unit target = params.Unit.GetTrigger()

                local thistype this = target
call InfoEx("A")
                set this.summoner = summoner
call InfoEx("B")
                if summoner.Data.Integer.Table.Add(KEY_ARRAY, this) then
                    call InfoEx("C")
                    call summoner.Event.Add(HEAL_EVENT)
                endif
call InfoEx("D")
            endmethod

            eventMethod Event_Unlearn
                call params.Unit.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
            endmethod

            eventMethod Event_Learn
                call params.Unit.GetTrigger().Buffs.AddFresh(thistype.DUMMY_BUFF, params.Spell.GetLevel())
            endmethod

            static method Init takes nothing returns nothing
                set thistype.HEAL_EVENT = Event.Create(Unit.HEALED_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Heal)
                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
                call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Learn.CHANGE_LEVEL_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Learn))
                call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Learn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Learn))
                call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Unlearn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Unlearn))
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Summon")
        static Event DEATH_EVENT
        //! runtextmacro GetKey("KEY")

        integer amount

        //! runtextmacro LinkToStruct("Summon", "FuniculusUmbilicalis")

        eventMethod Event_Death
            local Unit summon = params.Unit.GetTrigger()

            local thistype this = summon.Data.Integer.Get(KEY)

            local integer amount = this.amount - 1

            set this.amount = amount
            call summon.Data.Integer.Remove(KEY)
            call summon.Event.Remove(DEATH_EVENT)
        endmethod

        static method Start takes Unit caster, integer level, Unit target returns nothing
            local thistype this = caster

            local integer amount = this.amount

            if (amount < thistype.MAX_AMOUNT[level]) then
                set amount = amount + 1

                local Unit summon = Unit.CreateSummon(thistype.SUMMON_UNIT_TYPE[level], caster.Owner.Get(), target.Position.X.Get(), target.Position.Y.Get(), target.Facing.Get(), thistype.DURATION[level])

                set this.amount = amount
                call summon.Data.Integer.Set(KEY, this)
                call summon.Event.Add(DEATH_EVENT)

                set thistype(NULL).FuniculusUmbilicalis.SUMMONER = caster

                call summon.Abilities.Add(thistype(NULL).FuniculusUmbilicalis.THIS_SPELL)
            endif
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Death)

            call thistype(NULL).FuniculusUmbilicalis.Init()
        endmethod
    endstruct

    //! runtextmacro Struct("Target")
        static real array DAMAGE_PER_INTERVAL
        static Event DEATH_EVENT

        static Unit CASTER

        Unit caster
        real damagePerInterval
        Timer intervalTimer
        integer level

        timerMethod Interval
            local thistype this = Timer.GetExpired().GetData()

            local Unit target = this

            local Unit caster = this.caster

            call caster.DamageUnitBySpell(target, this.damagePerInterval, true, false)
        endmethod

        eventMethod Event_Death
            local Unit target = params.Unit.GetTrigger()

            local thistype this = target

            call INFECTION.Summon.Start(this.caster, this.level, target)
        endmethod

        eventMethod Event_BuffLose
            local Unit target = params.Unit.GetTrigger()

            local thistype this = target

            local Timer intervalTimer = this.intervalTimer

            call intervalTimer.Destroy()
            call target.Event.Remove(DEATH_EVENT)
        endmethod

        eventMethod Event_BuffGain
            local Unit caster = thistype.CASTER
            local integer level = params.Buff.GetLevel()
            local Unit target = params.Unit.GetTrigger()

            local thistype this = target

			local Timer intervalTimer = Timer.Create()

            set this.caster = caster
            set this.damagePerInterval = thistype.DAMAGE_PER_INTERVAL[level]
            set this.intervalTimer = intervalTimer
            set this.level = level
            call target.Event.Add(DEATH_EVENT)

            call intervalTimer.Start(thistype.INTERVAL, true, function thistype.Interval)
        endmethod

        static method Start takes Unit caster, integer level, Unit target returns nothing
            set thistype.CASTER = caster

            call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.DURATION[level])
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Death)
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))

            local integer iteration = Infection.THIS_SPELL.GetLevelsAmount()

            loop
                set thistype.DAMAGE_PER_INTERVAL[iteration] = thistype.DAMAGE_TOTAL[iteration] / Real.ToInt(thistype.DURATION[iteration] / thistype.INTERVAL)

                set iteration = iteration - 1
                exitwhen (iteration < 1)
            endloop
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Infection", "INFECTION")
    static Event DAMAGE_EVENT

    integer level

    //! runtextmacro LinkToStruct("Infection", "Cone")
    //! runtextmacro LinkToStruct("Infection", "Summon")
    //! runtextmacro LinkToStruct("Infection", "Target")

    eventMethod Event_Damage
        local Unit caster = params.Unit.GetDamager()
        local Unit target = params.Unit.GetTrigger()

        if target.IsAllyOf(caster.Owner.Get()) then
            return
        endif

        local thistype this = caster

        local integer level = this.level

        call thistype(NULL).Target.Start(caster, level, target)

        //call thistype(NULL).Cone.Start(caster, level, target)
    endmethod

    eventMethod Event_BuffLose
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

        call target.Event.Remove(DAMAGE_EVENT)
    endmethod

    eventMethod Event_BuffGain
        local integer level = params.Buff.GetLevel()
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

        set this.level = level
        call target.Event.Add(DAMAGE_EVENT)
    endmethod

    eventMethod Event_SpellEffect
        local integer level = params.Spell.GetLevel()

        call params.Unit.GetTrigger().Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.DURATION[level])
    endmethod

    initMethod Init of Spells_Hero
        set thistype.DAMAGE_EVENT = Event.Create(UNIT.Damage.Events.ATTACKER_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Damage)
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call thistype(NULL).Cone.Init()
        call thistype(NULL).Target.Init()

        call thistype(NULL).Summon.Init()
    endmethod
endstruct