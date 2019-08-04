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
                return DialogButton.GetFromSelf(GetClickedButton())
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Event")
        //! runtextmacro LinkToStruct("Event", "Native")
    endstruct
endscope

//! runtextmacro BaseStruct("DialogButton", "DIALOG_BUTTON")
    //! runtextmacro GetKey("KEY")

    button self

    //! runtextmacro LinkToStruct("DialogButton", "Data")
    //! runtextmacro LinkToStruct("DialogButton", "Event")
    //! runtextmacro LinkToStruct("DialogButton", "Id")

    static method GetFromSelf takes button self returns thistype
        return Memory.IntegerKeys.GetIntegerByHandle(self, KEY)
    endmethod

    static method Create takes Dialog whichDialog, string text, integer hotkey returns thistype
        local button self = DialogAddButton(whichDialog.self, text, hotkey)
        local thistype this = thistype.allocate()

        set this.self = self
        call Memory.IntegerKeys.SetIntegerByHandle(self, KEY, this)

        set self = null
        call this.Id.Event_Create()

        return this
    endmethod

    static method CreateQuit takes Dialog whichDialog, boolean showScores, string text, integer hotkey returns thistype
        local button self = DialogAddQuitButton(whichDialog.self, showScores, text, hotkey)
        local thistype this = thistype.allocate()

        set this.self = self
        call Memory.IntegerKeys.SetIntegerByHandle(self, KEY, this)

        set self = null

        return this
    endmethod

    static method Init takes nothing returns nothing
    endmethod
endstruct

//! runtextmacro Folder("Dialog")
    //! runtextmacro Folder("Event")
        //! runtextmacro Struct("Native")
            static method GetClicked takes nothing returns Dialog
                return Dialog.GetFromSelf(GetClickedDialog())
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Event")
        //! runtextmacro LinkToStruct("Event", "Native")
    endstruct
endscope

//! runtextmacro BaseStruct("Dialog", "DIALOG")
    //! runtextmacro GetKey("KEY")

    dialog self

    //! runtextmacro LinkToStruct("Dialog", "Event")

    static method GetFromSelf takes dialog self returns thistype
        return Memory.IntegerKeys.GetIntegerByHandle(self, KEY)
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

    method Display takes User whichPlayer, boolean flag returns nothing
        local integer iteration

        if (whichPlayer == User.ANY) then
            set iteration = User.HUMANS_COUNT

            loop
                call this.Display(User.HUMANS[iteration], flag)

                set iteration = iteration - 1
                exitwhen (iteration < ARRAY_MIN)
            endloop
        endif
        call DialogDisplay(whichPlayer.self, this.self, flag)
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

        return this
    endmethod

    static method Init takes nothing returns nothing
        call DialogButton.Init()
    endmethod
endstruct