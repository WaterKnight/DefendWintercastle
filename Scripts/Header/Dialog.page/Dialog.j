//! runtextmacro Folder("DialogButton")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("DialogButton", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Boolean")
            //! runtextmacro Data_Type_Implement("DialogButton", "Boolean", "boolean")
        endstruct

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("DialogButton", "Integer", "integer")
        endstruct

        //! runtextmacro Struct("Real")
            //! runtextmacro Data_Type_Implement("DialogButton", "Real", "real")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Boolean")
        //! runtextmacro LinkToStruct("Data", "Integer")
        //! runtextmacro LinkToStruct("Data", "Real")

        //! runtextmacro Data_Implement("DialogButton")
    endstruct

    //! runtextmacro Folder("Event")
        //! runtextmacro Struct("Native")
            static method GetClicked takes nothing returns DialogButton
                return Memory.IntegerKeys.GetIntegerByHandle(GetClickedButton(), Dialog(NULL).Buttons.KEY)
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Event")
        //! runtextmacro LinkToStruct("Event", "Native")

		//! runtextmacro Event_Implement("DialogButton")
    endstruct
endscope

//! runtextmacro BaseStruct("DialogButton", "DIALOG_BUTTON")
    //! runtextmacro CreateAnyState("hotkey", "Hotkey", "integer")
    //! runtextmacro CreateAnyState("text", "Text", "string")

    //! runtextmacro LinkToStruct("DialogButton", "Data")
    //! runtextmacro LinkToStruct("DialogButton", "Event")
    //! runtextmacro LinkToStruct("DialogButton", "Id")

    method Destroy takes nothing returns nothing
        call this.deallocate()

        call Dialog(NULL).Buttons.Event_ButtonDestroy(this)
    endmethod

    static method Create takes string text, integer hotkey returns thistype
        local thistype this = thistype.allocate()

        call this.Id.Event_Create()

        call this.SetHotkey(hotkey)
        call this.SetText(text)

        return this
    endmethod

    static method Init takes nothing returns nothing
    endmethod
endstruct

