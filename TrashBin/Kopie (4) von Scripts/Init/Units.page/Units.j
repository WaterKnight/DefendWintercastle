//! runtextmacro BaseStruct("InitUnits", "INIT_UNITS")
    static method Init takes nothing returns nothing
        //! runtextmacro Load("Units")
        call Pengu.Init()
        call Library.Init()
        call Sebastian.Init()
    endmethod
endstruct