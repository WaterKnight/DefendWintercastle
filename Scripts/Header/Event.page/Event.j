//! runtextmacro Folder("EventResponse")
    //! runtextmacro Struct("Act")
        //! runtextmacro CreateAnyState("trigger", "Trigger", "Act")
    endstruct

    //! runtextmacro Struct("Aura")
        //! runtextmacro CreateAnyState("trigger", "Trigger", "Aura")
    endstruct

    //! runtextmacro Struct("Bool")
        //! runtextmacro CreateAnyState("added", "Added", "boolean")
        //! runtextmacro CreateAnyState("val", "Val", "boolean")
    endstruct

    //! runtextmacro Struct("Buff")
        //! runtextmacro CreateAnyState("data", "Data", "integer")
        //! runtextmacro CreateAnyState("trigger", "Trigger", "Buff")
        //! runtextmacro CreateAnyState("level", "Level", "integer")
        //! runtextmacro CreateAnyState("sourceLevel", "SourceLevel", "integer")
    endstruct

    //! runtextmacro Struct("DefenderSpawnType")
        //! runtextmacro CreateAnyState("trigger", "Trigger", "DefenderSpawnType")
    endstruct

    //! runtextmacro Struct("Destructable")
        //! runtextmacro CreateAnyState("trigger", "Trigger", "Destructable")
    endstruct

    //! runtextmacro Struct("DestructableType")
        //! runtextmacro CreateAnyState("trigger", "Trigger", "DestructableType")
    endstruct

    //! runtextmacro Struct("Dialog")
        //! runtextmacro CreateAnyState("trigger", "Trigger", "Dialog")
        //! runtextmacro CreateAnyState("triggerButton", "TriggerButton", "DialogButton")
    endstruct

    //! runtextmacro Struct("DummyUnit")
        //! runtextmacro CreateAnyState("trigger", "Trigger", "DummyUnit")
    endstruct

    //! runtextmacro Struct("Dynamic")
        //! runtextmacro GetKey("LOCAL_KEY")

        //! textmacro EventResponse_Dynamic_CreateType takes name, type
            method Get$name$ takes integer key returns $type$
                return Memory.IntegerKeys.D2.Get$name$(LOCAL_KEY, this, key, NULL, NULL)
            endmethod

            method Set$name$ takes integer key, $type$ val returns nothing
                call Memory.IntegerKeys.D2.Set$name$(LOCAL_KEY, this, key, NULL, NULL, val)
            endmethod
        //! endtextmacro

        //! runtextmacro EventResponse_Dynamic_CreateType("Boolean", "boolean")
        //! runtextmacro EventResponse_Dynamic_CreateType("Integer", "integer")
        //! runtextmacro EventResponse_Dynamic_CreateType("Real", "real")
        //! runtextmacro EventResponse_Dynamic_CreateType("String", "string")
    endstruct

    //! runtextmacro Struct("Event")
        //! runtextmacro CreateAnyState("trigger", "Trigger", "Event")

		method Destroy takes nothing returns nothing
		endmethod
    endstruct

    //! runtextmacro Struct("Item")
        //! runtextmacro CreateAnyState("target", "Target", "Item")
        //! runtextmacro CreateAnyState("targetSlot", "TargetSlot", "integer")
        //! runtextmacro CreateAnyState("trigger", "Trigger", "Item")
        //! runtextmacro CreateAnyState("triggerSlot", "TriggerSlot", "integer")
    endstruct

    //! runtextmacro Struct("ItemType")
        //! runtextmacro CreateAnyState("trigger", "Trigger", "ItemType")
    endstruct

    //! runtextmacro Struct("Level")
        //! runtextmacro CreateAnyState("trigger", "Trigger", "Level")
    endstruct

    //! runtextmacro Struct("Lightning")
        //! runtextmacro CreateAnyState("trigger", "Trigger", "Lightning")
    endstruct

    //! runtextmacro Struct("Missile")
        //! runtextmacro CreateAnyState("trigger", "Trigger", "Missile")
    endstruct

    //! runtextmacro Struct("MissileCheckpoint")
        //! runtextmacro CreateAnyState("trigger", "Trigger", "MissileCheckpoint")
    endstruct

    //! runtextmacro Struct("Order")
        //! runtextmacro CreateAnyState("trigger", "Trigger", "Order")
    endstruct

    //! runtextmacro Struct("Real")
        //! runtextmacro CreateAnyState("damage", "Damage", "real")
        //! runtextmacro CreateAnyState("distanceSquare", "DistanceSquare", "real")
        //! runtextmacro CreateAnyState("healedAmount", "HealedAmount", "real")
        //! runtextmacro CreateAnyState("intervalWeight", "IntervalWeight", "real")
        //! runtextmacro CreateAnyState("val", "Val", "real")
    endstruct

    //! runtextmacro Struct("Rect")
        //! runtextmacro CreateAnyState("trigger", "Trigger", "Rectangle")
    endstruct

    //! runtextmacro Struct("Region")
        //! runtextmacro CreateAnyState("trigger", "Trigger", "Region")
    endstruct

    //! runtextmacro Struct("SpawnType")
        //! runtextmacro CreateAnyState("trigger", "Trigger", "SpawnType")
    endstruct

    //! runtextmacro Struct("Spell")
        //! runtextmacro CreateAnyFlagState("channelComplete", "ChannelComplete")
        //! runtextmacro CreateAnyState("source", "Source", "Spell")
        //! runtextmacro CreateAnyState("trigger", "Trigger", "Spell")
        //! runtextmacro CreateAnyState("level", "Level", "integer")
    endstruct

    //! runtextmacro Struct("SpellInstance")
        //! runtextmacro CreateAnyState("trigger", "Trigger", "SpellInstance")
    endstruct

    //! runtextmacro Struct("Spot")
        //! runtextmacro CreateAnyState("targetX", "TargetX", "real")
        //! runtextmacro CreateAnyState("targetY", "TargetY", "real")
    endstruct

    //! runtextmacro Struct("String")
        //! runtextmacro CreateAnyState("chat", "Chat", "string")
        //! runtextmacro CreateAnyState("match", "Match", "string")
    endstruct

    //! runtextmacro Struct("Tile")
        //! runtextmacro CreateAnyState("trigger", "Trigger", "Tile")
    endstruct

    //! runtextmacro Struct("Ubersplat")
        //! runtextmacro CreateAnyState("trigger", "Trigger", "Ubersplat")
    endstruct

    //! runtextmacro Struct("Unit")
        //! runtextmacro CreateAnyState("damager", "Damager", "Unit")
        //! runtextmacro CreateAnyState("killer", "Killer", "Unit")
        //! runtextmacro CreateAnyState("target", "Target", "Unit")
        //! runtextmacro CreateAnyState("trigger", "Trigger", "Unit")
    endstruct

    //! runtextmacro Struct("UnitEffect")
        //! runtextmacro CreateAnyState("trigger", "Trigger", "UnitEffect")
    endstruct

    //! runtextmacro Struct("UnitMod")
        //! runtextmacro CreateAnyState("trigger", "Trigger", "UnitMod")
    endstruct

    //! runtextmacro Struct("UnitType")
        //! runtextmacro CreateAnyState("source", "Source", "UnitType")
        //! runtextmacro CreateAnyState("target", "Target", "UnitType")
        //! runtextmacro CreateAnyState("trigger", "Trigger", "UnitType")
    endstruct

    //! runtextmacro Struct("User")
        //! runtextmacro CreateAnyState("trigger", "Trigger", "User")
        //! runtextmacro CreateAnyState("source", "Source", "User")
        //! runtextmacro CreateAnyState("target", "Target", "User")
    endstruct
