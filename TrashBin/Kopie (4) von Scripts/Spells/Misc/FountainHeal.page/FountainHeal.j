//! runtextmacro BaseStruct("FountainHeal", "FOUNTAIN_HEAL")
    static Event DESTROY_EVENT
    static constant integer DUMMY_SPELL_ID = 'AFHD'
    //! runtextmacro GetKeyArray("KEY_ARRAY")
    static Event ORDER_EVENT

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTarget()
        local Unit target = UNIT.Event.GetTrigger()

        local real manaLifeNeeded = (target.MaxLife.GetAll() - target.Life.Get()) / thistype.HEAL_LIFE_PER_MANA_POINT
        local real manaManaNeeded = (target.MaxMana.GetAll() - target.Mana.Get()) / thistype.HEAL_MANA_PER_MANA_POINT

        local real manaNeeded = manaLifeNeeded + manaManaNeeded

        local real manaUsed = Math.Min(caster.Mana.Get(), manaNeeded)

        call target.Stop()

        if (manaUsed < 10.) then
            call caster.AddRisingTextTag(String.Color.Do(caster.GetName() + " empty or target nearly full", String.Color.MALUS), 0.024, 120., 1., 2., KEY_ARRAY + caster)

            return
        endif

        call caster.Effects.Create(thistype.CASTER_EFFECT_PATH, thistype.CASTER_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

        if (manaLifeNeeded > 0.) then
            call target.Effects.Create(thistype.TARGET_LIFE_EFFECT_PATH, thistype.TARGET_LIFE_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

            call caster.HealBySpell(target, manaUsed * manaLifeNeeded / manaNeeded * thistype.HEAL_LIFE_PER_MANA_POINT)
        endif

        if (manaManaNeeded > 0.) then
            call target.Effects.Create(thistype.TARGET_MANA_EFFECT_PATH, thistype.TARGET_MANA_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

            call caster.HealManaBySpell(target, manaUsed * manaManaNeeded / manaNeeded * thistype.HEAL_MANA_PER_MANA_POINT)
        endif

        call caster.Mana.Subtract(manaUsed)
    endmethod

    static method Event_Order takes nothing returns nothing
        local Unit caster
        local Unit target
        local User targetOwner

        if (ORDER.Event.GetTrigger() != Order.SMART) then
            return
        endif

        set caster = UNIT.Event.GetTrigger()
        set target = UNIT.Event.GetTarget()

        set targetOwner = target.Owner.Get()

        call target.Abilities.AddBySelf(thistype.DUMMY_SPELL_ID)

        call targetOwner.EnableAbilityBySelf(thistype.DUMMY_SPELL_ID, true)

        call target.Order.UnitTarget(Order.EAT_TREE, caster)

        call targetOwner.EnableAbilityBySelf(thistype.DUMMY_SPELL_ID, false)
    endmethod

    static method Event_BuffLose takes nothing returns nothing
        call UNIT.Event.GetTrigger().Event.Remove(ORDER_EVENT)
    endmethod

    static method Event_Unlearn takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        call UNIT.Event.GetTrigger().Event.Add(ORDER_EVENT)
    endmethod

    static method Event_Learn takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.Add(thistype.DUMMY_BUFF, SPELL.Event.GetLevel())
    endmethod

    static method Init takes nothing returns nothing
        set thistype.ORDER_EVENT = Event.Create(UNIT.Order.Events.Gain.Target.TARGET_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Order)
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Learn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Learn))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Unlearn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Unlearn))

        call thistype.DUMMY_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.PRE_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct