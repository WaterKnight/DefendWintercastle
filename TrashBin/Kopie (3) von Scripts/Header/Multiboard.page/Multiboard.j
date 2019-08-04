//! runtextmacro BaseStruct("MultiboardItem", "MULTIBOARD_ITEM")
    //! runtextmacro GetKey("KEY")

    integer column
    integer row
    multiboarditem self

    method Destroy takes nothing returns nothing
        local multiboarditem self = this.self

        call this.deallocate()
        call Memory.IntegerKeys.RemoveIntegerByHandle(self, KEY)

        call MultiboardReleaseItem(self)

        set self = null
    endmethod

    method SetIcon takes string value returns nothing
        if (value == null) then
            call MultiboardSetItemStyle(this.self, true, false)
        else
            call MultiboardSetItemIcon(this.self, value)
            call MultiboardSetItemStyle(this.self, true, true)
        endif
    endmethod

    method SetValue takes string value returns nothing
        call MultiboardSetItemValue(this.self, value)
    endmethod

    method SetWidth takes real value returns nothing
        call MultiboardSetItemWidth(this.self, value)
    endmethod

    method Use takes nothing returns nothing
        call this.SetIcon(null)
        call this.SetWidth(0.)
    endmethod

    static method Create takes Multiboard whichBoard, integer row, integer column returns thistype
        local thistype this = thistype.allocate()

        set this.column = column
        set this.row = row
        set this.self = MultiboardGetItem(whichBoard.self, row, column)
        call Memory.IntegerKeys.SetIntegerByHandle(self, KEY, this)

        return this
    endmethod
endstruct

//! runtextmacro Folder("Multiboard")
    //! runtextmacro Struct("Column")
        method SetIcon takes integer column, string iconPath returns nothing
            local integer row = Multiboard(this).GetRowCount()

            loop
                exitwhen (row < 0)

                call Multiboard(this).SetIcon(row, column, iconPath)

                set row = row - 1
            endloop
        endmethod

        method SetWidth takes integer column, real value returns nothing
            local integer row = Multiboard(this).GetRowCount()

            loop
                exitwhen (row < 0)

                call Multiboard(this).SetWidth(row, column, value)

                set row = row - 1
            endloop
        endmethod
    endstruct

    //! runtextmacro Struct("ColumnSpan")
        method SetIcon takes integer row, integer columnStart, integer columnEnd, string iconPath returns nothing
            if (columnStart > columnEnd) then
                call this.SetIcon(row, columnEnd, columnStart, iconPath)
            else
                loop
                    exitwhen (columnStart > columnEnd)

                    call Multiboard(this).SetIcon(row, columnStart, iconPath)

                    set columnStart = columnStart + 1
                endloop
            endif
        endmethod

        method SetWidth takes integer row, integer columnStart, integer columnEnd, real value returns nothing
            if (columnStart > columnEnd) then
                call this.SetWidth(row, columnEnd, columnStart, value)
            else
                loop
                    exitwhen (columnStart > columnEnd)

                    call Multiboard(this).SetWidth(row, columnStart, value)

                    set columnStart = columnStart + 1
                endloop
            endif
        endmethod
    endstruct

    //! runtextmacro Struct("Row")
        method SetIcon takes integer row, string iconPath returns nothing
            call Multiboard(this).ColumnSpan.SetIcon(row, 0, Multiboard(this).GetColumnCount(), iconPath)
        endmethod

        method SetWidth takes integer row, real value returns nothing
            call Multiboard(this).ColumnSpan.SetWidth(row, 0, Multiboard(this).GetColumnCount(), value)
        endmethod
    endstruct

    //! runtextmacro Struct("Shown")
        static thistype CURRENT = NULL
        static constant real UPDATE_TIME = FRAME_UPDATE_TIME

        /*method GetIndex takes nothing returns integer
            return this.index
        endmethod*/

        method SetIndex takes integer index returns nothing
            set this.index = index
            set thistype.ALL[index] = this
        endmethod

        static method AdjustTitle takes nothing returns nothing
            call MultiboardSetTitleText(Multiboard(thistype.CURRENT).self, Integer.ToString(thistype.CURRENT.index + 1) + "/" + Integer.ToString(thistype.ALL_COUNT + 1) + " - " +Multiboard(thistype.CURRENT).GetTitle())
        endmethod

        method Show takes nothing returns nothing
            set thistype.CURRENT = this
            call MultiboardDisplay(Multiboard(this).self, true)
            call MultiboardMinimize(Multiboard(this).self, false)
        endmethod

        method Event_Destroy takes nothing returns nothing
            local integer index = this.index

            local boolean empty = this.RemoveFromListSorted()

            if (this == thistype.CURRENT) then
                if (empty) then
                    set thistype.CURRENT = NULL
                else
                    if (thistype.ALL_COUNT < index) then
                        call thistype.ALL[ARRAY_MIN].Show()
                    else
                        call thistype.ALL[index].Show()
                    endif

                    call thistype.AdjustTitle()
                endif
            endif
        endmethod

        method Event_Show takes nothing returns nothing
            if (index == ARRAY_MIN) then
                call this.Show()
            endif

            call thistype.AdjustTitle()

            call this.AddToList()
        endmethod

        static method Update takes nothing returns nothing
            if (thistype.CURRENT == NULL) then
                return
            endif

            if (IsMultiboardMinimized(Multiboard(thistype.CURRENT).self)) then
                if (thistype.CURRENT == thistype.ALL[thistype.ALL_COUNT]) then
                    if (thistype.ALL_COUNT != ARRAY_MIN) then
                        call thistype.ALL[ARRAY_MIN].Show()
                    endif
                else
                    call thistype.ALL[thistype.CURRENT.index + 1].Show()
                endif

                call thistype.AdjustTitle()
                call OptionsBoard.Event_MultiboardChange(User.GetLocal())
            else
                call MultiboardDisplay(Multiboard(thistype.CURRENT).self, true)
            endif
        endmethod

        static method Event_Start takes nothing returns nothing
            call Timer.Create().Start(UPDATE_TIME, true, function thistype.Update)
        endmethod

        static method Init takes nothing returns nothing
            call Event.Create(EventType.START, EventPriority.HEADER, function thistype.Event_Start).AddToStatics()
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Multiboard", "MULTIBOARD")
    //! runtextmacro GetKeyArray("ITEMS_KEY_ARRAY")
    static constant integer MAX_COLUMN_AMOUNT = 50
    static constant integer MAX_ROW_AMOUNT = 20
    static thistype TEMP

    integer columnCount = -1
    boolean displayed
    integer rowCount = -1
    multiboard self
    string title

    //! runtextmacro LinkToStruct("Multiboard", "Column")
    //! runtextmacro LinkToStruct("Multiboard", "ColumnSpan")
    //! runtextmacro LinkToStruct("Multiboard", "Row")
    //! runtextmacro LinkToStruct("Multiboard", "Shown")

    method GetItem takes integer row, integer column returns MultiboardItem
        //return MultiboardGetItem(this.self, row, column)
        return Memory.IntegerKeys.GetIntegerByHandle(this.self, ITEMS_KEY_ARRAY + row * thistype.MAX_COLUMN_AMOUNT + column)
    endmethod

    method GetTitle takes nothing returns string
        return this.title
    endmethod

    method SetItem takes integer row, integer column returns nothing
        //local MultiboardItem newItem = MultiboardItem.Create(this, row, column)

        //call Memory.IntegerKeys.SetIntegerByHandle(self, ITEMS_KEY_ARRAY + row * thistype.MAX_COLUMN_AMOUNT + column, newItem)
        call this.GetItem(row, column).Use()
    endmethod

    method CreateItem takes integer row, integer column, multiboard self returns nothing
        local MultiboardItem newItem = MultiboardItem.Create(this, row, column)

        call Memory.IntegerKeys.SetIntegerByHandle(self, ITEMS_KEY_ARRAY + row * thistype.MAX_COLUMN_AMOUNT + column, newItem)
    endmethod

    method GetColumnCount takes nothing returns integer
        return this.columnCount
    endmethod

    method GetRowCount takes nothing returns integer
        return this.rowCount
    endmethod

    method SetColumnCount takes integer count returns nothing
        local integer column
        local integer columnCount = this.GetColumnCount()
        local integer row
        local integer rowCount = this.GetRowCount()
        local multiboard self = this.self

        set this.columnCount = count
        if (count > columnCount) then
            set column = columnCount + 1
            call MultiboardSetColumnCount(self, count + 1)

            loop
                exitwhen (column > count)

                set row = rowCount

                loop
                    exitwhen (row < ARRAY_MIN)

                    call this.SetItem(row, column)

                    set row = row - 1
                endloop

                set column = column + 1
            endloop
        elseif (count < columnCount) then
            set column = columnCount

            loop
                exitwhen (column < ARRAY_MIN)

                set row = rowCount

                loop
                    exitwhen (row < ARRAY_MIN)

                    call this.SetItem(row, column)

                    set row = row - 1
                endloop

                set column = column - 1
            endloop

            /*set column = columnCount

            loop
                set row = rowCount

                loop
                    exitwhen (row < ARRAY_MIN)

                    call this.GetItem(row, column).Destroy()

                    set row = row - 1
                endloop

                set column = column - 1
                exitwhen (column < count)
            endloop*/

            call MultiboardSetColumnCount(self, count + 1)
        endif

        set self = null
    endmethod

    method SetRowCount takes integer count returns nothing
        local integer column
        local integer columnCount = this.GetColumnCount()
        local integer row = this.GetRowCount()
        local multiboard self = this.self

        set this.rowCount = count
        if (count > row) then
            set row = row + 1
            call MultiboardSetRowCount(self, count + 1)

            loop
                exitwhen (row > count)

                set column = columnCount

                loop
                    exitwhen (column < ARRAY_MIN)

                    call this.SetItem(row, column)

                    set column = column - 1
                endloop

                set row = row + 1
            endloop
        elseif (count < row) then
            /*loop
                set column = 0

                loop
                    exitwhen (column > columnCount)

                    call this.GetItem(row, column).Destroy()

                    set column = column + 1
                endloop

                set row = row - 1
                exitwhen (row < count)
            endloop*/

            call MultiboardSetRowCount(self, count + 1)
        endif

        set self = null
    endmethod

    method Destroy takes nothing returns nothing
        local multiboard self = this.self

        call this.SetColumnCount(-1)
        call this.SetRowCount(-1)

        call this.Shown.Event_Destroy()

        call this.deallocate()
        call DestroyMultiboard(self)

        set self = null
    endmethod

    method AddColumnCount takes integer amount returns nothing
        call this.SetColumnCount(this.GetColumnCount() + amount)
    endmethod

    method GetNewColumn takes nothing returns integer
        local integer count = this.GetColumnCount() + 1

        call this.SetColumnCount(count)

        return count
    endmethod

    method AddRowCount takes integer amount returns nothing
        call this.SetRowCount(this.GetRowCount() + amount)
    endmethod

    method GetNewRow takes nothing returns integer
        local integer count = this.GetRowCount() + 1

        call this.SetRowCount(count)

        return count
    endmethod

    method CheckCellAvailable takes integer row, integer column returns nothing
        if (column > this.columnCount) then
            call this.SetColumnCount(column)
        endif
        if (row > this.rowCount) then
            call this.SetRowCount(row)
        endif
    endmethod

    method SetIcon takes integer row, integer column, string value returns nothing
        call this.CheckCellAvailable(row, column)

        call this.GetItem(row, column).SetIcon(value)
    endmethod

    method SetTitle takes string title returns nothing
        set this.title = title
        call MultiboardSetTitleText(this.self, title)
    endmethod

    method SetValue takes integer row, integer column, string value returns nothing
        //call this.CheckCellAvailable(row, column)

        call this.GetItem(row, column).SetValue(value)
    endmethod

    method SetWidth takes integer row, integer column, real value returns nothing
        //call this.CheckCellAvailable(row, column)

        call this.GetItem(row, column).SetWidth(value)
    endmethod

    method Show takes nothing returns nothing
        if (this.displayed) then
            return
        endif

        set this.displayed = true
        call this.Shown.Event_Show()
    endmethod

    static method Create_Executed takes nothing returns nothing
        local integer column = 0
        local integer row
        local thistype this = thistype.TEMP

        local multiboard self = this.self

        loop
            set row = 0

            loop
                call this.CreateItem(row, column, self)

                set row = row + 1
                exitwhen (row == thistype.MAX_ROW_AMOUNT)
            endloop

            set column = column + 1
            exitwhen (column == thistype.MAX_COLUMN_AMOUNT)
        endloop

        set self = null
    endmethod

    static method Create takes nothing returns Multiboard
        local thistype this = thistype.allocate()

        set this.columnCount = -1
        set this.displayed = false
        set this.rowCount = -1
        set this.self = CreateMultiboard()

        set thistype.TEMP = this

        call thistype.Create_Executed.execute()

        return this
    endmethod

    static method Init takes nothing returns nothing
        call thistype(NULL).Shown.Init()
    endmethod
endstruct