//! runtextmacro BaseStruct("Initialization", "INITIALIZATION")
    //! runtextmacro GetKey("KEY")
    //! runtextmacro GetKeyArray("KEY_ARRAY")
    static sound MUSIC_SOUND
    static constant real START_DELAY = 3.

    static method TriggerEvents takes nothing returns nothing
        local EventResponse params = EventResponse.Create(EventResponse.STATIC_SUBJECT_ID)

		local integer iteration = ARRAY_MIN

        loop
            exitwhen (iteration > EventPriority.ALL_COUNT)

            local EventPriority priority = EventPriority.ALL[iteration]

            local integer iteration2 = Event.CountAtStatics(EventType.START, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call Event.GetFromStatics(EventType.START, priority, iteration2).Run(params)

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration + 1
        endloop

        call params.Destroy()
    endmethod

    static method Start takes nothing returns nothing
        call InfoEx("start game")

        call Loading.Ending()

        call StopSound(thistype.MUSIC_SOUND, true, false)

        set thistype.MUSIC_SOUND = null

		call Music.Create("Music\\Main.wav", 0).Play()

        call FogMaskEnable(false)

        call SetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK, 315., 0.)
        call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 1650., 0.)
        call SetCameraField(CAMERA_FIELD_ZOFFSET, 0., 0.)

        call Trigger.Sleep(thistype.START_DELAY)

        call Loading.Ending2()

        call Camera.SetBounds(User.GetLocal(), -7680. + GetCameraMargin(CAMERA_MARGIN_LEFT), -7680. + GetCameraMargin(CAMERA_MARGIN_BOTTOM), 7680. - GetCameraMargin(CAMERA_MARGIN_RIGHT), 7680. - GetCameraMargin(CAMERA_MARGIN_TOP), -7680. + GetCameraMargin(CAMERA_MARGIN_LEFT), 7680. - GetCameraMargin(CAMERA_MARGIN_TOP), 7680. - GetCameraMargin(CAMERA_MARGIN_RIGHT), -7680. + GetCameraMargin(CAMERA_MARGIN_BOTTOM))

        call EnableOcclusion(true)

        //call TriggerSyncReady()

        call Code.Run(function thistype.TriggerEvents)
    endmethod

    static method EndLoading takes nothing returns boolean
    	call InfoEx("ingame loading finished")

        call ObjThread.PrintErrors()

        call Code.Run(function thistype.Start)

		return true
    endmethod

    static method Other takes nothing returns boolean
       	//call Game.EnableTimeOfDay(false)
        call Game.FloatState.Set(GAME_STATE_TIME_OF_DAY, 12.)
        //call User.SPAWN.State.Set(PLAYER_STATE_GIVES_BOUNTY, 1)

		return true
    endmethod

	static method LoadHeader takes nothing returns boolean
		call InfoEx("load header")

		return true
	endmethod

	static method leave takes nothing returns nothing
		local player p = GetTriggerPlayer()
		
		local string s = "Player "+I2S(GetPlayerId(p))+" (" + GetPlayerName(p) + ") has left the game"
		
		call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 999, s)
		call InfoEx(s)
	endmethod

	static method leaveSetup takes nothing returns nothing
    	local trigger t = CreateTrigger()
    	local integer i = 0
    
    	call TriggerAddAction(t, function thistype.leave)
    
    	loop
    		exitwhen (i>15)
    	
    		call TriggerRegisterPlayerEvent(t, Player(i), EVENT_PLAYER_LEAVE)
    		
    		set i=i+1
    	endloop
	endmethod

    static method ProcessLoading takes nothing returns nothing
		call thistype.leaveSetup()
    
    	call InfoEx("process ingame loading...")

		call Loading.Init()

	//Header
			call Loading.QueueCode(function thistype.LoadHeader)

	        //! runtextmacro Load("Header")

	        call Loading.QueueCode(function EffectLevel.Init)

			//! runtextmacro Load("Header_Event")

	        //! runtextmacro Load("Header_2")

	        //! runtextmacro Load("Header_Group")

	        call Trigger.RunObjectInits(Trigger.INIT_NORMAL_KEY_ARRAY)

	        //! runtextmacro Load("Header_3")

	        //! runtextmacro Load("Header_4")

	        //! runtextmacro Load("Header_5")
//


	        //! runtextmacro Load("Header_6")

	        //! runtextmacro Load("Header_7")



	        //! runtextmacro Load("Header_8")
//
	        call Trigger.RunObjectInits(LightningType.INIT_KEY_ARRAY)
	        call Trigger.RunObjectInits(WeatherType.INIT_KEY_ARRAY)
	        call Trigger.RunObjectInits(UbersplatType.INIT_KEY_ARRAY)
	        call Trigger.RunObjectInits(TileType.INIT_KEY_ARRAY)
	        call Trigger.RunObjectInits(SoundType.INIT_KEY_ARRAY)

			call Trigger.RunObjectInits(Buff.INIT_KEY_ARRAY)
//
	        call Trigger.RunObjectInits(DestructableType.INIT_KEY_ARRAY)
//
	        call Trigger.RunObjectInits(Spell.INIT_KEY_ARRAY)

//
        	call Trigger.RunObjectInits(ItemType.INIT_KEY_ARRAY)
	        call Trigger.RunObjectInits(UnitType.INIT_KEY_ARRAY)
