//! runtextmacro Folder("Group")
    //! runtextmacro Struct("Refs")
        boolean waiting

        //! runtextmacro CreateSimpleAddState_OnlyGet("integer")

        method CheckForDestroy takes nothing returns boolean
            if (this.Get() > 0) then
                set this.waiting = true

                return false
            endif

            return true
        endmethod

        method Add takes nothing returns nothing
            set this.value = this.Get() + 1
        endmethod

        method Remove takes nothing returns nothing
            local integer value = this.Get() - 1

            set this.value = value

            if ((value == 0) and (this.waiting)) then
                call Group(this).Destroy()
            endif
        endmethod

        method Event_Create takes nothing returns nothing
            set this.value = 0
            set this.waiting = false
        endmethod
    endstruct

    //! textmacro Group_CreateUnitBoolExprAdapter takes name, target
        static method $name$ takes nothing returns boolean
            if ($target$(UNIT.Event.Native.GetFilter()) == false) then
                return false
            endif

            return true
        endmethod
    //! endtextmacro

    //! runtextmacro Struct("CountUnits")
        static Group ENUM_GROUP

        method Do takes nothing returns integer
            local Unit enumUnit
            local integer result = 0

            loop
                set enumUnit = Group(this).FetchFirst()
                exitwhen (enumUnit == NULL)

                call thistype.ENUM_GROUP.AddUnit(enumUnit)

                set result = result + 1
            endloop

            call Group(this).AddGroupClear(thistype.ENUM_GROUP)

            return result
        endmethod

        static method Init takes nothing returns nothing
            set thistype.ENUM_GROUP = Group.Create()
        endmethod
    endstruct

    //! runtextmacro Struct("NearestUnit")
        static Group ENUM_GROUP

        method Do takes real x, real y returns Unit
            local real currentRange
            local Unit currentUnit
            local Unit enumUnit = Group(this).FetchFirst()
            local real enumUnitRange
            local boolean found

            if (enumUnit == NULL) then
                return NULL
            endif

            set found = false

            loop
                set enumUnitRange = Math.DistanceByDeltas(enumUnit.Position.X.Get() - x, enumUnit.Position.Y.Get() - y)

                call thistype.ENUM_GROUP.AddUnit(enumUnit)

                if (found == false) then
                    set currentRange = enumUnitRange
                    set currentUnit = enumUnit
                    set found = true
                elseif (enumUnitRange < currentRange) then
                    set currentRange = enumUnitRange
                    set currentUnit = enumUnit
                endif

                set enumUnit = Group(this).FetchFirst()
                exitwhen (enumUnit == NULL)
            endloop

            call Group(this).AddGroupClear(thistype.ENUM_GROUP)

            return currentUnit
        endmethod

        method DoWithZ takes real x, real y, real z returns Unit
            local real currentRange
            local Unit currentUnit
            local Unit enumUnit = Group(this).FetchFirst()
            local real enumUnitRange
            local real enumUnitX
            local real enumUnitY
            local boolean found

            if (enumUnit == NULL) then
                return NULL
            endif

            set found = false

            loop
                set enumUnitX = enumUnit.Position.X.Get()
                set enumUnitY = enumUnit.Position.Y.Get()

                set enumUnitRange = Math.DistanceByDeltasWithZ(enumUnitX - x, enumUnitY - y, enumUnit.Position.Z.GetByCoords(enumUnitX, enumUnitY) - z)
                call thistype.ENUM_GROUP.AddUnit(enumUnit)

                if (found == false) then
                    set currentRange = enumUnitRange
                    set currentUnit = enumUnit
                    set found = true
                elseif (enumUnitRange < currentRange) then
                    set currentRange = enumUnitRange
                    set currentUnit = enumUnit
                endif

                set enumUnit = Group(this).FetchFirst()
                exitwhen (enumUnit == NULL)
            endloop

            call Group(this).AddGroupClear(thistype.ENUM_GROUP)

            return currentUnit
        endmethod

        static method Init takes nothing returns nothing
            set thistype.ENUM_GROUP = Group.Create()
        endmethod
    endstruct

    //! runtextmacro Struct("Order")
        method IssuePointTarget takes Order value, real x, real y returns nothing
            call GroupPointOrderById(Group(this).self, value.self, x, y)
        endmethod
    endstruct

    //! runtextmacro Struct("RandomUnit")
        static Group ENUM_GROUP

        method Do takes nothing returns Unit
            local Unit enumUnit = Group(this).GetFirst()
            local integer iteration
            local integer random
            local Unit result

            if (enumUnit == NULL) then
                return NULL
            endif

            set iteration = 1
            set random = Math.RandomI(1, Group(this).CountUnits.Do())

            loop
                exitwhen (iteration == random)

                set iteration = iteration + 1
                set enumUnit = Group(this).FetchFirst()

                call thistype.ENUM_GROUP.AddUnit(enumUnit)
            endloop

            set result = Group(this).GetFirst()

            call Group(this).AddGroupClear(thistype.ENUM_GROUP)

            return result
        endmethod

        static method Init takes nothing returns nothing
            set thistype.ENUM_GROUP = Group.Create()
        endmethod
    endstruct

    //! runtextmacro Folder("EnumUnits")
        //! runtextmacro Folder("InLine")
            //! runtextmacro Struct("WithCollision")
                static real ANGLE
                static BoolExpr DUMMY_FILTER
                static Rectangle DUMMY_RECT
                static real LENGTH
                static real SOURCE_X
                static real SOURCE_Y
                static real WIDTH_END
                static real WIDTH_START

                static method Conditions takes nothing returns boolean
                    local Unit filterUnit = UNIT.Event.Native.GetFilter()

                    if (filterUnit.Position.InLine(thistype.SOURCE_X, thistype.SOURCE_Y, thistype.LENGTH, thistype.ANGLE, thistype.WIDTH_START, thistype.WIDTH_END) == false) then
                        return false
                    endif

                    if (filterUnit.self == DummyUnit.WORLD_CASTER.self) then
                        return false
                    endif

                    return true
                endmethod

                method Do takes real sourceX, real sourceY, real length, real angle, real widthStart, real widthEnd, BoolExpr whichFilter returns nothing
                    local real size = Math.Max(length, Math.Max(widthEnd, widthStart))

                    if (whichFilter == NULL) then
                        set whichFilter = BoolExpr.DEFAULT_TRUE
                    endif

                    set whichFilter = BoolExpr.GetByAnd(thistype.DUMMY_FILTER, whichFilter)
                    set thistype.ANGLE = angle
                    set thistype.LENGTH = length
                    set thistype.SOURCE_X = sourceX
                    set thistype.SOURCE_Y = sourceY
                    set thistype.WIDTH_END = widthEnd
                    set thistype.WIDTH_START = widthStart
                    call thistype.DUMMY_RECT.Set(sourceX - size, sourceY - size, sourceX + size, sourceY + size)

                    call GroupEnumUnitsInRect(Group(this).self, thistype.DUMMY_RECT.self, whichFilter.self)
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.DUMMY_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
                    set thistype.DUMMY_RECT = Rectangle.Create(0., 0., 0., 0.)
                endmethod
            endstruct
        endscope

        //! runtextmacro Struct("InLine")
            static real ANGLE
            static BoolExpr DUMMY_FILTER
            static Rectangle DUMMY_RECT
            static real LENGTH
            static real SOURCE_X
            static real SOURCE_Y
            static real WIDTH_END
            static real WIDTH_START

            //! runtextmacro LinkToStruct("InLine", "WithCollision")

            static method Conditions takes nothing returns boolean
                local Unit filterUnit = UNIT.Event.Native.GetFilter()

                if (Math.Shapes.InLine(thistype.SOURCE_X, thistype.SOURCE_Y, thistype.LENGTH, thistype.ANGLE, thistype.WIDTH_START, thistype.WIDTH_END, filterUnit.Position.X.Get(), filterUnit.Position.Y.Get()) == false) then
                    return false
                endif

                if (filterUnit.self == DummyUnit.WORLD_CASTER.self) then
                    return false
                endif

                return true
            endmethod

            method Do takes real sourceX, real sourceY, real length, real angle, real widthStart, real widthEnd, BoolExpr whichFilter returns nothing
                local real size = Math.Max(length, Math.Max(widthEnd, widthStart))

                if (whichFilter == NULL) then
                    set whichFilter = BoolExpr.DEFAULT_TRUE
                endif

                set whichFilter = BoolExpr.GetByAnd(thistype.DUMMY_FILTER, whichFilter)
                set thistype.ANGLE = angle
                set thistype.LENGTH = length
                set thistype.SOURCE_X = sourceX
                set thistype.SOURCE_Y = sourceY
                set thistype.WIDTH_END = widthEnd
                set thistype.WIDTH_START = widthStart
                call thistype.DUMMY_RECT.Set(sourceX - size, sourceY - size, sourceX + size, sourceY + size)

                call GroupEnumUnitsInRect(Group(this).self, thistype.DUMMY_RECT.self, whichFilter.self)
            endmethod

            static method Init takes nothing returns nothing
                set thistype.DUMMY_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
                set thistype.DUMMY_RECT = Rectangle.Create(0., 0., 0., 0.)

                call thistype(NULL).WithCollision.Init()
            endmethod
        endstruct

        //! runtextmacro Folder("InRange")
            //! runtextmacro Struct("WithCollision")
                static BoolExpr DUMMY_FILTER
                static BoolExpr DUMMY_FILTER_WITH_Z
                static constant real MAX_SIZE = 128

                static real RADIUS
                static real X
                static real Y
                static real Z

                static method Conditions takes nothing returns boolean
                    local Unit filterUnit = UNIT.Event.Native.GetFilter()

                    if (filterUnit.Position.InRangeWithCollision(thistype.X, thistype.Y, thistype.RADIUS) == false) then
                        return false
                    endif
                    if (filterUnit.self == DummyUnit.WORLD_CASTER.self) then
                        return false
                    endif

                    return true
                endmethod

                method Do takes real x, real y, real radius, BoolExpr whichFilter returns nothing
                    if (whichFilter == NULL) then
                        set whichFilter = BoolExpr.DEFAULT_TRUE
                    endif

                    set whichFilter = BoolExpr.GetByAnd(thistype.DUMMY_FILTER, whichFilter)
                    set thistype.RADIUS = radius
                    set thistype.X = x
                    set thistype.Y = y

                    call Group(this).EnumUnits.InRange.Pick(x, y, radius + thistype.MAX_SIZE, whichFilter)
                endmethod

                static method GetNearest takes real x, real y, real radius, BoolExpr whichFilter returns Unit
                    call thistype(Group.DUMMY).Do(x, y, radius, whichFilter)

                    return Group.DUMMY.GetNearest(x, y)
                endmethod

                static method GetRandom takes real x, real y, real radius, BoolExpr whichFilter returns Unit
                    call thistype(Group.DUMMY).Do(x, y, radius, whichFilter)

                    return Group.DUMMY.GetRandom()
                endmethod

                static method ConditionsWithZ takes nothing returns boolean
                    local Unit filterUnit = UNIT.Event.Native.GetFilter()

                    if (filterUnit.Position.InRangeWithCollisionWithZ(thistype.X, thistype.Y, thistype.Z, thistype.RADIUS) == false) then
                        return false
                    endif
                    if (filterUnit.self == DummyUnit.WORLD_CASTER.self) then
                        return false
                    endif

                    return true
                endmethod

                method DoWithZ takes real x, real y, real z, real radius, BoolExpr whichFilter returns nothing
                    if (whichFilter == NULL) then
                        set whichFilter = BoolExpr.DEFAULT_TRUE
                    endif

                    set whichFilter = BoolExpr.GetByAnd(thistype.DUMMY_FILTER, whichFilter)
                    set thistype.RADIUS = radius
                    set thistype.X = x
                    set thistype.Y = y
                    set thistype.Z = z

                    call Group(this).EnumUnits.InRange.Pick(x, y, radius + thistype.MAX_SIZE, whichFilter)
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.DUMMY_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
                    set thistype.DUMMY_FILTER_WITH_Z = BoolExpr.GetFromFunction(function thistype.ConditionsWithZ)
                endmethod
            endstruct
        endscope

        //! runtextmacro Struct("InRange")
            static BoolExpr DUMMY_FILTER

            //! runtextmacro LinkToStruct("InRange", "WithCollision")

            static method Conditions takes nothing returns boolean
                if (UNIT.Event.Native.GetFilter().self == DummyUnit.WORLD_CASTER.self) then
                    return false
                endif

                return true
            endmethod

            method Pick takes real x, real y, real radius, BoolExpr whichFilter returns nothing
                call GroupEnumUnitsInRange(Group(this).self, x, y, radius, whichFilter.self)
            endmethod

            method Do takes real x, real y, real radius, BoolExpr whichFilter returns nothing
                if (whichFilter == NULL) then
                    set whichFilter = BoolExpr.DEFAULT_TRUE
                endif

                set whichFilter = BoolExpr.GetByAnd(thistype.DUMMY_FILTER, whichFilter)

                call this.Pick(x, y, radius, whichFilter)
            endmethod

            static method Init takes nothing returns nothing
                set thistype.DUMMY_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)

                call thistype(NULL).WithCollision.Init()
            endmethod
        endstruct

        //! runtextmacro Folder("InRect")
            //! runtextmacro Struct("WithCollision")
                static BoolExpr DUMMY_FILTER
                static Rectangle DUMMY_RECT
                static constant real MAX_SIZE = 1024

                static real MAX_X
                static real MAX_Y
                static real MIN_X
                static real MIN_Y

                static method Conditions takes nothing returns boolean
                    local Unit filterUnit = UNIT.Event.Native.GetFilter()
                    local real maxX = thistype.MAX_X
                    local real maxY = thistype.MAX_Y
                    local real minX = thistype.MIN_X
                    local real minY = thistype.MIN_Y
                    local real x
                    local real y

                    set x = filterUnit.Position.X.Get()
                    set y = filterUnit.Position.Y.Get()

                    if ((x <= maxX) and (y <= maxY) and (x >= minX) and (y >= minY)) then
                        return true
                    endif
                    if (filterUnit.Position.InRangeWithCollision(Math.Min(Math.Max(minX, x), maxX), Math.Min(Math.Max(minY, y), maxY), 0.)) then
                        return true
                    endif
                    if (filterUnit.self == DummyUnit.WORLD_CASTER.self) then
                        return false
                    endif

                    return false
                endmethod

                method Do takes Rectangle whichRect, BoolExpr whichFilter returns nothing
                    local real maxX = whichRect.GetMaxX()
                    local real maxY = whichRect.GetMaxY()
                    local real minX = whichRect.GetMinX()
                    local real minY = whichRect.GetMinY()

                    if (whichFilter == NULL) then
                        set whichFilter = BoolExpr.DEFAULT_TRUE
                    endif

                    set thistype.MAX_X = maxX
                    set thistype.MAX_Y = maxY
                    set thistype.MIN_X = minX
                    set thistype.MIN_Y = minY
                    set whichFilter = BoolExpr.GetByAnd(thistype.DUMMY_FILTER, whichFilter)
                    call thistype.DUMMY_RECT.Set(minX - thistype.MAX_SIZE, minY - thistype.MAX_SIZE, maxX + thistype.MAX_SIZE, maxY + thistype.MAX_SIZE)

                    call Group(this).EnumUnits.InRect.Pick(thistype.DUMMY_RECT, whichFilter)
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.DUMMY_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
                    set thistype.DUMMY_RECT = Rectangle.Create(0., 0., 0., 0.)
                endmethod
            endstruct
        endscope

        //! runtextmacro Struct("InRect")
            static BoolExpr DUMMY_FILTER

            //! runtextmacro LinkToStruct("InRect", "WithCollision")

            static method Conditions takes nothing returns boolean
                if (UNIT.Event.Native.GetFilter().self == DummyUnit.WORLD_CASTER.self) then
                    return false
                endif

                return true
            endmethod

            method Pick takes Rectangle whichRect, BoolExpr whichFilter returns nothing
                call GroupEnumUnitsInRect(Group(this).self, whichRect.self, whichFilter.self)
            endmethod

            method Do takes Rectangle whichRect, BoolExpr whichFilter returns nothing
                if (whichFilter == NULL) then
                    set whichFilter = BoolExpr.DEFAULT_TRUE
                endif

                set whichFilter = BoolExpr.GetByAnd(thistype.DUMMY_FILTER, whichFilter)

                call this.Pick(whichRect, whichFilter)
            endmethod

            static method Init takes nothing returns nothing
                set thistype.DUMMY_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)

                call thistype(NULL).WithCollision.Init()
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("EnumUnits")
        static User FILTER_USER

        //! runtextmacro LinkToStruct("EnumUnits", "InLine")
        //! runtextmacro LinkToStruct("EnumUnits", "InRange")
        //! runtextmacro LinkToStruct("EnumUnits", "InRect")

        method All takes BoolExpr whichFilter returns nothing
            call GroupEnumUnitsInRect(Group(this).self, Rectangle.WORLD.self, whichFilter.self)
        endmethod

        static method Init takes nothing returns nothing
            call thistype(NULL).InLine.Init()
            call thistype(NULL).InRange.Init()
            call thistype(NULL).InRect.Init()
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Group", "GROUP")
    static integer QUEUE_SIZE = ARRAY_EMPTY
    static thistype array QUEUED

    static thistype ALIVE
    static thistype DUMMY
    static thistype TEMP
    static thistype array TEMPS
    static thistype WORLD

    group self

    //! runtextmacro LinkToStruct("Group", "CountUnits")
    //! runtextmacro LinkToStruct("Group", "EnumUnits")
    //! runtextmacro LinkToStruct("Group", "NearestUnit")
    //! runtextmacro LinkToStruct("Group", "Order")
    //! runtextmacro LinkToStruct("Group", "RandomUnit")
    //! runtextmacro LinkToStruct("Group", "Refs")

    method Destroy takes nothing returns nothing
        if (this.Refs.CheckForDestroy() == false) then
            return
        endif

        set thistype.QUEUE_SIZE = thistype.QUEUE_SIZE + 1
        set thistype.QUEUED[thistype.QUEUE_SIZE] = this
        call GroupClear(this.self)
    endmethod

    method ContainsUnit takes Unit whichUnit returns boolean
        return IsUnitInGroup(whichUnit.self, this.self)
    endmethod

    method Count takes nothing returns integer
        return this.CountUnits.Do()
    endmethod

    method GetFirst takes nothing returns Unit
        return Unit.GetFromSelf(FirstOfGroup(this.self))
    endmethod

    method GetNearest takes real x, real y returns Unit
        return this.NearestUnit.Do(x, y)
    endmethod

    method GetRandom takes nothing returns Unit
        return this.RandomUnit.Do()
    endmethod

    method IsEmpty takes nothing returns boolean
        return (this.GetFirst() == NULL)
    endmethod

    method Clear takes nothing returns nothing
        call GroupClear(this.self)
    endmethod

    method RemoveUnit takes Unit whichUnit returns nothing
        call GroupRemoveUnit(this.self, whichUnit.self)
    endmethod

    method FetchFirst takes nothing returns Unit
        local Unit result = this.GetFirst()

        if (result == NULL) then
            return NULL
        endif

        call this.RemoveUnit(result)

        return result
    endmethod

    method AddGroupClear takes Group whichGroup returns nothing
        local Unit currentUnit

        loop
            set currentUnit = whichGroup.FetchFirst()
            exitwhen (currentUnit == NULL)

            call this.AddUnit(currentUnit)
        endloop
    endmethod

    method AddUnit takes Unit whichUnit returns nothing
        call GroupAddUnit(this.self, whichUnit.self)
    endmethod

    method Do takes code actionFunction returns nothing
        call ForGroup(this.self, actionFunction)
    endmethod

    static method Create takes nothing returns thistype
        local thistype this

        if (thistype.QUEUE_SIZE == ARRAY_EMPTY) then
            set this = thistype.allocate()

            //set thistype.QUEUED[ARRAY_MIN] = this

            set this.self = CreateGroup()
        else
            set this = thistype.QUEUED[thistype.QUEUE_SIZE]

            set thistype.QUEUE_SIZE = thistype.QUEUE_SIZE - 1
        endif

        call this.Refs.Event_Create()

        return this
    endmethod

    static method Init takes nothing returns nothing
        set thistype.ALIVE = thistype.Create()
        set thistype.DUMMY = thistype.Create()
        set thistype.WORLD = thistype.Create()

        call thistype(NULL).CountUnits.Init()
        call thistype(NULL).EnumUnits.Init()
        call thistype(NULL).NearestUnit.Init()
        call thistype(NULL).RandomUnit.Init()
    endmethod
endstruct