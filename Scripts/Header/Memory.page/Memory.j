//! runtextmacro Folder("GameCache")
    //! textmacro GameCache_CreateType takes containsFunc, getFunc, setFunc, syncFunc, type, defaultValue
        static constant $type$ DEFAULT_VALUE = $defaultValue$

        method Contains takes string missionKey, string key returns boolean
            return $containsFunc$(GameCache(this).self, missionKey, key)
        endmethod

        method Get takes string missionKey, string key returns $type$
            if ((missionKey == null) or (key == null)) then
                call DebugEx("GameCache Get: "+missionKey+";"+key)

                return $defaultValue$
            endif

            return $getFunc$(GameCache(this).self, missionKey, key)
        endmethod

        method Set takes string missionKey, string key, $type$ value returns nothing
            if ((missionKey == null) or (key == null)) then
                call DebugEx("GameCache Set: "+missionKey+";"+key)

                return
            endif

            call $setFunc$(GameCache(this).self, missionKey, key, value)
        endmethod

        method Remove takes string missionKey, string key returns nothing
            call this.Set(missionKey, key, thistype.DEFAULT_VALUE)
        endmethod
        
        method Sync takes string missionKey, string key returns nothing
        	call $syncFunc$(GameCache(this).self, missionKey, key)
        endmethod

        method SetAndSync takes string missionKey, string key, $type$ value returns nothing
        	call this.Set(missionKey, key, value)
        	
        	call this.Sync(missionKey, key)
        endmethod
    //! endtextmacro

    //! runtextmacro Struct("Boolean")
        //! runtextmacro GameCache_CreateType("HaveStoredBoolean", "GetStoredBoolean", "StoreBoolean", "SyncStoredBoolean", "boolean", "false")
    endstruct

    //! runtextmacro Struct("Integer")
        //! runtextmacro GameCache_CreateType("HaveStoredInteger", "GetStoredInteger", "StoreInteger", "SyncStoredInteger", "integer", "0")
    endstruct

    //! runtextmacro Struct("Real")
        //! runtextmacro GameCache_CreateType("HaveStoredReal", "GetStoredReal", "StoreReal", "SyncStoredReal", "real", "0.")
    endstruct

    //! runtextmacro Struct("String")
        //! runtextmacro GameCache_CreateType("HaveStoredString", "GetStoredString", "StoreString", "SyncStoredString", "string", "null")
    endstruct
endscope

//! runtextmacro BaseStruct("GameCache", "GAME_CACHE")
    gamecache self

    //! runtextmacro LinkToStruct("GameCache", "Boolean")
    //! runtextmacro LinkToStruct("GameCache", "Integer")
    //! runtextmacro LinkToStruct("GameCache", "Real")
    //! runtextmacro LinkToStruct("GameCache", "String")

    method RemoveChild takes string missionKey returns nothing
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
            return $getFunc$(HashTable(this).self, missionKey, key)
        endmethod

        method Set takes integer missionKey, integer key, $type$ value returns nothing
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
        //! runtextmacro HashTable_CreateType("HaveSavedString", "LoadStr", "SaveStr", "RemoveSavedString", "string", "null", "")
    endstruct
endscope

//! runtextmacro BaseStruct("HashTable", "HASH_TABLE")
    hashtable self

    //! runtextmacro LinkToStruct("HashTable", "Boolean")
    //! runtextmacro LinkToStruct("HashTable", "Integer")
    //! runtextmacro LinkToStruct("HashTable", "Real")
    //! runtextmacro LinkToStruct("HashTable", "String")

    method RemoveChild takes integer missionKey returns nothing
        call FlushChildHashtable(this.self, missionKey)
    endmethod

    static method Create takes nothing returns thistype
        local thistype this = thistype.allocate()

        set this.self = InitHashtable()

        return this
    endmethod
endstruct

//! runtextmacro Folder("DataTableHead")
    //! runtextmacro Folder("IntegerKeys")
        //! runtextmacro Struct("D2")
            HashTable CACHE
            static constant integer SIZE = 8192

            static method GetFirstKey takes integer pivotKey, integer subject1, integer subject2 returns integer
                set pivotKey = pivotKey - Math.Integer.MIN

				local integer res = (pivotKey div 64 * SIZE * SIZE + subject1 * SIZE + subject2)

                return res
            endmethod

            static method GetSecondKey takes integer pivotKey, integer subject3, integer subject4 returns integer
                set pivotKey = pivotKey - Math.Integer.MIN

                local integer res = ((pivotKey - pivotKey div 64 * 64) * SIZE * SIZE + subject3 * SIZE + subject4)

                return res
            endmethod

            //! textmacro DataTableHead_IntegerKeys_D2_CreateType takes name, type
                method Contains$name$ takes integer pivotKey, integer subject1, integer subject2, integer subject3, integer subject4 returns boolean
                    return this.CACHE.$name$.Contains(thistype.GetFirstKey(pivotKey, subject1, subject2), thistype.GetSecondKey(pivotKey, subject3, subject4))
                endmethod

                method Get$name$ takes integer pivotKey, integer subject1, integer subject2, integer subject3, integer subject4 returns $type$
                    return this.CACHE.$name$.Get(thistype.GetFirstKey(pivotKey, subject1, subject2), thistype.GetSecondKey(pivotKey, subject3, subject4))
                endmethod

                method Set$name$ takes integer pivotKey, integer subject1, integer subject2, integer subject3, integer subject4, $type$ value returns nothing
                    call this.CACHE.$name$.Set(thistype.GetFirstKey(pivotKey, subject1, subject2), thistype.GetSecondKey(pivotKey, subject3, subject4), value)
                endmethod

                method Remove$name$ takes integer pivotKey, integer subject1, integer subject2, integer subject3, integer subject4 returns nothing
                    call this.CACHE.$name$.Remove(thistype.GetFirstKey(pivotKey, subject1, subject2), thistype.GetSecondKey(pivotKey, subject3, subject4))
                endmethod

                method Contains$name$WithCache takes HashTable cache, integer pivotKey, integer subject1, integer subject2, integer subject3, integer subject4 returns boolean
                    return cache.$name$.Contains(thistype.GetFirstKey(pivotKey, subject1, subject2), thistype.GetSecondKey(pivotKey, subject3, subject4))
                endmethod

                method Get$name$WithCache takes HashTable cache, integer pivotKey, integer subject1, integer subject2, integer subject3, integer subject4 returns $type$
                    return cache.$name$.Get(thistype.GetFirstKey(pivotKey, subject1, subject2), thistype.GetSecondKey(pivotKey, subject3, subject4))
                endmethod

                method Set$name$WithCache takes HashTable cache, integer pivotKey, integer subject1, integer subject2, integer subject3, integer subject4, $type$ value returns nothing
                    call cache.$name$.Set(thistype.GetFirstKey(pivotKey, subject1, subject2), thistype.GetSecondKey(pivotKey, subject3, subject4), value)
                endmethod

                method Remove$name$WithCache takes HashTable cache, integer pivotKey, integer subject1, integer subject2, integer subject3, integer subject4 returns nothing
                    call cache.$name$.Remove(thistype.GetFirstKey(pivotKey, subject1, subject2), thistype.GetSecondKey(pivotKey, subject3, subject4))
                endmethod
            //! endtextmacro

            //! runtextmacro DataTableHead_IntegerKeys_D2_CreateType("Boolean", "boolean")
            //! runtextmacro DataTableHead_IntegerKeys_D2_CreateType("Integer", "integer")
            //! runtextmacro DataTableHead_IntegerKeys_D2_CreateType("Real", "real")
            //! runtextmacro DataTableHead_IntegerKeys_D2_CreateType("String", "string")

			method Event_Create takes nothing returns nothing
				set this.CACHE = HashTable.Create()
			endmethod
        endstruct
    endscope

    //! runtextmacro Struct("IntegerKeys")
        HashTable CACHE

        //! runtextmacro LinkToStruct("IntegerKeys", "D2")

        method RemoveChild takes integer missionKey returns nothing
            call this.CACHE.RemoveChild(missionKey)
        endmethod

        //! textmacro DataTableHead_IntegerKeys_CreateType takes name, type
            method Contains$name$ takes integer missionKey, integer key returns boolean
                return this.CACHE.$name$.Contains(missionKey, key)
            endmethod

            method Get$name$ takes integer missionKey, integer key returns $type$
                return this.CACHE.$name$.Get(missionKey, key)
            endmethod

            method Get$name$ByHandle takes handle handleSource, integer key returns $type$
                return this.Get$name$(GetHandleId(handleSource), key)
            endmethod

            method Set$name$ takes integer missionKey, integer key, $type$ value returns nothing
                call this.CACHE.$name$.Set(missionKey, key, value)
            endmethod

            method Set$name$ByHandle takes handle handleSource, integer key, $type$ value returns nothing
                call this.Set$name$(GetHandleId(handleSource), key, value)
            endmethod

            method Remove$name$ takes integer missionKey, integer key returns nothing
                call this.CACHE.$name$.Remove(missionKey, key)
            endmethod

            method Remove$name$ByHandle takes handle handleSource, integer key returns nothing
                call this.Remove$name$(GetHandleId(handleSource), key)
            endmethod
        //! endtextmacro

        //! runtextmacro DataTableHead_IntegerKeys_CreateType("Boolean", "boolean")
        //! runtextmacro DataTableHead_IntegerKeys_CreateType("Integer", "integer")
        //! runtextmacro DataTableHead_IntegerKeys_CreateType("Real", "real")
        //! runtextmacro DataTableHead_IntegerKeys_CreateType("String", "string")

		method Event_Create takes nothing returns nothing
			set this.CACHE = HashTable.Create()

			call this.D2.Event_Create()
		endmethod
    endstruct

    //! runtextmacro Struct("StringKeys")
        GameCache CACHE

        method RemoveChild takes string missionKey returns nothing
            call this.CACHE.RemoveChild(missionKey)
        endmethod

        //! textmacro DataTableHead_StringKeys_CreateType takes name, type
            method Set$name$ takes string missionKey, string key, $type$ value returns nothing
                call this.CACHE.$name$.Set(missionKey, key, value)
            endmethod

            method Remove$name$ takes string missionKey, string key returns nothing
                call this.CACHE.$name$.Remove(missionKey, key)
            endmethod

            method Get$name$ takes string missionKey, string key returns $type$
                return this.CACHE.$name$.Get(missionKey, key)
            endmethod
        //! endtextmacro

        //! runtextmacro DataTableHead_StringKeys_CreateType("Boolean", "boolean")
        //! runtextmacro DataTableHead_StringKeys_CreateType("Integer", "integer")
        //! runtextmacro DataTableHead_StringKeys_CreateType("Real", "real")
        //! runtextmacro DataTableHead_StringKeys_CreateType("String", "string")

		method Event_Create takes nothing returns nothing
			set this.CACHE = GameCache.Create()
		endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("DataTableHead", "DATA_TABLE_HEAD")
    //! runtextmacro LinkToStruct("DataTableHead", "IntegerKeys")
    //! runtextmacro LinkToStruct("DataTableHead", "StringKeys")

	static method Create takes nothing returns thistype
		local thistype this = thistype.allocate()

		call this.IntegerKeys.Event_Create()
		call this.StringKeys.Event_Create()

		return this
	endmethod

    static method Init takes nothing returns nothing
    endmethod
