//! runtextmacro BaseStruct("EyeOfTheFlame", "EYE_OF_THE_FLAME")
    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local integer iteration = thistype.SUMMONS_AMOUNT
        local real targetX = SPOT.Event.GetTargetX()
        local real targetY = SPOT.Event.GetTargetY()

        local User casterOwner = caster.Owner.Get()

        loop
            call Unit.CreateSummon(thistype.SUMMON_UNIT_TYPE, casterOwner, targetX, targetY, UNIT.Facing.STANDARD, thistype.DURATION)

            set iteration = iteration - 1
            exitwhen (iteration < 1)
        endloop
    endmethod

    static method Init takes nothing returns nothing
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct