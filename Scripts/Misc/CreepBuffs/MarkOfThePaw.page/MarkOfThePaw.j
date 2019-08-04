//! runtextmacro BaseStruct("MarkOfThePaw", "MARK_OF_THE_PAW")
    static Spell THIS_SPELL

    static method AddToUnit takes Unit target returns nothing
    	call Spot.CreateEffect(target.Position.X.Get(), target.Position.Y.Get(), thistype.SPECIAL_EFFECT_PATH, EffectLevel.LOW).Destroy()

        call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, 1, thistype.DURATION)
    endmethod

    initMethod Init of CreepBuffs
    endmethod
endstruct