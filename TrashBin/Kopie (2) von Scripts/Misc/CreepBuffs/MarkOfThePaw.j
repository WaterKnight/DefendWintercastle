//! runtextmacro BaseStruct("MarkOfThePaw", "MARK_OF_THE_PAW")
    static constant real ATTACK_RATE_INCREMENT = 1.
    static Buff DUMMY_BUFF
    static constant real DURATION = 60.
    static constant string SPECIAL_EFFECT_PATH = "Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl"

    static Spell THIS_SPELL

    static method Event_BuffLose takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        call target.Attack.Speed.BonusA.Subtract(thistype.ATTACK_RATE_INCREMENT)
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        call Spot.CreateEffect(target.Position.X.Get(), target.Position.Y.Get(), thistype.SPECIAL_EFFECT_PATH, EffectLevel.LOW).Destroy()

        call target.Attack.Speed.BonusA.Add(thistype.ATTACK_RATE_INCREMENT)
    endmethod

    static method AddToUnit takes Unit target returns nothing
        call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, 1, thistype.DURATION)
    endmethod

    static method Init takes nothing returns nothing
        //! runtextmacro Buff_Create("/", "DUMMY_BUFF", "MOP", "Mark Of The Paw", "1", "false", "ReplaceableTextures\\CommandButtons\\BTNBattleRoar.blp", "This unit carries the 'Mark of the Paw' and has an increased attack rate.")

        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.DUMMY_BUFF.SetLostOnDispel(true)
        call thistype.DUMMY_BUFF.TargetEffects.Add("Abilities\\Spells\\NightElf\\BattleRoar\\RoarTarget.mdl", AttachPoint.OVERHEAD, EffectLevel.LOW)
    endmethod
endstruct