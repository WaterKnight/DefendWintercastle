//! runtextmacro Folder("GameCache")
    //! textmacro GameCache_CreateType takes getFunc, setFunc, type, defaultValue
        static constant $type$ DEFAULT_VALUE = $defaultValue$

        method Get takes string missionKey, string key returns $type$
            if ((missionKey == null) or (key == null)) then
                call Game.DebugMsg("GameCache Get: "+missionKey+";"+key)

                return $defaultValue$
            endif

            return $getFunc$(GameCache(this).self, missionKey, key)
        endmethod

        method Set takes string missionKey, string key, $type$ value returns nothing
            if ((missionKey == null) or (key == null)) then
                call Game.DebugMsg("GameCache Set: "+missionKey+";"+key)

                return
            endif

            call $setFunc$(GameCache(this).self, missionKey, key, value)
        endmethod

        method Remove takes string missionKey, string key returns nothing
            call this.Set(missionKey, key, thistype.DEFAULT_VALUE)
        endmethod
    //! endtextmacro

    //! runtextmacro Struct("Boolean")
        //! runtextmacro GameCache_CreateType("GetStoredBoolean", "StoreBoolean", "boolean", "false")
    endstruct

    //! runtextmacro Struct("Integer")
        //! runtextmacro GameCache_CreateType("GetStoredInteger", "StoreInteger", "integer", "0")
    endstruct

    //! runtextmacro Struct("Real")
        //! runtextmacro GameCache_CreateType("GetStoredReal", "StoreReal", "real", "0.")
    endstruct

    //! runtextmacro Struct("String")
        //! runtextmacro GameCache_CreateType("GetStoredString", "StoreString", "string", "\"\"")
    endstruct
endscope

//! runtextmacro BaseStruct("GameCache", "GAME_CACHE")
    gamecache self

    //! runtextmacro LinkToStruct("GameCache", "Boolean")
    //! runtextmacro LinkToStruct("GameCache", "Integer")
    //! runtextmacro LinkToStruct("GameCache", "Real")
    //! runtextmacro LinkToStruct("GameCache", "String")

    method RemoveMission takes string missionKey returns nothing
        call FlushStoredMission(this.self, missionKey)
    endmethod

    static method Create takes nothing returns thistype
        local thistype this = thistype.allocate()

        set this.self = InitGameCache("bla")

        return this
    endmethod
endstruct

//! runtextmacro Folder("HashTable")
    //! textmacro HashTable_CreateType takes containsFunc, getFunc, setFunc, removeFunc, type, defaultValue, bugConv
        static constant $type$ DEFAULT_VALUE = $defaultValue$

        method Contains takes integer missionKey, integer key returns boolean
            //return $containsFunc$(HashTable(this).self, missionKey, key)
            return ($getFunc$(HashTable(this).self, missionKey, key) != thistype.DEFAULT_VALUE)
        endmethod

        method Get takes integer missionKey, integer key returns $type$
        if (missionKey==ID and key==UNIT.Buffs.KEY_ARRAY_DETAIL+UNIT.Movement.DUMMY_BUFF) then
            call BJDebugMsg("get "+I2S(key)+" --> "+$type$ToString($getFunc$(HashTable(this).self, missionKey, key)))
            call BJDebugMsg("buff: "+I2S(UNIT.Buffs.KEY_ARRAY_DETAIL)+";"+I2S(UNIT.Movement.DUMMY_BUFF))
        endif
            return $getFunc$(HashTable(this).self, missionKey, key)
        endmethod

        method Set takes integer missionKey, integer key, $type$ value returns nothing
        if (missionKey==ID and key==UNIT.Buffs.KEY_ARRAY_DETAIL+UNIT.Movement.DUMMY_BUFF) then
            call BJDebugMsg("set "+I2S(key)+" --> "+$type$ToString(value))
        endif
            call $setFunc$(HashTable(this).self, missionKey, key, value)
        endmethod

        method Remove takes integer missionKey, integer key returns nothing
            call this.Set(missionKey, key, thistype.DEFAULT_VALUE)
            //call $removeFunc$(HashTable(this).self, missionKey, key)
        endmethod
    //! endtextmacro

    //! runtextmacro Struct("Boolean")
        //! runtextmacro HashTable_CreateType("HaveSavedBoolean", "LoadBoolean", "SaveBoolean", "RemoveSavedBoolean", "boolean", "false", "B2S")
    endstruct

    //! runtextmacro Struct("Integer")
        //! runtextmacro HashTable_CreateType("HaveSavedInteger", "LoadInteger", "SaveInteger", "RemoveSavedInteger", "integer", "0", "I2S")
    endstruct

    //! runtextmacro Struct("Real")
        //! runtextmacro HashTable_CreateType("HaveSavedReal", "LoadReal", "SaveReal", "RemoveSavedReal", "real", "0.", "R2S")
    endstruct

    //! runtextmacro Struct("String")
        //! runtextmacro HashTable_CreateType("HaveSavedString", "LoadStr", "SaveStr", "RemoveSavedString", "string", "\"\"", "")
    endstruct
