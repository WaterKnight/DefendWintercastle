//! runtextmacro BaseStruct("AICastSpell", "A_I_CastSpell")
    static BoolExpr COOLDOWN_CONDITIONS
    static BoolExpr COOLDOWN_ENDING_EVENT_CONDITIONS
    static BoolExpr COOLDOWN_START_EVENT_CONDITIONS
    //! runtextmacro GetKeyArray("KEY")
    static BoolExpr MANA_CONDITIONS
    //! runtextmacro GetKeyArray("SPELL_KEY")

    static method Event_Learn takes nothing returns nothing
        local EventCombination whichCombination = SPELL.Event.GetTrigger().Data.Integer.Get(KEY)

        call UNIT.Event.GetTrigger().Event.Combination.Add(whichCombination)
    endmethod

    static method Event_Unlearn takes nothing returns nothing
        local EventCombination whichCombination = SPELL.Event.GetTrigger().Data.Integer.Get(KEY)

        call UNIT.Event.GetTrigger().Event.Combination.Remove(whichCombination)
    endmethod

    static method Event_CooldownStart_Conditions takes nothing returns boolean
        local EventCombination whichCombination = EVENT_COMBINATION.Events.GetParent(Event.GetTrigger())

        if (SPELL.Event.GetTrigger() != whichCombination.Data.Integer.Get(SPELL_KEY)) then
            return false
        endif

        return true
    endmethod

    static method Event_CooldownEnding_Conditions takes nothing returns boolean
        local EventCombination whichCombination = EVENT_COMBINATION.Events.GetParent(Event.GetTrigger())

        if (SPELL.Event.GetTrigger() != whichCombination.Data.Integer.Get(SPELL_KEY)) then
            return false
        endif

        return true
    endmethod

    static method GeneralConditions takes nothing returns boolean
        local Unit caster = Unit.GetFromId(Event.GetSubjectId())

        if (caster.Owner.Get().Controller.Get() != PlayerController.CPU) then
            return false
        endif

        return true
    endmethod

    static method Cooldown_Conditions takes nothing returns boolean
        local Unit caster = Unit.GetFromId(Event.GetSubjectId())
        local EventCombination whichCombination = EventCombination.GetTrigger()

        if (caster.Abilities.Cooldown.Is(whichCombination.Data.Integer.Get(SPELL_KEY))) then
            return false
        endif

        return true
    endmethod

    static method Mana_Conditions takes nothing returns boolean
        local Unit caster = Unit.GetFromId(Event.GetSubjectId())
        local Spell whichSpell = EventCombination.GetTrigger().Data.Integer.Get(SPELL_KEY)

        if (caster.Mana.Get() < whichSpell.GetManaCost(1)) then
            return false
        endif

        return true
    endmethod

    static method CreateBasics takes Spell whichSpell, code action returns EventCombination
        local EventCombination whichCombination = EventCombination.Create(action)

        call whichCombination.SetConditions(BoolExpr.GetFromFunction(function thistype.GeneralConditions))
        if (whichSpell.GetCooldown(1) > 0.) then
            call whichCombination.Pairs.Create(UNIT.Abilities.Cooldown.ENDING_EVENT_TYPE, thistype.COOLDOWN_ENDING_EVENT_CONDITIONS, UNIT.Abilities.Cooldown.START_EVENT_TYPE, thistype.COOLDOWN_START_EVENT_CONDITIONS, thistype.COOLDOWN_CONDITIONS)
        endif
        if (whichSpell.GetManaCost(1) > 0.) then
            call whichCombination.Pairs.CreateLimit(UNIT.Mana.DUMMY_EVENT_TYPE, Real.ToInt(whichSpell.GetManaCost(1)), GREATER_THAN_OR_EQUAL, thistype.MANA_CONDITIONS)
        endif
        call whichCombination.Data.Integer.Set(SPELL_KEY, whichSpell)
        call whichSpell.Data.Integer.Set(KEY, whichCombination)
        call whichSpell.Event.Add(Event.Create(UNIT.Abilities.Events.Learn.DUMMY_EVENT_TYPE, EventPriority.AI, function thistype.Event_Learn))
        call whichSpell.Event.Add(Event.Create(UNIT.Abilities.Events.Unlearn.DUMMY_EVENT_TYPE, EventPriority.AI, function thistype.Event_Unlearn))

        return whichCombination
    endmethod

    static method Init takes nothing returns nothing
        set thistype.COOLDOWN_CONDITIONS = BoolExpr.GetFromFunction(function thistype.Cooldown_Conditions)
        set thistype.COOLDOWN_ENDING_EVENT_CONDITIONS = BoolExpr.GetFromFunction(function thistype.Event_CooldownEnding_Conditions)
        set thistype.COOLDOWN_START_EVENT_CONDITIONS = BoolExpr.GetFromFunction(function thistype.Event_CooldownStart_Conditions)
        set thistype.MANA_CONDITIONS = BoolExpr.GetFromFunction(function thistype.Mana_Conditions)
    endmethod
endstruct