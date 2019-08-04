//! runtextmacro BaseStruct("CommandRefreshAbility", "COMMAND_REFRESH_ABILITY")
    static constant string INPUT = "-refresh"
    static constant string INPUT_NO_CD = "-nocd"
    static Event NO_CD_CAST_EVENT

    static boolean NO_CD = false
    static Spell WHICH_SPELL

    eventMethod Event_NoCd_Cast
        call params.Unit.GetTrigger().Abilities.Refresh(params.Spell.GetTrigger())
    endmethod

    enumMethod NoCd_Chat_Enum
        call UNIT.Event.Native.GetEnum().Abilities.RefreshAll()
    endmethod

    eventMethod Event_NoCd_Chat
        local string input = params.String.GetChat()
        local User whichPlayer = params.User.GetTrigger()

        set thistype.NO_CD = not thistype.NO_CD

        if thistype.NO_CD then
            call thistype.NO_CD_CAST_EVENT.AddToStatics()
        else
            call thistype.NO_CD_CAST_EVENT.RemoveFromStatics()
        endif

        call UnitList.WORLD.Do(function thistype.NoCd_Chat_Enum)
    endmethod

    enumMethod Enum
        if (thistype.WHICH_SPELL == NULL) then
            call UNIT.Event.Native.GetEnum().Abilities.RefreshAll()
        else
            call UNIT.Event.Native.GetEnum().Abilities.Refresh(thistype.WHICH_SPELL)
        endif
    endmethod

    eventMethod Event_Chat
        local string input = params.String.GetChat()
        local User whichPlayer = params.User.GetTrigger()

		local string whichSpellName = String.Word(input, 1)

		if (whichSpellName == null) then
			call InfoEx("no spell given")

			return
		endif

        local Spell whichSpell = Spell.GetFromName(whichSpellName)

        if (whichSpell == NULL) then
            if (String.Word(input, 1) != "all") then
                call InfoEx("invalid spell")

                return
            endif
        endif

        set thistype.WHICH_SPELL = whichSpell

        call whichPlayer.EnumSelectedUnits(function thistype.Enum)
    endmethod

    initMethod Init of Commands
        set thistype.NO_CD_CAST_EVENT = Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_NoCd_Cast)
        call CommandHeader.RegisterEvent(thistype.INPUT, function thistype.Event_Chat)
        call CommandHeader.RegisterEvent(thistype.INPUT_NO_CD, function thistype.Event_NoCd_Chat)
    endmethod
endstruct