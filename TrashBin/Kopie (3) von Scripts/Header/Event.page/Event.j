//! runtextmacro BaseStruct("EventResponse", "EVENT_RESPONSE")
    Trigger action

    method Run takes nothing returns nothing
        call this.action.Run()
    endmethod

    static method Create takes code actionFunction returns thistype
        local Trigger action = Trigger.Create()
        local thistype this = thistype.allocate()

        set this.action = action
        call action.AddCode(actionFunction)

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

    static method Create takes nothing returns thistype
        local thistype this = thistype.allocate()

        call this.AddToList()

        return this
    endmethod

    static method Init takes nothing returns nothing
        set thistype.HEADER = thistype.Create()

        set thistype.HEADER_TOP = thistype.Create()

        set thistype.COMBINATION = thistype.Create()

        set thistype.AI = thistype.Create()

        set thistype.EVENTS = thistype.Create()
        set thistype.CONTENT = thistype.Create()

        set thistype.CONTENT2 = thistype.Create()

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

    Trigger action

    //! runtextmacro LinkToStruct("Event", "Data")
    //! runtextmacro LinkToStruct("Event", "Id")
    //! runtextmacro LinkToStruct("Event", "Limit")

    //! runtextmacro CreateAnyStaticState("SUBJECT_ID", "SubjectId", "integer")
    //! runtextmacro CreateAnyStaticState("TRIGGER", "Trigger", "thistype")

    //! runtextmacro CreateAnyState("priority", "Priority", "EventPriority")
    //! runtextmacro CreateAnyState("response", "Response", "EventResponse")
    //! runtextmacro CreateAnyState("whichConditions", "Conditions", "BoolExpr")
    //! runtextmacro CreateAnyState("whichType", "Type", "EventType")

    //! textmacro Event_Implement takes type
        method Count takes integer whichType, integer priority returns integer
            return $type$(this).Data.Integer.Table.Count(Event.GetKey(whichType, priority))
        endmethod

        method Get takes integer whichType, integer priority, integer index returns Event
            return $type$(this).Data.Integer.Table.Get(Event.GetKey(whichType, priority), index)
        endmethod

        method Remove takes Event whichEvent returns nothing
            call $type$(this).Data.Integer.Table.Remove(Event.GetKey(whichEvent.GetType(), whichEvent.GetPriority()), whichEvent)
        endmethod

        method Add takes Event whichEvent returns nothing
            call $type$(this).Data.Integer.Table.Add(Event.GetKey(whichEvent.GetType(), whichEvent.GetPriority()), whichEvent)
        endmethod
    //! endtextmacro

    method GetAction takes nothing returns Trigger
        return this.action
    endmethod

    static method GetFromAction takes Trigger action returns thistype
        return action.Data.Integer.Get(KEY)
    endmethod

    method Destroy takes nothing returns nothing
        call this.deallocate()
    endmethod

    static method GetKey takes EventType whichType, EventPriority priority returns integer
        return (KEY_ARRAY + Memory.IntegerKeys.Table.SIZE * ((whichType - 1) * EventPriority.ALL_AMOUNT + (priority - 1)))
    endmethod

    method CountEvents takes EventType whichType, EventPriority priority returns integer
        return Event(this).Data.Integer.Table.Count(Event.GetKey(whichType, priority))
    endmethod

    method GetEvent takes EventType whichType, EventPriority priority, integer index returns Event
        return Event(this).Data.Integer.Table.Get(Event.GetKey(whichType, priority), index)
    endmethod

    method RemoveEvent takes Event whichEvent returns nothing
        call Event(this).Data.Integer.Table.Remove(Event.GetKey(whichEvent.GetType(), whichEvent.GetPriority()), whichEvent)
    endmethod

    method AddEvent takes Event whichEvent returns nothing
        call Event(this).Data.Integer.Table.Add(Event.GetKey(whichEvent.GetType(), whichEvent.GetPriority()), whichEvent)
    endmethod

    static method CountAtStatics takes integer whichType, integer priority returns integer
        return Memory.IntegerKeys.Table.CountIntegers(STATICS_PARENT_KEY, GetKey(whichType, priority))
    endmethod

    static method GetFromStatics takes integer whichType, integer priority, integer index returns thistype
        return Memory.IntegerKeys.Table.GetInteger(STATICS_PARENT_KEY, GetKey(whichType, priority), index)
    endmethod

    method IsStatic takes nothing returns boolean
        return this.Data.Boolean.Get(STATICS_KEY)
    endmethod

    method RemoveFromStatics takes nothing returns nothing
        call this.Data.Boolean.Set(STATICS_KEY, false)
        call Memory.IntegerKeys.Table.RemoveInteger(STATICS_PARENT_KEY, GetKey(this.whichType, this.priority), this)
    endmethod

    method AddToStatics takes nothing returns nothing
        call this.Data.Boolean.Set(STATICS_KEY, true)
        call Memory.IntegerKeys.Table.AddInteger(STATICS_PARENT_KEY, GetKey(this.whichType, this.priority), this)
    endmethod

    method Run takes nothing returns nothing
        call thistype.SetTrigger(this)

        if (this.GetConditions().Run()) then
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
        call this.SetPriority(NULL)
        call this.SetType(NULL)

        call this.Id.Event_Create()
        call this.Limit.Event_Create()

        return this
    endmethod

    static method Create takes EventType whichType, EventPriority priority, code actionFunction returns thistype
        local Trigger action = Trigger.Create()
        local thistype this = thistype.CreateBasic()

        set this.action = action
        call this.SetConditions(NULL)
        call this.SetPriority(priority)
        call this.SetType(whichType)

        call this.SetAction(actionFunction)

        return this
    endmethod

    static method CreateLimit takes integer whichType, integer priority, integer value, limitop whichOperator, code actionFunction returns thistype
        local thistype this = thistype.Create(whichType, priority, actionFunction)

        call this.Limit.Set(value, whichOperator)

        return this
    endmethod

    static method Init takes nothing returns nothing
        set thistype.DESTROY_EVENT_TYPE = EventType.Create()

        call EventPriority.Init()
        call EventType.Init()
    endmethod
endstruct