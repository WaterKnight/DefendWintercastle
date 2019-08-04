//! runtextmacro BaseStruct("BurnLumber", "BURN_LUMBER")
    static Trigger DUMMY_TRIGGER

    condMethod TrigConds
        if (SPELL.Event.Native.GetCast() != thistype.THIS_SPELL) then
            return false
        endif

        return true
    endmethod

    trigMethod Trig
        local Unit caster = UNIT.Event.Native.GetTrigger()

        call caster.HealBySpell(caster, thistype.HEAL)
        call caster.HealManaBySpell(caster, thistype.HEAL_MANA)
    endmethod

    eventMethod Event_Learn
        call thistype.DUMMY_TRIGGER.RegisterEvent.Unit(params.Unit.GetTrigger(), EVENT_UNIT_SPELL_EFFECT)
    endmethod

    initMethod Init of Spells_Misc
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Learn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Learn))

            set thistype.DUMMY_TRIGGER = Trigger.CreateFromCode(function thistype.Trig)

            call thistype.DUMMY_TRIGGER.AddConditions(function thistype.TrigConds)
    endmethod
endstruct