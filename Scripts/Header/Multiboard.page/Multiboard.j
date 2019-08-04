//! runtextmacro BaseStruct("MultiboardItem", "MULTIBOARD_ITEM")
    //! runtextmacro GetKey("KEY")

    integer column
    integer row
    multiboarditem self

    string icon
    string value
    real width

    method Destroy takes nothing returns nothing
        local multiboarditem self = this.self

        call this.deallocate()
        call Memory.IntegerKeys.RemoveIntegerByHandle(self, KEY)

        call MultiboardReleaseItem(self)

        set self = null
    endmethod

    method SetIcon takes string value returns nothing
        set this.icon = value

        if (value == null) then
            call MultiboardSetItemStyle(this.self, true, false)
        else
            call MultiboardSetItemIcon(this.self, value)
            call MultiboardSetItemStyle(this.self, true, true)
        endif
    endmethod

    method SetValue takes string value returns nothing
        set this.value = value

        call MultiboardSetItemValue(this.self, value)
    endmethod

    method SetWidth takes real value returns nothing
        set this.width = value

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

    //! runtextmacro Struct("Title")
        //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "2")
        static Timer UPDATE_TIMER

        string text

        method Get takes nothing returns string
            return this.text
        endmethod

        method Update takes nothing returns nothing
            if MULTIBOARD.Shown.AdjustTitle() then
                return
            endif

            call MultiboardSetTitleText(Multiboard(this).self, String.Color.Do("[" + Real.ToStringWithDecimals(GetDebugTime(), 0) + "]\n", String.Color.DWC) + "\t" + this.Get())
        endmethod

        method Set takes string text returns nothing
            set this.text = text

            call this.Update()
        endmethod

        timerMethod UpdateByTimer
            local thistype this = MULTIBOARD.Shown.GetCurrent(User.GetLocal())

            if (this == NULL) then
                return
            endif

            call this.Update()
        endmethod

        eventMethod Event_Start
            call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.UpdateByTimer)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.UPDATE_TIMER = Timer.Create()
            call Event.Create(EventType.START, EventPriority.HEADER, function thistype.Event_Start).AddToStatics()
        endmethod
    endstruct

    //! runtextmacro Folder("Shown")
        //! runtextmacro Folder("Control")
            //! runtextmacro Struct("PageSwitch")
                static Event LEFT_EVENT
                static Event RIGHT_EVENT

                boolean active

                static method IsActive takes User whichPlayer returns boolean
                    return thistype(whichPlayer).active
                endmethod

                static method ChangeBoard takes Multiboard parent, User whichPlayer returns nothing
                    call parent.Shown.Show(whichPlayer)

                    call OptionsBoard.Event_MultiboardChange(parent, whichPlayer)
                    call StructInfo.Event_MultiboardChange(parent, whichPlayer)
                endmethod

                eventMethod Event_Left
                    local User whichPlayer = params.User.GetTrigger()

                    local Queue activeQueue = MULTIBOARD.Shown.GetActiveQueue(whichPlayer)

                    local Multiboard parent = activeQueue.GetPrev(MULTIBOARD.Shown.GetCurrent(whichPlayer))

                    if (parent == NULL) then
                        set parent = activeQueue.GetLast()
                    endif

                    call thistype.ChangeBoard(parent, whichPlayer)
                endmethod

                eventMethod Event_Right
                    local User whichPlayer = params.User.GetTrigger()

                    local Queue activeQueue = MULTIBOARD.Shown.GetActiveQueue(whichPlayer)

                    local Multiboard parent = activeQueue.GetNext(MULTIBOARD.Shown.GetCurrent(whichPlayer))

                    if (parent == NULL) then
                        set parent = activeQueue.GetFirst()
                    endif

                    call thistype.ChangeBoard(parent, whichPlayer)
                endmethod

                static method Deactivate takes User whichPlayer returns nothing
                    local thistype this = whichPlayer

                    if not this.active then
                        return
                    endif

                    set this.active = false

                    call whichPlayer.Event.Remove(thistype.LEFT_EVENT)
                    call whichPlayer.Event.Remove(thistype.RIGHT_EVENT)

                    call MULTIBOARD.Shown.GetCurrent(User.GetLocal()).Title.Update()
                endmethod

                static method Activate takes User whichPlayer returns nothing
                    local thistype this = whichPlayer

                    if this.active then
                        return
                    endif

                    set this.active = true

                    call whichPlayer.Event.Add(thistype.LEFT_EVENT)
                    call whichPlayer.Event.Add(thistype.RIGHT_EVENT)

                    call MULTIBOARD.Shown.GetCurrent(User.GetLocal()).Title.Update()
                endmethod

                static method Create takes User whichPlayer returns thistype
                    local thistype this = whichPlayer

                    set this.active = false

                    return this
                endmethod

                static method InitPlayers takes nothing returns nothing
                    local integer iteration = User.PLAYING_HUMANS_COUNT

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        local User curPlayer = User.PLAYING_HUMANS[iteration]

                        call thistype.Create(curPlayer)

                        set iteration = iteration - 1
                    endloop
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.LEFT_EVENT = Event.Create(USER.KeyEvent.LeftArrow.PRESS_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Left)
                    set thistype.RIGHT_EVENT = Event.Create(USER.KeyEvent.RightArrow.PRESS_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Right)

                    call thistype.InitPlayers()
                endmethod
            endstruct
        endscope

        //! runtextmacro Struct("Control")
            boolean active

            //! runtextmacro LinkToStruct("Control", "PageSwitch")

            static method Deactivate takes User whichPlayer returns nothing
                local thistype this = whichPlayer

                if not this.active then
                    return
                endif

                set this.active = false

                call Camera.Unlock(whichPlayer)

                call OptionsBoard.Event_MultiboardControlDeactivate(whichPlayer)
                call StructInfo.Event_MultiboardControlDeactivate(whichPlayer)

                call thistype(NULL).PageSwitch.Deactivate(whichPlayer)
            endmethod

            static method Activate takes User whichPlayer returns nothing
                local thistype this = whichPlayer

                if this.active then
                    return
                endif

                set this.active = true

                call Camera.Lock(whichPlayer)

                call OptionsBoard.Event_MultiboardControlActivate(whichPlayer)
                call StructInfo.Event_MultiboardControlActivate(whichPlayer)

                call thistype(NULL).PageSwitch.Activate(whichPlayer)
            endmethod

            eventMethod Event_Esc
                local User whichPlayer = params.User.GetTrigger()

                local thistype this = whichPlayer

                if this.active then
                    call thistype.Deactivate(whichPlayer)

                    return
                endif

                call thistype.Activate(whichPlayer)
            endmethod

            static method Create takes User whichPlayer returns thistype
                local thistype this = whichPlayer

                set this.active = false

                return this
            endmethod

            static method InitPlayers takes nothing returns nothing
                local integer iteration = User.PLAYING_HUMANS_COUNT

                loop
                    exitwhen (iteration < ARRAY_MIN)

                    local User curPlayer = User.PLAYING_HUMANS[iteration]

                    call thistype.Create(curPlayer)

                    set iteration = iteration - 1
                endloop
            endmethod

            static method Init takes nothing returns nothing
                call Event.Create(USER.KeyEvent.ESC_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Esc).AddToStatics()

                call thistype.InitPlayers()

                call thistype(NULL).PageSwitch.Init()
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Shown")
        Queue activeQueue
        Multiboard current

        //! runtextmacro LinkToStruct("Shown", "Control")

        static method GetCurrent takes User whichPlayer returns Multiboard
            local thistype this = whichPlayer

            return this.current
        endmethod

        static method GetActiveQueue takes User whichPlayer returns Multiboard
            local thistype this = whichPlayer

            return this.activeQueue
        endmethod

        static method AdjustTitle takes nothing returns boolean
            local User whichPlayer = User.GetLocal()

            local Multiboard parent = thistype.GetCurrent(whichPlayer)

            local thistype this = whichPlayer

            if thistype(NULL).Control.PageSwitch.IsActive(whichPlayer) then
                call MultiboardSetTitleText(parent.self, String.Color.Do("<<<", String.Color.GOLD) + " " + Integer.ToString(this.activeQueue.GetIndex(parent) + 1) + "/" + Integer.ToString(this.activeQueue.Count() + 1) + " - " + String.Color.Do(parent.Title.Get(), String.Color.BONUS) + " " + String.Color.Do(">>>", String.Color.GOLD))

                return true
            endif

            return false
        endmethod

        method Show takes User whichPlayer returns nothing
            local Multiboard parent = this

            set this = whichPlayer

            set this.current = parent

            if not whichPlayer.IsLocal() then
                return
            endif

            call MultiboardDisplay(parent.self, true)
            call MultiboardMinimize(parent.self, false)

            call parent.Title.Update()
        endmethod

        method Event_Destroy takes nothing returns nothing
        	local Multiboard parent = this

            local integer iteration = User.PLAYING_HUMANS_COUNT

            loop
                exitwhen (iteration < ARRAY_MIN)

                local User curPlayer = User.PLAYING_HUMANS[iteration]

                set this = curPlayer

                call this.activeQueue.Remove(parent)

                if (this.current == parent) then
                    local Multiboard new = this.activeQueue.GetFirst()

                    if (new == NULL) then
                        set this.current = NULL
                    else
                        call new.Show(curPlayer)
                    endif
                endif

                set iteration = iteration - 1
            endloop

            call parent.Title.Update()
        endmethod

        method Event_Show takes User whichPlayer returns nothing
            local Multiboard parent = this

            set this = whichPlayer

            if this.activeQueue.Add(parent) then
                call thistype(parent).Show(whichPlayer)
            else
                call parent.Title.Update()
            endif
        endmethod

        static method Create takes User whichPlayer returns thistype
            local thistype this = whichPlayer

            set this.activeQueue = Queue.Create()
            set this.current = NULL

            return this
        endmethod

        static method Update takes User whichPlayer returns nothing
            if not whichPlayer.IsLocal() then
                return
            endif

            local thistype this = whichPlayer

            if (this.current == NULL) then
                return
            endif

            call MultiboardDisplay(this.current.self, true)
        endmethod

        static method InitPlayers takes nothing returns nothing
            local integer iteration = User.PLAYING_HUMANS_COUNT

            loop
                exitwhen (iteration < ARRAY_MIN)

                local User curPlayer = User.PLAYING_HUMANS[iteration]

                call thistype.Create(curPlayer)

                set iteration = iteration - 1
            endloop
        endmethod

        static method Init takes nothing returns nothing
            call thistype.InitPlayers()

            call thistype(NULL).Control.Init()
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Multiboard", "MULTIBOARD")
    //! runtextmacro GetKeyArray("ITEMS_KEY_ARRAY")
    static constant integer MAX_COLUMN_AMOUNT = 50
    static constant integer MAX_ROW_AMOUNT = 32
    static thistype TEMP

    integer columnCount = -1
    integer rowCount = -1
    multiboard self

    //! runtextmacro LinkToStruct("Multiboard", "Column")
    //! runtextmacro LinkToStruct("Multiboard", "ColumnSpan")
    //! runtextmacro LinkToStruct("Multiboard", "Row")
    //! runtextmacro LinkToStruct("Multiboard", "Shown")
    //! runtextmacro LinkToStruct("Multiboard", "Title")

    method GetItem takes integer row, integer column returns MultiboardItem
        //return MultiboardGetItem(this.self, row, column)
        return Memory.IntegerKeys.GetIntegerByHandle(this.self, ITEMS_KEY_ARRAY + row * thistype.MAX_COLUMN_AMOUNT + column)
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
        local integer columnCount = this.GetColumnCount()
        local integer rowCount = this.GetRowCount()
        local multiboard self = this.self

        set this.columnCount = count

		local integer column
		local integer row

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
        local integer columnCount = this.GetColumnCount()
        local integer row = this.GetRowCount()
        local multiboard self = this.self

        set this.rowCount = count

		local integer column

        if (count > row) then
            set row = row + 1

			local integer i = row

			loop
				exitwhen (i > count)

            	call MultiboardSetRowCount(self, i + 1)

				set i = i + 1
            endloop

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

			set row = row - 1

			loop
				exitwhen (row < count)

            	call MultiboardSetRowCount(self, row + 1)

            	set row = row - 1
            endloop
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

    method SetTitle takes string val returns nothing
        call this.Title.Set(val)
    endmethod

	method ClearVals takes nothing returns nothing
        local integer columnCount = this.GetColumnCount()
        local integer rowCount = this.GetRowCount()

		local integer col = columnCount

		loop
			exitwhen (col < ARRAY_MIN)

			local integer row = rowCount

			loop
				exitwhen (row < ARRAY_MIN)

				call this.GetItem(row, col).SetValue("")

				set row = row - 1
			endloop

			set col = col - 1
		endloop
	endmethod

    method SetValue takes integer row, integer column, string value returns nothing
        call this.CheckCellAvailable(row, column)

        call this.GetItem(row, column).SetValue(value)
    endmethod

    method SetWidth takes integer row, integer column, real value returns nothing
        call this.CheckCellAvailable(row, column)

        call this.GetItem(row, column).SetWidth(value)
    endmethod

    method Show takes User whichPlayer returns nothing
        call this.Shown.Event_Show(whichPlayer)
    endmethod

    execMethod Create_Executed
        local thistype this = thistype.TEMP

        local multiboard self = this.self

		local integer column = 0

        loop
            local integer row = 0

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
        set this.rowCount = -1
        set this.self = CreateMultiboard()

        set thistype.TEMP = this

        call Code.Run(function thistype.Create_Executed)

        return this
    endmethod

    initMethod Init of Header_5
        call thistype(NULL).Shown.Init()
        call thistype(NULL).Title.Init()
    endmethod
endstruct