//! runtextmacro BaseStruct("GarmentsOfTheSalamander", "GARMENTS_OF_THE_SALAMANDER")
    //! runtextmacro Unit_Type_CreateChangerAbility("/", "CHANGER_ABILITY", "ASaC", "UJot", "USal")
    static Buff DUMMY_BUFF
    static real array LIFE_REGEN_INCREMENT
    //! runtextmacro Unit_Type_CreateChangerAbility("/", "REVERT_ABILITY", "ASaX", "USal", "UJot")

    static Spell REVERT_SPELL
    static Spell THIS_SPELL
    static UnitType THIS_UNIT_TYPE

    //! import "Spells\Hero\GarmentsOfTheSalamander\obj.j"

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
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
        call InitAbility(thistype.CHANGER_ABILITY)
        call InitAbility(thistype.REVERT_ABILITY)

            set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME)

            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
            call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile_mini.mdl", AttachPoint.ORIGIN, EffectLevel.NORMAL)
            call thistype.DUMMY_BUFF.SetLostOnDeath(true)

        //! runtextmacro Spell_Finalize("/")

        //! runtextmacro Unit_Create("/", "THIS_UNIT_TYPE", "Sal", "Salamander Shape", "true", "DEFENDER", "0.95")

        //! runtextmacro Unit_SetArmor("/", "HERO", "1.", "Flesh")
        //! runtextmacro Unit_SetAttack("/", "NORMAL", "1.8", "140.", "250.", "ground,structure,debris,item,ward", "0.", "")
        //! runtextmacro Unit_SetBlend("/", "0.15")
        //! runtextmacro Unit_SetCasting("/", "0.5", "0.5")
        //! runtextmacro Unit_SetCollisionSize("/", "48.")
        //! runtextmacro Unit_SetCombatFlags("/", "ground", "500.")
        //! runtextmacro Unit_SetDamage("/", "NORMAL", "29", "1", "10", "0.5")
        //! runtextmacro Unit_SetDeathTime("/", "3.")
        //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "45.")
        //! runtextmacro Unit_SetExp("/", "10")
        //! runtextmacro Unit_SetHeroAttributes("/", "INTELLIGENCE", "0.8", "6.", "2.5", "16.", "4.5", "9.", "3.5")
        //! runtextmacro Unit_SetHeroNames("/", "Jota Temoinas")
        //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNThunderLizardSalamander.blp")
        //! runtextmacro Unit_SetLife("/", "100.", "1.")
        //! runtextmacro Unit_SetMana("/", "100.", "0.")
        //! runtextmacro Unit_SetMissilePoints("/", "100.", "0.", "100.", "20.")
        //! runtextmacro Unit_SetModel("/", "units\\creeps\\ThunderLizardSalamander\\ThunderLizardSalamander", "", "", "large", "")
        //! runtextmacro Unit_SetMovement("/", "FOOT", "280.", "0.5", "1", "100.", "240.")
        //! runtextmacro Unit_SetScale("/", "0.95", "2.5")
        //! runtextmacro Unit_SetShadow("/", "NORMAL", "240.", "240.", "120.", "120.")
        //! runtextmacro Unit_SetSight("/", "800.", "1400.")
        //! runtextmacro Unit_SetSoundset("/", "KotoBeastNoRider")
        //! runtextmacro Unit_SetSpellPower("/", "15.")
        //! runtextmacro Unit_SetSupply("/", "20")
        //! runtextmacro Unit_SetVertexColor("/", "255", "150", "170", "255")

        //! runtextmacro Unit_Finalize("/")

        //! runtextmacro Spell_OpenScope("/")

        //! runtextmacro Spell_Create("/", "REVERT_SPELL", "ASaR", "Revert to Human Form")

        //! runtextmacro Spell_SetTypes("/", "PARALLEL_IMMEDIATE", "HERO_SECOND")

        //! runtextmacro Spell_SetAnimation("/", "spell")
        //! runtextmacro Spell_SetAreaRange5("/", "90.", "90.", "90.", "90.", "90.", "false")
        //! runtextmacro Spell_SetCooldown5("/", "3.", "3.", "3.", "3.", "3.")
        //! runtextmacro Spell_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNHeroBloodElfPrince.blp")
        //! runtextmacro Spell_SetOrder("/", "evileye")
        //! runtextmacro Spell_SetResearchRaw("/", "SR")
        //! runtextmacro Spell_SetResearchUberTooltipLv("/", "1", "")
        //! runtextmacro Spell_SetResearchUberTooltipLv("/", "2", "")
        //! runtextmacro Spell_SetUberTooltipLv("/", "1", "")

        call thistype.REVERT_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_RevertSpellEffect))
    endmethod
endstruct