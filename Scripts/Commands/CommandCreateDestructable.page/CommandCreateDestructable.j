//! runtextmacro BaseStruct("CommandCreateDestructable", "COMMAND_CREATE_DESTRUCTABLE")
    static constant string INPUT = "-createDestructable"

    eventMethod Event_Chat
        local string input = params.String.GetChat()
        local User whichPlayer = params.User.GetTrigger()

        local DestructableType whichType = DestructableType.GetFromName(String.Word(input, 1))
        local real x = String.ToReal(String.Word(input, 2))
        local real y = String.ToReal(String.Word(input, 3))

        local real z = String.ToRealWithInvalid(String.Word(input, 4), Spot.GetHeight(x, y))
        local real angle = String.ToRealWithInvalid(String.Word(input, 5), 1.)
        local real scale = String.ToRealWithInvalid(String.Word(input, 6), 1.)
        local integer variation = String.ToIntWithInvalid(String.Word(input, 3), -1)

		if (whichType == NULL) then
			call InfoEx("invalid destructable type")

			return
		endif

        call Destructable.Create(whichType, x, y, z, angle, scale, variation)
    endmethod

    initMethod Init of Commands
        call CommandHeader.RegisterEvent(thistype.INPUT, function thistype.Event_Chat)
    endmethod
endstruct