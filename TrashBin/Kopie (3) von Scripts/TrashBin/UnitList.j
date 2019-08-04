//! runtextmacro Folder("Group")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("Group", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("Group", "Integer", "integer")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Integer")

        //! runtextmacro Data_Implement("Group")
    endstruct

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

    //! runtextmacro Struct("NearestUnit")
        method Do takes real x, real y returns Unit
            local Unit enumUnit
            local real enumUnitRange
            local boolean found
            local integer iteration = Group(this).CountUnits()
            local Unit result
            local real resultRange

            if (iteration < Memory.IntegerKeys.Table.STARTED) then
                return NULL
            endif

            set found = false

            loop
                set enumUnit = Group(this).GetUnit(iteration)

                set enumUnitRange = Math.DistanceByDeltas(enumUnit.Position.X.Get() - x, enumUnit.Position.Y.Get() - y)

                if (found == false) then
                    set found = true
                    set result = enumUnit
                    set resultRange = enumUnitRange
                elseif (enumUnitRange < resultRange) then
                    set result = enumUnit
                    set resultRange = enumUnitRange
                endif

                set iteration = iteration - 1
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
            endloop

            return result
        endmethod

        method DoWithZ takes real x, real y, real z returns Unit
            local Unit enumUnit
            local real enumUnitRange
            local real enumUnitX
            local real enumUnitY
            local boolean found
            local integer iteration = Group(this).CountUnits()
            local Unit result
            local real resultRange

            if (iteration < Memory.IntegerKeys.Table.STARTED) then
                return NULL
            endif

            set found = false

            loop
                set enumUnit = Group(this).GetUnit(iteration)

                set enumUnitX = enumUnit.Position.X.Get()
                set enumUnitY = enumUnit.Position.Y.Get()

                set enumUnitRange = Math.DistanceByDeltasWithZ(enumUnitX - x, enumUnitY - y, enumUnit.Position.Z.GetByCoords(enumUnitX, enumUnitY) - z)

                if (found == false) then
                    set found = true
                    set result = enumUnit
                    set resultRange = enumUnitRange
                elseif (enumUnitRange < resultRange) then
                    set result = enumUnit
                    set resultRange = enumUnitRange
                endif

                set iteration = iteration - 1
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
            endloop

            return result
        endmethod

        static method Init takes nothing returns nothing
        endmethod
    endstruct

    //! runtextmacro Folder("EnumUnits")
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

                    if (filterUnit.Position.InRangeWithCollision(X, Y, RADIUS) == false) then
                        return false
                    endif

                    return true
                endmethod

                method Do takes real x, real y, real radius, BoolExpr whichFilter returns nothing
                    if (whichFilter == NULL) then
                        set whichFilter = BoolExpr.DEFAULT_TRUE
                    endif

                    set whichFilter = BoolExpr.GetByAnd(DUMMY_FILTER, whichFilter)

                    set RADIUS = radius
                    set X = x
                    set Y = y

                    call Group(this).EnumUnits.InRange.Pick(x, y, radius + MAX_SIZE, whichFilter)
                endmethod

                static method GetNearest takes real x, real y, real radius, BoolExpr whichFilter returns Unit
                    call thistype(Group.DUMMY).Do(x, y, radius, whichFilter)

                    return Group.DUMMY.GetNearest(x, y)
                endmethod

                static method ConditionsWithZ takes nothing returns boolean
                    local Unit filterUnit = UNIT.Event.Native.GetFilter()

                    if (filterUnit.Position.InRangeWithCollisionWithZ(X, Y, Z, RADIUS) == false) then
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

                    set whichFilter = BoolExpr.GetByAnd(DUMMY_FILTER, whichFilter)

                    set RADIUS = radius
                    set X = x
                    set Y = y
                    set Z = z

                    call Group(this).EnumUnits.InRange.Pick(x, y, radius + MAX_SIZE, whichFilter)
                endmethod

                static method Init takes nothing returns nothing
                    set DUMMY_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
                    set DUMMY_FILTER_WITH_Z = BoolExpr.GetFromFunction(function thistype.ConditionsWithZ)
                endmethod
            endstruct
        endscope

        //! runtextmacro Struct("InRange")
            static group DUMMY_GROUP

            //! runtextmacro LinkToStruct("InRange", "WithCollision")

            static method Add takes nothing returns boolean
                call Group.TEMP.AddUnit(UNIT.Event.Native.GetFilter())

                return true
            endmethod

            method Pick takes real x, real y, real radius, BoolExpr whichFilter returns nothing
                local Unit currentUnit
                local unit currentUnitBJ

                //set whichFilter = BoolExpr.GetByAnd(whichFilter, ADD_FILTER)

                set Group.TEMP = this

                call GroupEnumUnitsInRange(DUMMY_GROUP, x, y, radius, whichFilter.self)

                loop
                    set currentUnitBJ = FirstOfGroup(thistype.DUMMY_GROUP)
                    exitwhen (currentUnitBJ == null)
                    call GroupRemoveUnit(thistype.DUMMY_GROUP, currentUnitBJ)

                    set currentUnit = Unit.GetFromSelf(currentUnitBJ)

                    if (currentUnit != NULL) then
                        call Group.TEMP.AddUnit(currentUnit)
                    endif
                endloop

                set currentUnitBJ = null
            endmethod

            method Do takes real x, real y, real radius, BoolExpr whichFilter returns nothing
                if (whichFilter == NULL) then
                    set whichFilter = BoolExpr.DEFAULT_TRUE
                endif

                //set whichFilter = BoolExpr.GetByAnd(DUMMY_FILTER, whichFilter)

                call this.Pick(x, y, radius, whichFilter)
            endmethod

            static method Init takes nothing returns nothing
                set DUMMY_GROUP = CreateGroup()

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
                    local real maxX = MAX_X
                    local real maxY = MAX_Y
                    local real minX = MIN_X
                    local real minY = MIN_Y
                    local real x
                    local real y

                    set x = filterUnit.Position.X.Get()
                    set y = filterUnit.Position.Y.Get()

                    if ((x <= maxX) and (y <= maxY) and (x >= minX) and (y >= minY)) then
                        return true
                    endif
                    if (filterUnit.Position.InRangeWithCollision(Math.Limit(x, minX, maxX), Math.Limit(y, minY, maxY), 0.)) then
                        return true
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

                    set MAX_X = maxX
                    set MAX_Y = maxY
                    set MIN_X = minX
                    set MIN_Y = minY
                    set whichFilter = BoolExpr.GetByAnd(DUMMY_FILTER, whichFilter)
                    call DUMMY_RECT.Set(minX - MAX_SIZE, minY - MAX_SIZE, maxX + MAX_SIZE, maxY + MAX_SIZE)

                    call Group(this).EnumUnits.InRect.Pick(DUMMY_RECT, whichFilter)
                endmethod

                static method Init takes nothing returns nothing
                    set DUMMY_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
                    set DUMMY_RECT = Rectangle.Create(0., 0., 0., 0.)
                endmethod
            endstruct
        endscope

        //! runtextmacro Struct("InRect")
            static group DUMMY_GROUP

            //! runtextmacro LinkToStruct("InRect", "WithCollision")

            static method Add takes nothing returns boolean
                call Group.TEMP.AddUnit(UNIT.Event.Native.GetFilter())

                return true
            endmethod

            method Pick takes Rectangle whichRect, BoolExpr whichFilter returns nothing
                local Unit currentUnit
                local unit currentUnitBJ

                //set whichFilter = BoolExpr.GetByAnd(whichFilter, ADD_FILTER)

                set Group.TEMP = this

                call GroupEnumUnitsInRect(thistype.DUMMY_GROUP, whichRect.self, whichFilter.self)

                loop
                    set currentUnitBJ = FirstOfGroup(thistype.DUMMY_GROUP)
                    exitwhen (currentUnitBJ == null)
                    call GroupRemoveUnit(thistype.DUMMY_GROUP, currentUnitBJ)

                    set currentUnit = Unit.GetFromSelf(currentUnitBJ)

                    if (currentUnit != NULL) then
                        call Group.TEMP.AddUnit(currentUnit)
                    endif
                endloop

                set currentUnitBJ = null
            endmethod

            method Do takes Rectangle whichRect, BoolExpr whichFilter returns nothing
                if (whichFilter == NULL) then
                    set whichFilter = BoolExpr.DEFAULT_TRUE
                endif

                //set whichFilter = BoolExpr.GetByAnd(DUMMY_FILTER, whichFilter)

                call this.Pick(whichRect, whichFilter)
            endmethod

            static method Init takes nothing returns nothing
                set DUMMY_GROUP = CreateGroup()

                call thistype(NULL).WithCollision.Init()
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("EnumUnits")
        static User FILTER_USER

        //! runtextmacro LinkToStruct("EnumUnits", "InRange")
        //! runtextmacro LinkToStruct("EnumUnits", "InRect")

        method All takes BoolExpr whichFilter returns nothing
            call Group(this).Copy(Group.WORLD)
        endmethod

        static method Init takes nothing returns nothing
            call thistype(NULL).InRange.Init()
            call thistype(NULL).InRect.Init()
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Group", "GROUP")
    //! runtextmacro GetKeyArray("KEY_ARRAY")

    static thistype ALIVE
    static thistype DUMMY
    static thistype TEMP
    static thistype array TEMPS
    static thistype WORLD

    //! runtextmacro LinkToStruct("Group", "Data")
    //! runtextmacro LinkToStruct("Group", "EnumUnits")
    //! runtextmacro LinkToStruct("Group", "Id")
    //! runtextmacro LinkToStruct("Group", "NearestUnit")
    //! runtextmacro LinkToStruct("Group", "Refs")

    method ContainsUnit takes Unit whichUnit returns boolean
        return this.Data.Integer.Table.Contains(KEY_ARRAY, whichUnit)
    endmethod

    method CountUnits takes nothing returns integer
        return this.Data.Integer.Table.Count(KEY_ARRAY)
    endmethod

    method GetNearest takes real x, real y returns Unit
        return this.NearestUnit.Do(x, y)
    endmethod

    method GetUnit takes integer index returns Unit
        return this.Data.Integer.Table.Get(KEY_ARRAY, index)
    endmethod

    method GetFirst takes nothing returns Unit
        return this.GetUnit(Memory.IntegerKeys.Table.STARTED)
    endmethod

    method GetRandom takes nothing returns Unit
        return this.Data.Integer.Table.RandomAll(KEY_ARRAY)
    endmethod

    method IsEmpty takes nothing returns boolean
        return (this.CountUnits() == Memory.IntegerKeys.Table.EMPTY)
    endmethod

    method Clear takes nothing returns nothing
        call this.Data.Integer.Table.Clear(KEY_ARRAY)
    endmethod

    method RemoveUnit takes Unit whichUnit returns nothing
        call this.Data.Integer.Table.Remove(KEY_ARRAY, whichUnit)
    endmethod

    method FetchFirst takes nothing returns Unit
        return this.Data.Integer.Table.FetchFirst(KEY_ARRAY)
    endmethod

    method AddGroupClear takes thistype target returns nothing
        call this.Data.Integer.Table.Join(KEY_ARRAY, target)

        call target.Clear()
    endmethod

    method AddUnit takes Unit whichUnit returns nothing
        call this.Data.Integer.Table.Add(KEY_ARRAY, whichUnit)
    endmethod

    method Destroy takes nothing returns nothing
        call this.Clear()

        call this.deallocate()
    endmethod

    static method Create takes nothing returns thistype
        local thistype this = thistype.allocate()

        call this.Id.Event_Create()

        return this
    endmethod

    method Copy takes Group other returns nothing
        local integer iteration = other.CountUnits()

        call this.Clear()

        loop
            exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

            call this.AddUnit(other.GetUnit(iteration))

            set iteration = iteration - 1
        endloop
    endmethod

    method Do takes code action returns nothing
        local thistype dummy
        local integer iteration = this.CountUnits()

        if (iteration < Memory.IntegerKeys.Table.STARTED) then
            return
        endif

        set dummy = thistype.Create()

        call dummy.Copy(this)

        loop
            call UNIT.Event.SetEnum(this.GetUnit(iteration))

            set iteration = iteration - 1
            exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
        endloop

        call dummy.Destroy()
    endmethod

    //! textmacro Group_CreateUnitBoolExprAdapter takes name, target
        static method $name$ takes nothing returns boolean
            if ($target$(UNIT.Event.Native.GetFilter()) == false) then
                return false
            endif

            return true
        endmethod
    //! endtextmacro

    static method Init takes nothing returns nothing
        set thistype.ALIVE = thistype.Create()
        set thistype.DUMMY = thistype.Create()
        set thistype.WORLD = thistype.Create()

        call thistype(NULL).NearestUnit.Init()
        call thistype(NULL).EnumUnits.Init()
    endmethod
endstruct