endstruct

//! runtextmacro Folder("DataTable")
    //! runtextmacro Folder("IntegerKeys")
        //! runtextmacro Folder("D2")
            //! runtextmacro Struct("Table")
                static constant integer EMPTY = HASH_TABLE.Integer.DEFAULT_VALUE//-1

                HashTable FIRST_CACHE
                HashTable LAST_CACHE

                HashTable NEXT_CACHE
                HashTable PREV_CACHE
                HashTable PRIO_CACHE

                //! textmacro DataTable_IntegerKeys_D2_Table_CreateType takes name, type, bugConverter, valueConverter
                    method GetFirst$name$ takes integer pivotKey, integer subject1, integer subject2, integer subject3 returns $type$
                        return DataTable(this).Head.IntegerKeys.D2.Get$name$WithCache(this.FIRST_CACHE, pivotKey, subject1, subject2, subject3, 0)
                    endmethod

                    method GetLast$name$ takes integer pivotKey, integer subject1, integer subject2, integer subject3 returns $type$
                        return DataTable(this).Head.IntegerKeys.D2.Get$name$WithCache(this.LAST_CACHE, pivotKey, subject1, subject2, subject3, 0)
                    endmethod

                    method GetNext$name$ takes integer pivotKey, integer subject1, integer subject2, integer subject3, $type$ value returns $type$
                        return DataTable(this).Head.IntegerKeys.D2.Get$name$WithCache(this.NEXT_CACHE, pivotKey, subject1, subject2, subject3, $valueConverter$(value))
                    endmethod

                    method GetPrev$name$ takes integer pivotKey, integer subject1, integer subject2, integer subject3, $type$ value returns $type$
                        return DataTable(this).Head.IntegerKeys.D2.Get$name$WithCache(this.PREV_CACHE, pivotKey, subject1, subject2, subject3, $valueConverter$(value))
                    endmethod

                    method Get$name$Prio takes integer pivotKey, integer subject1, integer subject2, integer subject3, $type$ value returns integer
                        return DataTable(this).Head.IntegerKeys.D2.GetIntegerWithCache(this.PRIO_CACHE, pivotKey, subject1, subject2, subject3, $valueConverter$(value))
                    endmethod

                    method Get$name$sMaxPrio takes integer pivotKey, integer subject1, integer subject2, integer subject3 returns integer
                    	local $type$ value = this.GetFirst$name$(pivotKey, subject1, subject2, subject3)

                    	local integer result = 0

                        loop
                            exitwhen (value == HASH_TABLE.$name$.DEFAULT_VALUE)

                            local integer prio = this.Get$name$Prio(pivotKey, subject1, subject2, subject3, value)

                            if (prio > result) then
                                set result = prio
                            endif

                            set value = this.GetNext$name$(pivotKey, subject1, subject2, subject3, value)
                        endloop

                        return result
                    endmethod

                    method Remove$name$ takes integer pivotKey, integer subject1, integer subject2, integer subject3, $type$ value returns nothing
                        local $type$ next = this.GetNext$name$(pivotKey, subject1, subject2, subject3, value)
                        local $type$ prev = this.GetPrev$name$(pivotKey, subject1, subject2, subject3, value)

                        if ((prev == HASH_TABLE.$name$.DEFAULT_VALUE) and (next == HASH_TABLE.$name$.DEFAULT_VALUE)) then
                            if (this.GetFirst$name$(pivotKey, subject1, subject2, subject3) != value) then
                                return
                            endif
                        endif

                        if (next == HASH_TABLE.$name$.DEFAULT_VALUE) then
                            call DataTable(this).Head.IntegerKeys.D2.Set$name$WithCache(this.LAST_CACHE, pivotKey, subject1, subject2, subject3, 0, prev)
                        else
                            call DataTable(this).Head.IntegerKeys.D2.Set$name$WithCache(this.PREV_CACHE, pivotKey, subject1, subject2, subject3, $valueConverter$(next), prev)
                        endif

                        if (prev == HASH_TABLE.$name$.DEFAULT_VALUE) then
                            call DataTable(this).Head.IntegerKeys.D2.Set$name$WithCache(this.FIRST_CACHE, pivotKey, subject1, subject2, subject3, 0, next)
                        else
                            //set Memory.TEST=true
                            call DataTable(this).Head.IntegerKeys.D2.Set$name$WithCache(this.NEXT_CACHE, pivotKey, subject1, subject2, subject3, $valueConverter$(prev), next)
                            //set Memory.TEST=false
                        endif
                    endmethod

                    method FetchFirst$name$ takes integer pivotKey, integer subject1, integer subject2, integer subject3 returns $type$
                        local $type$ value = this.GetFirst$name$(pivotKey, subject1, subject2, subject3)

                        if (value == HASH_TABLE.$name$.DEFAULT_VALUE) then
                            return HASH_TABLE.$name$.DEFAULT_VALUE
                        endif

                        call this.Remove$name$(pivotKey, subject1, subject2, subject3, value)

                        return value
                    endmethod

                    method Clear$name$s takes integer pivotKey, integer subject1, integer subject2, integer subject3 returns nothing
                        loop
                            exitwhen (this.FetchFirst$name$(pivotKey, subject1, subject2, subject3) == HASH_TABLE.$name$.DEFAULT_VALUE)
                        endloop
                    endmethod

                    method InsertAfter$name$ takes integer pivotKey, integer subject1, integer subject2, integer subject3, $type$ prev, $type$ value returns boolean
                        local $type$ next

                        if (prev == HASH_TABLE.$name$.DEFAULT_VALUE) then
                            set next = this.GetFirst$name$(pivotKey, subject1, subject2, subject3)

                            call DataTable(this).Head.IntegerKeys.D2.Set$name$WithCache(this.FIRST_CACHE, pivotKey, subject1, subject2, subject3, 0, value)
                        else
                            set next = this.GetNext$name$(pivotKey, subject1, subject2, subject3, prev)

                            call DataTable(this).Head.IntegerKeys.D2.Set$name$WithCache(this.NEXT_CACHE, pivotKey, subject1, subject2, subject3, $valueConverter$(prev), value)
                        endif

                        if (next == HASH_TABLE.$name$.DEFAULT_VALUE) then
                            call DataTable(this).Head.IntegerKeys.D2.Set$name$WithCache(this.LAST_CACHE, pivotKey, subject1, subject2, subject3, 0, value)
                        else
                            call DataTable(this).Head.IntegerKeys.D2.Set$name$WithCache(this.PREV_CACHE, pivotKey, subject1, subject2, subject3, $valueConverter$(next), value)
                        endif

                        call DataTable(this).Head.IntegerKeys.D2.Set$name$WithCache(this.NEXT_CACHE, pivotKey, subject1, subject2, subject3, $valueConverter$(value), next)
                        call DataTable(this).Head.IntegerKeys.D2.Set$name$WithCache(this.PREV_CACHE, pivotKey, subject1, subject2, subject3, $valueConverter$(value), prev)

                        return true
                    endmethod

                    method Add$name$WithPrio takes integer pivotKey, integer subject1, integer subject2, integer subject3, $type$ value, integer prio returns boolean
                        local $type$ otherValue = this.GetLast$name$(pivotKey, subject1, subject2, subject3)

                        loop
                            exitwhen (otherValue == HASH_TABLE.$name$.DEFAULT_VALUE)

                            exitwhen (prio <= this.Get$name$Prio(pivotKey, subject1, subject2, subject3, otherValue))

                            set otherValue = this.GetPrev$name$(pivotKey, subject1, subject2, subject3, otherValue)
                        endloop

                        if not this.InsertAfter$name$(pivotKey, subject1, subject2, subject3, otherValue, value) then
                            return false
                        endif

                        call DataTable(this).Head.IntegerKeys.D2.SetIntegerWithCache(this.PRIO_CACHE, pivotKey, subject1, subject2, subject3, $valueConverter$(value), prio)

                        return true
                    endmethod

                    method Add$name$ takes integer pivotKey, integer subject1, integer subject2, integer subject3, $type$ value returns boolean
                    //local boolean pre=$bugConverter$(this.GetFirst$name$(UNIT.Buffs.LOCAL_REFS_KEY, 47, 123, 0))=="0"
                    //if $bugConverter$(this.GetFirst$name$(UNIT.Buffs.LOCAL_REFS_KEY, 47, 123, 0))!="0" then
                        //call DebugEx("pre============================== "+$bugConverter$(this.GetFirst$name$(UNIT.Buffs.LOCAL_REFS_KEY, 47, 123, 0))+" +++ "+I2S(BuffRef(186).whichBuff))
                    //endif
