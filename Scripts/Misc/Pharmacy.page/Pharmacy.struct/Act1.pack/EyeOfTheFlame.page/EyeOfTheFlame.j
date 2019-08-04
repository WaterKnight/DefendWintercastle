//! runtextmacro BaseStruct("EyeOfTheFlame", "EYE_OF_THE_FLAME")
    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local real targetX = params.Spot.GetTargetX()
        local real targetY = params.Spot.GetTargetY()

        local User casterOwner = caster.Owner.Get()

		local integer iteration = thistype.SUMMONS_AMOUNT

        loop
            call Unit.CreateSummon(thistype.SUMMON_UNIT_TYPE, casterOwner, targetX, targetY, UNIT.Facing.STANDARD, thistype.DURATION)

            set iteration = iteration - 1
            exitwhen (iteration < 1)
        endloop
    endmethod

    initMethod Init of Items_Act1
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct