//! runtextmacro Folder("BJUnit")
    //! textmacro BJUnit_CreateStateWithPermanentAbilities takes name
        method Set takes unit self, real amount, real oldAmount returns nothing
            local integer packet
            local integer packetLevel

            if (amount * oldAmount <= 0.) then
                if (oldAmount < 0.) then
                    set packetLevel = thistype.DECREASING_SPELLS_MAX

                    loop
                        call UnitRemoveAbility(self, thistype.DECREASING_SPELLS_ID[packetLevel])

                        set packetLevel = packetLevel - 1
                        exitwhen (packetLevel < ARRAY_MIN)
                    endloop
                else
                    set packetLevel = thistype.INCREASING_SPELLS_MAX

                    loop
                        call UnitRemoveAbility(self, thistype.INCREASING_SPELLS_ID[packetLevel])

                        set packetLevel = packetLevel - 1
                        exitwhen (packetLevel < ARRAY_MIN)
                    endloop
                endif
                if (amount < 0.) then
                    set amount = -amount

                    set packetLevel = Math.MinI(Math.LogOf2I(Real.ToInt(Math.Max(Math.Abs(oldAmount), Math.Abs(amount)))), thistype.DECREASING_SPELLS_MAX)

                    loop
                        exitwhen (amount < 1.)

                        set packet = thistype.PACKETS[packetLevel]

                        if (packet <= amount) then
                            set amount = amount - packet
                            call UnitAddAbility(self, thistype.DECREASING_SPELLS_ID[packetLevel])
                        endif

                        set packetLevel = packetLevel - 1
                    endloop
                else
                    set packetLevel = Math.MinI(Math.LogOf2I(Real.ToInt(Math.Max(Math.Abs(oldAmount), Math.Abs(amount)))), thistype.INCREASING_SPELLS_MAX)

                    loop
                        exitwhen (amount < 1.)

                        set packet = thistype.PACKETS[packetLevel]

                        if (packet <= amount) then
                            set amount = amount - packet
                            call UnitAddAbility(self, thistype.INCREASING_SPELLS_ID[packetLevel])
                        endif

                        set packetLevel = packetLevel - 1
                    endloop
                endif
            else
                set packetLevel = Math.MinI(Math.LogOf2I(Real.ToInt(Math.Max(Math.Abs(oldAmount), Math.Abs(amount)))), thistype.DECREASING_SPELLS_MAX)

                if (amount < 0.) then
                    set amount = -amount

                    loop
                        exitwhen (packetLevel < ARRAY_MIN)

                        set packet = thistype.PACKETS[packetLevel]

                        if (packet <= amount) then
                            set amount = amount - packet
                            call UnitAddAbility(self, thistype.DECREASING_SPELLS_ID[packetLevel])
                        else
                            call UnitRemoveAbility(self, thistype.DECREASING_SPELLS_ID[packetLevel])
                        endif

                        set packetLevel = packetLevel - 1
                    endloop
                else
                    set packetLevel = Math.MinI(Math.LogOf2I(Real.ToInt(Math.Max(Math.Abs(oldAmount), Math.Abs(amount)))), thistype.INCREASING_SPELLS_MAX)

                    loop
                        exitwhen (packetLevel < ARRAY_MIN)

                        set packet = thistype.PACKETS[packetLevel]

                        if (packet <= amount) then
                            set amount = amount - packet
                            //call DebugEx("$name$: "+GetUnitName(self)+";"+B2S( UnitAddAbility(self, thistype.INCREASING_SPELLS_ID[packetLevel]) ))
                        else
                            call UnitRemoveAbility(self, thistype.INCREASING_SPELLS_ID[packetLevel])
                        endif

                        set packetLevel = packetLevel - 1
                    endloop
                endif
            endif
        endmethod
    //! endtextmacro

    //! runtextmacro Folder("Armor")
        //! runtextmacro Struct("Bonus")
            //! runtextmacro BJUnit_CreateStateWithPermanentAbilities("ArmorBonus")

            static method Init takes nothing returns nothing
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Armor")
        //! runtextmacro LinkToStaticStruct("Armor", "Bonus")

        static method Init takes nothing returns nothing
            call thistype(NULL).Bonus.Init()
        endmethod
    endstruct

    //! runtextmacro Folder("Attack")
        //! runtextmacro Folder("Speed")
            //! runtextmacro Struct("BonusA")
            //! runtextmacro BJUnit_CreateStateWithPermanentAbilities("AttackSpeedBonus")

                static method Init takes nothing returns nothing
                endmethod
            endstruct
        endscope

        //! runtextmacro Struct("Speed")
            //! runtextmacro LinkToStaticStruct("Speed", "BonusA")

            static method Init takes nothing returns nothing
                call thistype(NULL).BonusA.Init()
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Attack")
        //! runtextmacro LinkToStaticStruct("Attack", "Speed")

        static method Init takes nothing returns nothing
            call thistype(NULL).Speed.Init()
        endmethod
    endstruct

    //! runtextmacro Folder("Damage")
        //! runtextmacro Struct("Bonus")
            //! runtextmacro BJUnit_CreateStateWithPermanentAbilities("DamageBonus")

            static method Init takes nothing returns nothing
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Damage")
        static item array DECREASING_ITEMS
        static item array INCREASING_ITEMS

        //! runtextmacro LinkToStaticStruct("Damage", "Bonus")

        method Add takes unit self, real amount returns nothing
            local boolean hasInventory = (UnitInventorySize(self) > 0)
            local integer packet
            local integer packetLevel

            if (hasInventory == false) then
                call UnitAddAbility(self, Unit.HERO_INVENTORY_SPELL_ID)
            endif

            if (amount < 0) then
                set amount = -amount
                set packetLevel = thistype.DECREASING_ITEMS_MAX

                loop
                    exitwhen (amount < 1)

                    set packet = PACKETS[packetLevel]

                    loop
                        exitwhen (amount < packet)

                        call UnitAddItem(self, thistype.DECREASING_ITEMS[packetLevel])

                        call SetWidgetLife(thistype.DECREASING_ITEMS[packetLevel], 1.)

                        set amount = amount - packet
                    endloop

                    set packetLevel = packetLevel - 1
                endloop
            else
                set packetLevel = thistype.INCREASING_ITEMS_MAX

                loop
                    exitwhen (amount < 1)

                    set packet = thistype.PACKETS[packetLevel]

                    loop
                        exitwhen (amount < packet)

                        call UnitAddItem(self, thistype.INCREASING_ITEMS[packetLevel])

                        call SetWidgetLife(thistype.INCREASING_ITEMS[packetLevel], 1.)

                        set amount = amount - packet
                    endloop

                    set packetLevel = packetLevel - 1
                endloop
            endif

            if (hasInventory == false) then
                call UnitRemoveAbility(self, Unit.HERO_INVENTORY_SPELL_ID)
            endif
        endmethod

        static method Init takes nothing returns nothing
            local integer iteration = thistype.DECREASING_ITEMS_MAX

            loop
                exitwhen (iteration < 0)

                set thistype.DECREASING_ITEMS[iteration] = CreateItem('Idd0' + iteration, 0., 0.)

                set iteration = iteration - 1
            endloop

            set iteration = thistype.INCREASING_ITEMS_MAX

            loop
                exitwhen (iteration < 0)

                set thistype.INCREASING_ITEMS[iteration] = CreateItem('Iid0' + iteration, 0., 0.)

                set iteration = iteration - 1
            endloop

            call thistype(NULL).Bonus.Init()
        endmethod
    endstruct
endscope

//! runtextmacro StaticStruct("BJUnit")
    //! runtextmacro LinkToStaticStruct("BJUnit", "Armor")
    //! runtextmacro LinkToStaticStruct("BJUnit", "Attack")
    //! runtextmacro LinkToStaticStruct("BJUnit", "Damage")

    static method Init takes nothing returns nothing
        call thistype(NULL).Armor.Init()
        call thistype(NULL).Attack.Init()
        call thistype(NULL).Damage.Init()
    endmethod
endstruct

//! runtextmacro Folder("UnitClass")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("UnitClass", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("UnitClass", "Integer", "integer")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Integer")

        //! runtextmacro Data_Implement("UnitClass")
    endstruct
endscope

//! runtextmacro BaseStruct("UnitClass", "UNIT_CLASS")
    static thistype AIR
    static thistype DEAD
    static thistype GROUND
    static thistype HERO
    static thistype ILLUSION
    static thistype MECHANICAL
    static thistype NEUTRAL
    static thistype STRUCTURE
    static thistype SUMMON
    static thistype UNDECAYABLE
    static thistype UPGRADED
    static thistype WARD

    //! runtextmacro LinkToStruct("UnitClass", "Data")
    //! runtextmacro LinkToStruct("UnitClass", "Id")

    static method Create takes nothing returns thistype
        local thistype this = thistype.allocate()

        call this.AddToList()

        call this.Id.Event_Create()

        return this
    endmethod

    static method Init takes nothing returns nothing
        set thistype.AIR = thistype.Create()
        set thistype.DEAD = thistype.Create()
        set thistype.GROUND = thistype.Create()
        set thistype.HERO = thistype.Create()
        set thistype.ILLUSION = thistype.Create()
        set thistype.MECHANICAL = thistype.Create()
        set thistype.NEUTRAL = thistype.Create()
        set thistype.STRUCTURE = thistype.Create()
        set thistype.SUMMON = thistype.Create()
        set thistype.UNDECAYABLE = thistype.Create()
        set thistype.UPGRADED = thistype.Create()
        set thistype.WARD = thistype.Create()
    endmethod
endstruct

//! runtextmacro Folder("UnitTypePool")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("UnitTypePool", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("UnitTypePool", "Integer", "integer")
        endstruct

        //! runtextmacro Struct("Real")
            //! runtextmacro Data_Type_Implement("UnitTypePool", "Real", "real")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Integer")
        //! runtextmacro LinkToStruct("Data", "Real")

        //! runtextmacro Data_Implement("UnitTypePool")
    endstruct
endscope

//! runtextmacro BaseStruct("UnitTypePool", "UNIT_TYPE_POOL")
    //! runtextmacro GetKeyArray("KEY_ARRAY")
    //! runtextmacro GetKeyArray("WEIGHT_KEY_ARRAY_DETAIL")

    real weightAll

    //! runtextmacro LinkToStruct("UnitTypePool", "Data")
    //! runtextmacro LinkToStruct("UnitTypePool", "Id")

    method Random takes nothing returns UnitType
        local integer iteration = Memory.IntegerKeys.Table.STARTED
        local real random = Math.Random(0., this.weightAll)
        local real typeRandom = 0.
        local UnitType whichType

        loop
            set whichType = this.Data.Integer.Table.Get(KEY_ARRAY, iteration)

            set typeRandom = typeRandom + this.Data.Real.Get(WEIGHT_KEY_ARRAY_DETAIL + whichType)

            exitwhen (random <= typeRandom)

            set iteration = iteration + 1
        endloop

        return whichType
    endmethod

    method AddType takes UnitType whichType, real weight returns nothing
        set this.weightAll = this.weightAll + weight
        call this.Data.Integer.Table.Add(KEY_ARRAY, whichType)
        call this.Data.Real.Set(WEIGHT_KEY_ARRAY_DETAIL + whichType, weight)
    endmethod

    static method Create takes nothing returns thistype
        local thistype this = thistype.allocate()

        set this.weightAll = 0.
        call this.Id.Event_Create()

        return this
    endmethod

    static method Init takes nothing returns nothing
    endmethod
endstruct

//! runtextmacro Folder("Unit")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKey("KEY")
        //! runtextmacro GetKeyArray("PARENT_KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState_NotStart("integer")

        static method GetParent takes integer value returns Unit
            return Memory.IntegerKeys.GetInteger(PARENT_KEY_ARRAY + value, KEY)
        endmethod

        method Event_Create takes nothing returns nothing
            local integer value = GetHandleId(Unit(this).self)

            call this.Set(value)
            call Memory.IntegerKeys.SetInteger(PARENT_KEY_ARRAY + value, KEY, this)
        endmethod
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Struct("Boolean")
            //! runtextmacro Data_Type_Implement("Unit", "Boolean", "boolean")

            //! runtextmacro Data_Boolean_Implement("Unit")
        endstruct

        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("Unit", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("Unit", "Integer", "integer")

            //! runtextmacro Data_Integer_Implement("Unit")
        endstruct

        //! runtextmacro Folder("Real")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("Unit", "Real", "real")
            endstruct
        endscope

        //! runtextmacro Struct("Real")
            //! runtextmacro LinkToStruct("Real", "Table")

            //! runtextmacro Data_Type_Implement("Unit", "Real", "real")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Boolean")
        //! runtextmacro LinkToStruct("Data", "Integer")
        //! runtextmacro LinkToStruct("Data", "Real")

        //! runtextmacro Data_Implement("Unit")
    endstruct

    //! runtextmacro Folder("Event")
        //! runtextmacro Struct("Combination")
            method Remove takes EventCombination whichCombination returns nothing
                local integer iteration = whichCombination.Events.Count()
                local EventPair thisPair

                loop
                    exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                    call Unit(this).Event.Remove(whichCombination.Events.Get(iteration))

                    set iteration = iteration - 1
                endloop

                set iteration = whichCombination.Pairs.Count()

                loop
                    exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                    set thisPair = whichCombination.Pairs.Get(iteration)

                    call Unit(this).Event.Remove(thisPair.GetNegativeEvent())
                    call Unit(this).Event.Remove(thisPair.GetPositiveEvent())

                    set iteration = iteration - 1
                endloop

                call whichCombination.Subjects.Remove(Unit(this).Id.Get())
            endmethod

            method Add takes EventCombination whichCombination returns nothing
                local integer iteration = whichCombination.Events.Count()
                local EventPair thisPair

                loop
                    exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                    call Unit(this).Event.Add(whichCombination.Events.Get(iteration))

                    set iteration = iteration - 1
                endloop

                set iteration = whichCombination.Pairs.Count()

                loop
                    exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                    set thisPair = whichCombination.Pairs.Get(iteration)

                    call Unit(this).Event.Add(thisPair.GetNegativeEvent())
                    call Unit(this).Event.Add(thisPair.GetPositiveEvent())

                    set iteration = iteration - 1
                endloop

                call whichCombination.Subjects.Add(Unit(this).Id.Get())
            endmethod
        endstruct

        //! runtextmacro Struct("Counted")
            static Event DESTROY_EVENT
            //! runtextmacro GetKeyArray("KEY_ARRAY")
            //! runtextmacro GetKeyArray("KEY_ARRAY_DETAIL")

            method Ending takes Event whichEvent, boolean byDestroy returns nothing
                if (byDestroy) then
                    call Unit(this).Data.Integer.Remove(KEY_ARRAY_DETAIL + whichEvent)
                endif
                if (Unit(this).Data.Integer.Table.Remove(KEY_ARRAY, whichEvent)) then
                    call Unit(this).Event.Remove(DESTROY_EVENT)
                endif
                call Unit(this).Event.Remove(whichEvent)
            endmethod

            method Subtract takes Event whichEvent returns nothing
                if (Unit(this).Data.Integer.Subtract(KEY_ARRAY_DETAIL + whichEvent, 1)) then
                    call this.Ending(whichEvent, false)
                endif
            endmethod

            static method Event_Destroy takes nothing returns nothing
                local thistype parentThis = UNIT.Event.GetTrigger()
                local Event whichEvent

                loop
                    set whichEvent = Unit(parentThis).Data.Integer.Table.GetFirst(KEY_ARRAY)
                    exitwhen (whichEvent == NULL)

                    call parentThis.Ending(whichEvent, true)
                endloop
            endmethod

            method Add takes Event whichEvent returns nothing
                if (Unit(this).Data.Integer.Add(KEY_ARRAY_DETAIL + whichEvent, 1)) then
                    if (Unit(this).Data.Integer.Table.Add(KEY_ARRAY, whichEvent)) then
                        call Unit(this).Event.Add(DESTROY_EVENT)
                    endif
                    call Unit(this).Event.Add(whichEvent)
                endif
            endmethod

            static method Init takes nothing returns nothing
                set thistype.DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
            endmethod
        endstruct

        function GetAttacker_Wrapped takes nothing returns unit
            return GetAttacker()
        endfunction

        //! runtextmacro Struct("Native")
            //! textmacro Unit_Event_Native_CreateResponse takes name, source
                static method Get$name$ takes nothing returns Unit
                    local Unit result
                    local unit self = $source$()

                    if (GetUnitAbilityLevel(self, DummyUnit.LOCUST_SPELL_ID) > 0) then
                        set self = null

                        return STRUCT_INVALID
                    endif

                    set result = Unit.GetFromSelf(self)

                    set self = null

                    return result
                endmethod
            //! endtextmacro

            //! runtextmacro Unit_Event_Native_CreateResponse("AcquiredTarget", "GetEventTargetUnit")
            //! runtextmacro Unit_Event_Native_CreateResponse("Attacker", "GetAttacker_Wrapped")
            //! runtextmacro Unit_Event_Native_CreateResponse("Damager", "GetEventDamageSource")
            //! runtextmacro Unit_Event_Native_CreateResponse("Enum", "GetEnumUnit")
            //! runtextmacro Unit_Event_Native_CreateResponse("Filter", "GetFilterUnit")
            //! runtextmacro Unit_Event_Native_CreateResponse("Killer", "GetKillingUnit")
            //! runtextmacro Unit_Event_Native_CreateResponse("OrderTarget", "GetOrderTargetUnit")
            //! runtextmacro Unit_Event_Native_CreateResponse("Purchaser", "GetBuyingUnit")
            //! runtextmacro Unit_Event_Native_CreateResponse("SpellTarget", "GetSpellTargetUnit")
            //! runtextmacro Unit_Event_Native_CreateResponse("Trigger", "GetTriggerUnit")
        endstruct
    endscope

    //! runtextmacro Struct("Event")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro LinkToStruct("Event", "Combination")
        //! runtextmacro LinkToStruct("Event", "Counted")
        //! runtextmacro LinkToStruct("Event", "Native")

        //! runtextmacro CreateAnyStaticStateDefault("ATTACKER", "Attacker", "Unit", "NULL")
        //! runtextmacro CreateAnyStaticStateDefault("DAMAGER", "Damager", "Unit", "NULL")
        //! runtextmacro CreateAnyStaticStateDefault("ENUM", "Enum", "Unit", "NULL")
        //! runtextmacro CreateAnyStaticStateDefault("KILLER", "Killer", "Unit", "NULL")
        //! runtextmacro CreateAnyStaticStateDefault("TARGET", "Target", "Unit", "NULL")
        //! runtextmacro CreateAnyStaticStateDefault("TRIGGER", "Trigger", "Unit", "NULL")

        method Contains takes Event whichEvent returns boolean
            return whichEvent.Data.Integer.Table.Contains(KEY_ARRAY, this)
        endmethod

        method Count takes integer whichType, integer priority returns integer
            return Unit(this).Data.Integer.Table.Count(Event.GetKey(whichType, priority))
        endmethod

        method Get takes integer whichType, integer priority, integer index returns Event
            return Unit(this).Data.Integer.Table.Get(Event.GetKey(whichType, priority), index)
        endmethod

        method Remove takes Event whichEvent returns nothing
            call whichEvent.Data.Integer.Table.Remove(KEY_ARRAY, this)
            call Unit(this).Data.Integer.Table.Remove(Event.GetKey(whichEvent.GetType(), whichEvent.GetPriority()), whichEvent)
        endmethod

        method Add takes Event whichEvent returns nothing
            call whichEvent.Data.Integer.Table.Add(KEY_ARRAY, this)
            call Unit(this).Data.Integer.Table.Add(Event.GetKey(whichEvent.GetType(), whichEvent.GetPriority()), whichEvent)
        endmethod

        static method Init takes nothing returns nothing
            call thistype(NULL).Counted.Init()
        endmethod
    endstruct

    //! runtextmacro Folder("Abilities")
        //! runtextmacro Struct("Cooldown")
            static Event DESTROY_EVENT
            static EventType ENDING_EVENT_TYPE
            //! runtextmacro GetKey("KEY")
            //! runtextmacro GetKeyArray("KEY_ARRAY")
            //! runtextmacro GetKeyArray("KEY_ARRAY_DETAIL")
            static EventType START_EVENT_TYPE

            Timer durationTimer
            Unit parent
            Spell whichSpell

            method Is takes Spell whichSpell returns boolean
                return (whichSpell.Data.Integer.Get(KEY_ARRAY_DETAIL + this) != NULL)
            endmethod

            static method Ending_TriggerEvents takes Unit parent, Spell whichSpell returns nothing
                local integer iteration = EventPriority.ALL_COUNT
                local integer iteration2
                local EventPriority priority
                local Event whichEvent

                loop
                    exitwhen (iteration < ARRAY_MIN)

                    set priority = EventPriority.ALL[iteration]

                    set iteration2 = parent.Event.Count(thistype.ENDING_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        set whichEvent = parent.Event.Get(thistype.ENDING_EVENT_TYPE, priority, iteration2)
                        call Event.SetSubjectId(parent.Id.Get())
                        call SPELL.Event.SetTrigger(whichSpell)
                        call UNIT.Event.SetTrigger(parent)

                        call Event.SetTrigger(whichEvent)

                        call whichEvent.Run()

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration2 = whichSpell.Event.Count(thistype.ENDING_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        set whichEvent = whichSpell.Event.Get(thistype.ENDING_EVENT_TYPE, priority, iteration2)
                        call Event.SetSubjectId(whichSpell.Id.Get())
                        call SPELL.Event.SetTrigger(whichSpell)
                        call UNIT.Event.SetTrigger(parent)

                        call Event.SetTrigger(whichEvent)

                        call whichEvent.Run()

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration = iteration - 1
                endloop
            endmethod

            method Ending takes Timer durationTimer, Unit parent, Spell whichSpell returns nothing
                call this.deallocate()
                call durationTimer.Destroy()
                if (parent.Data.Integer.Table.Remove(KEY_ARRAY, this)) then
                    call parent.Event.Remove(DESTROY_EVENT)
                endif
                call parent.Data.Integer.Remove(KEY_ARRAY_DETAIL + whichSpell)
                if (whichSpell.Data.Integer.Table.Remove(KEY_ARRAY, this)) then
                    //call whichSpell.Event.Remove(COOLDOWN_EVENT)
                endif
                call whichSpell.Data.Integer.Remove(KEY_ARRAY_DETAIL + parent)

                call thistype.Ending_TriggerEvents(parent, whichSpell)
            endmethod

            method EndingByParent takes Spell whichSpell returns nothing
                local integer level
                local Unit parent = this
                local integer whichSpellSelf = whichSpell.self

                set this = parent.Data.Integer.Get(KEY_ARRAY_DETAIL + whichSpell)

                if (this == NULL) then
                    return
                endif

                set level = parent.Abilities.GetLevel(whichSpell)

                call parent.Abilities.RemoveBySelf(whichSpellSelf)
                call parent.Abilities.AddBySelf(whichSpellSelf)
                call parent.Abilities.SetLevelBySelf(whichSpellSelf, level)

                call this.Ending(this.durationTimer, parent, whichSpell)
            endmethod

            static method EndingByTimer takes nothing returns nothing
                local Timer durationTimer = Timer.GetExpired()

                local thistype this = durationTimer.GetData()

                call this.Ending(durationTimer, this.parent, this.whichSpell)
            endmethod

            static method Event_Destroy takes nothing returns nothing
                local Unit parent = UNIT.Event.GetTrigger()
                local thistype this

                local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

                loop
                    set this = parent.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                    call this.Ending(this.durationTimer, parent, this.whichSpell)

                    set iteration = iteration - 1
                    exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
                endloop
            endmethod

            static method Start_TriggerEvents takes Unit parent, Spell whichSpell returns nothing
                local integer iteration = EventPriority.ALL_COUNT
                local integer iteration2
                local EventPriority priority
                local Event whichEvent

                loop
                    exitwhen (iteration < ARRAY_MIN)

                    set priority = EventPriority.ALL[iteration]

                    set iteration2 = parent.Event.Count(thistype.START_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        set whichEvent = parent.Event.Get(thistype.START_EVENT_TYPE, priority, iteration2)
                        call Event.SetSubjectId(parent.Id.Get())
                        call SPELL.Event.SetTrigger(whichSpell)
                        call UNIT.Event.SetTrigger(parent)

                        call Event.SetTrigger(whichEvent)

                        call whichEvent.Run()

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration2 = whichSpell.Event.Count(thistype.START_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        set whichEvent = whichSpell.Event.Get(thistype.START_EVENT_TYPE, priority, iteration2)
                        call Event.SetSubjectId(whichSpell.Id.Get())
                        call SPELL.Event.SetTrigger(whichSpell)
                        call UNIT.Event.SetTrigger(parent)

                        call Event.SetTrigger(whichEvent)

                        call whichEvent.Run()

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration = iteration - 1
                endloop
            endmethod

            method StartEx takes Spell whichSpell returns nothing
                local Timer durationTimer
                local Unit parent = this

                local real duration = whichSpell.GetCooldown(parent.Abilities.GetLevel(whichSpell))

                if (duration == 0.) then
                    return
                endif

                set durationTimer = Timer.Create()
                set this = thistype.allocate()

                set this.durationTimer = durationTimer
                set this.parent = parent
                set this.whichSpell = whichSpell
                call durationTimer.SetData(this)
                if (parent.Data.Integer.Table.Add(KEY_ARRAY, this)) then
                    call parent.Event.Add(DESTROY_EVENT)
                endif
                call parent.Data.Integer.Set(KEY_ARRAY_DETAIL + whichSpell, this)
                if (whichSpell.Data.Integer.Table.Add(KEY_ARRAY, this)) then
                    //call whichSpell.Event.Add(COOLDOWN_EVENT)
                endif
                call whichSpell.Data.Integer.Set(KEY_ARRAY_DETAIL + parent, this)

                call durationTimer.Start(duration, false, function thistype.EndingByTimer)

                call thistype.Start_TriggerEvents(parent, whichSpell)
            endmethod

            method Start takes Spell whichSpell returns nothing
            endmethod

            static method Init takes nothing returns nothing
                set thistype.DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
                set thistype.ENDING_EVENT_TYPE = EventType.Create()
                set thistype.START_EVENT_TYPE = EventType.Create()
            endmethod
        endstruct

        //! runtextmacro Folder("Events")
            //! runtextmacro Struct("Begin")
                static EventType DUMMY_EVENT_TYPE
                static Group DUMMY_GROUP
                static Trigger DUMMY_TRIGGER

                static method TriggerEvents takes Unit caster, integer level, Unit targetUnit, real targetX, real targetY, Spell whichSpell returns nothing
                    local integer iteration = EventPriority.ALL_COUNT
                    local integer iteration2
                    local EventPriority priority

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        set priority = EventPriority.ALL[iteration]

                        set iteration2 = whichSpell.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call Event.SetSubjectId(whichSpell.Id.Get())
                            call SPELL.Event.SetLevel(level)
                            call SPELL.Event.SetTrigger(whichSpell)
                            call SPOT.Event.SetTargetX(targetX)
                            call SPOT.Event.SetTargetY(targetY)
                            call UNIT.Event.SetTarget(targetUnit)
                            call UNIT.Event.SetTrigger(caster)

                            call whichSpell.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run()

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration2 = caster.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call Event.SetSubjectId(caster.Id.Get())
                            call SPELL.Event.SetLevel(level)
                            call SPELL.Event.SetTrigger(whichSpell)
                            call SPOT.Event.SetTargetX(targetX)
                            call SPOT.Event.SetTargetY(targetY)
                            call UNIT.Event.SetTarget(targetUnit)
                            call UNIT.Event.SetTrigger(caster)

                            call caster.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run()

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration = iteration - 1
                    endloop
                endmethod

                static method TrigConds takes nothing returns boolean
                    if (thistype.DUMMY_GROUP.ContainsUnit(UNIT.Event.Native.GetTrigger()) == false) then
                        return false
                    endif
                    if (SPELL.Event.Native.GetCast() == NULL) then
                        return false
                    endif

                    return true
                endmethod

                static method Trig takes nothing returns nothing
                    local Unit caster = UNIT.Event.Native.GetTrigger()
                    local Unit targetUnit = UNIT.Event.Native.GetSpellTarget()
                    local real targetX = SPOT.Event.Native.GetSpellTargetX()
                    local real targetY = SPOT.Event.Native.GetSpellTargetY()
                    local Spell whichSpell = SPELL.Event.Native.GetCast()

                    local integer level = caster.Abilities.GetLevel(whichSpell)

                    call thistype.TriggerEvents(caster, level, targetUnit, targetX, targetY, whichSpell)
                endmethod

                method Event_Destroy takes nothing returns nothing
                    call thistype.DUMMY_GROUP.RemoveUnit(this)
                endmethod

                method Event_Create takes nothing returns nothing
                    call thistype.DUMMY_GROUP.AddUnit(this)
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.DUMMY_EVENT_TYPE = EventType.Create()
                    set thistype.DUMMY_GROUP = Group.Create()
                    set thistype.DUMMY_TRIGGER = Trigger.CreateFromCode(function thistype.Trig)

                    call thistype.DUMMY_TRIGGER.AddConditions(function thistype.TrigConds)
                    call thistype.DUMMY_TRIGGER.RegisterEvent.PlayerUnit(User.ANY, EVENT_PLAYER_UNIT_SPELL_CAST, null)
                endmethod
            endstruct

            //! runtextmacro Folder("Effect")
                //! runtextmacro Struct("Channeling")
                    static constant real ANIMATION_TIME = 0.05
                    static Timer ANIMATION_TIMER
                    //! runtextmacro GetKeyArray("CASTER_KEY_ARRAY")
                    static Buff DUMMY_BUFF
                    static real DURATION
                    static Event ORDER_EVENT
                    static Event TARGET_DEATH_EVENT
                    static Event TARGET_DESTROY_EVENT
                    static SpellInstance WHICH_INSTANCE

                    //! runtextmacro CreateList("ACTIVE_LIST")
                    //! runtextmacro CreateForEachList("FOR_EACH_LIST", "ACTIVE_LIST")

                    Timer durationTimer
                    boolean running
                    SpellInstance whichInstance

                    method Is takes nothing returns boolean
                        return this.running
                    endmethod

                    static method Animate takes nothing returns nothing
                        local Unit caster
                        local thistype this
                        local SpellInstance whichInstance

                        call thistype.FOR_EACH_LIST_Set()

                        loop
                            set this = thistype.FOR_EACH_LIST_FetchFirst()

                            exitwhen (this == NULL)

                            set caster = this
                            set whichInstance = this.whichInstance

                            call caster.Animation.Queue(whichInstance.GetSpell().GetAnimation())
                            if (whichInstance.GetSpell().GetTargetType() != Spell.TARGET_TYPE_IMMEDIATE) then
                                call caster.Facing.Set(caster.CastAngle(whichInstance.GetCurrentTargetX() - caster.Position.X.Get(), whichInstance.GetCurrentTargetY() - caster.Position.Y.Get()))
                            endif
                        endloop
                    endmethod

                    static method Event_Order takes nothing returns nothing
                        local Unit caster = UNIT.Event.GetTrigger()

                        if (ORDER.Event.GetTrigger() == Order.SMART) then
                            call caster.Buffs.Remove(thistype.DUMMY_BUFF)
                        endif
                    endmethod

                    static method TargetEnding takes Unit target returns nothing
                        local Unit caster
                        local integer iteration = target.Data.Integer.Table.Count(CASTER_KEY_ARRAY)

                        loop
                            set caster = target.Data.Integer.Table.Get(CASTER_KEY_ARRAY, iteration)

                            call caster.Buffs.Remove(thistype.DUMMY_BUFF)

                            set iteration = iteration - 1
                            exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
                        endloop
                    endmethod

                    static method Event_TargetDeath takes nothing returns nothing
                        call thistype.TargetEnding(UNIT.Event.GetTrigger())
                    endmethod

                    static method Event_TargetDestroy takes nothing returns nothing
                        call thistype.TargetEnding(UNIT.Event.GetTrigger())
                    endmethod

                    static method Event_BuffLose takes nothing returns nothing
                        local Unit caster = UNIT.Event.GetTrigger()

                        local thistype this = caster

                        local Timer durationTimer = this.durationTimer
                        local SpellInstance whichInstance = this.whichInstance

                        local boolean completed = (durationTimer.GetRemaining() < 0.1)
                        local Unit target = whichInstance.GetTargetUnit()

                        call durationTimer.Destroy()
                        if (thistype.ACTIVE_LIST_Remove(this)) then
                            call thistype.ANIMATION_TIMER.Pause()
                        endif

                        set this.running = false
                        call caster.Event.Remove(ORDER_EVENT)
                        if (target != NULL) then
                            if (target.Data.Integer.Table.Remove(CASTER_KEY_ARRAY, caster)) then
                                call target.Event.Remove(TARGET_DEATH_EVENT)
                                call target.Event.Remove(TARGET_DESTROY_EVENT)
                            endif
                        endif

                        call caster.Animation.Set(Animation.STAND)
                        call caster.Attack.Add()
                        call caster.Movement.Add()
                        call whichInstance.Refs.Subtract()

                        call UNIT.Abilities.Events.Finish.Start(whichInstance, completed)
                    endmethod

                    static method Event_BuffGain takes nothing returns nothing
                        local Unit caster = UNIT.Event.GetTrigger()
                        local real duration = thistype.DURATION
                        local Timer durationTimer = Timer.Create()
                        local SpellInstance whichInstance = thistype.WHICH_INSTANCE

                        local Unit target = whichInstance.GetTargetUnit()
                        local thistype this = caster

                        set this.durationTimer = durationTimer
                        set this.running = true
                        set this.whichInstance = whichInstance
                        call caster.Event.Add(ORDER_EVENT)
                        if (target != NULL) then
                            if (target.Data.Integer.Table.Add(CASTER_KEY_ARRAY, caster)) then
                                call target.Event.Add(TARGET_DEATH_EVENT)
                                call target.Event.Add(TARGET_DESTROY_EVENT)
                            endif
                        endif

                        call durationTimer.Start(duration + 0.01, false, null)
                        call Unit(this).Animation.Set(Animation.STAND)
                        call Unit(this).Attack.Subtract()
                        call Unit(this).Movement.Subtract()
                        call whichInstance.Refs.Add()

                        if (thistype.ACTIVE_LIST_Add(this)) then
                            call thistype.ANIMATION_TIMER.Start(thistype.ANIMATION_TIME, true, function thistype.Animate)
                        endif
                    endmethod

                    static method Start takes SpellInstance whichInstance returns nothing
                        local real duration = whichInstance.GetSpell().GetChannelTime(whichInstance.GetLevel())

                        if (duration == 0.) then
                            return
                        endif

                        set thistype.DURATION = duration
                        set thistype.WHICH_INSTANCE = whichInstance

                        call whichInstance.GetCaster().Buffs.Timed.Start(thistype.DUMMY_BUFF, 1, duration)
                    endmethod

                    method Event_Create takes nothing returns nothing
                        set this.running = false
                    endmethod

                    static method Init takes nothing returns nothing
                        set thistype.ANIMATION_TIMER = Timer.Create()
                        set thistype.ORDER_EVENT = Event.Create(UNIT.Order.Events.Gain.Immediate.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Order)
                        set thistype.TARGET_DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TargetDeath)
                        set thistype.TARGET_DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TargetDestroy)

                            set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME)

                            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
                            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
                            call thistype.DUMMY_BUFF.SetLostOnDeath(true)
                    endmethod
                endstruct
            endscope

            //! runtextmacro Struct("Effect")
                static EventType DUMMY_EVENT_TYPE
                static Group DUMMY_GROUP
                static Trigger DUMMY_TRIGGER
                //! runtextmacro GetKeyArray("KEY_ARRAY")
                static EventType PRE_EVENT_TYPE
                static Trigger PRE_TRIGGER

                SpellInstance whichInstance

                //! runtextmacro LinkToStruct("Effect", "Channeling")

                static method TriggerEvents takes SpellInstance whichInstance returns nothing
                    local Unit caster = whichInstance.GetCaster()
                    local integer level = whichInstance.GetLevel()
                    local Item targetItem = whichInstance.GetTargetItem()
                    local Unit targetUnit = whichInstance.GetTargetUnit()
                    local real targetX = whichInstance.GetTargetX()
                    local real targetY = whichInstance.GetTargetY()
                    local Spell whichSpell = whichInstance.GetSpell()

                    local integer iteration = EventPriority.ALL_COUNT
                    local integer iteration2
                    local EventPriority priority

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        set priority = EventPriority.ALL[iteration]

                        set iteration2 = caster.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call ITEM.Event.SetTarget(targetItem)
                            call SPELL.Event.SetLevel(level)
                            call SPELL.Event.SetTrigger(whichSpell)
                            call SPOT.Event.SetTargetX(targetX)
                            call SPOT.Event.SetTargetY(targetY)
                            call UNIT.Event.SetTarget(targetUnit)
                            call UNIT.Event.SetTrigger(caster)

                            call caster.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run()

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration2 = whichSpell.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call ITEM.Event.SetTarget(targetItem)
                            call SPELL.Event.SetLevel(level)
                            call SPELL.Event.SetTrigger(whichSpell)
                            call SPOT.Event.SetTargetX(targetX)
                            call SPOT.Event.SetTargetY(targetY)
                            call UNIT.Event.SetTarget(targetUnit)
                            call UNIT.Event.SetTrigger(caster)

                            call whichSpell.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run()

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration = iteration - 1
                    endloop
                endmethod

                static method Start takes SpellInstance whichInstance returns nothing
                    local Unit caster = whichInstance.GetCaster()
                    local integer level = whichInstance.GetLevel()
                    local Unit targetUnit = whichInstance.GetTargetUnit()
                    local Spell whichSpell = whichInstance.GetSpell()

                    local boolean hasTargetUnit = (targetUnit != NULL)
                    local boolean isNotCasterAlly
                    local thistype this = caster

                    call caster.Abilities.Cooldown.StartEx(whichSpell)
                    call caster.Mana.SubtractNoNative(whichSpell.GetManaCost(level))
                    if (hasTargetUnit) then
                        set isNotCasterAlly = (caster.IsAllyOf(targetUnit.Owner.Get()) == false)
                    endif

                    if (caster.Abilities.GetLevelBySelf(Spell.PARALLEL_CAST_BUFF_ID) > 0) then
                        call caster.Buffs.RemoveBySelf(Spell.PARALLEL_CAST_BUFF_ID)
                    endif
                    if (caster.Classes.Contains(UnitClass.HERO)) then
                        call caster.AddJumpingTextTag(String.Color.Do(whichInstance.GetSpell().GetName(), "ff00ffff"), 0.021, TextTag.GetFreeId())
                    endif

                    call thistype.TriggerEvents(whichInstance)

                    if (hasTargetUnit) then
                        if (isNotCasterAlly) then
                            set UNIT.Damage.Events.IGNORE_NEXT = true
                        endif
                    endif

                    call whichInstance.Destroy()

                    set this.whichInstance = NULL
                endmethod

                static method TrigConds takes nothing returns boolean
                    local Unit caster = UNIT.Event.Native.GetTrigger()

                    if (thistype.DUMMY_GROUP.ContainsUnit(caster) == false) then
                        return false
                    endif
                    if (SPELL.Event.Native.GetCast() == NULL) then
                        return false
                    endif

                    return true
                endmethod

                static method Trig takes nothing returns nothing
                    local Unit caster = UNIT.Event.Native.GetTrigger()

                    local SpellInstance whichInstance = thistype(caster).whichInstance

                    if (whichInstance == NULL) then
                        return
                    endif

                    call thistype(NULL).Channeling.Start(whichInstance)

                    call thistype.Start(whichInstance)
                endmethod

                static method PreTriggerEvents takes SpellInstance whichInstance returns nothing
                    local Unit caster = whichInstance.GetCaster()
                    local integer level = whichInstance.GetLevel()
                    local Item targetItem = whichInstance.GetTargetItem()
                    local Unit targetUnit = whichInstance.GetTargetUnit()
                    local real targetX = whichInstance.GetTargetX()
                    local real targetY = whichInstance.GetTargetY()
                    local Spell whichSpell = whichInstance.GetSpell()

                    local integer iteration = EventPriority.ALL_COUNT
                    local integer iteration2
                    local EventPriority priority

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        set priority = EventPriority.ALL[iteration]

                        set iteration2 = caster.Event.Count(thistype.PRE_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call ITEM.Event.SetTarget(targetItem)
                            call SPELL.Event.SetLevel(level)
                            call SPELL.Event.SetTrigger(whichSpell)
                            call SPOT.Event.SetTargetX(targetX)
                            call SPOT.Event.SetTargetY(targetY)
                            call UNIT.Event.SetTarget(targetUnit)
                            call UNIT.Event.SetTrigger(caster)

                            call caster.Event.Get(thistype.PRE_EVENT_TYPE, priority, iteration2).Run()

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration2 = whichSpell.Event.Count(thistype.PRE_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call ITEM.Event.SetTarget(targetItem)
                            call SPELL.Event.SetLevel(level)
                            call SPELL.Event.SetTrigger(whichSpell)
                            call SPOT.Event.SetTargetX(targetX)
                            call SPOT.Event.SetTargetY(targetY)
                            call UNIT.Event.SetTarget(targetUnit)
                            call UNIT.Event.SetTrigger(caster)

                            call whichSpell.Event.Get(thistype.PRE_EVENT_TYPE, priority, iteration2).Run()

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration = iteration - 1
                    endloop
                endmethod

                static method PreTrig takes nothing returns nothing
                    local Unit caster = UNIT.Event.Native.GetTrigger()
                    local integer level
                    local Spell whichSpell = SPELL.Event.Native.GetCast()

                    local Order casterOrder = caster.Order.Get()
                    local thistype this = caster
                    local SpellInstance whichInstance = SpellInstance.Create(caster, whichSpell)

                    call whichInstance.SetTargetItem(ITEM.Event.Native.GetSpellTarget())
                    call whichInstance.SetTargetUnit(UNIT.Event.Native.GetSpellTarget())
                    call whichInstance.SetTargetX(SPOT.Event.Native.GetSpellTargetX())
                    call whichInstance.SetTargetY(SPOT.Event.Native.GetSpellTargetY())

                    if (casterOrder.IsInventoryUse()) then
                        set level = caster.Items.GetFromSlot(casterOrder.GetInventoryIndex()).Abilities.GetLevel(whichSpell)
                    else
                        set level = caster.Abilities.GetLevel(whichSpell)
                    endif

                    set this.whichInstance = whichInstance
                    call thistype.PreTriggerEvents(whichInstance)
                endmethod

                method Event_Destroy takes nothing returns nothing
                    call thistype.DUMMY_GROUP.RemoveUnit(this)
                endmethod

                method Event_Create takes nothing returns nothing
                    set this.whichInstance = NULL
                    call thistype.DUMMY_GROUP.AddUnit(this)

                    call this.Channeling.Event_Create()
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.DUMMY_EVENT_TYPE = EventType.Create()
                    set thistype.DUMMY_GROUP = Group.Create()
                    set thistype.DUMMY_TRIGGER = Trigger.CreateFromCode(function thistype.Trig)
                    set thistype.PRE_EVENT_TYPE = EventType.Create()
                    set thistype.PRE_TRIGGER = Trigger.CreateFromCode(function thistype.PreTrig)

                    call thistype.DUMMY_TRIGGER.AddConditions(function thistype.TrigConds)
                    call thistype.DUMMY_TRIGGER.RegisterEvent.PlayerUnit(User.ANY, EVENT_PLAYER_UNIT_SPELL_ENDCAST, null)
                    call thistype.PRE_TRIGGER.AddConditions(function thistype.TrigConds)
                    call thistype.PRE_TRIGGER.RegisterEvent.PlayerUnit(User.ANY, EVENT_PLAYER_UNIT_SPELL_EFFECT, null)

                    call thistype(NULL).Channeling.Init()
                endmethod
            endstruct

            //! runtextmacro Struct("Finish")
                static EventType DUMMY_EVENT_TYPE

                static method TriggerEvents takes SpellInstance whichInstance, boolean channelComplete returns nothing
                    local Unit caster = whichInstance.GetCaster()
                    local integer level = whichInstance.GetLevel()
                    local Item targetItem = whichInstance.GetTargetItem()
                    local Unit targetUnit = whichInstance.GetTargetUnit()
                    local real targetX = whichInstance.GetTargetX()
                    local real targetY = whichInstance.GetTargetY()
                    local Spell whichSpell = whichInstance.GetSpell()

                    local integer iteration = EventPriority.ALL_COUNT
                    local integer iteration2
                    local EventPriority priority

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        set priority = EventPriority.ALL[iteration]

                        set iteration2 = whichSpell.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call Event.SetSubjectId(whichSpell.Id.Get())
                            call SPELL.Event.SetChannelComplete(channelComplete)
                            call SPELL.Event.SetTrigger(whichSpell)
                            call UNIT.Event.SetTrigger(caster)

                            call whichSpell.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run()

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration2 = caster.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call Event.SetSubjectId(caster.Id.Get())
                            call SPELL.Event.SetChannelComplete(channelComplete)
                            call SPELL.Event.SetTrigger(whichSpell)
                            call UNIT.Event.SetTrigger(caster)

                            call caster.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run()

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration = iteration - 1
                    endloop
                endmethod

                static method Start takes SpellInstance whichInstance, boolean channelComplete returns nothing
                    call thistype.TriggerEvents(whichInstance, channelComplete)
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.DUMMY_EVENT_TYPE = EventType.Create()
                endmethod
            endstruct

            //! runtextmacro Struct("Learn")
                static EventType DUMMY_EVENT_TYPE
                static Group DUMMY_GROUP
                static Trigger DUMMY_TRIGGER

                method TriggerEvents takes integer level, Spell whichSpell returns nothing
                    local integer iteration = EventPriority.ALL_COUNT
                    local integer iteration2
                    local EventPriority priority

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        set priority = EventPriority.ALL[iteration]

                        set iteration2 = whichSpell.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call Event.SetSubjectId(whichSpell.Id.Get())
                            call SPELL.Event.SetLevel(level)
                            call SPELL.Event.SetTrigger(whichSpell)
                            call UNIT.Event.SetTrigger(this)

                            call whichSpell.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run()

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration = iteration - 1
                    endloop
                endmethod

                method Start takes Spell whichSpell returns nothing
                    local integer level = Unit(this).Abilities.GetLevel(whichSpell)

                    call this.TriggerEvents(level, whichSpell)
                endmethod

                static method TrigConds takes Unit parent returns boolean
                    if (thistype.DUMMY_GROUP.ContainsUnit(parent) == false) then
                        return false
                    endif

                    return true
                endmethod

                static method Trig takes nothing returns nothing
                    local Unit parent = UNIT.Event.Native.GetTrigger()

                    if (thistype.TrigConds(parent) == false) then
                        return
                    endif

                    call parent.SkillPoints.UpdateByLearn()

                    call thistype(parent).Start(SPELL.Event.Native.GetLearned())
                endmethod

                method Event_Destroy takes nothing returns nothing
                    call thistype.DUMMY_GROUP.RemoveUnit(this)
                endmethod

                method Event_Create takes nothing returns nothing
                    call thistype.DUMMY_GROUP.AddUnit(this)
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.DUMMY_EVENT_TYPE = EventType.Create()
                    set thistype.DUMMY_GROUP = Group.Create()
                    set thistype.DUMMY_TRIGGER = Trigger.CreateFromCode(function thistype.Trig)

                    call thistype.DUMMY_TRIGGER.RegisterEvent.PlayerUnit(User.ANY, EVENT_PLAYER_HERO_SKILL, null)
                endmethod
            endstruct

            //! runtextmacro Struct("Unlearn")
                static EventType DUMMY_EVENT_TYPE

                method TriggerEvents takes Spell whichSpell returns nothing
                    local integer iteration = EventPriority.ALL_COUNT
                    local integer iteration2
                    local EventPriority priority

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        set priority = EventPriority.ALL[iteration]

                        set iteration2 = whichSpell.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call Event.SetSubjectId(whichSpell.Id.Get())
                            call SPELL.Event.SetTrigger(whichSpell)
                            call UNIT.Event.SetTrigger(this)

                            call whichSpell.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run()

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration = iteration - 1
                    endloop
                endmethod

                method Start takes Spell whichSpell returns nothing
                    call this.TriggerEvents(whichSpell)
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.DUMMY_EVENT_TYPE = EventType.Create()
                endmethod
            endstruct
        endscope

        //! runtextmacro Struct("Events")
            //! runtextmacro LinkToStruct("Events", "Begin")
            //! runtextmacro LinkToStruct("Events", "Effect")
            //! runtextmacro LinkToStruct("Events", "Finish")
            //! runtextmacro LinkToStruct("Events", "Learn")
            //! runtextmacro LinkToStruct("Events", "Unlearn")

            method Event_Destroy takes nothing returns nothing
                call this.Begin.Event_Destroy()
                call this.Effect.Event_Destroy()
                call this.Learn.Event_Destroy()
            endmethod

            method Event_Create takes nothing returns nothing
                call this.Begin.Event_Create()
                call this.Effect.Event_Create()
                call this.Learn.Event_Create()
            endmethod

            static method Init takes nothing returns nothing
                call thistype(NULL).Begin.Init()
                call thistype(NULL).Effect.Init()
                call thistype(NULL).Finish.Init()
                call thistype(NULL).Learn.Init()
                call thistype(NULL).Unlearn.Init()
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Abilities")
        //! runtextmacro GetKeyArray("KEY_ARRAY")
        //! runtextmacro GetKeyArray("LEVEL_KEY_ARRAY_DETAIL")

        //! runtextmacro LinkToStruct("Abilities", "Cooldown")
        //! runtextmacro LinkToStruct("Abilities", "Events")

        method Count takes nothing returns integer
            return Unit(this).Data.Integer.Table.Count(KEY_ARRAY)
        endmethod

        method Get takes integer index returns Spell
            return Unit(this).Data.Integer.Table.Get(KEY_ARRAY, index)
        endmethod

        method GetLevelBySelf takes integer spellSelf returns integer
            return GetUnitAbilityLevel(Unit(this).self, spellSelf)
        endmethod

        method GetLevel takes Spell whichSpell returns integer
            return Unit(this).Data.Integer.Get(LEVEL_KEY_ARRAY_DETAIL + whichSpell)
        endmethod

        method RemoveBySelf takes integer spellSelf returns nothing
            call UnitRemoveAbility(Unit(this).self, spellSelf)
        endmethod

        method AddBySelf takes integer spellSelf returns nothing
        if (Memory.IntegerKeys.Table.ContainsInteger(InitAbilityStruct.KEY_ARRAY, InitAbilityStruct.KEY_ARRAY, spellSelf)==false) then
            call BJDebugMsg("did not preload "+GetObjectName(spellSelf)+";"+I2S(spellSelf))
            call InitAbility(spellSelf)
        endif
            call UnitAddAbility(Unit(this).self, spellSelf)
            call UnitMakeAbilityPermanent(Unit(this).self, true, spellSelf)
        endmethod

        method SetLevelBySelf takes integer spellSelf, integer level returns nothing
            if (level == 0) then
                call this.RemoveBySelf(spellSelf)

                return
            endif

            if (this.GetLevelBySelf(spellSelf) == 0) then
                call this.AddBySelf(spellSelf)
            endif

            call SetUnitAbilityLevel(Unit(this).self, spellSelf, level)
        endmethod

        method Remove takes Spell whichSpell returns nothing
            if (this.GetLevel(whichSpell) == 0) then
                return
            endif

            if (whichSpell.self != 0) then
                call this.RemoveBySelf(whichSpell.self)
            endif

            call Unit(this).Data.Integer.Table.Remove(KEY_ARRAY, whichSpell)
            call Unit(this).Data.Integer.Remove(LEVEL_KEY_ARRAY_DETAIL + whichSpell)

            call this.Events.Unlearn.Start(whichSpell)
        endmethod

        method StartCooldown takes Spell whichSpell returns nothing
            call this.Cooldown.StartEx(whichSpell)
        endmethod

        method AddWithLevel takes Spell whichSpell, integer level returns nothing
            if (whichSpell.self != 0) then
                call this.AddBySelf(whichSpell.self)
            endif

            call Unit(this).Data.Integer.Table.Add(KEY_ARRAY, whichSpell)
            call Unit(this).Data.Integer.Set(LEVEL_KEY_ARRAY_DETAIL + whichSpell, level)

            call this.Events.Learn.Start(whichSpell)
        endmethod

        method Add takes Spell whichSpell returns nothing
            call this.AddWithLevel(whichSpell, 1)
        endmethod

        method SetLevel takes Spell whichSpell, integer level returns nothing
            if (level == 0) then
                call this.Remove(whichSpell)

                return
            endif

            if (this.GetLevel(whichSpell) == 0) then
                call this.Add(whichSpell)
            endif

            call Unit(this).Data.Integer.Set(LEVEL_KEY_ARRAY_DETAIL + whichSpell, level)
            call this.SetLevelBySelf(whichSpell.self, level)
        endmethod

        method AddLevel takes Spell whichSpell, integer value returns nothing
            call this.SetLevel(whichSpell, this.GetLevel(whichSpell) + value)
        endmethod

        method Replace takes Spell oldSpell, Spell newSpell returns nothing
            local integer level = this.GetLevel(oldSpell)

            if (level > 0) then
                call this.Remove(oldSpell)

                call this.SetLevel(newSpell, level)
            endif
        endmethod

        method Refresh takes Spell whichSpell returns nothing
            call this.Cooldown.EndingByParent(whichSpell)
        endmethod

        method RefreshAll takes nothing returns nothing
            local integer iteration = this.Count()

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                call this.Refresh(this.Get(iteration))

                set iteration = iteration - 1
            endloop
        endmethod

        method Clear takes nothing returns nothing
            local integer iteration = this.Count()

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                call this.Remove(this.Get(iteration))

                set iteration = iteration - 1
            endloop
        endmethod

        static method Event_TypeChange takes nothing returns nothing
            local integer iteration
            local UnitType sourceType = UNIT_TYPE.Event.GetSource()
            local UnitType targetType = UNIT_TYPE.Event.GetTrigger()
            local thistype this = UNIT.Event.GetTrigger()
            local Spell whichSpell

            if (Unit(this).Classes.Contains(UnitClass.HERO)) then
                return
            endif

            call this.Clear()

            set iteration = targetType.Abilities.Count()

            loop
                exitwhen (iteration < ARRAY_MIN)

                set whichSpell = targetType.Abilities.Get(iteration)

                call this.AddLevel(whichSpell, targetType.Abilities.GetLevel(whichSpell))

                set iteration = iteration - 1
            endloop
        endmethod

        method Event_Create takes nothing returns nothing
            local Spell whichSpell
            local UnitType thisType = Unit(this).Type.Get()

            local integer iteration = thisType.Abilities.Count()

            loop
                exitwhen (iteration < ARRAY_MIN)

                set whichSpell = thisType.Abilities.Get(iteration)

                call this.AddLevel(whichSpell, thisType.Abilities.GetLevel(whichSpell))

                set iteration = iteration - 1
            endloop

            call this.Events.Event_Create()

            set iteration = thisType.Abilities.Hero.Count()

            loop
                exitwhen (iteration < ARRAY_MIN)

                call HeroSpell.AddToUnit(thisType.Abilities.Hero.Get(iteration), this)

                set iteration = iteration - 1
            endloop
        endmethod

        static method Init takes nothing returns nothing
            call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()

            call thistype(NULL).Cooldown.Init()
            call thistype(NULL).Events.Init()
        endmethod
    endstruct

    //! runtextmacro Struct("Effects")
        method Create takes string modelPath, string attachPoint, EffectLevel level returns UnitEffect
            return UnitEffect.Create(this, modelPath, attachPoint, level)
        endmethod
    endstruct

    //! runtextmacro Struct("Attachments")
        method Add takes string path, string attachPoint, EffectLevel level returns nothing
            call Unit(this).Effects.Create(path, attachPoint, level)
        endmethod

        static method Event_TypeChange takes nothing returns nothing
            local UnitType targetType = UNIT_TYPE.Event.GetTrigger()
            local thistype this = UNIT.Event.GetTrigger()

            local integer iteration = targetType.Attachments.Count()

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                call this.Add(targetType.Attachments.GetPath(iteration), targetType.Attachments.GetAttachPoint(iteration), targetType.Attachments.GetLevel(iteration))

                set iteration = iteration - 1
            endloop
        endmethod

        method Event_Create takes nothing returns nothing
            local UnitType parentType = Unit(this).Type.Get()

            local integer iteration = parentType.Attachments.Count()

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                call this.Add(parentType.Attachments.GetPath(iteration), parentType.Attachments.GetAttachPoint(iteration), parentType.Attachments.GetLevel(iteration))

                set iteration = iteration - 1
            endloop
        endmethod

        static method Init takes nothing returns nothing
            call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
        endmethod
    endstruct

    //! runtextmacro Folder("Buffs")
        //! runtextmacro Folder("Events")
            //! runtextmacro Struct("Gain")
                static EventType DUMMY_EVENT_TYPE

                method TriggerEvents takes Buff whichBuff, integer level returns nothing
                    local integer iteration = EventPriority.ALL_COUNT
                    local integer iteration2
                    local EventPriority priority

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        set priority = EventPriority.ALL[iteration]

                        set iteration2 = whichBuff.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call BUFF.Event.SetLevel(level)
                            call BUFF.Event.SetTrigger(whichBuff)
                            call Event.SetSubjectId(whichBuff.Id.Get())
                            call UNIT.Event.SetTrigger(this)

                            call whichBuff.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run()

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration = iteration - 1
                    endloop
                endmethod

                method Start takes Buff whichBuff, integer level returns nothing
                    call this.TriggerEvents(whichBuff, level)
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.DUMMY_EVENT_TYPE = EventType.Create()
                endmethod
            endstruct

            //! runtextmacro Struct("Lose")
                static EventType DUMMY_EVENT_TYPE

                method TriggerEvents takes Buff whichBuff returns nothing
                    local integer iteration = EventPriority.ALL_COUNT
                    local integer iteration2
                    local EventPriority priority

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        set priority = EventPriority.ALL[iteration]

                        set iteration2 = Unit(this).Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call BUFF.Event.SetTrigger(whichBuff)
                            call Event.SetSubjectId(Unit(this).Id.Get())
                            call UNIT.Event.SetTrigger(this)

                            call Unit(this).Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run()

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration2 = whichBuff.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call BUFF.Event.SetTrigger(whichBuff)
                            call Event.SetSubjectId(whichBuff.Id.Get())
                            call UNIT.Event.SetTrigger(this)

                            call whichBuff.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run()

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration = iteration - 1
                    endloop
                endmethod

                method Start takes Buff whichBuff returns nothing
                    call this.TriggerEvents(whichBuff)
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.DUMMY_EVENT_TYPE = EventType.Create()
                endmethod
            endstruct
        endscope

        //! runtextmacro Struct("Events")
            //! runtextmacro LinkToStruct("Events", "Gain")
            //! runtextmacro LinkToStruct("Events", "Lose")

            static method Init takes nothing returns nothing
                call thistype(NULL).Gain.Init()
                call thistype(NULL).Lose.Init()
            endmethod
        endstruct

        //! runtextmacro Folder("Timed")
            //! runtextmacro Struct("Countdown")
                static Event DEATH_EVENT
                //! runtextmacro GetKey("KEY")
                //! runtextmacro GetKeyArray("KEY_ARRAY")
                //! runtextmacro GetKeyArray("KEY_ARRAY_DETAIL")
                static constant integer SHOW_FROM = 3

                integer count
                Timer countdownTimer
                Timer durationTimer
                boolean firstCount
                Unit parent
                Buff whichBuff

                method Ending takes Timer durationTimer, Unit parent returns nothing
                    local Timer countdownTimer = this.countdownTimer
                    local Buff whichBuff = this.whichBuff

                    call this.deallocate()
                    call countdownTimer.Destroy()
                    call durationTimer.Destroy()
                    if (parent.Data.Integer.Table.Remove(KEY_ARRAY, this)) then
                        call parent.Event.Remove(DEATH_EVENT)
                    endif
                    call parent.Data.Integer.Remove(KEY_ARRAY_DETAIL + whichBuff)
                endmethod

                static method EndingByTimer takes nothing returns nothing
                    local Timer durationTimer = Timer.GetExpired()

                    local thistype this = durationTimer.GetData()

                    call this.Ending(durationTimer, this.parent)
                endmethod

                method EndingByParent takes Buff whichBuff returns nothing
                    local Unit parent = this

                    set this = parent.Data.Integer.Get(KEY_ARRAY_DETAIL + whichBuff)

                    if (this != NULL) then
                        call this.Ending(this.durationTimer, parent)
                    endif
                endmethod

                static method Event_Death takes nothing returns nothing
                    local Unit parent = UNIT.Event.GetTrigger()
                    local thistype this

                    local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

                    loop
                        set this = parent.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                        call this.Ending(this.durationTimer, parent)

                        set iteration = iteration - 1
                        exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
                    endloop
                endmethod

                method Interval takes nothing returns nothing
                    local integer count = this.count
                    local boolean firstCount = this.firstCount

                    if (firstCount) then
                        set this.firstCount = false
                        call this.parent.AddRisingTextTag(String.Color.Do(this.whichBuff.GetName() + " vanishes in " + Char.BREAK + Integer.ToString(count), "ff00ffff"), 0.022, 120., 1., 2., TextTag.GetFreeId())
                    else
                        call this.parent.AddRisingTextTag(String.Color.Do(Integer.ToString(count), "ff00ffff"), 0.022, 120., 1., 2., TextTag.GetFreeId())
                    endif

                    set this.count = count - 1
                endmethod

                static method IntervalByTimer takes nothing returns nothing
                    local thistype this = Timer.GetExpired().GetData()

                    call this.Interval()
                endmethod

                static method StartCountdown takes nothing returns nothing
                    //call Timer.GetExpired().Start(1., true, function thistype.IntervalByTimer)
                endmethod

                method Start takes Buff whichBuff, real duration returns nothing
                    local integer count
                    local real countdownStart
                    local Timer countdownTimer
                    local Timer durationTimer
                    local Unit parent = this

                    set this = parent.Data.Integer.Get(KEY_ARRAY_DETAIL + whichBuff)

                    if (this != NULL) then
                        call this.Ending(this.durationTimer, parent)
                    endif

                    /*if (duration <= thistype.SHOW_FROM) then
                        return
                    endif*/

                    set count = Math.MinI(Real.ToInt(duration), thistype.SHOW_FROM)
                    set countdownTimer = Timer.Create()
                    set durationTimer = Timer.Create()
                    set this = thistype.allocate()

                    set countdownStart = duration - count - 1.

                    set this.count = count
                    set this.countdownTimer = countdownTimer
                    set this.durationTimer = durationTimer
                    set this.firstCount = true
                    set this.parent = parent
                    set this.whichBuff = whichBuff
                    call countdownTimer.SetData(this)
                    call durationTimer.SetData(this)
                    if (parent.Data.Integer.Table.Add(KEY_ARRAY, this)) then
                        call parent.Event.Add(DEATH_EVENT)
                    endif
                    call parent.Data.Integer.Set(KEY_ARRAY_DETAIL + whichBuff, this)

                    call countdownTimer.Start(countdownStart, false, function thistype.StartCountdown)

                    if (countdownStart < 0.) then
                        call this.Interval()
                    endif

                    //call durationTimer.Start(duration - countdownStart - 1.+0.01, false, function thistype.EndingByTimer)
                    call durationTimer.Start(duration - 1+0.01, false, function thistype.EndingByTimer)
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Death)
                endmethod
            endstruct
        endscope

        //! runtextmacro Struct("Timed")
            static Event DEATH_EVENT
            static constant real INFINITE = -1.
            //! runtextmacro GetKey("KEY")
            //! runtextmacro GetKeyArray("KEY_ARRAY")
            //! runtextmacro GetKeyArray("KEY_ARRAY_DETAIL")
            static Event LOSE_EVENT

            //! runtextmacro LinkToStruct("Timed", "Countdown")

            Timer durationTimer
            Unit parent
            Buff whichBuff

            method GetRemainingDuration takes Buff whichBuff returns real
                set this = Unit(this).Data.Integer.Get(KEY_ARRAY_DETAIL + whichBuff)

                if (this == NULL) then
                    return 0.
                endif

                return this.durationTimer.GetRemaining()
            endmethod

            method Ending takes Timer durationTimer, Unit parent, Buff whichBuff returns nothing
                call this.deallocate()
                call durationTimer.Destroy()
                if (parent.Data.Integer.Table.Remove(KEY_ARRAY, this)) then
                    call parent.Event.Remove(DEATH_EVENT)
                    call parent.Event.Remove(LOSE_EVENT)
                endif
                call parent.Data.Integer.Remove(KEY_ARRAY_DETAIL + whichBuff)

                call thistype(parent).Countdown.EndingByParent(whichBuff)
            endmethod

            static method Event_Lose takes nothing returns nothing
                local Unit parent = UNIT.Event.GetTrigger()
                local Buff whichBuff = BUFF.Event.GetTrigger()

                local thistype this = parent.Data.Integer.Get(KEY_ARRAY_DETAIL + whichBuff)

                if (this != NULL) then
                    call this.Ending(this.durationTimer, parent, whichBuff)
                endif
            endmethod

            static method EndingByTimer takes nothing returns nothing
                local Timer durationTimer = Timer.GetExpired()

                local thistype this = durationTimer.GetData()

                local Unit parent = this.parent
                local Buff whichBuff = this.whichBuff

                call this.Ending(durationTimer, parent, whichBuff)

                call parent.Buffs.Subtract(whichBuff)
            endmethod

            method Abort takes Buff whichBuff returns nothing
                local Unit parent = this

                set this = parent.Data.Integer.Get(KEY_ARRAY_DETAIL + whichBuff)

                if (this != NULL) then
                    call this.Ending(this.durationTimer, parent, whichBuff)

                    call parent.Buffs.Subtract(whichBuff)
                endif
            endmethod

            static method Event_Death takes nothing returns nothing
                local Unit parent = UNIT.Event.GetTrigger()
                local thistype this

                local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

                loop
                    set this = parent.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                    call thistype(parent).Abort(this.whichBuff)

                    set iteration = iteration - 1
                    exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
                endloop
            endmethod

            method AddTime takes Buff whichBuff, real duration returns nothing
                local Timer durationTimer
                local Unit parent = this

                set this = parent.Data.Integer.Get(KEY_ARRAY_DETAIL + whichBuff)

                set durationTimer = this.durationTimer
                call thistype(parent).Countdown.EndingByParent(whichBuff)

                set duration = duration + durationTimer.GetRemaining()

                call durationTimer.Start(duration, false, function thistype.EndingByTimer)

                if (whichBuff.IsHidden() == false) then
                    if (parent.Classes.Contains(UnitClass.HERO) or whichBuff.IsShowCountdown()) then
                        call thistype(parent).Countdown.Start(whichBuff, duration)
                    endif
                endif
            endmethod

            method Start takes Buff whichBuff, integer level, real duration returns boolean
                local Timer durationTimer
                local Unit parent = this

                call this.Abort(whichBuff)

                call parent.Buffs.Add(whichBuff, level)

                if (parent.Buffs.Contains(whichBuff) == false) then
                    return false
                endif

                set durationTimer = Timer.Create()
                set this = thistype.allocate()

                set this.durationTimer = durationTimer
                set this.parent = parent
                set this.whichBuff = whichBuff
                call durationTimer.SetData(this)
                if (parent.Data.Integer.Table.Add(KEY_ARRAY, this)) then
                    call parent.Event.Add(DEATH_EVENT)
                    call parent.Event.Add(LOSE_EVENT)
                endif
                call parent.Data.Integer.Set(KEY_ARRAY_DETAIL + whichBuff, this)

                call durationTimer.Start(duration, false, function thistype.EndingByTimer)

                if (whichBuff.IsHidden() == false) then
                    if (duration != thistype.INFINITE) then
                        if (parent.Classes.Contains(UnitClass.HERO) or whichBuff.IsShowCountdown()) then
                            call thistype(parent).Countdown.Start(whichBuff, duration)
                        endif
                    endif
                endif

                return true
            endmethod

            static method Init takes nothing returns nothing
                set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Death)
                set thistype.LOSE_EVENT = Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Lose)

                call thistype(NULL).Countdown.Init()
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Buffs")
        static Event DEATH_EVENT
        static Event DESTROY_EVENT
        static constant string DISPEL_EFFECT_ATTACH_POINT = AttachPoint.ORIGIN
        static constant string DISPEL_EFFECT_PATH = "Abilities\\Spells\\Human\\DispelMagic\\DispelMagicTarget.mdl"
        //! runtextmacro GetKeyArray("EFFECTS_KEY_ARRAY")
        static constant real INFINITE_DURATION = -1.
        //! runtextmacro GetKeyArray("KEY_ARRAY")
        //! runtextmacro GetKeyArray("KEY_ARRAY_DETAIL")
        //! runtextmacro GetKeyArray("LEVELS_KEY_ARRAY_DETAIL")

        //! runtextmacro LinkToStruct("Buffs", "Events")
        //! runtextmacro LinkToStruct("Buffs", "Timed")

        method Contains takes Buff whichBuff returns boolean
            return Unit(this).Data.Integer.Contains(KEY_ARRAY_DETAIL + whichBuff)
        endmethod

        method Count takes nothing returns integer
            return Unit(this).Data.Integer.Table.Count(KEY_ARRAY)
        endmethod

        method Get takes integer index returns Buff
            return Unit(this).Data.Integer.Table.Get(KEY_ARRAY, index)
        endmethod

        method GetRemainingDuration takes Buff whichBuff returns real
            local real result

            if (this.Contains(whichBuff) == false) then
                return 0.
            endif

            set result = this.Timed.GetRemainingDuration(whichBuff)

            if (result == 0.) then
                return thistype.INFINITE_DURATION
            endif

            return result
        endmethod

        method CountVisible takes nothing returns integer
            local integer iteration = this.Count()
            local integer result = Memory.IntegerKeys.Table.EMPTY

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                if (this.Get(iteration).IsHidden() == false) then
                    set result = result + 1
                endif

                set iteration = iteration - 1
            endloop

            return result
        endmethod

        method CountVisibleEx takes boolean negative, boolean positive returns integer
            local boolean isPositive
            local integer iteration = this.Count()
            local integer result = Memory.IntegerKeys.Table.EMPTY
            local Buff whichBuff

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                set whichBuff = this.Get(iteration)

                if (whichBuff.IsHidden() == false) then
                    set isPositive = whichBuff.IsPositive()

                    if ((negative and (isPositive == false)) or (positive and isPositive)) then
                        set result = result + 1
                    endif
                endif

                set iteration = iteration - 1
            endloop

            return result
        endmethod

        method GetVisible takes integer index returns Buff
            local integer count = this.Count()
            local Buff current
            local integer found = Memory.IntegerKeys.Table.EMPTY
            local integer iteration = Memory.IntegerKeys.Table.STARTED

            loop
                exitwhen (iteration > count)

                set current = this.Get(iteration)

                if (current.IsHidden() == false) then
                    set found = found + 1

                    if (found == index) then
                        return current
                    endif
                endif

                set iteration = iteration + 1
            endloop

            return NULL
        endmethod

        method GetLevel takes Buff whichBuff returns integer
            return Unit(this).Data.Integer.Get(LEVELS_KEY_ARRAY_DETAIL + whichBuff)
        endmethod

        method Dispel takes boolean negative, boolean positive, boolean useUI returns nothing
            local integer iteration = this.Count()
            local Buff whichBuff

            if (useUI) then
                call Unit(this).Effects.Create(thistype.DISPEL_EFFECT_PATH, thistype.DISPEL_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()
            endif

            loop
                set whichBuff = this.Get(iteration)

                if (whichBuff.IsLostOnDispel()) then
                    if (whichBuff.IsPositive()) then
                        if (positive) then
                            call this.Remove(whichBuff)
                        endif
                    else
                        if (negative) then
                            call this.Remove(whichBuff)
                        endif
                    endif
                endif

                set iteration = iteration - 1
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
            endloop

            //call this.Dispel_TriggerEvents(negative, positive)
        endmethod

        method RemoveBySelf takes integer buffId returns nothing
            call Unit(this).Abilities.RemoveBySelf(buffId)
        endmethod

        method RemoveBasic takes Buff whichBuff returns nothing
            local integer dummySpellId = whichBuff.GetDummySpellId()
            local integer iteration
            local integer tableKey = Memory.IntegerKeys.Table.GetId(this) + whichBuff
            local UnitEffect whichEffect

            if (dummySpellId != 0) then
                call Unit(this).Abilities.RemoveBySelf(dummySpellId)
                call Unit(this).Abilities.RemoveBySelf(whichBuff.self)
            endif
            call Unit(this).Data.Integer.Remove(KEY_ARRAY_DETAIL + whichBuff)
            call Unit(this).Data.Integer.Remove(LEVELS_KEY_ARRAY_DETAIL + whichBuff)

            if (Unit(this).Data.Integer.Table.Remove(KEY_ARRAY, whichBuff)) then
                call Unit(this).Event.Remove(DEATH_EVENT)
                call Unit(this).Event.Remove(DESTROY_EVENT)
            endif

            set iteration = Memory.IntegerKeys.Table.CountIntegers(tableKey, EFFECTS_KEY_ARRAY)

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                set whichEffect = Memory.IntegerKeys.Table.GetInteger(tableKey, EFFECTS_KEY_ARRAY, iteration)

                call Memory.IntegerKeys.Table.RemoveInteger(tableKey, EFFECTS_KEY_ARRAY, whichEffect)

                call whichEffect.Destroy()

                set iteration = iteration - 1
            endloop

            call this.Events.Lose.Start(whichBuff)
        endmethod

        method Remove takes Buff whichBuff returns nothing
            if (this.Contains(whichBuff)) then
                call this.RemoveBasic(whichBuff)
            endif
        endmethod

        method Subtract takes Buff whichBuff returns nothing
            if (this.Contains(whichBuff) == false) then
                return
            endif

            if (Unit(this).Data.Integer.Subtract(KEY_ARRAY_DETAIL + whichBuff, 1)) then
                call this.RemoveBasic(whichBuff)
            endif
        endmethod

        method Add takes Buff whichBuff, integer level returns boolean
            local integer dummySpellId
            local integer iteration

            if (Unit(this).IsDestroyed()) then
                return false
            endif

            if (whichBuff.IsLostOnDeath() and Unit(this).Classes.Contains(UnitClass.DEAD)) then
                return false
            endif

            if (Unit(this).Data.Integer.Add(KEY_ARRAY_DETAIL + whichBuff, 1) == false) then
                return false
            endif

            set dummySpellId = whichBuff.GetDummySpellId()

            if (Unit(this).Data.Integer.Table.Add(KEY_ARRAY, whichBuff)) then
                call Unit(this).Event.Add(DEATH_EVENT)
                call Unit(this).Event.Add(DESTROY_EVENT)
            endif
            call Unit(this).Data.Integer.Set(LEVELS_KEY_ARRAY_DETAIL + whichBuff, level)

            if (dummySpellId != 0) then
                call Unit(this).Abilities.AddBySelf(dummySpellId)

                call Unit(this).Abilities.SetLevelBySelf(dummySpellId, level)
            endif

            set iteration = whichBuff.TargetEffects.Count()

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                call Memory.IntegerKeys.Table.AddInteger(Memory.IntegerKeys.Table.GetId(this) + whichBuff, EFFECTS_KEY_ARRAY, Unit(this).Effects.Create(whichBuff.TargetEffects.GetPath(iteration), whichBuff.TargetEffects.GetAttachPoint(iteration), whichBuff.TargetEffects.GetLevel(iteration)))

                set iteration = iteration - 1
            endloop

            call this.Events.Gain.Start(whichBuff, level)

            return true
        endmethod

        method AddFresh takes Buff whichBuff, integer level returns boolean
            if (this.Contains(whichBuff)) then
                call this.Remove(whichBuff)
            endif

            return this.Add(whichBuff, level)
        endmethod

        method AddWithDuration takes Buff whichBuff, integer level, real duration returns boolean
            if (duration == thistype.INFINITE_DURATION) then
                return this.Add(whichBuff, level)
            endif

            return this.Timed.Start(whichBuff, level, duration)
        endmethod

        method Steal takes Unit target, boolean negative, boolean positive, integer level returns nothing
            local integer count = ARRAY_EMPTY
            local Buff current
            local real array duration
            local thistype targetThis = target
            local Buff array temp

            local integer iteration = targetThis.Count()

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                set current = targetThis.Get(iteration)

                if ((current.IsHidden() == false) and ((current.IsPositive() and positive) or ((current.IsPositive() == false) and negative)) and (target.Buffs.GetLevel(current) <= level)) then
                    set count = count + 1

                    set duration[count] = target.Buffs.GetRemainingDuration(current)
                    set temp[count] = current
                    call target.Buffs.Remove(current)
                endif

                set iteration = iteration - 1
            endloop

            loop
                exitwhen (count < ARRAY_MIN)

                call this.AddWithDuration(temp[count], level, duration[count])

                set count = count - 1
            endloop
        endmethod

        static method Event_Death takes nothing returns nothing
            local thistype this = UNIT.Event.GetTrigger()
            local Buff whichBuff

            local integer iteration = this.Count()

            loop
                set whichBuff = this.Get(iteration)

                if (whichBuff.IsLostOnDeath()) then
                    call this.Remove(whichBuff)
                endif

                set iteration = iteration - 1
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
            endloop
        endmethod

        static method Event_Destroy takes nothing returns nothing
            local thistype this = UNIT.Event.GetTrigger()
            local Buff whichBuff

            local integer iteration = this.Count()

            loop
                set whichBuff = this.Get(iteration)

                call this.Remove(whichBuff)

                set iteration = iteration - 1
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
            endloop
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Death)
            set thistype.DESTROY_EVENT = Event.Create(UNIT.DESTROY_EVENT_TYPE, EventPriority.HEADER_TOP, function thistype.Event_Destroy)

            call thistype(NULL).Events.Init()

            call thistype(NULL).Timed.Init()
        endmethod
    endstruct

    //! runtextmacro Folder("Items")
        //! runtextmacro Folder("Events")
            //! runtextmacro Struct("Gain")
                static EventType DUMMY_EVENT_TYPE
                static Group DUMMY_GROUP
                static Trigger DUMMY_TRIGGER
                static boolean IGNORE_NEXT = false

                method TriggerEvents takes Item whichItem, integer whichSlot returns nothing
                    local integer iteration = EventPriority.ALL_COUNT
                    local integer iteration2
                    local EventPriority priority
                    local ItemType whichItemType = whichItem.Type.Get()

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        set priority = EventPriority.ALL[iteration]

                        set iteration2 = whichItemType.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call Event.SetSubjectId(whichItemType.Id.Get())
                            call ITEM.Event.SetTrigger(whichItem)
                            call ITEM.Event.SetTriggerSlot(whichSlot)
                            call ITEM_TYPE.Event.SetTrigger(whichItemType)
                            call UNIT.Event.SetTrigger(this)

                            call whichItemType.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run()

                            if (Unit(this).Items.Contains(whichItem) == false) then
                                return
                            endif

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration2 = Unit(this).Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call Event.SetSubjectId(Unit(this).Id.Get())
                            call ITEM.Event.SetTrigger(whichItem)
                            call ITEM.Event.SetTriggerSlot(whichSlot)
                            call ITEM_TYPE.Event.SetTrigger(whichItemType)
                            call UNIT.Event.SetTrigger(this)

                            call Unit(this).Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run()

                            if (Unit(this).Items.Contains(whichItem) == false) then
                                return
                            endif

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration = iteration - 1
                    endloop
                endmethod

                static method TrigConds takes Unit parent returns boolean
                    if (thistype.DUMMY_GROUP.ContainsUnit(parent) == false) then
                        return false
                    endif

                    return true
                endmethod

                static method Trig takes nothing returns nothing
                    local Item whichItem
                    local integer whichSlot
                    local Unit parent = UNIT.Event.Native.GetTrigger()

                    if (thistype.TrigConds(parent) == false) then
                        return
                    endif

                    if (thistype.IGNORE_NEXT) then
                        set thistype.IGNORE_NEXT = false

                        return
                    endif

                    set whichItem = ITEM.Event.Native.GetTrigger()

                    if (whichItem == NULL) then
                        return
                    endif

                    if (whichItem.Classes.Contains(ItemClass.POWER_UP)) then
                        call parent.Items.Events.Use.StartByPowerUp(whichItem)

                        return
                    endif

                    set whichSlot = parent.Items.AddOnlySave(whichItem)

                    call thistype(parent).TriggerEvents(whichItem, whichSlot)
                endmethod

                method Event_Destroy takes nothing returns nothing
                    call thistype.DUMMY_GROUP.RemoveUnit(this)
                endmethod

                method Event_Create takes nothing returns nothing
                    call thistype.DUMMY_GROUP.AddUnit(this)
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.DUMMY_EVENT_TYPE = EventType.Create()
                    set thistype.DUMMY_GROUP = Group.Create()
                    set thistype.DUMMY_TRIGGER = Trigger.CreateFromCode(function thistype.Trig)

                    call thistype.DUMMY_TRIGGER.RegisterEvent.PlayerUnit(User.ANY, EVENT_PLAYER_UNIT_PICKUP_ITEM, null)
                endmethod
            endstruct

            //! runtextmacro Struct("Lose")
                static EventType DUMMY_EVENT_TYPE
                static Group DUMMY_GROUP
                static Trigger DUMMY_TRIGGER
                static boolean IGNORE_NEXT = false

                method TriggerEvents takes Item whichItem, integer whichSlot returns nothing
                    local integer iteration = EventPriority.ALL_COUNT
                    local integer iteration2
                    local EventPriority priority
                    local ItemType whichItemType = whichItem.Type.Get()

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        set priority = EventPriority.ALL[iteration]

                        set iteration2 = whichItemType.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call Event.SetSubjectId(whichItemType.Id.Get())
                            call ITEM.Event.SetTrigger(whichItem)
                            call ITEM.Event.SetTriggerSlot(whichSlot)
                            call ITEM_TYPE.Event.SetTrigger(whichItemType)
                            call UNIT.Event.SetTrigger(this)

                            call whichItemType.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run()

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration2 = Unit(this).Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call Event.SetSubjectId(Unit(this).Id.Get())
                            call ITEM.Event.SetTrigger(whichItem)
                            call ITEM.Event.SetTriggerSlot(whichSlot)
                            call ITEM_TYPE.Event.SetTrigger(whichItemType)
                            call UNIT.Event.SetTrigger(this)

                            call Unit(this).Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run()

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration = iteration - 1
                    endloop
                endmethod

                static method TrigConds takes Unit parent returns boolean
                    if (thistype.DUMMY_GROUP.ContainsUnit(parent) == false) then
                        return false
                    endif

                    return true
                endmethod

                static method Trig takes nothing returns nothing
                    local Item whichItem
                    local integer whichSlot
                    local Unit parent = UNIT.Event.Native.GetTrigger()

                    if (thistype.TrigConds(parent) == false) then
                        return
                    endif

                    if (thistype.IGNORE_NEXT) then
                        set thistype.IGNORE_NEXT = false

                        return
                    endif

                    set whichItem = ITEM.Event.Native.GetTrigger()

                    if (whichItem == NULL) then
                        return
                    endif

                    set whichSlot = parent.Items.RemoveOnlySave(whichItem)

                    call thistype(parent).TriggerEvents(whichItem, whichSlot)
                endmethod

                method Event_Destroy takes nothing returns nothing
                    call thistype.DUMMY_GROUP.RemoveUnit(this)
                endmethod

                method Event_Create takes nothing returns nothing
                    call thistype.DUMMY_GROUP.AddUnit(this)
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.DUMMY_EVENT_TYPE = EventType.Create()
                    set thistype.DUMMY_GROUP = Group.Create()
                    set thistype.DUMMY_TRIGGER = Trigger.CreateFromCode(function thistype.Trig)

                    call thistype.DUMMY_TRIGGER.RegisterEvent.PlayerUnit(User.ANY, EVENT_PLAYER_UNIT_DROP_ITEM, null)
                endmethod
            endstruct

            //! runtextmacro Struct("MoveInInventory")
                static EventType DUMMY_EVENT_TYPE
                //! runtextmacro GetKey("KEY")
                static Event ORDER_EVENT

                static method TriggerEvents takes Item whichItem, integer whichSlot, Item targetItem, integer targetSlot, Unit whichUnit returns nothing
                    local integer iteration = EventPriority.ALL_COUNT
                    local integer iteration2
                    local integer priority

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        set priority = EventPriority.ALL[iteration]

                        set iteration2 = whichUnit.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call Event.SetSubjectId(whichUnit.Id.Get())
                            call ITEM.Event.SetTarget(targetItem)
                            call ITEM.Event.SetTrigger(whichItem)
                            call ITEM.Event.SetTargetSlot(targetSlot)
                            call ITEM.Event.SetTriggerSlot(whichSlot)
                            call UNIT.Event.SetTrigger(whichUnit)

                            call whichUnit.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run()

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration = iteration - 1
                    endloop
                endmethod

                static method Event_Order takes nothing returns nothing
                    local Item sourceItem = ITEM.Event.GetTarget()
                    local integer targetSlot = ORDER.Event.GetTrigger().Data.Integer.Get(KEY)
                    local Unit whichUnit = UNIT.Event.GetTrigger()

                    local integer sourceSlot = whichUnit.Items.GetSlot(sourceItem)
                    local Item targetItem = whichUnit.Items.GetFromSlot(targetSlot)

                    call whichUnit.Items.SetSlotOnlySave(sourceItem, targetSlot)
                    if (targetItem != NULL) then
                        call whichUnit.Items.SetSlotOnlySave(targetItem, sourceSlot)
                    endif

                    call thistype.TriggerEvents(sourceItem, sourceSlot, targetItem, targetSlot, whichUnit)
                endmethod

                static method Create takes Order whichOrder, integer slot returns nothing
                    call whichOrder.Data.Integer.Set(KEY, slot)
                    call whichOrder.Event.Add(ORDER_EVENT)
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.DUMMY_EVENT_TYPE = EventType.Create()
                    set ORDER_EVENT = Event.Create(UNIT.Order.Events.Gain.Target.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Order)

                    call thistype.Create(Order.MOVE_ITEM_TO_SLOT_0, 0)
                    call thistype.Create(Order.MOVE_ITEM_TO_SLOT_1, 1)
                    call thistype.Create(Order.MOVE_ITEM_TO_SLOT_2, 2)
                    call thistype.Create(Order.MOVE_ITEM_TO_SLOT_3, 3)
                    call thistype.Create(Order.MOVE_ITEM_TO_SLOT_4, 4)
                    call thistype.Create(Order.MOVE_ITEM_TO_SLOT_5, 5)
                endmethod
            endstruct

            //! runtextmacro Struct("Sell")
                static EventType DUMMY_EVENT_TYPE
                static Group DUMMY_GROUP
                static Trigger DUMMY_TRIGGER

                method TriggerEvents takes Unit purchaser, Item whichItem returns nothing
                    local integer iteration = EventPriority.ALL_COUNT
                    local integer iteration2
                    local EventPriority priority
                    local ItemType whichItemType = whichItem.Type.Get()

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        set priority = EventPriority.ALL[iteration]

                        set iteration2 = whichItemType.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call Event.SetSubjectId(whichItemType.Id.Get())
                            call ITEM.Event.SetTrigger(whichItem)
                            call ITEM_TYPE.Event.SetTrigger(whichItemType)
                            call UNIT.Event.SetTarget(purchaser)
                            call UNIT.Event.SetTrigger(this)

                            call whichItemType.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run()

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration = iteration - 1
                    endloop
                endmethod

                static method TrigConds takes Unit parent returns boolean
                    if (thistype.DUMMY_GROUP.ContainsUnit(parent) == false) then
                        return false
                    endif

                    return true
                endmethod

                static method Trig takes nothing returns nothing
                    local Unit purchaser
                    local Unit shop = UNIT.Event.Native.GetTrigger()
                    local Item whichItem

                    if (thistype.TrigConds(shop) == false) then
                        return
                    endif

                    set purchaser = UNIT.Event.Native.GetPurchaser()
                    set whichItem = Item.CreateFromSelf(GetSoldItem())

                    call purchaser.Effects.Create("Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl", AttachPoint.ORIGIN, EffectLevel.NORMAL).Destroy()

                    call thistype(shop).TriggerEvents(purchaser, whichItem)
                endmethod

                method Event_Destroy takes nothing returns nothing
                    call thistype.DUMMY_GROUP.RemoveUnit(this)
                endmethod

                method Event_Create takes nothing returns nothing
                    call thistype.DUMMY_GROUP.AddUnit(this)
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.DUMMY_EVENT_TYPE = EventType.Create()
                    set thistype.DUMMY_GROUP = Group.Create()
                    set thistype.DUMMY_TRIGGER = Trigger.CreateFromCode(function thistype.Trig)

                    call thistype.DUMMY_TRIGGER.RegisterEvent.PlayerUnit(User.ANY, EVENT_PLAYER_UNIT_SELL_ITEM, null)
                endmethod
            endstruct

            //! runtextmacro Struct("Use")
                static EventType DUMMY_EVENT_TYPE
                static Group DUMMY_GROUP
                static Trigger DUMMY_TRIGGER
                static boolean IGNORE_NEXT = false
                static Buff SCROLL_COOLDOWN_BUFF

                method TriggerEvents takes Item whichItem returns nothing
                    local integer iteration = EventPriority.ALL_COUNT
                    local integer iteration2
                    local EventPriority priority
                    local ItemType whichItemType = whichItem.Type.Get()

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        set priority = EventPriority.ALL[iteration]

                        set iteration2 = whichItemType.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call Event.SetSubjectId(whichItemType.Id.Get())
                            call ITEM.Event.SetTrigger(whichItem)
                            call ITEM_TYPE.Event.SetTrigger(whichItemType)
                            call UNIT.Event.SetTrigger(this)

                            call whichItemType.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run()

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration = iteration - 1
                    endloop
                endmethod

                static method TrigConds takes Unit parent returns boolean
                    if (thistype.DUMMY_GROUP.ContainsUnit(parent) == false) then
                        return false
                    endif

                    return true
                endmethod

                method Start takes Item whichItem returns nothing
                    local boolean isScroll = whichItem.Classes.Contains(ItemClass.SCROLL)

                    if ((isScroll == false) or (Unit(this).Buffs.Contains(thistype.SCROLL_COOLDOWN_BUFF) == false)) then
                        call this.TriggerEvents(whichItem)
                    endif

                    if (isScroll) then
                        call Unit(this).Buffs.Timed.Start(thistype.SCROLL_COOLDOWN_BUFF, 1, 0.01)
                        call whichItem.ChargesAmount.Update()
                    elseif (whichItem.Classes.Contains(ItemClass.POWER_UP)) then
                        call whichItem.Destroy()
                    else
                        if (whichItem.ChargesAmount.Get() > 0) then
                            call whichItem.ChargesAmount.Subtract(1)
                        endif
                    endif
                endmethod

                method TriggerSpells_Enum takes Item whichItem, Spell whichSpell, integer level, Unit targetUnit, real targetX, real targetY returns nothing
                    local integer iteration = EventPriority.ALL_COUNT
                    local integer iteration2
                    local EventPriority priority

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        set priority = EventPriority.ALL[iteration]

                        set iteration2 = whichSpell.Event.Count(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call Event.SetSubjectId(whichSpell.Id.Get())
                            call ITEM.Event.SetTrigger(whichItem)
                            call SPELL.Event.SetLevel(level)
                            call SPELL.Event.SetTrigger(whichSpell)
                            call SPOT.Event.SetTargetX(targetX)
                            call SPOT.Event.SetTargetY(targetY)
                            call UNIT.Event.SetTarget(targetUnit)
                            call UNIT.Event.SetTrigger(this)

                            call whichSpell.Event.Get(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, priority, iteration2).Run()

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration = iteration - 1
                    endloop
                endmethod

                method TriggerSpells takes Item whichItem returns nothing
                    local integer iteration = whichItem.Abilities.Count()
                    local integer level
                    local Spell whichSpell

                    loop
                        exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                        set whichSpell = whichItem.Abilities.Get(iteration)

                        set level = whichItem.Abilities.GetLevel(whichSpell)

                        call this.TriggerSpells_Enum(whichItem, whichSpell, level, NULL, 0., 0.)

                        set iteration = iteration - 1
                    endloop
                endmethod

                method StartByPowerUp takes Item whichItem returns nothing
                    call this.TriggerSpells(whichItem)

                    call this.Start(whichItem)
                endmethod

                static method Trig takes nothing returns nothing
                    local integer level
                    local Unit parent = UNIT.Event.Native.GetTrigger()
                    local Item whichItem

                    if (thistype.TrigConds(parent) == false) then
                        return
                    endif

                    set whichItem = ITEM.Event.Native.GetTrigger()

                    call thistype(parent).Start(whichItem)
                endmethod

                method Event_Destroy takes nothing returns nothing
                    call thistype.DUMMY_GROUP.RemoveUnit(this)
                endmethod

                method Event_Create takes nothing returns nothing
                    call thistype.DUMMY_GROUP.AddUnit(this)
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.DUMMY_EVENT_TYPE = EventType.Create()
                    set thistype.DUMMY_GROUP = Group.Create()
                    set thistype.DUMMY_TRIGGER = Trigger.CreateFromCode(function thistype.Trig)
                    set thistype.SCROLL_COOLDOWN_BUFF = Buff.CreateHidden(thistype.NAME)

                    call thistype.DUMMY_TRIGGER.RegisterEvent.PlayerUnit(User.ANY, EVENT_PLAYER_UNIT_USE_ITEM, null)
                endmethod
            endstruct
        endscope

        //! runtextmacro Struct("Events")
            //! runtextmacro LinkToStruct("Events", "Gain")
            //! runtextmacro LinkToStruct("Events", "Lose")
            //! runtextmacro LinkToStruct("Events", "MoveInInventory")
            //! runtextmacro LinkToStruct("Events", "Sell")
            //! runtextmacro LinkToStruct("Events", "Use")

            method Event_Destroy takes nothing returns nothing
                call this.Gain.Event_Destroy()
                call this.Lose.Event_Destroy()
                call this.Sell.Event_Destroy()
                call this.Use.Event_Destroy()
            endmethod

            method Event_Create takes nothing returns nothing
                call this.Gain.Event_Create()
                call this.Lose.Event_Create()
                call this.Sell.Event_Create()
                call this.Use.Event_Create()
            endmethod

            static method Init takes nothing returns nothing
                call thistype(NULL).Gain.Init()
                call thistype(NULL).Lose.Init()
                call thistype(NULL).MoveInInventory.Init()
                call thistype(NULL).Sell.Init()
                call thistype(NULL).Use.Init()
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Items")
        //! runtextmacro GetKeyArray("KEY_ARRAY_DETAIL")
        //! runtextmacro GetKeyArray("SLOT_KEY_ARRAY_DETAIL")

        //! runtextmacro LinkToStruct("Items", "Events")

        method GetFromSlot takes integer slot returns Item
            return Unit(this).Data.Integer.Get(KEY_ARRAY_DETAIL + slot)
        endmethod

        method GetInventorySize takes nothing returns integer
            return UnitInventorySize(Unit(this).self)
        endmethod

        method GetFirstFreeIndex takes nothing returns integer
            local integer inventorySize = this.GetInventorySize() - 1
            local integer iteration = 0

            loop
                exitwhen (iteration > inventorySize)

                if (this.GetFromSlot(iteration) == NULL) then
                    return iteration
                endif

                set iteration = iteration + 1
            endloop

            return -1
        endmethod

        method GetFirstOfType takes ItemType whichType returns Item
            local integer inventorySize = this.GetInventorySize() - 1
            local integer iteration = 0
            local Item thisItem

            loop
                exitwhen (iteration > inventorySize)

                set thisItem = this.GetFromSlot(iteration)

                if (thisItem.Type.Get() == whichType) then
                    return thisItem
                endif

                set iteration = iteration + 1
            endloop

            return NULL
        endmethod

        method GetSlot takes Item whichItem returns integer
            local integer result = Unit(this).Data.Integer.Get(SLOT_KEY_ARRAY_DETAIL + whichItem)

            if (result == HASH_TABLE.Integer.DEFAULT_VALUE) then
                return -1
            endif

            return (result - HASH_TABLE.Integer.DEFAULT_VALUE - 1)
        endmethod

        method Contains takes Item whichItem returns boolean
            return (this.GetSlot(whichItem) != -1)
        endmethod

        method RemoveOnlySave takes Item whichItem returns integer
            local integer whichSlot

            if (whichItem.Classes.Contains(ItemClass.POWER_UP) == false) then
                set whichSlot = this.GetSlot(whichItem)

                call Unit(this).Data.Integer.Remove(KEY_ARRAY_DETAIL + whichSlot)
                call Unit(this).Data.Integer.Remove(SLOT_KEY_ARRAY_DETAIL + whichItem)
                call whichItem.SetSlot(-1)

                return whichSlot
            endif

            return -1
        endmethod

        method Remove takes Item whichItem returns nothing
            call this.RemoveOnlySave(whichItem)

            call whichItem.Position.Set(Unit(this).Position.X.Get(), Unit(this).Position.Y.Get())
        endmethod

        method SetSlotOnlySave takes Item whichItem, integer slot returns nothing
            call Unit(this).Data.Integer.Remove(KEY_ARRAY_DETAIL + this.GetSlot(whichItem))
            call Unit(this).Data.Integer.Remove(SLOT_KEY_ARRAY_DETAIL + whichItem)

            call Unit(this).Data.Integer.Set(KEY_ARRAY_DETAIL + slot, whichItem)
            call Unit(this).Data.Integer.Set(SLOT_KEY_ARRAY_DETAIL + whichItem, HASH_TABLE.Integer.DEFAULT_VALUE + 1 + slot)
            call whichItem.SetSlot(slot)
        endmethod

        method SetSlot takes Item whichItem, integer slot returns nothing
            call this.SetSlotOnlySave(whichItem, slot)

            call UnitDropItemSlot(Unit(this).self, whichItem.self, slot)
        endmethod

        method AddOnlySave takes Item whichItem returns integer
            local integer whichSlot

            if (whichItem.Classes.Contains(ItemClass.POWER_UP)) then
                return -1
            endif

            set whichSlot = this.GetFirstFreeIndex()

            call Unit(this).Data.Integer.Set(KEY_ARRAY_DETAIL + whichSlot, whichItem)
            call Unit(this).Data.Integer.Set(SLOT_KEY_ARRAY_DETAIL + whichItem, HASH_TABLE.Integer.DEFAULT_VALUE + 1 + whichSlot)
            call whichItem.SetSlot(whichSlot)

            return whichSlot
        endmethod

        method Add takes Item whichItem returns nothing
            call UnitAddItem(Unit(this).self, whichItem.self)
        endmethod

        method AddPowerup takes nothing returns nothing
        endmethod

        method Create takes ItemType whichType, boolean test returns nothing
            call this.Add(Item.Create(whichType, Unit(this).Position.X.Get(), Unit(this).Position.Y.Get()))
        endmethod

        method Event_Create takes nothing returns nothing
            local integer iteration = this.GetInventorySize() - 1

            loop
                exitwhen (iteration < 0)

                //set this.slots[iteration] = NULL

                set iteration = iteration - 1
            endloop

            call this.Events.Event_Create()
        endmethod

        static method Init takes nothing returns nothing
            call thistype(NULL).Events.Init()
        endmethod
    endstruct

    //! runtextmacro Struct("Classes")
        //! runtextmacro GetKey("KEY")

        Group dummyGroup

        method Contains takes UnitClass whichType returns boolean
            return thistype(whichType.Data.Integer.Get(KEY)).dummyGroup.ContainsUnit(this)
        endmethod

        method IsNative takes unittype whichUnitType returns boolean
            return IsUnitType(Unit(this).self, whichUnitType)
        endmethod

        method Remove takes UnitClass whichType returns nothing
            call thistype(whichType.Data.Integer.Get(KEY)).dummyGroup.RemoveUnit(this)
        endmethod

        method RemoveNative takes unittype whichUnitType returns nothing
            call UnitRemoveType(Unit(this).self, whichUnitType)
        endmethod

        method Clear takes nothing returns nothing
            local integer iteration = UnitClass.ALL_COUNT

            loop
                exitwhen (iteration < ARRAY_MIN)

                call this.Remove(UnitClass.ALL[iteration])

                set iteration = iteration - 1
            endloop
        endmethod

        method Add takes UnitClass whichType returns nothing
            call thistype(whichType.Data.Integer.Get(KEY)).dummyGroup.AddUnit(this)
        endmethod

        method AddIllusion takes nothing returns nothing
            local integer iteration = Unit(this).Abilities.Count()

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                call Unit(this).Abilities.Remove(Unit(this).Abilities.Get(iteration))

                set iteration = iteration - 1
            endloop
            call this.Add(UnitClass.ILLUSION)
        endmethod

        method AddNative takes unittype whichUnitType returns nothing
            call UnitAddType(Unit(this).self, whichUnitType)
        endmethod

        static method Event_TypeChange takes nothing returns nothing
            local UnitType targetType = UNIT_TYPE.Event.GetTrigger()
            local thistype this = UNIT.Event.GetTrigger()

            local integer iteration = targetType.Classes.Count()

            call this.Clear()

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                call this.Add(targetType.Classes.Get(iteration))

                set iteration = iteration - 1
            endloop
        endmethod

        method Event_Create takes nothing returns nothing
            local UnitType thisType = Unit(this).Type.Get()

            local integer iteration = thisType.Classes.Count()

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                call this.Add(thisType.Classes.Get(iteration))

                set iteration = iteration - 1
            endloop
        endmethod

        static method Create takes UnitClass whichClass returns thistype
            local thistype this = thistype.allocate()

            set this.dummyGroup = Group.Create()
            call whichClass.Data.Integer.Set(KEY, this)

            return this
        endmethod

        static method Init takes nothing returns nothing
            local integer iteration = UnitClass.ALL_COUNT

            call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
            loop
                exitwhen (iteration < ARRAY_MIN)

                call thistype.Create(UnitClass.ALL[iteration])

                set iteration = iteration - 1
            endloop
        endmethod
    endstruct

    //! runtextmacro Struct("Type")
        static EventType DUMMY_EVENT_TYPE

        UnitType value

        //! textmacro Unit_Type_CreateChangerAbility takes doExternal, var, raw, sourceType, targetType
            static integer $var$ = '$raw$'

            /*$doExternal$//! externalblock extension=lua ObjectMerger $FILENAME$
                //! i function set(field, value)
                    //! i makechange(current, field, value)
                //! i end

                //! i function setl(field, level, value)
                    //! i makechange(current, field, level, value)
                //! i end

                //! i setobjecttype("abilities")

                //! i createobject("Abrf", "$raw$")

                //! i set("anam", "Unit Type Changer Ability")
                //! i set("ansf", "($sourceType$ to $targetType$)")
                //! i set("areq", "")

                //! i setl("Emeu", 1, "$sourceType$")
                //! i setl("Eme1", 1, "$targetType$")
            $doExternal$//! endexternalblock*/
        //! endtextmacro

        method Get takes nothing returns UnitType
            return this.value
        endmethod

        method TriggerEvents takes UnitType sourceType, UnitType targetType returns nothing
            local integer iteration = EventPriority.ALL_COUNT
            local integer iteration2
            local EventPriority priority

            loop
                exitwhen (iteration < ARRAY_MIN)

                set priority = EventPriority.ALL[iteration]

                set iteration2 = Event.CountAtStatics(thistype.DUMMY_EVENT_TYPE, priority)

                loop
                    exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                    call UNIT.Event.SetTrigger(this)
                    call UNIT_TYPE.Event.SetSource(sourceType)
                    call UNIT_TYPE.Event.SetTrigger(targetType)

                    call Event.GetFromStatics(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run()

                    set iteration2 = iteration2 - 1
                endloop

                set iteration = iteration - 1
            endloop
        endmethod

        method Set takes UnitType targetType returns nothing
            local UnitType sourceType = this.Get()

            set this.value = targetType

            if ((sourceType == NULL) or (sourceType == targetType)) then
                return
            endif

            call this.TriggerEvents(sourceType, targetType)
        endmethod

        method SetWithChangerAbility takes UnitType targetType, integer abil returns nothing
            call Unit(this).Abilities.AddBySelf(abil)

            call Unit(this).Abilities.RemoveBySelf(abil)

            call this.Set(targetType)
        endmethod

        static method UpgradeFinishTrig takes nothing returns nothing
            local thistype this = Unit.GetFromSelf(GetTriggerUnit())

            call this.Set(UnitType.GetFromSelf(GetUnitTypeId(GetTriggerUnit())))
        endmethod

        method Event_Create takes nothing returns nothing
            set this.value = UnitType.GetFromSelf(GetUnitTypeId(Unit(this).self))
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DUMMY_EVENT_TYPE = EventType.Create()
            call Trigger.CreateFromCode(function thistype.UpgradeFinishTrig).RegisterEvent.PlayerUnit(User.ANY, EVENT_PLAYER_UNIT_UPGRADE_FINISH, null)
        endmethod
    endstruct

    //! textmacro CreateSimpleUnitTimedAction takes actionFunction
        Timer durationTimer
        Unit whichUnit

        private static method Ending takes Timer durationTimer, Unit parent returns nothing
            local thistype this = durationTimer.GetData()

            call this.deallocate()
            call durationTimer.Destroy()
            call parent.Data.Integer.Remove(KEY)
        endmethod

        static method CancelByParent takes Unit parent returns nothing
            local thistype this = parent.Data.Integer.Get(KEY)

            call this.Ending(this.durationTimer, parent)
        endmethod

        private static method EndingByTimer takes nothing returns nothing
            local Timer durationTimer = Timer.GetExpired()

            local thistype this = durationTimer.GetData()

            local Unit parent = this.parent

            call this.Ending(durationTimer, parent)

            call parent.$actionFunction$()
        endmethod

        method Start takes real timeOut returns nothing
            local Timer durationTimer = Timer.Create()
            local Unit parent = this

            set this = thistype.allocate()
            set this.durationTimer = durationTimer
            set this.parent = parent
            call durationTimer.SetData(this)
            call parent.Data.Integer.Set(KEY, this)

            call durationTimer.Start(timeOut, false, function thistype.EndingByTimer)
        endmethod
    //! endtextmacro

    //! textmacro Unit_CreateStateWithPermanentAbilities takes name, factor, waitForSelection
        static constant boolean WAIT_FOR_SELECTION = $waitForSelection$

        real displayedValue
        real value

        method Get takes nothing returns real
            return this.value
        endmethod

        static if ($waitForSelection$) then
            static Event SELECTION_EVENT

            boolean waitForSelection

            method UpdateDisplay takes real value, real oldValue returns nothing
                set this.displayedValue = value
                call BJUnit.$name$.Set(Unit(this).self, value, oldValue)
            endmethod

            static method Event_Selection takes nothing returns nothing
                local Unit parent = UNIT.Event.GetTrigger()

                local thistype this = parent

                set this.waitForSelection = false
                call parent.Event.Remove(SELECTION_EVENT)

                call this.UpdateDisplay(this.Get() $factor$, this.displayedValue)
            endmethod

            method Set takes real value returns nothing
                local real displayedValue = this.displayedValue

                set this.value = value

                set value = value $factor$

                if (value == displayedValue) then
                    if (waitForSelection) then
                        set this.waitForSelection = false
                        call Unit(this).Event.Remove(SELECTION_EVENT)
                    endif
                else
                    if (Unit(this).Selection.Count() > Memory.IntegerKeys.Table.EMPTY) then
                        call this.UpdateDisplay(value, displayedValue)
                    else
                        set this.waitForSelection = true
                        call Unit(this).Event.Add(SELECTION_EVENT)
                    endif
                endif
            endmethod
        else
            method Set takes real value returns nothing
                local real oldDisplayedValue = this.displayedValue

                set this.value = value

                set value = value $factor$

                set this.displayedValue = value
                call BJUnit.$name$.Set(Unit(this).self, value, oldDisplayedValue)
            endmethod
        endif

        method Add takes real value returns nothing
            call this.Set(this.Get() + value)
        endmethod

        method AddOnlySave takes real value returns nothing
            set this.value = this.Get() + value
        endmethod

        method Event_Create takes nothing returns nothing
            set this.displayedValue = 0.
            set this.value = 0.
            static if ($waitForSelection$) then
                set this.waitForSelection = false
            endif
        endmethod

        method Subtract takes real value returns nothing
            call this.Set(this.Get() - value)
        endmethod

        method Update takes nothing returns nothing
            call this.Set(this.Get())
        endmethod
    //! endtextmacro

    //! runtextmacro Struct("Color")
        //! runtextmacro CreateSimpleAddState_OnlyGet("playercolor")

        method Set takes playercolor value returns nothing
            set this.value = value
            call SetUnitColor(Unit(this).self, value)
        endmethod
    endstruct

    //! runtextmacro Struct("Owner")
        static EventType DUMMY_EVENT_TYPE

        User owner

        method Get takes nothing returns User
            return this.owner
        endmethod

        method TriggerEvents takes nothing returns nothing
            local integer iteration = EventPriority.ALL_COUNT
            local integer iteration2
            local EventPriority priority

            loop
                exitwhen (iteration < ARRAY_MIN)

                set priority = EventPriority.ALL[iteration]

                set iteration2 = Unit(this).Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                loop
                    exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                    call Event.SetSubjectId(Unit(this).Id.Get())
                    call UNIT.Event.SetTrigger(this)

                    call Unit(this).Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run()

                    set iteration2 = iteration2 - 1
                endloop

                set iteration = iteration - 1
            endloop
        endmethod

        method Set takes User value returns nothing
            local User oldValue = this.Get()

            set this.owner = value
            call SetUnitOwner(Unit(this).self, value.self, true)

            call Unit(this).Color.Set(value.GetColor())

            if (value == oldValue) then
                return
            endif

            call this.TriggerEvents()
        endmethod

        method Event_Create takes User value returns nothing
            set this.owner = value

            call Unit(this).Color.Set(value.GetColor())
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DUMMY_EVENT_TYPE = EventType.Create()
        endmethod
    endstruct

    //! runtextmacro Folder("Armor")
        //! runtextmacro Struct("Bonus")
            //! runtextmacro Unit_CreateStateWithPermanentAbilities("Armor.Bonus", "+ Unit(this).Armor.Get() * (Unit(this).Armor.Relative.Get() - 1.)", "true")

            static method Init takes nothing returns nothing
                static if (thistype.WAIT_FOR_SELECTION) then
                    set SELECTION_EVENT = Event.Create(UNIT.Selection.START_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Selection)
                endif
            endmethod
        endstruct

        //! runtextmacro Folder("IgnoreDamage")
            //! runtextmacro Struct("Relative")
                //! runtextmacro CreateSimpleAddState("real", "0.")
            endstruct
        endscope

        //! runtextmacro Struct("IgnoreDamage")
            //! runtextmacro LinkToStruct("IgnoreDamage", "Relative")

            //! runtextmacro CreateSimpleAddState_NotStart("real")

            method Event_Create takes nothing returns nothing
                call this.Relative.Event_Create()
            endmethod
        endstruct

        //! runtextmacro Folder("Relative")
            //! runtextmacro Struct("Invisible")
                //! runtextmacro CreateSimpleAddState("real", "1.")
            endstruct
        endscope

        //! runtextmacro Struct("Relative")
            //! runtextmacro LinkToStruct("Relative", "Invisible")

            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).Armor.Bonus.Update()
            endmethod

            method Add takes real value returns nothing
                call this.Set(this.Get() + value)
            endmethod

            method Event_Create takes nothing returns nothing
                call this.Set(1.)

                call Invisible.Event_Create()
            endmethod

            method Subtract takes real value returns nothing
                call this.Set(this.Get() - value)
            endmethod
        endstruct

        //! runtextmacro Struct("Spell")
            //! runtextmacro CreateSimpleAddState("real", "0.")
        endstruct

        //! runtextmacro Struct("TypeA")
            //! runtextmacro CreateSimpleAddState("integer", "Unit(this).Type.Get().Armor.Type.Get()")

            static method Event_TypeChange takes nothing returns nothing
                local UnitType targetType = UNIT_TYPE.Event.GetTrigger()
                local thistype this = UNIT.Event.GetTrigger()

                call this.Set(targetType.Armor.Type.Get())
            endmethod

            static method Init takes nothing returns nothing
                call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Armor")
        //! runtextmacro LinkToStruct("Armor", "Bonus")
        //! runtextmacro LinkToStruct("Armor", "IgnoreDamage")
        //! runtextmacro LinkToStruct("Armor", "Relative")
        //! runtextmacro LinkToStruct("Armor", "Spell")
        //! runtextmacro LinkToStruct("Armor", "TypeA")

        //! runtextmacro CreateSimpleAddState_OnlyGet("real")

        method GetAll takes nothing returns real
            return (this.Get() * this.Relative.Get() * this.Relative.Invisible.Get() + this.Bonus.Get())
        endmethod

        static method GetDamageFactor takes real value returns real
            if (value < 0.) then
                return (2. - Math.Power((1. - Attack.ARMOR_REDUCTION_FACTOR), -value))
            endif

            return (1. / (1. + Attack.ARMOR_REDUCTION_FACTOR * value))
        endmethod

        method GetVisibleAll takes nothing returns real
            return (this.Get() * this.Relative.Get() + this.Bonus.Get())
        endmethod

        method GetVisibleBonus takes nothing returns real
            return this.GetVisibleAll() - this.Get()
        endmethod

        method Set takes real value returns nothing
            set this.value = value

            call this.Bonus.Update()
        endmethod

        method Add takes real value returns nothing
            call this.Set(this.Get() + value)
        endmethod

        static method Event_TypeChange takes nothing returns nothing
            local UnitType sourceType = UNIT_TYPE.Event.GetSource()
            local UnitType targetType = UNIT_TYPE.Event.GetTrigger()
            local thistype this = UNIT.Event.GetTrigger()

            call this.Add(targetType.Armor.Get() - sourceType.Armor.Get())
        endmethod

        method Event_Create takes nothing returns nothing
            set this.value = Unit(this).Type.Get().Armor.Get()

            call this.Bonus.Event_Create()
            call this.IgnoreDamage.Event_Create()
            call this.Relative.Event_Create()
            call this.Spell.Event_Create()
            call this.TypeA.Event_Create()
        endmethod

        static method Init takes nothing returns nothing
            call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()

            call thistype(NULL).Bonus.Init()
            call thistype(NULL).TypeA.Init()
        endmethod
    endstruct

    //! runtextmacro Folder("Attack")
        //! runtextmacro Folder("Events")
            //! runtextmacro Struct("Acquire2")
                static Event DESTROY_EVENT
                static EventType DUMMY_EVENT_TYPE

                Timer delayTimer
                boolean running
                Unit target

                method Ending takes Timer delayTimer, Unit parent returns nothing
                    local Unit target = this.target

                    call delayTimer.Destroy()

                    set this.running = false

                    call target.Refs.Subtract()
                endmethod

                static method Event_Destroy takes nothing returns nothing
                    local Unit parent = UNIT.Event.GetTrigger()

                    local thistype this = parent

                    call parent.Event.Remove(DESTROY_EVENT)

                    if (this.running) then
                        call this.Ending(this.delayTimer, parent)
                    endif
                endmethod

                method TriggerEvents takes Unit target returns nothing
                    local integer iteration = EventPriority.ALL_COUNT
                    local integer iteration2
                    local EventPriority priority

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        set priority = EventPriority.ALL[iteration]

                        set iteration2 = Unit(this).Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call Event.SetSubjectId(Unit(this).Id.Get())
                            call UNIT.Event.SetTrigger(this)
                            call UNIT.Event.SetTarget(target)

                            call Unit(this).Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run()

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration = iteration - 1
                    endloop
                endmethod

                static method EndingByTimer takes nothing returns nothing
                    local Timer delayTimer = Timer.GetExpired()

                    local thistype this = delayTimer.GetData()

                    call this.Ending(delayTimer, this)

                    call this.TriggerEvents(target)
                endmethod

                method Start takes Unit target returns nothing
                    local Timer delayTimer = Timer.Create()

                    if (this.running) then
                        call this.Ending(this.delayTimer, this)
                    endif

                    set this.delayTimer = delayTimer
                    set this.running = true
                    set this.target = target
                    call delayTimer.SetData(this)

                    call target.Refs.Add()

                    call delayTimer.Start(0.01, false, function thistype.EndingByTimer)
                endmethod

                method Event_Create takes nothing returns nothing
                    set this.running = false
                    call Unit(this).Event.Add(DESTROY_EVENT)
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
                    set thistype.DUMMY_EVENT_TYPE = EventType.Create()
                endmethod
            endstruct

            //! runtextmacro Struct("Ground")
                static Event ATTACK_EVENT
                static Trigger DAMAGE_TRIGGER
                static Event DESTROY_EVENT
                static EventType DUMMY_EVENT_TYPE
                static Event DUMMY_UNIT_DESTROY_EVENT
                static constant real DURATION_TOLERANCE = 2.
                static Group ENUM_GROUP
                static Group ENUM_GROUP2
                //! runtextmacro GetKey("KEY")
                //! runtextmacro GetKeyArray("KEY_ARRAY")
                static constant real MAX_DURATION = 30.
                static BoolExpr TARGET_FILTER

                Unit parent

                static method Event_Destroy takes nothing returns nothing
                    local Unit parent = UNIT.Event.GetTrigger()

                    call parent.Event.Remove(ATTACK_EVENT)
                    call parent.Event.Remove(DESTROY_EVENT)
                endmethod

                method Ending takes DummyUnit dummyUnit, Unit parent returns nothing
                    call dummyUnit.Data.Integer.Remove(KEY)
                    call dummyUnit.Event.Remove(DUMMY_UNIT_DESTROY_EVENT)
                    call parent.Data.Integer.Table.Remove(KEY_ARRAY, this)

                    call parent.Refs.Subtract()
                endmethod

                static method Event_DummyUnitDestroy takes nothing returns nothing
                    local DummyUnit dummyUnit = DUMMY_UNIT.Event.GetTrigger()

                    local thistype this = dummyUnit.Data.Integer.Get(KEY)

                    call this.Ending(dummyUnit, this.parent)
                endmethod

                method DealPhysical_Single takes Unit target, real amount, integer whichType returns nothing
                    set amount = amount * (1. - target.Armor.IgnoreDamage.Relative.Get())

                    set amount = amount * UNIT.Armor.GetDamageFactor(target.Armor.GetAll())

                    set amount = amount * Attack.Get(whichType, target.Armor.TypeA.Get())

                    call Unit(this).DamageUnit(target, amount, false)
                endmethod

                static method Conditions takes nothing returns boolean
                    local Unit target = UNIT.Event.Native.GetFilter()

                    if (thistype.ENUM_GROUP2.ContainsUnit(target)) then
                        return false
                    endif

                    if ((TEMP_BOOLEAN == false) and target.IsAllyOf(User.TEMP)) then
                        return false
                    endif

                    if (target.Classes.Contains(UnitClass.DEAD)) then
                        return false
                    endif
                    if (target.Classes.Contains(UnitClass.GROUND) == false) then
                        return false
                    endif

                    return true
                endmethod

                method DealPhysical takes real x, real y returns nothing
                    local boolean affectsAlly = Unit(this).Attack.Splash.TargetFlag.Is(TargetFlag.ALLY)
                    local real damageAmount = Unit(this).Damage.Get() + Unit(this).Damage.Bonus.Get()
                    local integer damageSides = Unit(this).Damage.Sides.Get()
                    local integer damageType = Unit(this).Damage.TypeA.Get()
                    local integer iteration = Unit(this).Damage.Dices.Get()
                    local integer iterationEnd = Unit(this).Attack.Splash.Count()
                    local User parentOwner = Unit(this).Owner.Get()
                    local real rangeDamageAmount
                    local Unit target

                    loop
                        exitwhen (iteration < 1)

                        set damageAmount = damageAmount + Math.RandomI(1, damageSides)

                        set iteration = iteration - 1
                    endloop

                    set damageAmount = damageAmount * Unit(this).Damage.Relative.Get() * Unit(this).Damage.Relative.Invisible.Get()
                    set iteration = Memory.IntegerKeys.Table.STARTED

                    loop
                        set TEMP_BOOLEAN = affectsAlly
                        set User.TEMP = parentOwner

                        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, Unit(this).Attack.Splash.GetAreaRange(iteration), thistype.TARGET_FILTER)

                        set target = thistype.ENUM_GROUP.FetchFirst()

                        if (target != NULL) then
                            set rangeDamageAmount = damageAmount * Unit(this).Attack.Splash.GetDamageFactor(iteration)

                            loop
                                call thistype.ENUM_GROUP2.AddUnit(target)

                                call this.DealPhysical_Single(target, rangeDamageAmount, damageType)

                                set target = thistype.ENUM_GROUP.FetchFirst()
                                exitwhen (target == NULL)
                            endloop
                        endif

                        set iteration = iteration + 1
                        exitwhen (iteration > iterationEnd)
                    endloop

                    call thistype.ENUM_GROUP2.Clear()
                endmethod

                method TriggerEvents takes real x, real y returns nothing
                    local integer iteration = EventPriority.ALL_COUNT
                    local integer iteration2
                    local EventPriority priority

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        set priority = EventPriority.ALL[iteration]

                        set iteration2 = Unit(this).Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call Event.SetSubjectId(Unit(this).Id.Get())
                            call SPOT.Event.SetTargetX(x)
                            call SPOT.Event.SetTargetY(y)
                            call UNIT.Event.SetTrigger(this)

                            call Unit(this).Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run()

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration = iteration - 1
                    endloop

                    call this.DealPhysical(x, y)
                endmethod

                static method DamageTrig takes nothing returns nothing
                    local DummyUnit dummyUnit = DUMMY_UNIT.Event.Native.GetTrigger()
                    local Unit parent = UNIT.Event.Native.GetDamager()
                    local real x
                    local real y

                    local thistype this = dummyUnit.Data.Integer.Get(KEY)

                    if (parent == this.parent) then
                        set x = dummyUnit.Position.X.Get()
                        set y = dummyUnit.Position.Y.Get()

                        call this.Ending(dummyUnit, parent)

                        call thistype(parent).TriggerEvents(x, y)
                    endif
                endmethod

                static method Event_Attack takes nothing returns nothing
                    local Unit target = UNIT.Event.GetTarget()
                    local thistype this = thistype.allocate()
                    local Unit parent = UNIT.Event.GetTrigger()

                    local real targetX = target.Position.X.Get()
                    local real targetY = target.Position.Y.Get()

                    local DummyUnit dummyUnit = DummyUnit.Create(DUMMY_UNIT_ID, targetX, targetY, 0., 0.)

                    set this.parent = parent
                    call DAMAGE_TRIGGER.RegisterEvent.DummyUnit(dummyUnit, EVENT_UNIT_DAMAGED)
                    call dummyUnit.Data.Integer.Set(KEY, this)
                    call dummyUnit.Event.Add(DUMMY_UNIT_DESTROY_EVENT)
                    call parent.Data.Integer.Table.Add(KEY_ARRAY, this)
                    call parent.Refs.Add()

                    call dummyUnit.DestroyTimed.Start(Math.DistanceByDeltas(targetX - parent.Position.X.Get(), targetY - parent.Position.Y.Get()) / parent.Attack.Missile.Speed.Get() + DURATION_TOLERANCE)
                endmethod

                static method Event_TypeChange takes nothing returns nothing
                    local Unit parent = UNIT.Event.GetTrigger()
                    local UnitType sourceType = UNIT_TYPE.Event.GetSource()
                    local UnitType targetType = UNIT_TYPE.Event.GetTrigger()

                    local boolean hasArtillery = (targetType.Attack.Get() == Attack.ARTILLERY)

                    if ((sourceType.Attack.Get() == Attack.ARTILLERY) == hasArtillery) then
                        return
                    endif

                    if (hasArtillery) then
                        call parent.Event.Add(ATTACK_EVENT)
                        call parent.Event.Add(DESTROY_EVENT)
                    else
                        call parent.Event.Remove(ATTACK_EVENT)
                        call parent.Event.Remove(DESTROY_EVENT)
                    endif
                endmethod

                static method Event_Create takes nothing returns nothing
                    local Unit parent = UNIT.Event.GetTrigger()

                    if (parent.Type.Get().Attack.Get() == Attack.ARTILLERY) then
                        call parent.Event.Add(ATTACK_EVENT)
                        call parent.Event.Add(DESTROY_EVENT)
                    endif
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.DAMAGE_TRIGGER = Trigger.CreateFromCode(function thistype.DamageTrig)
                    set thistype.ATTACK_EVENT = Event.Create(UNIT.Attack.Events.DUMMY_EVENT_TYPE, EventPriority.EVENTS, function thistype.Event_Attack)
                    set thistype.DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.EVENTS, function thistype.Event_Destroy)
                    set thistype.DUMMY_EVENT_TYPE = EventType.Create()
                    set thistype.DUMMY_UNIT_DESTROY_EVENT = Event.Create(DummyUnit.DESTROY_EVENT_TYPE, EventPriority.EVENTS, function thistype.Event_DummyUnitDestroy)
                    set thistype.ENUM_GROUP = Group.Create()
                    set thistype.ENUM_GROUP2 = Group.Create()
                    set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
                    call Event.Create(Unit.CREATE_EVENT_TYPE, EventPriority.EVENTS, function thistype.Event_Create).AddToStatics()
                    call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
                endmethod
            endstruct
        endscope

        //! runtextmacro Struct("Events")
            static EventType ACQUIRE_EVENT_TYPE
            static Trigger ACQUIRE_TRIGGER

            static EventType DUMMY_EVENT_TYPE
            static Trigger DUMMY_TRIGGER

            static EventType OFFENDED_EVENT_TYPE
            static Group OFFENDED_GROUP
            static EventType OFFENDED_REVERSED_EVENT_TYPE
            static Trigger OFFENDED_TRIGGER

            //! runtextmacro LinkToStruct("Events", "Acquire2")
            //! runtextmacro LinkToStruct("Events", "Ground")

            method TriggerEvents takes Unit target returns nothing
                local integer iteration = EventPriority.ALL_COUNT
                local integer iteration2
                local EventPriority priority
                local UnitType parentType = Unit(this).Type.Get()

                loop
                    exitwhen (iteration < ARRAY_MIN)

                    set priority = EventPriority.ALL[iteration]

                    set iteration2 = Unit(this).Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        call Event.SetSubjectId(Unit(this).Id.Get())
                        call UNIT.Event.SetTrigger(this)
                        call UNIT.Event.SetTarget(target)

                        call Unit(this).Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run()

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration2 = parentType.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        call Event.SetSubjectId(parentType.Id.Get())
                        call UNIT.Event.SetTrigger(this)
                        call UNIT.Event.SetTarget(target)

                        call parentType.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run()

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration = iteration - 1
                endloop
            endmethod

            static method Trig takes nothing returns nothing
                local Unit parent = UNIT.Event.Native.GetTrigger()
                local Unit target = UNIT.Event.Native.GetAcquiredTarget()

                call thistype(parent).TriggerEvents(target)
            endmethod

            method Acquire_TriggerEvents takes Unit target returns nothing
                local integer iteration = EventPriority.ALL_COUNT
                local integer iteration2
                local EventPriority priority
                local UnitType parentType = Unit(this).Type.Get()

                loop
                    exitwhen (iteration < ARRAY_MIN)

                    set priority = EventPriority.ALL[iteration]

                    set iteration2 = Unit(this).Event.Count(thistype.ACQUIRE_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        call Event.SetSubjectId(Unit(this).Id.Get())
                        call UNIT.Event.SetTrigger(this)
                        call UNIT.Event.SetTarget(target)

                        call Unit(this).Event.Get(thistype.ACQUIRE_EVENT_TYPE, priority, iteration2).Run()

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration = iteration - 1
                endloop
            endmethod

            static method AcquireTrig takes nothing returns nothing
                local Unit parent = UNIT.Event.Native.GetTrigger()
                local Unit target = UNIT.Event.Native.GetAcquiredTarget()

                if (target.IsEnemyOf(parent.Owner.Get()) and (target.Order.Get() == NULL)) then
                    call parent.Order.UnitTarget(Order.ATTACK, target)
                endif

                call thistype(parent).Acquire_TriggerEvents(target)

                call thistype(parent).Acquire2.Start(target)
            endmethod

            method Offended_TriggerEvents takes Unit attacker returns nothing
                local integer iteration = EventPriority.ALL_COUNT
                local integer iteration2
                local EventPriority priority

                loop
                    exitwhen (iteration < ARRAY_MIN)

                    set priority = EventPriority.ALL[iteration]

                    set iteration2 = attacker.Event.Count(thistype.OFFENDED_REVERSED_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        call Event.SetSubjectId(attacker.Id.Get())
                        call UNIT.Event.SetTarget(this)
                        call UNIT.Event.SetTrigger(attacker)

                        call attacker.Event.Get(thistype.OFFENDED_REVERSED_EVENT_TYPE, priority, iteration2).Run()

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration2 = Unit(this).Event.Count(thistype.OFFENDED_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        call Event.SetSubjectId(Unit(this).Id.Get())
                        call UNIT.Event.SetTarget(attacker)
                        call UNIT.Event.SetTrigger(this)

                        call Unit(this).Event.Get(thistype.OFFENDED_EVENT_TYPE, priority, iteration2).Run()

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration = iteration - 1
                endloop
            endmethod

            static method OffendedTrigConds takes Unit parent returns boolean
                if (thistype.OFFENDED_GROUP.ContainsUnit(parent) == false) then
                    return false
                endif

                return true
            endmethod

            static method OffendedTrig takes nothing returns nothing
                local Unit parent = UNIT.Event.Native.GetTrigger()

                if (thistype.OffendedTrigConds(parent) == false) then
                    return
                endif

                call thistype(parent).Offended_TriggerEvents(UNIT.Event.Native.GetAttacker())
            endmethod

            method Event_Destroy takes nothing returns nothing
                call thistype.OFFENDED_GROUP.RemoveUnit(this)
            endmethod

            method Event_Create takes nothing returns nothing
                call thistype.ACQUIRE_TRIGGER.RegisterEvent.Unit(this, EVENT_UNIT_ACQUIRED_TARGET)

                call thistype.DUMMY_TRIGGER.RegisterEvent.Unit(this, EVENT_UNIT_TARGET_IN_RANGE)

                call thistype.OFFENDED_GROUP.AddUnit(this)

                call this.Acquire2.Event_Create()
            endmethod

            static method Init takes nothing returns nothing
                set thistype.ACQUIRE_EVENT_TYPE = EventType.Create()
                set thistype.ACQUIRE_TRIGGER = Trigger.CreateFromCode(function thistype.AcquireTrig)

                set thistype.DUMMY_EVENT_TYPE = EventType.Create()
                set thistype.DUMMY_TRIGGER = Trigger.CreateFromCode(function thistype.Trig)

                set thistype.OFFENDED_EVENT_TYPE = EventType.Create()
                set thistype.OFFENDED_GROUP = Group.Create()
                set thistype.OFFENDED_REVERSED_EVENT_TYPE = EventType.Create()
                set thistype.OFFENDED_TRIGGER = Trigger.CreateFromCode(function thistype.OffendedTrig)

                call thistype.OFFENDED_TRIGGER.RegisterEvent.PlayerUnit(User.ANY, EVENT_PLAYER_UNIT_ATTACKED, null)

                call thistype(NULL).Acquire2.Init()
                call thistype(NULL).Ground.Init()
            endmethod
        endstruct

        //! runtextmacro Folder("Missile")
            //! runtextmacro Struct("Speed")
                method Get takes nothing returns real
                    return Unit(this).Type.Get().Attack.Missile.Speed.Get()
                endmethod
            endstruct
        endscope

        //! runtextmacro Struct("Missile")
            //! runtextmacro LinkToStruct("Missile", "Speed")
        endstruct

        //! runtextmacro Struct("Range")
            //! runtextmacro CreateSimpleAddState("real", "Unit(this).Type.Get().Attack.Range.Get()")
        endstruct

        //! runtextmacro Folder("Speed")
            //! runtextmacro Struct("BonusA")
                //! runtextmacro Unit_CreateStateWithPermanentAbilities("Attack.Speed.BonusA", "* 100.", "false")

                static method Init takes nothing returns nothing
                endmethod
            endstruct
        endscope

        //! runtextmacro Struct("Speed")
            //! runtextmacro LinkToStruct("Speed", "BonusA")

            //! runtextmacro CreateSimpleAddState_NotStart("real")

            method GetAll takes nothing returns real
                return (this.Get() + this.BonusA.Get())
            endmethod

            static method Event_TypeChange takes nothing returns nothing
                local UnitType sourceType = UNIT_TYPE.Event.GetSource()
                local UnitType targetType = UNIT_TYPE.Event.GetTrigger()
                local thistype this = UNIT.Event.GetTrigger()

                call this.Add(targetType.Attack.Speed.Get() - sourceType.Attack.Speed.Get())
            endmethod

            method Event_Create takes nothing returns nothing
                call this.Set(Unit(this).Type.Get().Attack.Speed.Get())

                call this.BonusA.Event_Create()
            endmethod

            static method Init takes nothing returns nothing
                call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()

                call thistype(NULL).BonusA.Init()
            endmethod
        endstruct

        //! runtextmacro Folder("Splash")
            //! runtextmacro Struct("TargetFlag")
                //! runtextmacro GetKeyArray("KEY_ARRAY_DETAIL")

                method Is takes integer whichFlag returns boolean
                    return Unit(this).Type.Get().Attack.Splash.TargetFlag.Is(whichFlag)
                endmethod
            endstruct
        endscope

        //! runtextmacro Struct("Splash")
            //! runtextmacro GetKeyArray("AREA_RANGE_KEY_ARRAY")
            //! runtextmacro GetKeyArray("DAMAGE_KEY_ARRAY")

            //! runtextmacro LinkToStruct("Splash", "TargetFlag")

            method Count takes nothing returns integer
                return Unit(this).Data.Real.Table.Count(AREA_RANGE_KEY_ARRAY)
            endmethod

            method GetAreaRange takes integer index returns real
                return Unit(this).Data.Real.Table.Get(AREA_RANGE_KEY_ARRAY, index)
            endmethod

            method GetDamageFactor takes integer index returns real
                return Unit(this).Data.Real.Table.Get(DAMAGE_KEY_ARRAY, index)
            endmethod

            method GetMaxAreaRange takes nothing returns real
                local integer iteration = this.Count()
                local real result = 0.

                loop
                    exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                    set result = Math.Max(result, this.GetAreaRange(iteration))

                    set iteration = iteration - 1
                endloop

                return result
            endmethod

            method Subtract takes integer index returns nothing
                call Unit(this).Data.Real.Table.RemoveByIndex(AREA_RANGE_KEY_ARRAY, index)
                call Unit(this).Data.Real.Table.RemoveByIndex(DAMAGE_KEY_ARRAY, index)
            endmethod

            method Add takes real areaRange, real damageFactor returns integer
                call Unit(this).Data.Real.Table.Add(AREA_RANGE_KEY_ARRAY, areaRange)
                call Unit(this).Data.Real.Table.Add(DAMAGE_KEY_ARRAY, damageFactor)

                return this.Count()
            endmethod

            method Event_Create takes nothing returns nothing
                local UnitType thisType = Unit(this).Type.Get()

                local integer iteration = thisType.Attack.Splash.Count()

                loop
                    exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                    call this.Add(thisType.Attack.Splash.GetAreaRange(iteration), thisType.Attack.Splash.GetDamageFactor(iteration))

                    set iteration = iteration - 1
                endloop

                //call this.TargetFlags.Event_Create()
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Attack")
        //! runtextmacro LinkToStruct("Attack", "Events")
        //! runtextmacro LinkToStruct("Attack", "Missile")
        //! runtextmacro LinkToStruct("Attack", "Range")
        //! runtextmacro LinkToStruct("Attack", "Speed")
        //! runtextmacro LinkToStruct("Attack", "Splash")

        //! runtextmacro CreateSimpleAddState_OnlyGet("integer")

        method Subtract takes nothing returns nothing
            local integer value = this.Get() - 1

            set this.value = value
            if (value == 0) then
                call Unit(this).Abilities.AddBySelf(thistype.DISABLE_SPELL_ID)
                call Unit(this).Abilities.AddBySelf(thistype.ICON_SPELL_ID)
            endif
        endmethod

        method Add takes nothing returns nothing
            local integer value = this.Get() + 1

            set this.value = value
            if (value == 1) then
                call Unit(this).Abilities.RemoveBySelf(thistype.DISABLE_SPELL_ID)
                call Unit(this).Abilities.RemoveBySelf(thistype.ICON_SPELL_ID)
            endif
        endmethod

        static method Event_BuffLose takes nothing returns nothing
            call thistype(UNIT.Event.GetTrigger()).Add()
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            call thistype(UNIT.Event.GetTrigger()).Subtract()
        endmethod

        method DisableTimed takes real duration, Buff whichBuff returns nothing
            call Unit(this).Buffs.Timed.Start(whichBuff, 1, duration)
        endmethod

        method Event_Create takes nothing returns nothing
            set this.value = 1

            call this.Events.Event_Create()
            call this.Range.Event_Create()
            call this.Speed.Event_Create()
            call this.Splash.Event_Create()
        endmethod

        static method Init takes nothing returns nothing
            call InitAbility(thistype.DISABLE_SPELL_ID)
            call InitAbility(thistype.ICON_SPELL_ID)

            call thistype.NONE_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.NONE_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))

            call thistype.NORMAL_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.NORMAL_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))

            call thistype(NULL).Events.Init()
            call thistype(NULL).Speed.Init()
        endmethod
    endstruct

    //! runtextmacro Struct("Blood")
        //! runtextmacro CreateSimpleAddState_NotAdd("string", "Unit(this).Type.Get().Blood.Get()")

        static method Event_TypeChange takes nothing returns nothing
            local UnitType targetType = UNIT_TYPE.Event.GetTrigger()
            local thistype this = UNIT.Event.GetTrigger()

            call this.Set(targetType.Blood.Get())
        endmethod

        static method Init takes nothing returns nothing
            call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
        endmethod
    endstruct

    //! runtextmacro Struct("BloodExplosion")
        //! runtextmacro CreateSimpleAddState_NotAdd("string", "Unit(this).Type.Get().BloodExplosion.Get()")

        static method Event_TypeChange takes nothing returns nothing
            local UnitType targetType = UNIT_TYPE.Event.GetTrigger()
            local thistype this = UNIT.Event.GetTrigger()

            call this.Set(targetType.BloodExplosion.Get())
        endmethod

        static method Init takes nothing returns nothing
            call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
        endmethod
    endstruct

    //! runtextmacro Struct("CollisionSize")
        real value

        method Get takes boolean useScale returns real
            if (useScale) then
                return (this.value * Unit(this).Scale.Get())
            endif

            return this.value
        endmethod

        method GetSquare takes boolean useScale returns real
            return (this.Get(useScale) * this.Get(useScale))
        endmethod

        method Set takes real value returns nothing
            set this.value = value
        endmethod

        method Add takes real value returns nothing
            call this.Set(this.Get(false) + value)
        endmethod

        //! runtextmacro CreateSimpleAddState_OnlyStart("Unit(this).Type.Get().CollisionSize.Get()")

        static method Event_TypeChange takes nothing returns nothing
            local UnitType sourceType = UNIT_TYPE.Event.GetSource()
            local UnitType targetType = UNIT_TYPE.Event.GetTrigger()
            local thistype this = UNIT.Event.GetTrigger()

            call this.Add(targetType.CollisionSize.Get() - sourceType.CollisionSize.Get())
        endmethod

        static method Init takes nothing returns nothing
            call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
        endmethod
    endstruct

    //! runtextmacro Folder("CriticalChance")
        //! runtextmacro Struct("Bonus")
            //! runtextmacro CreateSimpleAddState("real", "0.")
        endstruct

        //! runtextmacro Folder("Defense")
            //! runtextmacro Struct("BonusA")
                //! runtextmacro CreateSimpleAddState("real", "0.")
            endstruct
        endscope

        //! runtextmacro Struct("Defense")
            //! runtextmacro LinkToStruct("Defense", "BonusA")

            //! runtextmacro CreateSimpleAddState_NotStart("real")

            method GetAll takes nothing returns real
                return (this.Get() + this.BonusA.Get())
            endmethod

            method Event_Create takes nothing returns nothing
                call this.Set(0.)

                call this.BonusA.Event_Create()
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("CriticalChance")
        static constant real CHANCE_EXPONENT = 0.1
        static constant real CHANCE_FACTOR = 1.
        static constant real DAMAGE_FACTOR = 2.

        //! runtextmacro LinkToStruct("CriticalChance", "Bonus")
        //! runtextmacro LinkToStruct("CriticalChance", "Defense")

        //! runtextmacro CreateSimpleAddState_NotStart("real")

        method GetAll takes nothing returns real
            return (this.Get() + this.Bonus.Get())
        endmethod

        method VsUnit takes Unit target returns real
            return (1. - 1. / (1. + thistype.CHANCE_FACTOR * Math.Power(1. + this.GetAll() - thistype(target).Defense.GetAll(), thistype.CHANCE_EXPONENT) - 1.))
        endmethod

        method Random takes Unit target returns boolean
            if (Unit(this).Invisibility.Is() and (Unit(this).Invisibility.Reveal.Is() == false)) then
                return true
            endif
            if (target.Sleep.Is()) then
                return true
            endif

            return (Math.Random(0., 1.) <= this.VsUnit(target))
        endmethod

        method Event_Create takes nothing returns nothing
            call this.Set(0.)

            call this.Bonus.Event_Create()
            call this.Defense.Event_Create()
        endmethod
    endstruct

    //! runtextmacro Folder("Death")
        //! runtextmacro Struct("Events")
            static EventType BEFORE_EVENT_TYPE
            static EventType DUMMY_EVENT_TYPE
            static Group DUMMY_GROUP
            static Trigger DUMMY_TRIGGER
            static Unit KILLER
            static EventType KILLER_EVENT_TYPE
            static boolean NEXT_DECAYS_INSTANTLY = false

            method Before_TriggerEvents takes Unit killer returns nothing
                local integer iteration = EventPriority.ALL_COUNT
                local integer iteration2
                local EventPriority priority

                loop
                    exitwhen (iteration < ARRAY_MIN)

                    set priority = EventPriority.ALL[iteration]

                    set iteration2 = Event.CountAtStatics(thistype.BEFORE_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        call UNIT.Event.SetKiller(killer)
                        call UNIT.Event.SetTrigger(this)

                        call Event.GetFromStatics(thistype.BEFORE_EVENT_TYPE, priority, iteration2).Run()

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration = iteration - 1
                endloop
            endmethod

            static method Before_Event_Life takes nothing returns nothing
                local Unit killer = thistype.KILLER

                set UNIT.Life.DAMAGE_SOURCE = NULL

                call thistype(UNIT.Event.GetTrigger()).Before_TriggerEvents(killer)
            endmethod

            method TriggerEvents takes Unit killer returns nothing
                local Event array eventsToRun
                local integer eventsToRunCount = ARRAY_EMPTY
                local integer array eventsToRunType
                local integer iteration = EventPriority.ALL_COUNT
                local integer iteration2
                local EventPriority priority

                loop
                    exitwhen (iteration < ARRAY_MIN)

                    set priority = EventPriority.ALL[iteration]

                    set iteration2 = Event.CountAtStatics(thistype.DUMMY_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        set eventsToRunCount = eventsToRunCount + 1

                        set eventsToRun[eventsToRunCount] = Event.GetFromStatics(thistype.DUMMY_EVENT_TYPE, priority, iteration2)
                        set eventsToRunType[eventsToRunCount] = 0

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration2 = killer.Event.Count(thistype.KILLER_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        set eventsToRunCount = eventsToRunCount + 1

                        set eventsToRun[eventsToRunCount] = killer.Event.Get(thistype.KILLER_EVENT_TYPE, priority, iteration2)
                        set eventsToRunType[eventsToRunCount] = 1

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration2 = Unit(this).Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        set eventsToRunCount = eventsToRunCount + 1

                        set eventsToRun[eventsToRunCount] = Unit(this).Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2)
                        set eventsToRunType[eventsToRunCount] = 2

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration = iteration - 1
                endloop

                set iteration = ARRAY_MIN

                loop
                    exitwhen (iteration > eventsToRunCount)

                    if (eventsToRunType[iteration] == 0) then
                        if (eventsToRun[iteration].IsStatic()) then
                            call Event.SetSubjectId(NULL)
                            call UNIT.Event.SetKiller(killer)
                            call UNIT.Event.SetTrigger(this)

                            call eventsToRun[iteration].Run()

                            if (Unit(this).Classes.Contains(UnitClass.DEAD) == false) then
                                return
                            endif
                        endif
                    elseif (eventsToRunType[iteration] == 1) then
                        if (killer.Event.Contains(eventsToRun[iteration])) then
                            call Event.SetSubjectId(killer.Id.Get())
                            call UNIT.Event.SetTarget(this)
                            call UNIT.Event.SetTrigger(killer)

                            call eventsToRun[iteration].Run()

                            if (Unit(this).Classes.Contains(UnitClass.DEAD) == false) then
                                return
                            endif
                        endif
                    else
                        if (Unit(this).Event.Contains(eventsToRun[iteration])) then
                            call Event.SetSubjectId(Unit(this).Id.Get())
                            call UNIT.Event.SetKiller(killer)
                            call UNIT.Event.SetTrigger(this)

                            call eventsToRun[iteration].Run()

                            if (Unit(this).Classes.Contains(UnitClass.DEAD) == false) then
                                return
                            endif
                        endif
                    endif

                    set iteration = iteration + 1
                endloop
            endmethod

            method TriggerEvents2 takes Unit killer returns nothing
                local integer iteration = EventPriority.ALL_COUNT
                local integer iteration2
                local EventPriority priority

                loop
                    exitwhen (iteration < ARRAY_MIN)

                    set priority = EventPriority.ALL[iteration]

                    set iteration2 = Event.CountAtStatics(thistype.DUMMY_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        call Event.SetSubjectId(NULL)
                        call UNIT.Event.SetKiller(killer)
                        call UNIT.Event.SetTrigger(this)

                        call Event.GetFromStatics(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run()

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration2 = killer.Event.Count(thistype.KILLER_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        call Event.SetSubjectId(killer.Id.Get())
                        call UNIT.Event.SetTarget(this)
                        call UNIT.Event.SetTrigger(killer)

                        call killer.Event.Get(thistype.KILLER_EVENT_TYPE, priority, iteration2).Run()

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration2 = Unit(this).Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        call Event.SetSubjectId(Unit(this).Id.Get())
                        call UNIT.Event.SetKiller(killer)
                        call UNIT.Event.SetTrigger(this)

                        call Unit(this).Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run()

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration = iteration - 1
                endloop
            endmethod

            method Start takes Unit killer returns nothing
                local real decayDuration
                local boolean decaysInstantly = thistype.NEXT_DECAYS_INSTANTLY

                if (decaysInstantly) then
                    set thistype.NEXT_DECAYS_INSTANTLY = false
                endif

                call Group.ALIVE.RemoveUnit(this)
                call Unit(this).Classes.Add(UnitClass.DEAD)

                if ((Unit(this).Classes.Contains(UnitClass.HERO) and (Unit(this).Classes.Contains(UnitClass.ILLUSION) == false)) or Unit(this).Classes.Contains(UnitClass.UNDECAYABLE)) then
                    call this.TriggerEvents(killer)
                else
                    set decayDuration = Unit(this).Decay.Duration.Get()

                    set decaysInstantly = (decaysInstantly or (decayDuration == 0.))

                    if (decaysInstantly) then
                        if (Unit(this).Classes.Contains(UnitClass.SUMMON)) then
                            call SpotEffectWithSize.Create(Unit(this).Position.X.Get(), Unit(this).Position.Y.Get(), Unit(this).BloodExplosion.Get(), EffectLevel.LOW, Unit(this).Scale.Get()).DestroyTimed.Start(5.)
                        endif

                        call this.TriggerEvents(killer)

                        if (Unit(this).IsDestroyed() == false) then
                            call Unit(this).Decay.Do()
                        endif
                    else
                        call Unit(this).Decay.Timed.Start(decayDuration)

                        call this.TriggerEvents(killer)
                    endif
                endif
            endmethod

            static method TrigConds takes Unit parent returns boolean
                if (thistype.DUMMY_GROUP.ContainsUnit(parent) == false) then
                    return false
                endif

                return true
            endmethod

            static method Event_Life takes nothing returns nothing
                local Unit killer = thistype.KILLER
                local Unit parent = UNIT.Event.GetTrigger()

                set UNIT.Life.DAMAGE_SOURCE = NULL

                if (thistype.TrigConds(parent) == false) then
                    return
                endif

                call thistype(parent).Start(killer)
            endmethod

            static method Trig takes nothing returns nothing
                local Unit parent = UNIT.Event.Native.GetTrigger()

                if (thistype.TrigConds(parent) == false) then
                    return
                endif

                call thistype(parent).Start(thistype.KILLER)
            endmethod

            method Event_Destroy takes nothing returns nothing
                call thistype.DUMMY_GROUP.RemoveUnit(this)
                call Group.ALIVE.RemoveUnit(this)
            endmethod

            method Event_Create takes nothing returns nothing
                call thistype.DUMMY_GROUP.AddUnit(this)
            endmethod

            static method Init takes nothing returns nothing
                set thistype.BEFORE_EVENT_TYPE = EventType.Create()
                set thistype.DUMMY_EVENT_TYPE = EventType.Create()
                set thistype.DUMMY_GROUP = Group.Create()
                set thistype.DUMMY_TRIGGER = Trigger.CreateFromCode(function thistype.Trig)
                set thistype.KILLER_EVENT_TYPE = EventType.Create()

                call thistype.DUMMY_TRIGGER.RegisterEvent.PlayerUnit(User.ANY, EVENT_PLAYER_UNIT_DEATH, null)
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Death")
        //! runtextmacro LinkToStruct("Death", "Events")

        method Event_Destroy takes nothing returns nothing
            call this.Events.Event_Destroy()
        endmethod

        method Event_Create takes nothing returns nothing
            call this.Events.Event_Create()
        endmethod

        method Do takes Unit killer returns nothing
            set thistype(NULL).Events.KILLER = killer

            call KillUnit(Unit(this).self)
        endmethod

        static method Init takes nothing returns nothing
            call thistype(NULL).Events.Init()
        endmethod
    endstruct

    //! runtextmacro Folder("Decay")
        //! runtextmacro Struct("Duration")
            //! runtextmacro CreateSimpleAddState("real", "Unit(this).Type.Get().Decay.Duration.Get()")

            static method Event_TypeChange takes nothing returns nothing
                local UnitType sourceType = UNIT_TYPE.Event.GetSource()
                local UnitType targetType = UNIT_TYPE.Event.GetTrigger()
                local thistype this = UNIT.Event.GetTrigger()

                call this.Add(targetType.Decay.Duration.Get() - sourceType.Decay.Duration.Get())
            endmethod

            static method Init takes nothing returns nothing
                call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
            endmethod
        endstruct

        //! runtextmacro Struct("Events")
            static Group DUMMY_GROUP
            static Trigger DUMMY_TRIGGER

            static method TrigConds takes nothing returns boolean
                if (thistype.DUMMY_GROUP.ContainsUnit(UNIT.Event.Native.GetFilter()) == false) then
                    return false
                endif

                return true
            endmethod

            static method Trig takes nothing returns nothing
                call UNIT.Event.Native.GetTrigger().Decay.Suspend(true)
            endmethod

            method Event_Destroy takes nothing returns nothing
                call thistype.DUMMY_GROUP.RemoveUnit(this)
            endmethod

            method Event_Create takes nothing returns nothing
                call thistype.DUMMY_GROUP.AddUnit(this)
            endmethod

            static method Init takes nothing returns nothing
                set thistype.DUMMY_GROUP = Group.Create()
                set thistype.DUMMY_TRIGGER = Trigger.CreateFromCode(function thistype.Trig)

                call thistype.DUMMY_TRIGGER.RegisterEvent.PlayerUnit(User.ANY, EVENT_PLAYER_UNIT_DECAY, function thistype.TrigConds)
            endmethod
        endstruct

        //! runtextmacro Struct("Timed")
            static Event DESTROY_EVENT
            //! runtextmacro GetKey("KEY")
            static Event REVIVE_EVENT

            Timer durationTimer
            Unit parent

            method Ending takes Timer durationTimer, Unit parent returns nothing
                call this.deallocate()
                call durationTimer.Destroy()
                call parent.Data.Integer.Remove(KEY)
                call parent.Event.Remove(DESTROY_EVENT)
                call parent.Event.Remove(REVIVE_EVENT)
            endmethod

            private static method EndingByTimer takes nothing returns nothing
                local Timer durationTimer = Timer.GetExpired()

                local thistype this = durationTimer.GetData()

                local Unit parent = this.parent

                call this.Ending(durationTimer, parent)

                call parent.Decay.Do()
            endmethod

            static method Event_Destroy takes nothing returns nothing
                local Unit parent = UNIT.Event.GetTrigger()

                local thistype this = parent.Data.Integer.Get(KEY)

                call this.Ending(this.durationTimer, parent)
            endmethod

            static method Event_Revive takes nothing returns nothing
                local Unit parent = UNIT.Event.GetTrigger()

                local thistype this = parent.Data.Integer.Get(KEY)

                call this.Ending(this.durationTimer, parent)
            endmethod

            method Start takes real duration returns nothing
                local Timer durationTimer = Timer.Create()
                local Unit parent = this

                set this = thistype.allocate()

                set this.durationTimer = durationTimer
                set this.parent = parent
                call durationTimer.SetData(this)
                call parent.Data.Integer.Set(KEY, this)
                call parent.Event.Add(DESTROY_EVENT)
                call parent.Event.Add(REVIVE_EVENT)

                call durationTimer.Start(duration, false, function thistype.EndingByTimer)
            endmethod

            static method Init takes nothing returns nothing
                set thistype.DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
                set thistype.REVIVE_EVENT = Event.Create(UNIT.Revival.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Revive)
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Decay")
        //! runtextmacro LinkToStruct("Decay", "Duration")
        //! runtextmacro LinkToStruct("Decay", "Events")
        //! runtextmacro LinkToStruct("Decay", "Timed")

        method Do takes nothing returns nothing
            call Unit(this).Destroy()
        endmethod

        method Suspend takes boolean flag returns nothing
            call UnitSuspendDecay(Unit(this).self, flag)
        endmethod

        method Event_Create takes nothing returns nothing
            call this.Duration.Event_Create()
            call this.Events.Event_Create()
        endmethod

        static method Init takes nothing returns nothing
            call thistype(NULL).Duration.Init()
            call thistype(NULL).Events.Init()
            call thistype(NULL).Timed.Init()
        endmethod
    endstruct

    //! runtextmacro Struct("Display")
        static constant integer SPELL_ID = 'AUUD'

        method Update takes nothing returns nothing
            call Unit(this).Abilities.AddBySelf(thistype.DUMMY_SPELL_ID)
            call Unit(this).Abilities.RemoveBySelf(thistype.DUMMY_SPELL_ID)
        endmethod

        static method Init takes nothing returns nothing
            call InitAbility(thistype.DUMMY_SPELL_ID)
        endmethod
    endstruct

    //! runtextmacro Folder("Drop")
        //! runtextmacro Struct("Exp")
            //! runtextmacro CreateSimpleAddState("integer", "Unit(this).Type.Get().Drop.Exp.Get()")

            static method Event_TypeChange takes nothing returns nothing
                local UnitType sourceType = UNIT_TYPE.Event.GetSource()
                local UnitType targetType = UNIT_TYPE.Event.GetTrigger()
                local thistype this = UNIT.Event.GetTrigger()

                call this.Add(targetType.Drop.Exp.Get() - sourceType.Drop.Exp.Get())
            endmethod

            static method Init takes nothing returns nothing
                call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
            endmethod
        endstruct

        //! runtextmacro Struct("Supply")
            //! runtextmacro CreateSimpleAddState("integer", "Unit(this).Type.Get().Drop.Supply.Get()")

            static method Event_TypeChange takes nothing returns nothing
                local UnitType sourceType = UNIT_TYPE.Event.GetSource()
                local UnitType targetType = UNIT_TYPE.Event.GetTrigger()
                local thistype this = UNIT.Event.GetTrigger()

                call this.Add(targetType.Drop.Supply.Get() - sourceType.Drop.Supply.Get())
            endmethod

            static method Init takes nothing returns nothing
                call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Drop")
        static Event DESTROY_EVENT
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro LinkToStruct("Drop", "Exp")
        //! runtextmacro LinkToStruct("Drop", "Supply")

        static method Event_Destroy takes nothing returns nothing
            local Unit parent = UNIT.Event.GetTrigger()
            local CustomDrop value

            local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

            call parent.Event.Remove(DESTROY_EVENT)
            loop
                set value = parent.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                call parent.Event.Remove(value.GetEvent())

                set iteration = iteration - 1
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
            endloop

            call parent.Data.Integer.Table.Clear(KEY_ARRAY)
        endmethod

        method Add takes CustomDrop value returns nothing
            if (Unit(this).Data.Integer.Table.Add(KEY_ARRAY, value)) then
                call Unit(this).Event.Add(DESTROY_EVENT)
            endif
            call Unit(this).Event.Add(value.GetEvent())
            call Unit(this).Effects.Create(value.GetEffectPath(), value.GetEffectAttachPoint(), value.GetEffectLevel())
        endmethod

        method Clear takes nothing returns nothing
            local Unit parent = UNIT.Event.GetTrigger()
            local CustomDrop value

            local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

            if (iteration < Memory.IntegerKeys.Table.STARTED) then
                return
            endif

            call parent.Event.Remove(DESTROY_EVENT)
            loop
                set value = parent.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                call parent.Event.Remove(value.GetEvent())

                set iteration = iteration - 1
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
            endloop

            call parent.Data.Integer.Table.Clear(KEY_ARRAY)
        endmethod

        static method Event_TypeChange takes nothing returns nothing
            local UnitType targetType = UNIT_TYPE.Event.GetTrigger()
            local thistype this = UNIT.Event.GetTrigger()

            local integer iteration = targetType.Drop.Count()

            call this.Clear()

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                call this.Add(targetType.Drop.Get(iteration))

                set iteration = iteration - 1
            endloop
        endmethod

        method Event_Create takes nothing returns nothing
            local UnitType whichType = Unit(this).Type.Get()

            local integer iteration = whichType.Drop.Count()

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                call this.Add(whichType.Drop.Get(iteration))

                set iteration = iteration - 1
            endloop

            call this.Exp.Event_Create()
            call this.Supply.Event_Create()
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
            call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()

            call thistype(NULL).Exp.Init()
            call thistype(NULL).Supply.Init()
        endmethod
    endstruct

    //! runtextmacro Struct("Evasion")
        static constant string TRY_TEXT = "patzer"

        //! runtextmacro CreateSimpleFlagCountState_NotStart()

        method Try takes Unit target returns boolean
            if (thistype(target).Is() == false) then
                return false
            endif
            if (target.Sleep.Is()) then
                return false
            endif
            if (Unit(this).Invisibility.Is()) then
                return false
            endif

            if (Math.Random(0., 1.) > Unit(this).EvasionChance.VsUnit(target)) then
                return false
            endif

            call Unit(this).AddRisingTextTag(String.Color.Do(thistype.TRY_TEXT, "dfffdfdf"), 0.02, 140., 0., 1.5, TextTag.GetFreeId())
            call target.Effects.Create("Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl", AttachPoint.CHEST, EffectLevel.NORMAL).Destroy()

            return true
        endmethod

        method Event_Create takes nothing returns nothing
            if (Unit(this).Classes.Contains(UnitClass.STRUCTURE) or Unit(this).Classes.Contains(UnitClass.WARD)) then
                call this.Set(0)
            else
                call this.Set(1)
            endif
        endmethod
    endstruct

    //! runtextmacro Folder("EvasionChance")
        //! runtextmacro Struct("Bonus")
            //! runtextmacro CreateSimpleAddState("real", "0.")
        endstruct

        //! runtextmacro Folder("Defense")
            //! runtextmacro Struct("BonusA")
                //! runtextmacro CreateSimpleAddState("real", "0.")
            endstruct
        endscope

        //! runtextmacro Struct("Defense")
            //! runtextmacro LinkToStruct("Defense", "BonusA")

            //! runtextmacro CreateSimpleAddState_NotStart("real")

            method GetAll takes nothing returns real
                return (this.Get() + this.BonusA.Get())
            endmethod

            method Event_Create takes nothing returns nothing
                call this.Set(0.)

                call this.BonusA.Event_Create()
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("EvasionChance")
        static constant real CHANCE_EXPONENT = 0.1
        static constant real CHANCE_FACTOR = 1.
        static constant real MAX = 0.55
        static constant real MIN = 0.05

        //! runtextmacro LinkToStruct("EvasionChance", "Bonus")
        //! runtextmacro LinkToStruct("EvasionChance", "Defense")

        //! runtextmacro CreateSimpleAddState_OnlyGet("real")

        method VsUnit takes Unit target returns real
            return Math.Limit(1. - 1. / (1. + CHANCE_FACTOR * (Math.Power(1. + thistype(target).GetAll() - this.Defense.GetAll(), thistype.CHANCE_EXPONENT) - 1.)), thistype.MIN, thistype.MAX)
        endmethod

        method GetAll takes nothing returns real
            return (this.Get() + this.Bonus.Get())
        endmethod

        method Set takes real chance returns nothing
            set this.value = chance
        endmethod

        //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

        method Event_Create takes nothing returns nothing
            call this.Set(0.)

            call this.Bonus.Event_Create()
            call this.Defense.Event_Create()
        endmethod

        static method Init takes nothing returns nothing
        endmethod
    endstruct

    //! runtextmacro Folder("Impact")
        //! runtextmacro Struct("X")
            real value

            method Get takes boolean useScale returns real
                if (useScale) then
                    return (this.value * Unit(this).Scale.Get())
                endif

                return this.value
            endmethod

            method Set takes real value returns nothing
                set this.value = value
            endmethod

            method Add takes real value returns nothing
                call this.Set(this.Get(false) + value)
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyStart("0.")
        endstruct

        //! runtextmacro Struct("Y")
            real value

            method Get takes boolean useScale returns real
                if (useScale) then
                    return (this.value * Unit(this).Scale.Get())
                endif

                return this.value
            endmethod

            method Set takes real value returns nothing
                set this.value = value
            endmethod

            method Add takes real value returns nothing
                call this.Set(this.Get(false) + value)
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyStart("0.")
        endstruct

        //! runtextmacro Struct("Z")
            real value

            method Get takes boolean useScale returns real
                if (useScale) then
                    return (this.value * Unit(this).Scale.Get())
                endif

                return this.value
            endmethod

            method Set takes real value returns nothing
                set this.value = value
            endmethod

            method Add takes real value returns nothing
                call this.Set(this.Get(false) + value)
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyStart("Unit(this).Type.Get().Impact.Z.Get()")

            method Event_TypeChange takes UnitType sourceType, UnitType targetType returns nothing
                call this.Add(targetType.Impact.Z.Get() - sourceType.Impact.Z.Get())
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Impact")
        //! runtextmacro LinkToStruct("Impact", "X")
        //! runtextmacro LinkToStruct("Impact", "Y")
        //! runtextmacro LinkToStruct("Impact", "Z")

        static method Event_TypeChange takes nothing returns nothing
            local UnitType sourceType = UNIT_TYPE.Event.GetSource()
            local UnitType targetType = UNIT_TYPE.Event.GetTrigger()
            local thistype this = UNIT.Event.GetTrigger()

            call this.Z.Event_TypeChange(sourceType, targetType)
        endmethod

        method Event_Create takes nothing returns nothing
            call this.X.Event_Create()
            call this.Y.Event_Create()
            call this.Z.Event_Create()
        endmethod

        static method Init takes nothing returns nothing
            call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
        endmethod
    endstruct

    //! runtextmacro Struct("Exp")
        //! runtextmacro CreateSimpleAddState_OnlyGet("real")

        method Set takes real value returns nothing
            set this.value = value
            call SetHeroXP(Unit(this).self, Real.ToInt(value), false)
        endmethod

        //! runtextmacro CreateSimpleAddState_OnlyAdd("real", "GetHeroXP(Unit(this).self)")
    endstruct

    //! runtextmacro Folder("Outpact")
        //! runtextmacro Struct("X")
            real value

            method Get takes boolean useScale returns real
                if (useScale) then
                    return (this.value * Unit(this).Scale.Get())
                endif

                return this.value
            endmethod

            method Set takes real value returns nothing
                set this.value = value
            endmethod

            method Add takes real value returns nothing
                call this.Set(this.Get(false) + value)
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyStart("0.")
        endstruct

        //! runtextmacro Struct("Y")
            real value

            method Get takes boolean useScale returns real
                if (useScale) then
                    return (this.value * Unit(this).Scale.Get())
                endif

                return this.value
            endmethod

            method Set takes real value returns nothing
                set this.value = value
            endmethod

            method Add takes real value returns nothing
                call this.Set(this.Get(false) + value)
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyStart("0.")
        endstruct

        //! runtextmacro Struct("Z")
            real value

            method Get takes boolean useScale returns real
                if (useScale) then
                    return (this.value * Unit(this).Scale.Get())
                endif

                return this.value
            endmethod

            method Set takes real value returns nothing
                set this.value = value
            endmethod

            method Add takes real value returns nothing
                call this.Set(this.Get(false) + value)
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyStart("Unit(this).Type.Get().Outpact.Z.Get()")

            method Event_TypeChange takes UnitType sourceType, UnitType targetType returns nothing
                call this.Add(targetType.Outpact.Z.Get() - sourceType.Outpact.Z.Get())
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Outpact")
        //! runtextmacro LinkToStruct("Outpact", "X")
        //! runtextmacro LinkToStruct("Outpact", "Y")
        //! runtextmacro LinkToStruct("Outpact", "Z")

        static method Event_TypeChange takes nothing returns nothing
            local UnitType sourceType = UNIT_TYPE.Event.GetSource()
            local UnitType targetType = UNIT_TYPE.Event.GetTrigger()
            local thistype this = UNIT.Event.GetTrigger()

            call this.Z.Event_TypeChange(sourceType, targetType)
        endmethod

        method Event_Create takes nothing returns nothing
            call this.X.Event_Create()
            call this.Y.Event_Create()
            call this.Z.Event_Create()
        endmethod

        static method Init takes nothing returns nothing
            call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
        endmethod
    endstruct

    //! runtextmacro Struct("LifeLeech")
        //! runtextmacro CreateSimpleAddState("real", "0.")
    endstruct

    //! textmacro Unit_CreateStateWithTemporaryAbilities takes name, factor
        real displayedValue
        real value
        real valueAll

        method Get takes nothing returns real
            return this.value
        endmethod

        method AddNative takes real amount returns nothing
            local integer packet
            local integer packetLevel

            if (amount < 0) then
                set amount = -amount

                set packetLevel = Math.MinI(Math.LogOf2I(Real.ToInt(amount)), thistype.DECREASING_SPELLS_MAX)

                loop
                    exitwhen (amount < 1)

                    set packet = thistype.PACKETS[packetLevel]

                    loop
                        exitwhen (amount < packet)

                        call Unit(this).Abilities.AddBySelf(thistype.DECREASING_SPELL_ID)

                        call Unit(this).Abilities.SetLevelBySelf(thistype.DECREASING_SPELL_ID, 2 + packetLevel)

                        call Unit(this).Abilities.RemoveBySelf(thistype.DECREASING_SPELL_ID)

                        set amount = amount - packet
                    endloop

                    set packetLevel = packetLevel - 1
                endloop
            else
                set packetLevel = Math.MinI(Math.LogOf2I(Real.ToInt(amount)), thistype.INCREASING_SPELLS_MAX)

                loop
                    exitwhen (amount < 1)

                    set packet = thistype.PACKETS[packetLevel]

                    loop
                        exitwhen (amount < packet)

                        call Unit(this).Abilities.AddBySelf(thistype.INCREASING_SPELL_ID)

                        call Unit(this).Abilities.SetLevelBySelf(thistype.INCREASING_SPELL_ID, 2 + packetLevel)

                        call Unit(this).Abilities.RemoveBySelf(thistype.INCREASING_SPELL_ID)

                        set amount = amount - packet
                    endloop

                    set packetLevel = packetLevel - 1
                endloop
            endif
        endmethod

        method Set takes real value returns nothing
            local real oldDisplayedValue = this.displayedValue
            static if (thistype.SetEx.exists) then
                local real oldValue = this.valueAll
            endif

            set this.value = value

            set value = value $factor$

            set this.displayedValue = value
            call this.AddNative(value - oldDisplayedValue)

            static if (thistype.SetEx.exists) then
                set this.valueAll = value
                if (oldValue != 0.) then
                    call this.SetEx(oldValue, value)
                endif
            endif
        endmethod

        method Add takes real value returns nothing
            call this.Set(this.Get() + value)
        endmethod

        method Subtract takes real value returns nothing
            call this.Set(this.Get() - value)
        endmethod

        method Update takes nothing returns nothing
            call this.Set(this.Get())
        endmethod
    //! endtextmacro

    //! runtextmacro Struct("Invulnerability")
        //! runtextmacro GetKeyArray("KEY_ARRAY")
        static constant string TRY_TEXT = "Invulnerable!!"

        //! runtextmacro CreateSimpleAddState_OnlyGet("integer")

        method Is takes nothing returns boolean
            return (this.Get() > 0)
        endmethod

        method Try takes nothing returns boolean
            if (this.Is() == false) then
                return false
            endif

            call Unit(this).AddJumpingTextTag(String.Color.Do(thistype.TRY_TEXT, "ffff0000"), 0.02, KEY_ARRAY + this)

            return true
        endmethod

        static method Event_BuffLose takes nothing returns nothing
            local Unit parent = UNIT.Event.GetTrigger()

            local thistype this = parent

            local integer value = this.Get() - 1

            set this.value = value
            if (value == 0) then
            endif
        endmethod

        method Subtract takes Buff whichBuff returns nothing
            call Unit(this).Buffs.Subtract(whichBuff)
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local Unit parent = UNIT.Event.GetTrigger()

            local thistype this = parent

            local integer value = this.Get() + 1

            set this.value = value
            if (value == 1) then
            endif
        endmethod

        method Add takes Buff whichBuff returns nothing
            call Unit(this).Buffs.Add(whichBuff, 1)
        endmethod

        method AddTimed takes real duration, Buff whichBuff returns nothing
            call Unit(this).Buffs.Timed.Start(whichBuff, 1, duration)
        endmethod

        method Update takes nothing returns nothing
        endmethod

        static method Event_TypeChange takes nothing returns nothing
            local thistype this = UNIT.Event.GetTrigger()

            call this.Update()
        endmethod

        //! runtextmacro CreateSimpleAddState_OnlyStart("0")

        static method Init takes nothing returns nothing
            local Buff currentBuff

            set currentBuff = thistype.NONE_BUFF

            call currentBuff.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call currentBuff.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))

            set currentBuff = thistype.NORMAL_BUFF

            call currentBuff.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call currentBuff.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))

            call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
        endmethod
    endstruct

    //! runtextmacro Folder("Damage")
        //! runtextmacro Struct("Bonus")
            //! runtextmacro Unit_CreateStateWithPermanentAbilities("Damage.Bonus", "* 1. + Unit(this).Damage.Get() * (Unit(this).Damage.Relative.Get() - 1.)", "true")

            static method Init takes nothing returns nothing
                static if (thistype.WAIT_FOR_SELECTION) then
                    set thistype.SELECTION_EVENT = Event.Create(UNIT.Selection.START_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Selection)
                endif
            endmethod
        endstruct

        //! runtextmacro Struct("Delay")
            //! runtextmacro CreateSimpleAddState("real", "Unit(this).Type.Get().Damage.Delay.Get()")
        endstruct

        //! runtextmacro Struct("Dices")
            //! runtextmacro CreateSimpleAddState("integer", "Unit(this).Type.Get().Damage.Dices.Get()")

            static method Event_TypeChange takes nothing returns nothing
                local UnitType targetType = UNIT_TYPE.Event.GetTrigger()
                local thistype this = UNIT.Event.GetTrigger()

                call this.Set(targetType.Damage.Dices.Get())
            endmethod

            static method Init takes nothing returns nothing
                call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
            endmethod
        endstruct

        //! runtextmacro Struct("Events")
            static EventType ATTACKER_EVENT_TYPE
            static Trigger DUMMY_TRIGGER
            static boolean IGNORE_NEXT = false
            static boolean SPELL_NEXT = false
            static BoolExpr SPLASH_FILTER
            static Group SPLASH_GROUP
            static Group SPLASH_GROUP2
            static EventType TARGET_EVENT_TYPE
            static EventType TARGET_EDIT_EVENT_TYPE
            //! runtextmacro GetKeyArray("TEXT_TAG_KEY_ARRAY")

            method TriggerEvents takes real amount, Unit target, boolean isSpell returns real
                local integer iteration = EventPriority.ALL_COUNT
                local integer iteration2
                local Unit parent = this
                local EventPriority priority

                loop
                    exitwhen (iteration < ARRAY_MIN)

                    set priority = EventPriority.ALL[iteration]

                    set iteration2 = target.Event.Count(thistype.TARGET_EDIT_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        call TRIGGER.Event.SetDamage(amount)
                        call UNIT.Event.SetDamager(parent)
                        call UNIT.Event.SetTrigger(target)

                        call target.Event.Get(thistype.TARGET_EDIT_EVENT_TYPE, priority, iteration2).Run()

                        set amount = TRIGGER.Event.GetDamage()

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration2 = target.Event.Count(thistype.TARGET_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        call Event.SetSubjectId(target.Id.Get())
                        call TRIGGER.Event.SetDamage(amount)
                        call UNIT.Event.SetDamager(parent)
                        call UNIT.Event.SetTrigger(target)

                        call target.Event.Get(thistype.TARGET_EVENT_TYPE, priority, iteration2).Run()

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration2 = parent.Event.Count(thistype.ATTACKER_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        call Event.SetSubjectId(parent.Id.Get())
                        call TRIGGER.Event.SetDamage(amount)
                        call UNIT.Event.SetDamager(parent)
                        call UNIT.Event.SetTrigger(target)

                        call parent.Event.Get(thistype.ATTACKER_EVENT_TYPE, priority, iteration2).Run()

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration = iteration - 1
                endloop

                return amount
            endmethod

            static method SplashConditions takes nothing returns boolean
                local Unit target = UNIT.Event.Native.GetFilter()

                if (thistype.SPLASH_GROUP2.ContainsUnit(target)) then
                    return false
                endif

                if ((TEMP_BOOLEAN == false) and target.IsAllyOf(User.TEMP)) then
                    return false
                endif

                if (target.Classes.Contains(UnitClass.DEAD)) then
                    return false
                endif
                if (target.Classes.Contains(UnitClass.GROUND) == false) then
                    return false
                endif

                return true
            endmethod

            method DealSplash_Single takes Unit target, real amount, integer whichType returns nothing
                set amount = amount * (1. - target.Armor.IgnoreDamage.Relative.Get())

                set amount = amount * UNIT.Armor.GetDamageFactor(target.Armor.GetAll())

                set amount = amount * Attack.Get(whichType, target.Armor.TypeA.Get())

                call Unit(this).DamageUnit(target, amount, false)
            endmethod

            method DealSplash takes real damageAmount, integer damageType, real x, real y, Unit primaryTarget returns nothing
                local boolean affectsAlly
                local integer iteration
                local integer iterationEnd = Unit(this).Attack.Splash.Count()
                local User parentOwner
                local real rangeDamageAmount
                local Unit target

                if (iterationEnd < Memory.IntegerKeys.Table.STARTED) then
                    return
                endif

                set affectsAlly = Unit(this).Attack.Splash.TargetFlag.Is(TargetFlag.ALLY)
                set iteration = Memory.IntegerKeys.Table.STARTED
                set parentOwner = Unit(this).Owner.Get()
                call thistype.SPLASH_GROUP2.AddUnit(primaryTarget)

                loop
                    set TEMP_BOOLEAN = affectsAlly
                    set User.TEMP = parentOwner

                    call thistype.SPLASH_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, Unit(this).Attack.Splash.GetAreaRange(iteration), thistype.SPLASH_FILTER)

                    set target = thistype.SPLASH_GROUP.FetchFirst()

                    if (target != NULL) then
                        set rangeDamageAmount = damageAmount * Unit(this).Attack.Splash.GetDamageFactor(iteration)

                        loop
                            call thistype.SPLASH_GROUP2.AddUnit(target)

                            call this.DealSplash_Single(target, rangeDamageAmount, damageType)

                            set target = thistype.SPLASH_GROUP.FetchFirst()
                            exitwhen (target == NULL)
                        endloop
                    endif

                    set iteration = iteration + 1
                    exitwhen (iteration > iterationEnd)
                endloop

                call thistype.SPLASH_GROUP2.Clear()
            endmethod

            method VsUnit takes Unit target, boolean triggerEvents, real amount returns nothing
                local real armorAmount = target.Armor.GetAll()
                local integer damageType = Unit(this).Damage.TypeA.Get()
                local TextTag oldTextTag
                local Unit parent = this
                local real targetX = target.Position.X.Get()
                local real targetY = target.Position.Y.Get()

                local integer iteration = parent.Damage.Dices.Get()
                local real lifeLeech = parent.LifeLeech.Get()
                local integer sides = parent.Damage.Sides.Get()

                if parent.Evasion.Try(target) then
                    return
                endif
                if target.Invulnerability.Try() then
                    return
                endif

                loop
                    exitwhen (iteration < 1)

                    set amount = amount + Math.RandomI(1, sides)

                    set iteration = iteration - 1
                endloop

                set amount = amount * (1. - target.Armor.IgnoreDamage.Relative.Get())

                set amount = amount * UNIT.Armor.GetDamageFactor(target.Armor.GetAll())

                set amount = amount * Attack.Get(parent.Damage.TypeA.Get(), target.Armor.TypeA.Get())

                if parent.CriticalChance.Random(target) then
                    set amount = amount * UNIT.CriticalChance.DAMAGE_FACTOR

                    if (amount > 0.) then
                        call target.ReplaceRisingTextTagIfMinorValue(String.Color.Do(Real.ToIntString(amount) + Char.EXCLAMATION_MARK, parent.Owner.Get().GetColorString()), Math.Linear(amount, target.MaxLife.GetAll() / 2., 0.024, 0.028), 160., 0., 1., TEXT_TAG_KEY_ARRAY + target, amount / 2)
                    endif
                else
                    if (amount > 0.) then
                        call target.ReplaceRisingTextTagIfMinorValue(String.Color.Do(Real.ToIntString(amount), parent.Owner.Get().GetColorString()), Math.Linear(amount, target.MaxLife.GetAll() / 2., 0.016, 0.022), 160., 0., 1., TEXT_TAG_KEY_ARRAY + target, amount / 2)
                    endif
                endif

                call parent.DamageUnit(target, amount, true)

                if (lifeLeech > 0.) then
                    if (target.IsAllyOf(parent) == false) then
                        call parent.AddRisingTextTag(String.Color.Do(Char.PLUS + Integer.ToString(Real.ToInt(lifeLeech)), "ffc80000"), 0.02, 80., 0., 3., TextTag.GetFreeId())

                        call parent.Life.Add(lifeLeech)
                    endif
                endif

                call this.DealSplash(amount, damageType, targetX, targetY, target)
            endmethod

            static method Trig takes nothing returns nothing
                local Unit parent = UNIT.Event.Native.GetDamager()
                local boolean isSpell = thistype.SPELL_NEXT
                local Unit target = UNIT.Event.Native.GetTrigger()

                if ((parent == STRUCT_INVALID) or (TRIGGER.Event.Native.GetDamage() == 0.) or (parent.Attack.Get() == Attack.ARTILLERY)) then
                    set thistype.IGNORE_NEXT = true
                endif

                set thistype.SPELL_NEXT = false
                if thistype.IGNORE_NEXT then
                    set thistype.IGNORE_NEXT = false
                else
                    if isSpell then
                        call thistype(parent).TriggerEvents(0., target, true)
                    else
                        call thistype(parent).VsUnit(target, true, parent.Damage.GetAll())
                    endif
                endif
            endmethod

            method Event_Create takes nothing returns nothing
                call thistype.DUMMY_TRIGGER.RegisterEvent.Unit(this, EVENT_UNIT_DAMAGED)
            endmethod

            static method Init takes nothing returns nothing
                set thistype.ATTACKER_EVENT_TYPE = EventType.Create()
                set thistype.DUMMY_TRIGGER = Trigger.CreateFromCode(function thistype.Trig)
                set thistype.SPLASH_FILTER = BoolExpr.GetFromFunction(function thistype.SplashConditions)
                set thistype.SPLASH_GROUP = Group.Create()
                set thistype.SPLASH_GROUP2 = Group.Create()
                set thistype.TARGET_EDIT_EVENT_TYPE = EventType.Create()
                set thistype.TARGET_EVENT_TYPE = EventType.Create()
            endmethod
        endstruct

        //! runtextmacro Folder("Relative")
            //! runtextmacro Struct("Invisible")
                //! runtextmacro CreateSimpleAddState("real", "1.")
            endstruct
        endscope

        //! runtextmacro Struct("Relative")
            //! runtextmacro LinkToStruct("Relative", "Invisible")

            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).Damage.Bonus.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            method Event_Create takes nothing returns nothing
                call this.Set(1.)

                call Invisible.Event_Create()
            endmethod
        endstruct

        //! runtextmacro Struct("Sides")
            //! runtextmacro CreateSimpleAddState("integer", "Unit(this).Type.Get().Damage.Sides.Get()")

            static method Event_TypeChange takes nothing returns nothing
                local UnitType targetType = UNIT_TYPE.Event.GetTrigger()
                local thistype this = UNIT.Event.GetTrigger()

                call this.Set(targetType.Damage.Sides.Get())
            endmethod

            static method Init takes nothing returns nothing
                call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
            endmethod
        endstruct

        //! runtextmacro Struct("SpellRelative")
            //! runtextmacro CreateSimpleAddState("real", "1.")
        endstruct

        //! runtextmacro Struct("TypeA")
            //! runtextmacro CreateSimpleAddState("integer", "Unit(this).Type.Get().Damage.Type.Get()")

            static method Event_TypeChange takes nothing returns nothing
                local UnitType targetType = UNIT_TYPE.Event.GetTrigger()
                local thistype this = UNIT.Event.GetTrigger()

                call this.Set(targetType.Damage.Type.Get())
            endmethod

            static method Init takes nothing returns nothing
                call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Damage")
        static constant boolean WAIT_FOR_SELECTION = true

        //! runtextmacro LinkToStruct("Damage", "Bonus")
        //! runtextmacro LinkToStruct("Damage", "Delay")
        //! runtextmacro LinkToStruct("Damage", "Dices")
        //! runtextmacro LinkToStruct("Damage", "Events")
        //! runtextmacro LinkToStruct("Damage", "Relative")
        //! runtextmacro LinkToStruct("Damage", "Sides")
        //! runtextmacro LinkToStruct("Damage", "SpellRelative")
        //! runtextmacro LinkToStruct("Damage", "TypeA")

        //! runtextmacro CreateSimpleAddState_OnlyGet("real")

        method GetAll takes nothing returns real
            return (this.Get() * this.Relative.Get() * this.Relative.Invisible.Get() + this.Bonus.Get())
        endmethod

        method GetVisibleAll takes nothing returns real
            return (this.Get() * this.Relative.Get() + this.Bonus.Get())
        endmethod

        method GetVisibleBonus takes nothing returns real
            return this.GetVisibleAll() - this.Get()
        endmethod

        static if (thistype.WAIT_FOR_SELECTION) then
            static Event SELECTION_EVENT

            real displayedValue
            boolean waitForSelection

            method UpdateDisplay takes real value, real oldValue returns nothing
                set this.displayedValue = value

                call UNIT.Items.Events.Gain.DUMMY_TRIGGER.Disable()
                call UNIT.Items.Events.Lose.DUMMY_TRIGGER.Disable()

                call BJUnit.Damage.Add(Unit(this).self, Real.ToInt(value) - Real.ToInt(oldValue))

                call UNIT.Items.Events.Gain.DUMMY_TRIGGER.Enable()
                call UNIT.Items.Events.Lose.DUMMY_TRIGGER.Enable()
            endmethod

            static method Event_Selection takes nothing returns nothing
                local Unit parent = UNIT.Event.GetTrigger()

                set thistype(parent).waitForSelection = false
                call parent.Event.Remove(SELECTION_EVENT)

                call thistype(parent).UpdateDisplay(thistype(parent).Get(), thistype(parent).displayedValue)
            endmethod

            method Set takes real value returns nothing
                local real displayedValue = this.displayedValue

                set this.value = value

                if (value == displayedValue) then
                    if (waitForSelection) then
                        set this.waitForSelection = false
                        call Unit(this).Event.Remove(SELECTION_EVENT)
                    endif
                else
                    if (Unit(this).Selection.Count() > Memory.IntegerKeys.Table.EMPTY) then
                        call this.UpdateDisplay(value, displayedValue)
                    else
                        set this.waitForSelection = true
                        call Unit(this).Event.Add(SELECTION_EVENT)
                    endif
                endif

                call this.Bonus.Update()
            endmethod
        else
            method Set takes real value returns nothing
                local real oldValue = this.value

                set this.value = value

                call UNIT.Items.Events.Gain.DUMMY_TRIGGER.Disable()
                call UNIT.Items.Events.Lose.DUMMY_TRIGGER.Disable()

                call BJUnit.Damage.Add(Unit(this).self, Real.ToInt(value) - Real.ToInt(oldValue))

                call UNIT.Items.Events.Gain.DUMMY_TRIGGER.Enable()
                call UNIT.Items.Events.Lose.DUMMY_TRIGGER.Enable()

                call this.Bonus.Update()
            endmethod
        endif

        method Add takes real value returns nothing
            call this.Set(this.Get() + value)
        endmethod

        method Update takes nothing returns nothing
            call this.Set(this.Get())
        endmethod

        method Do takes Unit target, real amount, boolean triggerEvents returns real
            if (target.Invulnerability.Try()) then
                return 0.
            endif

            if (amount > 0.) then
                if triggerEvents then
                    set amount = this.Events.TriggerEvents(amount, target, false)
                endif

                set amount = Math.Min(amount, target.Life.Get())
                call UnitDamageTarget(Unit(this).self, target.self, 0., false, false, null, null, null)

                set UNIT.Life.DAMAGE_SOURCE = this

                call target.Life.Subtract(amount)

                return amount
            endif

            return 0.
        endmethod

        method CreateSpellTextTag takes Unit target, boolean magical, real amount, boolean crit returns nothing
            if (amount > 0.) then
                if magical then
                    call target.ReplaceRisingTextTagIfMinorValue(String.Color.Gradient("~" + Real.ToIntString(amount) + String.If(crit, Char.EXCLAMATION_MARK) + "~", Unit(this).Owner.Get().GetColorString(), String.Color.MAGENTA), Math.Linear(amount, target.MaxLife.GetAll() / 2., 0.016, 0.022), 160., 0., 1., thistype(NULL).Events.TEXT_TAG_KEY_ARRAY + target, amount / 2)
                else
                    call target.ReplaceRisingTextTagIfMinorValue(String.Color.Do(Real.ToIntString(amount) + String.If(crit, Char.EXCLAMATION_MARK), Unit(this).Owner.Get().GetColorString()), Math.Linear(amount, target.MaxLife.GetAll() / 2., 0.016, 0.022), 160., 0., 1., thistype(NULL).Events.TEXT_TAG_KEY_ARRAY + target, amount / 2)
                endif
            endif
        endmethod

        method DoBySpell takes Unit target, real amount, boolean magical, boolean triggerEvents returns real
            local boolean crit = false
            local real result

            if (amount > 0.) then
                if (magical) then
                    if (target.MagicImmunity.Try()) then
                        return 0.
                    endif

                    set amount = amount * Unit(this).SpellPower.GetDamageFactor(target.SpellPower.GetAll() - Unit(this).SpellPower.GetAll()) * Math.Random(0.9, 1.1)
                else
                    set amount = amount * Unit(this).Armor.GetDamageFactor(target.Armor.GetAll())
                endif

                if ((magical == false) and Unit(this).CriticalChance.Random(target)) then
                    set amount = amount * UNIT.CriticalChance.DAMAGE_FACTOR
                    set crit = true
                endif
            endif

            set result = this.Do(target, amount, triggerEvents)

            call this.CreateSpellTextTag(target, magical, amount, crit)

            return result
        endmethod

        static method Event_TypeChange takes nothing returns nothing
            local UnitType sourceType = UNIT_TYPE.Event.GetSource()
            local UnitType targetType = UNIT_TYPE.Event.GetTrigger()
            local thistype this = UNIT.Event.GetTrigger()

            static if (thistype.WAIT_FOR_SELECTION) then
                set this.displayedValue = targetType.Damage.GetBJ()
                set this.waitForSelection = false
            endif

            call this.Add(targetType.Damage.Get() - sourceType.Damage.Get())
        endmethod

        method Event_Create takes nothing returns nothing
            local UnitType thisType = Unit(this).Type.Get()

            static if (thistype.WAIT_FOR_SELECTION) then
                set this.displayedValue = thisType.Damage.GetBJ()
                set this.waitForSelection = false
            endif

            call this.Bonus.Event_Create()
            call this.Delay.Event_Create()
            call this.Dices.Event_Create()
            call this.Events.Event_Create()
            call this.Relative.Event_Create()
            call this.Sides.Event_Create()
            call this.SpellRelative.Event_Create()
            call this.TypeA.Event_Create()

            call this.Set(thisType.Damage.Get())
        endmethod

        static method Init takes nothing returns nothing
            call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
            static if (thistype.WAIT_FOR_SELECTION) then
                set thistype.SELECTION_EVENT = Event.Create(UNIT.Selection.START_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Selection)
            endif

            call thistype(NULL).Bonus.Init()
            call thistype(NULL).Dices.Init()
            call thistype(NULL).Events.Init()
            call thistype(NULL).Sides.Init()
            call thistype(NULL).TypeA.Init()
        endmethod
    endstruct

    //! runtextmacro Folder("MagicImmunity")
        //! runtextmacro Struct("SpellShield")
            //! runtextmacro GetKeyArray("KEY_ARRAY")
            static constant string TRY_TEXT = "Blocked!!"

            //! runtextmacro CreateSimpleAddState_OnlyGet("integer")

            method Is takes nothing returns boolean
                return (this.Get() > 0)
            endmethod

            static method Event_BuffLose takes nothing returns nothing
                local Buff whichBuff = BUFF.Event.GetTrigger()
                local Unit parent = UNIT.Event.GetTrigger()

                local thistype this = parent

                set this.value = this.Get() - 1
                call parent.Data.Integer.Table.Remove(KEY_ARRAY, whichBuff)
            endmethod

            static method Event_BuffGain takes nothing returns nothing
                local Buff whichBuff = BUFF.Event.GetTrigger()

                local Unit parent = UNIT.Event.GetTrigger()

                local thistype this = parent

                set this.value = this.Get() + 1
                call parent.Data.Integer.Table.Add(KEY_ARRAY, whichBuff)
            endmethod

            method Subtract takes Buff whichBuff returns nothing
                call Unit(this).Buffs.Subtract(whichBuff)
            endmethod

            method Try takes nothing returns boolean
                if (this.Is() == false) then
                    return false
                endif

                call this.Subtract(Unit(this).Data.Integer.Table.Get(KEY_ARRAY, Memory.IntegerKeys.Table.STARTED))
                call Unit(this).AddJumpingTextTag(String.Color.Do(thistype.TRY_TEXT, "d4e019aa"), 0.02, KEY_ARRAY + this)
                call Unit(this).Effects.Create("Abilities\\Spells\\Other\\HealingSpray\\HealBottleMissile.mdl", AttachPoint.CHEST, EffectLevel.LOW).Destroy()

                return true
            endmethod

            method Add takes Buff whichBuff returns nothing
                call Unit(this).Buffs.Add(whichBuff, 1)
            endmethod

            method AddTimed takes real duration, Buff whichBuff returns nothing
                call Unit(this).Buffs.Timed.Start(whichBuff, 1, duration)
            endmethod

            method Event_Create takes nothing returns nothing
                set this.value = 0
            endmethod

            static method Init takes nothing returns nothing
                local Buff currentBuff

                set currentBuff = thistype.NORMAL_BUFF

                call currentBuff.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_BuffGain))
                call currentBuff.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_BuffLose))
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("MagicImmunity")
        //! runtextmacro GetKeyArray("KEY_ARRAY")
        static constant string TRY_TEXT = "Magic immune!!"

        //! runtextmacro LinkToStruct("MagicImmunity", "SpellShield")

        //! runtextmacro CreateSimpleAddState_OnlyGet("integer")

        method Is takes nothing returns boolean
            return (this.Get() > 0)
        endmethod

        method Try takes nothing returns boolean
            if (this.Is() == false) then
                return this.SpellShield.Try()
            endif

            call Unit(this).AddJumpingTextTag(String.Color.Do(thistype.TRY_TEXT, "d4e019aa"), 0.02, KEY_ARRAY + this)

            return true
        endmethod

        static method Event_BuffLose takes nothing returns nothing
            local Unit parent = UNIT.Event.GetTrigger()

            local thistype this = parent

            local integer value = this.Get() - 1

            set this.value = value
            if (value == 0) then
            endif
        endmethod

        method Subtract takes Buff whichBuff returns nothing
            call Unit(this).Buffs.Subtract(whichBuff)
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local Unit parent = UNIT.Event.GetTrigger()

            local thistype this = parent

            local integer value = this.Get() + 1

            set this.value = value
            if (value == 1) then
            endif
        endmethod

        method Add takes Buff whichBuff returns nothing
            call Unit(this).Buffs.Add(whichBuff, 1)
        endmethod

        method AddTimed takes real duration, Buff whichBuff returns nothing
            call Unit(this).Buffs.Timed.Start(whichBuff, 1, duration)
        endmethod

        method Update takes nothing returns nothing
        endmethod

        method Event_Create takes nothing returns nothing
            set this.value = 0

            call this.SpellShield.Event_Create()
        endmethod

        static method Init takes nothing returns nothing
            local Buff currentBuff

            set currentBuff = thistype.NONE_BUFF

            call currentBuff.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_BuffGain))
            call currentBuff.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_BuffLose))

            set currentBuff = thistype.NORMAL_BUFF

            call currentBuff.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_BuffGain))
            call currentBuff.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_BuffLose))

            call thistype(NULL).SpellShield.Init()
        endmethod
    endstruct

    //! runtextmacro Folder("Scale")
        //! runtextmacro Struct("Timed")
            static Event DESTROY_EVENT
            //! runtextmacro GetKey("KEY")
            //! runtextmacro GetKeyArray("KEY_ARRAY")
            //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "1")
            static Timer UPDATE_TIMER

            real bonusScalePerInterval
            Timer durationTimer
            Unit parent

            private method Ending takes Timer durationTimer, Unit parent returns nothing
                call this.deallocate()
                call durationTimer.Destroy()
                if (parent.Data.Integer.Table.Remove(KEY_ARRAY, this)) then
                    call parent.Event.Remove(DESTROY_EVENT)
                endif
                if (this.RemoveFromList()) then
                    call thistype.UPDATE_TIMER.Pause()
                endif
            endmethod

            static method Event_Destroy takes nothing returns nothing
                local Unit parent = UNIT.Event.GetTrigger()
                local thistype this

                local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

                loop
                    set this = parent.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                    call this.Ending(this.durationTimer, parent)

                    set iteration = iteration - 1
                    exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
                endloop
            endmethod

            static method EndingByTimer takes nothing returns nothing
                local Timer durationTimer = Timer.GetExpired()

                local thistype this = durationTimer.GetData()

                call this.Ending(durationTimer, this.parent)
            endmethod

            static method Update takes nothing returns nothing
                local integer iteration = thistype.ALL_COUNT
                local thistype this

                loop
                    set this = thistype.ALL[iteration]

                    call this.parent.Scale.Add(this.bonusScalePerInterval)

                    set iteration = iteration - 1
                    exitwhen (iteration < ARRAY_MIN)
                endloop
            endmethod

            method Add takes real scale, real duration returns nothing
                local Timer durationTimer
                local Unit parent = this
                local integer wavesAmount

                if (duration == 0.) then
                    call Unit(this).Scale.Add(scale)

                    return
                endif

                set durationTimer = Timer.Create()
                set this = thistype.allocate()
                set wavesAmount = Real.ToInt(duration / thistype.UPDATE_TIME)

                set this.bonusScalePerInterval = scale / wavesAmount
                set this.durationTimer = durationTimer
                set this.parent = parent
                call durationTimer.SetData(this)
                if (parent.Data.Integer.Table.Add(KEY_ARRAY, this)) then
                    call parent.Event.Add(DESTROY_EVENT)
                endif

                if (this.AddToList()) then
                    call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.Update)
                endif

                call durationTimer.Start(duration, false, function thistype.EndingByTimer)
            endmethod

            method Subtract takes real scale, real duration returns nothing
                call this.Add(-scale, duration)
            endmethod

            static method Init takes nothing returns nothing
                set thistype.DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
                set thistype.UPDATE_TIMER = Timer.Create()
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Scale")
        //! runtextmacro LinkToStruct("Scale", "Timed")

        //! runtextmacro CreateSimpleAddState_OnlyGet("real")

        method Set takes real value returns nothing
            set this.value = value
            call SetUnitScale(Unit(this).self, value, value, value)
        endmethod

        //! runtextmacro CreateSimpleAddState_OnlyAdd("real", "Unit(this).Type.Get().Scale.Get()")

        static method Event_TypeChange takes nothing returns nothing
            local UnitType sourceType = UNIT_TYPE.Event.GetSource()
            local UnitType targetType = UNIT_TYPE.Event.GetTrigger()
            local thistype this = UNIT.Event.GetTrigger()

            call this.Add(targetType.Scale.Get() - sourceType.Scale.Get())
        endmethod

        static method Init takes nothing returns nothing
            call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()

            call thistype(NULL).Timed.Init()
        endmethod
    endstruct

    //! runtextmacro Folder("VertexColor")
        //! runtextmacro Struct("Red")
            //! runtextmacro CreateSimpleAddState("real", "Unit(this).Type.Get().VertexColor.Red.Get()")
        endstruct

        //! runtextmacro Struct("Green")
            //! runtextmacro CreateSimpleAddState("real", "Unit(this).Type.Get().VertexColor.Green.Get()")
        endstruct

        //! runtextmacro Struct("Blue")
            //! runtextmacro CreateSimpleAddState("real", "Unit(this).Type.Get().VertexColor.Blue.Get()")
        endstruct

        //! runtextmacro Struct("Alpha")
            //! runtextmacro CreateSimpleAddState("real", "Unit(this).Type.Get().VertexColor.Alpha.Get()")
        endstruct

        //! runtextmacro Struct("Timed")
            static Event DESTROY_EVENT
            //! runtextmacro GetKey("KEY")
            //! runtextmacro GetKeyArray("KEY_ARRAY")
            //! runtextmacro CreateTimeByFramesAmount("UPDATE_TIME", "8")
            static Timer UPDATE_TIMER

            real bonusRedPerInterval
            real bonusGreenPerInterval
            real bonusBluePerInterval
            real bonusAlphaPerInterval
            Timer durationTimer
            Unit parent

            private method Ending takes Timer durationTimer, Unit parent returns nothing
                call this.deallocate()
                call durationTimer.Destroy()
                if (parent.Data.Integer.Table.Remove(KEY_ARRAY, this)) then
                    call parent.Event.Remove(DESTROY_EVENT)
                endif
                if (this.RemoveFromList()) then
                    call thistype.UPDATE_TIMER.Pause()
                endif
            endmethod

            static method Event_Destroy takes nothing returns nothing
                local Unit parent = UNIT.Event.GetTrigger()
                local thistype this

                local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

                loop
                    set this = parent.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                    call this.Ending(this.durationTimer, parent)

                    set iteration = iteration - 1
                    exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
                endloop
            endmethod

            static method EndingByTimer takes nothing returns nothing
                local Timer durationTimer = Timer.GetExpired()

                local thistype this = durationTimer.GetData()

                call this.Ending(durationTimer, this.parent)
            endmethod

            static method Update takes nothing returns nothing
                local integer iteration = thistype.ALL_COUNT
                local thistype this

                loop
                    set this = thistype.ALL[iteration]

                    call this.parent.VertexColor.Add(this.bonusRedPerInterval, this.bonusGreenPerInterval, this.bonusBluePerInterval, this.bonusAlphaPerInterval)

                    set iteration = iteration - 1
                    exitwhen (iteration < ARRAY_MIN)
                endloop
            endmethod

            method Add takes real red, real green, real blue, real alpha, real duration returns nothing
                local Timer durationTimer
                local Unit parent = this
                local integer wavesAmount

                if (duration == 0.) then
                    call Unit(this).VertexColor.Add(red, green, blue, alpha)

                    return
                endif

                set durationTimer = Timer.Create()
                set this = thistype.allocate()
                set wavesAmount = Real.ToInt(duration / UPDATE_TIME)

                set this.bonusRedPerInterval = red / wavesAmount
                set this.bonusGreenPerInterval = green / wavesAmount
                set this.bonusBluePerInterval = blue / wavesAmount
                set this.bonusAlphaPerInterval = alpha / wavesAmount
                set this.durationTimer = durationTimer
                set this.parent = parent
                call durationTimer.SetData(this)
                if (parent.Data.Integer.Table.Add(KEY_ARRAY, this)) then
                    call parent.Event.Add(DESTROY_EVENT)
                endif

                if (this.AddToList()) then
                    call thistype.UPDATE_TIMER.Start(UPDATE_TIME, true, function thistype.Update)
                endif

                call durationTimer.Start(duration, false, function thistype.EndingByTimer)
            endmethod

            method Subtract takes real red, real green, real blue, real alpha, real duration returns nothing
                call this.Add(-red, -green, -blue, -alpha, duration)
            endmethod

            static method Init takes nothing returns nothing
                set thistype.DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
                set thistype.UPDATE_TIMER = Timer.Create()
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("VertexColor")
        static Event DESTROY_EVENT
        //! runtextmacro GetKey("KEY")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro GetKeyArray("RED_KEY_ARRAY_DETAIL")
        //! runtextmacro GetKeyArray("GREEN_KEY_ARRAY_DETAIL")
        //! runtextmacro GetKeyArray("BLUE_KEY_ARRAY_DETAIL")
        //! runtextmacro GetKeyArray("ALPHA_KEY_ARRAY_DETAIL")

        //! runtextmacro LinkToStruct("VertexColor", "Red")
        //! runtextmacro LinkToStruct("VertexColor", "Green")
        //! runtextmacro LinkToStruct("VertexColor", "Blue")
        //! runtextmacro LinkToStruct("VertexColor", "Alpha")

        //! runtextmacro LinkToStruct("VertexColor", "Timed")

        //! runtextmacro CreateSimpleAddState_OnlyGet("real")

        method GetRedForPlayer takes User whichPlayer returns real
            return Unit(this).Data.Real.Get(RED_KEY_ARRAY_DETAIL + whichPlayer)
        endmethod

        method GetGreenForPlayer takes User whichPlayer returns real
            return Unit(this).Data.Real.Get(GREEN_KEY_ARRAY_DETAIL + whichPlayer)
        endmethod

        method GetBlueForPlayer takes User whichPlayer returns real
            return Unit(this).Data.Real.Get(BLUE_KEY_ARRAY_DETAIL + whichPlayer)
        endmethod

        method GetAlphaForPlayer takes User whichPlayer returns real
            return Unit(this).Data.Real.Get(ALPHA_KEY_ARRAY_DETAIL + whichPlayer)
        endmethod

        method Set takes real red, real green, real blue, real alpha returns nothing
            local User whichPlayer = User.GetLocal()

            call this.Red.Set(red)
            call this.Green.Set(green)
            call this.Blue.Set(blue)
            call this.Alpha.Set(alpha)
            if (Unit(this).Invisibility.Is()) then
                set alpha = UNIT.Invisibility.ALPHA
            endif

            call SetUnitVertexColor(Unit(this).self, Real.ToInt(red + this.GetRedForPlayer(whichPlayer)), Real.ToInt(green + this.GetGreenForPlayer(whichPlayer)), Real.ToInt(blue + this.GetBlueForPlayer(whichPlayer)), Real.ToInt(alpha + this.GetAlphaForPlayer(whichPlayer)))
        endmethod

        static method Event_Destroy takes nothing returns nothing
            local Unit parent = UNIT.Event.GetTrigger()
            local User whichPlayer

            local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

            call parent.Event.Remove(DESTROY_EVENT)
            loop
                set whichPlayer = parent.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                call parent.Data.Integer.Table.Remove(KEY_ARRAY, whichPlayer)
                call parent.Data.Integer.Remove(RED_KEY_ARRAY_DETAIL + whichPlayer)
                call parent.Data.Integer.Remove(GREEN_KEY_ARRAY_DETAIL + whichPlayer)
                call parent.Data.Integer.Remove(BLUE_KEY_ARRAY_DETAIL + whichPlayer)
                call parent.Data.Integer.Remove(ALPHA_KEY_ARRAY_DETAIL + whichPlayer)
                call whichPlayer.Data.Integer.Remove(KEY)

                set iteration = iteration - 1
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
            endloop
        endmethod

        method SetForPlayer takes real red, real green, real blue, real alpha, User whichPlayer returns nothing
            if (whichPlayer.Data.Boolean.Is(KEY) == false) then
                call whichPlayer.Data.Boolean.Add(KEY)
                if (Unit(this).Data.Integer.Table.Add(KEY_ARRAY, whichPlayer)) then
                    call Unit(this).Event.Add(DESTROY_EVENT)
                endif
            endif
            call Unit(this).Data.Real.Set(RED_KEY_ARRAY_DETAIL + whichPlayer, red)
            call Unit(this).Data.Real.Set(GREEN_KEY_ARRAY_DETAIL + whichPlayer, green)
            call Unit(this).Data.Real.Set(BLUE_KEY_ARRAY_DETAIL + whichPlayer, blue)
            call Unit(this).Data.Real.Set(ALPHA_KEY_ARRAY_DETAIL + whichPlayer, alpha)
            call SetUnitVertexColor(Unit(this).self, Real.ToInt(this.Red.Get() + red), Real.ToInt(this.Green.Get() + green), Real.ToInt(this.Blue.Get() + blue), Real.ToInt(this.Alpha.Get() + alpha))
        endmethod

        method Add takes real red, real green, real blue, real alpha returns nothing
            call this.Set(this.Red.Get() + red, this.Green.Get() + green, this.Blue.Get() + blue, this.Alpha.Get() + alpha)
        endmethod

        method AddForPlayer takes real red, real green, real blue, real alpha, User whichPlayer returns nothing
            call this.SetForPlayer(this.GetRedForPlayer(whichPlayer) + red, this.GetGreenForPlayer(whichPlayer) + green, this.GetBlueForPlayer(whichPlayer) + blue, this.GetAlphaForPlayer(whichPlayer) + alpha, whichPlayer)
        endmethod

        method Subtract takes real red, real green, real blue, real alpha returns nothing
            call this.Add(-red, -green, -blue, -alpha)
        endmethod

        method SubtractForPlayer takes real red, real green, real blue, real alpha, User whichPlayer returns nothing
            call this.AddForPlayer(-red, -green, -blue, -alpha, whichPlayer)
        endmethod

        method Update takes nothing returns nothing
            call this.Set(this.Red.Get(), this.Green.Get(), this.Blue.Get(), this.Alpha.Get())
        endmethod

        static method Event_TypeChange takes nothing returns nothing
            local UnitType sourceType = UNIT_TYPE.Event.GetSource()
            local UnitType targetType = UNIT_TYPE.Event.GetTrigger()
            local thistype this = UNIT.Event.GetTrigger()

            call this.Add(targetType.VertexColor.Red.Get() - sourceType.VertexColor.Red.Get(), targetType.VertexColor.Green.Get() - sourceType.VertexColor.Green.Get(), targetType.VertexColor.Blue.Get() - sourceType.VertexColor.Blue.Get(), targetType.VertexColor.Alpha.Get() - sourceType.VertexColor.Alpha.Get())
        endmethod

        method Event_Create takes nothing returns nothing
            local UnitType thisType = Unit(this).Type.Get()

            call this.Set(thisType.VertexColor.Red.Get(), thisType.VertexColor.Green.Get(), thisType.VertexColor.Blue.Get(), thisType.VertexColor.Alpha.Get())
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
            call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()

            call thistype(NULL).Timed.Init()
        endmethod
    endstruct

    //! runtextmacro Struct("Cold")
        static constant real ATTACK_SPEED_INCREMENT = -0.1
        static Event DAMAGE_EVENT
        static constant real EXTRA_DAMAGE_FACTOR = 1.35
        static constant real EXTRA_DAMAGE_LIFE_THRESHOLD = 0.35
        static constant real MOVE_SPEED_INCREMENT = -0.2

        static constant real RED_INCREMENT = -150.
        static constant real GREEN_INCREMENT = -150.
        static constant real BLUE_INCREMENT = 0.
        static constant real ALPHA_INCREMENT = 0.

        //! runtextmacro CreateSimpleAddState_OnlyGet("integer")

        static method Event_BuffLose takes nothing returns nothing
            local Unit parent = UNIT.Event.GetTrigger()

            local thistype this = parent

            local integer value = this.Get() - 1

            set this.value = value
            if (value == 0) then
                call Unit(this).Event.Remove(DAMAGE_EVENT)

                call parent.Attack.Speed.BonusA.Subtract(thistype.ATTACK_SPEED_INCREMENT)
                call parent.Movement.Speed.RelativeA.Subtract(thistype.MOVE_SPEED_INCREMENT)
                call parent.VertexColor.Subtract(thistype.RED_INCREMENT, thistype.GREEN_INCREMENT, thistype.BLUE_INCREMENT, thistype.ALPHA_INCREMENT)
            endif
        endmethod

        method Subtract takes nothing returns nothing
            call Unit(this).Buffs.Subtract(thistype.DUMMY_BUFF)
        endmethod

        static method Event_Damage takes nothing returns nothing
            local Unit parent = UNIT.Event.GetTrigger()

            if (parent.Life.Get() / parent.MaxLife.GetAll() > thistype.EXTRA_DAMAGE_LIFE_THRESHOLD) then
                return
            endif

            call TRIGGER.Event.SetDamage(TRIGGER.Event.GetDamage() * thistype.EXTRA_DAMAGE_FACTOR)
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local Unit parent = UNIT.Event.GetTrigger()

            local thistype this = parent

            local integer value = this.Get() + 1

            set this.value = value
            if (value == 1) then
                call parent.Event.Add(DAMAGE_EVENT)

                call parent.Attack.Speed.BonusA.Add(thistype.ATTACK_SPEED_INCREMENT)
                call parent.Movement.Speed.RelativeA.Add(thistype.MOVE_SPEED_INCREMENT)
                call parent.VertexColor.Add(thistype.RED_INCREMENT, thistype.GREEN_INCREMENT, thistype.BLUE_INCREMENT, thistype.ALPHA_INCREMENT)
            endif
        endmethod

        method Add takes nothing returns nothing
            call Unit(this).Buffs.Add(thistype.DUMMY_BUFF, 1)
        endmethod

        method AddTimed takes real duration returns nothing
            call Unit(this).Buffs.Timed.Start(thistype.DUMMY_BUFF, 1, duration)
        endmethod

        //! runtextmacro CreateSimpleAddState_OnlyStart("0")

        static method Init takes nothing returns nothing
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))

            set thistype.DAMAGE_EVENT = Event.Create(UNIT.Damage.Events.TARGET_EDIT_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Damage)
        endmethod
    endstruct

    //! runtextmacro Folder("Invisibility")
        //! runtextmacro Struct("Reveal")
            static constant real STANDARD_DURATION = 2.

            //! runtextmacro CreateSimpleAddState_OnlyGet("integer")

            method Is takes nothing returns boolean
                return (this.Get() > 0)
            endmethod

            static method Event_BuffLose takes nothing returns nothing
                local Unit parent = UNIT.Event.GetTrigger()

                local thistype this = parent

                local integer value = this.Get() - 1

                set this.value = value
                if (value == 0) then
                    if (parent.Invisibility.Is()) then
                        call parent.Abilities.AddBySelf(UNIT.Invisibility.DUMMY_SPELL_ID)
                    endif
                endif
            endmethod

            method Subtract takes nothing returns nothing
                call Unit(this).Buffs.Subtract(thistype.DUMMY_BUFF)
            endmethod

            static method Event_BuffGain takes nothing returns nothing
                local Unit parent = UNIT.Event.GetTrigger()

                local thistype this = parent

                local integer value = this.Get() + 1

                set this.value = value
                if (value == 1) then
                    if (parent.Invisibility.Is()) then
                        call parent.Abilities.RemoveBySelf(UNIT.Invisibility.DUMMY_SPELL_ID)
                        call parent.Effects.Create("Abilities\\Spells\\NightElf\\FaerieDragonInvis\\FaerieDragon_Invis.mdl", AttachPoint.HEAD, EffectLevel.LOW).Destroy()

                        call SetUnitVertexColor(parent.self, Real.ToInt(parent.VertexColor.Red.Get()), Real.ToInt(parent.VertexColor.Green.Get()), Real.ToInt(parent.VertexColor.Blue.Get()), UNIT.Invisibility.ALPHA)
                    endif
                endif
            endmethod

            method Add takes nothing returns nothing
                call Unit(this).Buffs.Add(thistype.DUMMY_BUFF, 1)
            endmethod

            method AddTimed takes real duration returns nothing
                call Unit(this).Buffs.Timed.Start(thistype.DUMMY_BUFF, 1, duration)
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyStart("0")

            static method Init takes nothing returns nothing
                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Invisibility")
        static constant integer ALPHA = 128
        static Event ATTACK_EVENT
        static Event CAST_EVENT
        static EventType ENDING_EVENT_TYPE

        Timer attackTimer

        //! runtextmacro LinkToStruct("Invisibility", "Reveal")

        //! runtextmacro CreateSimpleAddState_OnlyGet("integer")

        method Is takes nothing returns boolean
            return (this.Get() > 0)
        endmethod

        method Ending_TriggerEvents takes nothing returns nothing
            local integer iteration = EventPriority.ALL_COUNT
            local integer iteration2
            local EventPriority priority

            loop
                exitwhen (iteration < ARRAY_MIN)

                set priority = EventPriority.ALL[iteration]

                set iteration2 = Unit(this).Event.Count(thistype.ENDING_EVENT_TYPE, priority)

                loop
                    exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                    call Event.SetSubjectId(Unit(this).Id.Get())
                    call UNIT.Event.SetTrigger(this)

                    call Unit(this).Event.Get(thistype.ENDING_EVENT_TYPE, priority, iteration2).Run()

                    set iteration2 = iteration2 - 1
                endloop

                set iteration = iteration - 1
            endloop
        endmethod

        static method EndingByAttackTimer takes nothing returns nothing
            local thistype this = Timer.GetExpired().GetData()

            local Unit parent = this

            call this.Reveal.AddTimed(UNIT.Invisibility.Reveal.STANDARD_DURATION)

            call parent.Buffs.Remove(thistype.TIMED_BUFF)
        endmethod

        static method Event_Attack takes nothing returns nothing
            local Unit parent = UNIT.Event.GetTrigger()

            local thistype this = parent

            call this.attackTimer.Start(parent.Damage.Delay.Get() + 0.01, false, function thistype.EndingByAttackTimer)
        endmethod

        static method Event_Cast takes nothing returns nothing
            local Unit parent = UNIT.Event.GetTrigger()

            call parent.Buffs.Remove(thistype.TIMED_BUFF)
        endmethod

        method Subtract takes nothing returns nothing
            call Unit(this).Buffs.Subtract(thistype.DUMMY_BUFF)
        endmethod

        static method Event_BuffLose takes nothing returns nothing
            local Unit parent = UNIT.Event.GetTrigger()

            local thistype this = parent

            local integer value = this.Get() - 1

            set this.value = value
            if (value == 0) then
                call parent.Event.Remove(ATTACK_EVENT)
                call parent.Event.Remove(CAST_EVENT)
                call this.attackTimer.Destroy()

                call parent.Abilities.RemoveBySelf(thistype.DUMMY_SPELL_ID)

                call parent.VertexColor.Update()

                call thistype(parent).Ending_TriggerEvents()
            endif
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local Timer attackTimer
            local Unit parent = UNIT.Event.GetTrigger()

            local thistype this = parent

            local integer value = this.Get() + 1

            set this.value = value
            if (value == 1) then
                if (this.Reveal.Is() == false) then
                    set attackTimer = Timer.Create()

                    set this.attackTimer = attackTimer
                    call attackTimer.SetData(this)
                    call parent.Event.Add(ATTACK_EVENT)
                    call parent.Event.Add(CAST_EVENT)

                    call parent.Abilities.AddBySelf(thistype.DUMMY_SPELL_ID)
                endif
            endif
        endmethod

        method Add takes nothing returns nothing
            call Unit(this).Buffs.Add(thistype.DUMMY_BUFF, 1)
        endmethod

        method AddTimed takes real duration returns nothing
            call Unit(this).Buffs.Timed.Start(thistype.TIMED_BUFF, 1, duration)
        endmethod

        method Event_Create takes nothing returns nothing
            set this.value = 0
            call this.Reveal.Event_Create()
        endmethod

        static method Init takes nothing returns nothing
            set thistype.ATTACK_EVENT = Event.Create(UNIT.Attack.Events.OFFENDED_REVERSED_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Attack)
            set thistype.CAST_EVENT = Event.Create(UNIT.Abilities.Events.Begin.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Attack)
            set thistype.ENDING_EVENT_TYPE = EventType.Create()

            call InitAbility(thistype.DUMMY_SPELL_ID)

            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))

            call thistype.TIMED_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.TIMED_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))

            call thistype(NULL).Reveal.Init()
        endmethod
    endstruct

    //! runtextmacro Struct("Ghost")
        //! runtextmacro CreateSimpleAddState_OnlyGet("integer")

        static method Event_BuffLose takes nothing returns nothing
            local Unit parent = UNIT.Event.GetTrigger()

            local thistype this = parent

            local integer value = this.Get() - 1

            set this.value = value
            if (value == 0) then
                call parent.Abilities.RemoveBySelf(thistype.DUMMY_SPELL_ID)

                call parent.VertexColor.Update()
            endif
        endmethod

        method Subtract takes nothing returns nothing
            call Unit(this).Buffs.Subtract(thistype.DUMMY_BUFF)
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local Unit parent = UNIT.Event.GetTrigger()

            local thistype this = parent

            local integer value = this.Get() + 1

            set this.value = value
            if (value == 1) then
                call parent.Abilities.AddBySelf(thistype.DUMMY_SPELL_ID)
            endif
        endmethod

        method Add takes nothing returns nothing
            call Unit(this).Buffs.Add(thistype.DUMMY_BUFF, 1)
        endmethod

        //! runtextmacro CreateSimpleAddState_OnlyStart("0")

        static method Init takes nothing returns nothing
            call InitAbility(thistype.DUMMY_SPELL_ID)

            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        endmethod
    endstruct

    //! runtextmacro Folder("MaxLife")
        //! runtextmacro Struct("Bonus")
            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).MaxLife.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            method Event_Create takes nothing returns nothing
                set this.value = 0.
            endmethod
        endstruct

        //! runtextmacro Struct("Relative")
            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                local real oldValue = this.Get()

                set this.value = value

                call Unit(this).MaxLife.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            method Event_Create takes nothing returns nothing
                set this.value = 1.
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("MaxLife")
        //! runtextmacro LinkToStruct("MaxLife", "Bonus")
        //! runtextmacro LinkToStruct("MaxLife", "Relative")

        method GetAll takes nothing returns real
            return (this.Get() * this.Relative.Get() + this.Bonus.Get())
        endmethod

        method SetEx takes real oldValue, real value returns nothing
            if (Unit(this).Life.Get() == 0.) then
                return
            endif

            call Unit(this).Life.Set(Unit(this).Life.Get() / oldValue * value)
        endmethod

        //! runtextmacro Unit_CreateStateWithTemporaryAbilities("MaxLife", "* this.Relative.Get() + this.Bonus.Get()")

        static method Event_TypeChange takes nothing returns nothing
            local UnitType sourceType = UNIT_TYPE.Event.GetSource()
            local UnitType targetType = UNIT_TYPE.Event.GetTrigger()
            local thistype this = UNIT.Event.GetTrigger()

            //set this.displayedValue = targetType.Life.GetBJ()
            set this.displayedValue = this.displayedValue + targetType.Life.GetBJ() - sourceType.Life.GetBJ()

            call this.Add(targetType.Life.Get() - sourceType.Life.Get())
        endmethod

        method Event_Create takes nothing returns nothing
            local UnitType thisType = Unit(this).Type.Get()

            set this.displayedValue = thisType.Life.GetBJ()
            set this.valueAll = 0.

            call this.Bonus.Event_Create()
            call this.Relative.Event_Create()

            call this.Set(thisType.Life.Get())
        endmethod

        static method Init takes nothing returns nothing
            call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
        endmethod
    endstruct

    //! runtextmacro Struct("Life")
        static Unit DAMAGE_SOURCE = NULL
        static EventType DUMMY_EVENT_TYPE
        static constant real LIMIT_OF_DEATH = 0.405

        static constant real IMMORTAL = thistype.LIMIT_OF_DEATH + 1.

        //! runtextmacro CreateSimpleAddState_OnlyGet("real")

        static method TriggerEvents takes Unit parent, real oldValue, real value returns nothing
            local integer iteration = EventPriority.ALL_COUNT
            local integer iteration2
            local limitop limitOperator
            local integer limitValue
            local EventPriority priority
            local Event whichEvent

            loop
                exitwhen (iteration < ARRAY_MIN)

                set priority = EventPriority.ALL[iteration]

                set iteration2 = parent.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                loop
                    exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                    set whichEvent = parent.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2)

                    if whichEvent.Limit.Is() then
                        set limitOperator = whichEvent.Limit.GetOperator()
                        set limitValue = whichEvent.Limit.GetValue()

                        if (Math.Compare(value, limitOperator, limitValue) and (Math.Compare(oldValue, limitOperator, limitValue) == false)) then
                            call Event.SetSubjectId(parent.Id.Get())
                            call Event.SetTrigger(whichEvent)
                            call UNIT.Event.SetTrigger(parent)

                            call whichEvent.Run()
                        endif
                    else
                        call Event.SetTrigger(whichEvent)
                        call UNIT.Event.SetTrigger(parent)

                        call whichEvent.Run()
                    endif

                    set iteration2 = iteration2 - 1
                endloop

                set iteration = iteration - 1
            endloop
        endmethod

        method Set takes real value returns nothing
            local real oldValue = this.Get()

            local boolean causesDeath = ((oldValue > thistype.LIMIT_OF_DEATH) and (value < thistype.LIMIT_OF_DEATH))

            set value = Math.Limit(value, 0., Unit(this).MaxLife.GetAll())

            set this.value = value
            if causesDeath then
                set UNIT.Death.Events.KILLER = thistype.DAMAGE_SOURCE
                call UNIT.Event.SetTrigger(this)

                call Unit(this).Death.Events.Before_Event_Life()
            endif

            //call SetUnitState(Unit(this).self, UNIT_STATE_LIFE, value)
            call SetWidgetLife(Unit(this).self, value)

            if causesDeath then
                set UNIT.Death.Events.KILLER = NULL
            endif

            call thistype.TriggerEvents(this, oldValue, value)
        endmethod

        //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

        method Event_Create takes nothing returns nothing
            call this.Set(Unit(this).MaxLife.Get())
        endmethod

        method UpdateByNative takes nothing returns nothing
            call this.Set(GetUnitState(Unit(this).self, UNIT_STATE_LIFE))
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DUMMY_EVENT_TYPE = EventType.Create()
        endmethod
    endstruct

    //! runtextmacro Folder("LifeRegeneration")
        //! runtextmacro Struct("Bonus")
            //! runtextmacro CreateSimpleAddState("real", "0.")
        endstruct

        //! runtextmacro Struct("Disablement")
            //! runtextmacro CreateSimpleAddState_OnlyGet("integer")

            static method Event_BuffLose takes nothing returns nothing
                local Unit parent = UNIT.Event.GetTrigger()

                local thistype this = parent

                local integer value = this.Get() - 1

                set this.value = value
                if (value == 0) then
                    if (parent.LifeRegeneration.Get() > 0.) then
                        call Unit(this).LifeRegeneration.Activate()
                    endif
                endif
            endmethod

            method Subtract takes nothing returns nothing
                call Unit(this).Buffs.Subtract(thistype.DUMMY_BUFF)
            endmethod

            static method Event_BuffGain takes nothing returns nothing
                local Unit parent = UNIT.Event.GetTrigger()

                local thistype this = parent

                local integer value = this.Get() + 1

                set this.value = value
                if (value == 1) then
                    call Unit(this).LifeRegeneration.Deactivate()
                endif
            endmethod

            method Add takes nothing returns nothing
                call Unit(this).Buffs.Add(thistype.DUMMY_BUFF, 1)
            endmethod

            static method Event_Death takes nothing returns nothing
                call thistype(UNIT.Event.GetTrigger()).Add()
            endmethod

            static method Event_Revive takes nothing returns nothing
                call thistype(UNIT.Event.GetTrigger()).Subtract()
            endmethod

            static method Init takes nothing returns nothing
                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))

                call Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Death).AddToStatics()
                call Event.Create(UNIT.Revival.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Revive).AddToStatics()
            endmethod
        endstruct

        //! runtextmacro Struct("Relative")
            //! runtextmacro CreateSimpleAddState("real", "1.")
        endstruct
    endscope

    //! runtextmacro Struct("LifeRegeneration")
        static constant real INTERVAL = 1.
        static Timer INTERVAL_TIMER

        //! runtextmacro LinkToStruct("LifeRegeneration", "Bonus")
        //! runtextmacro LinkToStruct("LifeRegeneration", "Disablement")
        //! runtextmacro LinkToStruct("LifeRegeneration", "Relative")

        //! runtextmacro CreateList("ACTIVE_LIST")
        //! runtextmacro CreateForEachList("FOR_EACH_LIST", "ACTIVE_LIST")
        //! runtextmacro CreateSimpleAddState_OnlyGet("real")

        method GetAll takes nothing returns real
            return (this.Get() * this.Relative.Get() + this.Bonus.Get())
        endmethod

        method Disable takes nothing returns nothing
            call this.Disablement.Add()
        endmethod

        method Enable takes nothing returns nothing
            call this.Disablement.Subtract()
        endmethod

        static method Interval takes nothing returns nothing
            local thistype this

            call thistype.FOR_EACH_LIST_Set()

            loop
                set this = thistype.FOR_EACH_LIST_FetchFirst()

                exitwhen (this == NULL)

                call Unit(this).Life.Add(this.GetAll() * thistype.INTERVAL)
            endloop
        endmethod

        method Activate takes nothing returns nothing
            if (thistype.ACTIVE_LIST_Add(this)) then
                call thistype.INTERVAL_TIMER.Start(thistype.INTERVAL, true, function thistype.Interval)
            endif
        endmethod

        method Deactivate takes nothing returns nothing
            if (thistype.ACTIVE_LIST_Remove(this)) then
                call thistype.INTERVAL_TIMER.Pause()
            endif
        endmethod

        static method Event_Destroy takes nothing returns nothing
            local thistype this = UNIT.Event.GetTrigger()

            call this.Deactivate()
        endmethod

        static method Event_Death takes nothing returns nothing
            call thistype(UNIT.Event.GetTrigger()).Disable()
        endmethod

        static method Event_Revive takes nothing returns nothing
            call thistype(UNIT.Event.GetTrigger()).Enable()
        endmethod

        method Set takes real value returns nothing
            local real oldValue = this.value

            set this.value = value

            if ((oldValue > 0.) == (value > 0.)) then
                return
            endif

            if (Unit(this).Buffs.Contains(thistype(NULL).Disablement.DUMMY_BUFF)) then
                return
            endif

            if (value > 0.) then
                call this.Activate()
            else
                call this.Deactivate()
            endif
        endmethod

        //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

        static method Event_TypeChange takes nothing returns nothing
            local UnitType sourceType = UNIT_TYPE.Event.GetSource()
            local UnitType targetType = UNIT_TYPE.Event.GetTrigger()
            local thistype this = UNIT.Event.GetTrigger()

            call this.Add(targetType.LifeRegeneration.Get() - sourceType.LifeRegeneration.Get())
        endmethod

        method Event_Create takes nothing returns nothing
            set this.value = 0.

            call this.Set(Unit(this).Type.Get().LifeRegeneration.Get())

            call this.Bonus.Event_Create()
            call this.Relative.Event_Create()
        endmethod

        static method Init takes nothing returns nothing
            set thistype.INTERVAL_TIMER = Timer.Create()
            call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
            call Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Death).AddToStatics()
            call Event.Create(UNIT.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy).AddToStatics()
            call Event.Create(UNIT.Revival.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Revive).AddToStatics()

            call thistype(NULL).Disablement.Init()
        endmethod
    endstruct

    //! runtextmacro Folder("MaxMana")
        //! runtextmacro Struct("Bonus")
            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).MaxMana.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            method Event_Create takes nothing returns nothing
                set this.value = 0.
            endmethod
        endstruct

        //! runtextmacro Struct("Relative")
            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).MaxMana.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            method Event_Create takes nothing returns nothing
                set this.value = 1.
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("MaxMana")
        //! runtextmacro LinkToStruct("MaxMana", "Bonus")
        //! runtextmacro LinkToStruct("MaxMana", "Relative")

        method GetAll takes nothing returns real
            return (this.Get() * this.Relative.Get() + this.Bonus.Get())
        endmethod

        method SetEx takes real oldValue, real value returns nothing
            if (Unit(this).Mana.Get() == 0.) then
                return
            endif

            call Unit(this).Mana.Set(Unit(this).Mana.Get() / oldValue * value)
        endmethod

        //! runtextmacro Unit_CreateStateWithTemporaryAbilities("MaxMana", "* this.Relative.Get() + this.Bonus.Get()")

        static method Event_TypeChange takes nothing returns nothing
            local UnitType sourceType = UNIT_TYPE.Event.GetSource()
            local UnitType targetType = UNIT_TYPE.Event.GetTrigger()
            local thistype this = UNIT.Event.GetTrigger()

            //set this.displayedValue = targetType.Mana.GetBJ()
            set this.displayedValue = this.displayedValue + targetType.Mana.GetBJ() - sourceType.Mana.GetBJ()

            call this.Add(targetType.Mana.Get() - sourceType.Mana.Get())
        endmethod

        method Event_Create takes nothing returns nothing
            local UnitType thisType = Unit(this).Type.Get()

            set this.displayedValue = thisType.Mana.GetBJ()
            set this.valueAll = 0.

            call this.Bonus.Event_Create()
            call this.Relative.Event_Create()

            call this.Set(thisType.Mana.Get())
        endmethod

        static method Init takes nothing returns nothing
            call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
        endmethod
    endstruct

    //! runtextmacro Struct("Mana")
        static EventType DUMMY_EVENT_TYPE

        //! runtextmacro CreateSimpleAddState_OnlyGet("real")

        static method TriggerEvents takes Unit parent, real oldValue, real value returns nothing
            local integer iteration = EventPriority.ALL_COUNT
            local integer iteration2
            local limitop limitOperator
            local integer limitValue
            local EventPriority priority
            local Event whichEvent

            loop
                exitwhen (iteration < ARRAY_MIN)

                set priority = EventPriority.ALL[iteration]

                set iteration2 = parent.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                loop
                    exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                    set whichEvent = parent.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2)

                    set limitOperator = whichEvent.Limit.GetOperator()
                    set limitValue = whichEvent.Limit.GetValue()

                    if (Math.Compare(value, limitOperator, limitValue) and (Math.Compare(oldValue, limitOperator, limitValue) == false)) then
                        call Event.SetSubjectId(parent.Id.Get())
                        call Event.SetTrigger(whichEvent)
                        call UNIT.Event.SetTrigger(parent)

                        call whichEvent.Run()
                    endif

                    set iteration2 = iteration2 - 1
                endloop

                set iteration = iteration - 1
            endloop
        endmethod

        method Set takes real value returns nothing
            local real oldValue = this.Get()

            set value = Math.Limit(value, 0., Unit(this).MaxMana.GetAll())

            set this.value = value
            call SetUnitState(Unit(this).self, UNIT_STATE_MANA, value)

            call thistype.TriggerEvents(this, oldValue, value)
        endmethod

        //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

        method Event_Create takes nothing returns nothing
            call this.Set(Unit(this).MaxMana.Get())
        endmethod

        method SubtractNoNative takes real value returns nothing
            local real oldValue = this.Get()

            set value = Math.Limit(oldValue - value, 0., Unit(this).MaxMana.Get())

            set this.value = value

            call thistype.TriggerEvents(this, oldValue, value)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DUMMY_EVENT_TYPE = EventType.Create()
        endmethod
    endstruct

    //! runtextmacro Folder("ManaRegeneration")
        //! runtextmacro Struct("Bonus")
            //! runtextmacro CreateSimpleAddState("real", "0.")
        endstruct

        //! runtextmacro Struct("Disablement")
            //! runtextmacro CreateSimpleAddState_OnlyGet("integer")

            static method Event_BuffLose takes nothing returns nothing
                local Unit parent = UNIT.Event.GetTrigger()

                local thistype this = parent

                local integer value = this.Get() - 1

                set this.value = value
                if (value == 0) then
                    if (parent.ManaRegeneration.Get() > 0.) then
                        call Unit(this).ManaRegeneration.Activate()
                    endif
                endif
            endmethod

            method Subtract takes nothing returns nothing
                call Unit(this).Buffs.Subtract(thistype.DUMMY_BUFF)
            endmethod

            static method Event_BuffGain takes nothing returns nothing
                local Unit parent = UNIT.Event.GetTrigger()

                local thistype this = parent

                local integer value = this.Get() + 1

                set this.value = value
                if (value == 1) then
                    call Unit(this).ManaRegeneration.Deactivate()
                endif
            endmethod

            method Add takes nothing returns nothing
                call Unit(this).Buffs.Add(thistype.DUMMY_BUFF, 1)
            endmethod

            static method Event_Death takes nothing returns nothing
                call thistype(UNIT.Event.GetTrigger()).Add()
            endmethod

            static method Event_Revive takes nothing returns nothing
                call thistype(UNIT.Event.GetTrigger()).Subtract()
            endmethod

            static method Init takes nothing returns nothing
                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))

                call Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Death).AddToStatics()
                call Event.Create(UNIT.Revival.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Revive).AddToStatics()
            endmethod
        endstruct

        //! runtextmacro Struct("Relative")
            //! runtextmacro CreateSimpleAddState("real", "1.")
        endstruct
    endscope

    //! runtextmacro Struct("ManaRegeneration")
        static constant real INTERVAL = 1.
        static Timer INTERVAL_TIMER

        //! runtextmacro LinkToStruct("ManaRegeneration", "Bonus")
        //! runtextmacro LinkToStruct("ManaRegeneration", "Disablement")
        //! runtextmacro LinkToStruct("ManaRegeneration", "Relative")

        //! runtextmacro CreateList("ACTIVE_LIST")
        //! runtextmacro CreateForEachList("FOR_EACH_LIST", "ACTIVE_LIST")
        //! runtextmacro CreateSimpleAddState_OnlyGet("real")

        method GetAll takes nothing returns real
            return (this.Get() * this.Relative.Get() + this.Bonus.Get())
        endmethod

        method Disable takes nothing returns nothing
            call this.Disablement.Add()
        endmethod

        method Enable takes nothing returns nothing
            call this.Disablement.Subtract()
        endmethod

        static method Interval takes nothing returns nothing
            local thistype this

            call thistype.FOR_EACH_LIST_Set()

            loop
                set this = thistype.FOR_EACH_LIST_FetchFirst()

                exitwhen (this == NULL)

                call Unit(this).Mana.Add(this.GetAll() * thistype.INTERVAL)
            endloop
        endmethod

        method Activate takes nothing returns nothing
            if (thistype.ACTIVE_LIST_Add(this)) then
                call thistype.INTERVAL_TIMER.Start(thistype.INTERVAL, true, function thistype.Interval)
            endif
        endmethod

        method Deactivate takes nothing returns nothing
            if (thistype.ACTIVE_LIST_Remove(this)) then
                call thistype.INTERVAL_TIMER.Pause()
            endif
        endmethod

        static method Event_Destroy takes nothing returns nothing
            local thistype this = UNIT.Event.GetTrigger()

            call this.Deactivate()
        endmethod

        static method Event_Death takes nothing returns nothing
            call thistype(UNIT.Event.GetTrigger()).Disable()
        endmethod

        static method Event_Revive takes nothing returns nothing
            call thistype(UNIT.Event.GetTrigger()).Enable()
        endmethod

        method Set takes real value returns nothing
            local real oldValue = this.value

            set this.value = value

            if ((oldValue > 0.) == (value > 0.)) then
                return
            endif

            if (Unit(this).Buffs.Contains(thistype(NULL).Disablement.DUMMY_BUFF)) then
                return
            endif

            if (value > 0.) then
                call this.Activate()
            else
                call this.Deactivate()
            endif
        endmethod

        //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

        static method Event_TypeChange takes nothing returns nothing
            local UnitType sourceType = UNIT_TYPE.Event.GetSource()
            local UnitType targetType = UNIT_TYPE.Event.GetTrigger()
            local thistype this = UNIT.Event.GetTrigger()

            call this.Add(targetType.ManaRegeneration.Get() - sourceType.ManaRegeneration.Get())
        endmethod

        method Event_Create takes nothing returns nothing
            set this.value = 0.

            call this.Set(Unit(this).Type.Get().ManaRegeneration.Get())

            call this.Bonus.Event_Create()
            call this.Relative.Event_Create()
        endmethod

        static method Init takes nothing returns nothing
            set thistype.INTERVAL_TIMER = Timer.Create()
            call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
            call Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Death).AddToStatics()
            call Event.Create(UNIT.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy).AddToStatics()
            call Event.Create(UNIT.Revival.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Revive).AddToStatics()

            call thistype(NULL).Disablement.Init()
        endmethod
    endstruct

    //! runtextmacro Folder("Movement")
        //! runtextmacro Folder("Events")
            //! runtextmacro Struct("EnterRegion")
                static EventType DUMMY_EVENT_TYPE

                Group registeredGroup

                static method TrigConditions takes nothing returns boolean
                    return true
                endmethod

                static method Trig takes nothing returns nothing
                    local integer iteration = EventPriority.ALL_COUNT
                    local integer iteration2
                    local integer priority
                    local Unit parent = UNIT.Event.Native.GetTrigger()
                    local Region whichRegion = REGION.Event.Native.GetTrigger()

                    local thistype this = whichRegion

                    if (this.registeredGroup.ContainsUnit(parent) == false) then
                        return
                    endif

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        set priority = EventPriority.ALL[iteration]

                        set iteration2 = whichRegion.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call Event.SetSubjectId(whichRegion.Id.Get())
                            call UNIT.Event.SetTrigger(parent)

                            call whichRegion.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run()

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration = iteration - 1
                    endloop
                endmethod

                method Reg takes Region whichRegion returns nothing
                    local Unit parent = this

                    set this = whichRegion

                    call this.registeredGroup.AddUnit(parent)
                endmethod

                method Unreg takes Region whichRegion returns nothing
                    local Unit parent = this

                    set this = whichRegion

                    call this.registeredGroup.RemoveUnit(parent)
                endmethod

                static method InitRegion takes Region whichRegion returns nothing
                    local thistype this = whichRegion

                    set this.registeredGroup = Group.Create()

                    call Trigger.CreateFromCode(function thistype.Trig).RegisterEvent.EnterRegion(whichRegion, function thistype.TrigConditions)
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.DUMMY_EVENT_TYPE = EventType.Create()
                endmethod
            endstruct

            //! runtextmacro Struct("Interval")
                //! runtextmacro GetKeyArray("KEY_ARRAY")
                //! runtextmacro GetKeyArray("KEY_ARRAY_DETAIL")
                static Event MOVE_ENDING_EVENT
                static Event MOVE_START_EVENT

                real interval
                Timer intervalTimer
                Unit parent
                Event whichEvent
                real x
                real y

                static method Event_Move_Ending takes nothing returns nothing
                    local Unit parent = UNIT.Event.GetTrigger()
                    local thistype this

                    local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

                    loop
                        set this = parent.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                        call this.intervalTimer.Pause()

                        set iteration = iteration - 1
                        exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
                    endloop
                endmethod

                static method Interval takes nothing returns nothing
                    local thistype this = Timer.GetExpired().GetData()

                    local Unit parent = this.parent

                    local real parentX = parent.Position.X.Get()
                    local real parentY = parent.Position.Y.Get()

                    call Event.SetSubjectId(parent.Id.Get())
                    call Real.Event.SetTrigger(Math.DistanceSquareByDeltas(parentX - this.x, parentY - this.y))
                    call UNIT.Event.SetTrigger(parent)

                    set this.x = parentX
                    set this.y = parentY

                    call this.whichEvent.Run()
                endmethod

                static method Event_Move_Start takes nothing returns nothing
                    local Unit parent = UNIT.Event.GetTrigger()
                    local thistype this

                    local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

                    loop
                        set this = parent.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                        set this.x = parent.Position.X.Get()
                        set this.y = parent.Position.Y.Get()

                        call this.intervalTimer.Start(this.interval, true, function thistype.Interval)

                        set iteration = iteration - 1
                        exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
                    endloop
                endmethod

                method Remove takes Event whichEvent returns nothing
                    local Timer intervalTimer
                    local Unit parent = this

                    set this = whichEvent.Data.Integer.Get(KEY_ARRAY_DETAIL + parent)

                    if (this == NULL) then
                        return
                    endif

                    set intervalTimer = this.intervalTimer

                    call this.deallocate()
                    call intervalTimer.Destroy()
                    call whichEvent.Data.Integer.Remove(KEY_ARRAY_DETAIL + parent)
                    if (parent.Data.Integer.Table.Remove(KEY_ARRAY, this)) then
                        call parent.Event.Remove(MOVE_ENDING_EVENT)
                        call parent.Event.Remove(MOVE_START_EVENT)
                    endif
                endmethod

                method Add takes Event whichEvent, real interval returns nothing
                    local Timer intervalTimer = Timer.Create()
                    local Unit parent = this

                    set this = thistype.allocate()

                    set this.interval = interval
                    set this.intervalTimer = intervalTimer
                    set this.parent = parent
                    set this.whichEvent = whichEvent
                    call intervalTimer.SetData(this)
                    if (parent.Data.Integer.Table.Add(KEY_ARRAY, this)) then
                        call parent.Event.Add(MOVE_ENDING_EVENT)
                        call parent.Event.Add(MOVE_START_EVENT)
                    endif
                    call whichEvent.Data.Integer.Set(KEY_ARRAY_DETAIL + parent, this)
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.MOVE_ENDING_EVENT = Event.Create(UNIT.Movement.Events.ENDING_EVENT_TYPE, EventPriority.EVENTS, function thistype.Event_Move_Ending)
                    set thistype.MOVE_START_EVENT = Event.Create(UNIT.Movement.Events.START_EVENT_TYPE, EventPriority.EVENTS, function thistype.Event_Move_Start)
                endmethod
            endstruct

            //! runtextmacro Struct("LeaveRegion")
                static thistype DUMMY_EVENT_TYPE

                Group registeredGroup

                static method TrigConditions takes nothing returns boolean
                    return true
                endmethod

                static method Trig takes nothing returns nothing
                    local integer iteration = EventPriority.ALL_COUNT
                    local integer iteration2
                    local integer priority
                    local Unit parent = UNIT.Event.Native.GetTrigger()
                    local Region whichRegion = REGION.Event.Native.GetTrigger()

                    local thistype this = whichRegion

                    if (this.registeredGroup.ContainsUnit(parent) == false) then
                        return
                    endif

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        set priority = EventPriority.ALL[iteration]

                        set iteration2 = whichRegion.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call Event.SetSubjectId(whichRegion.Id.Get())
                            call UNIT.Event.SetTrigger(parent)

                            call whichRegion.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run()

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration = iteration - 1
                    endloop
                endmethod

                method Reg takes Region whichRegion returns nothing
                    local Unit parent = this

                    set this = whichRegion

                    call this.registeredGroup.AddUnit(parent)
                endmethod

                method Unreg takes Region whichRegion returns nothing
                    local Unit parent = this

                    set this = whichRegion

                    call this.registeredGroup.RemoveUnit(parent)
                endmethod

                static method InitRegion takes Region whichRegion returns nothing
                    local thistype this = whichRegion

                    set this.registeredGroup = Group.Create()

                    call Trigger.CreateFromCode(function thistype.Trig).RegisterEvent.LeaveRegion(whichRegion, function thistype.TrigConditions)
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.DUMMY_EVENT_TYPE = EventType.Create()
                endmethod
            endstruct
        endscope

        //! runtextmacro Struct("Events")
            static Trigger DUMMY_TRIGGER
            static EventType ENDING_EVENT_TYPE
            static Group ENUM_GROUP
            static Group EVENT_GROUP
            //! runtextmacro GetKey("KEY")
            static Group MOVING_GROUP
            static EventType START_EVENT_TYPE
            static constant real THRESHOLD = 0.1
            //! runtextmacro CreateTimeByFramesAmount("UPDATE_TIME", "8")
            static Timer UPDATE_TIMER

            static constant real THRESHOLD_SQUARE = (thistype.THRESHOLD * thistype.THRESHOLD)

            real x
            real y

            //! runtextmacro LinkToStruct("Events", "EnterRegion")
            //! runtextmacro LinkToStruct("Events", "Interval")
            //! runtextmacro LinkToStruct("Events", "LeaveRegion")

            method GetOldX takes nothing returns real
                return this.x
            endmethod

            method GetOldY takes nothing returns real
                return this.y
            endmethod

            method Ending_TriggerEvents takes real distanceSquare returns nothing
                local integer iteration = EventPriority.ALL_COUNT
                local integer iteration2
                local Unit parent = Unit(this)
                local integer priority

                loop
                    exitwhen (iteration < ARRAY_MIN)

                    set priority = EventPriority.ALL[iteration]

                    set iteration2 = parent.Event.Count(thistype.ENDING_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        call Event.SetSubjectId(parent.Id.Get())
                        call Real.Event.SetTrigger(distanceSquare)
                        call UNIT.Event.SetTrigger(parent)

                        call parent.Event.Get(thistype.ENDING_EVENT_TYPE, priority, iteration2).Run()

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration = iteration - 1
                endloop
            endmethod

            method Start_TriggerEvents takes real distanceSquare returns nothing
                local integer iteration = EventPriority.ALL_COUNT
                local integer iteration2
                local Unit parent = Unit(this)
                local integer priority

                loop
                    exitwhen (iteration < ARRAY_MIN)

                    set priority = EventPriority.ALL[iteration]

                    set iteration2 = parent.Event.Count(thistype.START_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        call Event.SetSubjectId(parent.Id.Get())
                        call Real.Event.SetTrigger(distanceSquare)
                        call UNIT.Event.SetTrigger(parent)

                        call parent.Event.Get(thistype.START_EVENT_TYPE, priority, iteration2).Run()

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration = iteration - 1
                endloop
            endmethod

            static method Trig takes nothing returns nothing
                local real distanceSquare
                local Unit parent
                local thistype this
                local real x
                local real y

                loop
                    set parent = thistype.EVENT_GROUP.FetchFirst()
                    exitwhen (parent == NULL)

                    set this = parent
                    set x = parent.Position.X.Get()
                    set y = parent.Position.Y.Get()

                    set distanceSquare = Math.DistanceSquareByDeltas(x - this.x, y - this.y)

                    call thistype.ENUM_GROUP.AddUnit(parent)
                    if (thistype.MOVING_GROUP.ContainsUnit(parent)) then
                        if (distanceSquare < thistype.THRESHOLD_SQUARE) then
                            call thistype.MOVING_GROUP.RemoveUnit(parent)
                            call this.Ending_TriggerEvents(distanceSquare)
                        //else
                            //call this.Interval_TriggerEvents(distanceSquare)
                        endif

                        set this.x = x
                        set this.y = y
                    else
                        if (distanceSquare > thistype.THRESHOLD_SQUARE) then
                            set this.x = x
                            set this.y = y
                            call thistype.MOVING_GROUP.AddUnit(parent)
                            call this.Start_TriggerEvents(distanceSquare)
                        endif
                    endif
                endloop

                call thistype.EVENT_GROUP.AddGroupClear(thistype.ENUM_GROUP)
            endmethod

            method SetStatus takes boolean moving returns nothing
                if (moving) then
                    call thistype.MOVING_GROUP.AddUnit(this)
                else
                    if (thistype.MOVING_GROUP.ContainsUnit(this)) then
                        call thistype.MOVING_GROUP.RemoveUnit(this)
                    endif
                endif
            endmethod

            method Reg takes Event whichEvent returns nothing
                local Unit parent = this

                if (parent.Data.Integer.Add(KEY, 1)) then
                    if (thistype.EVENT_GROUP.GetFirst() == NULL) then
                        call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.Trig)
                    endif

                    set this.x = parent.Position.X.Get()
                    set this.y = parent.Position.Y.Get()
                    call thistype.EVENT_GROUP.AddUnit(parent)
                endif
                call parent.Event.Add(whichEvent)
            endmethod

            method RegWithInterval takes Event whichEvent, real interval returns nothing
                call this.Interval.Add(whichEvent, interval)

                call this.Reg(whichEvent)
            endmethod

            method Unreg takes Event whichEvent returns nothing
                local Unit parent = this

                if (parent.Data.Integer.Subtract(KEY, 1)) then
                    call thistype.EVENT_GROUP.RemoveUnit(parent)

                    if (thistype.EVENT_GROUP.GetFirst() == NULL) then
                        call thistype.UPDATE_TIMER.Pause()
                    endif
                endif
                call parent.Event.Remove(whichEvent)

                call this.Interval.Remove(whichEvent)
            endmethod

            static method Init takes nothing returns nothing
                set thistype.DUMMY_TRIGGER = Trigger.Create()
                set thistype.ENDING_EVENT_TYPE = EventType.Create()
                set thistype.ENUM_GROUP = Group.Create()
                set thistype.EVENT_GROUP = Group.Create()
                set thistype.MOVING_GROUP = Group.Create()
                set thistype.START_EVENT_TYPE = EventType.Create()
                set thistype.UPDATE_TIMER = Timer.Create()

                call thistype.DUMMY_TRIGGER.AddCode(function thistype.Trig)

                call thistype(NULL).EnterRegion.Init()
                call thistype(NULL).Interval.Init()
                call thistype(NULL).LeaveRegion.Init()
            endmethod
        endstruct

        //! runtextmacro Folder("Speed")
            //! runtextmacro Struct("BonusA")
                static constant real ZERO_CAP = 0.1

                method Set takes real value returns nothing
                    local integer abilityLevel

                    set Unit(this).Movement.Speed.bonus = value

                    set value = (value + Unit(this).Movement.Speed.Get()) * (Unit(this).Movement.Speed.RelativeA.Get() - 1.)

                    if (Math.Abs(value) < thistype.ZERO_CAP) then
                        set value = 0.
                    endif

                    if (value > 0.) then
                        set abilityLevel = 3
                    else
                        set abilityLevel = 1 + B2I(value < 0.)
                    endif

                    call Unit(this).Movement.Speed.UpdateNative()

                    call Unit(this).Abilities.SetLevelBySelf(thistype.DUMMY_SPELL_ID, abilityLevel)

                    call Unit(this).Display.Update()
                endmethod

                method Add takes real value returns nothing
                    call this.Set(Unit(this).Movement.Speed.bonus + value)
                endmethod

                method Event_Create takes nothing returns nothing
                    call Unit(this).Abilities.AddBySelf(thistype.STORAGE_SPELL_ID)
                endmethod

                method Subtract takes real value returns nothing
                    call this.Set(Unit(this).Movement.Speed.bonus - value)
                endmethod

                method Update takes nothing returns nothing
                    call this.Set(Unit(this).Movement.Speed.bonus)
                endmethod

                static method Init takes nothing returns nothing
                    call InitAbility(thistype.DUMMY_SPELL_ID)
                    call InitAbility(thistype.STORAGE_SPELL_ID)
                    call User.ANY.EnableAbilityBySelf(thistype.STORAGE_SPELL_ID, false)
                endmethod
            endstruct

            //! runtextmacro Struct("RelativeA")
                //! runtextmacro CreateSimpleAddState_OnlyGet("real")

                method Set takes real value returns nothing
                    set this.value = value

                    call Unit(this).Movement.Speed.BonusA.Update()
                endmethod

                //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

                method Event_Create takes nothing returns nothing
                    set this.value = 1.
                endmethod
            endstruct
        endscope

        //! runtextmacro Struct("Speed")
            static constant real LOWER_CAP = 150.
            static constant real UPPER_CAP = 522.

            real bonus

            //! runtextmacro LinkToStruct("Speed", "BonusA")
            //! runtextmacro LinkToStruct("Speed", "RelativeA")

            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method GetAll takes nothing returns real
                return (this.Get() * this.RelativeA.Get() + this.bonus)
            endmethod

            method GetBonus takes nothing returns real
                return this.bonus
            endmethod

            method GetBonusAll takes nothing returns real
                local real value = this.Get()

                return ((value + this.GetBonus()) * (this.RelativeA.Get()) - value)
            endmethod

            method UpdateNative takes nothing returns nothing
                local real bonus = this.bonus

                local real value = this.Get() * this.RelativeA.Get() + bonus

                set value = Math.Max(thistype.LOWER_CAP, value)
                set value = Math.Min(value, thistype.UPPER_CAP)

                call SetUnitMoveSpeed(Unit(this).self, value - Math.Sign(bonus))
            endmethod

            method Set takes real value returns nothing
                local real bonusValue = this.GetBonus()

                set this.value = value

                call this.BonusA.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            static method Event_TypeChange takes nothing returns nothing
                local UnitType sourceType = UNIT_TYPE.Event.GetSource()
                local UnitType targetType = UNIT_TYPE.Event.GetTrigger()
                local thistype this = UNIT.Event.GetTrigger()

                call this.Add(targetType.Speed.Get() - sourceType.Speed.Get())
            endmethod

            method Event_Create takes nothing returns nothing
                call this.RelativeA.Event_Create()

                call this.BonusA.Event_Create()

                call this.Set(Unit(this).Type.Get().Speed.Get())
            endmethod

            static method Init takes nothing returns nothing
                call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()

                call thistype(NULL).BonusA.Init()
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Movement")
        static constant integer DUMMY_SPELL_ID = 'Amov'

        //! runtextmacro LinkToStruct("Movement", "Events")
        //! runtextmacro LinkToStruct("Movement", "Speed")

        //! runtextmacro CreateSimpleAddState_OnlyGet("integer")

        static method Event_BuffGain takes nothing returns nothing
            local Unit parent = UNIT.Event.GetTrigger()

            local thistype this = parent

            local integer value = this.Get() - 1

            set this.value = value
            if (value == 0) then
                call SetUnitPropWindow(Unit(this).self, 0.)
            endif
        endmethod

        method Subtract takes nothing returns nothing
            call Unit(this).Buffs.Add(thistype.DUMMY_BUFF, 1)
        endmethod

        method SubtractTimed takes real duration returns nothing
            call Unit(this).Buffs.Timed.Start(thistype.DUMMY_BUFF, 1, duration)
        endmethod

        method RemovePermanently takes nothing returns nothing
            call Unit(this).Abilities.RemoveBySelf(thistype.DUMMY_SPELL_ID)
        endmethod

        static method Event_BuffLose takes nothing returns nothing
            local Unit parent = UNIT.Event.GetTrigger()

            local thistype this = parent

            local integer value = this.Get() + 1

            set this.value = value
            if (value == 1) then
                call SetUnitPropWindow(Unit(this).self, 60.)
            endif
        endmethod

        method Add takes nothing returns nothing
            call Unit(this).Buffs.Subtract(thistype.DUMMY_BUFF)
        endmethod

        static method Event_TypeChange takes nothing returns nothing
            local UnitType sourceType = UNIT_TYPE.Event.GetSource()
            local UnitType targetType = UNIT_TYPE.Event.GetTrigger()
            local thistype this = UNIT.Event.GetTrigger()

            local boolean hasSpeed = (targetType.Speed.Get() > 0.)

            if ((sourceType.Speed.Get() > 0.) == hasSpeed) then
                if (hasSpeed == false) then
                    call this.RemovePermanently()
                endif

                return
            endif

            if (hasSpeed) then
                call this.Add()
            else
                call this.RemovePermanently()
                call this.Subtract()
            endif
        endmethod

        method Event_Create takes nothing returns nothing
            if (Unit(this).Type.Get().Speed.Get() > 0.) then
                set this.value = 1
            else
                set this.value = 0
                call this.RemovePermanently()
            endif

            call this.Speed.Event_Create()
        endmethod

        static method Init takes nothing returns nothing
            call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()

            call InitAbility(thistype.DUMMY_SPELL_ID)

            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))

            call thistype(NULL).Events.Init()
            call thistype(NULL).Speed.Init()
        endmethod
    endstruct

    //! runtextmacro Folder("Order")
        //! runtextmacro Folder("Events")
            //! runtextmacro Struct("Lose")
                static Event DESTROY_EVENT
                static Group DUMMY_GROUP
                static Group ENUM_GROUP
                static Group UPDATE_GROUP
                //! runtextmacro CreateTimeByFramesAmount("UPDATE_TIME", "8")
                static Timer UPDATE_TIMER

                method Unreg takes nothing returns nothing
                    call thistype.DUMMY_GROUP.RemoveUnit(this)
                    call Unit(this).Event.Remove(DESTROY_EVENT)

                    if (thistype.UPDATE_GROUP.ContainsUnit(this) == false) then
                        return
                    endif

                    call thistype.UPDATE_GROUP.RemoveUnit(this)

                    if (thistype.UPDATE_GROUP.IsEmpty()) then
                        call thistype.UPDATE_TIMER.Pause()
                    endif
                endmethod

                static method Event_Destroy takes nothing returns nothing
                    call thistype(UNIT.Event.GetTrigger()).Unreg()
                endmethod

                method TriggerEvents takes nothing returns nothing
                    local Unit parent = this
                endmethod

                method Start takes nothing returns nothing
                    set Unit(this).Order.whichOrder = NULL

                    call this.TriggerEvents()
                endmethod

                static method Update takes nothing returns nothing
                    local Unit parent

                    loop
                        set parent = thistype.UPDATE_GROUP.FetchFirst()
                        exitwhen (parent == NULL)

                        if (parent.Order.GetNative() == NULL) then
                            call thistype(parent).Start()
                        else
                            call ENUM_GROUP.AddUnit(parent)
                        endif
                    endloop

                    if (thistype.ENUM_GROUP.IsEmpty()) then
                        call thistype.UPDATE_TIMER.Pause()
                    else
                        call thistype.UPDATE_GROUP.AddGroupClear(thistype.ENUM_GROUP)
                    endif
                endmethod

                method AddToUpdateGroup takes nothing returns nothing
                    local boolean isFirst = thistype.UPDATE_GROUP.IsEmpty()

                    call thistype.UPDATE_GROUP.AddUnit(this)

                    if (isFirst) then
                        call thistype.UPDATE_TIMER.Start(5., true, function thistype.Update)
                    endif
                endmethod

                method StartByGain takes Order newOrder returns nothing
                    if (thistype.DUMMY_GROUP.ContainsUnit(this) == false) then
                        return
                    endif

                    call this.Start()

                    set Unit(this).Order.whichOrder = newOrder

                    call this.AddToUpdateGroup()
                endmethod

                method Reg takes nothing returns nothing
                    call thistype.DUMMY_GROUP.AddUnit(this)
                    call Unit(this).Event.Add(DESTROY_EVENT)

                    if (Unit(this).Order.GetNative() == NULL) then
                        return
                    endif

                    call this.AddToUpdateGroup()
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
                    set thistype.DUMMY_GROUP = Group.Create()
                    set thistype.ENUM_GROUP = Group.Create()
                    set thistype.UPDATE_GROUP = Group.Create()
                    set thistype.UPDATE_TIMER = Timer.Create()
                endmethod
            endstruct

            //! runtextmacro Folder("Gain")
                //! runtextmacro Struct("Immediate")
                    static EventType DUMMY_EVENT_TYPE
                    static Trigger DUMMY_TRIGGER

                    method TriggerEvents takes Order whichOrder returns nothing
                        local integer iteration = EventPriority.ALL_COUNT
                        local integer iteration2
                        local Unit parent = this
                        local EventPriority priority

                        loop
                            exitwhen (iteration < ARRAY_MIN)

                            set priority = EventPriority.ALL[iteration]

                            set iteration2 = Unit(this).Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                            loop
                                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                                call Event.SetSubjectId(Unit(this).Id.Get())
                                call ORDER.Event.SetTrigger(whichOrder)
                                call UNIT.Event.SetTrigger(parent)

                                call Unit(this).Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run()

                                set iteration2 = iteration2 - 1
                            endloop

                            set iteration2 = whichOrder.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                            loop
                                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                                call Event.SetSubjectId(whichOrder.Id.Get())
                                call ORDER.Event.SetTrigger(whichOrder)
                                call UNIT.Event.SetTrigger(parent)

                                call whichOrder.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run()

                                set iteration2 = iteration2 - 1
                            endloop

                            set iteration = iteration - 1
                        endloop
                    endmethod

                    method Reg takes nothing returns nothing
                        call thistype.DUMMY_TRIGGER.RegisterEvent.Unit(this, EVENT_UNIT_ISSUED_ORDER)
                    endmethod

                    method Start takes Order whichOrder returns nothing
                        local Item triggerItem

                        if (whichOrder.IsInventoryUse()) then
                            set triggerItem = Unit(this).Items.GetFromSlot(whichOrder.GetInventoryIndex())

                            if (triggerItem.Classes.Contains(ItemClass.SCROLL) and Unit(this).Stun.Is()) then
                                call Unit(this).Items.Events.Use.TriggerEvents(triggerItem)
                            endif
                        endif

                        call Unit(this).Order.Events.Lose.StartByGain(whichOrder)

                        call this.TriggerEvents(whichOrder)
                    endmethod

                    static method Trig takes nothing returns nothing
                        local thistype this = UNIT.Event.Native.GetTrigger()

                        if (Unit(this).Transport.Is()) then
                            return
                        endif

                        call this.Start(ORDER.Event.Native.GetTrigger())
                    endmethod

                    static method Init takes nothing returns nothing
                        set thistype.DUMMY_EVENT_TYPE = EventType.Create()
                        set thistype.DUMMY_TRIGGER = Trigger.CreateFromCode(function thistype.Trig)
                    endmethod
                endstruct

                //! runtextmacro Struct("Point")
                    static EventType DUMMY_EVENT_TYPE
                    static Trigger DUMMY_TRIGGER

                    method TriggerEvents takes Order whichOrder, real targetX, real targetY returns nothing
                        local integer iteration = EventPriority.ALL_COUNT
                        local integer iteration2
                        local Unit parent = this
                        local EventPriority priority

                        loop
                            exitwhen (iteration < ARRAY_MIN)

                            set priority = EventPriority.ALL[iteration]

                            set iteration2 = whichOrder.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                            loop
                                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                                call Event.SetSubjectId(whichOrder.Id.Get())
                                call ORDER.Event.SetTrigger(whichOrder)
                                call SPOT.Event.SetTargetX(targetX)
                                call SPOT.Event.SetTargetY(targetY)
                                call UNIT.Event.SetTrigger(parent)

                                call whichOrder.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run()

                                set iteration2 = iteration2 - 1
                            endloop

                            set iteration = iteration - 1
                        endloop
                    endmethod

                    method Reg takes nothing returns nothing
                        call thistype.DUMMY_TRIGGER.RegisterEvent.Unit(this, EVENT_UNIT_ISSUED_POINT_ORDER)
                    endmethod

                    method Start takes Order whichOrder, real targetX, real targetY returns nothing
                        call Unit(this).Order.Events.Lose.StartByGain(whichOrder)

                        call this.TriggerEvents(whichOrder, targetX, targetY)
                    endmethod

                    static method Trig takes nothing returns nothing
                        call thistype(UNIT.Event.Native.GetTrigger()).Start(ORDER.Event.Native.GetTrigger(), SPOT.Event.Native.GetOrderTargetX(), SPOT.Event.Native.GetOrderTargetY())
                    endmethod

                    static method Init takes nothing returns nothing
                        set thistype.DUMMY_EVENT_TYPE = EventType.Create()
                        set thistype.DUMMY_TRIGGER = Trigger.CreateFromCode(function thistype.Trig)
                    endmethod
                endstruct

                //! runtextmacro Struct("Target")
                    static EventType DUMMY_EVENT_TYPE
                    static Trigger DUMMY_TRIGGER
                    static EventType TARGET_EVENT_TYPE

                    method TriggerEvents takes Order whichOrder, Item targetItem, Unit targetUnit returns nothing
                        local integer iteration = EventPriority.ALL_COUNT
                        local integer iteration2
                        local Unit parent = this
                        local EventPriority priority

                        loop
                            exitwhen (iteration < ARRAY_MIN)

                            set priority = EventPriority.ALL[iteration]

                            set iteration2 = whichOrder.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                            loop
                                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                                call Event.SetSubjectId(whichOrder.Id.Get())
                                call ORDER.Event.SetTrigger(whichOrder)
                                call ITEM.Event.SetTarget(targetItem)
                                call UNIT.Event.SetTrigger(parent)
                                call UNIT.Event.SetTarget(targetUnit)

                                call whichOrder.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run()

                                set iteration2 = iteration2 - 1
                            endloop

                            set iteration2 = targetUnit.Event.Count(thistype.TARGET_EVENT_TYPE, priority)

                            loop
                                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                                call ORDER.Event.SetTrigger(whichOrder)
                                call UNIT.Event.SetTrigger(targetUnit)
                                call UNIT.Event.SetTarget(parent)

                                call targetUnit.Event.Get(thistype.TARGET_EVENT_TYPE, priority, iteration2).Run()

                                set iteration2 = iteration2 - 1
                            endloop

                            set iteration = iteration - 1
                        endloop
                    endmethod

                    method Reg takes nothing returns nothing
                        call thistype.DUMMY_TRIGGER.RegisterEvent.Unit(this, EVENT_UNIT_ISSUED_TARGET_ORDER)
                    endmethod

                    method Start takes Order whichOrder, Item targetItem, Unit targetUnit returns nothing
                        call Unit(this).Order.Events.Lose.StartByGain(whichOrder)

                        call this.TriggerEvents(whichOrder, targetItem, targetUnit)
                    endmethod

                    static method Trig takes nothing returns nothing
                        call thistype(UNIT.Event.Native.GetTrigger()).Start(ORDER.Event.Native.GetTrigger(), ITEM.Event.Native.GetOrderTarget(), UNIT.Event.Native.GetOrderTarget())
                    endmethod

                    static method Init takes nothing returns nothing
                        set thistype.DUMMY_EVENT_TYPE = EventType.Create()
                        set thistype.DUMMY_TRIGGER = Trigger.CreateFromCode(function thistype.Trig)
                        set thistype.TARGET_EVENT_TYPE = EventType.Create()
                    endmethod
                endstruct
            endscope

            //! runtextmacro Struct("Gain")
                //! runtextmacro LinkToStruct("Gain", "Immediate")
                //! runtextmacro LinkToStruct("Gain", "Point")
                //! runtextmacro LinkToStruct("Gain", "Target")

                method Event_Create takes nothing returns nothing
                    call this.Immediate.Reg()
                    call this.Point.Reg()
                    call this.Target.Reg()
                endmethod

                static method Init takes nothing returns nothing
                    call thistype(NULL).Immediate.Init()
                    call thistype(NULL).Point.Init()
                    call thistype(NULL).Target.Init()
                endmethod
            endstruct

            //! runtextmacro Struct("Idle")
                static Event DESTROY_EVENT
                static EventType ENDING_EVENT_TYPE
                static EventType INTERVAL_EVENT_TYPE
                //! runtextmacro GetKeyArray("KEY_ARRAY")
                static EventType START_EVENT_TYPE
                static constant real UPDATE_TIME = 0.5
                static Timer UPDATE_TIMER

                //! runtextmacro CreateList("ACTIVE_LIST")
                //! runtextmacro CreateList("EVENT_LIST")
                //! runtextmacro CreateForEachList("FOR_EACH_LIST", "ACTIVE_LIST")
                //! runtextmacro CreateList("IDLING_LIST")

                method Ending_TriggerEvents takes nothing returns nothing
                    local integer iteration = EventPriority.ALL_COUNT
                    local integer iteration2
                    local integer priority

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        set priority = EventPriority.ALL[iteration]

                        set iteration2 = Unit(this).Event.Count(thistype.ENDING_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call Event.SetSubjectId(Unit(this).Id.Get())
                            call UNIT.Event.SetTrigger(this)

                            call Unit(this).Event.Get(thistype.ENDING_EVENT_TYPE, priority, iteration2).Run()

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration = iteration - 1
                    endloop
                endmethod

                method Interval_TriggerEvents takes nothing returns nothing
                    local integer iteration = EventPriority.ALL_COUNT
                    local integer iteration2
                    local integer priority

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        set priority = EventPriority.ALL[iteration]

                        set iteration2 = Unit(this).Event.Count(thistype.INTERVAL_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call Event.SetSubjectId(Unit(this).Id.Get())
                            call UNIT.Event.SetTrigger(this)

                            call Unit(this).Event.Get(thistype.INTERVAL_EVENT_TYPE, priority, iteration2).Run()

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration = iteration - 1
                    endloop
                endmethod

                method Start_TriggerEvents takes nothing returns nothing
                    local integer iteration = EventPriority.ALL_COUNT
                    local integer iteration2
                    local integer priority

                    loop
                        exitwhen (iteration < ARRAY_MIN)

                        set priority = EventPriority.ALL[iteration]

                        set iteration2 = Unit(this).Event.Count(thistype.START_EVENT_TYPE, priority)

                        loop
                            exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                            call Event.SetSubjectId(Unit(this).Id.Get())
                            call UNIT.Event.SetTrigger(this)

                            call Unit(this).Event.Get(thistype.START_EVENT_TYPE, priority, iteration2).Run()

                            set iteration2 = iteration2 - 1
                        endloop

                        set iteration = iteration - 1
                    endloop
                endmethod

                static method Update takes nothing returns nothing
                    local thistype this

                    call thistype.FOR_EACH_LIST_Set()

                    loop
                        set this = thistype.FOR_EACH_LIST_FetchFirst()

                        exitwhen (this == NULL)

                        if (thistype.IDLING_LIST_Contains(this)) then
                            if (Unit(this).Order.GetNative() == NULL) then
                                call this.Interval_TriggerEvents()
                            else
                                call thistype.IDLING_LIST_Remove(this)

                                call this.Ending_TriggerEvents()
                            endif
                        else
                            if (Unit(this).Order.GetNative() == NULL) then
                                call thistype.IDLING_LIST_Add(this)

                                call this.Start_TriggerEvents()
                            endif
                        endif
                    endloop
                endmethod

                method Reg takes Event whichEvent returns nothing
                    if (Unit(this).Data.Integer.Table.Add(KEY_ARRAY, whichEvent)) then
                        call Unit(this).Event.Add(DESTROY_EVENT)

                        call thistype.EVENT_LIST_Add(this)
                        if (Unit(this).Classes.Contains(UnitClass.DEAD) == false) then
                            if (thistype.ACTIVE_LIST_Add(this)) then
                                call UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.Update)
                            endif
                        endif
                    endif
                    call Unit(this).Event.Add(whichEvent)
                endmethod

                method Unreg takes Event whichEvent returns nothing
                    if (Unit(this).Data.Integer.Table.Remove(KEY_ARRAY, whichEvent)) then
                        call thistype.EVENT_LIST_Remove(this)
                        call Unit(this).Event.Remove(DESTROY_EVENT)

                        if (thistype.ACTIVE_LIST_Remove(this)) then
                            call thistype.UPDATE_TIMER.Pause()
                        endif
                    endif
                    call Unit(this).Event.Remove(whichEvent)
                endmethod

                static method Event_Death takes nothing returns nothing
                    local thistype this = UNIT.Event.GetTrigger()

                    if (thistype.EVENT_LIST_Contains(this) == false) then
                        return
                    endif

                    call thistype.ACTIVE_LIST_Remove(this)
                    if (thistype.IDLING_LIST_Contains(this)) then
                        call thistype.IDLING_LIST_Remove(this)

                        call this.Ending_TriggerEvents()
                    endif
                endmethod

                static method Event_Revive takes nothing returns nothing
                    local thistype this = UNIT.Event.GetTrigger()

                    if (thistype.EVENT_LIST_Contains(this) == false) then
                        return
                    endif

                    call thistype.ACTIVE_LIST_Add(this)
                    call thistype.IDLING_LIST_Add(this)

                    call this.Start_TriggerEvents()
                endmethod

                static method Event_Destroy takes nothing returns nothing
                    local Unit parent = UNIT.Event.GetTrigger()

                    local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

                    loop
                        call thistype(parent).Unreg(parent.Data.Integer.Table.Get(KEY_ARRAY, iteration))

                        set iteration = iteration - 1
                        exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
                    endloop
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
                    set thistype.ENDING_EVENT_TYPE = EventType.Create()
                    set thistype.INTERVAL_EVENT_TYPE = EventType.Create()
                    set thistype.START_EVENT_TYPE = EventType.Create()
                    set thistype.UPDATE_TIMER = Timer.Create()
                    call Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Death).AddToStatics()
                    call Event.Create(UNIT.Revival.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Revive).AddToStatics()
                endmethod
            endstruct
        endscope

        //! runtextmacro Struct("Events")
            //! runtextmacro LinkToStruct("Events", "Gain")
            //! runtextmacro LinkToStruct("Events", "Idle")
            //! runtextmacro LinkToStruct("Events", "Lose")

            method Event_Create takes nothing returns nothing
                call this.Gain.Event_Create()
                call this.Lose.Reg()
            endmethod

            static method Init takes nothing returns nothing
                call thistype(NULL).Gain.Init()
                call thistype(NULL).Idle.Init()
                call thistype(NULL).Lose.Init()
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Order")
        Order whichOrder

        //! runtextmacro LinkToStruct("Order", "Events")

        method Get takes nothing returns Order
            return this.whichOrder
        endmethod

        method GetNative takes nothing returns Order
            return Order.GetFromSelf(GetUnitCurrentOrder(Unit(this).self))
        endmethod

        method AddImmediate takes Order whichOrder returns nothing
        endmethod

        method Immediate takes Order whichOrder returns boolean
            set this.whichOrder = whichOrder

            if (IssueImmediateOrderById(Unit(this).self, whichOrder.self) == false) then
                set this.whichOrder = NULL

                return false
            endif

            return true
        endmethod

        method ImmediateBySpell takes Spell whichSpell returns boolean
            return this.Immediate(whichSpell.GetOrder())
        endmethod

        method PointTarget takes Order whichOrder, real x, real y returns boolean
            set this.whichOrder = whichOrder

            if (IssuePointOrderById(Unit(this).self, whichOrder.self, x, y) == false) then
                set this.whichOrder = NULL

                return false
            endif

            return true
        endmethod

        method PointTargetBySpell takes Spell whichSpell, real x, real y returns boolean
            return this.PointTarget(whichSpell.GetOrder(), x, y)
        endmethod

        method UnitTarget takes Order whichOrder, Unit target returns boolean
            set this.whichOrder = whichOrder

            if (IssueTargetOrderById(Unit(this).self, whichOrder.self, Unit(target).self) == false) then
                set this.whichOrder = NULL

                return false
            endif

            return true
        endmethod

        method UnitTargetBySpell takes Spell whichSpell, Unit target returns boolean
            return this.UnitTarget(whichSpell.GetOrder(), target)
        endmethod

        method Spell takes Spell whichSpell, Unit target, real x, real y returns boolean
            local integer targetType = whichSpell.GetTargetType()

            if (targetType == Spell.TARGET_TYPE_IMMEDIATE) then
                return this.ImmediateBySpell(whichSpell)
            elseif (targetType == Spell.TARGET_TYPE_POINT) then
                return this.PointTargetBySpell(whichSpell, x, y)
            else
                if (target == NULL) then
                    return this.PointTargetBySpell(whichSpell, x, y)
                endif
            endif

            return this.UnitTargetBySpell(whichSpell, target)
        endmethod

        method Event_Create takes nothing returns nothing
            call this.Events.Event_Create()
        endmethod

        static method Init takes nothing returns nothing
            call thistype(NULL).Events.Init()
        endmethod
    endstruct

    //! runtextmacro Struct("Eclipse")
        static constant real MANA_REGENERATION_RELATIVE_INCREMENT = -0.5
        static constant real MOVE_SPEED_RELATIVE_INCREMENT = -0.3
        static constant real SPELL_POWER_INCREMENT = -0.5

        static constant real RED_INCREMENT = -50.
        static constant real GREEN_INCREMENT = -150.
        static constant real BLUE_INCREMENT = -50.
        static constant real ALPHA_INCREMENT = 0.

        //! runtextmacro CreateSimpleAddState_OnlyGet("integer")

        method Is takes nothing returns boolean
            return (this.Get() > 0)
        endmethod

        static method Event_BuffLose takes nothing returns nothing
            local Unit parent = UNIT.Event.GetTrigger()

            local thistype this = parent

            local integer value = this.Get() - 1

            set this.value = value
            if (value == 0) then
                call parent.ManaRegeneration.Relative.Add(thistype.MANA_REGENERATION_RELATIVE_INCREMENT)
                call parent.Movement.Speed.RelativeA.Subtract(thistype.MOVE_SPEED_RELATIVE_INCREMENT)
                call parent.SpellPower.Relative.Subtract(thistype.SPELL_POWER_INCREMENT)
                call parent.VertexColor.Add(-thistype.RED_INCREMENT, -thistype.GREEN_INCREMENT, -thistype.BLUE_INCREMENT, -thistype.ALPHA_INCREMENT)
            endif
        endmethod

        method Subtract takes nothing returns nothing
            call Unit(this).Buffs.Subtract(thistype.DUMMY_BUFF)
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local Unit parent = UNIT.Event.GetTrigger()

            local thistype this = parent

            local integer value = this.Get() + 1

            set this.value = value
            if (value == 1) then
                call parent.ManaRegeneration.Relative.Subtract(thistype.MANA_REGENERATION_RELATIVE_INCREMENT)
                call parent.Movement.Speed.RelativeA.Add(thistype.MOVE_SPEED_RELATIVE_INCREMENT)
                call parent.SpellPower.Relative.Add(thistype.SPELL_POWER_INCREMENT)
                call parent.VertexColor.Add(thistype.RED_INCREMENT, thistype.GREEN_INCREMENT, thistype.BLUE_INCREMENT, thistype.ALPHA_INCREMENT)
            endif
        endmethod

        method Add takes nothing returns nothing
            call Unit(this).Buffs.Add(thistype.DUMMY_BUFF, 1)
        endmethod

        method AddTimed takes real duration returns nothing
            call Unit(this).Buffs.Timed.Start(thistype.DUMMY_BUFF, 1, duration)
        endmethod

        //! runtextmacro CreateSimpleAddState_OnlyStart("0")

        static method Init takes nothing returns nothing
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        endmethod
    endstruct

    //! runtextmacro Struct("Facing")
        static real STANDARD = Math.SOUTH_ANGLE

        method Get takes nothing returns real
            return (GetUnitFacing(Unit(this).self) * Math.DEG_TO_RAD)
        endmethod

        method Set takes real value returns nothing
            call SetUnitFacing(Unit(this).self, value * Math.RAD_TO_DEG)
        endmethod

        method SetToUnit takes Unit target returns nothing
            local real targetX = target.Position.X.Get()
            local real targetY = target.Position.Y.Get()
            local real thisX = Unit(this).Position.X.Get()
            local real thisY = Unit(this).Position.Y.Get()

            if ((targetX != thisX) or (targetY != thisY)) then
                call this.Set(Math.AtanByDeltas(targetY - thisY, targetX - thisX))
            endif
        endmethod
    endstruct

    //! runtextmacro Struct("Ignited")
        static constant real INTERVAL = 1.

        static constant real DAMAGE_PER_INTERVAL = 0.05 * thistype.INTERVAL
        static constant real HERO_DAMAGE_PER_INTERVAL = 0.02 * thistype.INTERVAL

        //! runtextmacro CreateSimpleAddState_OnlyGet("integer")

        Unit caster
        Timer intervalTimer

        method Is takes nothing returns boolean
            return (this.Get() > 0)
        endmethod

        static method Event_BuffLose takes nothing returns nothing
            local Unit parent = UNIT.Event.GetTrigger()

            local thistype this = parent

            local integer value = this.Get() - 1

            set this.value = value
            if (value == 0) then
                call this.intervalTimer.Destroy()

                call parent.Invisibility.Reveal.Subtract()
            endif
        endmethod

        method Subtract takes nothing returns nothing
            call Unit(this).Buffs.Subtract(thistype.DUMMY_BUFF)
        endmethod

        static method Interval takes nothing returns nothing
            local thistype this = Timer.GetExpired().GetData()

            local Unit target = this

            if (target.Classes.Contains(UnitClass.HERO)) then
                call this.caster.DamageUnitBySpell(target, target.MaxLife.GetAll() * thistype.HERO_DAMAGE_PER_INTERVAL, true, false)
            else
                call this.caster.DamageUnitBySpell(target, target.MaxLife.GetAll() * thistype.DAMAGE_PER_INTERVAL, true, false)
            endif
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local Unit caster = Unit.TEMP
            local Timer intervalTimer
            local Unit parent = UNIT.Event.GetTrigger()

            local thistype this = parent

            local integer value = this.Get() + 1

            set this.caster = caster
            set this.value = value
            if (value == 1) then
                set intervalTimer = Timer.Create()

                set this.intervalTimer = intervalTimer
                call intervalTimer.SetData(this)

                call parent.Invisibility.Reveal.Add()

                call intervalTimer.Start(INTERVAL, true, function thistype.Interval)
            endif
        endmethod

        method Add takes Unit caster returns nothing
            set Unit.TEMP = caster

            call Unit(this).Buffs.Add(thistype.DUMMY_BUFF, 1)
        endmethod

        method AddTimed takes Unit caster, real duration returns nothing
            set Unit.TEMP = caster

            call Unit(this).Buffs.Timed.Start(thistype.DUMMY_BUFF, 1, duration)
        endmethod

        //! runtextmacro CreateSimpleAddState_OnlyStart("0")

        static method Init takes nothing returns nothing
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        endmethod
    endstruct

    //! runtextmacro Struct("Pathing")
        //! runtextmacro CreateSimpleAddState_OnlyGet("integer")

        method Is takes nothing returns boolean
            return (this.Get() > 0)
        endmethod

        static method Event_BuffLose takes nothing returns nothing
            local Unit parent = UNIT.Event.GetTrigger()

            local thistype this = parent

            local integer value = this.Get() - 1

            set this.value = value
            if (value == 0) then
                call SetUnitPathing(parent.self, false)
            endif
        endmethod

        method Add takes nothing returns nothing
            call Unit(this).Buffs.Subtract(thistype.DUMMY_BUFF)
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local Unit parent = UNIT.Event.GetTrigger()

            local thistype this = parent

            local integer value = this.Get() + 1
            set this.value = value
            if (value == 1) then
                call SetUnitPathing(parent.self, true)
            endif
        endmethod

        method Subtract takes nothing returns nothing
            call Unit(this).Buffs.Add(thistype.DUMMY_BUFF, 1)
        endmethod

        static method Event_TypeChange takes nothing returns nothing
            local thistype this = UNIT.Event.GetTrigger()

            if (this.Is()) then
                call SetUnitPathing(Unit(this).self, true)
            else
                call SetUnitPathing(Unit(this).self, false)
            endif
        endmethod

        //! runtextmacro CreateSimpleAddState_OnlyStart("1")

        static method Init takes nothing returns nothing
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))

            call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
        endmethod
    endstruct

    //! runtextmacro Struct("Poisoned")
        static constant real ATTACK_SPEED_INCREMENT = -0.25
        static constant real MOVE_SPEED_INCREMENT = -0.1
        static constant real LIFE_REGENERATION_RELATIVE_INCREMENT = -0.5

        static constant real RED_INCREMENT = -100.
        static constant real GREEN_INCREMENT = 0.
        static constant real BLUE_INCREMENT = -100.
        static constant real ALPHA_INCREMENT = 0.

        //! runtextmacro CreateSimpleAddState_OnlyGet("integer")

        method Is takes nothing returns boolean
            return (this.Get() > 0)
        endmethod

        static method Event_BuffLose takes nothing returns nothing
            local Unit parent = UNIT.Event.GetTrigger()

            local thistype this = parent

            local integer value = this.Get() - 1

            set this.value = value
            if (value == 0) then
                call parent.Attack.Speed.BonusA.Subtract(thistype.ATTACK_SPEED_INCREMENT)
                call parent.LifeRegeneration.Relative.Add(thistype.LIFE_REGENERATION_RELATIVE_INCREMENT)
                call parent.Movement.Speed.RelativeA.Subtract(thistype.MOVE_SPEED_INCREMENT)
                call parent.VertexColor.Add(-thistype.RED_INCREMENT, -thistype.GREEN_INCREMENT, -thistype.BLUE_INCREMENT, -thistype.ALPHA_INCREMENT)
            endif
        endmethod

        method Subtract takes nothing returns nothing
            call Unit(this).Buffs.Subtract(thistype.DUMMY_BUFF)
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local Unit parent = UNIT.Event.GetTrigger()

            local thistype this = parent

            local integer value = this.Get() + 1

            set this.value = value
            if (value == 1) then
                call parent.Attack.Speed.BonusA.Add(thistype.ATTACK_SPEED_INCREMENT)
                call parent.LifeRegeneration.Relative.Subtract(thistype.LIFE_REGENERATION_RELATIVE_INCREMENT)
                call parent.Movement.Speed.RelativeA.Add(thistype.MOVE_SPEED_INCREMENT)
                call parent.VertexColor.Add(thistype.RED_INCREMENT, thistype.GREEN_INCREMENT, thistype.BLUE_INCREMENT, thistype.ALPHA_INCREMENT)
            endif
        endmethod

        method Add takes nothing returns nothing
            call Unit(this).Buffs.Add(thistype.DUMMY_BUFF, 1)
        endmethod

        method AddTimed takes real duration returns nothing
            call Unit(this).Buffs.Timed.Start(thistype.DUMMY_BUFF, 1, duration)
        endmethod

        //! runtextmacro CreateSimpleAddState_OnlyStart("0")

        static method Init takes nothing returns nothing
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        endmethod
    endstruct

    //! runtextmacro Folder("Revival")
        //! runtextmacro Struct("Able")
            //! runtextmacro CreateSimpleFlagCountState("Boolean.ToInt(Unit(this).Type.Get().Revivalable.Is())")

            static method Event_TypeChange takes nothing returns nothing
                local UnitType sourceType = UNIT_TYPE.Event.GetSource()
                local UnitType targetType = UNIT_TYPE.Event.GetTrigger()
                local thistype this = UNIT.Event.GetTrigger()

                call this.AddValue(Boolean.ToInt(targetType.Revivalable.Is()) - Boolean.ToInt(sourceType.Revivalable.Is()))
            endmethod

            static method Init takes nothing returns nothing
                call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
            endmethod
        endstruct

        //! runtextmacro Struct("Events")
            static EventType DUMMY_EVENT_TYPE
            static Trigger DUMMY_TRIGGER

            method TriggerEvents takes nothing returns nothing
                local integer iteration = EventPriority.ALL_COUNT
                local integer iteration2
                local EventPriority priority

                loop
                    exitwhen (iteration < ARRAY_MIN)

                    set priority = EventPriority.ALL[iteration]

                    set iteration2 = Event.CountAtStatics(thistype.DUMMY_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        call UNIT.Event.SetTrigger(this)

                        call Event.GetFromStatics(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run()

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration2 = Unit(this).Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        call Event.SetSubjectId(Unit(this).Id.Get())
                        call UNIT.Event.SetTrigger(this)

                        call Unit(this).Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run()

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration = iteration - 1
                endloop
            endmethod

            method Start takes nothing returns nothing
                call this.TriggerEvents()
            endmethod

            static method Init takes nothing returns nothing
                set thistype.DUMMY_EVENT_TYPE = EventType.Create()
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Revival")
        //! runtextmacro LinkToStruct("Revival", "Able")
        //! runtextmacro LinkToStruct("Revival", "Events")

        //! runtextmacro CreateSimpleFlagState_NotStart()

        method Do takes nothing returns boolean
            local boolean isStructure
            local boolean result
            local User thisOwner

            if (this.Able.Is() == false) then
                return false
            endif
            if (Unit(this).Classes.IsNative(UNIT_TYPE_DEAD) == false) then
                return false
            endif

            set isStructure = Unit(this).Classes.IsNative(UNIT_TYPE_STRUCTURE)
            set thisOwner = Unit(this).Owner.Get()

            call DummyUnit.WORLD_CASTER.Owner.Set(thisOwner)
            call DummyUnit.WORLD_CASTER.Position.X.Set(Unit(this).Position.X.Get())
            call DummyUnit.WORLD_CASTER.Position.Y.Set(Unit(this).Position.Y.Get())
            call Unit(this).Classes.AddNative(UNIT_TYPE_TAUREN)
            call UnitShareVision(Unit(this).self, thisOwner.self, true)

            set result = DummyUnit.WORLD_CASTER.Order.Immediate(Order.ANCESTRAL_SPIRIT)

            call DummyUnit.WORLD_CASTER.Owner.Set(User.DUMMY)
            call Unit(this).Classes.RemoveNative(UNIT_TYPE_TAUREN)

            if (result) then
                call Group.ALIVE.AddUnit(this)
                if (isStructure) then
                    call ShowUnit(Unit(this).self, false)
                endif
                call this.Set(false)
                call Unit(this).Classes.Remove(UnitClass.DEAD)

                if (isStructure) then
                    call ShowUnit(Unit(this).self, true)
                endif

                call Unit(this).Life.Set(Unit(this).MaxLife.GetAll())

                call this.Events.Start()
            endif

            return result
        endmethod

        method Event_Create takes nothing returns nothing
            set this.flag = false

            call this.Able.Event_Create()
        endmethod

        static method Init takes nothing returns nothing
            call InitAbility(thistype.DUMMY_SPELL_ID)

            call DummyUnit.WORLD_CASTER.Abilities.AddBySelf(thistype.DUMMY_SPELL_ID)

            call thistype(NULL).Able.Init()
            call thistype(NULL).Events.Init()
        endmethod
    endstruct

    //! runtextmacro Struct("Silence")
        //! runtextmacro CreateSimpleAddState_OnlyGet("integer")

        static method Event_BuffLose takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = target

            local integer value = this.Get() - 1

            set this.value = value
            if (value == 0) then
                call Unit(this).Buffs.RemoveBySelf(thistype.DUMMY_BUFF_ID)
            endif
        endmethod

        method Subtract takes Buff whichBuff returns nothing
            call Unit(this).Buffs.Subtract(whichBuff)
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = target

            local integer value = this.Get() + 1

            set this.value = value
            if (value == 1) then
                call DummyUnit.WORLD_CASTER.Order.UnitTargetInstantly(Order.SOULBURN, this)
            endif
        endmethod

        method Add takes Buff whichBuff returns nothing
            call Unit(this).Buffs.Add(whichBuff, 1)
        endmethod

        method AddTimed takes real duration, Buff whichBuff returns nothing
            call Unit(this).Buffs.Timed.Start(whichBuff, 1, duration)
        endmethod

        //! runtextmacro CreateSimpleAddState_OnlyStart("0")

        static method Init takes nothing returns nothing
            call InitBuff(thistype.DUMMY_BUFF_ID)
            call InitAbility(thistype.DUMMY_SPELL_ID)

            call thistype.NONE_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.NONE_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))

            call thistype.NORMAL_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.NORMAL_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))

            call DummyUnit.WORLD_CASTER.Abilities.AddBySelf(thistype.DUMMY_SPELL_ID)
        endmethod
    endstruct

    //! runtextmacro Struct("Sleep")
        static Event DAMAGE_EVENT
        static EventType ENDING_EVENT_TYPE
        static integer SLEEP_INVU_BUFF_ID = 'BUsp'

        //! runtextmacro CreateSimpleAddState_OnlyGet("integer")

        method Is takes nothing returns boolean
            return (this.Get() > 0)
        endmethod

        method Ending_TriggerEvents takes nothing returns nothing
            local integer iteration = EventPriority.ALL_COUNT
            local integer iteration2
            local EventPriority priority

            loop
                exitwhen (iteration < ARRAY_MIN)

                set priority = EventPriority.ALL[iteration]

                set iteration2 = Unit(this).Event.Count(thistype.ENDING_EVENT_TYPE, priority)

                loop
                    exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                    call Event.SetSubjectId(Unit(this).Id.Get())
                    call UNIT.Event.SetTrigger(this)

                    call Unit(this).Event.Get(thistype.ENDING_EVENT_TYPE, priority, iteration2).Run()

                    set iteration2 = iteration2 - 1
                endloop

                set iteration = iteration - 1
            endloop
        endmethod

        static method Event_BuffLose takes nothing returns nothing
            local Unit parent = UNIT.Event.GetTrigger()

            local thistype this = parent

            local integer value = this.Get() - 1

            set this.value = value
            if (value == 0) then
                call parent.Event.Remove(DAMAGE_EVENT)
                call parent.Stun.Subtract(UNIT.Stun.NONE_BUFF)
                call parent.Buffs.RemoveBySelf(thistype.SLEEP_BUFF_ID)

                call thistype(parent).Ending_TriggerEvents()
            endif
        endmethod

        method Subtract takes nothing returns nothing
            call Unit(this).Buffs.Subtract(thistype.DUMMY_BUFF)
        endmethod

        static method Event_Damage takes nothing returns nothing
            call UNIT.Event.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local Unit parent = UNIT.Event.GetTrigger()

            local thistype this = parent

            local integer value = this.Get() + 1

            set this.value = value
            if (value == 1) then
                call parent.Event.Add(DAMAGE_EVENT)
                call parent.Stun.Add(UNIT.Stun.NONE_BUFF)
                call DummyUnit.WORLD_CASTER.Order.UnitTargetInstantly(Order.SLEEP, parent)

                call parent.Buffs.RemoveBySelf('BUsp')
            endif
        endmethod

        method Add takes nothing returns nothing
            call Unit(this).Buffs.Add(thistype.DUMMY_BUFF, 1)
        endmethod

        method AbortTimed takes nothing returns nothing
            call Unit(this).Buffs.Timed.Abort(thistype.DUMMY_BUFF)
        endmethod

        method AddTimed takes real duration returns nothing
            call Unit(this).Buffs.Timed.Start(thistype.DUMMY_BUFF, 1, duration)
        endmethod

        //! runtextmacro CreateSimpleAddState_OnlyStart("0")

        static method Init takes nothing returns nothing
            set thistype.DAMAGE_EVENT = Event.Create(UNIT.Damage.Events.TARGET_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Damage)
            set thistype.ENDING_EVENT_TYPE = EventType.Create()

            call InitBuff(thistype.SLEEP_BUFF_ID)
            call InitBuff(thistype.SLEEP_INVU_BUFF_ID)
            call InitAbility(thistype.SLEEP_SPELL_ID)

            call DummyUnit.WORLD_CASTER.Abilities.AddBySelf(thistype.SLEEP_SPELL_ID)

            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        endmethod
    endstruct

    //! runtextmacro Folder("Stun")
        //! runtextmacro Struct("Cancel")
            static Event DEATH_EVENT
            //! runtextmacro GetKey("KEY")

            Timer delayTimer
            Unit parent

            method Ending takes Timer delayTimer, Unit parent returns nothing
                call this.deallocate()
                call delayTimer.Destroy()
                call parent.Data.Integer.Remove(KEY)
                call parent.Event.Remove(DEATH_EVENT)
                call Unit(parent).Buffs.RemoveBySelf(UNIT.Stun.DUMMY_BUFF_ID)
            endmethod

            static method Event_Death takes nothing returns nothing
                local Unit parent = UNIT.Event.GetTrigger()

                local thistype this = parent.Data.Integer.Get(KEY)

                call this.Ending(this.delayTimer, parent)
            endmethod

            static method EndingByTimer takes nothing returns nothing
                local Timer delayTimer = Timer.GetExpired()

                local thistype this = delayTimer.GetData()

                call this.Ending(delayTimer, this.parent)
            endmethod

            static method Event_Order takes nothing returns nothing
                local Unit parent = UNIT.Event.GetTrigger()
                local Timer delayTimer
                local thistype this = parent.Data.Integer.Get(KEY)

                if (parent.Stun.Get() == 0) then
                    if (parent.Data.Integer.Get(KEY) == NULL) then
                        set this = thistype.allocate()
                        set delayTimer = Timer.Create()
                        set this.delayTimer = delayTimer
                        set this.parent = parent
                        call delayTimer.SetData(this)
                        call parent.Data.Integer.Set(KEY, this)
                        call parent.Event.Add(DEATH_EVENT)

                        call delayTimer.Start(0., false, function thistype.EndingByTimer)
                    endif
                endif
            endmethod

            static method Init takes nothing returns nothing
                set DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Order)
                call Order.STUNNED.Event.Add(Event.Create(UNIT.Order.Events.Gain.Target.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Order))
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Stun")
        //! runtextmacro LinkToStruct("Stun", "Cancel")

        //! runtextmacro CreateSimpleAddState_OnlyGet("integer")

        method Is takes nothing returns boolean
            return (this.Get() > 0)
        endmethod

        static method Event_BuffLose takes nothing returns nothing
            local Unit parent = UNIT.Event.GetTrigger()

            local thistype this = parent

            local integer value = this.Get() - 1

            set this.value = value
            if (value == 0) then
                call Unit(this).Buffs.RemoveBySelf(thistype.DUMMY_BUFF_ID)
            endif
        endmethod

        method Subtract takes Buff whichBuff returns nothing
            call Unit(this).Buffs.Subtract(whichBuff)
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local Unit parent = UNIT.Event.GetTrigger()

            local thistype this = parent

            local integer value = this.Get() + 1

            set this.value = value
            if (value == 1) then
                call DummyUnit.WORLD_CASTER.Order.UnitTargetInstantly(Order.THUNDER_BOLT, parent)
            endif
        endmethod

        method Add takes Buff whichBuff returns nothing
            call Unit(this).Buffs.Add(whichBuff, 1)
        endmethod

        method AddTimed takes real duration, Buff whichBuff returns nothing
            call Unit(this).Buffs.Timed.Start(whichBuff, 1, duration)
        endmethod

        //! runtextmacro CreateSimpleAddState_OnlyStart("0")

        static method Init takes nothing returns nothing
            local Buff currentBuff

            call InitBuff(thistype.DUMMY_BUFF_ID)
            call InitAbility(thistype.DUMMY_SPELL_ID)

            call DummyUnit.WORLD_CASTER.Abilities.AddBySelf(thistype.DUMMY_SPELL_ID)

            set currentBuff = thistype.NONE_BUFF

            call currentBuff.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_BuffGain))
            call currentBuff.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_BuffLose))

            set currentBuff = thistype.NORMAL_BUFF

            call currentBuff.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_BuffGain))
            call currentBuff.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_BuffLose))

            call thistype(NULL).Cancel.Init()
        endmethod
    endstruct

    //! runtextmacro Folder("Animation")
        //! runtextmacro Struct("Loop")
            static Event DEATH_EVENT
            //! runtextmacro GetKey("KEY")
            //! runtextmacro CreateTimeByFramesAmount("UPDATE_TIME", "32")
            static Timer UPDATE_TIMER

            Unit parent
            string whichAnimation

            private method Ending takes Unit parent returns nothing
                call this.deallocate()
                call parent.Data.Integer.Remove(KEY)
                call parent.Event.Remove(DEATH_EVENT)
                if (this.RemoveFromList()) then
                    call thistype.UPDATE_TIMER.Pause()
                endif

                call this.parent.Animation.Set(UNIT.Animation.STAND)
                call this.parent.Animation.Queue(UNIT.Animation.STAND)
            endmethod

            method Abort takes nothing returns nothing
                local Unit parent = this

                set this = parent.Data.Integer.Get(KEY)

                if (this != NULL) then
                    call this.Ending(parent)
                endif
            endmethod

            static method Event_Death takes nothing returns nothing
                local Unit parent = UNIT.Event.GetTrigger()

                local thistype this = parent.Data.Integer.Get(KEY)

                call this.Ending(parent)
            endmethod

            static method Update takes nothing returns nothing
                local integer iteration = thistype.ALL_COUNT
                local thistype this

                loop
                    set this = thistype.ALL[iteration]

                    call this.parent.Animation.Queue(this.whichAnimation)

                    set iteration = iteration - 1
                    exitwhen (iteration < ARRAY_MIN)
                endloop
            endmethod

            method Start takes string whichAnimation returns nothing
                local Unit parent = this

                set this = thistype.allocate()

                set this.parent = parent
                set this.whichAnimation = whichAnimation
                call parent.Data.Integer.Table.Add(KEY, this)
                call parent.Event.Add(DEATH_EVENT)

                if (this.AddToList()) then
                    call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.Update)
                endif
            endmethod

            static method Init takes nothing returns nothing
                set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Death)
                set thistype.UPDATE_TIMER = Timer.Create()
            endmethod
        endstruct

        //! runtextmacro Struct("Speed")
            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value
                call SetUnitTimeScale(Unit(this).self, value)
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd("real", "1.")
        endstruct
    endscope

    //! runtextmacro Struct("Animation")
        static constant string ALTERNATE = "alternate"
        static constant string ATTACK = "attack"
        static constant string BIRTH = "birth"
        static constant string SPELL = "spell"
        static constant string SPELL_SLAM = "spell slam"
        static constant string STAND = "stand"
        static constant string SWIM = "swim"

        //! runtextmacro LinkToStruct("Animation", "Loop")
        //! runtextmacro LinkToStruct("Animation", "Speed")

        method Remove takes string whichAnimation returns nothing
            call AddUnitAnimationProperties(Unit(this).self, whichAnimation, false)
        endmethod

        method Queue takes string whichAnimation returns nothing
            call QueueUnitAnimation(Unit(this).self, whichAnimation)
        endmethod

        method Set takes string whichAnimation returns nothing
            call SetUnitAnimation(Unit(this).self, whichAnimation)
        endmethod

        method Add takes string whichAnimation returns nothing
            call AddUnitAnimationProperties(Unit(this).self, whichAnimation, true)
        endmethod

        method SetByIndex takes integer whichAnimation returns nothing
            call SetUnitAnimationByIndex(Unit(this).self, whichAnimation)
        endmethod

        method Event_Create takes nothing returns nothing
            call this.Speed.Event_Create()
        endmethod

        static method Init takes nothing returns nothing
            call thistype(NULL).Loop.Init()
        endmethod
    endstruct

    //! runtextmacro Struct("SkillPoints")
        //! runtextmacro CreateSimpleAddState_OnlyGet("integer")

        method Set takes integer value returns nothing
            local integer oldValue = this.Get()

            set this.value = value
            call UnitModifySkillPoints(Unit(this).self, value - oldValue)
        endmethod

        method UpdateByLearn takes nothing returns nothing
            set this.value = GetHeroSkillPoints(Unit(this).self) - 1
        endmethod

        //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("integer")

        method Event_Create takes nothing returns nothing
            set this.value = 0
            call UnitModifySkillPoints(Unit(this).self, -GetHeroSkillPoints(Unit(this).self))
        endmethod
    endstruct

    //! runtextmacro Folder("SpellPower")
        //! runtextmacro Struct("Bonus")
            //! runtextmacro CreateSimpleAddState("real", "0.")
        endstruct

        //! runtextmacro Struct("Relative")
            //! runtextmacro CreateSimpleAddState("real", "1.")
        endstruct
    endscope

    //! runtextmacro Struct("SpellPower")
        static constant real SCALE_FACTOR = 1. / 10.

        //! runtextmacro LinkToStruct("SpellPower", "Bonus")
        //! runtextmacro LinkToStruct("SpellPower", "Relative")

        //! runtextmacro CreateSimpleAddState_NotStart("real")

        method GetAll takes nothing returns real
            return (this.Get() * this.Relative.Get() + this.Bonus.Get())
        endmethod

        method GetBonusAll takes nothing returns real
            local real value = this.Get()

            return ((value + this.Bonus.Get()) * (this.Relative.Get()) - value)
        endmethod

        static method GetDamageFactor takes real value returns real
            if (value < 0.) then
                return (2. - Math.Power((1. - Attack.ARMOR_REDUCTION_FACTOR), -value * thistype.SCALE_FACTOR))
            endif

            return (1. / (1. + Attack.ARMOR_REDUCTION_FACTOR * value * thistype.SCALE_FACTOR))
        endmethod

        static method Event_TypeChange takes nothing returns nothing
            local UnitType sourceType = UNIT_TYPE.Event.GetSource()
            local UnitType targetType = UNIT_TYPE.Event.GetTrigger()
            local thistype this = UNIT.Event.GetTrigger()

            call this.Add(targetType.SpellPower.Get() - sourceType.SpellPower.Get())
        endmethod

        method Event_Create takes nothing returns nothing
            call this.Set(Unit(this).Type.Get().SpellPower.Get())

            call this.Bonus.Event_Create()
            call this.Relative.Event_Create()
        endmethod

        static method Init takes nothing returns nothing
            call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
        endmethod
    endstruct

    //! runtextmacro Folder("MaxStamina")
        //! runtextmacro Struct("Bonus")
            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).MaxStamina.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            method Event_Create takes nothing returns nothing
                set this.value = 0.
            endmethod
        endstruct

        //! runtextmacro Struct("Relative")
            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                set this.value = value

                call Unit(this).MaxStamina.Update()
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            method Event_Create takes nothing returns nothing
                set this.value = 1.
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("MaxStamina")
        //! runtextmacro LinkToStruct("MaxStamina", "Bonus")
        //! runtextmacro LinkToStruct("MaxStamina", "Relative")

        //! runtextmacro CreateSimpleAddState_OnlyGet("real")

        method GetAll takes nothing returns real
            return (this.Get() * this.Relative.Get() + this.Bonus.Get())
        endmethod

        method Set takes real value returns nothing
            local real oldValueAll = this.GetAll()

            set this.value = value

            if (oldValueAll == 0.) then
                return
            endif

            call Unit(this).Stamina.Set(Unit(this).Stamina.Get() / oldValueAll * this.GetAll())
        endmethod

        //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

        method Event_Create takes nothing returns nothing
            set this.value = 0.

            call this.Bonus.Event_Create()
            call this.Relative.Event_Create()

            call this.Set(200.)
        endmethod
    endstruct

    //! runtextmacro Folder("Stamina")
        //! runtextmacro Struct("Exhaustion")
            static constant real BONUS_RELATIVE_MOVE_SPEED = -0.5

            static method Event_BuffLose takes nothing returns nothing
                call UNIT.Event.GetTrigger().Movement.Speed.RelativeA.Subtract(thistype.BONUS_RELATIVE_MOVE_SPEED)
            endmethod

            static method Event_BuffGain takes nothing returns nothing
                call UNIT.Event.GetTrigger().Movement.Speed.RelativeA.Add(thistype.BONUS_RELATIVE_MOVE_SPEED)
            endmethod

            method Subtract takes nothing returns nothing
                call Unit(this).Buffs.Subtract(thistype.DUMMY_BUFF)
            endmethod

            method Add takes nothing returns nothing
                call Unit(this).Buffs.Add(thistype.DUMMY_BUFF, 1)
            endmethod

            static method Init takes nothing returns nothing
                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Bars")
        static Event CAST_EVENT
        static Event DESTROY_EVENT
        static Event END_CAST_EVENT
        static constant real DISPLAY_MAX = 0.15
        static constant real DISPLAY_MAX_TRESHOLD = 0.9
        static constant real DISPLAY_MIN = 1.
        static constant real DISPLAY_MIN_TRESHOLD = 0.7
        static constant real HEIGHT = 175.
        //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "1")
        static Timer UPDATE_TIMER
        static constant real WIDTH = 60.

        //static constant real DISPLAY_ELEV = 1 / (thistype.DISPLAY_MIN_TRESHOLD - thistype.DISPLAY_MAX_TRESHOLD)
        static constant real DISPLAY_ELEV = (thistype.DISPLAY_MAX - thistype.DISPLAY_MIN) / (thistype.DISPLAY_MAX_TRESHOLD - thistype.DISPLAY_MIN_TRESHOLD)
        //static constant real DISPLAY_OFFSET = 1 / (1 - (thistype.DISPLAY_MIN_TRESHOLD / thistype.DISPLAY_MAX_TRESHOLD))
        static constant real DISPLAY_OFFSET = (thistype.DISPLAY_MIN / thistype.DISPLAY_MIN_TRESHOLD - thistype.DISPLAY_MAX / thistype.DISPLAY_MAX_TRESHOLD) / (1 / thistype.DISPLAY_MIN_TRESHOLD - 1 / thistype.DISPLAY_MAX_TRESHOLD)

        lightning channelBar
        lightning channelJuice
        Timer channelTimer
        //lightning lifeBar
        //lightning lifeJuice
        lightning manaBar
        lightning manaJuice
        lightning staminaJuice
        lightning staminaBar

        static method Update takes nothing returns nothing
            local real angle = GetCameraField(CAMERA_FIELD_ROTATION) - Math.QUARTER_ANGLE
            local real height
            local integer iteration = thistype.ALL_COUNT
            local real relative
            local thistype this
            local real x
            local real xOffset
            local real y
            local real yOffset

            local real xPart = Math.Cos(angle)
            local real yPart = Math.Sin(angle)

            loop
                set this = thistype.ALL[iteration]

                if (Unit(this).Classes.Contains(UnitClass.DEAD)) then
                    /*call MoveLightningEx(this.lifeBar, false, 0., 0., 0., 0., 0., 0.)
                    call MoveLightningEx(this.lifeJuice, false, 0., 0., 0., 0., 0., 0.)*/
                    call MoveLightningEx(this.manaBar, false, 0., 0., 0., 0., 0., 0.)
                    call MoveLightningEx(this.manaJuice, false, 0., 0., 0., 0., 0., 0.)
                    call MoveLightningEx(this.staminaBar, false, 0., 0., 0., 0., 0., 0.)
                    call MoveLightningEx(this.staminaJuice, false, 0., 0., 0., 0., 0., 0.)
                else
                    set height = Unit(this).Position.Z.Get() + thistype.HEIGHT * Unit(this).Scale.Get()
                    set x = Unit(this).Position.X.Get()
                    set xOffset = thistype.WIDTH * xPart
                    set y = Unit(this).Position.Y.Get()
                    set yOffset = thistype.WIDTH * yPart

                    set relative = this.channelTimer.GetTimeout()

                    if (relative > 0.) then
                        set relative = this.channelTimer.GetRemaining() / relative

                        call MoveLightningEx(this.channelBar, false, x - xOffset*1.5, y - yOffset*1.5, height+75, x + xOffset*1.5, y + yOffset*1.5, height+75)
                        call SetLightningColor(this.channelBar, 1., 1., 1., 1.)
                        call MoveLightningEx(this.channelJuice, false, x - xOffset*1.5, y - yOffset*1.5, height+75, x + (relative * 2 - 1) * xOffset*1.5, y + (relative * 2 - 1) * yOffset*1.5, height+75)
                        call SetLightningColor(this.channelJuice, 0., 0.75, 1., 1.)
                    endif

                    /*set relative = Unit(this).Life.Get() / Unit(this).MaxLife.GetAll()

                    if (relative > thistype.DISPLAY_MAX_TRESHOLD) then
                        call MoveLightningEx(this.lifeBar, false, 0., 0., 0., 0., 0., 0.)
                        call MoveLightningEx(this.lifeJuice, false, 0., 0., 0., 0., 0., 0.)
                    else
                        call MoveLightningEx(this.lifeBar, false, x - xOffset, y - yOffset, height+25, x + xOffset, y + yOffset, height+25)
                        call SetLightningColor(this.lifeBar, 1., 1., 1., Math.Limit(thistype.DISPLAY_ELEV * relative + thistype.DISPLAY_OFFSET, Math.Min(thistype.DISPLAY_MIN, thistype.DISPLAY_MAX), Math.Max(thistype.DISPLAY_MIN, thistype.DISPLAY_MAX)))
                        call MoveLightningEx(this.lifeJuice, false, x - xOffset, y - yOffset, height+25, x + (relative * 2 - 1) * xOffset, y + (relative * 2 - 1) * yOffset, height+25)
                        call SetLightningColor(this.lifeJuice, 0., 1., 0., Math.Limit(thistype.DISPLAY_ELEV * relative + thistype.DISPLAY_OFFSET, Math.Min(thistype.DISPLAY_MIN, thistype.DISPLAY_MAX), Math.Max(thistype.DISPLAY_MIN, thistype.DISPLAY_MAX)))
                    endif*/

                    set relative = Unit(this).Mana.Get() / Unit(this).MaxMana.GetAll()

                    if (relative > thistype.DISPLAY_MAX_TRESHOLD) then
                        call MoveLightningEx(this.manaBar, false, 0., 0., 0., 0., 0., 0.)
                        call MoveLightningEx(this.manaJuice, false, 0., 0., 0., 0., 0., 0.)
                    else
                        call MoveLightningEx(this.manaBar, false, x - xOffset, y - yOffset, height+50, x + xOffset, y + yOffset, height+50)
                        call SetLightningColor(this.manaBar, 1., 1., 1., Math.Limit(thistype.DISPLAY_ELEV * relative + thistype.DISPLAY_OFFSET, Math.Min(thistype.DISPLAY_MIN, thistype.DISPLAY_MAX), Math.Max(thistype.DISPLAY_MIN, thistype.DISPLAY_MAX)))
                        call MoveLightningEx(this.manaJuice, false, x - xOffset, y - yOffset, height+50, x + (relative * 2 - 1) * xOffset, y + (relative * 2 - 1) * yOffset, height+50)
                        call SetLightningColor(this.manaJuice, 1., 0., 1., Math.Limit(thistype.DISPLAY_ELEV * relative + thistype.DISPLAY_OFFSET, Math.Min(thistype.DISPLAY_MIN, thistype.DISPLAY_MAX), Math.Max(thistype.DISPLAY_MIN, thistype.DISPLAY_MAX)))
                    endif

                    set relative = Unit(this).Stamina.Get() / Unit(this).MaxStamina.GetAll()

                    if (relative > thistype.DISPLAY_MAX_TRESHOLD) then
                        call MoveLightningEx(this.staminaBar, false, 0., 0., 0., 0., 0., 0.)
                        call MoveLightningEx(this.staminaJuice, false, 0., 0., 0., 0., 0., 0.)
                    else
                        call MoveLightningEx(this.staminaBar, false, x - xOffset, y - yOffset, height, x + xOffset, y + yOffset, height)
                        call SetLightningColor(this.staminaBar, 1., 1., 1., Math.Limit(thistype.DISPLAY_ELEV * relative + thistype.DISPLAY_OFFSET, Math.Min(thistype.DISPLAY_MIN, thistype.DISPLAY_MAX), Math.Max(thistype.DISPLAY_MIN, thistype.DISPLAY_MAX)))
                        call MoveLightningEx(this.staminaJuice, false, x - xOffset, y - yOffset, height, x + (relative * 2 - 1) * xOffset, y + (relative * 2 - 1) * yOffset, height)
                        call SetLightningColor(this.staminaJuice, 1., 1., 0., Math.Limit(thistype.DISPLAY_ELEV * relative + thistype.DISPLAY_OFFSET, Math.Min(thistype.DISPLAY_MIN, thistype.DISPLAY_MAX), Math.Max(thistype.DISPLAY_MIN, thistype.DISPLAY_MAX)))
                    endif
                endif

                set iteration = iteration - 1
                exitwhen (iteration < ARRAY_MIN)
            endloop
        endmethod

        static method Event_Destroy takes nothing returns nothing
            local Unit parent = UNIT.Event.GetTrigger()

            local thistype this = parent

            if (this.RemoveFromList()) then
                call thistype.UPDATE_TIMER.Pause()
            endif
            call parent.Event.Remove(CAST_EVENT)
            call parent.Event.Remove(DESTROY_EVENT)
            call parent.Event.Remove(END_CAST_EVENT)
            call this.channelTimer.Destroy()
            call DestroyLightning(this.channelBar)
            call DestroyLightning(this.channelJuice)
            //call DestroyLightning(this.lifeBar)
            //call DestroyLightning(this.lifeJuice)
            call DestroyLightning(this.manaBar)
            call DestroyLightning(this.manaJuice)
            call DestroyLightning(this.staminaBar)
            call DestroyLightning(this.staminaJuice)
        endmethod

        static method Event_EndCast takes nothing returns nothing
            local real duration = SPELL.Event.GetTrigger().GetChannelTime(SPELL.Event.GetLevel())
            local thistype this

            if (duration > 0.) then
                set this = thistype(UNIT.Event.GetTrigger())

                call MoveLightningEx(this.channelBar, false, 0., 0., 0., 0., 0., 0.)
                call MoveLightningEx(this.channelJuice, false, 0., 0., 0., 0., 0., 0.)
                call this.channelTimer.Abort()
            endif
        endmethod

        static method Event_SpellEffect takes nothing returns nothing
            local real duration = SPELL.Event.GetTrigger().GetChannelTime(SPELL.Event.GetLevel())

            if (duration > 0.) then
                call thistype(UNIT.Event.GetTrigger()).channelTimer.Start(duration, false, null)
            endif
        endmethod

        method Event_Create takes nothing returns nothing
            set this.channelBar = AddLightningEx("STAB", false, 0., 0., 0., 0., 0., 0.)
            set this.channelJuice = AddLightningEx("STAJ", false, 0., 0., 0., 0., 0., 0.)
            set this.channelTimer = Timer.Create()
            //set this.lifeBar = AddLightningEx("STAB", false, 0., 0., 0., 0., 0., 0.)
            //set this.lifeJuice = AddLightningEx("STAJ", false, 0., 0., 0., 0., 0., 0.)
            set this.manaBar = AddLightningEx("STAB", false, 0., 0., 0., 0., 0., 0.)
            set this.manaJuice = AddLightningEx("STAJ", false, 0., 0., 0., 0., 0., 0.)
            set this.staminaBar = AddLightningEx("STAB", false, 0., 0., 0., 0., 0., 0.)
            set this.staminaJuice = AddLightningEx("STAJ", false, 0., 0., 0., 0., 0., 0.)
            call Unit(this).Event.Add(CAST_EVENT)
            call Unit(this).Event.Add(DESTROY_EVENT)
            call Unit(this).Event.Add(END_CAST_EVENT)

            if (this.AddToList()) then
                call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.Update)
            endif
        endmethod

        static method Init takes nothing returns nothing
            set thistype.CAST_EVENT = Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_SpellEffect)
            set thistype.DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
            set thistype.END_CAST_EVENT = Event.Create(UNIT.Abilities.Events.Finish.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_EndCast)
            set thistype.UPDATE_TIMER = Timer.Create()
        endmethod
    endstruct

    //! runtextmacro Struct("Stamina")
        static Event DESTROY_EVENT
        static constant real INTERVAL = 0.125
        static constant real LOST_VALUE_PER_SECOND = 10.
        static Event MOVE_EVENT

        static constant real LOST_VALUE_PER_INTERVAL = thistype.LOST_VALUE_PER_SECOND * thistype.INTERVAL

        //! runtextmacro LinkToStruct("Stamina", "Exhaustion")

        //! runtextmacro CreateSimpleAddState_OnlyGet("real")

        method Set takes real value returns nothing
            local real oldValue = this.Get()

            set value = Math.Limit(value, 0., Unit(this).MaxStamina.GetAll())

            set this.value = value

            if ((value > 0.) == (oldValue > 0.)) then
                return
            endif

            if (value > 0.) then
                call this.Exhaustion.Subtract()
            else
                call this.Exhaustion.Add()
            endif
        endmethod

        //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

        static method Event_Move takes nothing returns nothing
            local thistype this = UNIT.Event.GetTrigger()

            local real value = Math.Max(0., this.Get() - thistype.LOST_VALUE_PER_INTERVAL)

            call this.Set(value)
        endmethod

        static method Event_Destroy takes nothing returns nothing
            local Unit parent = UNIT.Event.GetTrigger()

            local thistype this = parent

            call parent.Event.Remove(DESTROY_EVENT)
            call parent.Movement.Events.Interval.Remove(MOVE_EVENT)
        endmethod

        method Event_Create takes nothing returns nothing
            set this.value = Unit(this).MaxStamina.GetAll()
            call Unit(this).Event.Add(DESTROY_EVENT)
            call Unit(this).Movement.Events.Interval.Add(MOVE_EVENT, thistype.INTERVAL)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
            set thistype.MOVE_EVENT = Event.Create(NULL, NULL, function thistype.Event_Move)

            call thistype(NULL).Exhaustion.Init()
        endmethod
    endstruct

    //! runtextmacro Folder("StaminaRegeneration")
        //! runtextmacro Struct("Bonus")
            //! runtextmacro CreateSimpleAddState("real", "0.")
        endstruct

        //! runtextmacro Struct("Relative")
            //! runtextmacro CreateSimpleAddState("real", "1.")
        endstruct
    endscope

    //! runtextmacro Struct("StaminaRegeneration")
        static Event DESTROY_EVENT
        static Event MOVE_ENDING_EVENT
        static Event MOVE_START_EVENT
        static constant real UPDATE_TIME = 0.125
        static Timer UPDATE_TIMER

        real valuePerUpdate

        //! runtextmacro LinkToStruct("StaminaRegeneration", "Bonus")
        //! runtextmacro LinkToStruct("StaminaRegeneration", "Relative")

        //! runtextmacro CreateList("ACTIVE_LIST")
        //! runtextmacro CreateForEachList("FOR_EACH_LIST", "ACTIVE_LIST")
        //! runtextmacro CreateSimpleAddState_OnlyGet("real")

        method GetAll takes nothing returns real
            return (this.Get() * this.Relative.Get() + this.Bonus.Get())
        endmethod

        method Set takes real value returns nothing
            set this.value = value
            set this.valuePerUpdate = value * thistype.UPDATE_TIME
        endmethod

        //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

        static method Event_Destroy takes nothing returns nothing
            local Unit parent = UNIT.Event.GetTrigger()

            local thistype this = parent

            if (thistype.ACTIVE_LIST_Remove(this)) then
                call thistype.UPDATE_TIMER.Pause()
            endif
            call parent.Event.Remove(DESTROY_EVENT)
        endmethod

        static method UpdateByTimer takes nothing returns nothing
            local thistype this

            call thistype.FOR_EACH_LIST_Set()

            loop
                set this = thistype.FOR_EACH_LIST_FetchFirst()

                exitwhen (this == NULL)

                call Unit(this).Stamina.Add(this.valuePerUpdate)
            endloop
        endmethod

        static method Event_MoveEnding takes nothing returns nothing
            call thistype.ACTIVE_LIST_Add(UNIT.Event.GetTrigger())
        endmethod

        static method Event_MoveStart takes nothing returns nothing
            call thistype.ACTIVE_LIST_Remove(UNIT.Event.GetTrigger())
        endmethod

        method Event_Create takes nothing returns nothing
            call this.Set(25.)

            call Unit(this).Event.Add(DESTROY_EVENT)
            call Unit(this).Movement.Events.Reg(MOVE_ENDING_EVENT)
            call Unit(this).Movement.Events.Reg(MOVE_START_EVENT)

            if (thistype.ACTIVE_LIST_Add(this)) then
                call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.UpdateByTimer)
            endif

            call this.Bonus.Event_Create()
            call this.Relative.Event_Create()
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
            set thistype.MOVE_ENDING_EVENT = Event.Create(UNIT.Movement.Events.ENDING_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_MoveEnding)
            set thistype.MOVE_START_EVENT = Event.Create(UNIT.Movement.Events.START_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_MoveStart)
            set thistype.UPDATE_TIMER = Timer.Create()
        endmethod
    endstruct

    //! runtextmacro Struct("TimedLife")
        Timer durationTimer

        static method Event_BuffLose takes nothing returns nothing
            local Unit parent = UNIT.Event.GetTrigger()

            local thistype this = parent

            local Timer durationTimer = this.durationTimer

            call durationTimer.Destroy()
        endmethod

        static method EndingByTimer takes nothing returns nothing
            local thistype this = Timer.GetExpired().GetData()

            local Unit parent = this

            call parent.Buffs.Remove(thistype.DUMMY_BUFF)

            call parent.Kill()
        endmethod

        method Stop takes nothing returns nothing
            call Unit(this).Buffs.Remove(thistype.DUMMY_BUFF)
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local real duration = TEMP_REAL
            local Timer durationTimer = Timer.Create()
            local Unit parent = UNIT.Event.GetTrigger()

            local thistype this = parent

            set this.durationTimer = durationTimer
            call durationTimer.SetData(this)

            call UnitApplyTimedLife(parent.self, 'RTLF', duration + 0.01)

            call durationTimer.Start(duration, false, function thistype.EndingByTimer)
        endmethod

        method Start takes real duration returns nothing
            set TEMP_REAL = duration

            call Unit(this).Buffs.Add(thistype.DUMMY_BUFF, 1)
        endmethod

        static method Init takes nothing returns nothing
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        endmethod
    endstruct

    //! runtextmacro Struct("Transport")
        DummyUnit dummyUnit

        //! runtextmacro CreateSimpleAddState_OnlyGet("integer")

        method Is takes nothing returns boolean
            return (this.Get() > 0)
        endmethod

        static method Event_BuffLose takes nothing returns nothing
            local Unit parent = UNIT.Event.GetTrigger()

            local thistype this = parent

            local integer value = this.Get() - 1
            local DummyUnit dummyUnit

            set this.value = value
            if (value == 0) then
                /*call ShowUnit(Unit(this).self, true)*/
                set dummyUnit = this.dummyUnit

                call dummyUnit.Kill()

                call dummyUnit.DestroyInstantly()

                call Unit(this).Select(Unit(this).Owner.Get(), true)
            endif
        endmethod

        method Subtract takes nothing returns nothing
            call Unit(this).Buffs.Subtract(thistype.DUMMY_BUFF)
        endmethod

        method SetPosition takes real x, real y returns nothing
            local DummyUnit dummyUnit = this.dummyUnit

            call dummyUnit.Position.X.Set(x)
            call dummyUnit.Position.Y.Set(y)
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local Unit parent = UNIT.Event.GetTrigger()

            local thistype this = parent

            local integer value = this.Get() + 1
            local DummyUnit dummyUnit

            set this.value = value
            if (value == 1) then
                /*call ShowUnit(Unit(this).self, false)
                //call Unit(this).Select(Unit(this).Owner.Get(), false)*/
                set dummyUnit = DummyUnit.Create(thistype.DUMMY_UNIT_ID, Unit(this).Position.X.Get(), Unit(this).Position.Y.Get(), 0., 0.)

                set this.dummyUnit = dummyUnit
                call dummyUnit.Abilities.AddBySelf(thistype.CARGO_SPELL_ID)
                call dummyUnit.Abilities.AddBySelf(thistype.LOAD_IN_SPELL_ID)
                call dummyUnit.Owner.Set(Unit(this).Owner.Get())

                call dummyUnit.Order.UnitTarget(Order.LOAD, this)
            endif
        endmethod

        method Add takes nothing returns nothing
            call Unit(this).Buffs.Add(thistype.DUMMY_BUFF, 1)
        endmethod

        method AddTimed takes real duration returns nothing
            call Unit(this).Buffs.Timed.Start(thistype.DUMMY_BUFF, 1, duration)
        endmethod

        method Event_Create takes nothing returns nothing
            set this.value = 0
        endmethod

        static method Init takes nothing returns nothing
            call InitAbility(thistype.CARGO_SPELL_ID)
            call InitAbility(thistype.LOAD_IN_SPELL_ID)

            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        endmethod
    endstruct

    //! runtextmacro Struct("Hero")
        //! runtextmacro LinkToStruct("Unit", "Agility")
        //! runtextmacro LinkToStruct("Unit", "Intelligence")
        //! runtextmacro LinkToStruct("Unit", "Level")
        //! runtextmacro LinkToStruct("Unit", "SkillPoints")
        //! runtextmacro LinkToStruct("Unit", "Strength")

        method Revive takes real x, real y returns nothing
            call Unit(this).Classes.Remove(UnitClass.DEAD)
            call Unit(this).Revival.Set(false)
            call ReviveHero(Unit(this).self, x, y, false)

            call Unit(this).Revival.Events.Start()
        endmethod

        method SelectSpell takes Spell whichSpell, boolean useSkillPoints returns nothing
            if (useSkillPoints == false) then
                call this.SkillPoints.Add(1)
            endif

            call SelectHeroSkill(Unit(this).self, HeroSpell.GetLearnerSpellId(whichSpell, Unit(this).Abilities.GetLevel(whichSpell) + 1))
        endmethod
    endstruct

    //! runtextmacro Folder("Position")
        //! runtextmacro Folder("Timed")
            //! runtextmacro Struct("Accelerated")
                static Event DEATH_EVENT
                //! runtextmacro GetKey("KEY")
                //! runtextmacro GetKeyArray("KEY_ARRAY")
                //! runtextmacro CreateTimeByFramesAmount("UPDATE_TIME", "2")
                static Timer UPDATE_TIMER

                Timer durationTimer
                Unit parent
                real xAdd
                real xAddAdd
                real yAdd
                real yAddAdd
                real zAdd
                real zAddAdd

                method Ending takes Timer durationTimer, Unit parent returns nothing
                    call this.deallocate()
                    call durationTimer.Destroy()
                    if (parent.Data.Integer.Table.Remove(KEY_ARRAY, this)) then
                        call parent.Event.Remove(DEATH_EVENT)
                    endif
                    if (this.RemoveFromList()) then
                        call thistype.UPDATE_TIMER.Pause()
                    endif
                endmethod

                static method Event_Death takes nothing returns nothing
                    local Unit parent = UNIT.Event.GetTrigger()
                    local thistype this

                    local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

                    loop
                        set this = parent.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                        call this.Ending(this.durationTimer, parent)

                        set iteration = iteration - 1
                        exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
                    endloop
                endmethod

                static method EndingByTimer takes nothing returns nothing
                    local Timer durationTimer = Timer.GetExpired()

                    local thistype this = durationTimer.GetData()

                    call this.Ending(durationTimer, this.parent)
                endmethod

                static method Update takes nothing returns nothing
                    local integer iteration = thistype.ALL_COUNT
                    local Unit parent
                    local thistype this
                    local real xAdd
                    local real yAdd
                    local real zAdd

                    loop
                        set this = thistype.ALL[iteration]

                        set parent = this.parent
                        set xAdd = this.xAdd + this.xAddAdd
                        set yAdd = this.yAdd + this.yAddAdd
                        set zAdd = this.zAdd + this.zAddAdd

                        set this.xAdd = xAdd
                        set this.yAdd = yAdd
                        set this.zAdd = zAdd

                        call parent.Position.X.Add(xAdd)
                        call parent.Position.Y.Add(yAdd)
                        call parent.Position.Z.Add(zAdd)

                        set iteration = iteration - 1
                        exitwhen (iteration < ARRAY_MIN)
                    endloop
                endmethod

                method AddIn takes real xAdd, real yAdd, real zAdd, real xAddAdd, real yAddAdd, real zAddAdd, real duration returns nothing
                    local Timer durationTimer
                    local Unit parent
                    local integer wavesAmount

                    if (UNIT.Position.Timed.TargetConditions(this) == false) then
                        return
                    endif

                    set durationTimer = Timer.Create()
                    set parent = this
                    set wavesAmount = Real.ToInt(duration / thistype.UPDATE_TIME)

                    set this = thistype.allocate()

                    set this.durationTimer = durationTimer
                    set this.parent = parent
                    set this.xAdd = xAdd / wavesAmount
                    set this.xAddAdd = xAddAdd / wavesAmount
                    set this.yAdd = yAdd / wavesAmount
                    set this.yAddAdd = yAddAdd / wavesAmount
                    set this.zAdd = zAdd / wavesAmount
                    set this.zAddAdd = zAddAdd / wavesAmount
                    call durationTimer.SetData(this)
                    if (parent.Data.Integer.Table.Add(KEY_ARRAY, this)) then
                        call parent.Event.Add(DEATH_EVENT)
                    endif

                    if (this.AddToList()) then
                        call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.Update)
                    endif

                    call durationTimer.Start(duration, false, function thistype.EndingByTimer)
                endmethod

                method AddForNoCheck takes real xAdd, real yAdd, real zAdd, real xAddAdd, real yAddAdd, real zAddAdd, real duration returns nothing
                    local Timer durationTimer = Timer.Create()
                    local Unit parent = this

                    set this = thistype.allocate()

                    set this.durationTimer = durationTimer
                    set this.parent = parent
                    set this.xAdd = xAdd
                    set this.xAddAdd = xAddAdd
                    set this.yAdd = yAdd
                    set this.yAddAdd = yAddAdd
                    set this.zAdd = zAdd
                    set this.zAddAdd = zAddAdd
                    call durationTimer.SetData(this)
                    if (parent.Data.Integer.Table.Add(KEY_ARRAY, this)) then
                        call parent.Event.Add(DEATH_EVENT)
                    endif

                    if (this.AddToList()) then
                        call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.Update)
                    endif

                    call durationTimer.Start(duration, false, function thistype.EndingByTimer)
                endmethod

                method AddFor takes real xAdd, real yAdd, real zAdd, real xAddAdd, real yAddAdd, real zAddAdd, real duration returns nothing
                    if (UNIT.Position.Timed.TargetConditions(this)) then
                        call this.AddForNoCheck(xAdd, yAdd, zAdd, xAddAdd, yAddAdd, zAddAdd, duration)
                    endif
                endmethod

                method AddSpeedDirection takes real speed, real acceleration, real angle, real duration returns nothing
                    local real xPart = Math.Cos(angle)
                    local real yPart = Math.Sin(angle)

                    set acceleration = acceleration * thistype.UPDATE_TIME * thistype.UPDATE_TIME
                    set speed = speed * thistype.UPDATE_TIME

                    call this.AddFor(speed * xPart, speed * yPart, 0., acceleration * xPart, acceleration * yPart, 0., duration)
                endmethod

                method AddKnockback takes real speed, real acceleration, real angle, real duration returns nothing
                    call Unit(this).Movement.SubtractTimed(duration)
                    call this.AddSpeedDirection(speed, acceleration, angle, duration)
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Death)
                    set thistype.UPDATE_TIMER = Timer.Create()
                endmethod
            endstruct
        endscope

        //! runtextmacro Struct("Timed")
            static Event DEATH_EVENT
            //! runtextmacro GetKey("KEY")
            //! runtextmacro GetKeyArray("KEY_ARRAY")
            //! runtextmacro CreateTimeByFramesAmount("UPDATE_TIME", "2")
            static Timer UPDATE_TIMER

            Timer durationTimer
            Unit parent
            real xAdd
            real yAdd
            real zAdd

            //! runtextmacro LinkToStruct("Timed", "Accelerated")

            method Ending takes Timer durationTimer, Unit parent returns nothing
                call this.deallocate()
                call durationTimer.Destroy()
                if (parent.Data.Integer.Table.Remove(KEY_ARRAY, this)) then
                    call parent.Event.Remove(DEATH_EVENT)
                endif
                if (this.RemoveFromList()) then
                    call thistype.UPDATE_TIMER.Pause()
                endif
            endmethod

            static method Event_Death takes nothing returns nothing
                local Unit parent = UNIT.Event.GetTrigger()
                local thistype this

                local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

                loop
                    set this = parent.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                    call this.Ending(this.durationTimer, parent)

                    set iteration = iteration - 1
                    exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
                endloop
            endmethod

            static method EndingByTimer takes nothing returns nothing
                local Timer durationTimer = Timer.GetExpired()

                local thistype this = durationTimer.GetData()

                call this.Ending(durationTimer, this.parent)
            endmethod

            static method Update takes nothing returns nothing
                local integer iteration = thistype.ALL_COUNT
                local Unit parent
                local thistype this

                loop
                    set this = thistype.ALL[iteration]

                    set parent = this.parent

                    call parent.Position.X.Add(this.xAdd)
                    call parent.Position.Y.Add(this.yAdd)
                    call parent.Position.Z.Add(this.zAdd)

                    set iteration = iteration - 1
                    exitwhen (iteration < ARRAY_MIN)
                endloop
            endmethod

            static method TargetConditions takes Unit target returns boolean
                if (target.Type.Get().Speed.Get() <= 0.) then
                    return false
                endif

                return true
            endmethod

            method AddNoCheck takes real xAdd, real yAdd, real zAdd, real duration returns nothing
                local Timer durationTimer = Timer.Create()
                local Unit parent = this
                local integer wavesAmount = Real.ToInt(duration / thistype.UPDATE_TIME)

                set this = thistype.allocate()

                set this.durationTimer = durationTimer
                set this.parent = parent
                set this.xAdd = xAdd / wavesAmount
                set this.yAdd = yAdd / wavesAmount
                set this.zAdd = zAdd / wavesAmount
                call durationTimer.SetData(this)
                if (parent.Data.Integer.Table.Add(KEY_ARRAY, this)) then
                    call parent.Event.Add(DEATH_EVENT)
                endif

                if (this.AddToList()) then
                    call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.Update)
                endif

                call durationTimer.Start(duration, false, function thistype.EndingByTimer)
            endmethod

            method Add takes real xAdd, real yAdd, real zAdd, real duration returns nothing
                if (thistype.TargetConditions(this) == false) then
                    return
                endif

                call this.AddNoCheck(xAdd, yAdd, zAdd, duration)
            endmethod

            method AddSpeedDirection takes real speed, real angle, real duration returns nothing
                //set speed = speed * thistype.UPDATE_TIME

                call this.Add(speed * Math.Cos(angle), speed * Math.Sin(angle), 0., duration)
            endmethod

            method AddKnockback takes real speed, real angle, real duration returns nothing
                call Unit(this).Movement.SubtractTimed(duration)
                call this.AddSpeedDirection(speed, angle, duration)
            endmethod

            method Set takes real x, real y, real z, real duration returns nothing
                call this.Add(x - Unit(this).Position.X.Get(), y - Unit(this).Position.Y.Get(), z - Unit(this).Position.Z.Get(), duration)
            endmethod

            method SetXY takes real x, real y, real duration returns nothing
                call this.Set(x, y, Spot.GetHeight(x, y) + Unit(this).Position.Z.GetFlyHeight(), duration)
            endmethod

            static method Init takes nothing returns nothing
                set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Death)
                set thistype.UPDATE_TIMER = Timer.Create()

                call thistype(NULL).Accelerated.Init()
            endmethod
        endstruct

        //! runtextmacro Struct("X")
            method Get takes nothing returns real
                return GetUnitX(Unit(this).self)
            endmethod

            method Set takes real value returns nothing
                call SetUnitX(Unit(this).self, value)
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")
        endstruct

        //! runtextmacro Struct("Y")
            method Get takes nothing returns real
                return GetUnitY(Unit(this).self)
            endmethod

            method Set takes real value returns nothing
                call SetUnitY(Unit(this).self, value)
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")
        endstruct

        //! runtextmacro Struct("Z")
            method GetFlyHeight takes nothing returns real
                return GetUnitFlyHeight(Unit(this).self)
            endmethod

            method GetByCoords takes real x, real y returns real
                return (Spot.GetHeight(x, y) + this.GetFlyHeight())
            endmethod

            method SetByCoords takes real x, real y, real z returns nothing
                call SetUnitFlyHeight(Unit(this).self, z - Spot.GetHeight(x, y), 0.)
            endmethod

            method Get takes nothing returns real
                return this.GetByCoords(Unit(this).Position.X.Get(), Unit(this).Position.Y.Get())
            endmethod

            method Set takes real z returns nothing
                call this.SetByCoords(Unit(this).Position.X.Get(), Unit(this).Position.Y.Get(), z)
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyAdd_NotStart("real")

            method Event_Create takes nothing returns nothing
                call Unit(this).Abilities.AddBySelf(BJUnit.Z_ENABLER_SPELL_ID)
                call Unit(this).Abilities.RemoveBySelf(BJUnit.Z_ENABLER_SPELL_ID)
            endmethod

            static method Init takes nothing returns nothing
                call InitAbility(BJUnit.Z_ENABLER_SPELL_ID)
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Position")
        //! runtextmacro LinkToStruct("Position", "Timed")

        //! runtextmacro LinkToStruct("Position", "X")
        //! runtextmacro LinkToStruct("Position", "Y")
        //! runtextmacro LinkToStruct("Position", "Z")

        method DistToLine takes real sourceX, real sourceY, real length, real angle, real widthStart, real widthEnd returns real
            return Math.Max(0., Math.Shapes.DistToLine(sourceX, sourceY, length, angle, widthStart, widthEnd, this.X.Get(), this.Y.Get()) - Unit(this).CollisionSize.Get(true))
        endmethod

        method InLine takes real sourceX, real sourceY, real length, real angle, real widthStart, real widthEnd returns boolean
            return (this.DistToLine(sourceX, sourceY, length, angle, widthStart, widthEnd) == 0.)
        endmethod

        method InRangeWithCollision takes real x, real y, real radius returns boolean
            local real dX = x - Unit(this).Position.X.Get()
            local real dY = y - Unit(this).Position.Y.Get()

            set radius = (radius + Unit(this).CollisionSize.Get(true))

            return (dX * dX + dY * dY < radius * radius)
        endmethod

        method InRangeWithCollisionWithZ takes real x, real y, real z, real radius returns boolean
            local real dX = x - this.X.Get()
            local real dY = y - this.Y.Get()
            local real dZ = z - this.Z.Get()

            set radius = (radius + Unit(this).CollisionSize.Get(true))

            return (dX * dX + dY * dY + dZ * dZ < radius * radius)
        endmethod

        method Set takes real x, real y, real z returns nothing
            call this.X.Set(x)
            call this.Y.Set(y)

            call this.Z.SetByCoords(x, y, z)
        endmethod

        method SetWithCollision takes real x, real y returns nothing
            call SetUnitPosition(Unit(this).self, x, y)
        endmethod

        method SetXY takes real x, real y returns nothing
            call this.X.Set(x)
            call this.Y.Set(y)
        endmethod

        method SetXYWithTerrainWalkableCollision takes real x, real y returns nothing
            if (Spot.IsWalkable(x, y)) then
                call this.X.Set(x)
                call this.Y.Set(y)
            endif
        endmethod

        method SetXYZ takes real x, real y, real z returns nothing
            call this.X.Set(x)
            call this.Y.Set(y)

            call this.Z.SetByCoords(x, y, z)
        endmethod

        method Event_Create takes nothing returns nothing
            call this.Z.Event_Create()
        endmethod

        static method Init takes nothing returns nothing
            call thistype(NULL).Z.Init()

            call thistype(NULL).Timed.Init()
        endmethod
    endstruct

    //! runtextmacro Struct("Selection")
        static Event DEATH_EVENT
        static EventType ENDING_EVENT_TYPE
        static Trigger ENDING_TRIGGER
        //! runtextmacro GetKeyArray("KEY_ARRAY")
        static EventType REPEAT_EVENT_TYPE
        static EventType START_EVENT_TYPE
        static Trigger START_TRIGGER

        method Count takes nothing returns integer
            return Unit(this).Data.Integer.Table.Count(KEY_ARRAY)
        endmethod

        method CountAtPlayer takes User whichPlayer returns integer
            return whichPlayer.Data.Integer.Table.Count(KEY_ARRAY)
        endmethod

        method GetFromPlayer takes User whichPlayer, integer index returns Unit
            return whichPlayer.Data.Integer.Table.Get(KEY_ARRAY, index)
        endmethod

        method Ending_TriggerEvents takes User whichPlayer returns nothing
            local integer iteration = EventPriority.ALL_COUNT
            local integer iteration2
            local EventPriority priority

            loop
                exitwhen (iteration < ARRAY_MIN)

                set priority = EventPriority.ALL[iteration]

                set iteration2 = Event.CountAtStatics(thistype.ENDING_EVENT_TYPE, priority)

                loop
                    exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                    call UNIT.Event.SetTrigger(this)
                    call USER.Event.SetTrigger(whichPlayer)

                    call Event.GetFromStatics(thistype.ENDING_EVENT_TYPE, priority, iteration2).Run()

                    set iteration2 = iteration2 - 1
                endloop

                set iteration2 = Unit(this).Event.Count(thistype.ENDING_EVENT_TYPE, priority)

                loop
                    exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                    call UNIT.Event.SetTrigger(this)
                    call USER.Event.SetTrigger(whichPlayer)

                    call Unit(this).Event.Get(thistype.ENDING_EVENT_TYPE, priority, iteration2).Run()

                    set iteration2 = iteration2 - 1
                endloop

                set iteration = iteration - 1
            endloop
        endmethod

        method Ending takes User whichPlayer returns nothing
            call whichPlayer.Data.Integer.Table.Remove(KEY_ARRAY, this)
            if (Unit(this).Data.Integer.Table.Remove(KEY_ARRAY, whichPlayer)) then
                call Unit(this).Event.Remove(DEATH_EVENT)
            endif

            call this.Ending_TriggerEvents(whichPlayer)
        endmethod

        static method EndingTrig takes nothing returns nothing
            call thistype(UNIT.Event.Native.GetTrigger()).Ending(USER.Event.Native.GetTrigger())
        endmethod

        static method Event_Death takes nothing returns nothing
            local Unit parent = UNIT.Event.GetTrigger()

            local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

            loop
                call thistype(parent).Ending(parent.Data.Integer.Table.Get(KEY_ARRAY, iteration))

                set iteration = iteration - 1
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
            endloop
        endmethod

        method Repeat_TriggerEvents takes User whichPlayer returns nothing
            local integer iteration = EventPriority.ALL_COUNT
            local integer iteration2
            local EventPriority priority

            loop
                exitwhen (iteration < ARRAY_MIN)

                set priority = EventPriority.ALL[iteration]

                set iteration2 = Event.CountAtStatics(thistype.REPEAT_EVENT_TYPE, priority)

                loop
                    exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                    call UNIT.Event.SetTrigger(this)
                    call USER.Event.SetTrigger(whichPlayer)

                    call Event.GetFromStatics(thistype.REPEAT_EVENT_TYPE, priority, iteration2).Run()

                    set iteration2 = iteration2 - 1
                endloop

                set iteration2 = Unit(this).Event.Count(thistype.REPEAT_EVENT_TYPE, priority)

                loop
                    exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                    call UNIT.Event.SetTrigger(this)
                    call USER.Event.SetTrigger(whichPlayer)

                    call Unit(this).Event.Get(thistype.REPEAT_EVENT_TYPE, priority, iteration2).Run()

                    set iteration2 = iteration2 - 1
                endloop

                set iteration = iteration - 1
            endloop
        endmethod

        method Start_TriggerEvents takes User whichPlayer returns nothing
            local integer iteration = EventPriority.ALL_COUNT
            local integer iteration2
            local EventPriority priority

            loop
                exitwhen (iteration < ARRAY_MIN)

                set priority = EventPriority.ALL[iteration]

                set iteration2 = Event.CountAtStatics(thistype.START_EVENT_TYPE, priority)

                loop
                    exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                    call UNIT.Event.SetTrigger(this)
                    call USER.Event.SetTrigger(whichPlayer)

                    call Event.GetFromStatics(thistype.START_EVENT_TYPE, priority, iteration2).Run()

                    set iteration2 = iteration2 - 1
                endloop

                set iteration2 = Unit(this).Event.Count(thistype.START_EVENT_TYPE, priority)

                loop
                    exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                    call UNIT.Event.SetTrigger(this)
                    call USER.Event.SetTrigger(whichPlayer)

                    call Unit(this).Event.Get(thistype.START_EVENT_TYPE, priority, iteration2).Run()

                    set iteration2 = iteration2 - 1
                endloop

                set iteration = iteration - 1
            endloop
        endmethod

        method Start takes User whichPlayer returns nothing
            if (whichPlayer.Data.Integer.Table.Contains(KEY_ARRAY, this) == false) then
                call whichPlayer.Data.Integer.Table.Add(KEY_ARRAY, this)
                if (Unit(this).Data.Integer.Table.Add(KEY_ARRAY, whichPlayer)) then
                    call Unit(this).Event.Add(DEATH_EVENT)
                endif

                call this.Start_TriggerEvents(whichPlayer)
            endif

            call this.Repeat_TriggerEvents(whichPlayer)
        endmethod

        static method StartTrig takes nothing returns nothing
            call thistype(UNIT.Event.Native.GetTrigger()).Start(USER.Event.Native.GetTrigger())
        endmethod

        static method Init takes nothing returns nothing
            set DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Death)
            set thistype.ENDING_EVENT_TYPE = EventType.Create()
            set thistype.ENDING_TRIGGER = Trigger.CreateFromCode(function thistype.EndingTrig)
            set thistype.REPEAT_EVENT_TYPE = EventType.Create()
            set thistype.START_EVENT_TYPE = EventType.Create()
            set thistype.START_TRIGGER = Trigger.CreateFromCode(function thistype.StartTrig)

            call thistype.ENDING_TRIGGER.RegisterEvent.PlayerUnit(User.ANY, EVENT_PLAYER_UNIT_DESELECTED, null)
            call thistype.START_TRIGGER.RegisterEvent.PlayerUnit(User.ANY, EVENT_PLAYER_UNIT_SELECTED, null)
        endmethod
    endstruct

    //! runtextmacro Struct("SightRange")
        //! runtextmacro Unit_CreateStateWithTemporaryAbilities("SightRange", "")
//* this.Relative.Get() + this.Bonus.Get()

        static method Event_TypeChange takes nothing returns nothing
            local UnitType sourceType = UNIT_TYPE.Event.GetSource()
            local UnitType targetType = UNIT_TYPE.Event.GetTrigger()
            local thistype this = UNIT.Event.GetTrigger()

            //set this.displayedValue = targetType.SightRange.GetBJ()
            set this.displayedValue = this.displayedValue + targetType.SightRange.GetBJ() - sourceType.SightRange.GetBJ()

            call this.Add(targetType.SightRange.Get() - sourceType.SightRange.Get())
        endmethod

        method Event_Create takes nothing returns nothing
            local UnitType thisType = Unit(this).Type.Get()

            set this.displayedValue = thisType.SightRange.GetBJ()

            call this.Set(thisType.SightRange.Get())
        endmethod

        static method Init takes nothing returns nothing
            call Event.Create(UNIT.Type.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TypeChange).AddToStatics()
        endmethod
    endstruct

    ///! runtextmacro Folder("Hero")
        globals
            constant real DAMAGE_BONUS_PER_HERO_ATTRIBUTE_POINT = 0.3
            constant real PRIMARY_ATTRIBUTE_FACTOR = 1.25
        endglobals

        //! textmacro CreateHeroAttribute takes name
            real value

            method Get takes nothing returns real
                return this.value
            endmethod

            method Set takes real amount returns nothing
                local real amount2
                local real oldAmount = this.Get()
                local integer packet
                local integer packetLevel

                set amount2 = amount - oldAmount
                set this.value = amount

                if (amount * oldAmount <= 0.) then
                    if (oldAmount < 0.) then
                        set packetLevel = DECREASING_SPELLS_MAX

                        loop
                            call Unit(this).Abilities.RemoveBySelf(thistype.DECREASING_SPELLS_ID[packetLevel])

                            set packetLevel = packetLevel - 1
                            exitwhen (packetLevel < ARRAY_MIN)
                        endloop
                    else
                        set packetLevel = INCREASING_SPELLS_MAX

                        loop
                            call Unit(this).Abilities.RemoveBySelf(thistype.INCREASING_SPELLS_ID[packetLevel])

                            set packetLevel = packetLevel - 1
                            exitwhen (packetLevel < ARRAY_MIN)
                        endloop
                    endif
                    if (amount < 0.) then
                        set amount2 = -amount

                        set packetLevel = Math.MinI(Math.LogOf2I(Real.ToInt(Math.Max(Math.Abs(oldAmount), Math.Abs(amount)))), DECREASING_SPELLS_MAX)

                        loop
                            exitwhen (amount2 < 1)

                            set packet = PACKETS[packetLevel]

                            if (packet <= amount2) then
                                call Unit(this).Abilities.AddBySelf(thistype.DECREASING_SPELLS_ID[packetLevel])
                                set amount2 = amount2 - packet
                            endif

                            set packetLevel = packetLevel - 1
                        endloop
                    else
                        set amount2 = amount
                        set packetLevel = Math.MinI(Math.LogOf2I(Real.ToInt(Math.Max(Math.Abs(oldAmount), Math.Abs(amount)))), INCREASING_SPELLS_MAX)

                        loop
                            exitwhen (amount2 < 1.)

                            set packet = PACKETS[packetLevel]

                            if (packet <= amount2) then
                                call Unit(this).Abilities.AddBySelf(thistype.INCREASING_SPELLS_ID[packetLevel])
                                set amount2 = amount2 - packet
                            endif

                            set packetLevel = packetLevel - 1
                        endloop
                    endif
                else
                    set packetLevel = Math.MinI(Math.LogOf2I(Real.ToInt(Math.Max(Math.Abs(oldAmount), Math.Abs(amount)))), DECREASING_SPELLS_MAX)

                    if (amount < 0.) then
                        set amount2 = -amount

                        loop
                            exitwhen (packetLevel < ARRAY_MIN)

                            set packet = PACKETS[packetLevel]

                            if (packet <= amount2) then
                                call Unit(this).Abilities.AddBySelf(thistype.DECREASING_SPELLS_ID[packetLevel])
                                set amount2 = amount2 - packet
                            else
                                call Unit(this).Abilities.RemoveBySelf(thistype.DECREASING_SPELLS_ID[packetLevel])
                            endif

                            set packetLevel = packetLevel - 1
                        endloop
                    else
                        set amount2 = amount
                        set packetLevel = Math.MinI(Math.LogOf2I(Real.ToInt(Math.Max(Math.Abs(oldAmount), Math.Abs(amount)))), INCREASING_SPELLS_MAX)

                        loop
                            exitwhen (packetLevel < ARRAY_MIN)

                            set packet = PACKETS[packetLevel]

                            if (packet <= amount2) then
                                call Unit(this).Abilities.AddBySelf(thistype.INCREASING_SPELLS_ID[packetLevel])
                                set amount2 = amount2 - packet
                            else
                                call Unit(this).Abilities.RemoveBySelf(thistype.INCREASING_SPELLS_ID[packetLevel])
                            endif

                            set packetLevel = packetLevel - 1
                        endloop
                    endif
                endif
                call Unit(this).$name$.AddBonuses(Real.ToInt(amount) - oldAmount, true)
            endmethod

            method Add takes real value returns nothing
                call this.Set(this.Get() + value)
            endmethod

            method Event_Create takes nothing returns nothing
                set this.value = 0.
            endmethod

            method Subtract takes real value returns nothing
                call this.Set(this.Get() - value)
            endmethod
        //! endtextmacro

        //! runtextmacro Folder("Level")
            //! runtextmacro Struct("Events")
                static Group DUMMY_GROUP
                static Trigger DUMMY_TRIGGER
                static boolean IGNORE_NEXT = false

                static method TrigConds takes Unit parent returns boolean
                    if (thistype.DUMMY_GROUP.ContainsUnit(parent) == false) then
                        return false
                    endif

                    return true
                endmethod

                static method Trig takes nothing returns nothing
                    local Unit parent = UNIT.Event.Native.GetTrigger()

                    if (thistype.TrigConds(parent) == false) then
                        return
                    endif

                    if (thistype.IGNORE_NEXT) then
                        set thistype.IGNORE_NEXT = false

                        return
                    endif

                    call parent.Level.SetByEvent()
                endmethod

                method Event_Destroy takes nothing returns nothing
                    call thistype.DUMMY_GROUP.RemoveUnit(this)
                endmethod

                method Event_Create takes nothing returns nothing
                    call thistype.DUMMY_GROUP.AddUnit(this)
                endmethod

                static method Init takes nothing returns nothing
                    set thistype.DUMMY_GROUP = Group.Create()
                    set thistype.DUMMY_TRIGGER = Trigger.CreateFromCode(function thistype.Trig)

                    call thistype.DUMMY_TRIGGER.RegisterEvent.PlayerUnit(User.ANY, EVENT_PLAYER_HERO_LEVEL, null)
                endmethod
            endstruct
        endscope

        //! runtextmacro Struct("Level")
            static integer array EXP_MIN

            //! runtextmacro LinkToStruct("Level", "Events")

            //! runtextmacro CreateSimpleAddState_OnlyGet("integer")

            method GetHeroLvl takes nothing returns integer
                return GetHeroLevel(Unit(this).self)
            endmethod

            method AddBonuses takes integer oldValue, integer value returns nothing
                local UnitType thisType = Unit(this).Type.Get()

                call Unit(this).Exp.Set(thistype.EXP_MIN[ARRAY_MIN + value])

                set value = value - oldValue

                call Unit(this).Agility.Add(value * thisType.Hero.Agility.PerLevel.Get())
                call Unit(this).Armor.Add(value * thisType.Hero.ArmorPerLevel.Get())
                call Unit(this).Intelligence.Add(value * thisType.Hero.Intelligence.PerLevel.Get())
                call Unit(this).SkillPoints.Add(value)
                call Unit(this).Strength.Add(value * thisType.Hero.Strength.PerLevel.Get())
            endmethod

            method SetByEvent takes nothing returns nothing
                local integer oldValue = this.Get()
                local integer value = this.GetHeroLvl()

                set this.value = value

                call UnitModifySkillPoints(Unit(this).self, oldValue - value)

                if (value == 0) then
                    return
                endif

                call this.AddBonuses(oldValue, value)
            endmethod

            method Set takes integer value returns nothing
                local integer oldValue = this.Get()

                if (value != oldValue) then
                    call SetHeroLevel(Unit(this).self, value, true)
                endif
            endmethod

            method Add takes integer value returns nothing
                call this.Set(this.Get() + value)
            endmethod

            method Event_Create takes nothing returns nothing
                local integer value = this.GetHeroLvl()

                call Unit(this).SkillPoints.Set(1)

                set this.value = value
                call this.AddBonuses(1, value)

                call this.Events.Event_Create()
            endmethod

            static method Init takes nothing returns nothing
                set thistype.EXP_MIN[ARRAY_MIN + 1] = 0
                set thistype.EXP_MIN[ARRAY_MIN + 2] = 300
                set thistype.EXP_MIN[ARRAY_MIN + 3] = thistype.EXP_MIN[ARRAY_MIN + 2] + 300
                set thistype.EXP_MIN[ARRAY_MIN + 4] = thistype.EXP_MIN[ARRAY_MIN + 3] + 500
                set thistype.EXP_MIN[ARRAY_MIN + 5] = thistype.EXP_MIN[ARRAY_MIN + 4] + 800
                set thistype.EXP_MIN[ARRAY_MIN + 6] = thistype.EXP_MIN[ARRAY_MIN + 5] + 1200
                set thistype.EXP_MIN[ARRAY_MIN + 7] = thistype.EXP_MIN[ARRAY_MIN + 6] + 1700
                set thistype.EXP_MIN[ARRAY_MIN + 8] = thistype.EXP_MIN[ARRAY_MIN + 7] + 2300
                set thistype.EXP_MIN[ARRAY_MIN + 9] = thistype.EXP_MIN[ARRAY_MIN + 8] + 3000
                set thistype.EXP_MIN[ARRAY_MIN + 10] = thistype.EXP_MIN[ARRAY_MIN + 9] + 3800
                set thistype.EXP_MIN[ARRAY_MIN + 11] = thistype.EXP_MIN[ARRAY_MIN + 10] + 4700
                set thistype.EXP_MIN[ARRAY_MIN + 12] = thistype.EXP_MIN[ARRAY_MIN + 11] + 5700
                set thistype.EXP_MIN[ARRAY_MIN + 13] = thistype.EXP_MIN[ARRAY_MIN + 12] + 6800
                set thistype.EXP_MIN[ARRAY_MIN + 14] = thistype.EXP_MIN[ARRAY_MIN + 13] + 8000
                set thistype.EXP_MIN[ARRAY_MIN + 15] = thistype.EXP_MIN[ARRAY_MIN + 14] + 9300
                set thistype.EXP_MIN[ARRAY_MIN + 16] = thistype.EXP_MIN[ARRAY_MIN + 15] + 10700
                set thistype.EXP_MIN[ARRAY_MIN + 17] = thistype.EXP_MIN[ARRAY_MIN + 16] + 12200
                set thistype.EXP_MIN[ARRAY_MIN + 18] = thistype.EXP_MIN[ARRAY_MIN + 17] + 13800
                set thistype.EXP_MIN[ARRAY_MIN + 19] = thistype.EXP_MIN[ARRAY_MIN + 18] + 15500
                set thistype.EXP_MIN[ARRAY_MIN + 20] = thistype.EXP_MIN[ARRAY_MIN + 19] + 17300

                call thistype(NULL).Events.Init()
            endmethod
        endstruct

        //! runtextmacro Folder("Agility")
            //! runtextmacro Struct("Bonus")
                //! runtextmacro CreateHeroAttribute("Agility")

                static method Init takes nothing returns nothing
                endmethod
            endstruct
        endscope

        //! runtextmacro Struct("Agility")
            static constant integer ATTRIBUTE_AGILITY = 1

            static constant real ATTACK_SPEED_BONUS = 0.
            static constant real CRITICAL_BONUS = 0.003
            static constant real EVASION_BONUS = 0.003
            static constant real STAMINA_BONUS = 4.

            //! runtextmacro LinkToStruct("Agility", "Bonus")

            method AddBonuses takes real amount, boolean asBonus returns nothing
                if (Unit(this).Type.Get().Hero.PrimaryAttribute.Get() == ATTRIBUTE_AGILITY) then
                    set amount = PRIMARY_ATTRIBUTE_FACTOR * amount
                endif
                if (asBonus) then
                    call Unit(this).Attack.Speed.BonusA.AddOnlySave(amount * thistype.ATTACK_SPEED_BONUS)
                    call Unit(this).CriticalChance.Bonus.Add(amount * thistype.CRITICAL_BONUS)
                    call Unit(this).EvasionChance.Bonus.Add(amount * thistype.EVASION_BONUS)
                    call Unit(this).MaxStamina.Bonus.Add(amount * thistype.STAMINA_BONUS)
                else
                    call Unit(this).Attack.Speed.Add(amount * thistype.ATTACK_SPEED_BONUS)
                    call Unit(this).CriticalChance.Add(amount * thistype.CRITICAL_BONUS)
                    call Unit(this).EvasionChance.Add(amount * thistype.EVASION_BONUS)
                    call Unit(this).MaxStamina.Add(amount * thistype.STAMINA_BONUS)
                endif
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                local integer valueI = Real.ToInt(value)
                local integer oldValue = Real.ToInt(this.Get())

                set this.value = value
                call SetHeroAgi(Unit(this).self, valueI, true)
                call this.AddBonuses(valueI - oldValue, false)
            endmethod

            method Add takes real value returns nothing
                call this.Set(this.Get() + value)
            endmethod

            method Event_Create takes nothing returns nothing
                set this.value = 0.

                call this.Set(Unit(this).Type.Get().Hero.Agility.Get())

                call this.Bonus.Event_Create()
            endmethod

            static method Init takes nothing returns nothing
                call thistype(NULL).Bonus.Init()
            endmethod
        endstruct

        //! runtextmacro Folder("Intelligence")
            //! runtextmacro Struct("Bonus")
                //! runtextmacro CreateHeroAttribute("Intelligence")

                static method Init takes nothing returns nothing
                endmethod
            endstruct
        endscope

        //! runtextmacro Struct("Intelligence")
            static constant integer ATTRIBUTE_INTELLIGENCE = 2

            static constant real MANA_REGENERATION_BONUS = 0.04
            static constant real MAX_MANA_BONUS = 15.
            static constant real SPELL_POWER_BONUS = 2.

            //! runtextmacro LinkToStruct("Intelligence", "Bonus")

            method AddBonuses takes real amount, boolean asBonus returns nothing
                if (Unit(this).Type.Get().Hero.PrimaryAttribute.Get() == ATTRIBUTE_INTELLIGENCE) then
                    set amount = PRIMARY_ATTRIBUTE_FACTOR * amount
                endif
                if (asBonus) then
                    call Unit(this).ManaRegeneration.Bonus.Add(amount * thistype.MANA_REGENERATION_BONUS)
                    call Unit(this).MaxMana.Bonus.Add(amount * thistype.MAX_MANA_BONUS)
                    call Unit(this).SpellPower.Bonus.Add(amount * thistype.SPELL_POWER_BONUS)
                else
                    call Unit(this).ManaRegeneration.Add(amount * thistype.MANA_REGENERATION_BONUS)
                    call Unit(this).MaxMana.Add(amount * thistype.MAX_MANA_BONUS)
                    call Unit(this).SpellPower.Add(amount * thistype.SPELL_POWER_BONUS)
                endif
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                local integer valueI = Real.ToInt(value)
                local integer oldValue = Real.ToInt(this.Get())

                set this.value = value
                call SetHeroInt(Unit(this).self, valueI, true)
                call this.AddBonuses(valueI - oldValue, false)
            endmethod

            method Add takes real value returns nothing
                call this.Set(this.Get() + value)
            endmethod

            method Event_Create takes nothing returns nothing
                set this.value = 0.

                call this.Set(Unit(this).Type.Get().Hero.Intelligence.Get())

                call this.Bonus.Event_Create()
            endmethod

            static method Init takes nothing returns nothing
                call thistype(NULL).Bonus.Init()
            endmethod
        endstruct

        //! runtextmacro Folder("Strength")
            //! runtextmacro Struct("Bonus")
                //! runtextmacro CreateHeroAttribute("Strength")

                static method Init takes nothing returns nothing
                endmethod
            endstruct
        endscope

        //! runtextmacro Struct("Strength")
            static constant integer ATTRIBUTE_STRENGTH = 3

            static constant real DAMAGE_BONUS = 0.5
            static constant real LIFE_REGENERATION_BONUS = 0.05
            static constant real MAX_LIFE_BONUS = 25.

            //! runtextmacro LinkToStruct("Strength", "Bonus")

            method AddBonuses takes real amount, boolean asBonus returns nothing
                if (Unit(this).Type.Get().Hero.PrimaryAttribute.Get() == ATTRIBUTE_STRENGTH) then
                    set amount = PRIMARY_ATTRIBUTE_FACTOR * amount
                endif
                if (asBonus) then
                    call Unit(this).Damage.Bonus.Add(amount * thistype.DAMAGE_BONUS)
                    call Unit(this).LifeRegeneration.Bonus.Add(amount * thistype.LIFE_REGENERATION_BONUS)
                    call Unit(this).MaxLife.Bonus.Add(amount * thistype.MAX_LIFE_BONUS)
                else
                    call Unit(this).Damage.Add(amount * thistype.DAMAGE_BONUS)
                    call Unit(this).LifeRegeneration.Add(amount * thistype.LIFE_REGENERATION_BONUS)
                    call Unit(this).MaxLife.Add(amount * thistype.MAX_LIFE_BONUS)
                endif
            endmethod

            //! runtextmacro CreateSimpleAddState_OnlyGet("real")

            method Set takes real value returns nothing
                local integer valueI = Real.ToInt(value)
                local integer oldValue = Real.ToInt(this.Get())

                set this.value = value
                call SetHeroStr(Unit(this).self, valueI, true)
                call this.AddBonuses(valueI - oldValue, false)
            endmethod

            method Add takes real value returns nothing
                call this.Set(this.Get() + value)
            endmethod

            method Event_Create takes nothing returns nothing
                set this.value = 0.

                call this.Set(Unit(this).Type.Get().Hero.Strength.Get())

                call this.Bonus.Event_Create()
            endmethod

            static method Init takes nothing returns nothing
                call thistype(NULL).Bonus.Init()
            endmethod
        endstruct
    //endscope

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

        method Subtract takes nothing returns nothing
            local integer value = this.Get() - 1

            set this.value = value

            if ((value == 0) and (this.waiting)) then
                call Unit(this).Destroy()
            endif
        endmethod

        method Add takes nothing returns nothing
            set this.value = this.Get() + 1
        endmethod

        method Event_Create takes nothing returns nothing
            set this.value = 0
            set this.waiting = false
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Unit", "UNIT")
    static EventType CREATE_EVENT_TYPE
    static Trigger CREATE_EXECUTE_TRIGGER
    static Trigger CREATE_FROM_SELF_EXECUTE_TRIGGER
    static boolean CREATE_TRIGGER_EVENTS = true
    static EventType DESTROY_EVENT_TYPE
    static Trigger DESTROY_EXECUTE_TRIGGER
    static BoolExpr ENUM_OF_TYPE_FILTER
    static EventType HEALED_EVENT_TYPE
    //! runtextmacro GetKey("KEY")
    static constant string SUMMON_EFFECT_PATH = "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl"
    static thistype TEMP
    static thistype TEMP2
    static thistype array TEMPS

    static thistype ARURUW
    static thistype DRAKUL
    static thistype JOTA
    static thistype KERA
    static thistype LIZZY
    static thistype ROCKETEYE
    static thistype ROSA
    static thistype SMOKEALOT
    static thistype STORMY
    static thistype TAJRAN

    boolean destroyed
    unit self

    //! runtextmacro LinkToStruct("Unit", "Abilities")
    //! runtextmacro LinkToStruct("Unit", "Animation")
    //! runtextmacro LinkToStruct("Unit", "Armor")
    //! runtextmacro LinkToStruct("Unit", "Attachments")
    //! runtextmacro LinkToStruct("Unit", "Attack")
    //! runtextmacro LinkToStruct("Unit", "Bars")
    //! runtextmacro LinkToStruct("Unit", "Blood")
    //! runtextmacro LinkToStruct("Unit", "BloodExplosion")
    //! runtextmacro LinkToStruct("Unit", "Buffs")
    //! runtextmacro LinkToStruct("Unit", "Classes")
    //! runtextmacro LinkToStruct("Unit", "Cold")
    //! runtextmacro LinkToStruct("Unit", "CollisionSize")
    //! runtextmacro LinkToStruct("Unit", "Color")
    //! runtextmacro LinkToStruct("Unit", "CriticalChance")
    //! runtextmacro LinkToStruct("Unit", "Damage")
    //! runtextmacro LinkToStruct("Unit", "Data")
    //! runtextmacro LinkToStruct("Unit", "Death")
    //! runtextmacro LinkToStruct("Unit", "Decay")
    //! runtextmacro LinkToStruct("Unit", "Display")
    //! runtextmacro LinkToStruct("Unit", "Drop")
    //! runtextmacro LinkToStruct("Unit", "Effects")
    //! runtextmacro LinkToStruct("Unit", "Eclipse")
    //! runtextmacro LinkToStruct("Unit", "Evasion")
    //! runtextmacro LinkToStruct("Unit", "EvasionChance")
    //! runtextmacro LinkToStruct("Unit", "Event")
    //! runtextmacro LinkToStruct("Unit", "Facing")
    //! runtextmacro LinkToStruct("Unit", "Ghost")
    //! runtextmacro LinkToStruct("Unit", "Id")
    //! runtextmacro LinkToStruct("Unit", "Impact")
    //! runtextmacro LinkToStruct("Unit", "Ignited")
    //! runtextmacro LinkToStruct("Unit", "Invisibility")
    //! runtextmacro LinkToStruct("Unit", "Invulnerability")
    //! runtextmacro LinkToStruct("Unit", "Items")
    //! runtextmacro LinkToStruct("Unit", "Life")
    //! runtextmacro LinkToStruct("Unit", "LifeLeech")
    //! runtextmacro LinkToStruct("Unit", "LifeRegeneration")
    //! runtextmacro LinkToStruct("Unit", "MagicImmunity")
    //! runtextmacro LinkToStruct("Unit", "Mana")
    //! runtextmacro LinkToStruct("Unit", "ManaRegeneration")
    //! runtextmacro LinkToStruct("Unit", "MaxLife")
    //! runtextmacro LinkToStruct("Unit", "MaxMana")
    //! runtextmacro LinkToStruct("Unit", "MaxStamina")
    //! runtextmacro LinkToStruct("Unit", "Movement")
    //! runtextmacro LinkToStruct("Unit", "Outpact")
    //! runtextmacro LinkToStruct("Unit", "Order")
    //! runtextmacro LinkToStruct("Unit", "Owner")
    //! runtextmacro LinkToStruct("Unit", "Pathing")
    //! runtextmacro LinkToStruct("Unit", "Poisoned")
    //! runtextmacro LinkToStruct("Unit", "Position")
    //! runtextmacro LinkToStruct("Unit", "Refs")
    //! runtextmacro LinkToStruct("Unit", "Revival")
    //! runtextmacro LinkToStruct("Unit", "Scale")
    //! runtextmacro LinkToStruct("Unit", "Selection")
    //! runtextmacro LinkToStruct("Unit", "SightRange")
    //! runtextmacro LinkToStruct("Unit", "Silence")
    //! runtextmacro LinkToStruct("Unit", "SkillPoints")
    //! runtextmacro LinkToStruct("Unit", "Sleep")
    //! runtextmacro LinkToStruct("Unit", "SpellPower")
    //! runtextmacro LinkToStruct("Unit", "Stamina")
    //! runtextmacro LinkToStruct("Unit", "StaminaRegeneration")
    //! runtextmacro LinkToStruct("Unit", "Stun")
    //! runtextmacro LinkToStruct("Unit", "TimedLife")
    //! runtextmacro LinkToStruct("Unit", "Transport")
    //! runtextmacro LinkToStruct("Unit", "Type")
    //! runtextmacro LinkToStruct("Unit", "VertexColor")

    //Hero
    //! runtextmacro LinkToStruct("Unit", "Exp")
    //! runtextmacro LinkToStruct("Unit", "Hero")
    //! runtextmacro LinkToStruct("Unit", "Agility")
    //! runtextmacro LinkToStruct("Unit", "Level")
    //! runtextmacro LinkToStruct("Unit", "Intelligence")
    //! runtextmacro LinkToStruct("Unit", "Strength")

    //! runtextmacro CreateAnyStaticState("HEALED_AMOUNT", "HealedAmount", "real")

    static method GetFromId takes integer id returns thistype
        return thistype(NULL).Id.GetParent(id)
    endmethod

    static method GetFromSelf takes unit self returns thistype
        return Memory.IntegerKeys.GetIntegerByHandle(self, KEY)
    endmethod

    static method GetFromSelfSecured takes unit self returns thistype
        if (self == null) then
            return NULL
        endif

        return thistype.GetFromSelf(self)
    endmethod

    method GetName takes nothing returns string
        return GetUnitName(this.self)
    endmethod

    method GetProperName takes nothing returns string
        return GetHeroProperName(this.self)
    endmethod

    method GetSelf takes nothing returns unit
        return this.self
    endmethod

    method CastAngle takes real dX, real dY returns real
        if (Math.DistanceSquareByDeltas(dX, dY) < 1.) then
            return this.Facing.Get()
        endif

        return Math.AtanByDeltas(dY, dX)
    endmethod

    method IsAllyOf takes User whichPlayer returns boolean
        return IsUnitAlly(this.self, whichPlayer.self)
    endmethod

    method IsDestroyed takes nothing returns boolean
        return this.destroyed
    endmethod

    method IsEnemyOf takes User whichPlayer returns boolean
        return IsUnitEnemy(this.self, whichPlayer.self)
    endmethod

    method IsSelected takes User whichPlayer returns boolean
        return IsUnitSelected(this.self, whichPlayer.self)
    endmethod

    method Destroy_TriggerEvents takes nothing returns nothing
        local integer iteration = EventPriority.ALL_COUNT
        local integer iteration2
        local EventPriority priority

        loop
            exitwhen (iteration < ARRAY_MIN)

            set priority = EventPriority.ALL[iteration]

            set iteration2 = Event.CountAtStatics(thistype.DESTROY_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call UNIT.Event.SetTrigger(this)

                call Event.GetFromStatics(thistype.DESTROY_EVENT_TYPE, priority, iteration2).Run()

                set iteration2 = iteration2 - 1
            endloop

            set iteration2 = this.Event.Count(thistype.DESTROY_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call Event.SetSubjectId(this.Id.Get())
                call UNIT.Event.SetTrigger(this)

                call this.Event.Get(thistype.DESTROY_EVENT_TYPE, priority, iteration2).Run()

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration - 1
        endloop

        call this.Abilities.Events.Event_Destroy()
        call this.Attack.Events.Event_Destroy()
        call this.Items.Events.Event_Destroy()
        call this.Level.Events.Event_Destroy()
    endmethod

    static method Destroy_Executed takes nothing returns nothing
        local thistype this = thistype.TEMP

        local integer iteration = this.Abilities.Count()
        local unit self = this.self

        set this.destroyed = true
        call Group.WORLD.RemoveUnit(this)

        call this.Abilities.Clear()

        call this.Destroy_TriggerEvents()

        if (this.Refs.CheckForDestroy() == false) then
            call ShowUnit(this.self, false)

            return
        endif

        call this.deallocate()
        call RemoveUnit(self)

        set self = null
    endmethod

    method Destroy takes nothing returns nothing
        set thistype.TEMP = this

        call thistype.DESTROY_EXECUTE_TRIGGER.Run()
    endmethod

    method AddJumpingTextTag takes string text, real fontSize, integer id returns TextTag
        local real x = this.Position.X.Get()
        local real y = this.Position.Y.Get()

        return TEXT_TAG.CreateJumping.Create(text, fontSize, x, y, this.Position.Z.GetByCoords(x, y) + this.Outpact.Z.Get(true), id)
    endmethod

    method AddJumpingTextTagEx takes string text, real fontSize, integer id, boolean useOutpact, boolean useScale returns TextTag
        local real x = this.Position.X.Get()
        local real y = this.Position.Y.Get()

        local real z = this.Position.Z.GetByCoords(x, y)

        if (useOutpact) then
            set z = z + this.Outpact.Z.Get(useScale)
        endif
        if (useScale) then
            set fontSize = fontSize * this.Scale.Get()
        endif

        return TEXT_TAG.CreateJumping.Create(text, fontSize, x, y, z, id)
    endmethod

    method AddMovingTextTag takes string text, real fontSize, real speedX, real speedY, real speedZ, real fadePoint, real duration, integer id returns TextTag
        local real x = this.Position.X.Get()
        local real y = this.Position.Y.Get()

        return TEXT_TAG.CreateMoving.Create(text, fontSize, x, y, this.Position.Z.GetByCoords(x, y) + this.Outpact.Z.Get(true), speedX, speedY, speedZ, fadePoint, duration, id)
    endmethod

    method AddRisingTextTag takes string text, real fontSize, real speedZ, real fadePoint, real duration, integer id returns TextTag
        local real x = this.Position.X.Get()
        local real y = this.Position.Y.Get()

        return TEXT_TAG.CreateRising.Create(text, fontSize, x, y, this.Position.Z.GetByCoords(x, y) + this.Outpact.Z.Get(true), speedZ, fadePoint, duration, id)
    endmethod

    method ReplaceRisingTextTagIfMinorValue takes string text, real fontSize, real speedZ, real fadePoint, real duration, integer id, real value returns TextTag
        local TextTag old = TextTag.GetFromId(id)

        if ((old == NULL) or (old.GetValue() < value)) then
            if (old != NULL) then
                call old.Destroy()
            endif

            set old = this.AddRisingTextTag(text, fontSize, speedZ, fadePoint, duration, id)

            call old.SetValue(value)
        endif

        return old
    endmethod

    method AddState takes UnitState whichState, real value returns nothing
        call whichState.Run(this, value)
    endmethod

    method ChangeType takes UnitType targetType returns nothing
        call this.Type.Set(targetType)
    endmethod

    method DamageUnit takes Unit target, real amount, boolean triggerEvents returns real
        return this.Damage.Do(target, amount, triggerEvents)
    endmethod

    static method EnumOfType_Conditions takes nothing returns boolean
        if (UNIT.Event.Native.GetFilter().Type.Get() != UnitType.TEMP) then
            return false
        endif

        return true
    endmethod

    static method EnumOfType takes UnitType whichType, code action returns nothing
        local Group dummyGroup = Group.Create()

        set UnitType.TEMP = whichType

        call dummyGroup.EnumUnits.InRect.Do(Rectangle.WORLD, thistype.ENUM_OF_TYPE_FILTER)

        call dummyGroup.Do(action)

        call dummyGroup.Destroy()
    endmethod

    method DamageUnitBySpell takes Unit target, real amount, boolean magical, boolean triggerEvents returns real
        return this.Damage.DoBySpell(target, amount, magical, triggerEvents)
    endmethod

    method HealBySpell_TriggerEvents takes Unit target, real amount returns nothing
        local integer iteration = EventPriority.ALL_COUNT
        local integer iteration2
        local EventPriority priority

        loop
            exitwhen (iteration < ARRAY_MIN)

            set priority = EventPriority.ALL[iteration]

            set iteration2 = target.Event.Count(thistype.HEALED_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call thistype.SetHealedAmount(amount)
                call Event.SetSubjectId(target.Id.Get())
                call UNIT.Event.SetTrigger(target)

                call target.Event.Get(thistype.HEALED_EVENT_TYPE, priority, iteration2).Run()

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration - 1
        endloop
    endmethod

    method HealBySpell takes Unit target, real amount returns nothing
        if (amount < 0.) then
            return
        endif

        set amount = amount * thistype(NULL).SpellPower.GetDamageFactor(-this.SpellPower.GetAll()) * Math.Random(0.9, 1.1)

        call target.AddJumpingTextTag(String.Color.Do(Char.PLUS + Integer.ToString(Real.ToInt(amount)), "ff00c800"), 0.02, TextTag.GetFreeId())

        call target.Life.Add(amount)

        call this.HealBySpell_TriggerEvents(target, amount)
    endmethod

    method BurnManaBySpell takes Unit target, real amount returns nothing
        if (amount < 0.) then
            return
        endif

        call target.AddJumpingTextTag(String.Color.Do(Char.MINUS + Integer.ToString(Real.ToInt(amount)), "ffffff00"), 0.02, TextTag.GetFreeId())

        call target.Mana.Add(amount)
    endmethod

    method HealManaBySpell takes Unit target, real amount returns nothing
        if (amount < 0.) then
            return
        endif

        call target.AddJumpingTextTag(String.Color.Do(Char.PLUS + Integer.ToString(Real.ToInt(amount)), "ffaa55ff"), 0.02, TextTag.GetFreeId())

        call target.Mana.Add(amount)
    endmethod

    method Kill takes nothing returns nothing
        call this.Death.Do(NULL)
    endmethod

    method KillInstantly takes nothing returns nothing
        set thistype(NULL).Death.Events.NEXT_DECAYS_INSTANTLY = true

        call this.Kill()
    endmethod

    method ApplyTimedLife takes real duration returns nothing
        call this.TimedLife.Start(duration)
    endmethod

    method Flash takes integer red, integer green, integer blue, integer alpha returns nothing
        call AddIndicator(this.self, red, green, blue, alpha)
    endmethod

    method Revive takes nothing returns nothing
        if (this.Classes.Contains(UnitClass.HERO)) then
            call this.Hero.Revive(this.Position.X.Get(), this.Position.Y.Get())
        else
            call this.Revival.Do()
        endif
    endmethod

    method Select takes User whichPlayer, boolean flag returns nothing
        if (whichPlayer.IsLocal()) then
            call SelectUnit(this.self, flag)
        endif
    endmethod

    method SetSummon takes real duration returns nothing
        if (duration >= 0.) then
            call this.BloodExplosion.Set(SUMMON_EFFECT_PATH)
            call this.Classes.Add(UnitClass.SUMMON)
            call this.Decay.Duration.Set(0.)

            call this.ApplyTimedLife(duration)
        endif
    endmethod

    method Stop takes nothing returns nothing
        call this.Order.Immediate(Order.STOP)
    endmethod

    method Create_TriggerEvents takes nothing returns nothing
        local integer iteration = EventPriority.ALL_COUNT
        local integer iteration2
        local EventPriority priority
        local UnitType thisType = this.Type.Get()

        loop
            exitwhen (iteration < ARRAY_MIN)

            set priority = EventPriority.ALL[iteration]

            set iteration2 = Event.CountAtStatics(thistype.CREATE_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call Event.SetSubjectId(0)
                call UNIT.Event.SetTrigger(this)
                call UNIT_TYPE.Event.SetTrigger(thisType)

                call Event.GetFromStatics(thistype.CREATE_EVENT_TYPE, priority, iteration2).Run()

                set iteration2 = iteration2 - 1
            endloop

            set iteration2 = thisType.Event.Count(thistype.CREATE_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call Event.SetSubjectId(thisType.Id.Get())
                call UNIT.Event.SetTrigger(this)
                call UNIT_TYPE.Event.SetTrigger(thisType)

                call thisType.Event.Get(thistype.CREATE_EVENT_TYPE, priority, iteration2).Run()

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration - 1
        endloop
    endmethod

    static method CreateBasic takes User owner, unit self returns thistype
        local boolean isHero
        local thistype this
        local UnitType thisType = UnitType.GetFromSelf(GetUnitTypeId(self))

        static if DEBUG then
            if (thisType == NULL) then
                //call Game.DebugMsg("Unit.CreateBasic: NULL type ("+I2S(GetUnitTypeId(self))+";"+GetObjectName(GetUnitTypeId(self))+";"+GetUnitName(self) + ")")

                return NULL
            endif
        endif

        set this = thistype.allocate()

        set this.destroyed = false
        set this.self = self
        call Memory.IntegerKeys.SetIntegerByHandle(self, KEY, this)
        call Group.ALIVE.AddUnit(this)
        call Group.WORLD.AddUnit(this)
        call this.Refs.Event_Create()

        call this.Animation.Event_Create()
        call this.CriticalChance.Event_Create()
        call this.EvasionChance.Event_Create()
        call this.Exp.Event_Create()
        call this.Ghost.Event_Create()
        call this.Id.Event_Create()
        call this.Invisibility.Event_Create()
        call this.Invulnerability.Event_Create()
        call this.Items.Event_Create()
        call this.LifeLeech.Event_Create()
        call this.MagicImmunity.Event_Create()
        call this.Owner.Event_Create(owner)
        call this.Pathing.Event_Create()
        call this.Position.Event_Create()
        call this.Silence.Event_Create()
        call this.Stun.Event_Create()
        call this.Transport.Event_Create()
        call this.Type.Event_Create()

        call this.Abilities.Event_Create()
        call this.Armor.Event_Create()
        call this.Attachments.Event_Create()
        call this.Attack.Event_Create()
        call this.Blood.Event_Create()
        call this.BloodExplosion.Event_Create()
        call this.Classes.Event_Create()
        call this.CollisionSize.Event_Create()
        call this.Damage.Event_Create()
        call this.Death.Event_Create()
        call this.Decay.Event_Create()
        call this.Drop.Event_Create()
        call this.Evasion.Event_Create()
        call this.Impact.Event_Create()
        call this.Revival.Event_Create()
        call this.SightRange.Event_Create()
        call this.SpellPower.Event_Create()

        call this.LifeRegeneration.Event_Create()
        call this.ManaRegeneration.Event_Create()
        call this.MaxLife.Event_Create()
        call this.MaxMana.Event_Create()
        call this.Movement.Event_Create()
        call this.Outpact.Event_Create()
        call this.Scale.Event_Create()
        call this.VertexColor.Event_Create()

        call this.Cold.Event_Create()
        call this.Eclipse.Event_Create()
        call this.Ignited.Event_Create()
        call this.Poisoned.Event_Create()

        set isHero = this.Classes.Contains(UnitClass.HERO)

        if isHero then
            call this.MaxStamina.Event_Create()
            call this.StaminaRegeneration.Event_Create()

            call this.Agility.Event_Create()
            call this.Intelligence.Event_Create()
            call this.Strength.Event_Create()

            call this.SkillPoints.Event_Create()

            call this.Level.Event_Create()

            call this.Stamina.Event_Create()

            call this.Bars.Event_Create()
        endif

        call this.Life.Event_Create()
        call this.Mana.Event_Create()

        call this.Items.Event_Create()
        call this.Order.Event_Create()

        if thistype.CREATE_TRIGGER_EVENTS then
            call this.Create_TriggerEvents()
        endif

        return this
    endmethod

    static method CreateFromSelf_Executed takes nothing returns nothing
        set thistype.TEMP = thistype.CreateBasic(User.GetFromSelf(GetOwningPlayer(UNIT.self)), UNIT.self)
    endmethod

    static method CreateFromSelf takes unit self returns thistype
        set UNIT.self = self

        call thistype.CREATE_FROM_SELF_EXECUTE_TRIGGER.Run()

        if (thistype.TEMP == NULL) then
            call RemoveUnit(self)
        endif

        return thistype.TEMP
    endmethod

    static method Create_Executed takes nothing returns nothing
        set thistype.TEMP = thistype.CreateBasic(User.TEMP, CreateUnit(User.TEMP.self, UnitType.TEMP.self, TEMP_REAL, TEMP_REAL2, TEMP_REAL3 * Math.RAD_TO_DEG))
    endmethod

    static method Create takes UnitType whichType, User whichPlayer, real x, real y, real angle returns thistype
        set TEMP_REAL = x
        set TEMP_REAL2 = y
        set TEMP_REAL3 = angle
        set User.TEMP = whichPlayer
        set UnitType.TEMP = whichType

        call thistype.CREATE_EXECUTE_TRIGGER.Run()

        return thistype.TEMP
    endmethod

    static method CreateSummon takes UnitType whichType, User whichPlayer, real x, real y, real angle, real duration returns Unit
        local Unit this = thistype.Create(whichType, whichPlayer, x, y, angle)

        call SpotEffectWithSize.Create(x, y, SUMMON_EFFECT_PATH, EffectLevel.LOW, this.Scale.Get()).Destroy()
        call this.Animation.Set(UNIT.Animation.BIRTH)

        call this.Animation.Queue(UNIT.Animation.STAND)
        call this.SetSummon(duration)

        return this
    endmethod

    static method CreateIllusion takes UnitType whichType, User whichPlayer, real x, real y, real angle, real duration, string deathEffectPath returns thistype
        local Unit this

        set thistype.CREATE_TRIGGER_EVENTS = false

        set this = thistype.Create(whichType, whichPlayer, x, y, angle)

        set thistype.CREATE_TRIGGER_EVENTS = true

        call this.Armor.Relative.Invisible.Add(-0.5)
        call this.Classes.AddIllusion()
        call this.Damage.Relative.Invisible.Add(-1.)
        call this.VertexColor.AddForPlayer(-191., -191., 0., 0., whichPlayer)

        call this.SetSummon(duration)

        call this.BloodExplosion.Set(deathEffectPath)

        call this.Create_TriggerEvents()

        return this
    endmethod

    static method Event_Start takes nothing returns nothing
        local group enumGroup = CreateGroup()
        local Unit enumUnit
        local unit enumUnitSelf
        local real x
        local real y

        call GroupEnumUnitsInRect(enumGroup, Rectangle.WORLD.self, null)

        loop
            set enumUnitSelf = FirstOfGroup(enumGroup)
            exitwhen (enumUnitSelf == null)
            call GroupRemoveUnit(enumGroup, enumUnitSelf)

            if (GetUnitTypeId(enumUnitSelf) == 0) then
                call RemoveUnit(enumUnitSelf)
            else
                set enumUnit = thistype.GetFromSelf(enumUnitSelf)

                if (enumUnit == NULL) then
                    set enumUnit = thistype.CreateFromSelf(enumUnitSelf)
                endif

                if (enumUnit != NULL) then
                    call enumUnit.Invulnerability.AddTimed(15., thistype(NULL).Invulnerability.NORMAL_BUFF)
                    call enumUnit.Stop()
                endif
            endif
        endloop

        call DestroyGroup(enumGroup)

        set enumGroup = null

        set x = Rectangle.ROSA.GetCenterX()
        set y = Rectangle.ROSA.GetCenterY()

        set thistype.ROSA = thistype.Create(UnitType.ROSA, User.CASTLE, x, y, Math.AtanByDeltas(HeroRevival.REVIVAL_RECTS[0].GetCenterY() - y, HeroRevival.REVIVAL_RECTS[0].GetCenterX() - x))
    endmethod

    static method Init takes nothing returns nothing
        call BJUnit.Init()

        call UnitClass.Init()

        set thistype.CREATE_EVENT_TYPE = EventType.Create()
        set thistype.CREATE_EXECUTE_TRIGGER = Trigger.CreateFromCode(function thistype.Create_Executed)
        set thistype.CREATE_FROM_SELF_EXECUTE_TRIGGER = Trigger.CreateFromCode(function thistype.CreateFromSelf_Executed)
        set thistype.DESTROY_EVENT_TYPE = EventType.Create()
        set thistype.DESTROY_EXECUTE_TRIGGER = Trigger.CreateFromCode(function thistype.Destroy_Executed)
        set thistype.ENUM_OF_TYPE_FILTER = BoolExpr.GetFromFunction(function thistype.EnumOfType_Conditions)
        set thistype.HEALED_EVENT_TYPE = EventType.Create()
        call Event.Create(EventType.START, EventPriority.HEADER, function thistype.Event_Start).AddToStatics()

        call thistype(NULL).Type.Init()
call DebugEx("A")
        call thistype(NULL).Agility.Init()
        call thistype(NULL).Attachments.Init()
        call thistype(NULL).Blood.Init()
        call thistype(NULL).BloodExplosion.Init()
        call thistype(NULL).Classes.Init()
        call thistype(NULL).CollisionSize.Init()
        call thistype(NULL).Death.Init()
        call thistype(NULL).Display.Init()
        call thistype(NULL).Drop.Init()
        call thistype(NULL).EvasionChance.Init()
        call thistype(NULL).Event.Init()
        call thistype(NULL).Intelligence.Init()
        call thistype(NULL).Impact.Init()
        call thistype(NULL).Level.Init()
        call thistype(NULL).Life.Init()
        call thistype(NULL).Mana.Init()
        call thistype(NULL).MaxLife.Init()
        call thistype(NULL).MaxMana.Init()
        call thistype(NULL).Outpact.Init()
        call thistype(NULL).Owner.Init()
        call thistype(NULL).Revival.Init()
        call thistype(NULL).Scale.Init()
        call thistype(NULL).SightRange.Init()
        call thistype(NULL).SpellPower.Init()
        call thistype(NULL).Strength.Init()
        call thistype(NULL).VertexColor.Init()
call DebugEx("B")
        call thistype(NULL).Animation.Init()
call DebugEx("BA")
        call thistype(NULL).Buffs.Init()
call DebugEx("BB")
        call thistype(NULL).Decay.Init()
call DebugEx("BC")
        call thistype(NULL).Order.Init()
call DebugEx("BD")
        call thistype(NULL).Position.Init()
call DebugEx("BE")
        call thistype(NULL).Selection.Init()
call DebugEx("C")
        call thistype(NULL).Abilities.Init()
call DebugEx("CA")
        call thistype(NULL).Armor.Init()
call DebugEx("CB")
        call thistype(NULL).Damage.Init()
call DebugEx("CC")
        call thistype(NULL).Ignited.Init()
call DebugEx("CD")
        call thistype(NULL).Movement.Init()
call DebugEx("CE")
        call thistype(NULL).Stamina.Init()
call DebugEx("CF")
        call thistype(NULL).TimedLife.Init()
call DebugEx("D")
        call thistype(NULL).Attack.Init()
        call thistype(NULL).Bars.Init()
        call thistype(NULL).Cold.Init()
        call thistype(NULL).Eclipse.Init()
        call thistype(NULL).Ghost.Init()
        call thistype(NULL).Invisibility.Init()
        call thistype(NULL).Invulnerability.Init()
        call thistype(NULL).Items.Init()
        call thistype(NULL).LifeRegeneration.Init()
        call thistype(NULL).MagicImmunity.Init()
        call thistype(NULL).ManaRegeneration.Init()
        call thistype(NULL).Pathing.Init()
        call thistype(NULL).Poisoned.Init()
        call thistype(NULL).Silence.Init()
        call thistype(NULL).Sleep.Init()
        call thistype(NULL).StaminaRegeneration.Init()
        call thistype(NULL).Stun.Init()
        call thistype(NULL).Transport.Init()
call DebugEx("E")
        call UnitState.Init()
        call UnitType.Init()
        call UnitTypePool.Init()
    endmethod
endstruct

//! runtextmacro BaseStruct("UnitState", "UNIT_STATE")
    static real TEMP_AMOUNT

    static thistype MAX_LIFE
    static thistype MAX_MANA

    Trigger action

    static method MaxLifeTrig takes nothing returns nothing
        call Unit.TEMP.MaxLife.Add(thistype.TEMP_AMOUNT)
    endmethod

    static method MaxManaTrig takes nothing returns nothing
        call Unit.TEMP.MaxMana.Add(thistype.TEMP_AMOUNT)
    endmethod

    method Run takes Unit whichUnit, real amount returns nothing
        set thistype.TEMP_AMOUNT = amount
        set Unit.TEMP = whichUnit

        call this.action.Run()
    endmethod

    static method Create takes code actionFunction returns thistype
        local thistype this = thistype.allocate()

        set this.action = Trigger.CreateFromCode(actionFunction)

        return this
    endmethod

    static method Init takes nothing returns nothing
        set thistype.MAX_LIFE = thistype.Create(function thistype.MaxLifeTrig)
        set thistype.MAX_MANA = thistype.Create(function thistype.MaxManaTrig)
    endmethod
endstruct