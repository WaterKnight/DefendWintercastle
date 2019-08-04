//! runtextmacro Folder("EventMemoryHead")
    //! runtextmacro Folder("IntegerKeys")
        //! runtextmacro Struct("D2")
            static HashTable CACHE
            static constant integer SIZE = 8192

            static method GetFirstKey takes integer pivotKey, integer subject1, integer subject2 returns integer
                set pivotKey = pivotKey - Math.Integer.MIN

				local integer res = (pivotKey div 64 * SIZE * SIZE + subject1 * SIZE + subject2)
//if EventMemory.TEST then
//call DebugEx("first key: "+I2S(pivotKey)+";"+I2S(subject1)+";"+I2S(subject2)+" --> "+I2S(res))
//endif
                return res
            endmethod

            static method GetSecondKey takes integer pivotKey, integer subject3, integer subject4 returns integer
                set pivotKey = pivotKey - Math.Integer.MIN

                local integer res = ((pivotKey - pivotKey div 64 * 64) * SIZE * SIZE + subject3 * SIZE + subject4)
//if EventMemory.TEST then
//call DebugEx("second key: "+I2S(pivotKey)+";"+I2S(subject3)+";"+I2S(subject4)+" --> "+I2S(res))
//endif
                return res
            endmethod

            //! textmacro EventMemoryHead_IntegerKeys_D2_CreateType takes name, type
                static method Contains$name$ takes integer pivotKey, integer subject1, integer subject2, integer subject3, integer subject4 returns boolean
                    return thistype.CACHE.$name$.Contains(thistype.GetFirstKey(pivotKey, subject1, subject2), thistype.GetSecondKey(pivotKey, subject3, subject4))
                endmethod

                static method Get$name$ takes integer pivotKey, integer subject1, integer subject2, integer subject3, integer subject4 returns $type$
                    return thistype.CACHE.$name$.Get(thistype.GetFirstKey(pivotKey, subject1, subject2), thistype.GetSecondKey(pivotKey, subject3, subject4))
                endmethod

                static method Set$name$ takes integer pivotKey, integer subject1, integer subject2, integer subject3, integer subject4, $type$ value returns nothing
                    call thistype.CACHE.$name$.Set(thistype.GetFirstKey(pivotKey, subject1, subject2), thistype.GetSecondKey(pivotKey, subject3, subject4), value)
                endmethod

                static method Remove$name$ takes integer pivotKey, integer subject1, integer subject2, integer subject3, integer subject4 returns nothing
                    call thistype.CACHE.$name$.Remove(thistype.GetFirstKey(pivotKey, subject1, subject2), thistype.GetSecondKey(pivotKey, subject3, subject4))
                endmethod

                static method Contains$name$WithCache takes HashTable cache, integer pivotKey, integer subject1, integer subject2, integer subject3, integer subject4 returns boolean
                    return cache.$name$.Contains(thistype.GetFirstKey(pivotKey, subject1, subject2), thistype.GetSecondKey(pivotKey, subject3, subject4))
                endmethod

                static method Get$name$WithCache takes HashTable cache, integer pivotKey, integer subject1, integer subject2, integer subject3, integer subject4 returns $type$
                    return cache.$name$.Get(thistype.GetFirstKey(pivotKey, subject1, subject2), thistype.GetSecondKey(pivotKey, subject3, subject4))
                endmethod

                static method Set$name$WithCache takes HashTable cache, integer pivotKey, integer subject1, integer subject2, integer subject3, integer subject4, $type$ value returns nothing
                    call cache.$name$.Set(thistype.GetFirstKey(pivotKey, subject1, subject2), thistype.GetSecondKey(pivotKey, subject3, subject4), value)
                endmethod

                static method Remove$name$WithCache takes HashTable cache, integer pivotKey, integer subject1, integer subject2, integer subject3, integer subject4 returns nothing
                    call cache.$name$.Remove(thistype.GetFirstKey(pivotKey, subject1, subject2), thistype.GetSecondKey(pivotKey, subject3, subject4))
                endmethod
            //! endtextmacro

            //! runtextmacro EventMemoryHead_IntegerKeys_D2_CreateType("Boolean", "boolean")
            //! runtextmacro EventMemoryHead_IntegerKeys_D2_CreateType("Integer", "integer")
            //! runtextmacro EventMemoryHead_IntegerKeys_D2_CreateType("Real", "real")
            //! runtextmacro EventMemoryHead_IntegerKeys_D2_CreateType("String", "string")

            static method Init takes nothing returns nothing
                set thistype.CACHE = HashTable.Create()
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("IntegerKeys")
        static HashTable CACHE

        //! runtextmacro LinkToStaticStruct("IntegerKeys", "D2")

        static method RemoveChild takes integer missionKey returns nothing
            call thistype.CACHE.RemoveChild(missionKey)
        endmethod

        //! textmacro EventMemoryHead_IntegerKeys_CreateType takes name, type
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

        //! runtextmacro EventMemoryHead_IntegerKeys_CreateType("Boolean", "boolean")
        //! runtextmacro EventMemoryHead_IntegerKeys_CreateType("Integer", "integer")
        //! runtextmacro EventMemoryHead_IntegerKeys_CreateType("Real", "real")
        //! runtextmacro EventMemoryHead_IntegerKeys_CreateType("String", "string")

        static method Init takes nothing returns nothing
            set thistype.CACHE = HashTable.Create()

            call thistype.D2.Init()
        endmethod
    endstruct
endscope

//! runtextmacro StaticStruct("EventMemoryHead")
    //! runtextmacro LinkToStaticStruct("EventMemoryHead", "IntegerKeys")

    static method Init takes nothing returns nothing
        call thistype.IntegerKeys.Init()
    endmethod
endstruct

//! runtextmacro Folder("EventMemory")
    //! runtextmacro Folder("IntegerKeys")
        //! runtextmacro Folder("D2")
            //! runtextmacro Struct("Table")
                static constant integer EMPTY = HASH_TABLE.Integer.DEFAULT_VALUE//-1

                static HashTable FIRST_CACHE
                static HashTable LAST_CACHE

                static HashTable NEXT_CACHE
                static HashTable PREV_CACHE
                static HashTable PRIO_CACHE

                //! textmacro EventMemory_IntegerKeys_D2_Table_CreateType takes name, type, bugConverter, valueConverter
                    static method GetFirst$name$ takes integer pivotKey, integer subject1, integer subject2, integer subject3 returns $type$
                        return EventMemoryHead.IntegerKeys.D2.Get$name$WithCache(thistype.FIRST_CACHE, pivotKey, subject1, subject2, subject3, 0)
                    endmethod

                    static method GetLast$name$ takes integer pivotKey, integer subject1, integer subject2, integer subject3 returns $type$
                        return EventMemoryHead.IntegerKeys.D2.Get$name$WithCache(thistype.LAST_CACHE, pivotKey, subject1, subject2, subject3, 0)
                    endmethod

                    static method GetNext$name$ takes integer pivotKey, integer subject1, integer subject2, integer subject3, $type$ value returns $type$
                        return EventMemoryHead.IntegerKeys.D2.Get$name$WithCache(thistype.NEXT_CACHE, pivotKey, subject1, subject2, subject3, $valueConverter$(value))
                    endmethod

                    static method GetPrev$name$ takes integer pivotKey, integer subject1, integer subject2, integer subject3, $type$ value returns $type$
                        return EventMemoryHead.IntegerKeys.D2.Get$name$WithCache(thistype.PREV_CACHE, pivotKey, subject1, subject2, subject3, $valueConverter$(value))
                    endmethod

                    static method Get$name$Prio takes integer pivotKey, integer subject1, integer subject2, integer subject3, $type$ value returns integer
                        return EventMemoryHead.IntegerKeys.D2.GetIntegerWithCache(thistype.PRIO_CACHE, pivotKey, subject1, subject2, subject3, $valueConverter$(value))
                    endmethod

                    static method Get$name$sMaxPrio takes integer pivotKey, integer subject1, integer subject2, integer subject3 returns integer
                    	local $type$ value = thistype.GetFirst$name$(pivotKey, subject1, subject2, subject3)

                    	local integer result = 0

                        loop
                            exitwhen (value == HASH_TABLE.$name$.DEFAULT_VALUE)

                            local integer prio = thistype.Get$name$Prio(pivotKey, subject1, subject2, subject3, value)

                            if (prio > result) then
                                set result = prio
                            endif

                            set value = thistype.GetNext$name$(pivotKey, subject1, subject2, subject3, value)
                        endloop

                        return result
                    endmethod

                    static method Remove$name$ takes integer pivotKey, integer subject1, integer subject2, integer subject3, $type$ value returns nothing
                        local $type$ next = thistype.GetNext$name$(pivotKey, subject1, subject2, subject3, value)
                        local $type$ prev = thistype.GetPrev$name$(pivotKey, subject1, subject2, subject3, value)

                        if ((prev == HASH_TABLE.$name$.DEFAULT_VALUE) and (next == HASH_TABLE.$name$.DEFAULT_VALUE)) then
                            if (thistype.GetFirst$name$(pivotKey, subject1, subject2, subject3) != value) then
                                return
                            endif
                        endif
                //if $bugConverter$(thistype.GetFirst$name$(UNIT.Buffs.LOCAL_REFS_KEY, 47, 123, 0))!="0" then
                  //  call DebugEx("removeA========================= "+$bugConverter$(thistype.GetFirst$name$(UNIT.Buffs.LOCAL_REFS_KEY, 47, 123, 0))+" +++ "+I2S(BuffRef(186).whichBuff)+" next "+$bugConverter$(next)+" prev "+$bugConverter$(prev))
                //endif
                        if (next == HASH_TABLE.$name$.DEFAULT_VALUE) then
                            call EventMemoryHead.IntegerKeys.D2.Set$name$WithCache(thistype.LAST_CACHE, pivotKey, subject1, subject2, subject3, 0, prev)
                        else
                            call EventMemoryHead.IntegerKeys.D2.Set$name$WithCache(thistype.PREV_CACHE, pivotKey, subject1, subject2, subject3, $valueConverter$(next), prev)
                        endif
                //if $bugConverter$(thistype.GetFirst$name$(UNIT.Buffs.LOCAL_REFS_KEY, 47, 123, 0))!="0" then
                    //call DebugEx("removeB========================= "+$bugConverter$(thistype.GetFirst$name$(UNIT.Buffs.LOCAL_REFS_KEY, 47, 123, 0))+" +++ "+I2S(BuffRef(186).whichBuff)+" next "+$bugConverter$(next)+" prev "+$bugConverter$(prev))
                //endif
                        if (prev == HASH_TABLE.$name$.DEFAULT_VALUE) then
                            //set EventMemory.TEST=true
                            call EventMemoryHead.IntegerKeys.D2.Set$name$WithCache(thistype.FIRST_CACHE, pivotKey, subject1, subject2, subject3, 0, next)
                            //set EventMemory.TEST=false
                        else
                            //set EventMemory.TEST=true
                            call EventMemoryHead.IntegerKeys.D2.Set$name$WithCache(thistype.NEXT_CACHE, pivotKey, subject1, subject2, subject3, $valueConverter$(prev), next)
                            //set EventMemory.TEST=false
                        endif
                //if $bugConverter$(thistype.GetFirst$name$(UNIT.Buffs.LOCAL_REFS_KEY, 47, 123, 0))!="0" then
                    //call DebugEx("removeC========================= "+$bugConverter$(thistype.GetFirst$name$(UNIT.Buffs.LOCAL_REFS_KEY, 47, 123, 0))+" +++ "+I2S(BuffRef(186).whichBuff))
                //endif
                    endmethod

                    static method FetchFirst$name$ takes integer pivotKey, integer subject1, integer subject2, integer subject3 returns $type$
                        local $type$ value = thistype.GetFirst$name$(pivotKey, subject1, subject2, subject3)