//
	        //! runtextmacro Load("Header_Buffs")
	//Commands
	        //! runtextmacro Load("Commands")
	//Items
	        //! runtextmacro Load("Items_Misc")

	        //! runtextmacro Load("Items_Act1")

	        //! runtextmacro Load("Items_Act2")

	        //! runtextmacro Load("Items_Act3")
	//Speeches
	        //! runtextmacro Load("Speeches")
	//Spells
			//! runtextmacro Load("Spells_Header")

	        //! runtextmacro Load("Spells_Misc")

	        //! runtextmacro Load("Spells_Act1")

	        //! runtextmacro Load("Spells_Act2")

	        //! runtextmacro Load("Spells_Hero")

	        //! runtextmacro Load("Spells_Artifacts")

	        //! runtextmacro Load("Spells_Purchasable")
	        //! runtextmacro Load("Spells_Elemental")

	        //! runtextmacro Load("Spells_Grant_Elementals")
	//Units
	        //! runtextmacro Load("Units")

	//Other
	        //! runtextmacro Load("Other")

	        call Loading.QueueCode(function thistype.Other)

	        //! runtextmacro Load("CreepBuffs")

	        //! runtextmacro Load("Misc")

	        //! runtextmacro Load("Misc_2")

	        //! runtextmacro Load("Misc_Level")

	        //! runtextmacro Load("Misc_3")

	        //! runtextmacro Load("Misc_4")

	        //! runtextmacro Load("Misc_5")
	//AI
	        //! runtextmacro Load("AI_Header")

	        //! runtextmacro Load("AI_Spells")

	        //! runtextmacro Load("AI_Misc")
	//Preplaced
	        //! runtextmacro Load("Preplaced")

        call Loading.QueueCode(function thistype.EndLoading)

        call Loading.ExecQueue()
    endmethod

    static method StartLoading takes nothing returns nothing
    call InfoEx("start loading")
        call Loading.Start()

        call SetMapMusic("", false, 0)

        call TriggerSleepAction(0.)

        set thistype.MUSIC_SOUND = CreateSound("Sound\\Music\\mp3Music\\War2IntroMusic.mp3", false, false, false, 10, 10, "DefaultEAXOn")

        call SetSoundPitch(thistype.MUSIC_SOUND, 0.8)

        call StartSound(thistype.MUSIC_SOUND)

        call Code.Run(function thistype.ProcessLoading)
    endmethod
endstruct

//! inject main
    //call InitFuncs.customInit()

    //! dovjassinit

    call SetCameraBounds(-7680. + GetCameraMargin(CAMERA_MARGIN_LEFT), -7680. + GetCameraMargin(CAMERA_MARGIN_BOTTOM), 7680. - GetCameraMargin(CAMERA_MARGIN_RIGHT), 7680. - GetCameraMargin(CAMERA_MARGIN_TOP), -7680. + GetCameraMargin(CAMERA_MARGIN_LEFT), 7680. - GetCameraMargin(CAMERA_MARGIN_TOP), 7680. - GetCameraMargin(CAMERA_MARGIN_RIGHT), -7680. + GetCameraMargin(CAMERA_MARGIN_BOTTOM))
    call SetDayNightModels("UI\\LightEnvTerrain.mdx", "UI\\LightEnvUnit.mdx")
    call NewSoundEnvironment("Default")
    call SetMapMusic("Music", true, 0)
    call CreateRegions()
    call CreateCameras()
    call CreateAllDestructables()
    call CreateAllItems()
    //call CreateAllUnits()

    call Code.Run(function preplaced.initRects)

    call Code.Run(function preplaced.initUnits)

	//call IncStack(Code.GetId(function Initialization.Other))
	//call IncStack(Code.GetId(function Initialization.TriggerEvents))

    call Code.Run(function Initialization.StartLoading)
//! endinject

function InitPlayerSlots takes nothing returns nothing
    local integer iteration = User.MAX_HUMAN_INDEX
    local player specificPlayer

    call SetPlayers(iteration + 2)
    call SetTeams(2)

    loop
        exitwhen (iteration < 0)

        set specificPlayer = Player(iteration)

        call SetPlayerController(specificPlayer, MAP_CONTROL_USER)
        call SetPlayerRacePreference(specificPlayer, RACE_PREF_HUMAN)
        call SetPlayerRaceSelectable(specificPlayer, false)
        call SetPlayerTeam(specificPlayer, 0)

        set iteration = iteration - 1
    endloop

    set specificPlayer = Player(7)

    call SetPlayerColor(specificPlayer, PLAYER_COLOR_PINK)
    call SetPlayerController(specificPlayer, MAP_CONTROL_COMPUTER)
    call SetPlayerRacePreference(specificPlayer, RACE_PREF_HUMAN)
    call SetPlayerRaceSelectable(specificPlayer, false)
    call SetPlayerTeam(specificPlayer, 1)

    set specificPlayer = Player(11)

    call SetPlayerColor(specificPlayer, PLAYER_COLOR_BROWN)
    call SetPlayerController(specificPlayer, MAP_CONTROL_COMPUTER)
    call SetPlayerRacePreference(specificPlayer, RACE_PREF_ORC)
    call SetPlayerRaceSelectable(specificPlayer, false)
    call SetPlayerTeam(specificPlayer, 1)

    set specificPlayer = null
endfunction

//! inject config
    call SetGamePlacement(MAP_PLACEMENT_USE_MAP_SETTINGS)
    call SetMapDescription("blub")
    call SetMapName("Defend Wintercastle")
    //call PlayMusic("Sound\\Music\\mp3Music\\PH1.mp3")

    call InitPlayerSlots()
//! endinject