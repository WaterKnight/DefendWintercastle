//! runtextmacro BaseStruct("TileType", "TILE_TYPE")
    //! runtextmacro GetKey("KEY")

    integer self

    static method GetFromSelf takes integer self returns thistype
        return Memory.IntegerKeys.GetInteger(self, KEY)
    endmethod

    method Destroy takes nothing returns nothing
        call this.deallocate()
    endmethod

    static method CreateFromSelf takes integer self returns thistype
        local thistype this = thistype.allocate()

        set this.self = self

        call Memory.IntegerKeys.SetInteger(self, KEY, this)

        return this
    endmethod

    //! runtextmacro GetKeyArray("INIT_KEY_ARRAY")

    static method AddInit takes code c, string name returns nothing
        call Trigger.AddObjectInit(INIT_KEY_ARRAY, c, name)
    endmethod

    initMethod Init of Header_5
    endmethod
endstruct

//! runtextmacro Folder("Tile")
    //! runtextmacro Struct("Type")
        TileType orig
        Queue vals

        method GetNative takes nothing returns TileType
            return TileType.GetFromSelf(GetTerrainType(Tile(this).GetX(), Tile(this).GetY()))
        endmethod

        method SetNative takes TileType val returns nothing
            call SetTerrainType(Tile(this).GetX(), Tile(this).GetY(), val.self, -1, 1, 0)
        endmethod

        method Remove takes TileTypeMod val returns nothing
            if (this.vals == NULL) then
                call DebugEx(thistype.NAME + " tile " + I2S(this) + " has not " + I2S(val))

                return
            endif

            call this.vals.Remove(val)

            if vals.IsEmpty() then
                call vals.Destroy()

                set this.vals = NULL

                call this.SetNative(this.orig)
            else
                set val = this.vals.GetLast()

                call this.SetNative(val.GetVal())
            endif
        endmethod

        method Add takes TileTypeMod val returns nothing
            if (this.vals == NULL) then
                set this.orig = this.GetNative()
                set this.vals = Queue.Create()
            endif

            call this.vals.Add(val)

            call this.SetNative(val.GetVal())
        endmethod

        method Event_Create takes nothing returns nothing
            set this.vals = NULL
        endmethod

        static method Init takes nothing returns nothing
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Tile", "TILE")
	static constant integer CELL_DIST = 128
    static HashTable TABLE

    //! runtextmacro CreateAnyState("x", "X", "integer")
    //! runtextmacro CreateAnyState("y", "Y", "integer")

    //! runtextmacro LinkToStruct("Tile", "Type")

    integer refs

    static method GetFromCoords2 takes real x, real y returns thistype
        local integer xI = Real.ToInt(x - WORLD_MIN_X) div 128
        local integer yI = Real.ToInt(y - WORLD_MIN_Y) div 128

        return thistype(yI * Real.ToInt(WORLD_MAX_X - WORLD_MIN_X) div 128 + xI)
    endmethod

    method GetFirstKey takes nothing returns integer
        return (this div 8192)
    endmethod

    method GetSecondKey takes nothing returns integer
        return Math.ModI(this, 8192)
    endmethod

    method GetX2 takes nothing returns real
        return (WORLD_MIN_X + Math.ModI(this, Real.ToInt(WORLD_MAX_X - WORLD_MIN_X) div 128) * 128)
    endmethod

    method GetY2 takes nothing returns real
        return (WORLD_MIN_Y + this / (Real.ToInt(WORLD_MAX_X - WORLD_MIN_X) div 128) * 128)
    endmethod

    method RemoveRef takes nothing returns nothing
        if (this.refs == 1) then
            call thistype.TABLE.Integer.Remove(Real.ToInt(this.GetX()) div 128, Real.ToInt(this.GetY()) div 128)

            call this.deallocate()

            return
        endif

        set this.refs = this.refs - 1
    endmethod

    static method GetFromCoords takes real x, real y returns thistype
        local integer xI = Real.ToInt(Math.RoundTo(x, 128)) div 128
        local integer yI = Real.ToInt(Math.RoundTo(y, 128)) div 128

        local thistype this = thistype.TABLE.Integer.Get(xI, yI)

        if (this == NULL) then
            set this = thistype.allocate()

            call thistype.TABLE.Integer.Set(xI, yI, this)

            set this.refs = 1

            call this.SetX(xI * 128)
            call this.SetY(yI * 128)

            call this.Type.Event_Create()
        else
            set this.refs = this.refs + 1
        endif

        return this
    endmethod

    initMethod Init of Header_5
        set thistype.TABLE = HashTable.Create()
    endmethod
endstruct

//! runtextmacro Folder("TileTypeMod")
    //! runtextmacro Struct("DestroyTimed")
        Timer durationTimer

        method Ending takes nothing returns nothing
            call this.durationTimer.Destroy()
        endmethod

        static method EndingByTimer takes nothing returns nothing
            local thistype this = Timer.GetExpired().GetData()

            call this.Ending()

            call TileTypeMod(this).Destroy()
        endmethod

        method Start takes real duration returns nothing
            local Timer durationTimer = Timer.Create()

            set this.durationTimer = durationTimer
            call durationTimer.SetData(this)

            call durationTimer.Start(duration, false, function thistype.EndingByTimer)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("TileTypeMod", "TILE_TYPE_MOD")
    //! runtextmacro CreateAnyState("tile", "Tile", "Tile")
    //! runtextmacro CreateAnyState("val", "Val", "TileType")

    //! runtextmacro LinkToStruct("TileTypeMod", "DestroyTimed")

    method Destroy takes nothing returns nothing
        local Tile tile = this.GetTile()

        call tile.Type.Remove(this)

        call tile.RemoveRef()

        call this.deallocate()
    endmethod

    static method Create takes real x, real y, TileType val returns thistype
        local Tile tile = Tile.GetFromCoords(x, y)

        local thistype this = thistype.allocate()

        call this.SetTile(tile)
        call this.SetVal(val)

        call tile.Type.Add(this)

        return this
    endmethod

    initMethod Init of Header_5
    endmethod
endstruct