//                    call DebugEx("\t\tadd: "+I2S(pivotKey)+";"+I2S(subject1)+";"+I2S(subject2)+";"+I2S(subject3)+";"+$bugConverter$(value))
                    //local boolean res=this.Add$name$WithPrio(pivotKey, subject1, subject2, subject3, value, 0)
                    //if $bugConverter$(this.GetFirst$name$(UNIT.Buffs.LOCAL_REFS_KEY, 47, 123, 0))!="0" then
                      //  call DebugEx("================================= "+$bugConverter$(this.GetFirst$name$(UNIT.Buffs.LOCAL_REFS_KEY, 47, 123, 0))+" +++ "+I2S(BuffRef(186).whichBuff))
                    //endif
                        return this.Add$name$WithPrio(pivotKey, subject1, subject2, subject3, value, 0)
                    endmethod
                //! endtextmacro

                //! runtextmacro DataTable_IntegerKeys_D2_Table_CreateType("Boolean", "boolean", "B2S", "Boolean.ToInt")
                //! runtextmacro DataTable_IntegerKeys_D2_Table_CreateType("Integer", "integer", "I2S", "")
                //! runtextmacro DataTable_IntegerKeys_D2_Table_CreateType("Real", "real", "R2S", "Real.ToInt")
                //! runtextmacro DataTable_IntegerKeys_D2_Table_CreateType("String", "string", "", "String.ToIntHash")

				method Event_Create takes nothing returns nothing
                    set this.FIRST_CACHE = HashTable.Create()
                    set this.LAST_CACHE = HashTable.Create()

                    set this.NEXT_CACHE = HashTable.Create()
                    set this.PREV_CACHE = HashTable.Create()
                    set this.PRIO_CACHE = HashTable.Create()
				endmethod
            endstruct
        endscope

        //! runtextmacro Struct("D2")
            //! runtextmacro LinkToStruct("D2", "Table")

            //! textmacro DataTable_IntegerKeys_D2_CreateType takes name, type, bugConv
                method Contains$name$ takes integer pivotKey, integer subject1, integer subject2, integer subject3, integer subject4 returns boolean
                    return DataTable(this).Head.IntegerKeys.D2.Contains$name$(pivotKey, subject1, subject2, subject3, subject4)
                endmethod

                method Get$name$ takes integer pivotKey, integer subject1, integer subject2, integer subject3, integer subject4 returns $type$
                    return DataTable(this).Head.IntegerKeys.D2.Get$name$(pivotKey, subject1, subject2, subject3, subject4)
                endmethod

                method Set$name$ takes integer pivotKey, integer subject1, integer subject2, integer subject3, integer subject4, $type$ value returns nothing
                    call DataTable(this).Head.IntegerKeys.D2.Set$name$(pivotKey, subject1, subject2, subject3, subject4, value)
                endmethod

                method Remove$name$ takes integer pivotKey, integer subject1, integer subject2, integer subject3, integer subject4 returns nothing
                    call DataTable(this).Head.IntegerKeys.D2.Remove$name$(pivotKey, subject1, subject2, subject3, subject4)
                endmethod
            //! endtextmacro

            //! runtextmacro DataTable_IntegerKeys_D2_CreateType("Boolean", "boolean", "B2S")
            //! runtextmacro DataTable_IntegerKeys_D2_CreateType("Integer", "integer", "I2S")
            //! runtextmacro DataTable_IntegerKeys_D2_CreateType("Real", "real", "R2S")
            //! runtextmacro DataTable_IntegerKeys_D2_CreateType("String", "string", "")

			method Event_Create takes nothing returns nothing
				call this.Table.Event_Create()
			endmethod
        endstruct

        //! runtextmacro Struct("Table")
            static constant integer EMPTY = HASH_TABLE.Integer.DEFAULT_VALUE//-1
            static constant integer OFFSET = 8192
            static constant integer SIZE = 8192

            static constant integer STARTED = thistype.EMPTY + 1//0

            HashTable POS_CACHE
            HashTable PRIO_CACHE

            static method GetId takes integer key returns integer
                return thistype.OFFSET + (key - Math.Integer.MIN) * thistype.SIZE
            endmethod

            static method GetTableId takes integer key returns integer
                return (key - Math.Integer.MIN - thistype.OFFSET) div thistype.SIZE
            endmethod

            static method GetTableStartId takes integer key returns integer
                local integer tableId = thistype.GetTableId(key)

                if (tableId > 0) then
                    return Math.Integer.MIN + thistype.OFFSET + tableId * thistype.SIZE
                endif

                return 0
            endmethod

            static method GetReverseKey takes integer key, integer value returns integer
                return (value * thistype.SIZE + thistype.GetTableId(key))
            endmethod

            private method SetCount takes integer missionKey, integer key, integer value returns nothing
                call DataTable(this).Head.IntegerKeys.SetInteger(missionKey, key, value - thistype.EMPTY)
            endmethod

            static method ToArrayIndex takes integer index returns integer
                return (index - thistype.STARTED + ARRAY_MIN)
            endmethod

            //! textmacro DataTable_IntegerKeys_Table_CreateType takes name, type, bugConverter, valueConverter
                method Get$name$Pos takes integer missionKey, integer key, $type$ value returns integer
                    return this.POS_CACHE.Integer.Get(missionKey, thistype.GetReverseKey(key, $valueConverter$(value)))
                endmethod

                method Get$name$Prio takes integer missionKey, integer key, $type$ value returns integer
                    return this.PRIO_CACHE.Integer.Get(missionKey, thistype.GetReverseKey(key, $valueConverter$(value)))
                endmethod

                method Count$name$s takes integer missionKey, integer key returns integer
                    return (thistype.EMPTY + DataTable(this).Head.IntegerKeys.GetInteger(missionKey, key))
                endmethod

                method IsEmpty$name$ takes integer missionKey, integer key returns boolean
                    return (DataTable(this).Head.IntegerKeys.GetInteger(missionKey, key) == thistype.EMPTY)
                endmethod

                method Get$name$ takes integer missionKey, integer key, integer index returns $type$
                    return DataTable(this).Head.IntegerKeys.Get$name$(missionKey, key + index)
                endmethod

                method GetFirst$name$ takes integer missionKey, integer key returns $type$
                    return this.Get$name$(missionKey, key, thistype.STARTED)
                endmethod

                method GetLast$name$ takes integer missionKey, integer key returns $type$
                    return this.Get$name$(missionKey, key, this.Count$name$s(missionKey, key))
                endmethod

                method Contains$name$ takes integer missionKey, integer key, $type$ value returns boolean
                    return (this.Get$name$Pos(missionKey, key, value) != HASH_TABLE.Integer.DEFAULT_VALUE)
                endmethod

                method Random$name$ takes integer missionKey, integer key, integer lowerBound, integer higherBound returns $type$
                    return this.Get$name$(missionKey, key, Math.RandomI(lowerBound, higherBound))
                endmethod

                method Random$name$All takes integer missionKey, integer key returns $type$
                    return this.Random$name$(missionKey, key, thistype.STARTED, this.Count$name$s(missionKey, key))
                endmethod

                method FetchFirst$name$ takes integer missionKey, integer key returns $type$
                    local integer count = this.Count$name$s(missionKey, key)

                    if (count == thistype.EMPTY) then
                        return HASH_TABLE.$name$.DEFAULT_VALUE
                    endif

                    local $type$ value = this.Get$name$(missionKey, key, count)

                    call this.SetCount(missionKey, key, count - 1)
                    call this.POS_CACHE.$name$.Remove(missionKey, thistype.GetReverseKey(key, $valueConverter$(value)))
                    call DataTable(this).Head.IntegerKeys.Remove$name$(missionKey, key + count)

                    return value
                endmethod

                method Clear$name$s takes integer missionKey, integer key returns nothing
                    local integer iteration = this.Count$name$s(missionKey, key)

                    loop
                        exitwhen (iteration < thistype.STARTED)

                        local $type$ value = this.Get$name$(missionKey, key, iteration)

                        call DataTable(this).Head.IntegerKeys.Remove$name$(missionKey, key + iteration)
                        call this.POS_CACHE.Integer.Remove(missionKey, thistype.GetReverseKey(key, $valueConverter$(value)))

                        set iteration = iteration - 1
                    endloop

					call this.SetCount(missionKey, key, thistype.EMPTY)
                endmethod

                method Add$name$ takes integer missionKey, integer key, $type$ value returns boolean
                    if this.Contains$name$(missionKey, key, value) then
						call DebugEx($bugConverter$(value)+" already in table "+I2S(missionKey)+";"+I2S(key))
						call this.Print$name$s(missionKey, key)

                        return false
                    endif

                    local integer count = this.Count$name$s(missionKey, key) + 1

                    call this.SetCount(missionKey, key, count)
                    call this.POS_CACHE.Integer.Set(missionKey, thistype.GetReverseKey(key, $valueConverter$(value)), count)
                    call DataTable(this).Head.IntegerKeys.Set$name$(missionKey, key + count, value)

                    return (count == thistype.STARTED)
                endmethod

                method Add$name$Multi takes integer missionKey, integer key, $type$ value returns boolean
                    local integer count = this.Count$name$s(missionKey, key) + 1

                    call this.SetCount(missionKey, key, count)
                    call DataTable(this).Head.IntegerKeys.Set$name$(missionKey, key + count, value)

                    return (count == thistype.STARTED)
                endmethod

                /*method Add$name$WithPrio takes integer missionKey, integer key, $type$ value, integer prio returns boolean
                    local integer count = this.Count$name$s(missionKey, key)

                    loop
                        exitwhen (iteration < thistype.STARTED)

                        exitwhen (prio < this.Get$name$Prio(missionKey, key, value))

                        set iteration = iteration - 1
                    endloop

                    if not this.Insert$name$(missionKey, key, value) then
                        return false
                    endif

                    call this.PRIO_CACHE.Integer.Set(missionKey, thistype.GetReverseKey(key, $valueConverter$(value)), prio)

                    return true
                endmethod*/

                method Join$name$ takes integer missionKey, integer key, DataTable other, integer missionKey2, integer key2 returns nothing
                    local integer count = thistype(other).Count$name$s(missionKey2, key2)

                    if (count == thistype.EMPTY) then
                        return
                    endif

					local integer addCount = 0
                    local integer iteration = thistype.STARTED
                    local integer oldCount = this.Count$name$s(missionKey, key)

                    loop
                        local $type$ value = thistype(other).Get$name$(missionKey2, key2, iteration)

                        if not this.Contains$name$(missionKey, key, value) then
                            set addCount = addCount + 1

                            call this.POS_CACHE.Integer.Set(missionKey, thistype.GetReverseKey(key, $valueConverter$(value)), oldCount + addCount)
                            call DataTable(this).Head.IntegerKeys.Set$name$(missionKey, key + oldCount + addCount, value)
                        endif

                        set iteration = iteration + 1

                        exitwhen (iteration > count)
                    endloop

                    call this.SetCount(missionKey, key, oldCount + addCount)
                endmethod

                method Print$name$s takes integer missionKey, integer key returns nothing
                	local integer count = this.Count$name$s(missionKey, key)

					call DebugBufferStart()

                    call DebugBuffer("print table " + I2S(missionKey) + ";" + I2S(key) + ";" + I2S(count))

                    local string missionKeyName = DataTable.GetKeyFromValue(missionKey)
                    local string keyName = DataTable.GetKeyFromValue(key)

                    if ((missionKeyName != null) or (keyName != null)) then
                        call DebugBuffer(missionKeyName + ";" + keyName)
                    endif

                    call DebugBuffer("--->")

					local integer iteration = count

                    loop
                        exitwhen (iteration < thistype.STARTED)

                        local $type$ value = this.Get$name$(missionKey, key, iteration)

                        local integer pos = this.Get$name$Pos(missionKey, key, value)

                        call DebugBuffer(Char.TAB + $bugConverter$(value) + " on " + I2S(iteration) + ";" + I2S(pos) + ";" + I2S(thistype.GetReverseKey(key, $valueConverter$(value))))
                        if (iteration != pos) then
                            call DebugBuffer("TABLE CORRUPTED!")
                        endif
                        call DebugBuffer(Char.TAB + Char.TAB + DataTable.GetKeyFromValue(pos))

                        set iteration = iteration - 1
                    endloop

					//call Code.PrintThreadInfo()

                    call DebugBufferFinish()
                endmethod

                method Remove$name$ takes integer missionKey, integer key, $type$ value returns boolean
                    local integer count = this.Count$name$s(missionKey, key)
                    local integer reverseKey = thistype.GetReverseKey(key, $valueConverter$(value))

                    local $type$ lastValue = this.Get$name$(missionKey, key, count)
                    local integer pos = this.POS_CACHE.Integer.Get(missionKey, reverseKey)

                    static if DEBUG then
                        if not this.Contains$name$(missionKey, key, value) then
                            call DebugEx(thistype.NAME + ": " + "cannot remove "+$bugConverter$(value) + " from " + I2S(missionKey) + ";" + I2S(key) + " reverseKey: "+I2S(reverseKey))

                            call this.Print$name$s(missionKey, key)

                            return false
                        endif
                    endif

                    call this.POS_CACHE.Integer.Set(missionKey, thistype.GetReverseKey(key, $valueConverter$(lastValue)), pos)
                    call DataTable(this).Head.IntegerKeys.Set$name$(missionKey, key + pos, lastValue)

                    call this.POS_CACHE.Integer.Remove(missionKey, reverseKey)
                    call DataTable(this).Head.IntegerKeys.Remove$name$(missionKey, key + count)

                    set count = count - 1

                    call this.SetCount(missionKey, key, count)

                    return (count == thistype.EMPTY)
                endmethod

                method FetchRandom$name$ takes integer missionKey, integer key, integer lowerBound, integer higherBound returns $type$
                    local integer count = this.Count$name$s(missionKey, key)

                    if (lowerBound > count) then
                        set lowerBound = count
                    endif
                    if (higherBound > count) then
                        set higherBound = count
                    endif
                    if (higherBound <= thistype.EMPTY) then
                        return HASH_TABLE.$name$.DEFAULT_VALUE
                    endif

                    local integer index = Math.RandomI(lowerBound, higherBound)

                    local $type$ value = this.Get$name$(missionKey, key, index)

                    call this.Remove$name$ByIndex(missionKey, key, index)

                    return value
                endmethod

                method FetchRandom$name$All takes integer missionKey, integer key returns $type$
                    return this.FetchRandom$name$(missionKey, key, thistype.STARTED, this.Count$name$s(missionKey, key))
                endmethod

                method Shuffle$name$s takes integer missionKey, integer key returns nothing
                    local integer count = this.Count$name$s(missionKey, key)

                    local integer iteration = count
                    local $type$ array temp

                    loop
                        exitwhen (iteration < thistype.STARTED)

                        set temp[thistype.ToArrayIndex(iteration)] = this.Get$name$(missionKey, key, iteration)

                        set iteration = iteration - 1
                    endloop

					call this.Clear$name$s(missionKey, key)

                    set iteration = thistype.ToArrayIndex(count)

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        local integer index = Math.RandomI(ARRAY_MIN, iteration)

                        call this.Add$name$(missionKey, key, temp[index])

                        set temp[index] = temp[iteration]

                        set iteration = iteration - 1
                    endloop
                endmethod

                method Remove$name$ByIndex takes integer missionKey, integer key, integer index returns boolean
                    return this.Remove$name$(missionKey, key, this.Get$name$(missionKey, key, index))
                endmethod

                /////////////////////////////////////

                method Count$name$sByHandle takes handle source, integer key returns integer
                    return this.Count$name$s(GetHandleId(source), key)
                endmethod

                method Get$name$ByHandle takes handle source, integer key, integer index returns $type$
                    return this.Get$name$(GetHandleId(source), key, index)
                endmethod

                method Random$name$ByHandle takes handle handleSource, integer key, integer lowerBound, integer higherBound returns $type$
                    return this.Random$name$(GetHandleId(handleSource), key, lowerBound, higherBound)
                endmethod

                method Add$name$ByHandle takes handle source, integer key, $type$ value returns boolean
                    return this.Add$name$(GetHandleId(source), key, value)
                endmethod

                method Remove$name$ByHandle takes handle source, integer key, $type$ value returns boolean
                    return this.Remove$name$(GetHandleId(source), key, value)
                endmethod
            //! endtextmacro

            //! runtextmacro DataTable_IntegerKeys_Table_CreateType("Boolean", "boolean", "B2S", "Boolean.ToInt")
            //! runtextmacro DataTable_IntegerKeys_Table_CreateType("Integer", "integer", "I2S", "")
            //! runtextmacro DataTable_IntegerKeys_Table_CreateType("Real", "real", "R2S", "Real.ToInt")
            //! runtextmacro DataTable_IntegerKeys_Table_CreateType("String", "string", "", "String.ToIntHash")

            //! textmacro DataTable_IntegerKeys_Table_CreateSortedType takes name, type, bugConverter, valueConverter
                method Add$name$Sorted takes integer missionKey, integer key, $type$ value, real sortValue returns boolean
                    local integer count = this.Count$name$s(missionKey, key)

                    local integer iteration = count

                    loop
                        exitwhen (iteration == thistype.EMPTY)
                        exitwhen (value > this.Get$name$(missionKey, key, iteration))

                        set iteration = iteration - 1
                    endloop

					local integer index

                    if (iteration == thistype.EMPTY) then
                        set index = thistype.STARTED
                    endif

                    set count = count + 1
                    set iteration = index + 1

                    call this.SetCount(missionKey, key, count)
                    loop
                        exitwhen (iteration > count)

                        local $type$ otherValue = this.Get$name$(missionKey, key, iteration - 1)

                        call this.POS_CACHE.Integer.Set(missionKey, thistype.GetReverseKey(key, $valueConverter$(otherValue)), iteration)
                        call DataTable(this).Head.IntegerKeys.Set$name$(missionKey, key + iteration, otherValue)

                        set iteration = iteration + 1
                    endloop

                    call this.POS_CACHE.Integer.Set(missionKey, thistype.GetReverseKey(key, $valueConverter$(value)), index)
                    call DataTable(this).Head.IntegerKeys.Set$name$(missionKey, key + index, value)

                    return (count == thistype.STARTED)
                endmethod

                method Remove$name$Sorted takes integer missionKey, integer key, $type$ value returns boolean
                    local integer count = this.Count$name$s(missionKey, key) - 1
                    local integer reverseKey = thistype.GetReverseKey(key, $valueConverter$(value))

                    local integer index = this.POS_CACHE.Integer.Get(missionKey, reverseKey)

                    static if DEBUG then
                        if not this.Contains$name$(missionKey, key, value) then
                            call DebugEx(thistype.NAME + ": " + "cannot remove " + $bugConverter$(value) + " from " + I2S(missionKey) + ";" + I2S(key))

                            return false
                        endif
                    endif

                    call this.POS_CACHE.Integer.Remove(missionKey, reverseKey)
                    call DataTable(this).Head.IntegerKeys.Remove$name$(missionKey, key + index)

                    set count = count - 1

                    local integer iteration = index

                    loop
                        exitwhen (iteration > count)

                        set value = this.Get$name$(missionKey, key, iteration + 1)

                        call this.POS_CACHE.Integer.Set(missionKey, thistype.GetReverseKey(key, $valueConverter$(value)), iteration)
                        call DataTable(this).Head.IntegerKeys.Set$name$(missionKey, key + iteration, value)

                        set iteration = iteration - 1
                    endloop

                    call this.SetCount(missionKey, key, count)

                    return (count == thistype.EMPTY)
                endmethod
            //! endtextmacro

            //! runtextmacro DataTable_IntegerKeys_Table_CreateSortedType("Integer", "integer", "I2S", "")
            //! runtextmacro DataTable_IntegerKeys_Table_CreateSortedType("Real", "real", "R2S", "Real.ToInt")

            method Clear takes integer missionKey, integer key returns nothing
                call this.ClearIntegers(missionKey, key)
            endmethod

			method Event_Create takes nothing returns nothing
                set this.POS_CACHE = HashTable.Create()
                set this.PRIO_CACHE = HashTable.Create()
			endmethod
        endstruct
    endscope

    //! runtextmacro Struct("IntegerKeys")
        //! runtextmacro LinkToStruct("IntegerKeys", "D2")
        //! runtextmacro LinkToStruct("IntegerKeys", "Table")

        method RemoveChild takes integer missionKey returns nothing
            call DataTable(this).Head.IntegerKeys.RemoveChild(missionKey)
        endmethod

        //! textmacro DataTable_IntegerKeys_CreateType takes name, type, bugConv
            method Contains$name$ takes integer missionKey, integer key returns boolean
                return DataTable(this).Head.IntegerKeys.Contains$name$(missionKey, key)
            endmethod

            method Get$name$ takes integer missionKey, integer key returns $type$
                return DataTable(this).Head.IntegerKeys.Get$name$(missionKey, key)
            endmethod

            method Get$name$ByHandle takes handle handleSource, integer key returns $type$
                return DataTable(this).Head.IntegerKeys.Get$name$ByHandle(handleSource, key)
            endmethod

            method Set$name$ takes integer missionKey, integer key, $type$ value returns nothing
                call DataTable(this).Head.IntegerKeys.Set$name$(missionKey, key, value)
            endmethod

            method Set$name$ByHandle takes handle handleSource, integer key, $type$ value returns nothing
                call this.Set$name$(GetHandleId(handleSource), key, value)
            endmethod

            method Remove$name$ takes integer missionKey, integer key returns nothing
                call DataTable(this).Head.IntegerKeys.Remove$name$(missionKey, key)
            endmethod

            method Remove$name$ByHandle takes handle handleSource, integer key returns nothing
                call DataTable(this).Head.IntegerKeys.Remove$name$ByHandle(handleSource, key)
            endmethod
        //! endtextmacro

        //! runtextmacro DataTable_IntegerKeys_CreateType("Boolean", "boolean", "B2S")
        //! runtextmacro DataTable_IntegerKeys_CreateType("Integer", "integer", "I2S")
        //! runtextmacro DataTable_IntegerKeys_CreateType("Real", "real", "R2S")
        //! runtextmacro DataTable_IntegerKeys_CreateType("String", "string", "")

		method Event_Create takes nothing returns nothing
			call this.D2.Event_Create()
			call this.Table.Event_Create()
		endmethod
    endstruct

    //! runtextmacro Folder("StringKeys")
        //! runtextmacro Struct("Table")
            static constant integer EMPTY = -1
            static constant integer STARTED = 0

            //! textmacro DataTable_StringKeys_Table_CreateType takes name, type, bugConverter
                method Count$name$s takes string missionKey, string key returns integer
                    return (thistype.EMPTY + DataTable(this).Head.StringKeys.GetInteger(missionKey, key))
                endmethod

                method Get$name$ takes string missionKey, string key, integer index returns $type$
                    return DataTable(this).Head.StringKeys.Get$name$(missionKey, key + I2S(thistype.EMPTY + index + 2))
                endmethod

                method Contains$name$ takes string missionKey, string key, $type$ value returns boolean
                    local integer iteration = this.Count$name$s(missionKey, key)

                    loop
                        exitwhen (iteration < thistype.STARTED)

                        exitwhen (this.Get$name$(missionKey, key, iteration) == value)

                        set iteration = iteration - 1
                    endloop

                    if (iteration < thistype.STARTED) then
                        return false
                    endif

                    return true
                endmethod

                method Print$name$s takes string missionKey, string key returns nothing
					local integer iteration = this.Count$name$s(missionKey, key)

					call DebugBufferStart()

					loop
						exitwhen (iteration < thistype.STARTED)

						call DebugBuffer($bugConverter$(this.Get$name$(missionKey, key, iteration)))

						set iteration = iteration - 1
					endloop

					call DebugBufferFinish()
                endmethod

                method Add$name$ takes string missionKey, string key, $type$ value returns boolean
                    local integer count = this.Count$name$s(missionKey, key) + 1

                    call DataTable(this).Head.StringKeys.SetInteger(missionKey, key, count - thistype.EMPTY)
                    call DataTable(this).Head.StringKeys.Set$name$(missionKey, key + I2S(thistype.EMPTY + count + 2), value)

                    return (count == thistype.STARTED)
                endmethod

                method Remove$name$ takes string missionKey, string key, $type$ value returns boolean
                    local integer count = this.Count$name$s(missionKey, key)

                    local integer iteration = count

                    loop