endscope

//! runtextmacro BaseStruct("HashTable", "HASH_TABLE")
    hashtable self

    //! runtextmacro LinkToStruct("HashTable", "Boolean")
    //! runtextmacro LinkToStruct("HashTable", "Integer")
    //! runtextmacro LinkToStruct("HashTable", "Real")
    //! runtextmacro LinkToStruct("HashTable", "String")

    method RemoveMission takes integer missionKey returns nothing
        call FlushChildHashtable(this.self, missionKey)
    endmethod

    static method Create takes nothing returns thistype
        local thistype this = thistype.allocate()

        set this.self = InitHashtable()

        return this
    endmethod
endstruct

//! runtextmacro Folder("MemoryHead")
    //! runtextmacro Struct("IntegerKeys")
        static HashTable CACHE

        static method RemoveChild takes integer missionKey returns nothing
            call thistype.CACHE.RemoveMission(missionKey)
        endmethod

        //! textmacro MemoryHead_IntegerKeys_CreateType takes name, type
            static method Contains$name$ takes integer missionKey, integer key returns boolean
                return thistype.CACHE.$name$.Contains(missionKey, key)
            endmethod

            static method Get$name$ takes integer missionKey, integer key returns $type$
                return thistype.CACHE.$name$.Get(missionKey, key)
            endmethod

            static method Get$name$ByHandle takes handle handleSource, integer key returns $type$
                return thistype.Get$name$(GetHandleId(handleSource), key)
            endmethod

            static method Set$name$ takes integer missionKey, integer key, $type$ value returns nothing
                call thistype.CACHE.$name$.Set(missionKey, key, value)
            endmethod

            static method Set$name$ByHandle takes handle handleSource, integer key, $type$ value returns nothing
                call thistype.Set$name$(GetHandleId(handleSource), key, value)
            endmethod

            static method Remove$name$ takes integer missionKey, integer key returns nothing
                call thistype.CACHE.$name$.Remove(missionKey, key)
            endmethod

            static method Remove$name$ByHandle takes handle handleSource, integer key returns nothing
                call thistype.Remove$name$(GetHandleId(handleSource), key)
            endmethod
        //! endtextmacro

        //! runtextmacro MemoryHead_IntegerKeys_CreateType("Boolean", "boolean")
        //! runtextmacro MemoryHead_IntegerKeys_CreateType("Integer", "integer")
        //! runtextmacro MemoryHead_IntegerKeys_CreateType("Real", "real")
        //! runtextmacro MemoryHead_IntegerKeys_CreateType("String", "string")

        static method Init takes nothing returns nothing
            set thistype.CACHE = HashTable.Create()
        endmethod
    endstruct

    //! runtextmacro Struct("StringKeys")
        static GameCache CACHE

        static method RemoveChild takes string missionKey returns nothing
            call thistype.CACHE.RemoveMission(missionKey)
        endmethod

        //! textmacro MemoryHead_StringKeys_CreateType takes name, type
            static method Set$name$ takes string missionKey, string key, $type$ value returns nothing
                call thistype.CACHE.$name$.Set(missionKey, key, value)
            endmethod

            static method Remove$name$ takes string missionKey, string key returns nothing
                call thistype.CACHE.$name$.Remove(missionKey, key)
            endmethod

            static method Get$name$ takes string missionKey, string key returns $type$
                return thistype.CACHE.$name$.Get(missionKey, key)
            endmethod
        //! endtextmacro

        //! runtextmacro MemoryHead_StringKeys_CreateType("Boolean", "boolean")
        //! runtextmacro MemoryHead_StringKeys_CreateType("Integer", "integer")
        //! runtextmacro MemoryHead_StringKeys_CreateType("Real", "real")
        //! runtextmacro MemoryHead_StringKeys_CreateType("String", "string")

        static method Init takes nothing returns nothing
            set thistype.CACHE = GameCache.Create()
        endmethod
    endstruct
