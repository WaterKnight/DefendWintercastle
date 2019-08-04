//! runtextmacro BaseStruct("FrostAttack", "FROST_ATTACK")
    static Group ENUM_GROUP
    static Event GROUND_ATTACK_EVENT
    static BoolExpr TARGET_FILTER

    static method Conditions_Single takes Unit target returns boolean
        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if target.Classes.Contains(UnitClass.MECHANICAL) then
            return false
        endif
        if target.Classes.Contains(UnitClass.STRUCTURE) then
            return false
        endif
        if target.MagicImmunity.Try() then
            return false
        endif

        return true
    endmethod

    condMethod Conditions
        local Unit target = UNIT.Event.Native.GetFilter()

        if thistype.Conditions_Single(target) then
            return false
        endif
        if target.IsAllyOf(User.TEMP) then
            return false
        endif

        return true
    endmethod

    eventMethod Event_GroundAttack
//        local Unit caster = params.Unit.GetTrigger()
        local Unit caster = params.Unit.GetDamager()
//        local Unit target
//        local real targetX = params.Spot.GetTargetX()
//        local real targetY = params.Spot.GetTargetY()
        local Unit target = params.Unit.GetTrigger()

        local real targetX = target.Position.X.Get()
        local real targetY = target.Position.Y.Get()

        local integer level = caster.Abilities.GetLevel(thistype.THIS_SPELL)

        local real duration = thistype.DURATION[level]

        set User.TEMP = caster.Owner.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(targetX, targetY, caster.Attack.Splash.GetMaxAreaRange(), thistype.TARGET_FILTER)

        call thistype.ENUM_GROUP.RemoveUnit(target)

        if thistype.Conditions_Single(target) then
            call target.Buffs.Timed.Start(thistype.COLDNESS_BUFF, level, duration)
        endif

        set target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            loop
                call target.Buffs.Timed.Start(thistype.COLDNESS_BUFF, level, duration)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
    endmethod

    eventMethod Event_BuffLose
        call params.Unit.GetTrigger().Event.Remove(GROUND_ATTACK_EVENT)
    endmethod

    eventMethod Event_BuffGain
        call params.Unit.GetTrigger().Event.Add(GROUND_ATTACK_EVENT)
    endmethod

    eventMethod Event_Unlearn
        call params.Unit.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

    eventMethod Event_Learn
        call params.Unit.GetTrigger().Buffs.Add(thistype.DUMMY_BUFF, params.Spell.GetLevel())
    endmethod

    initMethod Init of Spells_Misc
        set thistype.ENUM_GROUP = Group.Create()
//        set thistype.GROUND_ATTACK_EVENT = Event.Create(UNIT.Attack.Events.Ground.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_GroundAttack)
        set thistype.GROUND_ATTACK_EVENT = Event.Create(UNIT.Damage.Events.ATTACKER_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_GroundAttack)
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Learn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Learn))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Unlearn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Unlearn))
        call UNIT.Cold.NORMAL_BUFF.Variants.Add(thistype.COLDNESS_BUFF)
    endmethod
endstruct