endscope

//! runtextmacro BaseStruct("EventResponse", "EVENT_RESPONSE")
    static constant integer DIRECT_SUBJECT_ID = 0
    static constant integer STATIC_SUBJECT_ID = 0
    static constant integer STRING_DATA_SUBJECT_ID = 0
    //! runtextmacro CreateAnyStaticState("TRIGGER", "Trigger", "thistype")

    //! runtextmacro CreateAnyState("data", "Data", "integer")
    //! runtextmacro CreateAnyState("subjectId", "SubjectId", "integer")

    //! runtextmacro LinkToStruct("EventResponse", "Act")
    //! runtextmacro LinkToStruct("EventResponse", "Aura")
    //! runtextmacro LinkToStruct("EventResponse", "Bool")
    //! runtextmacro LinkToStruct("EventResponse", "Buff")
    //! runtextmacro LinkToStruct("EventResponse", "DefenderSpawnType")
    //! runtextmacro LinkToStruct("EventResponse", "Destructable")
    //! runtextmacro LinkToStruct("EventResponse", "DestructableType")
    //! runtextmacro LinkToStruct("EventResponse", "Dialog")
    //! runtextmacro LinkToStruct("EventResponse", "DummyUnit")
    //! runtextmacro LinkToStruct("EventResponse", "Dynamic")
    //! runtextmacro LinkToStruct("EventResponse", "Event")
    //! runtextmacro LinkToStruct("EventResponse", "Item")
    //! runtextmacro LinkToStruct("EventResponse", "ItemType")
    //! runtextmacro LinkToStruct("EventResponse", "Level")
    //! runtextmacro LinkToStruct("EventResponse", "Lightning")
    //! runtextmacro LinkToStruct("EventResponse", "Missile")
    //! runtextmacro LinkToStruct("EventResponse", "MissileCheckpoint")
    //! runtextmacro LinkToStruct("EventResponse", "Order")
    //! runtextmacro LinkToStruct("EventResponse", "Real")
    //! runtextmacro LinkToStruct("EventResponse", "Rect")
    //! runtextmacro LinkToStruct("EventResponse", "Region")
    //! runtextmacro LinkToStruct("EventResponse", "SpawnType")
    //! runtextmacro LinkToStruct("EventResponse", "Spell")
    //! runtextmacro LinkToStruct("EventResponse", "SpellInstance")
    //! runtextmacro LinkToStruct("EventResponse", "Spot")
    //! runtextmacro LinkToStruct("EventResponse", "String")
    //! runtextmacro LinkToStruct("EventResponse", "Tile")
    //! runtextmacro LinkToStruct("EventResponse", "Ubersplat")
    //! runtextmacro LinkToStruct("EventResponse", "Unit")
    //! runtextmacro LinkToStruct("EventResponse", "UnitEffect")
    //! runtextmacro LinkToStruct("EventResponse", "UnitMod")
    //! runtextmacro LinkToStruct("EventResponse", "UnitType")
    //! runtextmacro LinkToStruct("EventResponse", "User")

    method Destroy takes nothing returns nothing
        call this.deallocate()
    endmethod

    static method Create takes integer subjectId returns thistype
        local thistype this = thistype.allocate()

        call this.SetSubjectId(subjectId)

        return this
    endmethod