debug                        exitwhen (iteration < thistype.STARTED)

                        exitwhen (this.Get$name$(missionKey, key, iteration) == value)

                        set iteration = iteration - 1
                    endloop

debug                    if (iteration < thistype.STARTED) then
debug                        call Game.DebugMsg("Failed to remove " + $bugConverter$(value)+" from table " + key + " of missionKey " + missionKey + " (" + I2S(count) + ")")
debug                    else
                    call DataTable(this).Head.StringKeys.Set$name$(missionKey, key + I2S(thistype.EMPTY + iteration + 2), this.Get$name$(missionKey, key, count))

                    set count = count - 1

                    call DataTable(this).Head.StringKeys.SetInteger(missionKey, key, count - thistype.EMPTY)
debug                    endif

                    return (count == thistype.EMPTY)
                endmethod

                method Random$name$ takes string missionKey, string key, integer lowerBound, integer higherBound returns $type$
                    return this.Get$name$(missionKey, key, Math.RandomI(lowerBound, higherBound))
                endmethod

                method Random$name$All takes string missionKey, string key returns $type$
                    return this.Random$name$(missionKey, key, thistype.STARTED, this.Count$name$s(missionKey, key))
                endmethod
            //! endtextmacro

            //! runtextmacro DataTable_StringKeys_Table_CreateType("Boolean", "boolean", "B2S")
            //! runtextmacro DataTable_StringKeys_Table_CreateType("Integer", "integer", "I2S")
            //! runtextmacro DataTable_StringKeys_Table_CreateType("Real", "real", "R2S")
            //! runtextmacro DataTable_StringKeys_Table_CreateType("String", "string", "")
        endstruct
    endscope

    //! runtextmacro Struct("StringKeys")
        //! runtextmacro LinkToStruct("StringKeys", "Table")

        method RemoveChild takes string missionKey returns nothing
            call DataTable(this).Head.StringKeys.RemoveChild(missionKey)
        endmethod

        //! textmacro DataTable_StringKeys_CreateType takes name, type
            method Set$name$ takes string missionKey, string key, $type$ value returns nothing
                call DataTable(this).Head.StringKeys.Set$name$(missionKey, key, value)
            endmethod

            method Remove$name$ takes string missionKey, string key returns nothing
                call DataTable(this).Head.StringKeys.Remove$name$(missionKey, key)
            endmethod

            method Get$name$ takes string missionKey, string key returns $type$
                return DataTable(this).Head.StringKeys.Get$name$(missionKey, key)
            endmethod
        //! endtextmacro

        //! runtextmacro DataTable_StringKeys_CreateType("Boolean", "boolean")
        //! runtextmacro DataTable_StringKeys_CreateType("Integer", "integer")
        //! runtextmacro DataTable_StringKeys_CreateType("Real", "real")
        //! runtextmacro DataTable_StringKeys_CreateType("String", "string")
    endstruct

    //! runtextmacro Struct("Native")
        hashtable TABLE

        static method GetHandleIdString takes handle h returns string
            return I2S(GetHandleId(h))
        endmethod

        //! textmacro NativeTable_CreateType takes name, containsFunc, getFunc, setFunc, removeFunc, type, defaultValue, bugConv
            static constant $type$ DEFAULT_VALUE = $defaultValue$

            method Contains$name$ takes integer missionKey, integer key returns boolean
                //return $containsFunc$(this.TABLE, missionKey, key)
                return ($getFunc$(this.TABLE, missionKey, key) != thistype.DEFAULT_VALUE)
            endmethod

            method Get$name$ takes integer missionKey, integer key returns $type$
                return $getFunc$(this.TABLE, missionKey, key)
            endmethod

            method Set$name$ takes integer missionKey, integer key, $type$ value returns nothing
                call $setFunc$(this.TABLE, missionKey, key, value)
            endmethod

            method Remove$name$ takes integer missionKey, integer key returns nothing
                call this.Set$name$(missionKey, key, thistype.DEFAULT_VALUE)
                //call $removeFunc$(this.TABLE, missionKey, key)
            endmethod
        //! endtextmacro

        //! runtextmacro NativeTable_CreateType("Button", "HaveSavedHandle", "LoadButtonHandle", "SaveButtonHandle", "RemoveSavedHandle", "button", "null", "GetHandleIdString")

        method RemoveChild takes integer missionKey returns nothing
            call FlushChildHashtable(this.TABLE, missionKey)
        endmethod

		method Event_Create takes nothing returns nothing
			set this.TABLE = InitHashtable()
		endmethod
    endstruct
