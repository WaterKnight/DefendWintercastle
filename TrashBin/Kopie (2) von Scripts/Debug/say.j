scope say initializer init
    globals
        private trigger thisTrig=null
    endglobals
function Trig_Unbezeichneter_Ausl__ser_002_Actions takes nothing returns nothing
call Game.DisplayTextTimed( User.ANY, String.Color.Gradient(GetEventPlayerChatString(), String.Color.RED, String.Color.GOLD), 3. )
    call Game.DisplayTextTimed( User.GetFromSelf(GetTriggerPlayer()), SubStringBJ(GetEventPlayerChatString(), 5, StringLength(GetEventPlayerChatString())), 3. )
endfunction

//===========================================================================
private function init takes nothing returns nothing
    set thisTrig = CreateTrigger(  )
    call TriggerRegisterPlayerChatEvent( thisTrig, Player(0), "say ", false )
    call TriggerAddAction( thisTrig, function Trig_Unbezeichneter_Ausl__ser_002_Actions )
endfunction
endscope