endscope

//! runtextmacro StaticStruct("MemoryHead")
    //! runtextmacro LinkToStaticStruct("MemoryHead", "IntegerKeys")
    //! runtextmacro LinkToStaticStruct("MemoryHead", "StringKeys")

    static method Init takes nothing returns nothing
        call thistype.IntegerKeys.Init()
        call thistype.StringKeys.Init()
    endmethod
endstruct

//! runtextmacro Folder("Memory")
    //! runtextmacro Folder("IntegerKeys")
        //! runtextmacro Struct("Table")
            static constant integer EMPTY = HASH_TABLE.Integer.DEFAULT_VALUE//-1
            static constant integer OFFSET = 8192
            static HashTable POS_CACHE
            static constant integer SIZE = 8192

            static constant integer STARTED = thistype.EMPTY + 1//0

            static method GetId takes integer key returns integer
                return thistype.OFFSET + (key - Math.Integer.MIN) * thistype.SIZE
            endmethod

            static method GetTableId takes integer key returns integer
                return (key - Math.Integer.MIN - thistype.OFFSET) / thistype.SIZE
            endmethod

            static method GetReverseKey takes integer key, integer value returns integer
                return (value * thistype.SIZE + thistype.GetTableId(key))
            endmethod

            private static method SetCount takes integer missionKey, integer key, integer value returns nothing
                call MemoryHead.IntegerKeys.SetInteger(missionKey, key, value - thistype.EMPTY)
            endmethod

            //! textmacro Memory_IntegerKeys_Table_CreateType takes name, type, bugConverter, valueConverter
                static method Get$name$Pos takes integer missionKey, integer key, $type$ value returns integer
                    return thistype.POS_CACHE.Integer.Get(missionKey, thistype.GetReverseKey(key, $valueConverter$(value)))
                endmethod

                static method Count$name$s takes integer missionKey, integer key returns integer
                    return (thistype.EMPTY + MemoryHead.IntegerKeys.GetInteger(missionKey, key))
                endmethod

                static method Get$name$ takes integer missionKey, integer key, integer index returns $type$
                    return MemoryHead.IntegerKeys.Get$name$(missionKey, key + index)
                endmethod

                static method GetFirst$name$ takes integer missionKey, integer key returns $type$
                    return thistype.Get$name$(missionKey, key, thistype.STARTED)
                endmethod

                static method Contains$name$ takes integer missionKey, integer key, $type$ value returns boolean
                    return (thistype.Get$name$Pos(missionKey, key, value) != HASH_TABLE.Integer.DEFAULT_VALUE)
                endmethod

                static method Random$name$ takes integer missionKey, integer key, integer lowerBound, integer higherBound returns $type$
                    return thistype.Get$name$(missionKey, key, Math.RandomI(lowerBound, higherBound))
                endmethod

                static method Random$name$All takes integer missionKey, integer key returns $type$
                    return thistype.Random$name$(missionKey, key, thistype.STARTED, thistype.Count$name$s(missionKey, key))
                endmethod

                static method FetchFirst$name$ takes integer missionKey, integer key returns $type$
                    local integer count = thistype.Count$name$s(missionKey, key)
                    local $type$ value

                    if (count == thistype.EMPTY) then
                        return HASH_TABLE.$name$.DEFAULT_VALUE
                    endif

                    set value = thistype.Get$name$(missionKey, key, count)

                    call thistype.SetCount(missionKey, key, count - 1)
                    call thistype.POS_CACHE.$name$.Remove(missionKey, thistype.GetReverseKey(key, $valueConverter$(value)))
                    call MemoryHead.IntegerKeys.Remove$name$(missionKey, key + count)

                    return value
                endmethod

                static method Clear$name$s takes integer missionKey, integer key returns nothing
                    local integer iteration = thistype.Count$name$s(missionKey, key)
                    local $type$ value

                    call thistype.SetCount(missionKey, key, thistype.EMPTY)
                    loop
                        exitwhen (iteration < thistype.STARTED)

                        set value = thistype.Get$name$(missionKey, key, iteration)

                        call MemoryHead.IntegerKeys.Remove$name$(missionKey, key + iteration)
                        call thistype.POS_CACHE.Integer.Remove(missionKey, thistype.GetReverseKey(key, $valueConverter$(value)))

                        set iteration = iteration - 1
                    endloop
                endmethod

                static method Add$name$ takes integer missionKey, integer key, $type$ value returns boolean
                    local integer count = thistype.Count$name$s(missionKey, key) + 1

                    call thistype.SetCount(missionKey, key, count)
                    call thistype.POS_CACHE.Integer.Set(missionKey, thistype.GetReverseKey(key, $valueConverter$(value)), count)
                    call MemoryHead.IntegerKeys.Set$name$(missionKey, key + count, value)

                    return (count == thistype.STARTED)
                endmethod

                static method Join$name$ takes integer missionKey, integer key, integer missionKey2, integer key2 returns nothing
                    local integer count = thistype.Count$name$s(missionKey2, key2)
                    local integer iteration
                    local integer pos
                    local $type$ value

                    if (count == thistype.EMPTY) then
                        return
                    endif

                    set iteration = thistype.STARTED
                    set pos = thistype.Count$name$s(missionKey, key) + 1

                    call thistype.SetCount(missionKey, key, pos + count - thistype.EMPTY)
                    loop
                        set value = thistype.Get$name$(missionKey2, key2, iteration)

                        call thistype.POS_CACHE.Integer.Set(missionKey, thistype.GetReverseKey(key, $valueConverter$(value)), pos)
                        call MemoryHead.IntegerKeys.Set$name$(missionKey, key + pos, value)

                        set iteration = iteration + 1

                        exitwhen (iteration > count)

                        set pos = pos + 1
                    endloop
                endmethod

                static method Remove$name$ takes integer missionKey, integer key, $type$ value returns boolean
                    local integer count = thistype.Count$name$s(missionKey, key)
                    local integer reverseKey = thistype.GetReverseKey(key, $valueConverter$(value))

                    local $type$ lastValue = thistype.Get$name$(missionKey, key, count)
                    local integer pos = thistype.POS_CACHE.Integer.Get(missionKey, reverseKey)