endscope

globals
    hashtable KEY_MACROS_TABLE
    DataTable Memory
endglobals

//! runtextmacro BaseStruct("DataTable", "DATA_TABLE")
	static thistype MEMORY

    //! runtextmacro LinkToStruct("DataTable", "IntegerKeys")
    //! runtextmacro LinkToStruct("DataTable", "Native")
    //! runtextmacro LinkToStruct("DataTable", "StringKeys")

	DataTableHead Head

    static method GetKeyFromValue takes integer val returns string
        local integer tableId = thistype(NULL).IntegerKeys.Table.GetTableId(val)
        local integer tableStartId = thistype(NULL).IntegerKeys.Table.GetTableStartId(val)

		local string result

        if (tableId > 0) then
            set result = LoadStr(KEY_MACROS_TABLE, 0, tableStartId)

            if (result == HASH_TABLE.String.DEFAULT_VALUE) then
                return null
            endif

            return (Integer.ToString(tableStartId) + " (table " + Integer.ToString(tableId) + "; index " + Integer.ToString(val - tableStartId) + "): " + result)
        endif

        set result = LoadStr(KEY_MACROS_TABLE, 0, val)

        if (result == HASH_TABLE.String.DEFAULT_VALUE) then
            return null
        endif

        return (Integer.ToString(val) + " (base " + Integer.ToString(val - Math.Integer.MIN) + "): " + result)
    endmethod

	static method Create takes nothing returns thistype
		local thistype this = thistype.allocate()

		set this.Head = DataTableHead.Create()

		call this.IntegerKeys.Event_Create()
		call this.Native.Event_Create()
		//call this.StringKeys.Event_Create()

		return this
	endmethod

    initMethod Init of Header
    call InfoEx("memory")
        call DataTableHead.Init()

		set thistype.MEMORY = thistype.Create()

		set Memory = thistype.MEMORY

		call Data.Init()
    endmethod
