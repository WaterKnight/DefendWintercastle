//! runtextmacro BaseStruct("CommandCreateItem", "COMMAND_CREATE_ITEM")
    static constant string INPUT = "-createItem"

    eventMethod Event_Chat
        local string input = params.String.GetChat()
        local User whichPlayer = params.User.GetTrigger()

        local ItemType whichType = ItemType.GetFromName(String.Word(input, 1))
        local real x = String.ToReal(String.Word(input, 2))
        local real y = String.ToReal(String.Word(input, 3))

		if (whichType == NULL) then
			call InfoEx("invalid item type")

			return
		endif

        call Item.Create(whichType, x, y)
    endmethod

    initMethod Init of Commands
        call CommandHeader.RegisterEvent(thistype.INPUT, function thistype.Event_Chat)
    endmethod
endstruct