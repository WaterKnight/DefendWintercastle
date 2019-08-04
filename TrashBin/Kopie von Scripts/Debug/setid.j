scope sel initializer init
    globals
        private trigger thisTrig=null
    endglobals
globals
integer ID=0
endglobals

    function Trig_Unbezeichneter_Ausl__ser_006_Func001A takes nothing returns nothing
        set ID = Unit.GetFromSelf(GetEnumUnit()).Id.Get()
        call BJDebugMsg("set ID to "+I2S(ID))
    endfunction

    function Trig_Unbezeichneter_Ausl__ser_006_Actions takes nothing returns nothing
        call ForGroupBJ( GetUnitsSelectedAll(Player(0)), function Trig_Unbezeichneter_Ausl__ser_006_Func001A )
    endfunction

    private function init takes nothing returns nothing
        set thisTrig = CreateTrigger(  )
        call TriggerRegisterPlayerEventEndCinematic( thisTrig, Player(0) )
        call TriggerAddAction( thisTrig, function Trig_Unbezeichneter_Ausl__ser_006_Actions )
    endfunction
endscope