endstruct

//! textmacro GetKey takes name
    static key GetKeyMacro_$name$
    static constant integer $name$ = Math.Integer.MIN + GetKeyMacro_$name$
//! endtextmacro

//! textmacro GetKeyArray takes name
    static key GetKeyMacro_$name$

    static constant integer $name$ = Math.Integer.MIN + Memory.IntegerKeys.Table.OFFSET + GetKeyMacro_$name$ * Memory.IntegerKeys.Table.SIZE
//! endtextmacro

struct Data
	static DataTable array RANDOM_TABLES
	static integer RANDOM_TABLES_COUNT

	static method GetRandomTable takes nothing returns DataTable
		return thistype.RANDOM_TABLES[Math.RandomI(ARRAY_MIN, thistype.RANDOM_TABLES_COUNT)]
	endmethod

	static method Init takes nothing returns nothing
		set thistype.RANDOM_TABLES_COUNT = 10 + ARRAY_EMPTY

		local integer i = thistype.RANDOM_TABLES_COUNT

		loop
			exitwhen (i < ARRAY_MIN)

			set thistype.RANDOM_TABLES[i] = DataTable.Create()

			set i = i - 1
		endloop
	endmethod
endstruct

//! textmacro Data_Implement takes baseType
	DataTable table

    method Destroy takes nothing returns nothing
        call this.table.IntegerKeys.RemoveChild($baseType$(this).Id.Get())
    endmethod

	method Event_Create takes nothing returns nothing
		set this.table = Data.GetRandomTable()
	endmethod

	inject $baseType$.Allocation.deallocate_demount.hook
		call $baseType$(this).Data.Destroy()
	endinject

	inject $baseType$.Allocation.allocate_mount.hook
		call $baseType$(this).Data.Event_Create()
	endinject