//if EventMemory.TEST then
	//call DebugEx("fetchFirst: "+I2S(pivotKey)+";"+I2S(subject1)+";"+I2S(subject2)+";"+I2S(subject3)+" --> "+$bugConverter$(value))
//endif
                        if (value == HASH_TABLE.$name$.DEFAULT_VALUE) then
                            return HASH_TABLE.$name$.DEFAULT_VALUE
                        endif
                    //if $bugConverter$(thistype.GetFirst$name$(UNIT.Buffs.LOCAL_REFS_KEY, 47, 123, 0))!="0" then
                        //call DebugEx("bobobobo========================= "+$bugConverter$(thistype.GetFirst$name$(UNIT.Buffs.LOCAL_REFS_KEY, 47, 123, 0))+" +++ "+I2S(BuffRef(186).whichBuff))
                    //endif
                        call thistype.Remove$name$(pivotKey, subject1, subject2, subject3, value)
                    //if $bugConverter$(thistype.GetFirst$name$(UNIT.Buffs.LOCAL_REFS_KEY, 47, 123, 0))!="0" then
                        //call DebugEx("lalalala=========================== "+$bugConverter$(thistype.GetFirst$name$(UNIT.Buffs.LOCAL_REFS_KEY, 47, 123, 0))+" +++ "+I2S(BuffRef(186).whichBuff))
                    //endif
                        return value
                    endmethod

                    static method Clear$name$s takes integer pivotKey, integer subject1, integer subject2, integer subject3 returns nothing
                        loop
                            exitwhen (thistype.FetchFirst$name$(pivotKey, subject1, subject2, subject3) == HASH_TABLE.$name$.DEFAULT_VALUE)
                        endloop
                    endmethod

                    static method InsertAfter$name$ takes integer pivotKey, integer subject1, integer subject2, integer subject3, $type$ prev, $type$ value returns boolean
                        local $type$ next

                        if (prev == HASH_TABLE.$name$.DEFAULT_VALUE) then
                            set next = thistype.GetFirst$name$(pivotKey, subject1, subject2, subject3)

                            call EventMemoryHead.IntegerKeys.D2.Set$name$WithCache(thistype.FIRST_CACHE, pivotKey, subject1, subject2, subject3, 0, value)
                        else
                            set next = thistype.GetNext$name$(pivotKey, subject1, subject2, subject3, prev)

                            call EventMemoryHead.IntegerKeys.D2.Set$name$WithCache(thistype.NEXT_CACHE, pivotKey, subject1, subject2, subject3, $valueConverter$(prev), value)
                        endif

                        if (next == HASH_TABLE.$name$.DEFAULT_VALUE) then
                            call EventMemoryHead.IntegerKeys.D2.Set$name$WithCache(thistype.LAST_CACHE, pivotKey, subject1, subject2, subject3, 0, value)
                        else
                            call EventMemoryHead.IntegerKeys.D2.Set$name$WithCache(thistype.PREV_CACHE, pivotKey, subject1, subject2, subject3, $valueConverter$(next), value)
                        endif

                        call EventMemoryHead.IntegerKeys.D2.Set$name$WithCache(thistype.NEXT_CACHE, pivotKey, subject1, subject2, subject3, $valueConverter$(value), next)
                        call EventMemoryHead.IntegerKeys.D2.Set$name$WithCache(thistype.PREV_CACHE, pivotKey, subject1, subject2, subject3, $valueConverter$(value), prev)

                        return true
                    endmethod

                    static method Add$name$WithPrio takes integer pivotKey, integer subject1, integer subject2, integer subject3, $type$ value, integer prio returns boolean
                        local $type$ otherValue = thistype.GetLast$name$(pivotKey, subject1, subject2, subject3)

                        loop
                            exitwhen (otherValue == HASH_TABLE.$name$.DEFAULT_VALUE)

                            exitwhen (prio <= thistype.Get$name$Prio(pivotKey, subject1, subject2, subject3, otherValue))

                            set otherValue = thistype.GetPrev$name$(pivotKey, subject1, subject2, subject3, otherValue)
                        endloop

                        if not thistype.InsertAfter$name$(pivotKey, subject1, subject2, subject3, otherValue, value) then
                            return false
                        endif

                        call EventMemoryHead.IntegerKeys.D2.SetIntegerWithCache(thistype.PRIO_CACHE, pivotKey, subject1, subject2, subject3, $valueConverter$(value), prio)

                        return true
                    endmethod

                    static method Add$name$ takes integer pivotKey, integer subject1, integer subject2, integer subject3, $type$ value returns boolean
                    //local boolean pre=$bugConverter$(thistype.GetFirst$name$(UNIT.Buffs.LOCAL_REFS_KEY, 47, 123, 0))=="0"
                    //if $bugConverter$(thistype.GetFirst$name$(UNIT.Buffs.LOCAL_REFS_KEY, 47, 123, 0))!="0" then
                        //call DebugEx("pre============================== "+$bugConverter$(thistype.GetFirst$name$(UNIT.Buffs.LOCAL_REFS_KEY, 47, 123, 0))+" +++ "+I2S(BuffRef(186).whichBuff))
                    //endif
