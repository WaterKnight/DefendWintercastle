//! runtextmacro BaseStruct("CommandCreateUnit", "COMMAND_CREATE_UNIT")
    static constant string INPUT = "-create"

    eventMethod Event_Chat
        local string input = params.String.GetChat()
        local User whichPlayer = params.User.GetTrigger()

        local UnitType whichType = UnitType.GetFromName(String.Word(input, 1))
        local User owner
        local string input1 = String.Word(input, 2)
        local real x = String.ToReal(String.Word(input, 3))
        local real y = String.ToReal(String.Word(input, 4))

        if (input1 == null) then
            set owner = whichPlayer
        else
            set owner = User.GetFromNativeIndex(String.ToInt(input1))
        endif

		if (whichType == NULL) then
			call InfoEx("invalid unit type")

			return
		endif

        call Unit.Create(whichType, owner, x, y, UNIT.Facing.STANDARD)
    endmethod

    initMethod Init of Commands
        call CommandHeader.RegisterEvent(thistype.INPUT, function thistype.Event_Chat)
    endmethod
endstruct