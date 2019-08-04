//! runtextmacro BaseStruct("PenguinFeather", "PENGUIN_FEATHER")
    static real EVASION_INCREMENT
    static real HEAL
    static string HEAL_TARGET_EFFECT_ATTACH_POINT
    static string HEAL_TARGET_EFFECT_PATH
    static real INTELLIGENCE_INCREMENT

    static Spell THIS_SPELL

    static method Event_Drop takes nothing returns nothing
        local Unit whichUnit = UNIT.Event.GetTrigger()

        call whichUnit.EvasionChance.Bonus.Subtract(thistype.EVASION_INCREMENT)
        call whichUnit.Hero.Intelligence.Bonus.Subtract(thistype.INTELLIGENCE_INCREMENT)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local Unit target = UNIT.Event.GetTarget()

        call target.Effects.Create(thistype.HEAL_TARGET_EFFECT_PATH, thistype.HEAL_TARGET_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).DestroyTimed.Start(2.)

        call caster.HealBySpell(target, thistype.HEAL)
    endmethod

    static method Event_PickUp takes nothing returns nothing
        local Unit whichUnit = UNIT.Event.GetTrigger()

        call whichUnit.EvasionChance.Bonus.Add(thistype.EVASION_INCREMENT)
        call whichUnit.Hero.Intelligence.Bonus.Add(thistype.INTELLIGENCE_INCREMENT)
    endmethod

    static method Init takes nothing returns nothing
        //! runtextmacro Spell_Create("/", "THIS_SPELL", "APeF", "Penguin Feather")

        //! runtextmacro Spell_SetTypes("/", "NORMAL", "ITEM")

        //! runtextmacro Spell_SetCooldown("/", "12.")
        //! runtextmacro Spell_SetData("/", "EVASION_INCREMENT", "evasionIncrement", "0.35")
        //! runtextmacro Spell_SetData("/", "HEAL", "heal", "120.")
        //! runtextmacro Spell_SetData("/", "HEAL_TARGET_EFFECT_ATTACH_POINT", "", "AttachPoint.ORIGIN")
        //! runtextmacro Spell_SetDataOfType("/", "string", "HEAL_TARGET_EFFECT_PATH", "", "Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl")
        //! runtextmacro Spell_SetData("/", "INTELLIGENCE_INCREMENT", "intelligenceIncrement", "3.")
        //! runtextmacro Spell_SetManaCost("/", "60")
        //! runtextmacro Spell_SetRange("/", "725.")
        //! runtextmacro Spell_SetTargets("/", "friend,organic")
        //! runtextmacro Spell_SetTargetType("/", "UNIT")

        call ItemType.PENGUIN_FEATHER.Event.Add(Event.Create(UNIT.Items.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_Drop))
        call ItemType.PENGUIN_FEATHER.Event.Add(Event.Create(UNIT.Items.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_PickUp))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        //! runtextmacro Spell_Finalize("/")
    endmethod
endstruct