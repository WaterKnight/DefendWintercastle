//! runtextmacro Folder("Rectangle")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("Rectangle", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("Rectangle", "Integer", "integer")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Integer")

        //! runtextmacro Data_Implement("Rectangle")
    endstruct
endscope

//! runtextmacro BaseStruct("Rectangle", "RECTANGLE")
    static thistype TEMP
    static thistype array TEMPS
    static thistype WORLD

    real centerX
    real centerY
    real maxX
    real maxY
    real minX
    real minY
    rect self

    //! runtextmacro LinkToStruct("Rectangle", "Data")
    //! runtextmacro LinkToStruct("Rectangle", "Id")

    method Remove takes nothing returns nothing
        local rect self = this.self

        call this.deallocate()
        call RemoveRect(self)

        set self = null
    endmethod

    method GetCenterX takes nothing returns real
        return this.centerX
    endmethod

    method GetCenterY takes nothing returns real
        return this.centerY
    endmethod

    method GetMaxX takes nothing returns real
        return this.maxX
    endmethod

    method GetMaxY takes nothing returns real
        return this.maxY
    endmethod

    method GetMinX takes nothing returns real
        return this.minX
    endmethod

    method GetMinY takes nothing returns real
        return this.minY
    endmethod

    method GetSelf takes nothing returns rect
        return this.self
    endmethod

    method ContainsCoords takes real x, real y returns boolean
        return not ((x < this.GetMinX()) or (y < this.GetMinY()) or (x > this.GetMaxX()) or (y > this.GetMaxY()))
    endmethod

    method RandomX takes nothing returns real
        return Math.Random(this.GetMinX(), this.GetMaxX())
    endmethod

    method RandomY takes nothing returns real
        return Math.Random(this.GetMinY(), this.GetMaxY())
    endmethod

    method Set takes real minX, real minY, real maxX, real maxY returns nothing
        set this.centerX = (minX + maxX) / 2
        set this.centerY = (minY + maxY) / 2
    	set this.minX = minX
    	set this.maxX = maxX
    	set this.minY = minY
    	set this.maxY = maxY
        call SetRect(this.self, minX, minY, maxX, maxY)
    endmethod

    static method CreateBasic takes real minX, real minY, real maxX, real maxY returns thistype
        local thistype this = thistype.allocate()

        set this.centerX = (minX + maxX) / 2
        set this.centerY = (minY + maxY) / 2
        set this.maxX = maxX
        set this.maxY = maxY
        set this.minX = minX
        set this.minY = minY

        return this
    endmethod

    static method Create takes real minX, real minY, real maxX, real maxY returns thistype
        local thistype this = CreateBasic(minX, minY, maxX, maxY)

        set this.self = Rect(minX, minY, maxX, maxY)

        call this.Id.Event_Create()

        return this
    endmethod

    static method CreateWithSize takes real x, real y, real width, real height returns thistype
        set height = height / 2.
        set width = width / 2.

        return thistype.Create(x - width, y - height, x + width, y + height)
    endmethod

    static method CreateFromSelf takes rect self returns thistype
        local thistype this = CreateBasic(GetRectMinX(self), GetRectMinY(self), GetRectMaxX(self), GetRectMaxY(self))

        set this.self = self

        call this.Id.Event_Create()

        return this
    endmethod

    static method Init takes nothing returns nothing
        set thistype.WORLD = thistype.CreateFromSelf(GetWorldBounds())
    endmethod
endstruct

//! runtextmacro Folder("Region")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("Region", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("Region", "Integer", "integer")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Integer")

        //! runtextmacro Data_Implement("Region")
    endstruct

    //! runtextmacro Folder("Event")
        //! runtextmacro Struct("Native")
            //! textmacro Region_Event_Native_CreateResponse takes name, source
                static method Get$name$ takes nothing returns Region
                    return Region.GetFromSelf($source$())
                endmethod
            //! endtextmacro

            //! runtextmacro Region_Event_Native_CreateResponse("Trigger", "GetTriggeringRegion")
        endstruct
    endscope

    //! runtextmacro Struct("Event")
        //! runtextmacro LinkToStruct("Event", "Native")

        //! runtextmacro CreateAnyStaticStateDefault("TRIGGER", "Trigger", "Region", "NULL")

        //! runtextmacro Event_Implement("Region")
    endstruct
endscope

