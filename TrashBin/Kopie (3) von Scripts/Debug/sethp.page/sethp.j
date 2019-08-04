scope sethp initializer Init
    globals
        private trigger thisTrig=null
    endglobals
    private function Actions takes nothing returns nothing
        local real value = S2R(SubStringBJ(GetEventPlayerChatString(), 8, StringLength(GetEventPlayerChatString())) )

        if (value > 0.5) then
            call Difficulty.SELECTED.SetLifeFactor(value)
        endif
    endfunction

    //===========================================================================
    private function Init takes nothing returns nothing
        set thisTrig = CreateTrigger(  )
        call TriggerRegisterPlayerChatEvent( thisTrig, Player(0), "-sethp ", false )
        call TriggerAddAction( thisTrig, function Actions )
    endfunction
endscope