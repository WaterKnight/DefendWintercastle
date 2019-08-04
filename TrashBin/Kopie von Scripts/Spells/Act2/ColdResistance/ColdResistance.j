//! runtextmacro Spell_OpenScope("/")

//! runtextmacro BaseStruct("ColdResistance", "COLD_RESISTANCE")
    static real ARMOR_INCREMENT
    static Buff DUMMY_BUFF

    static Spell THIS_SPELL

    static method Event_BuffLose takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        call target.Armor.Spell.Subtract(thistype.ARMOR_INCREMENT)
    endmethod

    static method Event_Unlearn takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        call target.Armor.Spell.Add(thistype.ARMOR_INCREMENT)
    endmethod

    static method Event_Learn takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.AddFresh(thistype.DUMMY_BUFF, SPELL.Event.GetLevel())
    endmethod

    static method Init takes nothing returns nothing
        //! import ColdResistance.j

        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Learn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Learn))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Unlearn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Unlearn))

            //! runtextmacro Buff_Create("/", "DUMMY_BUFF", "CoR", "Cold Resistance", "1", "false", "ReplaceableTextures\\CommandButtons\\BTNFreezingBreath.blp", "This unit's spell armor is increased.")

            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
            call thistype.DUMMY_BUFF.SetLostOnDeath(false)
            call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Undead\\FrostArmor\\FrostArmorTarget.mdl", AttachPoint.ORIGIN, EffectLevel.LOW)

        //! runtextmacro Spell_Finalize("/")
    endmethod
endstruct