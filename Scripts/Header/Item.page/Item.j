//! runtextmacro Folder("ItemClass")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("ItemClass", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("ItemClass", "Integer", "integer")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Integer")

        //! runtextmacro Data_Implement("ItemClass")
    endstruct
endscope

//! runtextmacro BaseStruct("ItemClass", "ITEM_CLASS")
    static thistype SCROLL
    static thistype POWER_UP

    //! runtextmacro LinkToStruct("ItemClass", "Data")
    //! runtextmacro LinkToStruct("ItemClass", "Id")

    static method Create takes nothing returns thistype
        local thistype this = thistype.allocate()

        call this.AddToList()

        call this.Id.Event_Create()

        return this
    endmethod

    static method Init takes nothing returns nothing
        set thistype.SCROLL = thistype.Create()
        set thistype.POWER_UP = thistype.Create()
    endmethod
endstruct

//! runtextmacro Folder("Item")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Struct("Boolean")
            //! runtextmacro Data_Type_Implement("Item", "Boolean", "boolean")
        endstruct

        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("Item", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("Item", "Integer", "integer")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Boolean")
        //! runtextmacro LinkToStruct("Data", "Integer")

        //! runtextmacro Data_Implement("Item")
    endstruct

    //! runtextmacro Folder("Event")
        //! runtextmacro Struct("Native")
            //! textmacro Item_Event_Native_CreateResponse takes name, source
                static method Get$name$ takes nothing returns Item
                    return Item.GetFromSelf($source$())
                endmethod
            //! endtextmacro

            static method GetDying takes nothing returns Item
                return Memory.IntegerKeys.GetIntegerByHandle(GetTriggerWidget(), Item.KEY)
            endmethod

            //! runtextmacro Item_Event_Native_CreateResponse("OrderTarget", "GetOrderTargetItem")
            //! runtextmacro Item_Event_Native_CreateResponse("SpellTarget", "GetSpellTargetItem")
            //! runtextmacro Item_Event_Native_CreateResponse("Trigger", "GetManipulatedItem")
        endstruct
    endscope

    //! runtextmacro Struct("Event")
        //! runtextmacro LinkToStruct("Event", "Native")

        //! runtextmacro Event_Implement("Item")
    endstruct

    //! runtextmacro Struct("Classes")
        static Event DESTROY_EVENT
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        method Contains takes ItemClass whichType returns boolean
            return Item(this).Data.Integer.Table.Contains(KEY_ARRAY, whichType)
        endmethod

        method Remove takes ItemClass whichType returns nothing
            if Item(this).Data.Integer.Table.Remove(KEY_ARRAY, whichType) then
                call Item(this).Event.Remove(DESTROY_EVENT)
            endif
        endmethod

        method Add takes ItemClass whichType returns nothing
            if Item(this).Data.Integer.Table.Add(KEY_ARRAY, whichType) then
                call Item(this).Event.Add(DESTROY_EVENT)
            endif
        endmethod

        eventMethod Event_Destroy
            local Item parent = params.Item.GetTrigger()

            call parent.Data.Integer.Table.Clear(KEY_ARRAY)
            call parent.Event.Remove(DESTROY_EVENT)
        endmethod

        method Event_Create takes nothing returns nothing
            local ItemType thisType = Item(this).Type.Get()

            local integer iteration = thisType.Classes.Count()

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                call this.Add(thisType.Classes.Get(iteration))

                set iteration = iteration - 1
            endloop
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DESTROY_EVENT = Event.Create(Item.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
        endmethod
    endstruct

    //! runtextmacro Struct("Type")
        ItemType type

        method Get takes nothing returns ItemType
            return this.type
        endmethod

        method Event_Create takes nothing returns nothing
            set this.type = ItemType.GetFromSelf(GetItemTypeId(Item(this).self))
        endmethod
    endstruct

    //! runtextmacro Struct("Abilities")
        static Event DESTROY_EVENT
        //! runtextmacro GetKeyArray("KEY_ARRAY")
        //! runtextmacro GetKeyArray("KEY_ARRAY_DETAIL")

        method Count takes nothing returns integer
            return Item(this).Data.Integer.Table.Count(KEY_ARRAY)
        endmethod

        method Get takes integer index returns Spell
            return Item(this).Data.Integer.Table.Get(KEY_ARRAY, index)
        endmethod

        method GetLevel takes Spell whichSpell returns integer
            return Item(this).Data.Integer.Get(KEY_ARRAY_DETAIL + whichSpell)
        endmethod

        method Remove takes Spell whichSpell returns nothing
            if Item(this).Data.Integer.Table.Remove(KEY_ARRAY, whichSpell) then
                call Item(this).Event.Remove(DESTROY_EVENT)
            endif
            call Item(this).Data.Integer.Remove(KEY_ARRAY_DETAIL + whichSpell)
        endmethod

        method Add takes Spell whichSpell returns nothing
            if Item(this).Data.Integer.Table.Add(KEY_ARRAY, whichSpell) then
                call Item(this).Event.Add(DESTROY_EVENT)
            endif

            call Item(this).Data.Integer.Set(KEY_ARRAY_DETAIL + whichSpell, 1)
        endmethod

        method SetLevel takes Spell whichSpell, integer level returns nothing
            if (level == 0) then
                call this.Remove(whichSpell)

                return
            endif
            if (this.GetLevel(whichSpell) == 0) then
                call this.Add(whichSpell)
            endif

            call Item(this).Data.Integer.Set(KEY_ARRAY_DETAIL + whichSpell, level)
        endmethod

        method AddLevel takes Spell whichSpell, integer value returns nothing
            call this.SetLevel(whichSpell, this.GetLevel(whichSpell) + value)
        endmethod

        eventMethod Event_Destroy
            local Item parent = params.Item.GetTrigger()

            local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                local Spell whichSpell = parent.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                call parent.Data.Integer.Table.Remove(KEY_ARRAY, whichSpell)
                call parent.Data.Integer.Remove(KEY_ARRAY_DETAIL + whichSpell)

                set iteration = iteration - 1
            endloop
            call parent.Event.Remove(DESTROY_EVENT)
        endmethod

        method Event_Create takes nothing returns nothing
            local ItemType thisType = Item(this).Type.Get()

            local integer iteration = thisType.Abilities.Count()

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                local Spell whichSpell = thisType.Abilities.Get(iteration)

                call this.SetLevel(whichSpell, thisType.Abilities.GetLevel(whichSpell))

                set iteration = iteration - 1
            endloop
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DESTROY_EVENT = Event.Create(Item.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
        endmethod
    endstruct

    //! runtextmacro Struct("ChargesAmount")
        static EventType DUMMY_EVENT_TYPE

        //! runtextmacro CreateSimpleAddState_OnlyGet("integer")

        method TriggerEvents takes integer amount returns nothing
            local Item parent = this

            local EventResponse params = EventResponse.Create(parent.Id.Get())

            call params.Item.SetTrigger(parent)

			local integer iteration = EventPriority.ALL_COUNT

            loop
                exitwhen (iteration < ARRAY_MIN)

                local EventPriority priority = EventPriority.ALL[iteration]

                local integer iteration2 = parent.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

                loop
                    exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                    call parent.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(params)

                    set iteration2 = iteration2 - 1
                endloop

                set iteration = iteration - 1
            endloop

            call params.Destroy()
        endmethod

        method Set takes integer amount returns nothing
            set this.value = amount

            call SetItemCharges(Item(this).self, amount)

            call this.TriggerEvents(amount)

            if ((amount == 0) and (Item(this).Type.Get().ChargesAmount.Get() > 0)) then
                call Item(this).Destroy()
            endif
        endmethod

        //! runtextmacro CreateSimpleAddState_OnlyAdd("integer", "Item(this).Type.Get().ChargesAmount.Get()")

        static method Init takes nothing returns nothing
            set thistype.DUMMY_EVENT_TYPE = EventType.Create()
        endmethod
    endstruct

    //! runtextmacro Struct("Position")
        method GetX takes nothing returns real
            return GetItemX(Item(this).self)
        endmethod

        method GetY takes nothing returns real
            return GetItemY(Item(this).self)
        endmethod

        method GetZ takes nothing returns real
            return Spot.GetHeight(this.GetX(), this.GetY())
        endmethod

        method Set takes real x, real y returns nothing
            call SetItemPosition(Item(this).self, x, y)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Item", "ITEM")
    static EventType CREATE_EVENT_TYPE
    static EventType DEATH_EVENT_TYPE
    static EventType DESTROY_EVENT_TYPE
    //! runtextmacro GetKey("KEY")
    static thistype TEMP
    static thistype array TEMPS

    item self
    integer slot

    //! runtextmacro LinkToStruct("Item", "Abilities")
    //! runtextmacro LinkToStruct("Item", "ChargesAmount")
    //! runtextmacro LinkToStruct("Item", "Classes")
    //! runtextmacro LinkToStruct("Item", "Data")
    //! runtextmacro LinkToStruct("Item", "Event")
    //! runtextmacro LinkToStruct("Item", "Id")
    //! runtextmacro LinkToStruct("Item", "Position")
    //! runtextmacro LinkToStruct("Item", "Type")

    static method GetFromSelf takes item self returns thistype
        return Memory.IntegerKeys.GetIntegerByHandle(self, KEY)
    endmethod

    method GetSelf takes nothing returns item
        return this.self
    endmethod

    method GetSlot takes nothing returns integer
        return this.slot
    endmethod

    method Destroy_TriggerEvents takes nothing returns nothing
        local EventResponse params = EventResponse.Create(this.Id.Get())

        call params.Item.SetTrigger(this)

		local integer iteration = EventPriority.ALL_COUNT

        loop
            exitwhen (iteration < ARRAY_MIN)

            local EventPriority priority = EventPriority.ALL[iteration]

            local integer iteration2 = this.Event.Count(thistype.DESTROY_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call this.Event.Get(thistype.DESTROY_EVENT_TYPE, priority, iteration2).Run(params)

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration - 1
        endloop

        call params.Destroy()
    endmethod

    method Destroy takes nothing returns nothing
        local item self = this.self

        call SetItemPosition(self, 0., 0.)

        call this.Destroy_TriggerEvents()

        call this.deallocate()
        call Memory.IntegerKeys.SetIntegerByHandle(self, KEY, this)

        call RemoveItem(self)

        set self = null
    endmethod

    method SetLife takes real value returns nothing
        call SetWidgetLife(this.self, value)
    endmethod

    method GetName takes nothing returns string
        return GetItemName(this.self)
    endmethod

    method Death_TriggerEvents takes nothing returns nothing
        local EventResponse params = EventResponse.Create(this.Id.Get())

        call params.Item.SetTrigger(this)

		local integer iteration = EventPriority.ALL_COUNT

        loop
            exitwhen (iteration < ARRAY_MIN)

            local EventPriority priority = EventPriority.ALL[iteration]

            local integer iteration2 = this.Event.Count(thistype.DEATH_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call this.Event.Get(thistype.DEATH_EVENT_TYPE, priority, iteration2).Run(params)

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration - 1
        endloop

        call params.Destroy()
    endmethod

    trigMethod DeathTrig
        local thistype this = ITEM.Event.Native.GetDying()

        call this.Death_TriggerEvents()
    endmethod

    method Kill takes nothing returns nothing
        call SetWidgetLife(this.self, 0.)
    endmethod

    method SetInvulnerable takes boolean flag returns nothing
        call SetItemInvulnerable(this.self, flag)
    endmethod

    method SetSlot takes integer value returns nothing
        set this.slot = value
    endmethod

    method RecreateSelf takes Unit owner returns nothing
        local item self = this.self
        local real x = this.Position.GetX()
        local real y = this.Position.GetY()

        call Memory.IntegerKeys.SetIntegerByHandle(self, KEY, this)

        call RemoveItem(self)

        set self = CreateItem(this.Type.Get().self, x, y)

        set this.self = self
        call Memory.IntegerKeys.SetIntegerByHandle(self, KEY, this)

        if (owner != NULL) then
            call owner.Items.Add(this)
        endif

        set self = null
    endmethod

    method Create_TriggerEvents takes nothing returns nothing
        local ItemType thisType = Item(this).Type.Get()

        local EventResponse params = EventResponse.Create(thisType.Id.Get())

        call params.Item.SetTrigger(this)
        call params.ItemType.SetTrigger(thisType)

		local integer iteration = EventPriority.ALL_COUNT

        loop
            exitwhen (iteration < ARRAY_MIN)

            local EventPriority priority = EventPriority.ALL[iteration]

            local integer iteration2 = thisType.Event.Count(thistype.CREATE_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call thisType.Event.Get(thistype.CREATE_EVENT_TYPE, priority, iteration2).Run(params)

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration - 1
        endloop

        call params.Destroy()
    endmethod

    static method CreateFromSelf takes item self returns thistype
        local thistype this = thistype.allocate()

        set this.self = self
        call Memory.IntegerKeys.SetIntegerByHandle(self, KEY, this)

        call this.SetSlot(-1)

        call this.Id.Event_Create()
        call this.Type.Event_Create()

        call this.Abilities.Event_Create()
        call this.ChargesAmount.Event_Create()
        call this.Classes.Event_Create()

        call this.Create_TriggerEvents()

        return this
    endmethod

    static method Create takes ItemType whichType, real x, real y returns thistype
        return thistype.CreateFromSelf(CreateItem(whichType.self, x, y))
    endmethod

    static method CreateHidden takes ItemType whichType returns thistype
        return thistype.Create(whichType, 0., 0.)
    endmethod

    static method Start_Enum takes nothing returns nothing
        call Item.CreateFromSelf(GetEnumItem())
    endmethod

    eventMethod Event_Start
        call EnumItemsInRect(Rectangle.WORLD.self, null, function thistype.Start_Enum)
    endmethod

    initMethod Init of Header_5
        call ItemClass.Init()

        set thistype.CREATE_EVENT_TYPE = EventType.Create()
        set thistype.DEATH_EVENT_TYPE = EventType.Create()
        set thistype.DESTROY_EVENT_TYPE = EventType.Create()
        call Event.Create(EventType.START, EventPriority.HEADER, function thistype.Event_Start).AddToStatics()

        call thistype(NULL).Abilities.Init()
        call thistype(NULL).ChargesAmount.Init()
        call thistype(NULL).Classes.Init()

        call ItemType.Init()
    endmethod
endstruct