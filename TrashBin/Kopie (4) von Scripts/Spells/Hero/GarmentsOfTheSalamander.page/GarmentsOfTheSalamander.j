//! runtextmacro BaseStruct("GarmentsOfTheSalamander", "GARMENTS_OF_THE_SALAMANDER")
    //! runtextmacro Unit_Type_CreateChangerAbility("/", "CHANGER_ABILITY", "ASaC", "UJot", "USal")
    //! runtextmacro Unit_Type_CreateChangerAbility("/", "REVERT_ABILITY", "ASaX", "USal", "UJot")

    real lifeRegenAdd
    UnitType origUnitType

    static method Event_BuffLose takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        local real lifeRegenAdd = this.lifeRegenAdd
        local UnitType origUnitType = this.origUnitType

        call HeroSpell.ReplaceSlot(SpellClass.HERO_FIRST, WaterBindings.THIS_SPELL, target)
        call HeroSpell.ReplaceSlot(SpellClass.HERO_SECOND, thistype.THIS_SPELL, target)
        call target.Abilities.Replace(Vomit.THIS_SPELL, WhiteStaff.THIS_SPELL)
        call target.LifeRegeneration.Bonus.Subtract(lifeRegenAdd)
        call target.Type.SetWithChangerAbility(origUnitType, thistype.REVERT_ABILITY)
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        local integer level = BUFF.Event.GetLevel()
        local Unit target = UNIT.Event.GetTrigger()

        local real lifeRegenAdd = thistype.LIFE_REGEN_INCREMENT[level]
        local thistype this = target

        set this.lifeRegenAdd = lifeRegenAdd
        set this.origUnitType = target.Type.Get()

        call HeroSpell.ReplaceSlot(SpellClass.HERO_FIRST, Conflagration.THIS_SPELL, target)
        call HeroSpell.ReplaceSlot(SpellClass.HERO_SECOND, thistype.REVERT_SPELL, target)
        call target.Abilities.Replace(WhiteStaff.THIS_SPELL, Vomit.THIS_SPELL)
        call target.LifeRegeneration.Bonus.Add(lifeRegenAdd)
        call target.Type.SetWithChangerAbility(thistype.THIS_UNIT_TYPE, thistype.CHANGER_ABILITY)
    endmethod

    static method Event_RevertSpellEffect takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.Add(thistype.DUMMY_BUFF, SPELL.Event.GetLevel())
    endmethod

    static method Init takes nothing returns nothing
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.REVERT_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_RevertSpellEffect))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
        call InitAbility(thistype.CHANGER_ABILITY)
        call InitAbility(thistype.REVERT_ABILITY)
    endmethod
endstruct