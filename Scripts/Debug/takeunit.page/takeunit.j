scope takeunit initializer init
    globals
        private trigger thisTrig=null
    endglobals

    function Trig_takeunit_Enum takes nothing returns nothing
        call Unit.GetFromSelf(GetEnumUnit()).Owner.Set(User.GetFromSelf(GetTriggerPlayer()))
    endfunction

    function Trig_takeunit_Actions takes nothing returns nothing
        call ForGroupBJ( GetUnitsSelectedAll(Player(0)), function Trig_takeunit_Enum )
    endfunction

    private function init takes nothing returns nothing
        set thisTrig = CreateTrigger(  )
        call TriggerRegisterPlayerChatEvent( thisTrig, Player(0), "-take", true )
        call TriggerAddAction( thisTrig, function Trig_takeunit_Actions )
    endfunction
endscope