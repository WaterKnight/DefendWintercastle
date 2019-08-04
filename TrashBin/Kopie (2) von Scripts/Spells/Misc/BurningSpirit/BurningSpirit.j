//! runtextmacro BaseStruct("BurningSpirit", "BURNING_SPIRIT")
    static real ATTACK_RATE_INCREMENT
    static real CRITICAL_CHANCE_INCREMENT
    static Buff DUMMY_BUFF
    static real DURATION
    static real SPEED_RELATIVE_INCREMENT

    static Spell THIS_SPELL

    static method Event_BuffLose takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        call target.Attack.Speed.BonusA.Subtract(thistype.ATTACK_RATE_INCREMENT)
        call target.CriticalChance.Subtract(thistype.CRITICAL_CHANCE_INCREMENT)
        call target.Movement.Speed.RelativeA.Subtract(thistype.SPEED_RELATIVE_INCREMENT)
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        call target.Attack.Speed.BonusA.Add(thistype.ATTACK_RATE_INCREMENT)
        call target.CriticalChance.Add(thistype.CRITICAL_CHANCE_INCREMENT)
        call target.Movement.Speed.RelativeA.Add(thistype.SPEED_RELATIVE_INCREMENT)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.Timed.Start(DUMMY_BUFF, SPELL.Event.GetLevel(), thistype.DURATION)
    endmethod

    static method Init takes nothing returns nothing
        //! import "obj_BurningSpirit.j"

        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

            //! runtextmacro Buff_Create("/", "DUMMY_BUFF", "Bur", "Burning Spirit", "1", "true", "ReplaceableTextures\\CommandButtons\\BTNIncinerate.blp", "This unit is heated up. Attack rate, movement speed and critical chance are increased.")

            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
            call thistype.DUMMY_BUFF.SetLostOnDispel(true)
            call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Orc\\Bloodlust\\BloodlustSpecial.mdl", AttachPoint.HAND_LEFT, EffectLevel.LOW)
            call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\Orc\\Bloodlust\\BloodlustSpecial.mdl", AttachPoint.HAND_RIGHT, EffectLevel.NORMAL)

        //! runtextmacro Spell_Finalize("/")
    endmethod
endstruct