scope rpgcam initializer Init
    globals
        private trigger thisTrig=null
    endglobals
    globals
        boolean RPG_CAM_ON = false
        real RPG_CAM_TIME
    endglobals

    private function Actions takes nothing returns nothing
        if (RPG_CAM_ON) then
            if (GetEventPlayerChatString()=="-rpgcam") then
                set RPG_CAM_ON = false
            endif
        else
            set RPG_CAM_ON = true
            set RPG_CAM_TIME = S2R(SubStringBJ(GetEventPlayerChatString(), 9, StringLength(GetEventPlayerChatString())) )
        endif
    endfunction

    //===========================================================================
    private function Init takes nothing returns nothing
        set thisTrig = CreateTrigger(  )
        call TriggerRegisterPlayerChatEvent( thisTrig, Player(0), "-rpgcam ", false )
        call TriggerAddAction( thisTrig, function Actions )
    endfunction
endscope