endstruct

//! runtextmacro BaseStruct("EventPriority", "EVENT_PRIORITY")
    static integer ALL_AMOUNT

    static thistype AI
    static thistype COMBINATION
    static thistype CONTENT
    static thistype CONTENT2
    static thistype EVENTS
    static thistype HEADER
    static thistype HEADER_TOP
    static thistype ITEMS
    static thistype MISC
    static thistype MISC2
    static thistype SPEECHES
    static thistype SPELLS
    static thistype UNIT_TYPES

    //! runtextmacro CreateAnyState("name", "Name", "string")

    static method Create takes string name returns thistype
        local thistype this = thistype.allocate()

        call this.SetName(name)

        call this.AddToList()

        return this
    endmethod

    static method Init takes nothing returns nothing
        set thistype.HEADER = thistype.Create("Header")

        set thistype.HEADER_TOP = thistype.Create("HeaderTop")

        set thistype.COMBINATION = thistype.Create("Combination")

        set thistype.AI = thistype.Create("AI")

        set thistype.EVENTS = thistype.Create("Events")
        set thistype.CONTENT = thistype.Create("Content")

        set thistype.CONTENT2 = thistype.Create("Content2")

        set thistype.ITEMS = thistype.CONTENT
        set thistype.MISC = thistype.CONTENT
        set thistype.MISC2 = thistype.CONTENT2
        set thistype.SPEECHES = thistype.CONTENT
        set thistype.SPELLS = thistype.CONTENT
        set thistype.UNIT_TYPES = thistype.CONTENT

        set thistype.ALL_AMOUNT = thistype.ALL_COUNT + 1
    endmethod