//! endtextmacro

//! textmacro Data_Type_Implement takes baseType, whichTypeName, whichType
    method Get takes integer key returns $whichType$
        return $baseType$(this).Data.table.IntegerKeys.Get$whichTypeName$($baseType$(this).Id.Get(), key)
    endmethod

    method Is takes integer key returns boolean
        return (this.Get(key) != HASH_TABLE.$whichTypeName$.DEFAULT_VALUE)
    endmethod

    method Remove takes integer key returns nothing
        call $baseType$(this).Data.table.IntegerKeys.Remove$whichTypeName$($baseType$(this).Id.Get(), key)
    endmethod

    method Set takes integer key, $whichType$ value returns nothing
        call $baseType$(this).Data.table.IntegerKeys.Set$whichTypeName$($baseType$(this).Id.Get(), key, value)
    endmethod
//! endtextmacro

//! textmacro Data_Boolean_Implement takes baseType
    method Add takes integer key returns boolean
        local boolean oldValue = this.Get(key)

        call this.Set(key, not HASH_TABLE.Boolean.DEFAULT_VALUE)

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
//! endtextmacro

//! textmacro Data_Type_Table_Implement takes baseType, whichTypeName, whichType
    method Contains takes integer key, $whichType$ value returns boolean
        return $baseType$(this).Data.table.IntegerKeys.Table.Contains$whichTypeName$($baseType$(this).Id.Get(), key, value)
    endmethod

    method Count takes integer key returns integer
        return $baseType$(this).Data.table.IntegerKeys.Table.Count$whichTypeName$s($baseType$(this).Id.Get(), key)
    endmethod

    method IsEmpty takes integer key returns boolean
        return $baseType$(this).Data.table.IntegerKeys.Table.IsEmpty$whichTypeName$($baseType$(this).Id.Get(), key)
    endmethod

    method Get takes integer key, integer index returns $whichType$
        return $baseType$(this).Data.table.IntegerKeys.Table.Get$whichTypeName$($baseType$(this).Id.Get(), key, index)
    endmethod

    method GetFirst takes integer key returns $whichType$
        return $baseType$(this).Data.table.IntegerKeys.Table.GetFirst$whichTypeName$($baseType$(this).Id.Get(), key)
    endmethod

    method GetLast takes integer key returns $whichType$
        return $baseType$(this).Data.table.IntegerKeys.Table.GetLast$whichTypeName$($baseType$(this).Id.Get(), key)
    endmethod

    method Clear takes integer key returns nothing
        call $baseType$(this).Data.table.IntegerKeys.Table.Clear($baseType$(this).Id.Get(), key)
    endmethod

    method FetchFirst takes integer key returns $whichType$
        return $baseType$(this).Data.table.IntegerKeys.Table.FetchFirst$whichTypeName$($baseType$(this).Id.Get(), key)
    endmethod

    method Remove takes integer key, $whichType$ value returns boolean
        return $baseType$(this).Data.table.IntegerKeys.Table.Remove$whichTypeName$($baseType$(this).Id.Get(), key, value)
    endmethod

    method RemoveByIndex takes integer key, integer index returns boolean
        return $baseType$(this).Data.table.IntegerKeys.Table.Remove$whichTypeName$ByIndex($baseType$(this).Id.Get(), key, index)
    endmethod

    method Add takes integer key, $whichType$ value returns boolean
        return $baseType$(this).Data.table.IntegerKeys.Table.Add$whichTypeName$($baseType$(this).Id.Get(), key, value)
    endmethod

    method AddMulti takes integer key, $whichType$ value returns boolean
        return $baseType$(this).Data.table.IntegerKeys.Table.Add$whichTypeName$Multi($baseType$(this).Id.Get(), key, value)
    endmethod

    method Join takes integer key, thistype other returns nothing
        call $baseType$(this).Data.table.IntegerKeys.Table.Join$whichTypeName$($baseType$(this).Id.Get(), key, $baseType$(other).Data.table, $baseType$(other).Id.Get(), key)
    endmethod

    method Random takes integer key, integer lowerBound, integer higherBound returns $whichType$
        return $baseType$(this).Data.table.IntegerKeys.Table.Random$whichTypeName$($baseType$(this).Id.Get(), key, lowerBound, higherBound)
    endmethod

    method RandomAll takes integer key returns $whichType$
        return this.Random(key, DATA_TABLE.IntegerKeys.Table.STARTED, this.Count(key))
    endmethod

    method Shuffle takes integer key returns nothing
        call $baseType$(this).Data.table.IntegerKeys.Table.ShuffleIntegers($baseType$(this).Id.Get(), key)
    endmethod

    method Print takes integer key returns nothing
        call $baseType$(this).Data.table.IntegerKeys.Table.Print$whichTypeName$s($baseType$(this).Id.Get(), key)
    endmethod
