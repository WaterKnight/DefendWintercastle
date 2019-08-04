struct memtableteststruct
    //! runtextmacro GetKeyArray("KEY_ARRAY")
endstruct

scope memtabletest initializer Init
    globals
        private trigger thisTrig=null
    endglobals
    private function Actions takes nothing returns nothing
        local integer i=Memory.IntegerKeys.Table.STARTED
        local integer key = memtableteststruct.KEY_ARRAY
        local integer missionKey = 40000
        local integer val = S2I(SubString(GetEventPlayerChatString(), 5, StringLength(GetEventPlayerChatString())))

        if (SubString(GetEventPlayerChatString(), 0, 4) == "-add") then
        call BJDebugMsg("add")
            call Memory.IntegerKeys.Table.AddInteger(missionKey, key, val)
        else
        call BJDebugMsg("rem")
            call Memory.IntegerKeys.Table.RemoveInteger(missionKey, key, val)
        endif

        call BJDebugMsg("count "+I2S(Memory.IntegerKeys.Table.CountIntegers(missionKey, key)))
        loop
            exitwhen (i>10)
            call BJDebugMsg(I2S(i)+" --> "+I2S(Memory.IntegerKeys.Table.GetInteger(missionKey, key, i)))
            set i=i+1
        endloop
    endfunction

    //===========================================================================
    private function Init takes nothing returns nothing
        set thisTrig = CreateTrigger(  )
        call TriggerRegisterPlayerChatEvent( thisTrig, Player(0), "-add ", false )
        call TriggerRegisterPlayerChatEvent( thisTrig, Player(0), "-rem ", false )
        call TriggerAddAction( thisTrig, function Actions )
    endfunction
endscope