debug                    if (thistype.Contains$name$(missionKey, key, value) == false) then
debug                        //debugMsg
debug
debug                        return false
debug                    endif

                    call thistype.POS_CACHE.Integer.Set(missionKey, thistype.GetReverseKey(key, $valueConverter$(lastValue)), pos)
                    call MemoryHead.IntegerKeys.Set$name$(missionKey, key + pos, lastValue)

                    call thistype.POS_CACHE.Integer.Remove(missionKey, reverseKey)
                    call MemoryHead.IntegerKeys.Remove$name$(missionKey, key + count)

                    set count = count - 1

                    call thistype.SetCount(missionKey, key, count)

                    return (count == thistype.EMPTY)
                endmethod

                static method Remove$name$ByIndex takes integer missionKey, integer key, integer index returns boolean
                    return thistype.Remove$name$(missionKey, key, thistype.Get$name$(missionKey, key, index))
                endmethod

                /////////////////////////////////////

                static method Count$name$sByHandle takes handle source, integer key returns integer
                    return thistype.Count$name$s(GetHandleId(source), key)
                endmethod

                static method Get$name$ByHandle takes handle source, integer key, integer index returns $type$
                    return thistype.Get$name$(GetHandleId(source), key, index)
                endmethod

                static method Random$name$ByHandle takes handle handleSource, integer key, integer lowerBound, integer higherBound returns $type$
                    return thistype.Random$name$(GetHandleId(handleSource), key, lowerBound, higherBound)
                endmethod

                static method Add$name$ByHandle takes handle source, integer key, $type$ value returns boolean
                    return thistype.Add$name$(GetHandleId(source), key, value)
                endmethod

                static method Remove$name$ByHandle takes handle source, integer key, $type$ value returns boolean
                    return thistype.Remove$name$(GetHandleId(source), key, value)
                endmethod
            //! endtextmacro

            //! runtextmacro Memory_IntegerKeys_Table_CreateType("Boolean", "boolean", "B2S", "Boolean.ToInt")
            //! runtextmacro Memory_IntegerKeys_Table_CreateType("Integer", "integer", "I2S", "")
            //! runtextmacro Memory_IntegerKeys_Table_CreateType("Real", "real", "R2S", "Real.ToInt")
            //! runtextmacro Memory_IntegerKeys_Table_CreateType("String", "string", "", "String.ToIntHash")

            static method Clear takes integer missionKey, integer key returns nothing
                call thistype.ClearIntegers(missionKey, key)
            endmethod

            static method Init takes nothing returns nothing
                set thistype.POS_CACHE = HashTable.Create()
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("IntegerKeys")
        //! runtextmacro LinkToStaticStruct("IntegerKeys", "Table")

        static method RemoveChild takes integer missionKey returns nothing
            call MemoryHead.IntegerKeys.RemoveChild(missionKey)
        endmethod

        //! textmacro Memory_IntegerKeys_CreateType takes name, type
            static method Contains$name$ takes integer missionKey, integer key returns boolean
                return MemoryHead.IntegerKeys.Contains$name$(missionKey, key)
            endmethod

            static method Get$name$ takes integer handleSource, integer key returns $type$
            if (handleSource==ID) then
            endif
                return MemoryHead.IntegerKeys.Get$name$(handleSource, key)
            endmethod

            static method Get$name$ByHandle takes handle handleSource, integer key returns $type$
                return MemoryHead.IntegerKeys.Get$name$ByHandle(handleSource, key)
            endmethod

            static method Set$name$ takes integer missionKey, integer key, $type$ value returns nothing
                call MemoryHead.IntegerKeys.Set$name$(missionKey, key, value)
            endmethod

            static method Set$name$ByHandle takes handle handleSource, integer key, $type$ value returns nothing
                call thistype.Set$name$(GetHandleId(handleSource), key, value)
            endmethod

            static method Remove$name$ takes integer missionKey, integer key returns nothing
                call MemoryHead.IntegerKeys.Remove$name$(missionKey, key)
            endmethod

            static method Remove$name$ByHandle takes handle handleSource, integer key returns nothing
                call MemoryHead.IntegerKeys.Remove$name$ByHandle(handleSource, key)
            endmethod
        //! endtextmacro

        //! runtextmacro Memory_IntegerKeys_CreateType("Boolean", "boolean")
        //! runtextmacro Memory_IntegerKeys_CreateType("Integer", "integer")
        //! runtextmacro Memory_IntegerKeys_CreateType("Real", "real")
        //! runtextmacro Memory_IntegerKeys_CreateType("String", "string")

        static method Init takes nothing returns nothing
            call thistype.Table.Init()
        endmethod
    endstruct

    //! runtextmacro Folder("StringKeys")
        //! runtextmacro Struct("Table")
            static constant integer EMPTY = -1
            static constant integer STARTED = 0

            //! textmacro Memory_StringKeys_Table_CreateType takes name, type, bugConverter
                static method Count$name$s takes string missionKey, string key returns integer
                    return (thistype.EMPTY + MemoryHead.StringKeys.GetInteger(missionKey, key))
                endmethod

                static method Get$name$ takes string missionKey, string key, integer index returns $type$
                    return MemoryHead.StringKeys.Get$name$(missionKey, key + I2S(thistype.EMPTY + index + 2))
                endmethod

                static method Contains$name$ takes string missionKey, string key, $type$ value returns boolean
                    local integer iteration = thistype.Count$name$s(missionKey, key)

                    loop
                        exitwhen (iteration < thistype.STARTED)

                        exitwhen (thistype.Get$name$(missionKey, key, iteration) == value)

                        set iteration = iteration - 1
                    endloop

                    if (iteration < thistype.STARTED) then
                        return false
                    endif

                    return true
                endmethod

                static method Add$name$ takes string missionKey, string key, $type$ value returns boolean
                    local integer count = thistype.Count$name$s(missionKey, key) + 1

                    call MemoryHead.StringKeys.SetInteger(missionKey, key, count - thistype.EMPTY)
                    call MemoryHead.StringKeys.Set$name$(missionKey, key + I2S(thistype.EMPTY + count + 2), value)

                    return (count == thistype.STARTED)
                endmethod

                static method Remove$name$ takes string missionKey, string key, $type$ value returns boolean
                    local integer count = thistype.Count$name$s(missionKey, key)

                    local integer iteration = count

                    loop
