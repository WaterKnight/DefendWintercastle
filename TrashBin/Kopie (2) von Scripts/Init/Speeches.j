//! runtextmacro BaseStruct("InitSpeeches", "INIT_SPEECHES")
    static method Init takes nothing returns nothing
        //! runtextmacro Load("Speeches")
        call AxeFighter.Init()
        call Balduir.Init()
    endmethod
endstruct