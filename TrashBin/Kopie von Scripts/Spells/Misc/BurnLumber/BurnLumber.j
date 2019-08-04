//! runtextmacro Spell_OpenScope("/")

//! runtextmacro BaseStruct("BurnLumber", "BURN_LUMBER")
    static Trigger DUMMY_TRIGGER
    static real HEAL
    static real HEAL_MANA

    static Spell THIS_SPELL

    static method TrigConds takes nothing returns boolean
        if (SPELL.Event.Native.GetCast() != thistype.THIS_SPELL) then
            return false
        endif

        return true
    endmethod

    static method Trig takes nothing returns nothing
        local Unit caster = UNIT.Event.Native.GetTrigger()

        call caster.HealBySpell(caster, thistype.HEAL)
        call caster.HealManaBySpell(caster, thistype.HEAL_MANA)
    endmethod

    static method Event_Learn takes nothing returns nothing
        call thistype.DUMMY_TRIGGER.RegisterEvent.Unit(UNIT.Event.GetTrigger(), EVENT_UNIT_SPELL_EFFECT)
    endmethod

    static method Init takes nothing returns nothing
        //! import obj_BurnLumber.j

        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Learn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Learn))

            set thistype.DUMMY_TRIGGER = Trigger.CreateFromCode(function thistype.Trig)

            call thistype.DUMMY_TRIGGER.AddConditions(function thistype.TrigConds)

        //! runtextmacro Spell_Finalize("/")
    endmethod
endstruct