//! runtextmacro Folder("Dialog")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("Dialog", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Boolean")
            //! runtextmacro Data_Type_Implement("Dialog", "Boolean", "boolean")
        endstruct

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("Dialog", "Integer", "integer")
        endstruct

        //! runtextmacro Struct("Real")
            //! runtextmacro Data_Type_Implement("Dialog", "Real", "real")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Boolean")
        //! runtextmacro LinkToStruct("Data", "Integer")
        //! runtextmacro LinkToStruct("Data", "Real")

        //! runtextmacro Data_Implement("Dialog")
    endstruct

    //! runtextmacro Folder("Event")
        //! runtextmacro Struct("Native")
            static method GetClicked takes nothing returns Dialog
                return Dialog.GetFromSelf(GetClickedDialog())
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Event")
        //! runtextmacro LinkToStruct("Event", "Native")

        //! runtextmacro Event_Implement("Dialog")
    endstruct

    //! runtextmacro Struct("Buttons")
        //! runtextmacro GetKey("KEY")
        //! runtextmacro GetKeyArray("KEY_ARRAY")
        //! runtextmacro GetKeyArray("KEY_ARRAY_DETAIL")
        //! runtextmacro GetKeyArray("PARENT_KEY_ARRAY")

        method GetFromSelf takes button self returns DialogButton
            return Memory.IntegerKeys.GetIntegerByHandle(self, KEY)
        endmethod

        method ClearNatives takes nothing returns nothing
            local DialogButton but
            local button butSelf
            local integer iteration = Dialog(this).Data.Integer.Table.Count(KEY_ARRAY)

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                set but = Dialog(this).Data.Integer.Table.Get(KEY_ARRAY, iteration)

                set butSelf = Memory.Native.GetButton(PARENT_KEY_ARRAY + this, KEY_ARRAY_DETAIL + but)

                call Memory.IntegerKeys.RemoveIntegerByHandle(butSelf, KEY)
                call Memory.Native.RemoveButton(PARENT_KEY_ARRAY + this, KEY_ARRAY_DETAIL + but)

                set iteration = iteration - 1
            endloop

            set butSelf = null

            call DialogClear(Dialog(this).self)
        endmethod

        method Clear takes nothing returns nothing
            call this.ClearNatives()

            call Dialog(this).Data.Integer.Table.Clear(KEY_ARRAY)
        endmethod

        method AddNative takes DialogButton but returns nothing
            local button butSelf = DialogAddButton(Dialog(this).self, but.text, but.hotkey)

            call Memory.IntegerKeys.SetIntegerByHandle(butSelf, KEY, but)
            call Memory.Native.SetButton(PARENT_KEY_ARRAY + this, KEY_ARRAY_DETAIL + but, butSelf)

            set butSelf = null
        endmethod

        method AddNatives takes nothing returns nothing
            local integer count = Dialog(this).Data.Integer.Table.Count(KEY_ARRAY)
            local integer iteration = Memory.IntegerKeys.Table.STARTED

            loop
                exitwhen (iteration > count)

                call this.AddNative(Dialog(this).Data.Integer.Table.Get(KEY_ARRAY, iteration))

                set iteration = iteration + 1
            endloop
        endmethod

        method UpdateNatives takes nothing returns nothing
            call this.ClearNatives()

            call this.AddNatives()
        endmethod

        method Remove takes DialogButton val returns nothing
            local DialogButton but
            local integer iteration

            call this.ClearNatives()

            call Dialog(this).Data.Integer.Table.Remove(KEY_ARRAY, val)
            call val.Data.Integer.Table.Remove(KEY_ARRAY, this)

            call this.AddNatives()
        endmethod

        static method Event_ButtonDestroy takes DialogButton val returns nothing
            local integer iteration = val.Data.Integer.Table.Count(KEY_ARRAY)
            local Dialog parent

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                set parent = val.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                call thistype(parent).Remove(val)

                set iteration = iteration - 1
            endloop
        endmethod

        method Destroy takes DialogButton val returns nothing
            call this.Remove(val)

            call val.Destroy()
        endmethod

        method Add takes DialogButton val returns nothing
            call Dialog(this).Data.Integer.Table.Add(KEY_ARRAY, val)
            call val.Data.Integer.Table.Add(KEY_ARRAY, this)

            call this.AddNative(val)
        endmethod

        method Create takes string text, integer hotkey returns DialogButton
            local DialogButton result = DialogButton.Create(text, hotkey)

            call this.Add(result)

            return result
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Dialog", "DIALOG")
    static EventType CLICK_EVENT_TYPE
    static Trigger CLICK_TRIGGER
    //! runtextmacro GetKey("KEY")
    //! runtextmacro GetKey("PLAYER_CUR_SHOWN_KEY")
    //! runtextmacro GetKeyArray("PLAYER_CUR_SHOWN_KEY_ARRAY")
    //! runtextmacro GetKey("PLAYER_SHOWN_KEY")
    //! runtextmacro GetKeyArray("PLAYER_SHOWN_KEY_ARRAY")

    dialog self

    //! runtextmacro CreateAnyFlagState("shown", "Shown")

    //! runtextmacro LinkToStruct("Dialog", "Buttons")
    //! runtextmacro LinkToStruct("Dialog", "Data")
    //! runtextmacro LinkToStruct("Dialog", "Event")
    //! runtextmacro LinkToStruct("Dialog", "Id")

    static method GetFromSelf takes dialog self returns thistype
        return Memory.IntegerKeys.GetIntegerByHandle(self, KEY)
    endmethod

    static method GetFromPlayer takes User whichPlayer returns thistype
        return whichPlayer.Data.Integer.Get(PLAYER_CUR_SHOWN_KEY)
    endmethod

    method GetSelf takes nothing returns dialog
        return this.self
    endmethod

    method Destroy takes nothing returns nothing
        local dialog self = this.self

        call this.deallocate()
        call DialogDestroy(self)

        set self = null
    endmethod

    method Show takes User whichPlayer returns nothing
        local boolean isFirst
        local integer iteration

        if (whichPlayer == User.ANY) then
            set iteration = User.PLAYING_HUMANS_COUNT

            loop
                call this.Show(User.PLAYING_HUMANS[iteration])

                set iteration = iteration - 1
                exitwhen (iteration < ARRAY_MIN)
            endloop

            return
        endif

        set isFirst = whichPlayer.Data.Integer.Table.IsEmpty(PLAYER_SHOWN_KEY_ARRAY)

        if ((isFirst == false) and whichPlayer.Data.Integer.Table.Contains(PLAYER_SHOWN_KEY_ARRAY, this)) then
            return
        endif

        call this.Data.Integer.Table.Add(PLAYER_SHOWN_KEY_ARRAY, whichPlayer)
        call whichPlayer.Data.Integer.Table.Add(PLAYER_SHOWN_KEY_ARRAY, this)

        if isFirst then
            call this.Data.Integer.Table.Add(PLAYER_CUR_SHOWN_KEY_ARRAY, whichPlayer)
            call whichPlayer.Data.Integer.Set(PLAYER_CUR_SHOWN_KEY, this)

            call DialogDisplay(whichPlayer.self, this.self, true)
        endif
    endmethod

    method Hide takes User whichPlayer returns nothing
        local boolean hasNext
        local integer iteration

        if (whichPlayer == User.ANY) then
            set iteration = User.PLAYING_HUMANS_COUNT

            loop
                call this.Hide(User.PLAYING_HUMANS[iteration])

                set iteration = iteration - 1
                exitwhen (iteration < ARRAY_MIN)
            endloop

            return
        endif

        if (whichPlayer.Data.Integer.Table.Contains(PLAYER_SHOWN_KEY_ARRAY, this) == false) then
            return
        endif

        call this.Data.Integer.Table.Remove(PLAYER_SHOWN_KEY_ARRAY, whichPlayer)
        call whichPlayer.Data.Integer.Table.Remove(PLAYER_SHOWN_KEY_ARRAY, this)

        if (thistype.GetFromPlayer(whichPlayer) == this) then
            call this.Data.Integer.Table.Remove(PLAYER_CUR_SHOWN_KEY_ARRAY, whichPlayer)

            if whichPlayer.Data.Integer.Table.IsEmpty(PLAYER_SHOWN_KEY_ARRAY) then
                call whichPlayer.Data.Integer.Remove(PLAYER_CUR_SHOWN_KEY)

                call DialogDisplay(whichPlayer.self, this.self, false)

                call MULTIBOARD.Shown.Update(whichPlayer)
            else
                set this = whichPlayer.Data.Integer.Table.GetFirst(PLAYER_SHOWN_KEY_ARRAY)

                call this.Data.Integer.Table.Add(PLAYER_CUR_SHOWN_KEY_ARRAY, whichPlayer)
                call whichPlayer.Data.Integer.Set(PLAYER_CUR_SHOWN_KEY, this)

                call DialogDisplay(whichPlayer.self, this.self, true)
            endif
        endif
    endmethod

    method Display takes User whichPlayer, boolean flag returns nothing
        if flag then
            call this.Show(whichPlayer)
        else
            call this.Hide(whichPlayer)
        endif
    endmethod

    method UpdateDisplay takes nothing returns nothing
        local integer iteration = this.Data.Integer.Table.Count(PLAYER_CUR_SHOWN_KEY_ARRAY)
        local User whichPlayer

        loop
            exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

            set whichPlayer = this.Data.Integer.Table.Get(PLAYER_CUR_SHOWN_KEY_ARRAY, iteration)

            call DialogDisplay(whichPlayer.self, this.self, true)

            set iteration = iteration - 1
        endloop
    endmethod

    method Click_TriggerEvents takes DialogButton but returns nothing
        local integer iteration = EventPriority.ALL_COUNT
        local integer iteration2
        local EventPriority priority

        local EventResponse params = EventResponse.Create(this.Id.Get())

        call params.Dialog.SetTrigger(this)
        call params.Dialog.SetTriggerButton(but)

        loop
            exitwhen (iteration < ARRAY_MIN)

            set priority = EventPriority.ALL[iteration]

            set iteration2 = this.Event.Count(thistype.CLICK_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call this.Event.Get(thistype.CLICK_EVENT_TYPE, priority, iteration2).Run(params)

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration - 1
        endloop

        call params.Destroy()
    endmethod

    trigMethod ClickTrig
        local DialogButton but = DIALOG_BUTTON.Event.Native.GetClicked()
        local thistype this = thistype(NULL).Event.Native.GetClicked()
        local User whichPlayer = USER.Event.Native.GetTrigger()

        call this.Hide(whichPlayer)

        call this.Click_TriggerEvents(but)

        if not whichPlayer.Data.Integer.Table.IsEmpty(PLAYER_SHOWN_KEY_ARRAY) then
            call thistype(whichPlayer.Data.Integer.Table.GetFirst(PLAYER_SHOWN_KEY_ARRAY)).Show(whichPlayer)
        endif
    endmethod

    method SetTitle takes string title returns nothing
        call DialogSetMessage(this.self, title)
    endmethod

    static method Create takes nothing returns thistype
        local dialog self = DialogCreate()
        local thistype this = thistype.allocate()

        set this.self = self
        call Memory.IntegerKeys.SetIntegerByHandle(self, KEY, this)

        set self = null
        call this.Id.Event_Create()

        call thistype.CLICK_TRIGGER.RegisterEvent.Dialog(this)

        return this
    endmethod

    initMethod Init of Header_4
        set thistype.CLICK_EVENT_TYPE = EventType.Create()
        set thistype.CLICK_TRIGGER = Trigger.CreateFromCode(function thistype.ClickTrig)

        call DialogButton.Init()
    endmethod
endstruct