//! runtextmacro BaseStruct("Region", "REGION")
	static EventType DESTROY_EVENT_TYPE
	static EventType ADD_RECT_EVENT_TYPE
	static Rectangle DUMMY_RECT
    //! runtextmacro GetKey("KEY")
    static EventType REMOVE_RECT_EVENT_TYPE

    static thistype TEMP
    static thistype array TEMPS

    region self

    //! runtextmacro LinkToStruct("Region", "Data")
    //! runtextmacro LinkToStruct("Region", "Event")
    //! runtextmacro LinkToStruct("Region", "Id")

    static method GetFromSelf takes region self returns thistype
        return Memory.IntegerKeys.GetIntegerByHandle(self, KEY)
    endmethod

    static method GetTrigger takes nothing returns thistype
        return GetFromSelf(GetTriggeringRegion())
    endmethod

	method ContainsUnit takes Unit whichUnit returns boolean
		return IsUnitInRegion(this.self, whichUnit.self)
	endmethod

    method RemoveRect_TriggerEvents takes Rectangle whichRect
        local EventResponse params = EventResponse.Create(this.Id.Get())

        call params.Region.SetTrigger(this)
        call params.Rect.SetTrigger(whichRect)

		local integer iteration = EventPriority.ALL_COUNT

        loop
            exitwhen (iteration < ARRAY_MIN)

            local EventPriority priority = EventPriority.ALL[iteration]

            local integer iteration2 = this.Event.Count(thistype.REMOVE_RECT_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call this.Event.Get(thistype.REMOVE_RECT_EVENT_TYPE, priority, iteration2).Run(params)

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration - 1
        endloop

        call params.Destroy()
    endmethod

    method RemoveRect takes Rectangle whichRect returns nothing
        call RegionClearRect(this.self, whichRect.self)

		call this.RemoveRect_TriggerEvents(whichRect)
    endmethod

	method RemoveCells takes real minX, real minY, real maxX, real maxY
		call thistype.DUMMY_RECT.Set(minX, minY, maxX, maxY)

		call this.RemoveRect(thistype.DUMMY_RECT)
	endmethod

	method Clear
		call this.RemoveRect(Rectangle.WORLD)
	endmethod

    method AddRect_TriggerEvents takes Rectangle whichRect
        local EventResponse params = EventResponse.Create(this.Id.Get())

        call params.Region.SetTrigger(this)
        call params.Rect.SetTrigger(whichRect)

		local integer iteration = EventPriority.ALL_COUNT

        loop
            exitwhen (iteration < ARRAY_MIN)

            local EventPriority priority = EventPriority.ALL[iteration]

            local integer iteration2 = this.Event.Count(thistype.ADD_RECT_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call this.Event.Get(thistype.ADD_RECT_EVENT_TYPE, priority, iteration2).Run(params)

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration - 1
        endloop

        call params.Destroy()
    endmethod

    method AddRect takes Rectangle whichRect returns nothing
        call RegionAddRect(this.self, whichRect.self)

		call this.AddRect_TriggerEvents(whichRect)
    endmethod

	method AddCells takes real minX, real minY, real maxX, real maxY
		call thistype.DUMMY_RECT.Set(minX, minY, maxX, maxY)

		call this.AddRect(thistype.DUMMY_RECT)
	endmethod

    method Destroy_TriggerEvents
        local EventResponse params = EventResponse.Create(this.Id.Get())

        call params.Region.SetTrigger(this)

		local integer iteration = EventPriority.ALL_COUNT

        loop
            exitwhen (iteration < ARRAY_MIN)

            local EventPriority priority = EventPriority.ALL[iteration]

            local integer iteration2 = this.Event.Count(thistype.DESTROY_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call this.Event.Get(thistype.DESTROY_EVENT_TYPE, priority, iteration2).Run(params)

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration - 1
        endloop

        call params.Destroy()
    endmethod

    method Destroy takes nothing returns nothing
        local region self = this.self

		call this.Destroy_TriggerEvents()

        call RemoveRegion(self)

        set self = null

		call this.deallocate()
    endmethod

    static method Create takes nothing returns thistype
        local thistype this = thistype.allocate()

        set this.self = CreateRegion()
        call Memory.IntegerKeys.SetIntegerByHandle(self, KEY, this)

        call this.Id.Event_Create()

        return this
    endmethod

    static method CreateFromRectangle takes Rectangle whichRect returns thistype
        local thistype this = thistype.Create()

        call this.AddRect(whichRect)

        return this
    endmethod

    initMethod Init of Header_2
        call Rectangle.Init()

		set thistype.DUMMY_RECT = Rectangle.Create(0, 0, 0, 0)

		set thistype.DESTROY_EVENT_TYPE = EventType.Create()
		set thistype.ADD_RECT_EVENT_TYPE = EventType.Create()
		set thistype.REMOVE_RECT_EVENT_TYPE = EventType.Create()
    endmethod
endstruct