debug                        exitwhen (iteration < thistype.STARTED)

                        exitwhen (thistype.Get$name$(missionKey, key, iteration) == value)

                        set iteration = iteration - 1
                    endloop

debug                    if (iteration < thistype.STARTED) then
debug                        call Game.DebugMsg("Failed to remove "+$bugConverter$(value)+" from table "+key+" of missionKey "+missionKey+" ("+I2S(count)+")")
debug                    else
                    call MemoryHead.StringKeys.Set$name$(missionKey, key + I2S(thistype.EMPTY + iteration + 2), thistype.Get$name$(missionKey, key, count))

                    set count = count - 1

                    call MemoryHead.StringKeys.SetInteger(missionKey, key, count)
debug                    endif

                    return (count == thistype.EMPTY)
                endmethod

                static method Random$name$ takes string missionKey, string key, integer lowerBound, integer higherBound returns $type$
                    return thistype.Get$name$(missionKey, key, Math.RandomI(lowerBound, higherBound))
                endmethod

                static method Random$name$All takes string missionKey, string key returns $type$
                    return thistype.Random$name$(missionKey, key, thistype.STARTED, thistype.Count$name$s(missionKey, key))
                endmethod
            //! endtextmacro

            //! runtextmacro Memory_StringKeys_Table_CreateType("Boolean", "boolean", "B2S")
            //! runtextmacro Memory_StringKeys_Table_CreateType("Integer", "integer", "I2S")
            //! runtextmacro Memory_StringKeys_Table_CreateType("Real", "real", "R2S")
            //! runtextmacro Memory_StringKeys_Table_CreateType("String", "string", "")
        endstruct
    endscope

    //! runtextmacro Struct("StringKeys")
        //! runtextmacro LinkToStaticStruct("StringKeys", "Table")

        static method RemoveChild takes string missionKey returns nothing
            call MemoryHead.StringKeys.RemoveChild(missionKey)
        endmethod

        //! textmacro Memory_StringKeys_CreateType takes name, type
            static method Set$name$ takes string missionKey, string key, $type$ value returns nothing
                call MemoryHead.StringKeys.Set$name$(missionKey, key, value)
            endmethod

            static method Remove$name$ takes string missionKey, string key returns nothing
                call MemoryHead.StringKeys.Remove$name$(missionKey, key)
            endmethod

            static method Get$name$ takes string missionKey, string key returns $type$
                return MemoryHead.StringKeys.Get$name$(missionKey, key)
            endmethod
        //! endtextmacro

        //! runtextmacro Memory_StringKeys_CreateType("Boolean", "boolean")
        //! runtextmacro Memory_StringKeys_CreateType("Integer", "integer")
        //! runtextmacro Memory_StringKeys_CreateType("Real", "real")
        //! runtextmacro Memory_StringKeys_CreateType("String", "string")
    endstruct
