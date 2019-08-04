//! runtextmacro Folder("OptionsBoard")
    //! runtextmacro Struct("CameraSmoothing")
        static integer ROW
        static integer VALUE_INDEX
        static constant integer VALUE_MAX_INDEX = ARRAY_MIN + 8
        static real array VALUES

        static method Update takes nothing returns nothing
            local string s = Real.ToStringWithDecimals(thistype.VALUES[thistype.VALUE_INDEX], 1)

            set OptionsBoard.SELECTABLE_ROWS_VALUE[OptionsBoard.SELECTABLE_ROWS_INDIZES[thistype.ROW]] = s

            if (OptionsBoard.SELECTED_ROW == thistype.ROW) then
                set s = String.If((thistype.VALUE_INDEX > ARRAY_MIN), String.Color.Do("<<< ", String.Color.GOLD)) + String.Color.Do(s, String.Color.GREEN) + String.If((thistype.VALUE_INDEX < thistype.VALUE_MAX_INDEX), String.Color.Do(" >>>", String.Color.GOLD))
            endif

            call OptionsBoard.THIS_BOARD.SetValue(thistype.ROW, OptionsBoard.VALUE_COLUMN, s)

            call Camera.SetSmoothing(User.GetLocal(), thistype.VALUES[thistype.VALUE_INDEX])
        endmethod

        static method Event_Left takes nothing returns nothing
            if (thistype.VALUE_INDEX > ARRAY_MIN) then
                set thistype.VALUE_INDEX = thistype.VALUE_INDEX - 1
            endif

            call thistype.Update()
        endmethod

        static method Event_Right takes nothing returns nothing
            if (thistype.VALUE_INDEX < thistype.VALUE_MAX_INDEX) then
                set thistype.VALUE_INDEX = thistype.VALUE_INDEX + 1
            endif

            call thistype.Update()
        endmethod

        static method Init takes nothing returns nothing
            set thistype.VALUE_INDEX = ARRAY_MIN + 3
            set thistype.VALUES[ARRAY_MIN + 0] = 0.
            set thistype.VALUES[ARRAY_MIN + 1] = 0.5
            set thistype.VALUES[ARRAY_MIN + 2] = 1.
            set thistype.VALUES[ARRAY_MIN + 3] = 1.5
            set thistype.VALUES[ARRAY_MIN + 4] = 2.
            set thistype.VALUES[ARRAY_MIN + 5] = 2.5
            set thistype.VALUES[ARRAY_MIN + 6] = 3.
            set thistype.VALUES[ARRAY_MIN + 7] = 3.5
            set thistype.VALUES[ARRAY_MIN + 8] = 4.

            call thistype.Update()
        endmethod
    endstruct

    //! runtextmacro Struct("CameraZoom")
        static integer ROW
        static integer VALUE_INDEX
        static constant integer VALUE_MAX_INDEX = ARRAY_MIN + 11
        static integer array VALUES

        static method Update takes nothing returns nothing
            local string s = Integer.ToString(thistype.VALUES[thistype.VALUE_INDEX])

            set OptionsBoard.SELECTABLE_ROWS_VALUE[OptionsBoard.SELECTABLE_ROWS_INDIZES[thistype.ROW]] = s

            if (OptionsBoard.SELECTED_ROW == thistype.ROW) then
                set s = String.If((thistype.VALUE_INDEX > ARRAY_MIN), String.Color.Do("<<< ", String.Color.GOLD)) + String.Color.Do(s, String.Color.GREEN) + String.If((thistype.VALUE_INDEX < thistype.VALUE_MAX_INDEX), String.Color.Do(" >>>", String.Color.GOLD))
            endif

            call OptionsBoard.THIS_BOARD.SetValue(thistype.ROW, OptionsBoard.VALUE_COLUMN, s)

            set Zoom.VALUE = thistype.VALUES[thistype.VALUE_INDEX]
        endmethod

        static method Event_Left takes nothing returns nothing
            if (thistype.VALUE_INDEX > ARRAY_MIN) then
                set thistype.VALUE_INDEX = thistype.VALUE_INDEX - 1
            else
                if (USER.KeyEvent.LeftArrow.TRIGGER_INTERVAL_WEIGHT == 1.) then
                    call Game.DisplayTextTimed(USER.Event.GetTrigger(), String.Color.Do("Penguin perspective is not supported", String.Color.GOLD), 10.)
                endif
            endif

            call thistype.Update()
        endmethod

        static method Event_Right takes nothing returns nothing
            if (thistype.VALUE_INDEX < thistype.VALUE_MAX_INDEX) then
                set thistype.VALUE_INDEX = thistype.VALUE_INDEX + 1
            endif

            call thistype.Update()
        endmethod

        static method Init takes nothing returns nothing
            set thistype.VALUE_INDEX = ARRAY_MIN + 8
            set thistype.VALUES[ARRAY_MIN] = 1350
            set thistype.VALUES[ARRAY_MIN + 1] = 1450
            set thistype.VALUES[ARRAY_MIN + 2] = 1550
            set thistype.VALUES[ARRAY_MIN + 3] = 1650
            set thistype.VALUES[ARRAY_MIN + 4] = 1750
            set thistype.VALUES[ARRAY_MIN + 5] = 1850
            set thistype.VALUES[ARRAY_MIN + 6] = 1950
            set thistype.VALUES[ARRAY_MIN + 7] = 2050
            set thistype.VALUES[ARRAY_MIN + 8] = 2150
            set thistype.VALUES[ARRAY_MIN + 9] = 2250
            set thistype.VALUES[ARRAY_MIN + 10] = 2350
            set thistype.VALUES[ARRAY_MIN + 11] = 2450

            call thistype.Update()
        endmethod
    endstruct

    //! runtextmacro Struct("EffectLevel")
        static integer ROW

        static method Update takes nothing returns nothing
            local string s = EffectLevel.CURRENT.GetName()

            set OptionsBoard.SELECTABLE_ROWS_VALUE[OptionsBoard.SELECTABLE_ROWS_INDIZES[thistype.ROW]] = s

            if (OptionsBoard.SELECTED_ROW == thistype.ROW) then
                set s = String.If((EffectLevel.CURRENT.GetIndex() > ARRAY_MIN), String.Color.Do("<<< ", String.Color.GOLD)) + String.Color.Do(s, String.Color.GREEN) + String.If((EffectLevel.CURRENT.GetIndex() < EffectLevel.ALL_COUNT), String.Color.Do(" >>>", String.Color.GOLD))
            endif

            call OptionsBoard.THIS_BOARD.SetValue(thistype.ROW, OptionsBoard.VALUE_COLUMN, s)
        endmethod

        static method Event_Left takes nothing returns nothing
            call EffectLevel.ALL[Math.MaxI(ARRAY_MIN, EffectLevel.CURRENT.GetIndex() - 1)].Select()

            call thistype.Update()
        endmethod

        static method Event_Right takes nothing returns nothing
            call EffectLevel.ALL[Math.MinI(EffectLevel.CURRENT.GetIndex() + 1, EffectLevel.ALL_COUNT)].Select()

            call thistype.Update()
        endmethod

        static method Init takes nothing returns nothing
            call thistype.Update()
        endmethod
    endstruct

    //! runtextmacro Struct("Hint")
        static integer ROW
        static integer VALUE_INDEX
        static constant integer VALUE_MAX_INDEX = ARRAY_MIN + 1
        static string array VALUES

        static method Update takes nothing returns nothing
            local string s = thistype.VALUES[thistype.VALUE_INDEX]

            set OptionsBoard.SELECTABLE_ROWS_VALUE[OptionsBoard.SELECTABLE_ROWS_INDIZES[thistype.ROW]] = s

            if (OptionsBoard.SELECTED_ROW == thistype.ROW) then
                set s = String.If((thistype.VALUE_INDEX > ARRAY_MIN), String.Color.Do("<<< ", String.Color.GOLD)) + String.Color.Do(s, String.Color.GREEN) + String.If((thistype.VALUE_INDEX < thistype.VALUE_MAX_INDEX), String.Color.Do(" >>>", String.Color.GOLD))
            endif

            call OptionsBoard.THIS_BOARD.SetValue(thistype.ROW, OptionsBoard.VALUE_COLUMN, s)

            set Hint.SHOW = Integer.ToBoolean(VALUE_INDEX)
        endmethod

        static method Event_Left takes nothing returns nothing
            set thistype.VALUE_INDEX = Math.MaxI(0, thistype.VALUE_INDEX - 1)

            call thistype.Update()
        endmethod

        static method Event_Right takes nothing returns nothing
            set thistype.VALUE_INDEX = Math.MinI(thistype.VALUE_INDEX + 1, 1)

            call thistype.Update()
        endmethod

        static method Init takes nothing returns nothing
            set thistype.VALUE_INDEX = 0
            set thistype.VALUES[ARRAY_MIN] = "off"
            set thistype.VALUES[ARRAY_MIN + 1] = "on"

            call thistype.Update()
        endmethod
    endstruct

    //! runtextmacro Struct("MusicVolume")
        static constant integer MAX_SEGMENTS_AMOUNT = 25
        static integer ROW
        static Music TEST_MUSIC
        static integer VALUE = 100

        static method Deselect takes nothing returns nothing
            call thistype.TEST_MUSIC.Stop()
        endmethod

        static method Update takes boolean playMusic returns nothing
            local string s = String.Repeat("l", Real.ToInt(Math.Min(thistype.VALUE * thistype.MAX_SEGMENTS_AMOUNT / 100., thistype.MAX_SEGMENTS_AMOUNT)))
            local string s2 = " " + String.Color.Do("(" + Integer.ToString(thistype.VALUE) + Char.PERCENT + ")", String.Color.GOLD)

            set OptionsBoard.SELECTABLE_ROWS_VALUE[OptionsBoard.SELECTABLE_ROWS_INDIZES[thistype.ROW]] = s + s2
            call Music.SetVolume(thistype.VALUE / 100.)

            if (OptionsBoard.SELECTED_ROW == thistype.ROW) then
                set s = String.Color.Do(s, String.Color.GREEN)
            endif

            set s = s + s2

            if (playMusic) then
                call thistype.TEST_MUSIC.Play()
            endif
            call OptionsBoard.THIS_BOARD.SetValue(thistype.ROW, OptionsBoard.VALUE_COLUMN, s)
        endmethod

        static method Event_Left takes nothing returns nothing
            set thistype.VALUE = Math.MaxI(0, Real.ToInt(thistype.VALUE - 1. * USER.KeyEvent.LeftArrow.TRIGGER_INTERVAL_WEIGHT))

            call thistype.Update(true)
        endmethod

        static method Event_Right takes nothing returns nothing
            set thistype.VALUE = Math.MinI(Real.ToInt(thistype.VALUE + 1. * USER.KeyEvent.RightArrow.TRIGGER_INTERVAL_WEIGHT), 100)

            call thistype.Update(true)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.TEST_MUSIC = Music.Create("Sound\\Music\\mp3Music\\Credits.mp3", 999)

            call thistype.Update(false)
        endmethod
    endstruct

    //! runtextmacro Struct("SoundVolume")
        static constant integer MAX_SEGMENTS_AMOUNT = 25
        static integer ROW
        static Sound TEST_SOUND
        static integer VALUE = 100

        static method Update takes boolean playSound returns nothing
            local string s = String.Repeat("l", Real.ToInt(Math.Min(thistype.VALUE * thistype.MAX_SEGMENTS_AMOUNT / 100., thistype.MAX_SEGMENTS_AMOUNT)))
            local string s2 = " " + String.Color.Do("(" + Integer.ToString(thistype.VALUE) + Char.PERCENT + ")", String.Color.GOLD)

            set OptionsBoard.SELECTABLE_ROWS_VALUE[OptionsBoard.SELECTABLE_ROWS_INDIZES[thistype.ROW]] = s + s2
            call SoundChannel.SetVolumeOverall(thistype.VALUE / 100.)

            if (OptionsBoard.SELECTED_ROW == thistype.ROW) then
                set s = String.Color.Do(s, String.Color.GREEN)
            endif

            set s = s + s2

            if (playSound) then
                call thistype.TEST_SOUND.Play()
            endif
            call OptionsBoard.THIS_BOARD.SetValue(thistype.ROW, OptionsBoard.VALUE_COLUMN, s)
        endmethod

        static method Event_Left takes nothing returns nothing
            set thistype.VALUE = Math.MaxI(0, Real.ToInt(thistype.VALUE - 1. * USER.KeyEvent.LeftArrow.TRIGGER_INTERVAL_WEIGHT))

            call thistype.Update(true)
        endmethod

        static method Event_Right takes nothing returns nothing
            set thistype.VALUE = Math.MinI(Real.ToInt(thistype.VALUE + 1. * USER.KeyEvent.RightArrow.TRIGGER_INTERVAL_WEIGHT), 100)

            call thistype.Update(true)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.TEST_SOUND = Sound.Create("Units\\Human\\Footman\\FootmanPissed4.wav", false, false, false, 10, 10, SoundEax.EMPTY)
            call thistype.TEST_SOUND.SetChannel(SoundChannel.UI)

            call thistype.Update(false)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("OptionsBoard", "OPTIONS_BOARD")
    static boolean CONTROL_ACTIVATED = false
    static integer array SELECTABLE_ROWS
    static integer SELECTABLE_ROWS_COUNT = ARRAY_EMPTY
    static integer array SELECTABLE_ROWS_INDIZES
    static string array SELECTABLE_ROWS_LABEL
    static string array SELECTABLE_ROWS_VALUE
    static integer SELECTED_ROW = ARRAY_EMPTY
    static integer SELECTED_ROW_INDEX = ARRAY_EMPTY
    static Multiboard THIS_BOARD = NULL

    static integer LABEL_COLUMN
    static integer VALUE_COLUMN

    static integer AUDIO_ROW
    static integer BOTTOM_ROW
    static integer GRAPHICS_ROW
    static integer MISC_ROW

    //! runtextmacro LinkToStruct("OptionsBoard", "CameraSmoothing")
    //! runtextmacro LinkToStruct("OptionsBoard", "CameraZoom")
    //! runtextmacro LinkToStruct("OptionsBoard", "EffectLevel")
    //! runtextmacro LinkToStruct("OptionsBoard", "Hint")
    //! runtextmacro LinkToStruct("OptionsBoard", "MusicVolume")
    //! runtextmacro LinkToStruct("OptionsBoard", "SoundVolume")

    static method SelectRowByIndex takes integer index returns nothing
        local integer whichRow

        if (thistype.SELECTED_ROW_INDEX != ARRAY_EMPTY) then
            set whichRow = thistype.SELECTABLE_ROWS[thistype.SELECTED_ROW_INDEX]

            call thistype.THIS_BOARD.SetValue(whichRow, thistype.LABEL_COLUMN, thistype.SELECTABLE_ROWS_LABEL[thistype.SELECTED_ROW_INDEX])
            call thistype.THIS_BOARD.SetValue(whichRow, thistype.VALUE_COLUMN, thistype.SELECTABLE_ROWS_VALUE[thistype.SELECTED_ROW_INDEX])

            if (thistype.SELECTED_ROW == MusicVolume.ROW) then
                call MusicVolume.Deselect()
            endif
        endif

        set thistype.SELECTED_ROW_INDEX = index
        if (index == ARRAY_EMPTY) then
            set thistype.SELECTED_ROW = ARRAY_EMPTY
        else
            set whichRow = thistype.SELECTABLE_ROWS[index]

            set thistype.SELECTED_ROW = whichRow
            //call thistype.THIS_BOARD.SetValue(whichRow, thistype.VALUE_COLUMN, String.Color.Do("<<< ", String.Color.GOLD) + thistype.SELECTABLE_ROWS_VALUE[thistype.SELECTED_ROW_INDEX] + String.Color.Do(" >>>", String.Color.GOLD))
        endif

        if (thistype.SELECTED_ROW == thistype(NULL).CameraSmoothing.ROW) then
            call thistype(NULL).CameraSmoothing.Update()
        endif
        if (thistype.SELECTED_ROW == thistype(NULL).CameraZoom.ROW) then
            call thistype(NULL).CameraZoom.Update()
        endif
        if (thistype.SELECTED_ROW == thistype(NULL).EffectLevel.ROW) then
            call thistype(NULL).EffectLevel.Update()
        endif
        if (thistype.SELECTED_ROW == thistype(NULL).Hint.ROW) then
            call thistype(NULL).Hint.Update()
        endif
        if (thistype.SELECTED_ROW == MusicVolume.ROW) then
            call MusicVolume.Update(false)
        endif
        if (thistype.SELECTED_ROW == SoundVolume.ROW) then
            call SoundVolume.Update(false)
        endif
    endmethod

    static method Conditions takes User whichPlayer returns boolean
        if (whichPlayer.IsLocal() == false) then
            return true
        endif
        if (thistype.CONTROL_ACTIVATED == false) then
            return true
        endif

        return false
    endmethod

    static method Event_Left takes nothing returns nothing
        if (thistype.Conditions(USER.Event.GetTrigger())) then
            return
        endif

        if (thistype.SELECTED_ROW == thistype(NULL).CameraSmoothing.ROW) then
            call thistype(NULL).CameraSmoothing.Event_Left()
        endif
        if (thistype.SELECTED_ROW == thistype(NULL).CameraZoom.ROW) then
            call thistype(NULL).CameraZoom.Event_Left()
        endif
        if (thistype.SELECTED_ROW == thistype(NULL).EffectLevel.ROW) then
            call thistype(NULL).EffectLevel.Event_Left()
        endif
        if (thistype.SELECTED_ROW == thistype(NULL).Hint.ROW) then
            call thistype(NULL).Hint.Event_Left()
        endif
        if (thistype.SELECTED_ROW == MusicVolume.ROW) then
            call MusicVolume.Event_Left()
        endif
        if (thistype.SELECTED_ROW == SoundVolume.ROW) then
            call SoundVolume.Event_Left()
        endif
    endmethod

    static method Event_Right takes nothing returns nothing
        if (thistype.Conditions(USER.Event.GetTrigger())) then
            return
        endif

        if (thistype.SELECTED_ROW == thistype(NULL).CameraSmoothing.ROW) then
            call thistype(NULL).CameraSmoothing.Event_Right()
        endif
        if (thistype.SELECTED_ROW == thistype(NULL).CameraZoom.ROW) then
            call thistype(NULL).CameraZoom.Event_Right()
        endif
        if (thistype.SELECTED_ROW == thistype(NULL).EffectLevel.ROW) then
            call thistype(NULL).EffectLevel.Event_Right()
        endif
        if (thistype.SELECTED_ROW == thistype(NULL).Hint.ROW) then
            call thistype(NULL).Hint.Event_Right()
        endif
        if (thistype.SELECTED_ROW == MusicVolume.ROW) then
            call MusicVolume.Event_Right()
        endif
        if (thistype.SELECTED_ROW == SoundVolume.ROW) then
            call SoundVolume.Event_Right()
        endif
    endmethod

    static method Event_Down takes nothing returns nothing
        if (thistype.Conditions(USER.Event.GetTrigger())) then
            return
        endif

        if (thistype.SELECTED_ROW_INDEX == thistype.SELECTABLE_ROWS_COUNT) then
            call SelectRowByIndex(ARRAY_MIN)
        else
            call SelectRowByIndex(thistype.SELECTED_ROW_INDEX + 1)
        endif
    endmethod

    static method Event_Up takes nothing returns nothing
        if (thistype.Conditions(USER.Event.GetTrigger())) then
            return
        endif

        if (thistype.SELECTED_ROW_INDEX == ARRAY_MIN) then
            call SelectRowByIndex(thistype.SELECTABLE_ROWS_COUNT)
        else
            call SelectRowByIndex(thistype.SELECTED_ROW_INDEX - 1)
        endif
    endmethod

    static method Deactivate takes User whichPlayer returns nothing
        set thistype.CONTROL_ACTIVATED = false
        call Camera.Unlock(whichPlayer)
        call thistype.THIS_BOARD.SetValue(thistype.BOTTOM_ROW, thistype.LABEL_COLUMN, String.Color.Do("Press Esc to activate multiboard control and then use arrow keys.", String.Color.GREEN))
        call thistype.SelectRowByIndex(ARRAY_EMPTY)
    endmethod

    static method Event_Esc takes nothing returns nothing
        local User whichPlayer = USER.Event.GetTrigger()

        if (whichPlayer.IsLocal() == false) then
            return
        endif

        if (thistype.CONTROL_ACTIVATED) then
            call thistype.Deactivate(whichPlayer)
        elseif (MULTIBOARD.Shown.CURRENT == thistype.THIS_BOARD) then
            set thistype.CONTROL_ACTIVATED = true
            call Camera.Lock(whichPlayer)
            call thistype.THIS_BOARD.SetValue(thistype.BOTTOM_ROW, thistype.LABEL_COLUMN, String.Color.Do("Press Esc to deactivate multiboard control.", String.Color.RED))
            call thistype.SelectRowByIndex(ARRAY_MIN)
        endif
    endmethod

    static method Event_MultiboardChange takes User whichPlayer returns nothing
        if (whichPlayer.IsLocal() == false) then
            return
        endif

        if (thistype.CONTROL_ACTIVATED == false) then
            return
        endif

        if (MULTIBOARD.Shown.CURRENT != THIS_BOARD) then
            call thistype.Deactivate(whichPlayer)
        endif
    endmethod

    static method Event_AfterIntro takes nothing returns nothing
        if (USER.Event.GetTrigger().IsLocal()) then
            call thistype.THIS_BOARD.Show()
        endif
    endmethod

    static method GetNewRow takes nothing returns integer
        return thistype.THIS_BOARD.GetNewRow()
    endmethod

    static method GetNewSelectableRow takes string label, string value returns integer
        local integer result = thistype.GetNewRow()

        set label = String.Color.Do(label, String.Color.GOLD)

        set thistype.SELECTABLE_ROWS_COUNT = thistype.SELECTABLE_ROWS_COUNT + 1
        call thistype.THIS_BOARD.SetValue(result, thistype.LABEL_COLUMN, label)
        call thistype.THIS_BOARD.SetValue(result, thistype.VALUE_COLUMN, value)

        set thistype.SELECTABLE_ROWS[thistype.SELECTABLE_ROWS_COUNT] = result
        set thistype.SELECTABLE_ROWS_INDIZES[result] = thistype.SELECTABLE_ROWS_COUNT
        set thistype.SELECTABLE_ROWS_LABEL[thistype.SELECTABLE_ROWS_COUNT] = label
        set thistype.SELECTABLE_ROWS_VALUE[thistype.SELECTABLE_ROWS_COUNT] = value

        return result
    endmethod

    static method InitKeyEvents takes nothing returns nothing
        local integer iteration = User.PLAYING_HUMANS_COUNT
        local User specificPlayer

        call Event.Create(USER.KeyEvent.ESC_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Esc).AddToStatics()

        loop
            exitwhen (iteration < ARRAY_MIN)

            set specificPlayer = User.PLAYING_HUMANS[iteration]

            call specificPlayer.KeyEvent.DownArrow.RegisterPress(EventPriority.MISC, function thistype.Event_Down, 0.5, 1.)
            call specificPlayer.KeyEvent.LeftArrow.RegisterPress(EventPriority.MISC, function thistype.Event_Left, 0.1, 4.)
            call specificPlayer.KeyEvent.RightArrow.RegisterPress(EventPriority.MISC, function thistype.Event_Right, 0.1, 4.)
            call specificPlayer.KeyEvent.UpArrow.RegisterPress(EventPriority.MISC, function thistype.Event_Up, 0.5, 1.)

            set iteration = iteration - 1
        endloop
    endmethod

    static method Event_Start takes nothing returns nothing
        set thistype.THIS_BOARD = Multiboard.Create()

        set thistype.LABEL_COLUMN = thistype.THIS_BOARD.GetNewColumn()
        set thistype.VALUE_COLUMN = thistype.THIS_BOARD.GetNewColumn()

        set thistype.GRAPHICS_ROW = thistype.GetNewRow()
        set thistype(NULL).EffectLevel.ROW = thistype.GetNewSelectableRow("SFX Level", "")
        set thistype.AUDIO_ROW = thistype.GetNewRow()
        set SoundVolume.ROW = thistype.GetNewSelectableRow("Sound volume", "")
        set MusicVolume.ROW = thistype.GetNewSelectableRow("Music volume", "")
        set thistype.MISC_ROW = thistype.GetNewRow()
        set thistype(NULL).CameraZoom.ROW = thistype.GetNewSelectableRow("Camera zoom", "")
        set thistype(NULL).CameraSmoothing.ROW = thistype.GetNewSelectableRow("Camera smoothing factor", "")
        set thistype(NULL).Hint.ROW = thistype.GetNewSelectableRow("Hint", "")
        set thistype.BOTTOM_ROW = thistype.GetNewRow()

        call thistype.THIS_BOARD.Column.SetWidth(thistype.LABEL_COLUMN, 0.1)
        call thistype.THIS_BOARD.Column.SetWidth(thistype.VALUE_COLUMN, 0.1)
        call thistype.THIS_BOARD.SetTitle("Options")
        call thistype.THIS_BOARD.SetValue(thistype.AUDIO_ROW, thistype.LABEL_COLUMN, String.Color.Do("Audio", String.Color.GOLD))
        call thistype.THIS_BOARD.SetWidth(thistype.AUDIO_ROW, thistype.LABEL_COLUMN, 0.2)
        call thistype.THIS_BOARD.SetWidth(thistype.AUDIO_ROW, thistype.VALUE_COLUMN, 0.)
        call thistype.THIS_BOARD.SetValue(thistype.BOTTOM_ROW, thistype.LABEL_COLUMN, String.Color.Do("Press Esc to activate multiboard control and then use arrow keys.", String.Color.GREEN))
        call thistype.THIS_BOARD.SetWidth(thistype.BOTTOM_ROW, thistype.LABEL_COLUMN, 0.2)
        call thistype.THIS_BOARD.SetWidth(thistype.BOTTOM_ROW, thistype.VALUE_COLUMN, 0.)
        call thistype.THIS_BOARD.SetValue(thistype.GRAPHICS_ROW, thistype.LABEL_COLUMN, String.Color.Do("Graphics", String.Color.GOLD))
        call thistype.THIS_BOARD.SetWidth(thistype.GRAPHICS_ROW, thistype.LABEL_COLUMN, 0.2)
        call thistype.THIS_BOARD.SetWidth(thistype.GRAPHICS_ROW, thistype.VALUE_COLUMN, 0.)
        call thistype.THIS_BOARD.SetValue(thistype.MISC_ROW, thistype.LABEL_COLUMN, String.Color.Do("Misc", String.Color.GOLD))
        call thistype.THIS_BOARD.SetWidth(thistype.MISC_ROW, thistype.LABEL_COLUMN, 0.2)
        call thistype.THIS_BOARD.SetWidth(thistype.MISC_ROW, thistype.VALUE_COLUMN, 0.)

        call Event.Create(AfterIntro.FOR_PLAYER_EVENT_TYPE, EventPriority.MISC, function thistype.Event_AfterIntro).AddToStatics()

        call thistype.InitKeyEvents()

        call thistype(NULL).CameraSmoothing.Init()
        call thistype(NULL).CameraZoom.Init()
        call thistype(NULL).EffectLevel.Init()
        call thistype(NULL).Hint.Init()
        call thistype(NULL).MusicVolume.Init()
        call thistype(NULL).SoundVolume.Init()
    endmethod

    static method Init takes nothing returns nothing
        call Event.Create(EventType.START, EventPriority.MISC, function thistype.Event_Start).AddToStatics()
    endmethod
endstruct