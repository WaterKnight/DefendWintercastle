//! runtextmacro BaseStruct("Susanoo", "SUSANOO")
    static string ADD_TIME_EFFECT_ATTACH_POINT
    static string ADD_TIME_EFFECT_PATH
    static real array ARMOR_INCREMENT
    static real array ATTACK_RATE_INCREMENT
    static Event DEATH_EVENT
    static Buff DUMMY_BUFF
    static real array DURATION
    static real array DURATION_ADD
    static real DURATION_ADD_ADD_FACTOR
    static string SPECIAL_EFFECT_PATH
    static real array SPELL_POWER_INCREMENT

    static Spell THIS_SPELL

    //! import "Spells\Hero\Susanoo\obj.j"

    real armorAdd
    real attackRateAdd
    real durationAdd
    real lifeAdd
    real manaAdd
    real spellPowerAdd

    static method Event_BuffLose takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        local real armorAdd = this.armorAdd
        local real attackRateAdd = this.attackRateAdd
        local real spellPowerAdd = this.spellPowerAdd

        call target.Armor.IgnoreDamage.Relative.Subtract(armorAdd)
        call target.Attack.Speed.BonusA.Subtract(attackRateAdd)
        call target.Event.Remove(DEATH_EVENT)
        call target.SpellPower.Relative.Subtract(spellPowerAdd)
    endmethod

    static method Event_Death takes nothing returns nothing
        local Unit target = UNIT.Event.GetKiller()

        local thistype this = target

        local real durationAdd = this.durationAdd

        set this.durationAdd = durationAdd * (1. + thistype.DURATION_ADD_ADD_FACTOR)

        call target.Effects.Create(thistype.ADD_TIME_EFFECT_PATH, thistype.ADD_TIME_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()

        call target.Buffs.Timed.AddTime(thistype.DUMMY_BUFF, durationAdd)
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        local integer level = BUFF.Event.GetLevel()
        local Unit target = UNIT.Event.GetTrigger()

        local real armorAdd = thistype.ARMOR_INCREMENT[level]
        local real attackRateAdd = thistype.ATTACK_RATE_INCREMENT[level]
        local real spellPowerAdd = thistype.SPELL_POWER_INCREMENT[level]
        local thistype this = target

        call Spot.CreateEffect(target.Position.X.Get(), target.Position.Y.Get(), thistype.SPECIAL_EFFECT_PATH, EffectLevel.LOW).Destroy()

        set this.armorAdd = armorAdd
        set this.attackRateAdd = attackRateAdd
        set this.durationAdd = thistype.DURATION_ADD[level]
        set this.spellPowerAdd = spellPowerAdd

        call target.Armor.IgnoreDamage.Relative.Add(armorAdd)
        call target.Attack.Speed.BonusA.Add(attackRateAdd)
        call target.Event.Add(DEATH_EVENT)
        call target.SpellPower.Relative.Add(spellPowerAdd)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local integer level = SPELL.Event.GetLevel()

        call UNIT.Event.GetTrigger().Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.DURATION[level])
    endmethod

    static method Init takes nothing returns nothing
        set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.KILLER_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Death)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

            //! runtextmacro Buff_Create("/", "DUMMY_BUFF", "SuB", "Susanoo", "3", "false", "ReplaceableTextures\\CommandButtons\\BTNHowlOfTerror.blp", "Susanoo.")

            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
            call thistype.DUMMY_BUFF.TargetEffects.Add("Spells\\Susanoo\\Buff.mdx", AttachPoint.OVERHEAD, EffectLevel.LOW)
    endmethod
endstruct