endscope

//! runtextmacro StaticStruct("Memory")
    //! runtextmacro LinkToStaticStruct("Memory", "IntegerKeys")
    //! runtextmacro LinkToStaticStruct("Memory", "StringKeys")

    static method Init takes nothing returns nothing
        call MemoryHead.Init()

        call thistype.IntegerKeys.Init()
        //call thistype.StringKeys.Init()
    endmethod
endstruct

//! textmacro GetKey takes name
    static key $name$_BASE
    static constant integer $name$ = Math.Integer.MIN + $name$_BASE
//! endtextmacro

//! textmacro GetKeyArray takes name
    static key $name$_BASE

    static constant integer $name$ = Math.Integer.MIN + Memory.IntegerKeys.Table.OFFSET + $name$_BASE * Memory.IntegerKeys.Table.SIZE
//! endtextmacro

//! textmacro Data_Implement takes baseType
    method Destroy takes nothing returns nothing
        call Memory.IntegerKeys.RemoveChild($baseType$(this).Id.Get())
    endmethod
//! endtextmacro

//! textmacro Data_Type_Implement takes baseType, whichTypeName, whichType
    method Get takes integer key returns $whichType$
        return Memory.IntegerKeys.Get$whichTypeName$($baseType$(this).Id.Get(), key)
    endmethod

    method Is takes integer key returns boolean
        return (this.Get(key) != HASH_TABLE.$whichTypeName$.DEFAULT_VALUE)
    endmethod

    method Remove takes integer key returns nothing
        call Memory.IntegerKeys.Remove$whichTypeName$($baseType$(this).Id.Get(), key)
    endmethod

    method Set takes integer key, $whichType$ value returns nothing
    if ($baseType$(this).Id.Get()==ID) then
    if (ID==0) then
        set ID=-1
    endif
    call BJDebugMsg("memory "+I2S(ID)+";"+I2S(key)+" --> "+$whichType$ToString(value))
    endif
        call Memory.IntegerKeys.Set$whichTypeName$($baseType$(this).Id.Get(), key, value)
    endmethod
