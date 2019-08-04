//! runtextmacro BaseStruct("AIAutoCast", "A_I_AUTO_CAST")
    static BoolExpr COOLDOWN_CONDITIONS
    static BoolExpr COOLDOWN_ENDING_EVENT_CONDITIONS
    static BoolExpr COOLDOWN_START_EVENT_CONDITIONS
    //! runtextmacro GetKeyArray("KEY")
    static BoolExpr MANA_CONDITIONS
    //! runtextmacro GetKeyArray("SPELL_KEY")

    static BoolExpr AUTO_CAST_OFF_CONDITIONS
    static BoolExpr AUTO_CAST_ON_CONDITIONS
    static BoolExpr AUTO_CAST_CONDITIONS

    condEventMethod Event_CooldownStart_Conditions
        local EventCombination whichCombination = EVENT_COMBINATION.Events.GetParent(Event.GetTrigger())

        if (params.Spell.GetTrigger() != whichCombination.Data.Integer.Get(SPELL_KEY)) then
            return false
        endif

        return true
    endmethod

    condEventMethod Event_CooldownEnding_Conditions
        local EventCombination whichCombination = EVENT_COMBINATION.Events.GetParent(Event.GetTrigger())

        if (params.Spell.GetTrigger() != whichCombination.Data.Integer.Get(SPELL_KEY)) then
            return false
        endif

        return true
    endmethod

    condEventMethod GeneralConditions
        local Unit caster = Unit.GetFromId(params.GetSubjectId())

        return true
    endmethod

    condEventMethod Cooldown_Conditions
        local Unit caster = Unit.GetFromId(params.GetSubjectId())
        local EventCombination whichCombination = EventCombination.GetTrigger()

        if caster.Abilities.Cooldown.Is(whichCombination.Data.Integer.Get(SPELL_KEY)) then
            return false
        endif

        return true
    endmethod

    condEventMethod Mana_Conditions
        local Unit caster = Unit.GetFromId(params.GetSubjectId())
        local Spell whichSpell = EventCombination.GetTrigger().Data.Integer.Get(SPELL_KEY)

        if (caster.Mana.Get() < whichSpell.GetManaCost(1)) then
            return false
        endif

        return true
    endmethod

    condEventMethod Event_AutoCastOff_Conditions
        local Spell sourceSpell = params.Spell.GetSource()
        local EventCombination whichCombination = EVENT_COMBINATION.Events.GetParent(Event.GetTrigger())

        local Spell whichSpell = whichCombination.Data.Integer.Get(SPELL_KEY)

        return (sourceSpell == whichSpell)
    endmethod

    condEventMethod Event_AutoCastOn_Conditions
        local Spell triggerSpell = params.Spell.GetTrigger()
        local EventCombination whichCombination = EVENT_COMBINATION.Events.GetParent(Event.GetTrigger())

        local Spell whichSpell = whichCombination.Data.Integer.Get(SPELL_KEY)

        return (triggerSpell == whichSpell)
    endmethod

    condEventMethod AutoCast_Conditions
        local Unit caster = Unit.GetFromId(params.GetSubjectId())
        local Spell whichSpell = EventCombination.GetTrigger().Data.Integer.Get(SPELL_KEY)

        return (caster.Abilities.AutoCast.Get() == whichSpell)
    endmethod

    eventMethod Event_Unlearn
        local EventCombination whichCombination = params.Spell.GetTrigger().Data.Integer.Get(KEY)

        call params.Unit.GetTrigger().Event.Combination.Remove(whichCombination)
    endmethod

    eventMethod Event_Learn
        local EventCombination whichCombination = params.Spell.GetTrigger().Data.Integer.Get(KEY)

        call params.Unit.GetTrigger().Event.Combination.Add(whichCombination)
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

        call whichCombination.Pairs.Create(UNIT.Abilities.AutoCast.DUMMY_EVENT_TYPE, thistype.AUTO_CAST_ON_CONDITIONS, UNIT.Abilities.AutoCast.DUMMY_EVENT_TYPE, thistype.AUTO_CAST_OFF_CONDITIONS, thistype.AUTO_CAST_CONDITIONS)

        return whichCombination
    endmethod

    initMethod Init of AI_Header
        set thistype.COOLDOWN_CONDITIONS = BoolExpr.GetFromFunction(function thistype.Cooldown_Conditions)
        set thistype.COOLDOWN_ENDING_EVENT_CONDITIONS = BoolExpr.GetFromFunction(function thistype.Event_CooldownEnding_Conditions)
        set thistype.COOLDOWN_START_EVENT_CONDITIONS = BoolExpr.GetFromFunction(function thistype.Event_CooldownStart_Conditions)
        set thistype.MANA_CONDITIONS = BoolExpr.GetFromFunction(function thistype.Mana_Conditions)

        set thistype.AUTO_CAST_OFF_CONDITIONS = BoolExpr.GetFromFunction(function thistype.Event_AutoCastOff_Conditions)
        set thistype.AUTO_CAST_ON_CONDITIONS = BoolExpr.GetFromFunction(function thistype.Event_AutoCastOn_Conditions)
        set thistype.AUTO_CAST_CONDITIONS = BoolExpr.GetFromFunction(function thistype.AutoCast_Conditions)
    endmethod
endstruct