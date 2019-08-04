//! runtextmacro BaseStruct("Other", "OTHER")
    static method Init takes nothing returns nothing
        //! runtextmacro Load("Other")
        call Game.EnableTimeOfDay(false)
        call Game.FloatState.Set(GAME_STATE_TIME_OF_DAY, 12.)
        call User.SPAWN.State.Set(PLAYER_STATE_GIVES_BOUNTY, 1)
    endmethod
endstruct