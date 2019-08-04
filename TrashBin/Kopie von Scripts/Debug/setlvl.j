scope setlvl initializer Init
    globals
        private trigger thisTrig=null
    endglobals
    private function Actions takes nothing returns nothing
        call Level.ALL[S2I(SubStringBJ(GetEventPlayerChatString(), 4, StringLength(GetEventPlayerChatString())) )].Start()
    endfunction

    //===========================================================================
    private function Init takes nothing returns nothing
        set thisTrig = CreateTrigger(  )
        call TriggerRegisterPlayerChatEvent( thisTrig, Player(0), "-l ", false )
        call TriggerAddAction( thisTrig, function Actions )
    endfunction
endscope