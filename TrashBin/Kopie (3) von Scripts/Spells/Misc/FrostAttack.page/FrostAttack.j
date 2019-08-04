//! runtextmacro BaseStruct("FrostAttack", "FROST_ATTACK")
    static Group ENUM_GROUP
    static Event GROUND_ATTACK_EVENT
    static BoolExpr TARGET_FILTER

    static method Conditions takes nothing returns boolean
        local Unit target = UNIT.Event.Native.GetFilter()

        if (target.Classes.Contains(UnitClass.DEAD)) then
            return false
        endif
        if (target.Classes.Contains(UnitClass.MECHANICAL)) then
            return false
        endif
        if (target.Classes.Contains(UnitClass.STRUCTURE)) then
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

    static method Event_GroundAttack takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local real duration
        local Unit target
        local real targetX = SPOT.Event.GetTargetX()
        local real targetY = SPOT.Event.GetTargetY()

        local integer level = caster.Abilities.GetLevel(thistype.THIS_SPELL)

        set User.TEMP = caster.Owner.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(targetX, targetY, caster.Attack.Splash.GetMaxAreaRange(), thistype.TARGET_FILTER)

        set target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            set duration = thistype.DURATION[level]

            loop
                call target.Cold.AddTimed(duration)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
    endmethod

    static method Event_BuffLose takes nothing returns nothing
        call UNIT.Event.GetTrigger().Event.Remove(GROUND_ATTACK_EVENT)
    endmethod

    static method Event_Unlearn takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        call UNIT.Event.GetTrigger().Event.Add(GROUND_ATTACK_EVENT)
    endmethod

    static method Event_Learn takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.Add(thistype.DUMMY_BUFF, SPELL.Event.GetLevel())
    endmethod

    static method Init takes nothing returns nothing
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.GROUND_ATTACK_EVENT = Event.Create(UNIT.Attack.Events.Ground.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_GroundAttack)
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Learn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Learn))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Unlearn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Unlearn))
    endmethod
endstruct