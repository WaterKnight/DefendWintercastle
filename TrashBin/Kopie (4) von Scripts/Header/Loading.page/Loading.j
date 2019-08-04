//! runtextmacro BaseStruct("Loading", "LOADING")
    static texttag DUMMY_TEXT_TAG
    static constant real DUMMY_TEXT_TAG_SIZE = 0.1
    static unit DUMMY_UNIT
    static string array DUMMY_STRINGS
    static boolean ENDING = false
    static real PERCENT = 0.
    static constant real PERCENT_ADD = 100. / LOADING_PARTS

    static method Ending2 takes nothing returns nothing
        set thistype.ENDING = true
        call FogEnable(true)
        call FogMaskEnable(true)
        call ResetToGameCamera(0.)
        call DisplayCineFilter(false)
    endmethod

    static method Ending takes nothing returns nothing
        call DestroyTextTag(thistype.DUMMY_TEXT_TAG)
        call SetUnitAnimation(thistype.DUMMY_UNIT, "death")

        call SetCineFilterDuration(Initialization.START_DELAY - 1.)
        call SetCineFilterEndColor(255, 255, 255, 255)
        call SetCineFilterStartColor(0, 0, 0, 0)
        call SetCineFilterTexture("ReplaceableTextures\\CameraMasks\\Black_mask.blp")

        call DisplayCineFilter(true)

        call DisplayTimedTextToPlayer(GetLocalPlayer(), 0., 0., 0., "start game")
    endmethod

    static method SetPercent takes integer value returns nothing
        call SetTextTagColor(thistype.DUMMY_TEXT_TAG, 0, R2I(255. - value / 100. * 255. / 2.), 255, 255)
        call SetTextTagText(thistype.DUMMY_TEXT_TAG, I2S(value) + Char.PERCENT, thistype.DUMMY_TEXT_TAG_SIZE)
    endmethod

    static method Load takes string label, integer level returns nothing
        local integer iteration
        local string s = ""

        set thistype.DUMMY_STRINGS[level] = label

        if (level == 0) then
            set s = "init " + label + "..."
        else
            set iteration = 1

            loop
                set s = s + thistype.DUMMY_STRINGS[iteration]

                if (iteration < level) then
                    set s = s + ";"
                endif

                set iteration = iteration + 1
                exitwhen (iteration > level)
            endloop

            set s = "init " + thistype.DUMMY_STRINGS[0] + " (" + s + ")"
        endif

        set thistype.PERCENT = thistype.PERCENT + thistype.PERCENT_ADD
        //call ClearTextMessages()

        call DisplayTimedTextToPlayer(GetLocalPlayer(), 0., 0., 0., s)
        call thistype.SetPercent(R2I(thistype.PERCENT))

        call RenderGraphics()
    endmethod

    static method UpdateCam_Executed takes nothing returns nothing
        loop
            exitwhen thistype.ENDING

            call SetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK, 270., 0.)
            call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 1650., 0.)
            call SetCameraField(CAMERA_FIELD_ZOFFSET, 10000., 0.)
            call SetCameraTargetController(thistype.DUMMY_UNIT, 0., 0., false)

            call TriggerSleepAction(0.035)
        endloop
    endmethod

    static method Start takes nothing returns nothing
        local real camX = GetCameraTargetPositionX()
        local real camY = GetCameraTargetPositionY()
        local real z = 3900.

        set thistype.DUMMY_TEXT_TAG = CreateTextTag()
        set thistype.DUMMY_UNIT = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), thistype.DUMMY_UNIT_ID, 0., 0., 270.)

        call FogEnable(false)
        call FogMaskEnable(false)
        call SetCameraBounds(camX, camY, camX, camY, camX, camY, camX, camY)

        call SetCameraField(CAMERA_FIELD_FARZ, 2000., 0)
        call SetCameraField(CAMERA_FIELD_ZOFFSET, 10000., 0)
        call UnitAddAbility(thistype.DUMMY_UNIT, BJUnit.Z_ENABLER_SPELL_ID)

        call SetCameraTargetController(thistype.DUMMY_UNIT, 0., 0., false)
        call SetTextTagPos(thistype.DUMMY_TEXT_TAG, camX, camY, z)
        call SetTextTagText(thistype.DUMMY_TEXT_TAG, "", thistype.DUMMY_TEXT_TAG_SIZE)
        call SetUnitAnimationByIndex(thistype.DUMMY_UNIT, 2)
        call SetUnitX(thistype.DUMMY_UNIT, camX)
        call SetUnitY(thistype.DUMMY_UNIT, camY)
        call SetUnitFlyHeight(thistype.DUMMY_UNIT, z, 0)
        call UnitShareVision(thistype.DUMMY_UNIT, GetLocalPlayer(), true)

        call ExecuteFunc(thistype.UpdateCam_Executed.name)
    endmethod
endstruct

//! textmacro Load takes name
    call Loading.Load("$name$", 0)

    call TriggerSleepAction(0.)
//! endtextmacro