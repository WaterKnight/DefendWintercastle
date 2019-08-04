//! runtextmacro BaseStruct("Avatar", "AVATAR")
    static real array ARMOR_INCREMENT
    static real array DAMAGE_INCREMENT
    static Buff DUMMY_BUFF
    static real array DURATION
    static real array LIFE_INCREMENT
    static real LIFE_SPELL_POWER_MOD_FACTOR
    static real array LIFE_LEECH_INCREMENT
    static real LIFE_LEECH_SPELL_POWER_MOD_FACTOR
    static real SCALE_DURATION
    static real array SCALE_INCREMENT
    static string SPECIAL_EFFECT_PATH

    static Spell THIS_SPELL

    //! import "Spells\Hero\Avatar\obj.j"

    real armorAdd
    real damageAdd
    real lifeAdd
    real lifeLeechAdd
    real scaleAdd

    static method Event_BuffLose takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        local real armorAdd = this.armorAdd    
        local real damageAdd = this.damageAdd
        local real lifeAdd = this.lifeAdd
        local real lifeLeechAdd = this.lifeLeechAdd
        local real scaleAdd = this.scaleAdd

        call target.Animation.Remove(UNIT.Animation.ALTERNATE)
        call target.Armor.Bonus.Subtract(armorAdd)
        call target.Damage.Bonus.Subtract(damageAdd)
        call target.LifeLeech.Subtract(lifeLeechAdd)
        call target.MagicImmunity.Subtract(UNIT.MagicImmunity.NONE_BUFF)
        call target.MaxLife.Bonus.Subtract(lifeAdd)
        call target.Scale.Timed.Subtract(scaleAdd, thistype.SCALE_DURATION)
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        local integer level = BUFF.Event.GetLevel()
        local Unit target = UNIT.Event.GetTrigger()

        local real spellPower = target.SpellPower.GetAll()
        local thistype this = target

        local real armorAdd = thistype.ARMOR_INCREMENT[level]
        local real damageAdd = thistype.DAMAGE_INCREMENT[level]
        local real lifeAdd = thistype.LIFE_INCREMENT[level] + spellPower * thistype.LIFE_SPELL_POWER_MOD_FACTOR
        local real lifeLeechAdd = thistype.LIFE_LEECH_INCREMENT[level] + spellPower * thistype.LIFE_LEECH_SPELL_POWER_MOD_FACTOR
        local real scaleAdd = thistype.SCALE_INCREMENT[level]

        set this.armorAdd = armorAdd
        set this.damageAdd = damageAdd
        set this.lifeAdd = lifeAdd
        set this.lifeLeechAdd = lifeLeechAdd
        set this.scaleAdd = scaleAdd
        call target.Animation.Add(UNIT.Animation.ALTERNATE)
        call target.Armor.Bonus.Add(armorAdd)
        call target.Damage.Bonus.Add(damageAdd)
        call target.LifeLeech.Add(lifeLeechAdd)
        call target.MagicImmunity.Add(UNIT.MagicImmunity.NONE_BUFF)
        call target.MaxLife.Bonus.Add(lifeAdd)
        call target.Scale.Timed.Add(scaleAdd, thistype.SCALE_DURATION)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local integer level = SPELL.Event.GetLevel()

        call UNIT.Event.GetTrigger().Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.DURATION[level])
    endmethod

    static method Init takes nothing returns nothing
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

            //! runtextmacro Buff_Create("/", "DUMMY_BUFF", "Ava", "Avatar", "3", "true", "ReplaceableTextures\\CommandButtons\\BTNAvatar.blp", "Avatar form")

            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
            call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Orc\\SpiritLink\\SpiritLinkTarget.mdl", AttachPoint.CHEST, EffectLevel.NORMAL)
    endmethod
endstruct