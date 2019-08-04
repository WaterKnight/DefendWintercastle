scope bla initializer Init
    function Trig_Unbezeichneter_Ausl__ser_001_Func001A takes nothing returns nothing
        //call Unit.GetFromSelf(GetEnumUnit()).Mana.Subtract(50.)
        call BJDebugMsg(OrderId2StringBJ(GetUnitCurrentOrder(GetEnumUnit())) )
        call Unit.Create(Unit.GetFromSelf(GetEnumUnit()).Type.Get(), User.ALL[0], 0., 0., 0.)
    endfunction

    function Trig_Unbezeichneter_Ausl__ser_001_Actions takes nothing returns nothing
        local integer iteration = 15
//call BJDebugMsg(I2S(Initialization.KEY))
//call BJDebugMsg(I2S(Initialization.KEY_ARRAY))
        call ForGroup( GetUnitsSelectedAll(Player(0)), function Trig_Unbezeichneter_Ausl__ser_001_Func001A )
    endfunction

    private function Init takes nothing returns nothing
        set gg_trg_Unbezeichneter_Ausl__ser_001 = CreateTrigger(  )
        call TriggerRegisterPlayerEvent( gg_trg_Unbezeichneter_Ausl__ser_001, Player(0), EVENT_PLAYER_END_CINEMATIC )
        call TriggerAddAction( gg_trg_Unbezeichneter_Ausl__ser_001, function Trig_Unbezeichneter_Ausl__ser_001_Actions )
    endfunction
endscope