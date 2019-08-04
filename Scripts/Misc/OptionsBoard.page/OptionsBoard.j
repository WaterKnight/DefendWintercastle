//! runtextmacro Folder("OptionsBoard")
    //! runtextmacro Struct("CameraSmoothing")
        static integer ROW
        static integer VALUE_INDEX
        static constant integer VALUE_MAX_INDEX = ARRAY_MIN + 8
        static real array VALUES

        method UpdateLocal takes nothing returns nothing
            local string s = Real.ToStringWithDecimals(thistype.VALUES[thistype.VALUE_INDEX], 1)

            set OptionsBoard.SELECTABLE_ROWS_VALUE[OptionsBoard.SELECTABLE_ROWS_INDIZES[thistype.ROW]] = s

            if (OptionsBoard(this).selectedRow == thistype.ROW) then
                set s = String.If((thistype.VALUE_INDEX > ARRAY_MIN), String.Color.Do("<<< ", String.Color.GOLD)) + String.Color.Do(s, String.Color.GREEN) + String.If((thistype.VALUE_INDEX < thistype.VALUE_MAX_INDEX), String.Color.Do(" >>>", String.Color.GOLD))
            endif

            call OptionsBoard.THIS_BOARD.SetValue(thistype.ROW, OptionsBoard.VALUE_COLUMN, s)

            call Camera.SetSmoothing(User.GetLocal(), thistype.VALUES[thistype.VALUE_INDEX])
        endmethod

        method Update takes nothing returns nothing
            if OptionsBoard(this).owner.IsLocal() then
                call this.UpdateLocal()
            endif
        endmethod

        method Event_Left takes nothing returns nothing
            if (thistype.VALUE_INDEX > ARRAY_MIN) then
                set thistype.VALUE_INDEX = thistype.VALUE_INDEX - 1
            endif

            call this.Update()
        endmethod

        method Event_Right takes nothing returns nothing
            if (thistype.VALUE_INDEX < thistype.VALUE_MAX_INDEX) then
                set thistype.VALUE_INDEX = thistype.VALUE_INDEX + 1
            endif

            call this.Update()
        endmethod

        method Event_Create takes nothing returns nothing
            call this.Update()
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
        endmethod
    endstruct

    //! runtextmacro Struct("CameraZoom")
        static integer ROW
        static constant integer VALUE_MAX_INDEX = ARRAY_MIN + 11
        static integer array VALUES

        integer valueIndex

        method UpdateLocal takes nothing returns nothing
            local string s = Integer.ToString(thistype.VALUES[this.valueIndex])

            set OptionsBoard.SELECTABLE_ROWS_VALUE[OptionsBoard.SELECTABLE_ROWS_INDIZES[thistype.ROW]] = s

            if (OptionsBoard(this).selectedRow == thistype.ROW) then
                set s = String.If((this.valueIndex > ARRAY_MIN), String.Color.Do("<<< ", String.Color.GOLD)) + String.Color.Do(s, String.Color.GREEN) + String.If((this.valueIndex < thistype.VALUE_MAX_INDEX), String.Color.Do(" >>>", String.Color.GOLD))
            endif

            call OptionsBoard.THIS_BOARD.SetValue(thistype.ROW, OptionsBoard.VALUE_COLUMN, s)

            set Zoom.VALUE = thistype.VALUES[this.valueIndex]
        endmethod

        method Update takes nothing returns nothing
            if OptionsBoard(this).owner.IsLocal() then
                call this.UpdateLocal()
            endif
        endmethod

        method Event_Left takes real intervalWeight returns nothing
            if (this.valueIndex > ARRAY_MIN) then
                set this.valueIndex = this.valueIndex - 1
            else
                if (intervalWeight == 1.) then
                    call Game.DisplayTextTimed(OptionsBoard(this).owner, String.Color.Do("Penguin perspective is not supported", String.Color.GOLD), 10.)
                endif
            endif

            call this.Update()
        endmethod

        method Event_Right takes nothing returns nothing
            if (this.valueIndex < thistype.VALUE_MAX_INDEX) then
                set this.valueIndex = this.valueIndex + 1
            endif

            call this.Update()
        endmethod

        method Event_Create takes nothing returns nothing
            set this.valueIndex = ARRAY_MIN + 10

            call this.Update()
        endmethod

        static method Init takes nothing returns nothing
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
        endmethod
    endstruct

    //! runtextmacro Struct("EffectLevel")
        static integer ROW

        method UpdateLocal takes nothing returns nothing
            local string s = EffectLevel.CURRENT.GetName()

            set OptionsBoard.SELECTABLE_ROWS_VALUE[OptionsBoard.SELECTABLE_ROWS_INDIZES[thistype.ROW]] = s

            if (OptionsBoard(this).selectedRow == thistype.ROW) then
                set s = String.If((EffectLevel.CURRENT.GetIndex() > ARRAY_MIN), String.Color.Do("<<< ", String.Color.GOLD)) + String.Color.Do(s, String.Color.GREEN) + String.If((EffectLevel.CURRENT.GetIndex() < EffectLevel.ALL_COUNT), String.Color.Do(" >>>", String.Color.GOLD))
            endif

            call OptionsBoard.THIS_BOARD.SetValue(thistype.ROW, OptionsBoard.VALUE_COLUMN, s)
        endmethod

        method Update takes nothing returns nothing
            if OptionsBoard(this).owner.IsLocal() then
                call this.UpdateLocal()
            endif
        endmethod

        method Event_Left takes nothing returns nothing
            call EffectLevel.ALL[Math.MaxI(ARRAY_MIN, EffectLevel.CURRENT.GetIndex() - 1)].Select()

            call this.Update()
        endmethod

        method Event_Right takes nothing returns nothing
            call EffectLevel.ALL[Math.MinI(EffectLevel.CURRENT.GetIndex() + 1, EffectLevel.ALL_COUNT)].Select()

            call this.Update()
        endmethod

        method Event_Create takes nothing returns nothing
            call this.Update()
        endmethod

        static method Init takes nothing returns nothing
        endmethod
    endstruct

    //! runtextmacro Struct("Hint")
        static integer ROW
        static integer VALUE_INDEX
        static constant integer VALUE_MAX_INDEX = ARRAY_MIN + 1
        static string array VALUES

        method UpdateLocal takes nothing returns nothing
            local string s = thistype.VALUES[thistype.VALUE_INDEX]

            set OptionsBoard.SELECTABLE_ROWS_VALUE[OptionsBoard.SELECTABLE_ROWS_INDIZES[thistype.ROW]] = s

            if (OptionsBoard(this).selectedRow == thistype.ROW) then
                set s = String.If((thistype.VALUE_INDEX > ARRAY_MIN), String.Color.Do("<<< ", String.Color.GOLD)) + String.Color.Do(s, String.Color.GREEN) + String.If((thistype.VALUE_INDEX < thistype.VALUE_MAX_INDEX), String.Color.Do(" >>>", String.Color.GOLD))
            endif

            call OptionsBoard.THIS_BOARD.SetValue(thistype.ROW, OptionsBoard.VALUE_COLUMN, s)

            set Hint.SHOW = Integer.ToBoolean(thistype.VALUE_INDEX)
        endmethod

        method Update takes nothing returns nothing
            if OptionsBoard(this).owner.IsLocal() then
                call this.UpdateLocal()
            endif
        endmethod

        method Event_Left takes nothing returns nothing
            set thistype.VALUE_INDEX = Math.MaxI(0, thistype.VALUE_INDEX - 1)

            call this.Update()
        endmethod

        method Event_Right takes nothing returns nothing
            set thistype.VALUE_INDEX = Math.MinI(thistype.VALUE_INDEX + 1, 1)

            call this.Update()
        endmethod

        method Event_Create takes nothing returns nothing
            call this.Update()
        endmethod

        static method Init takes nothing returns nothing
            set thistype.VALUE_INDEX = 0
            set thistype.VALUES[ARRAY_MIN] = "off"
            set thistype.VALUES[ARRAY_MIN + 1] = "on"
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

        method UpdateLocal takes boolean playMusic returns nothing
            local string s = String.Repeat("l", Real.ToInt(Math.Min(thistype.VALUE * thistype.MAX_SEGMENTS_AMOUNT / 100., thistype.MAX_SEGMENTS_AMOUNT)))
            local string s2 = " " + String.Color.Do("(" + Integer.ToString(thistype.VALUE) + Char.PERCENT + ")", String.Color.GOLD)

            set OptionsBoard.SELECTABLE_ROWS_VALUE[OptionsBoard.SELECTABLE_ROWS_INDIZES[thistype.ROW]] = s + s2
            call Music.SetVolume(thistype.VALUE / 100.)

            if (OptionsBoard(this).selectedRow == thistype.ROW) then
                set s = String.Color.Do(s, String.Color.GREEN)
            endif

            set s = s + s2

            if playMusic then
                call thistype.TEST_MUSIC.Play()
            endif
            call OptionsBoard.THIS_BOARD.SetValue(thistype.ROW, OptionsBoard.VALUE_COLUMN, s)
        endmethod

        method Update takes boolean playMusic returns nothing
            if OptionsBoard(this).owner.IsLocal() then
                call this.UpdateLocal(playMusic)
            endif
        endmethod

        method Event_Left takes real intervalWeight returns nothing
            set thistype.VALUE = Math.MaxI(0, Real.ToInt(thistype.VALUE - 1. * intervalWeight))

            call this.Update(true)
        endmethod

        method Event_Right takes real intervalWeight returns nothing
            set thistype.VALUE = Math.MinI(Real.ToInt(thistype.VALUE + 1. * intervalWeight), 100)

            call this.Update(true)
        endmethod

        method Event_Create takes nothing returns nothing
            call this.Update(false)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.TEST_MUSIC = Music.Create("Sound\\Music\\mp3Music\\Credits.mp3", -1)
        endmethod
    endstruct

    //! runtextmacro Struct("SoundVolume")
        static constant integer MAX_SEGMENTS_AMOUNT = 25
        static integer ROW
        static Sound TEST_SOUND
        static integer VALUE = 100

        method UpdateLocal takes boolean playSound returns nothing
            local string s = String.Repeat("l", Real.ToInt(Math.Min(thistype.VALUE * thistype.MAX_SEGMENTS_AMOUNT / 100., thistype.MAX_SEGMENTS_AMOUNT)))
            local string s2 = " " + String.Color.Do("(" + Integer.ToString(thistype.VALUE) + Char.PERCENT + ")", String.Color.GOLD)

            set OptionsBoard.SELECTABLE_ROWS_VALUE[OptionsBoard.SELECTABLE_ROWS_INDIZES[thistype.ROW]] = s + s2
            call SoundChannel.SetVolumeOverall(thistype.VALUE / 100.)

            if (OptionsBoard(this).selectedRow == thistype.ROW) then
                set s = String.Color.Do(s, String.Color.GREEN)
            endif

            set s = s + s2

            if playSound then
                call thistype.TEST_SOUND.Play()
            endif
            call OptionsBoard.THIS_BOARD.SetValue(thistype.ROW, OptionsBoard.VALUE_COLUMN, s)
        endmethod

        method Update takes boolean playSound returns nothing
            if OptionsBoard(this).owner.IsLocal() then
                call this.UpdateLocal(playSound)
            endif
        endmethod

        method Event_Left takes real intervalWeight returns nothing
            set thistype.VALUE = Math.MaxI(0, Real.ToInt(thistype.VALUE - 1. * intervalWeight))

            call this.Update(true)
        endmethod

        method Event_Right takes real intervalWeight returns nothing
            set thistype.VALUE = Math.MinI(Real.ToInt(thistype.VALUE + 1. * intervalWeight), 100)

            call this.Update(true)
        endmethod

        method Event_Create takes nothing returns nothing
            call this.Update(false)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.TEST_SOUND = Sound.Create("Units\\Human\\Footman\\FootmanPissed4.wav", false, false, false, 10, 10, NULL)
            
            call thistype.TEST_SOUND.SetChannel(SoundChannel.UI)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("OptionsBoard", "OPTIONS_BOARD")
    static integer array SELECTABLE_ROWS
    static integer SELECTABLE_ROWS_COUNT = ARRAY_EMPTY
    static integer array SELECTABLE_ROWS_INDIZES
    static string array SELECTABLE_ROWS_LABEL
    static string array SELECTABLE_ROWS_VALUE
    static Multiboard THIS_BOARD = NULL

    static integer LABEL_COLUMN
    static integer VALUE_COLUMN

    static integer AUDIO_ROW
    static integer GRAPHICS_ROW
    static integer MISC_ROW

    boolean active
    User owner
    integer selectedRow
    integer selectedRowIndex

    Event downEvent
    Event leftEvent
    Event rightEvent
    Event upEvent

    //! runtextmacro LinkToStruct("OptionsBoard", "CameraSmoothing")
    //! runtextmacro LinkToStruct("OptionsBoard", "CameraZoom")
    //! runtextmacro LinkToStruct("OptionsBoard", "EffectLevel")
    //! runtextmacro LinkToStruct("OptionsBoard", "Hint")
    //! runtextmacro LinkToStruct("OptionsBoard", "MusicVolume")
    //! runtextmacro LinkToStruct("OptionsBoard", "SoundVolume")

    method DeselectRowByIndex takes integer index returns nothing
        if (index == ARRAY_EMPTY) then
            return
        endif

        local integer row = thistype.SELECTABLE_ROWS[index]

        if this.owner.IsLocal() then
            call thistype.THIS_BOARD.SetValue(row, thistype.LABEL_COLUMN, thistype.SELECTABLE_ROWS_LABEL[index])
            call thistype.THIS_BOARD.SetValue(row, thistype.VALUE_COLUMN, thistype.SELECTABLE_ROWS_VALUE[index])
        endif

        if (row == thistype(NULL).MusicVolume.ROW) then
            call thistype(NULL).MusicVolume.Deselect()
        endif
    endmethod

    method SelectRowByIndex takes integer index returns nothing
        local integer oldRowIndex = this.selectedRowIndex

        if (index == oldRowIndex) then
            return
        endif

        call this.DeselectRowByIndex(oldRowIndex)

        set this.selectedRowIndex = index

		local integer whichRow

        if (index == ARRAY_EMPTY) then
            set whichRow = NULL
        else
            set whichRow = thistype.SELECTABLE_ROWS[index]
        endif

        set this.selectedRow = whichRow

        if (whichRow == NULL) then
            call MULTIBOARD.Shown.Control.PageSwitch.Activate(this.owner)
        else
            call MULTIBOARD.Shown.Control.PageSwitch.Deactivate(this.owner)
        endif

        if not this.owner.IsLocal() then
            return
        endif

        if (whichRow == thistype(NULL).CameraSmoothing.ROW) then
            call this.CameraSmoothing.Update()
        endif
        if (whichRow == thistype(NULL).CameraZoom.ROW) then
            call this.CameraZoom.Update()
        endif
        if (whichRow == thistype(NULL).EffectLevel.ROW) then
            call this.EffectLevel.Update()
        endif
        if (whichRow == thistype(NULL).Hint.ROW) then
            call this.Hint.Update()
        endif
        if (whichRow == thistype(NULL).MusicVolume.ROW) then
            call this.MusicVolume.Update(false)
        endif
        if (whichRow == thistype(NULL).SoundVolume.ROW) then
            call this.SoundVolume.Update(false)
        endif
    endmethod

    eventMethod Event_Left
        local real intervalWeight = params.Real.GetIntervalWeight()
        local User owner = params.User.GetTrigger()

        local thistype this = owner

        local integer whichRow = this.selectedRow

        if (whichRow == thistype(NULL).CameraZoom.ROW) then
            call this.CameraZoom.Event_Left(intervalWeight)
        endif

        if not owner.IsLocal() then
            return
        endif

        if (whichRow == thistype(NULL).CameraSmoothing.ROW) then
            call this.CameraSmoothing.Event_Left()
        endif
        if (whichRow == thistype(NULL).EffectLevel.ROW) then
            call this.EffectLevel.Event_Left()
        endif
        if (whichRow == thistype(NULL).Hint.ROW) then
            call this.Hint.Event_Left()
        endif
        if (whichRow == thistype(NULL).MusicVolume.ROW) then
            call this.MusicVolume.Event_Left(intervalWeight)
        endif
        if (whichRow == thistype(NULL).SoundVolume.ROW) then
            call this.SoundVolume.Event_Left(intervalWeight)
        endif
    endmethod

    eventMethod Event_Right
        local real intervalWeight = params.Real.GetIntervalWeight()
        local User owner = params.User.GetTrigger()

        local thistype this = owner

        local integer whichRow = this.selectedRow

        if (whichRow == thistype(NULL).CameraZoom.ROW) then
            call this.CameraZoom.Event_Right()
        endif

        if not owner.IsLocal() then
            return
        endif

        if (whichRow == thistype(NULL).CameraSmoothing.ROW) then
            call this.CameraSmoothing.Event_Right()
        endif
        if (whichRow == thistype(NULL).EffectLevel.ROW) then
            call this.EffectLevel.Event_Right()
        endif
        if (whichRow == thistype(NULL).Hint.ROW) then
            call this.Hint.Event_Right()
        endif
        if (whichRow == thistype(NULL).MusicVolume.ROW) then
            call this.MusicVolume.Event_Right(intervalWeight)
        endif
        if (whichRow == thistype(NULL).SoundVolume.ROW) then
            call this.SoundVolume.Event_Right(intervalWeight)
        endif
    endmethod

    eventMethod Event_Down
        local User owner = params.User.GetTrigger()

        local thistype this = owner

        if (this.selectedRowIndex == thistype.SELECTABLE_ROWS_COUNT) then
            call this.SelectRowByIndex(ARRAY_EMPTY)
        else
            call this.SelectRowByIndex(this.selectedRowIndex + 1)
        endif
    endmethod

    eventMethod Event_Up
        local User owner = params.User.GetTrigger()

        local thistype this = owner

        if (this.selectedRowIndex == ARRAY_EMPTY) then
            call this.SelectRowByIndex(thistype.SELECTABLE_ROWS_COUNT)
        else
            call this.SelectRowByIndex(this.selectedRowIndex - 1)
        endif
    endmethod

    method Deactivate takes nothing returns nothing
        local User owner = this.owner

        if not this.active then
            return
        endif

        set this.active = false

        call this.downEvent.Destroy()
        call this.leftEvent.Destroy()
        call this.rightEvent.Destroy()
        call this.upEvent.Destroy()

        call this.DeselectRowByIndex(this.selectedRowIndex)
    endmethod

    method Activate takes nothing returns nothing
        local User owner = this.owner

        if this.active then
            return
        endif

        set this.active = true

        set this.downEvent = owner.KeyEvent.DownArrow.RegisterPress(EventPriority.MISC, function thistype.Event_Down, 0.5, 1.)
        set this.leftEvent = owner.KeyEvent.LeftArrow.RegisterPress(EventPriority.MISC, function thistype.Event_Left, 0.1, 4.)
        set this.rightEvent = owner.KeyEvent.RightArrow.RegisterPress(EventPriority.MISC, function thistype.Event_Right, 0.1, 4.)
        set this.upEvent = owner.KeyEvent.UpArrow.RegisterPress(EventPriority.MISC, function thistype.Event_Up, 0.5, 1.)

        set this.selectedRow = ARRAY_EMPTY
        set this.selectedRowIndex = ARRAY_EMPTY
    endmethod

    static method Event_MultiboardChange takes Multiboard matchingBoard, User owner returns nothing
        local thistype this = owner

        if (matchingBoard == thistype.THIS_BOARD) then
            call this.Activate()
        else
            call this.Deactivate()
        endif
    endmethod

    static method Event_MultiboardControlDeactivate takes User owner returns nothing
        local thistype this = owner

        call this.Deactivate()
    endmethod

    static method Event_MultiboardControlActivate takes User owner returns nothing
        local thistype this = owner

        if (MULTIBOARD.Shown.GetCurrent(owner) == thistype.THIS_BOARD) then
            call this.Activate()
        endif
    endmethod

    static method Create takes User owner returns thistype
        local thistype this = owner

        set this.active = false
        set this.owner = owner

        call thistype.THIS_BOARD.Show(owner)

        call this.CameraSmoothing.Event_Create()
        call this.CameraZoom.Event_Create()
        call this.EffectLevel.Event_Create()
        call this.Hint.Event_Create()
        call this.MusicVolume.Event_Create()
        call this.SoundVolume.Event_Create()

        return this
    endmethod

    eventMethod Event_AfterIntro
        call thistype.Create(params.User.GetTrigger())
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

    eventMethod Event_Start
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

        call thistype.THIS_BOARD.Column.SetWidth(thistype.LABEL_COLUMN, 0.1)
        call thistype.THIS_BOARD.Column.SetWidth(thistype.VALUE_COLUMN, 0.1)
        call thistype.THIS_BOARD.SetTitle("Options")
        call thistype.THIS_BOARD.SetValue(thistype.AUDIO_ROW, thistype.LABEL_COLUMN, String.Color.Do("Audio", String.Color.GOLD))
        call thistype.THIS_BOARD.SetWidth(thistype.AUDIO_ROW, thistype.LABEL_COLUMN, 0.2)
        call thistype.THIS_BOARD.SetWidth(thistype.AUDIO_ROW, thistype.VALUE_COLUMN, 0.)
        call thistype.THIS_BOARD.SetValue(thistype.GRAPHICS_ROW, thistype.LABEL_COLUMN, String.Color.Do("Graphics", String.Color.GOLD))
        call thistype.THIS_BOARD.SetWidth(thistype.GRAPHICS_ROW, thistype.LABEL_COLUMN, 0.2)
        call thistype.THIS_BOARD.SetWidth(thistype.GRAPHICS_ROW, thistype.VALUE_COLUMN, 0.)
        call thistype.THIS_BOARD.SetValue(thistype.MISC_ROW, thistype.LABEL_COLUMN, String.Color.Do("Misc", String.Color.GOLD))
        call thistype.THIS_BOARD.SetWidth(thistype.MISC_ROW, thistype.LABEL_COLUMN, 0.2)
        call thistype.THIS_BOARD.SetWidth(thistype.MISC_ROW, thistype.VALUE_COLUMN, 0.)

        call Event.Create(AfterIntro.FOR_PLAYER_EVENT_TYPE, EventPriority.MISC, function thistype.Event_AfterIntro).AddToStatics()

        call thistype(NULL).CameraSmoothing.Init()
        call thistype(NULL).CameraZoom.Init()
        call thistype(NULL).EffectLevel.Init()
        call thistype(NULL).Hint.Init()
        call thistype(NULL).MusicVolume.Init()
        call thistype(NULL).SoundVolume.Init()
    endmethod

    initMethod Init of Misc_2
        call Event.Create(EventType.START, EventPriority.MISC, function thistype.Event_Start).AddToStatics()
    endmethod
endstruct