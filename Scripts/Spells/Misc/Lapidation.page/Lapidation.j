//! runtextmacro Folder("Lapidation")
    //! runtextmacro Struct("Buff")
        eventMethod Event_BuffLose
            local Unit target = params.Unit.GetTrigger()

            local thistype this = target

            call target.Animation.Speed.Add(1.)
        endmethod

        eventMethod Event_BuffGain
            local Unit target = params.Unit.GetTrigger()

            local thistype this = target

            call target.Animation.Speed.Subtract(1.)
        endmethod

        static method Start takes integer level, Unit target returns nothing
            call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.DURATION)
        endmethod

        static method Init takes nothing returns nothing
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
            call UNIT.Stun.NORMAL_BUFF.Variants.Add(thistype.DUMMY_BUFF)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Lapidation", "LAPIDATION")
    static Group ENUM_GROUP
    static BoolExpr TARGET_FILTER

    Unit caster
    real damage
    integer level
    Unit target

    //! runtextmacro LinkToStruct("Lapidation", "Buff")

    static method Conditions_Single takes Unit target returns boolean
        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if not target.Classes.Contains(UnitClass.GROUND) then
            return false
        endif
        if target.Classes.Contains(UnitClass.MECHANICAL) then
            return false
        endif
        if target.IsAllyOf(User.TEMP) then
            return false
        endif

        return true
    endmethod

    eventMethod Impact
        local Missile dummyMissile = params.Missile.GetTrigger()

        local thistype this = dummyMissile.GetData()

        local Unit caster = this.caster
        local real damage = this.damage
        local integer level = this.level
        local Unit target = this.target

        call this.deallocate_demount()
        call dummyMissile.Destroy()

        set User.TEMP = caster.Owner.Get()

        if thistype.Conditions_Single(target) then
            call thistype(NULL).Buff.Start(level, target)

            call caster.DamageUnitBySpell(target, damage, true, false)
        endif
    endmethod

    static method StartTarget takes Unit caster, integer level, Unit target returns nothing
        local Missile dummyMissile = Missile.Create()

        local thistype this = thistype.allocate_mount(dummyMissile)

        set this.caster = caster
        set this.damage = thistype.DAMAGE
        set this.level = level
        set this.target = target

        call dummyMissile.Arc.SetByPerc(0.06)
        call dummyMissile.CollisionSize.Set(10.)
        call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 2.)
        call dummyMissile.Impact.SetAction(function thistype.Impact)
        call dummyMissile.SetData(this)
        call dummyMissile.Speed.Set(1400.)
        call dummyMissile.Position.SetFromUnit(caster)

        call dummyMissile.GoToUnit.Start(target, null)
    endmethod

    //! runtextmacro Group_CreateUnitBoolExprAdapter("Conditions", "Conditions_Single")

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()
        local real targetX = params.Spot.GetTargetX()
        local real targetY = params.Spot.GetTargetY()

        set User.TEMP = caster.Owner.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(targetX, targetY, thistype.THIS_SPELL.GetAreaRange(level), thistype.TARGET_FILTER)

        local Unit target = thistype.ENUM_GROUP.GetRandom()

        if (target != NULL) then
            local integer iteration = thistype.MAX_TARGETS_AMOUNT

            loop
                exitwhen (iteration < 1)
                call thistype.ENUM_GROUP.RemoveUnit(target)

                call thistype.StartTarget(caster, level, target)

                set target = thistype.ENUM_GROUP.GetRandom()
                exitwhen (target == NULL)

                set iteration = iteration - 1
            endloop
        endif
    endmethod

    initMethod Init of Spells_Misc
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call thistype(NULL).Buff.Init()
    endmethod
endstruct