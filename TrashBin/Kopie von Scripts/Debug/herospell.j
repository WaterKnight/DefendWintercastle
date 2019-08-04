scope herospell initializer Init
    globals
        private trigger thisTrig=null
    endglobals
    private function Actions takes nothing returns nothing
        local string input = GetEventPlayerChatString()
        local User this = USER.Event.Native.GetTrigger()

        if (SubString(input, 0, 3) == "-r ") then
            call this.Hero.Get().Abilities.Remove(Spell.GetFromName(SubString(input, 3, String.Length(input))))
        elseif (SubString(input, 0, 3) == "-a ") then
            call this.Hero.Get().Abilities.Add(Spell.GetFromName(SubString(input, 3, String.Length(input))))
        endif
    endfunction

    //===========================================================================
    private function Init takes nothing returns nothing
        set thisTrig = CreateTrigger(  )
        call TriggerRegisterPlayerChatEvent( thisTrig, Player(0), "-a ", false )
        call TriggerRegisterPlayerChatEvent( thisTrig, Player(0), "-r ", false )
        call TriggerAddAction( thisTrig, function Actions )
    endfunction
endscope