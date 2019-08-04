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
    static thistype ROSA
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
        return (((x < this.GetMinX()) or (y < this.GetMinY()) or (x > this.GetMaxX()) or (y > this.GetMaxY())) == false)
    endmethod

    method RandomX takes nothing returns real
        return Math.Random(this.GetMinX(), this.GetMaxX())
    endmethod

    method RandomY takes nothing returns real
        return Math.Random(this.GetMinY(), this.GetMaxY())
    endmethod

    method Set takes real minX, real minY, real maxX, real maxY returns nothing
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
        set thistype.ROSA = Rectangle.CreateFromSelf(gg_rct_Rosa)
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
                method Count takes integer key returns integer
                    return Memory.IntegerKeys.Table.CountIntegers(Region(this).Id.Get(), key)
                endmethod

                method Remove takes integer key, integer value returns nothing
                    call Memory.IntegerKeys.Table.RemoveInteger(Region(this).Id.Get(), key, value)
                endmethod

                method Get takes integer key, integer index returns integer
                    return Memory.IntegerKeys.Table.GetInteger(Region(this).Id.Get(), key, index)
                endmethod

                method Add takes integer key, integer value returns nothing
                    call Memory.IntegerKeys.Table.AddInteger(Region(this).Id.Get(), key, value)
                endmethod
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            method Remove takes integer key returns nothing
                call Memory.IntegerKeys.RemoveInteger(Region(this).Id.Get(), key)
            endmethod

            method Get takes integer key returns integer
                return Memory.IntegerKeys.GetInteger(Region(this).Id.Get(), key)
            endmethod

            method Set takes integer key, integer value returns nothing
                call Memory.IntegerKeys.SetInteger(Region(this).Id.Get(), key, value)
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Integer")

        method Destroy takes nothing returns nothing
            call Memory.IntegerKeys.RemoveChild(Region(this).Id.Get())
        endmethod
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
    //! runtextmacro GetKey("KEY")
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

    method Remove takes nothing returns nothing
        local region self = this.self

        call this.deallocate()
        call RemoveRegion(self)

        set self = null
    endmethod

    method AddRect takes Rectangle whichRect returns nothing
        call RegionAddRect(this.self, whichRect.self)
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

    static method Init takes nothing returns nothing
        call Rectangle.Init()
    endmethod
endstruct