endstruct

//! runtextmacro BaseStruct("EventType", "EVENT_TYPE")
    static thistype START

    static method Create takes nothing returns thistype
        return thistype.allocate()
    endmethod

    static method Init takes nothing returns nothing
        set thistype.START = thistype.Create()
    endmethod
endstruct

//! runtextmacro Folder("Event")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Struct("Boolean")
            //! runtextmacro Data_Type_Implement("Event", "Boolean", "boolean")
        endstruct

        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("Event", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("Event", "Integer", "integer")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Boolean")
        //! runtextmacro LinkToStruct("Data", "Integer")

        //! runtextmacro Data_Implement("Event")
    endstruct

    //! runtextmacro Struct("Limit")
        boolean is
        integer value
        limitop whichOperator

        method GetValue takes nothing returns integer
            return this.value
        endmethod

        method GetOperator takes nothing returns limitop
            return this.whichOperator
        endmethod

        method Is takes nothing returns boolean
            return this.is
        endmethod

        method Set takes integer value, limitop whichOperator returns nothing
            set this.is = true
            set this.value = value
            set this.whichOperator = whichOperator
        endmethod

        method Event_Create takes nothing returns nothing
            set this.is = false
            set this.value = 0
            set this.whichOperator = null
        endmethod

        static method Init takes nothing returns nothing
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Event", "EVENT")
    static EventType DESTROY_EVENT_TYPE
    //! runtextmacro GetKey("KEY")
    static constant integer KEY_ARRAY = 1
    //! runtextmacro GetKey("STATICS_KEY")
    //! runtextmacro GetKey("STATICS_PARENT_KEY")

	static DataTable array RANDOM_TABLES
	static integer RANDOM_TABLES_COUNT

    Trigger action

    //! runtextmacro LinkToStruct("Event", "Data")
    //! runtextmacro LinkToStruct("Event", "Id")
    //! runtextmacro LinkToStruct("Event", "Limit")

    //! runtextmacro CreateAnyStaticState("TRIGGER", "Trigger", "thistype")

    //! runtextmacro CreateAnyState("key", "Key", "integer")
    //! runtextmacro CreateAnyState("name", "Name", "string")
    //! runtextmacro CreateAnyState("priority", "Priority", "EventPriority")
    //! runtextmacro CreateAnyState("response", "Response", "EventResponse")
    //! runtextmacro CreateAnyState("whichConditions", "Conditions", "BoolExpr")
    //! runtextmacro CreateAnyState("whichType", "Type", "EventType")

    //! textmacro Event_Implement takes type
    	DataTable table

        method Contains takes Event whichEvent returns boolean
            //return $type$(this).Data.Integer.Table.Contains(whichEvent.GetKey(), whichEvent)
            return this.table.IntegerKeys.Table.ContainsInteger($type$(this).Id.Get(), whichEvent.GetKey(), whichEvent)
        endmethod

        method Count takes EventType whichType, EventPriority priority returns integer
            //return $type$(this).Data.Integer.Table.Count(Event.GetKeyFromTypePriority(whichType, priority))
            return this.table.IntegerKeys.Table.CountIntegers($type$(this).Id.Get(), Event.GetKeyFromTypePriority(whichType, priority))
        endmethod

        method Get takes EventType whichType, EventPriority priority, integer index returns Event
            //return $type$(this).Data.Integer.Table.Get(Event.GetKeyFromTypePriority(whichType, priority), index)
            return this.table.IntegerKeys.Table.GetInteger($type$(this).Id.Get(), Event.GetKeyFromTypePriority(whichType, priority), index)
        endmethod

        method Remove takes Event whichEvent returns nothing
            //if not $type$(this).Data.Integer.Table.Contains(whichEvent.GetKey(), whichEvent) then
                //call DebugEx("subject "+I2S($type$(this).Id.Get()) + " has not " + whichEvent.GetName())

              //  return
            //endif

            //call $type$(this).Data.Integer.Table.Remove(whichEvent.GetKey(), whichEvent)

            if not this.table.IntegerKeys.Table.ContainsInteger($type$(this).Id.Get(), whichEvent.GetKey(), whichEvent) then
                call DebugEx("subject "+I2S($type$(this).Id.Get()) + " has not " + whichEvent.GetName())

                return
            endif

            call this.table.IntegerKeys.Table.RemoveInteger($type$(this).Id.Get(), whichEvent.GetKey(), whichEvent)
        endmethod

        method Add takes Event whichEvent returns nothing
        	if (this.table == NULL) then
            	call DebugEx("no table "+I2S(this)+";"+whichEvent.GetName())
            	set this.table = Memory
        	endif
            //call $type$(this).Data.Integer.Table.Add(whichEvent.GetKey(), whichEvent)
            call this.table.IntegerKeys.Table.AddInteger($type$(this).Id.Get(), whichEvent.GetKey(), whichEvent)
        endmethod

		method Clear takes nothing returns nothing
			call this.table.IntegerKeys.RemoveChild($type$(this).Id.Get())
		endmethod

		method Destroy takes nothing returns nothing
			call this.Clear()
		endmethod

		method Event_Create takes nothing returns nothing
			set this.table = Event.GetRandomTable()
		endmethod

		inject $type$.Allocation.deallocate_demount.hook
			call $type$(this).Event.Destroy()
		endinject

		inject $type$.Allocation.allocate_mount.hook
			call $type$(this).Event.Event_Create()
		endinject
    //! endtextmacro

    //! textmacro Event_Implement2 takes type
    	struct Event
    		//! runtextmacro Event_Implement("$type$")
    	endstruct
    //! endtextmacro

	static method GetRandomTable takes nothing returns DataTable
		return thistype.RANDOM_TABLES[Math.RandomI(ARRAY_MIN, thistype.RANDOM_TABLES_COUNT)]
	endmethod

    static method GetKeyFromTypePriority takes EventType whichType, EventPriority priority returns integer
        return KEY_ARRAY + Memory.IntegerKeys.Table.SIZE * ((whichType - 1) * EventPriority.ALL_AMOUNT + (priority - 1))
    endmethod

    method GetAction takes nothing returns Trigger
        return this.action
    endmethod

    static method GetFromAction takes Trigger action returns thistype
        return action.Data.Integer.Get(KEY)
    endmethod

	method GetNameEx takes nothing returns string
		if (this.action != NULL) then
			if (this.action.GetNameEx() != null) then
				return this.action.GetNameEx()
			endif
		endif

		return this.name
	endmethod

    method Destroy_TriggerEvents takes nothing returns nothing
        local integer iteration = EventPriority.ALL_COUNT
        local integer iteration2
        local EventResponse params = EventResponse.Create(this.Id.Get())
        local EventPriority priority

        call params.Event.SetTrigger(this)

        loop
            exitwhen (iteration < ARRAY_MIN)

            set priority = EventPriority.ALL[iteration]

            set iteration2 = this.CountEvents(thistype.DESTROY_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call this.GetEvent(thistype.DESTROY_EVENT_TYPE, priority, iteration2).Run(params)

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration - 1
        endloop

        call params.Destroy()
    endmethod

    method Destroy takes nothing returns nothing
        call this.Destroy_TriggerEvents()

        call this.deallocate()        
    endmethod

    method CountEvents takes EventType whichType, EventPriority priority returns integer
        return Event(this).Data.Integer.Table.Count(Event.GetKeyFromTypePriority(whichType, priority))
    endmethod

    method GetEvent takes EventType whichType, EventPriority priority, integer index returns Event
        return Event(this).Data.Integer.Table.Get(Event.GetKeyFromTypePriority(whichType, priority), index)
    endmethod

    method RemoveEvent takes Event whichEvent returns nothing
        call Event(this).Data.Integer.Table.Remove(whichEvent.GetKey(), whichEvent)
    endmethod

    method AddEvent takes Event whichEvent returns nothing
        call Event(this).Data.Integer.Table.Add(whichEvent.GetKey(), whichEvent)
    endmethod

    static method CountAtStatics takes EventType whichType, EventPriority priority returns integer
        return Memory.IntegerKeys.Table.CountIntegers(STATICS_PARENT_KEY, thistype.GetKeyFromTypePriority(whichType, priority))
    endmethod

    static method GetFromStatics takes EventType whichType, EventPriority priority, integer index returns thistype
        return Memory.IntegerKeys.Table.GetInteger(STATICS_PARENT_KEY, thistype.GetKeyFromTypePriority(whichType, priority), index)
    endmethod

    method IsStatic takes nothing returns boolean
        return this.Data.Boolean.Get(STATICS_KEY)
    endmethod

    method RemoveFromStatics takes nothing returns nothing
        call this.Data.Boolean.Set(STATICS_KEY, false)
        call Memory.IntegerKeys.Table.RemoveInteger(STATICS_PARENT_KEY, this.GetKey(), this)
    endmethod

    method AddToStatics takes nothing returns nothing
if (this == NULL) then
	call DebugEx("event is null")
endif
        call this.Data.Boolean.Set(STATICS_KEY, true)
        call Memory.IntegerKeys.Table.AddInteger(STATICS_PARENT_KEY, this.GetKey(), this)
    endmethod

    method Run takes EventResponse params returns nothing
        call thistype.SetTrigger(this)
        call EventResponse.SetTrigger(params)

        if this.GetConditions().Run() then
            call this.GetAction().Run()
        endif
    endmethod

    method SetAction takes code actionFunction returns nothing
        local Trigger action = this.GetAction()

        if (action != NULL) then
            call action.Clear()
        endif

        call action.Data.Integer.Set(KEY, this)
        call action.AddCode(actionFunction)
    endmethod

    static method CreateBasic takes nothing returns thistype
        local thistype this = thistype.allocate()

        set this.action = NULL

        call this.SetConditions(NULL)
        call this.SetKey(0)
        call this.SetPriority(NULL)
        call this.SetType(NULL)

        call this.Id.Event_Create()
        call this.Limit.Event_Create()

        return this
    endmethod

    static method Create takes string name, EventType whichType, EventPriority priority, code actionFunction returns thistype
        local thistype this = thistype.CreateBasic()

		local Trigger action = Trigger.CreateWithName(name)

        set this.action = action
        call this.SetConditions(NULL)
        call this.SetKey(thistype.GetKeyFromTypePriority(whichType, priority))
        call this.SetName(name)
        call this.SetPriority(priority)
        call this.SetType(whichType)

        call this.SetAction(actionFunction)

        return this
    endmethod

    static method CreateLimit takes string name, EventType whichType, EventPriority priority, integer value, limitop whichOperator, code actionFunction returns thistype
        local thistype this = thistype.Create(name, whichType, priority, actionFunction)

        call this.Limit.Set(value, whichOperator)

        return this
    endmethod

    initMethod Init of Header_Event
        set thistype.DESTROY_EVENT_TYPE = EventType.Create()

		set thistype.RANDOM_TABLES_COUNT = 10 + ARRAY_EMPTY

		local integer i = thistype.RANDOM_TABLES_COUNT

		loop
			exitwhen (i < ARRAY_MIN)

			set thistype.RANDOM_TABLES[i] = DataTable.Create()

			set i = i - 1
		endloop

        call EventPriority.Init()
        call EventType.Init()
    endmethod
endstruct