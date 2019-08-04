//! runtextmacro BaseStruct("InitCommands", "INIT_COMMANDS")
    static method Init takes nothing returns nothing
        //! runtextmacro Load("Commands")
        call CharacterSpeech.Init()
    endmethod
endstruct