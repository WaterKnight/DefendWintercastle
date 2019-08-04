//! runtextmacro BaseStruct("StructInfo", "STRUCT_INFO")
    static integer array SELECTABLE_ROWS
    static integer SELECTABLE_ROWS_COUNT = ARRAY_EMPTY
    static integer array SELECTABLE_ROWS_INDIZES
    static string array SELECTABLE_ROWS_LABEL
    static string array SELECTABLE_ROWS_VALUE
    static Multiboard THIS_BOARD = NULL
    static Timer UPDATE_TIMER

    static integer LABEL_COLUMN
    static integer VALUE_COLUMN

	static integer FIRST_STRUCT_ROW
	static integer HEAD_ROW
	static integer PAGE_ROW

	static constant real LABEL_COLUMN_WIDTH = 0.2
	static constant real VALUE_COLUMN_WIDTH = 0.05

    boolean active
    User owner
    integer pageIndex
    integer selectedRow
    integer selectedRowIndex

    Event downEvent
    Event leftEvent
    Event rightEvent
    Event upEvent

	method UpdatePageDisplay takes nothing returns nothing
		local integer pageRowIndex = thistype.SELECTABLE_ROWS_INDIZES[thistype.PAGE_ROW]

		call thistype.THIS_BOARD.SetValue(thistype.PAGE_ROW, thistype.LABEL_COLUMN, thistype.SELECTABLE_ROWS_LABEL[pageRowIndex])

		local integer index = this.pageIndex

		local string s = Integer.ToString(index + 1) + "/" + Integer.ToString(thistype.PAGES_COUNT + 1)

		set thistype.SELECTABLE_ROWS_VALUE[pageRowIndex] = s

		if (this.selectedRow == thistype.PAGE_ROW) then
			set s = String.If((index > 0), String.Color.Do("<<< ", String.Color.GOLD)) + String.Color.Do(s, String.Color.GREEN) + String.If((index < thistype.PAGES_COUNT), String.Color.Do(" >>>", String.Color.GOLD))
		endif

		call thistype.THIS_BOARD.SetValue(thistype.PAGE_ROW, thistype.VALUE_COLUMN, s)
	endmethod

    method DeselectRowByIndex takes integer index returns nothing
        if (index == ARRAY_EMPTY) then
            return
        endif

        local integer row = thistype.SELECTABLE_ROWS[index]

        if this.owner.IsLocal() then
            call thistype.THIS_BOARD.SetValue(row, thistype.LABEL_COLUMN, thistype.SELECTABLE_ROWS_LABEL[index])
            call thistype.THIS_BOARD.SetValue(row, thistype.VALUE_COLUMN, thistype.SELECTABLE_ROWS_VALUE[index])
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
            set whichRow = ARRAY_EMPTY
        else
            set whichRow = thistype.SELECTABLE_ROWS[index]
        endif

        set this.selectedRow = whichRow

        if (whichRow == ARRAY_EMPTY) then
            call MULTIBOARD.Shown.Control.PageSwitch.Activate(this.owner)
        else
            call MULTIBOARD.Shown.Control.PageSwitch.Deactivate(this.owner)
        endif

        if not this.owner.IsLocal() then
            return
        endif

        if (whichRow == thistype.PAGE_ROW) then
            call this.UpdatePageDisplay()
        endif
    endmethod

	static integer PAGES_COUNT
	static constant integer STRUCTS_PER_PAGE = 30

	method SetPage takes integer index returns nothing
		call thistype.THIS_BOARD.ClearVals()

		set this.pageIndex = index

		call this.UpdatePageDisplay()

		local integer i = ARRAY_MIN + index * thistype.STRUCTS_PER_PAGE
		local integer iEnd = ARRAY_MIN + (index + 1) * thistype.STRUCTS_PER_PAGE - 1
		local integer c = 0

		call thistype.THIS_BOARD.SetRowCount(thistype.FIRST_STRUCT_ROW + Math.MinI(thistype.STRUCTS_PER_PAGE, Basic.ALLOC_MODULES_COUNT - i + 1) - 1)

        call thistype.THIS_BOARD.Column.SetWidth(thistype.LABEL_COLUMN, thistype.LABEL_COLUMN_WIDTH)
        call thistype.THIS_BOARD.Column.SetWidth(thistype.VALUE_COLUMN, thistype.VALUE_COLUMN_WIDTH)

		//call thistype.THIS_BOARD.SetValue(thistype.PAGE_ROW + 1, thistype.LABEL_COLUMN, "abc")
		//call thistype.THIS_BOARD.SetValue(thistype.PAGE_ROW + 1, thistype.VALUE_COLUMN, "def")

		loop
			exitwhen (i > iEnd)
			exitwhen (i > Basic.ALLOC_MODULES_COUNT)

			local integer moduleIndex = Basic.GetAllocModuleFromQueue(i)

			call thistype.THIS_BOARD.SetValue(thistype.FIRST_STRUCT_ROW + c, thistype.LABEL_COLUMN, Basic.GetAllocModuleName(moduleIndex))
			call thistype.THIS_BOARD.SetValue(thistype.FIRST_STRUCT_ROW + c, thistype.VALUE_COLUMN, Integer.ToString(Basic.GetAllocModuleAllocCount(moduleIndex)))

			set i = i + 1
			set c = c + 1
		endloop
	endmethod

	timerMethod UpdateByTimer
		local thistype this = thistype(User.GetLocal())

		if not this.active then
			return
		endif

		call this.SetPage(this.pageIndex)
	endmethod

    eventMethod Event_Left
        local real intervalWeight = params.Real.GetIntervalWeight()
        local User owner = params.User.GetTrigger()

        local thistype this = owner

        local integer whichRow = this.selectedRow

        if (whichRow == thistype.PAGE_ROW) then
            if (this.pageIndex > 0) then
            	call this.SetPage(this.pageIndex - 1)
            endif
        endif

        if not owner.IsLocal() then
            return
        endif

    endmethod

    eventMethod Event_Right
        local real intervalWeight = params.Real.GetIntervalWeight()
        local User owner = params.User.GetTrigger()

        local thistype this = owner

        local integer whichRow = this.selectedRow

        if (whichRow == thistype.PAGE_ROW) then
            if (this.pageIndex < thistype.PAGES_COUNT) then
            	call this.SetPage(this.pageIndex + 1)
            endif
        endif

        if not owner.IsLocal() then
            return
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
        set this.leftEvent = owner.KeyEvent.LeftArrow.RegisterPress(EventPriority.MISC, function thistype.Event_Left, 0.125, 1.)
        set this.rightEvent = owner.KeyEvent.RightArrow.RegisterPress(EventPriority.MISC, function thistype.Event_Right, 0.125, 1.)
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
        set this.pageIndex = -1
        set this.owner = owner
        set this.selectedRow = ARRAY_EMPTY
        set this.selectedRowIndex = ARRAY_EMPTY

        call thistype.THIS_BOARD.Show(owner)

		call this.SetPage(40)

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

		set thistype.PAGES_COUNT = Math.DivCeilI(Basic.ALLOC_MODULES_AMOUNT, thistype.STRUCTS_PER_PAGE) - 1

		//set thistype.HEAD_ROW = thistype.GetNewRow()

		//call thistype.THIS_BOARD.SetValue(thistype.HEAD_ROW, thistype.LABEL_COLUMN, String.Color.Do("Struct allocation information", String.Color.GOLD))

		set thistype.PAGE_ROW = thistype.GetNewSelectableRow("Page", "")

		set thistype.FIRST_STRUCT_ROW = thistype.THIS_BOARD.GetRowCount() + 2

        call thistype.THIS_BOARD.Column.SetWidth(thistype.LABEL_COLUMN, thistype.LABEL_COLUMN_WIDTH)
        call thistype.THIS_BOARD.Column.SetWidth(thistype.VALUE_COLUMN, thistype.VALUE_COLUMN_WIDTH)
        call thistype.THIS_BOARD.SetTitle("StructInfo")

        call Event.Create(AfterIntro.FOR_PLAYER_EVENT_TYPE, EventPriority.MISC, function thistype.Event_AfterIntro).AddToStatics()

		set thistype.UPDATE_TIMER = Timer.Create()

		call thistype.UPDATE_TIMER.Start(1., true, function thistype.UpdateByTimer)
    endmethod

    initMethod Init of Misc_2
        call Event.Create(EventType.START, EventPriority.MISC, function thistype.Event_Start).AddToStatics()
    endmethod
endstruct