//                    call DebugEx("\t\tadd: "+I2S(pivotKey)+";"+I2S(subject1)+";"+I2S(subject2)+";"+I2S(subject3)+";"+$bugConverter$(value))
                    //local boolean res=thistype.Add$name$WithPrio(pivotKey, subject1, subject2, subject3, value, 0)
                    //if $bugConverter$(thistype.GetFirst$name$(UNIT.Buffs.LOCAL_REFS_KEY, 47, 123, 0))!="0" then
                      //  call DebugEx("================================= "+$bugConverter$(thistype.GetFirst$name$(UNIT.Buffs.LOCAL_REFS_KEY, 47, 123, 0))+" +++ "+I2S(BuffRef(186).whichBuff))
                    //endif
                        return thistype.Add$name$WithPrio(pivotKey, subject1, subject2, subject3, value, 0)
                    endmethod
                //! endtextmacro

                //! runtextmacro EventMemory_IntegerKeys_D2_Table_CreateType("Boolean", "boolean", "B2S", "Boolean.ToInt")
                //! runtextmacro EventMemory_IntegerKeys_D2_Table_CreateType("Integer", "integer", "I2S", "")
                //! runtextmacro EventMemory_IntegerKeys_D2_Table_CreateType("Real", "real", "R2S", "Real.ToInt")
                //! runtextmacro EventMemory_IntegerKeys_D2_Table_CreateType("String", "string", "", "String.ToIntHash")

                static method Init takes nothing returns nothing
                    set thistype.FIRST_CACHE = HashTable.Create()
                    set thistype.LAST_CACHE = HashTable.Create()

                    set thistype.NEXT_CACHE = HashTable.Create()
                    set thistype.PREV_CACHE = HashTable.Create()
                    set thistype.PRIO_CACHE = HashTable.Create()
                endmethod
            endstruct
        endscope

        //! runtextmacro Struct("D2")
            //! runtextmacro LinkToStaticStruct("D2", "Table")

            //! textmacro EventMemory_IntegerKeys_D2_CreateType takes name, type, bugConv
                static method Contains$name$ takes integer pivotKey, integer subject1, integer subject2, integer subject3, integer subject4 returns boolean
                    return EventMemoryHead.IntegerKeys.D2.Contains$name$(pivotKey, subject1, subject2, subject3, subject4)
                endmethod

                static method Get$name$ takes integer pivotKey, integer subject1, integer subject2, integer subject3, integer subject4 returns $type$
                    return EventMemoryHead.IntegerKeys.D2.Get$name$(pivotKey, subject1, subject2, subject3, subject4)
                endmethod

                static method Set$name$ takes integer pivotKey, integer subject1, integer subject2, integer subject3, integer subject4, $type$ value returns nothing
                    call EventMemoryHead.IntegerKeys.D2.Set$name$(pivotKey, subject1, subject2, subject3, subject4, value)
                endmethod

                static method Remove$name$ takes integer pivotKey, integer subject1, integer subject2, integer subject3, integer subject4 returns nothing
                    call EventMemoryHead.IntegerKeys.D2.Remove$name$(pivotKey, subject1, subject2, subject3, subject4)
                endmethod
            //! endtextmacro

            //! runtextmacro EventMemory_IntegerKeys_D2_CreateType("Boolean", "boolean", "B2S")
            //! runtextmacro EventMemory_IntegerKeys_D2_CreateType("Integer", "integer", "I2S")
            //! runtextmacro EventMemory_IntegerKeys_D2_CreateType("Real", "real", "R2S")
            //! runtextmacro EventMemory_IntegerKeys_D2_CreateType("String", "string", "")

            static method Init takes nothing returns nothing
                call thistype.Table.Init()
            endmethod
        endstruct

        //! runtextmacro Struct("Table")
            static constant integer EMPTY = HASH_TABLE.Integer.DEFAULT_VALUE//-1
            static constant integer OFFSET = 8192
            static HashTable POS_CACHE
            static HashTable PRIO_CACHE
            static constant integer SIZE = 8192

            static constant integer STARTED = thistype.EMPTY + 1//0

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

            private static method SetCount takes integer missionKey, integer key, integer value returns nothing
                call EventMemoryHead.IntegerKeys.SetInteger(missionKey, key, value - thistype.EMPTY)
            endmethod

            static method ToArrayIndex takes integer index returns integer
                return (index - thistype.STARTED + ARRAY_MIN)
            endmethod

            //! textmacro EventMemory_IntegerKeys_Table_CreateType takes name, type, bugConverter, valueConverter
                static method Get$name$Pos takes integer missionKey, integer key, $type$ value returns integer
                    return thistype.POS_CACHE.Integer.Get(missionKey, thistype.GetReverseKey(key, $valueConverter$(value)))
                endmethod

                static method Get$name$Prio takes integer missionKey, integer key, $type$ value returns integer
                    return thistype.PRIO_CACHE.Integer.Get(missionKey, thistype.GetReverseKey(key, $valueConverter$(value)))
                endmethod

                static method Count$name$s takes integer missionKey, integer key returns integer
                    return (thistype.EMPTY + EventMemoryHead.IntegerKeys.GetInteger(missionKey, key))
                endmethod

                static method IsEmpty$name$ takes integer missionKey, integer key returns boolean
                    return (EventMemoryHead.IntegerKeys.GetInteger(missionKey, key) == thistype.EMPTY)
                endmethod

                static method Get$name$ takes integer missionKey, integer key, integer index returns $type$
                    return EventMemoryHead.IntegerKeys.Get$name$(missionKey, key + index)
                endmethod

                static method GetFirst$name$ takes integer missionKey, integer key returns $type$
                    return thistype.Get$name$(missionKey, key, thistype.STARTED)
                endmethod

                static method GetLast$name$ takes integer missionKey, integer key returns $type$
                    return thistype.Get$name$(missionKey, key, thistype.Count$name$s(missionKey, key))
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

                    if (count == thistype.EMPTY) then
                        return HASH_TABLE.$name$.DEFAULT_VALUE
                    endif

                    local $type$ value = thistype.Get$name$(missionKey, key, count)

                    call thistype.SetCount(missionKey, key, count - 1)
                    call thistype.POS_CACHE.$name$.Remove(missionKey, thistype.GetReverseKey(key, $valueConverter$(value)))
                    call EventMemoryHead.IntegerKeys.Remove$name$(missionKey, key + count)

                    return value
                endmethod

                static method Clear$name$s takes integer missionKey, integer key returns nothing
                    local integer iteration = thistype.Count$name$s(missionKey, key)

                    loop
                        exitwhen (iteration < thistype.STARTED)

                        local $type$ value = thistype.Get$name$(missionKey, key, iteration)

                        call EventMemoryHead.IntegerKeys.Remove$name$(missionKey, key + iteration)
                        call thistype.POS_CACHE.Integer.Remove(missionKey, thistype.GetReverseKey(key, $valueConverter$(value)))

                        set iteration = iteration - 1
                    endloop

					call thistype.SetCount(missionKey, key, thistype.EMPTY)
                endmethod

                static method Add$name$ takes integer missionKey, integer key, $type$ value returns boolean
                    if thistype.Contains$name$(missionKey, key, value) then