//! endtextmacro

//! textmacro Data_Boolean_Implement takes baseType
    method Add takes integer key returns boolean
        local boolean oldValue = this.Get(key)

        call this.Set(key, HASH_TABLE.Boolean.DEFAULT_VALUE == false)

        return (oldValue == HASH_TABLE.Boolean.DEFAULT_VALUE)
    endmethod

    method Subtract takes integer key returns boolean
        local boolean oldValue = this.Get(key)

        call this.Set(key, HASH_TABLE.Boolean.DEFAULT_VALUE)

        return (oldValue != HASH_TABLE.Boolean.DEFAULT_VALUE)
    endmethod
//! endtextmacro

//! textmacro Data_Integer_Implement takes baseType
    method Contains takes integer key returns boolean
        return (this.Get(key) > HASH_TABLE.Integer.DEFAULT_VALUE)
    endmethod

    method Add takes integer key, integer value returns boolean
        local integer oldValue = this.Get(key)

        call this.Set(key, oldValue + value)

        if (oldValue != HASH_TABLE.Integer.DEFAULT_VALUE) then
            return false
        endif

        return (value != HASH_TABLE.Integer.DEFAULT_VALUE)
    endmethod

    method Subtract takes integer key, integer value returns boolean
        local integer oldValue = this.Get(key)

        set value = (oldValue - value)

        call this.Set(key, value)

        if (oldValue == HASH_TABLE.Integer.DEFAULT_VALUE) then
            return false
        endif

        return (value == HASH_TABLE.Integer.DEFAULT_VALUE)
    endmethod
//! endtextmacro

//! textmacro Data_Real_Implement takes baseType
    method Add takes integer key, real value returns boolean
        local real oldValue = this.Get(key)

        call this.Set(key, oldValue + value)

        if (oldValue != HASH_TABLE.Real.DEFAULT_VALUE) then
            return false
        endif

        return (value != HASH_TABLE.Real.DEFAULT_VALUE)
    endmethod

    method Subtract takes integer key, real value returns boolean
        local real oldValue = this.Get(key)

        set value = (oldValue - value)

        call this.Set(key, value)

        if (oldValue == HASH_TABLE.Real.DEFAULT_VALUE) then
            return false
        endif

        return (value == HASH_TABLE.Real.DEFAULT_VALUE)
    endmethod
//! endtextmacro

//! textmacro Data_String_Implement takes baseType
    method Add takes integer key, string value returns boolean
        local string oldValue = this.Get(key)

        call this.Set(key, oldValue + value)

        if (oldValue != HASH_TABLE.String.DEFAULT_VALUE) then
            return false
        endif

        return (value != HASH_TABLE.String.DEFAULT_VALUE)
    endmethod

    method Subtract takes integer key, real value returns boolean
        local string oldValue = this.Get(key)

        set value = (oldValue - value)

        call this.Set(key, value)

        if (oldValue == HASH_TABLE.String.DEFAULT_VALUE) then
            return false
        endif

        return (value == HASH_TABLE.String.DEFAULT_VALUE)
    endmethod
//! endtextmacro

