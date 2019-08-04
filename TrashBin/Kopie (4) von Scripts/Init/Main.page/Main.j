//! runtextmacro BaseStruct("Initialization", "INITIALIZATION")
    //! runtextmacro GetKey("KEY")
    //! runtextmacro GetKeyArray("KEY_ARRAY")
    static sound MUSIC_SOUND
    static constant real START_DELAY = 3.

    static method TriggerEvents takes nothing returns nothing
        local integer iteration = ARRAY_MIN
        local integer iteration2
        local integer priority

        loop
            exitwhen (iteration > EventPriority.ALL_COUNT)

            set priority = EventPriority.ALL[iteration]

            set iteration2 = Event.CountAtStatics(EventType.START, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)
call DebugEx(Event.GetFromStatics(EventType.START, priority, iteration2).name)
                call Event.GetFromStatics(EventType.START, priority, iteration2).Run()

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration + 1
        endloop
    endmethod

    static method Start takes nothing returns nothing
        call Loading.Ending()

        call StopSound(thistype.MUSIC_SOUND, true, false)

        set thistype.MUSIC_SOUND = null
        call PauseGame(false)
        call FogMaskEnable(false)

        call Trigger.Sleep(thistype.START_DELAY)

        call Loading.Ending2()

        call Camera.SetBounds(User.GetLocal(), -7680. + GetCameraMargin(CAMERA_MARGIN_LEFT), -7680. + GetCameraMargin(CAMERA_MARGIN_BOTTOM), 7680. - GetCameraMargin(CAMERA_MARGIN_RIGHT), 7680. - GetCameraMargin(CAMERA_MARGIN_TOP), -7680. + GetCameraMargin(CAMERA_MARGIN_LEFT), 7680. - GetCameraMargin(CAMERA_MARGIN_TOP), 7680. - GetCameraMargin(CAMERA_MARGIN_RIGHT), -7680. + GetCameraMargin(CAMERA_MARGIN_BOTTOM))

        call EnableOcclusion(true)

        //call Trigger.Sleep(1.)
call BJDebugMsg("START")
        call thistype.TriggerEvents()
    endmethod

    static method Init2 takes nothing returns nothing
        local sound dummySound

        call Trigger.Sleep(0.)

        call PauseGame(true)

            set thistype.MUSIC_SOUND = CreateSound("Sound\\Music\\mp3Music\\War2IntroMusic.mp3", false, false, false, 10, 10, "DefaultEAXOn")

            call SetSoundPitch(thistype.MUSIC_SOUND, 0.8)

            call StartSound(thistype.MUSIC_SOUND)

        call InitHeader.Init()

        call InitCommands.Init()
        call InitItems.Init()
        call InitSpeeches.Init()
        call InitSpells.Init()
        call InitUnits.Init()

        call Other.Init()
        call InitMisc.Init()

        call AI.Init()

        call thistype.Start()
    endmethod

    static method Init takes nothing returns nothing
        call Loading.Start()

        call SetMapMusic("", false, 0)

        call ExecuteFunc(thistype.Init2.name)
    endmethod
endstruct

//! inject main
//call TriggerSleepAction(0)
    //! dovjassinit

    call SetCameraBounds(-7680. + GetCameraMargin(CAMERA_MARGIN_LEFT), -7680. + GetCameraMargin(CAMERA_MARGIN_BOTTOM), 7680. - GetCameraMargin(CAMERA_MARGIN_RIGHT), 7680. - GetCameraMargin(CAMERA_MARGIN_TOP), -7680. + GetCameraMargin(CAMERA_MARGIN_LEFT), 7680. - GetCameraMargin(CAMERA_MARGIN_TOP), 7680. - GetCameraMargin(CAMERA_MARGIN_RIGHT), -7680. + GetCameraMargin(CAMERA_MARGIN_BOTTOM))
    call SetDayNightModels("Environment\\DNC\\DNCLordaeron\\DNCLordaeronTerrain\\DNCLordaeronTerrain.mdl", "Environment\\DNC\\DNCLordaeron\\DNCLordaeronUnit\\DNCLordaeronUnit.mdl")
    call NewSoundEnvironment("Default")
    call SetAmbientDaySound("IceCrownDay")
    call SetAmbientNightSound("IceCrownNight")
    call SetMapMusic("Music", true, 0)
    call CreateRegions()
    call CreateCameras()
    call CreateAllDestructables()
    call CreateAllItems()
    call CreateAllUnits()
    call CreateRegions()
    call InitBlizzard()

    call Code.Run(function Initialization.Init)
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