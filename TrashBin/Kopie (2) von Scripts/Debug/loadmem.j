scope loadmem initializer Init
    globals
        private trigger thisTrig=null
    endglobals

    private function Actions takes nothing returns nothing
        local string val = GetEventPlayerChatString()

        local integer keyStart = String.Find(val, ";", 0)
call BJDebugMsg("load "+String.Sub(val, 5, keyStart - 1))
call BJDebugMsg("loadB "+String.Sub(val, keyStart+1, StringLength(val)-1))
        call BJDebugMsg(I2S(Memory.IntegerKeys.GetInteger(S2I(String.Sub(val, 0, keyStart - 2)), S2I(String.Sub(val, keyStart, StringLength(val))))))
    endfunction

    //===========================================================================
    private function Init takes nothing returns nothing
        set thisTrig = CreateTrigger(  )
        call TriggerRegisterPlayerChatEvent( thisTrig, Player(0), "-get ", false )
        call TriggerAddAction( thisTrig, function Actions )
    endfunction
endscope