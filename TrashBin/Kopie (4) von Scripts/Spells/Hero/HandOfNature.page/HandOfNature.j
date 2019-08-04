//! runtextmacro Folder("HandOfNature")
    //! runtextmacro Struct("Buff")
        static real array DAMAGE_PER_INTERVAL

        Unit caster
        real damage
        real evasionAdd
        Timer intervalTimer
        Unit target

        static method Event_BuffLose takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = target

            local real evasionAdd = this.evasionAdd
            local Timer intervalTimer = this.intervalTimer

            call intervalTimer.Destroy()

            call target.EvasionChance.Subtract(evasionAdd)
            call target.Stun.Subtract(UNIT.Stun.NONE_BUFF)
        endmethod

        static method DealDamage takes nothing returns nothing
            local thistype this = Timer.GetExpired().GetData()

            call this.caster.DamageUnitBySpell(this.target, this.damage, true, false)
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local Unit caster = Unit.TEMP
            local Timer intervalTimer = Timer.Create()
            local integer level = BUFF.Event.GetLevel()
            local Unit target = UNIT.Event.GetTrigger()

            local real evasionAdd = thistype.EVASION_INCREMENT[level]
            local thistype this = target

            set this.caster = caster
            set this.damage = thistype.DAMAGE_PER_INTERVAL[level]
            set this.evasionAdd = evasionAdd
            set this.intervalTimer = intervalTimer
            set this.target = target
            call intervalTimer.SetData(this)

            call target.EvasionChance.Add(evasionAdd)
            call target.Stun.Add(UNIT.Stun.NONE_BUFF)

            call intervalTimer.Start(thistype.INTERVAL, true, function thistype.DealDamage)
        endmethod

        static method Start takes Unit caster, integer level, Unit target returns nothing
            local real duration

            if (target.Classes.Contains(UnitClass.HERO)) then
                set duration = thistype.HERO_DURATION[level]
            else
                set duration = thistype.DURATION[level]
            endif

            set Unit.TEMP = caster

            call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, level, duration)
        endmethod

        static method Init takes nothing returns nothing
            local integer iteration

            set iteration = HandOfNature.THIS_SPELL.GetLevelsAmount()

            loop
                set thistype.DAMAGE_PER_INTERVAL[iteration] = thistype.DAMAGE[iteration] * thistype.INTERVAL / thistype.DURATION[iteration]

                set iteration = iteration - 1
                exitwhen (iteration < 1)
            endloop

            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        endmethod
    endstruct

    //! runtextmacro Struct("Heal")
        static Event DEATH_EVENT

        real lifeHeal
        real manaHeal

        static method Event_Death takes nothing returns nothing
            local Unit caster = UNIT.Event.GetKiller()

            local thistype this = caster

            call caster.Effects.Create(thistype.CASTER_EFFECT_PATH, thistype.CASTER_EFFECT_ATTACH_POINT, EffectLevel.LOW).DestroyTimed.Start(2.)

            call caster.Life.Add(this.lifeHeal)
            call caster.Life.Add(this.manaHeal)
        endmethod

        static method Event_BuffLose takes nothing returns nothing
            call UNIT.Event.GetTrigger().Event.Remove(DEATH_EVENT)
        endmethod

        static method Event_Unlearn takes nothing returns nothing
            call UNIT.Event.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local integer level = BUFF.Event.GetLevel()
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = target

            set this.lifeHeal = thistype.LIFE_HEAL[level]
            set this.manaHeal = thistype.MANA_HEAL[level]
            call target.Event.Add(DEATH_EVENT)
        endmethod

        static method Event_Learn takes nothing returns nothing
            call UNIT.Event.GetTrigger().Buffs.AddFresh(thistype.DUMMY_BUFF, SPELL.Event.GetLevel())
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.KILLER_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Death)
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
            call HandOfNature.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Learn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Learn))
            call HandOfNature.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Unlearn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Unlearn))
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("HandOfNature", "HAND_OF_NATURE")
    static Group ENUM_GROUP
    static BoolExpr TARGET_FILTER

    //! runtextmacro LinkToStruct("HandOfNature", "Buff")
    //! runtextmacro LinkToStruct("HandOfNature", "Heal")

    Unit caster
    Missile dummyMissile
    integer effectAlignment
    Timer intervalTimer
    integer level
    Unit target

    static method Impact takes nothing returns nothing
        local Missile dummyMissile = MISSILE.Event.GetTrigger()

        local thistype this = dummyMissile.GetData()

        local Unit caster = this.caster
        local Timer intervalTimer = this.intervalTimer
        local integer level = this.level
        local Unit target = this.target

        call this.deallocate()
        call dummyMissile.Destroy()
        call intervalTimer.Destroy()

        call thistype(NULL).Buff.Start(caster, level, target)
    endmethod

    static method Interval takes nothing returns nothing
        local thistype this = Timer.GetExpired().GetData()

        local Missile dummyMissile = this.dummyMissile
        local integer effectAligment = -this.effectAlignment

        set this.effectAlignment = effectAlignment
        call Spot.CreateEffect(dummyMissile.Position.X.Get() + effectAlignment * Math.Random(25., 50.), dummyMissile.Position.Y.Get() + effectAlignment * Math.Random(25., 50.), SPECIAL_EFFECT_PATH, EffectLevel.NORMAL).Destroy()
    endmethod

    static method StartTarget takes Unit caster, integer level, Unit target returns nothing
        local Missile dummyMissile = Missile.Create()
        local Timer intervalTimer = Timer.Create()
        local thistype this = thistype.allocate()

        set this.caster = caster
        set this.dummyMissile = dummyMissile
        set this.effectAlignment = -1
        set this.intervalTimer = intervalTimer
        set this.level = level
        set this.target = target
        call intervalTimer.SetData(this)

        call intervalTimer.Start(thistype.INTERVAL, true, function thistype.Interval)

        call dummyMissile.CollisionSize.Set(10.)
        call dummyMissile.Impact.SetAction(function thistype.Impact)
        call dummyMissile.SetData(this)
        call dummyMissile.Speed.Set(400.)
        call dummyMissile.Position.SetFromUnit(caster)

        call dummyMissile.GoToUnit.Start(target, false)
    endmethod

    static method Conditions takes nothing returns boolean
        local Unit target = UNIT.Event.Native.GetFilter()

        if (target.Classes.Contains(UnitClass.DEAD)) then
            return false
        endif
        if (target.Classes.Contains(UnitClass.GROUND) == false) then
            return false
        endif
        if (target.Classes.Contains(UnitClass.MECHANICAL)) then
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

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local integer level = SPELL.Event.GetLevel()
        local Unit target
        local integer targetsAmount = 1
        local real targetX = SPOT.Event.GetTargetX()
        local real targetY = SPOT.Event.GetTargetY()

        local integer maxTargetsAmount = thistype.MAX_TARGETS_AMOUNT[level]

        call Spot.CreateEffect(targetX, targetY, thistype.SUMMON_EFFECT_PATH, EffectLevel.NORMAL).Destroy()

        set caster = Unit.CreateSummon(thistype.SUMMON_UNIT_TYPE[level], caster.Owner.Get(), targetX, targetY, UNIT.Facing.STANDARD, thistype.DURATION[level])

        call caster.Scale.Set(0.)
        call caster.Scale.Timed.Add(thistype.SUMMON_UNIT_TYPE[level].Scale.Get(), 1.)

        set User.TEMP = caster.Owner.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(targetX, targetY, thistype.THIS_SPELL.GetAreaRange(level), TARGET_FILTER)

        loop
            exitwhen (targetsAmount > maxTargetsAmount)

            set target = thistype.ENUM_GROUP.GetNearest(targetX, targetY)

            exitwhen (target == NULL)

            call thistype.ENUM_GROUP.RemoveUnit(target)

            if (target != NULL) then
                call thistype.StartTarget(caster, level, target)
            endif

            set targetsAmount = targetsAmount + 1
        endloop
    endmethod

    static method Init takes nothing returns nothing
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call thistype(NULL).Buff.Init()
        call thistype(NULL).Heal.Init()
    endmethod
endstruct