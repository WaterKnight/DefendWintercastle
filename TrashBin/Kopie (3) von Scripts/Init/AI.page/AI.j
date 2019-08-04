//! runtextmacro BaseStruct("AI", "A_I")
    static method Init takes nothing returns nothing
        //! runtextmacro Load("AI")
        call AICastSpell.Init()

        //! runtextmacro Load("AI-2")
        call AIBoost.Init()
        call AIBouncyBomb.Init()
        call AIBurningSpirit.Init()
        call AIChaosBall.Init()
        call AIHeal.Init()
        call AIHealExplosion.Init()
        call AIKnockout.Init()
        call AIMedipack.Init()
        call AIPurge.Init()
    endmethod
endstruct