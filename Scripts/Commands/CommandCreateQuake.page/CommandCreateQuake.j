//! runtextmacro BaseStruct("CommandCreateQuake", "COMMAND_CREATE_QUAKE")
    static constant string INPUT = "-quake"
    static constant string INPUT_SHAKE = "-shake"

	eventMethod Event_Shake_Chat
        local string input = params.String.GetChat()
        local User whichPlayer = params.User.GetTrigger()
        
		local real power = String.ToReal(String.Word(input, 1))
		local string inputTargetPlayer = String.Word(input, 2)
		local real duration = String.ToReal(String.Word(input, 3))
		
		local User targetPlayer
		
		if (inputTargetPlayer == null) then
            set targetPlayer = whichPlayer
        else
            set targetPlayer = User.GetFromNativeIndex(String.ToInt(inputTargetPlayer)) 
        endif
		if (power == 0.) then
			set power = 10.
		endif
		if (duration == 0.) then
			set duration = 5.
		endif
		
		if (targetPlayer != NULL) then
			call CAMERA.Shake.Add(whichPlayer, power, duration)
		endif
	endmethod

    eventMethod Event_Chat
        local string input = params.String.GetChat()
        local User whichPlayer = params.User.GetTrigger()

        local real x = String.ToReal(String.Word(input, 1))
        local real y = String.ToReal(String.Word(input, 2))
        local real z = String.ToReal(String.Word(input, 3))

		local real powerMax = String.ToReal(String.Word(input, 4))
		local real powerMin = String.ToReal(String.Word(input, 5))

		local real falloff = String.ToReal(String.Word(input, 6))
		local real speed = String.ToReal(String.Word(input, 7))

		if (powerMax == 0.) then
			set powerMax = 1000.
		endif
		if (falloff == 0.) then
			set falloff = 99999.
		endif
		if (speed == 0.) then
			set speed = 1000.
		endif

        call CAMERA.Seismic.Create(x, y, z, powerMax, powerMin, falloff, speed)
    endmethod

    initMethod Init of Commands
        call CommandHeader.RegisterEvent(thistype.INPUT, function thistype.Event_Chat)
        call CommandHeader.RegisterEvent(thistype.INPUT_SHAKE, function thistype.Event_Shake_Chat)
    endmethod
endstruct