call DebugEx($bugConverter$(value)+" already in table "+I2S(missionKey)+";"+I2S(key))
call thistype.Print$name$s(missionKey, key)
                        return false
                    endif

                    local integer count = thistype.Count$name$s(missionKey, key) + 1
//if EventMemory.TEST then
    //call DebugEx(I2S(thistype.GetReverseKey(key, $valueConverter$(value)))+";"+I2S(count))
//endif
                    call thistype.SetCount(missionKey, key, count)
                    call thistype.POS_CACHE.Integer.Set(missionKey, thistype.GetReverseKey(key, $valueConverter$(value)), count)
                    call EventMemoryHead.IntegerKeys.Set$name$(missionKey, key + count, value)

                    return (count == thistype.STARTED)
                endmethod

                static method Add$name$Multi takes integer missionKey, integer key, $type$ value returns boolean
                    local integer count = thistype.Count$name$s(missionKey, key) + 1

                    call thistype.SetCount(missionKey, key, count)
                    call EventMemoryHead.IntegerKeys.Set$name$(missionKey, key + count, value)

                    return (count == thistype.STARTED)
                endmethod

                /*static method Add$name$WithPrio takes integer missionKey, integer key, $type$ value, integer prio returns boolean
                    local integer count = thistype.Count$name$s(missionKey, key)

                    loop
                        exitwhen (iteration < thistype.STARTED)

                        exitwhen (prio < thistype.Get$name$Prio(missionKey, key, value))

                        set iteration = iteration - 1
                    endloop

                    if not thistype.Insert$name$(missionKey, key, value) then
                        return false
                    endif

                    call thistype.PRIO_CACHE.Integer.Set(missionKey, thistype.GetReverseKey(key, $valueConverter$(value)), prio)

                    return true
                endmethod*/

                static method Join$name$ takes integer missionKey, integer key, integer missionKey2, integer key2 returns nothing
                    local integer count = thistype.Count$name$s(missionKey2, key2)

                    if (count == thistype.EMPTY) then
                        return
                    endif

					local integer addCount = 0
                    local integer iteration = thistype.STARTED
                    local integer oldCount = thistype.Count$name$s(missionKey, key)

                    loop
                        local $type$ value = thistype.Get$name$(missionKey2, key2, iteration)

                        if not thistype.Contains$name$(missionKey, key, value) then
                            set addCount = addCount + 1

                            call thistype.POS_CACHE.Integer.Set(missionKey, thistype.GetReverseKey(key, $valueConverter$(value)), oldCount + addCount)
                            call EventMemoryHead.IntegerKeys.Set$name$(missionKey, key + oldCount + addCount, value)
                        endif

                        set iteration = iteration + 1

                        exitwhen (iteration > count)
                    endloop

                    call thistype.SetCount(missionKey, key, oldCount + addCount)
                endmethod

                static method Print$name$s takes integer missionKey, integer key returns nothing
                	local integer count = thistype.Count$name$s(missionKey, key)

					call DebugBufferStart()

                    call DebugBuffer("print table " + I2S(missionKey) + ";" + I2S(key) + ";" + I2S(count))

                    local string missionKeyName = Memory.GetKeyFromValue(missionKey)
                    local string keyName = Memory.GetKeyFromValue(key)

                    if ((missionKeyName != null) or (keyName != null)) then
                        call DebugBuffer(missionKeyName + ";" + keyName)
                    endif

                    call DebugBuffer("--->")

					local integer iteration = count

                    loop
                        exitwhen (iteration < thistype.STARTED)

                        local $type$ value = thistype.Get$name$(missionKey, key, iteration)

                        local integer pos = thistype.Get$name$Pos(missionKey, key, value)

                        call DebugBuffer(Char.TAB + $bugConverter$(value) + " on " + I2S(iteration) + ";" + I2S(pos) + ";" + I2S(thistype.GetReverseKey(key, $valueConverter$(value))))
                        if (iteration != pos) then
                            call DebugBuffer("TABLE CORRUPTED!")
                        endif
                        call DebugBuffer(Char.TAB + Char.TAB + Memory.GetKeyFromValue(pos))

                        set iteration = iteration - 1
                    endloop

					//call Code.PrintThreadInfo()

                    call DebugBufferFinish()
                endmethod

                static method Remove$name$ takes integer missionKey, integer key, $type$ value returns boolean
                    local integer count = thistype.Count$name$s(missionKey, key)
                    local integer reverseKey = thistype.GetReverseKey(key, $valueConverter$(value))

                    local $type$ lastValue = thistype.Get$name$(missionKey, key, count)
                    local integer pos = thistype.POS_CACHE.Integer.Get(missionKey, reverseKey)

                    static if DEBUG then
                        if not thistype.Contains$name$(missionKey, key, value) then
                            call DebugEx(thistype.NAME + ": " + "cannot remove "+$bugConverter$(value) + " from " + I2S(missionKey) + ";" + I2S(key) + " reverseKey: "+I2S(reverseKey))

                            call thistype.Print$name$s(missionKey, key)

                            return false
                        endif
                    endif

                    call thistype.POS_CACHE.Integer.Set(missionKey, thistype.GetReverseKey(key, $valueConverter$(lastValue)), pos)
                    call EventMemoryHead.IntegerKeys.Set$name$(missionKey, key + pos, lastValue)

                    call thistype.POS_CACHE.Integer.Remove(missionKey, reverseKey)
                    call EventMemoryHead.IntegerKeys.Remove$name$(missionKey, key + count)

                    set count = count - 1

                    call thistype.SetCount(missionKey, key, count)

                    return (count == thistype.EMPTY)
                endmethod

                static method FetchRandom$name$ takes integer missionKey, integer key, integer lowerBound, integer higherBound returns $type$
                    local integer count = thistype.Count$name$s(missionKey, key)

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

                    local $type$ value = thistype.Get$name$(missionKey, key, index)

                    call thistype.Remove$name$ByIndex(missionKey, key, index)

                    return value
                endmethod

                static method FetchRandom$name$All takes integer missionKey, integer key returns $type$
                    return thistype.FetchRandom$name$(missionKey, key, EventMemory.IntegerKeys.Table.STARTED, thistype.Count$name$s(missionKey, key))
                endmethod

                static method Shuffle$name$s takes integer missionKey, integer key returns nothing
                    local integer count = thistype.Count$name$s(missionKey, key)

                    local integer iteration = count
                    local $type$ array temp

                    loop
                        exitwhen (iteration < thistype.STARTED)

                        set temp[thistype.ToArrayIndex(iteration)] = thistype.Get$name$(missionKey, key, iteration)

                        set iteration = iteration - 1
                    endloop

					call thistype.Clear$name$s(missionKey, key)

                    set iteration = thistype.ToArrayIndex(count)

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        local integer index = Math.RandomI(ARRAY_MIN, iteration)

                        call thistype.Add$name$(missionKey, key, temp[index])

                        set temp[index] = temp[iteration]

                        set iteration = iteration - 1
                    endloop
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

            //! runtextmacro EventMemory_IntegerKeys_Table_CreateType("Boolean", "boolean", "B2S", "Boolean.ToInt")
            //! runtextmacro EventMemory_IntegerKeys_Table_CreateType("Integer", "integer", "I2S", "")
            //! runtextmacro EventMemory_IntegerKeys_Table_CreateType("Real", "real", "R2S", "Real.ToInt")
            //! runtextmacro EventMemory_IntegerKeys_Table_CreateType("String", "string", "", "String.ToIntHash")

            //! textmacro EventMemory_IntegerKeys_Table_CreateSortedType takes name, type, bugConverter, valueConverter
                static method Add$name$Sorted takes integer missionKey, integer key, $type$ value, real sortValue returns boolean
                    local integer count = thistype.Count$name$s(missionKey, key)

                    local integer iteration = count

                    loop
                        exitwhen (iteration == thistype.EMPTY)
                        exitwhen (value > thistype.Get$name$(missionKey, key, iteration))

                        set iteration = iteration - 1
                    endloop

					local integer index

                    if (iteration == thistype.EMPTY) then
                        set index = thistype.STARTED
                    endif

                    set count = count + 1
                    set iteration = index + 1

                    call thistype.SetCount(missionKey, key, count)
                    loop
                        exitwhen (iteration > count)

                        local $type$ otherValue = thistype.Get$name$(missionKey, key, iteration - 1)

                        call thistype.POS_CACHE.Integer.Set(missionKey, thistype.GetReverseKey(key, $valueConverter$(otherValue)), iteration)
                        call EventMemoryHead.IntegerKeys.Set$name$(missionKey, key + iteration, otherValue)

                        set iteration = iteration + 1
                    endloop

                    call thistype.POS_CACHE.Integer.Set(missionKey, thistype.GetReverseKey(key, $valueConverter$(value)), index)
                    call EventMemoryHead.IntegerKeys.Set$name$(missionKey, key + index, value)

                    return (count == thistype.STARTED)
                endmethod

                static method Remove$name$Sorted takes integer missionKey, integer key, $type$ value returns boolean
                    local integer count = thistype.Count$name$s(missionKey, key) - 1
                    local integer reverseKey = thistype.GetReverseKey(key, $valueConverter$(value))

                    local integer index = thistype.POS_CACHE.Integer.Get(missionKey, reverseKey)

                    static if DEBUG then
                        if not thistype.Contains$name$(missionKey, key, value) then
                            call DebugEx(thistype.NAME + ": " + "cannot remove " + $bugConverter$(value) + " from " + I2S(missionKey) + ";" + I2S(key))

                            return false
                        endif
                    endif

                    call thistype.POS_CACHE.Integer.Remove(missionKey, reverseKey)
                    call EventMemoryHead.IntegerKeys.Remove$name$(missionKey, key + index)

                    set count = count - 1

                    local integer iteration = index

                    loop
                        exitwhen (iteration > count)

                        set value = thistype.Get$name$(missionKey, key, iteration + 1)

                        call thistype.POS_CACHE.Integer.Set(missionKey, thistype.GetReverseKey(key, $valueConverter$(value)), iteration)
                        call EventMemoryHead.IntegerKeys.Set$name$(missionKey, key + iteration, value)

                        set iteration = iteration - 1
                    endloop

                    call thistype.SetCount(missionKey, key, count)

                    return (count == thistype.EMPTY)
                endmethod
            //! endtextmacro

            //! runtextmacro EventMemory_IntegerKeys_Table_CreateSortedType("Integer", "integer", "I2S", "")
            //! runtextmacro EventMemory_IntegerKeys_Table_CreateSortedType("Real", "real", "R2S", "Real.ToInt")

            static method Clear takes integer missionKey, integer key returns nothing
                call thistype.ClearIntegers(missionKey, key)
            endmethod

        	static method RemoveChild takes integer missionKey returns nothing
            	call EventMemoryHead.IntegerKeys.RemoveChild(missionKey)
            	call thistype.POS_CACHE.RemoveChild(missionKey)
            	call thistype.PRIO_CACHE.RemoveChild(missionKey)
        	endmethod

            static method Init takes nothing returns nothing
                set thistype.POS_CACHE = HashTable.Create()
                set thistype.PRIO_CACHE = HashTable.Create()
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("IntegerKeys")
        //! runtextmacro LinkToStaticStruct("IntegerKeys", "D2")
        //! runtextmacro LinkToStaticStruct("IntegerKeys", "Table")

        static method RemoveChild takes integer missionKey returns nothing
            call EventMemoryHead.IntegerKeys.RemoveChild(missionKey)
        endmethod

        //! textmacro EventMemory_IntegerKeys_CreateType takes name, type, bugConv
            static method Contains$name$ takes integer missionKey, integer key returns boolean
                return EventMemoryHead.IntegerKeys.Contains$name$(missionKey, key)
            endmethod

            static method Get$name$ takes integer missionKey, integer key returns $type$
                return EventMemoryHead.IntegerKeys.Get$name$(missionKey, key)
            endmethod

            static method Get$name$ByHandle takes handle handleSource, integer key returns $type$
                return EventMemoryHead.IntegerKeys.Get$name$ByHandle(handleSource, key)
            endmethod

            static method Set$name$ takes integer missionKey, integer key, $type$ value returns nothing
                call EventMemoryHead.IntegerKeys.Set$name$(missionKey, key, value)
            endmethod

            static method Set$name$ByHandle takes handle handleSource, integer key, $type$ value returns nothing
                call thistype.Set$name$(GetHandleId(handleSource), key, value)
            endmethod

            static method Remove$name$ takes integer missionKey, integer key returns nothing
                call EventMemoryHead.IntegerKeys.Remove$name$(missionKey, key)
            endmethod

            static method Remove$name$ByHandle takes handle handleSource, integer key returns nothing
                call EventMemoryHead.IntegerKeys.Remove$name$ByHandle(handleSource, key)
            endmethod
        //! endtextmacro

        //! runtextmacro EventMemory_IntegerKeys_CreateType("Boolean", "boolean", "B2S")
        //! runtextmacro EventMemory_IntegerKeys_CreateType("Integer", "integer", "I2S")
        //! runtextmacro EventMemory_IntegerKeys_CreateType("Real", "real", "R2S")
        //! runtextmacro EventMemory_IntegerKeys_CreateType("String", "string", "")

        static method Init takes nothing returns nothing
            call thistype.D2.Init()
            call thistype.Table.Init()
        endmethod
    endstruct
endscope

//! runtextmacro StaticStruct("EventMemory")
    //! runtextmacro LinkToStaticStruct("EventMemory", "IntegerKeys")

    initMethod Init of Header_Event
        call EventMemoryHead.Init()

        call thistype.IntegerKeys.Init()
    endmethod
endstruct