//! textmacro Data_Type_Table_Implement takes baseType, whichTypeName, whichType
    method Contains takes integer key, $whichType$ value returns boolean
        return Memory.IntegerKeys.Table.Contains$whichTypeName$($baseType$(this).Id.Get(), key, value)
    endmethod

    method Count takes integer key returns integer
        return Memory.IntegerKeys.Table.Count$whichTypeName$s($baseType$(this).Id.Get(), key)
    endmethod

    method Get takes integer key, integer index returns $whichType$
        return Memory.IntegerKeys.Table.Get$whichTypeName$($baseType$(this).Id.Get(), key, index)
    endmethod

    method GetFirst takes integer key returns $whichType$
        return Memory.IntegerKeys.Table.GetFirst$whichTypeName$($baseType$(this).Id.Get(), key)
    endmethod

    method Clear takes integer key returns nothing
        call Memory.IntegerKeys.Table.Clear($baseType$(this).Id.Get(), key)
    endmethod

    method FetchFirst takes integer key returns $whichType$
        return Memory.IntegerKeys.Table.FetchFirst$whichTypeName$($baseType$(this).Id.Get(), key)
    endmethod

    method Remove takes integer key, $whichType$ value returns boolean
        return Memory.IntegerKeys.Table.Remove$whichTypeName$($baseType$(this).Id.Get(), key, value)
    endmethod

    method RemoveByIndex takes integer key, integer index returns boolean
        return Memory.IntegerKeys.Table.Remove$whichTypeName$ByIndex($baseType$(this).Id.Get(), key, index)
    endmethod

    method Add takes integer key, $whichType$ value returns boolean
        return Memory.IntegerKeys.Table.Add$whichTypeName$($baseType$(this).Id.Get(), key, value)
    endmethod

    method Join takes integer key, thistype other returns nothing
        call Memory.IntegerKeys.Table.Join$whichTypeName$($baseType$(this).Id.Get(), key, $baseType$(other).Id.Get(), key)
    endmethod

    method Random takes integer key, integer lowerBound, integer higherBound returns $whichType$
        return Memory.IntegerKeys.Table.Random$whichTypeName$($baseType$(this).Id.Get(), key, lowerBound, higherBound)
    endmethod

    method RandomAll takes integer key returns $whichType$
        return this.Random(key, Memory.IntegerKeys.Table.STARTED, this.Count(key))
    endmethod
//! endtextmacro

//! textmacro Data_StringKey_Implement
    static method Destroy takes string whichString returns nothing
        call Memory.StringKeys.RemoveChild(whichString)
    endmethod
//! endtextmacro

//! textmacro Data_StringKey_Type_Implement takes whichTypeName, whichType
    static method Get takes string whichString, integer key returns $whichType$
        return Memory.StringKeys.Get$whichTypeName$(whichString, Integer.ToString(key))
    endmethod

    static method Remove takes string whichString, integer key returns nothing
        call Memory.StringKeys.Remove$whichTypeName$(whichString, Integer.ToString(key))
    endmethod

    static method Set takes string whichString, integer key, $whichType$ value returns nothing
        call Memory.StringKeys.Set$whichTypeName$(whichString, Integer.ToString(key), value)
    endmethod
//! endtextmacro

//! textmacro Data_StringKey_Type_Table_Implement takes whichTypeName, whichType
    static method Count takes string whichString, integer key returns integer
        return Memory.StringKeys.Table.Count$whichTypeName$s(whichString, Integer.ToString(key))
    endmethod

    static method Get takes string whichString, integer key, integer index returns $whichType$
        return Memory.StringKeys.Table.Get$whichTypeName$(whichString, Integer.ToString(key), index)
    endmethod

    static method Remove takes string whichString, integer key, $whichType$ value returns boolean
        return Memory.StringKeys.Table.Remove$whichTypeName$(whichString, Integer.ToString(key), value)
    endmethod

    static method Add takes string whichString, integer key, $whichType$ value returns boolean
        return Memory.StringKeys.Table.Add$whichTypeName$(whichString, Integer.ToString(key), value)
    endmethod

    static method Random takes string whichString, integer key, integer lowerBound, integer higherBound returns $whichType$
        return Memory.StringKeys.Table.Random$whichTypeName$(whichString, Integer.ToString(key), lowerBound, higherBound)
    endmethod

    static method RandomAll takes string whichString, integer key returns $whichType$
        return thistype.Random(whichString, key, Memory.IntegerKeys.Table.STARTED, thistype.Count(whichString, key))
    endmethod
//! endtextmacro