//! endtextmacro

//! textmacro Id_Implement takes baseType
	struct Id
		//! runtextmacro GetKeyArray("KEY_ARRAY")

		//! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")

		inject $baseType$.Allocation.allocate_mount.hook
			call this.Id.Event_Create()
		endinject
	endstruct
//! endtextmacro

//! textmacro Data_Implement2 takes baseType
	struct Data
		struct Boolean
			struct Table
				//! runtextmacro Data_Type_Table_Implement("$baseType$", "Boolean", "boolean")
			endstruct

			//! runtextmacro Data_Type_Implement("$baseType$", "Boolean", "boolean")

			//! runtextmacro Data_Boolean_Implement("$baseType$")
		endstruct

		struct Integer
			struct Table
				//! runtextmacro Data_Type_Table_Implement("$baseType$", "Integer", "integer")
			endstruct

			//! runtextmacro Data_Type_Implement("$baseType$", "Integer", "integer")

			//! runtextmacro Data_Integer_Implement("$baseType$")
		endstruct

		struct Real
			struct Table
				//! runtextmacro Data_Type_Table_Implement("$baseType$", "Real", "real")
			endstruct

			//! runtextmacro Data_Type_Implement("$baseType$", "Real", "real")

			//! runtextmacro Data_Real_Implement("$baseType$")
		endstruct

		struct String
			struct Table
				//! runtextmacro Data_Type_Table_Implement("$baseType$", "String", "string")
			endstruct

			//! runtextmacro Data_Type_Implement("$baseType$", "String", "string")

			//! runtextmacro Data_String_Implement("$baseType$")
		endstruct

    	//! runtextmacro Data_Implement("$baseType$")
    endstruct
//! endtextmacro

//! textmacro Data_StringKey_Implement takes baseType
    method Destroy takes string whichString returns nothing
        call Memory.StringKeys.RemoveChild(whichString)
    endmethod
//! endtextmacro

//! textmacro Data_StringKey_Type_Implement takes baseType, whichTypeName, whichType
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

//! textmacro Data_StringKey_Type_Table_Implement takes baseType, whichTypeName, whichType
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
        return thistype.Random(whichString, key, DATA_TABLE.IntegerKeys.Table.STARTED, thistype.Count(whichString, key))
    endmethod
//! endtextmacro

//! textmacro Create1DState takes name, type, typeName
    ////! runtextmacro GetKeyArray("$name$_KEY_ARRAY_DETAIL")
        static key GetKeyMacro_$name$_KEY_ARRAY_DETAIL

        static constant integer $name$_KEY_ARRAY_DETAIL = Math.Integer.MIN + DATA_TABLE.IntegerKeys.Table.OFFSET + GetKeyMacro_$name$_KEY_ARRAY_DETAIL * DATA_TABLE.IntegerKeys.Table.SIZE
    ////! runtextmacro GetKeyArray("$name$_KEY_ARRAY_DETAIL")

    method Get$name$ takes integer index returns $type$
        return this.Data.$typeName$.Get($name$_KEY_ARRAY_DETAIL + index)
    endmethod

    method Set$name$ takes integer index, $type$ value returns nothing
        call this.Data.$typeName$.Set($name$_KEY_ARRAY_DETAIL + index, value)
    endmethod
//! endtextmacro