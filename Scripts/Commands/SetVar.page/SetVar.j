//! runtextmacro BaseStruct("SetVar", "SET_VAR")
    static constant string INPUT = "-var"
    static GameCache TABLE

    static method GetVal takes string name returns string
        return thistype.TABLE.String.Get(name, "var")
    endmethod

    static method GetValDef takes string name, string inval returns string
        if thistype.TABLE.String.Contains(name, "var") then
            return thistype.GetVal(name)
        endif

        return inval
    endmethod

    static method GetValDefI takes string name, integer inval returns integer
        if thistype.TABLE.String.Contains(name, "var") then
            return String.ToInt(thistype.GetVal(name))
        endif

        return inval
    endmethod

    static method GetValDefR takes string name, real inval returns real
        if thistype.TABLE.String.Contains(name, "var") then
            return String.ToReal(thistype.GetVal(name))
        endif

        return inval
    endmethod

    eventMethod Event_Chat
        local string input = params.String.GetChat()
        local User whichPlayer = params.User.GetTrigger()

        local string name = String.Word(input, 1)
        local string val = String.Word(input, 2)

        if (name == null) then
            call DebugEx("SetVar: no name given")

            return
        endif

        call thistype.TABLE.String.Set(name, "var", val)

        call DebugEx("SetVar: value of " + name + ":" + thistype.GetVal(name))
    endmethod

    initMethod Init of Commands
        set thistype.TABLE = GameCache.Create()
        call CommandHeader.RegisterEvent(thistype.INPUT, function thistype.Event_Chat)
    endmethod
endstruct