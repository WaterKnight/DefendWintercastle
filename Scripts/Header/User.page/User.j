//! runtextmacro BaseStruct("Force", "FORCE")
    static integer QUEUE_SIZE = ARRAY_EMPTY
    static thistype array QUEUED

	static thistype ALL_USERS

    force self

    method GetSelf takes nothing returns force
        return this.self
    endmethod

    method Destroy takes nothing returns nothing
        set thistype.QUEUE_SIZE = thistype.QUEUE_SIZE + 1
        set thistype.QUEUED[thistype.QUEUE_SIZE] = this
        call ForceClear(this.self)
    endmethod

    method ContainsPlayer takes User whichPlayer returns boolean
        return IsPlayerInForce(whichPlayer.self, this.self)
    endmethod

    static method GetFirst_Enum takes nothing returns nothing
        set User.TEMP = User.GetFromSelf(GetEnumPlayer())
    endmethod

    method GetFirst takes nothing returns User
        set User.TEMP = NULL

        call ForForce(this.self, function thistype.GetFirst_Enum)

        return User.TEMP
    endmethod

    static integer array DATA_STACK
    static Trigger array DATA_STACK_ACTION
    static integer DATA_STACK_NESTING = -1

    static method Do_Enum takes nothing returns nothing
        local EventResponse params = EventResponse.Create(EventResponse.DIRECT_SUBJECT_ID)

        call params.User.SetTrigger(USER.Event.Native.GetEnum())
        call params.SetData(thistype.DATA_STACK[thistype.DATA_STACK_NESTING])

        call thistype.DATA_STACK_ACTION[thistype.DATA_STACK_NESTING].RunWithParams(params)

        call params.Destroy()
    endmethod

    method Do takes code action, integer data returns nothing
        set thistype.DATA_STACK_NESTING = thistype.DATA_STACK_NESTING + 1

        set thistype.DATA_STACK[thistype.DATA_STACK_NESTING] = data
        set thistype.DATA_STACK_ACTION[thistype.DATA_STACK_NESTING] = Trigger.GetFromCode(action)

        call ForForce(this.self, function thistype.Do_Enum)

        set thistype.DATA_STACK_NESTING = thistype.DATA_STACK_NESTING - 1
    endmethod

    method RemovePlayer takes User whichPlayer returns nothing
        call ForceRemovePlayer(this.self, whichPlayer.self)
    endmethod

    method AddPlayer takes User whichPlayer returns nothing
        call ForceAddPlayer(this.self, whichPlayer.self)
    endmethod

    static method Create takes nothing returns thistype
        local thistype this

        if (thistype.QUEUE_SIZE == ARRAY_EMPTY) then
            set this = thistype.allocate()

            //set thistype.QUEUED[ARRAY_MIN] = this

            set this.self = CreateForce()

            return this
        endif

        set this = thistype.QUEUED[thistype.QUEUE_SIZE]

        set thistype.QUEUE_SIZE = thistype.QUEUE_SIZE - 1

        return this
    endmethod

    static method Init takes nothing returns nothing
    	set thistype.ALL_USERS = thistype.Create()

		local integer i = User.ALL_COUNT
    	
    	loop
    		exitwhen (i < ARRAY_MIN)
    		
    		call thistype.ALL_USERS.AddPlayer(User.ALL[i])
    		
    		set i = i - 1
    	endloop
    endmethod
endstruct

//! runtextmacro BaseStruct("PlayerController", "PLAYER_CONTROLLER")
    //! runtextmacro GetKey("KEY")
    //! runtextmacro GetKeyArray("PARENT_KEY")

    static thistype CPU
    static thistype HUMAN

    mapcontrol self

    static method GetFromSelf takes mapcontrol self returns thistype
        static if DEBUG then
            if (Memory.IntegerKeys.GetInteger(PARENT_KEY + GetHandleId(self), KEY) == HASH_TABLE.Integer.DEFAULT_VALUE) then
                call DebugEx("PlayerController: GetFromSelf: "+I2S(GetHandleId(self)))
            endif
        endif

        return Memory.IntegerKeys.GetInteger(PARENT_KEY + GetHandleId(self), KEY)
    endmethod

    method AddSelf takes mapcontrol self returns nothing
        call Memory.IntegerKeys.SetInteger(PARENT_KEY + GetHandleId(self), KEY, this)
    endmethod

    static method Create takes mapcontrol self returns thistype
        local thistype this = thistype.allocate()

        set this.self = self
        call Memory.IntegerKeys.SetInteger(PARENT_KEY + GetHandleId(self), KEY, this)

        return this
    endmethod

    static method Init takes nothing returns nothing
        set thistype.CPU = thistype.Create(MAP_CONTROL_COMPUTER)
        set thistype.HUMAN = thistype.Create(MAP_CONTROL_USER)

        call thistype.CPU.AddSelf(MAP_CONTROL_CREEP)
        call thistype.CPU.AddSelf(MAP_CONTROL_NONE)
    endmethod
endstruct

//! runtextmacro BaseStruct("PlayerSlotState", "PLAYER_SLOT_STATE")
    //! runtextmacro GetKey("KEY")
    //! runtextmacro GetKeyArray("PARENT_KEY")

    static thistype EMPTY
    static thistype LEFT
    static thistype PLAYING

    playerslotstate self

    static method GetFromSelf takes playerslotstate self returns thistype
        return Memory.IntegerKeys.GetInteger(PARENT_KEY + GetHandleId(self), KEY)
    endmethod

    static method Create takes playerslotstate self returns thistype
        local thistype this = thistype.allocate()

        set this.self = self
        call Memory.IntegerKeys.SetInteger(PARENT_KEY + GetHandleId(self), KEY, this)

        return this
    endmethod

    static method Init takes nothing returns nothing
        set thistype.EMPTY = thistype.Create(PLAYER_SLOT_STATE_EMPTY)
        set thistype.LEFT = thistype.Create(PLAYER_SLOT_STATE_LEFT)
        set thistype.PLAYING = thistype.Create(PLAYER_SLOT_STATE_PLAYING)
    endmethod
endstruct

//! runtextmacro BaseStruct("Team", "TEAM")
    //! runtextmacro GetKeyArray("MEMBERS_KEY_ARRAY")
    //! runtextmacro GetKeyArray("PARENT_KEY_ARRAY")

    static thistype ATTACKERS
    static thistype DEFENDERS
    static thistype STAFF

    static method SetStateOfPlayers takes User whichPlayer, User otherPlayer, alliancetype whichType, boolean flag, boolean mutual returns nothing
        call SetPlayerAlliance(whichPlayer.self, otherPlayer.self, whichType, flag)
        if mutual then
            call SetPlayerAlliance(otherPlayer.self, whichPlayer.self, whichType, flag)
        endif
    endmethod

    method AddPlayer takes User whichPlayer returns nothing
        local integer iteration = Memory.IntegerKeys.Table.CountIntegers(PARENT_KEY_ARRAY + this, MEMBERS_KEY_ARRAY)

        loop
            exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

            local User otherPlayer = Memory.IntegerKeys.Table.GetInteger(PARENT_KEY_ARRAY + this, MEMBERS_KEY_ARRAY, iteration)

            call thistype.SetStateOfPlayers(whichPlayer, otherPlayer, ALLIANCE_PASSIVE, true, true)
            call thistype.SetStateOfPlayers(whichPlayer, otherPlayer, ALLIANCE_SHARED_SPELLS, true, true)
            call thistype.SetStateOfPlayers(whichPlayer, otherPlayer, ALLIANCE_SHARED_VISION, true, true)

            set iteration = iteration - 1
        endloop

        call Memory.IntegerKeys.Table.AddInteger(PARENT_KEY_ARRAY + this, MEMBERS_KEY_ARRAY, whichPlayer)
    endmethod

    static method Init takes nothing returns nothing
        set thistype.ATTACKERS = thistype.allocate()
        set thistype.DEFENDERS = thistype.allocate()
        set thistype.STAFF = thistype.allocate()
    endmethod
endstruct

//! runtextmacro StaticStruct("Visibility")
    static method AddRect takes User whichPlayer, Rectangle whichRect returns nothing
        if (whichPlayer == User.ANY) then
            local integer iteration = User.ALL_COUNT

            loop
                call thistype.AddRect(User.ALL[iteration], whichRect)

                set iteration = iteration - 1
                exitwhen (iteration < ARRAY_MIN)
            endloop
        else
            call FogModifierStart(CreateFogModifierRect(whichPlayer.self, FOG_OF_WAR_VISIBLE, whichRect.self, true, true))
            //call SetFogStateRect(whichPlayer.self, FOG_OF_WAR_VISIBLE, whichRect.self, true)
        endif
    endmethod

    static method Init takes nothing returns nothing
    endmethod
endstruct

//! runtextmacro Folder("User")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Struct("Boolean")
            //! runtextmacro Data_Type_Implement("User", "Boolean", "boolean")

            //! runtextmacro Data_Boolean_Implement("User")
        endstruct

        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("User", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("User", "Integer", "integer")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Boolean")
        //! runtextmacro LinkToStruct("Data", "Integer")

        //! runtextmacro Data_Implement("User")
    endstruct

    //! runtextmacro Folder("Event")
        //! runtextmacro Struct("Native")
            static method GetEnum takes nothing returns User
                return User.GetFromSelf(GetEnumPlayer())
            endmethod
            
            static method GetTrigger takes nothing returns User
                return User.GetFromSelf(GetTriggerPlayer())
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Event")
        //! runtextmacro LinkToStruct("Event", "Native")

        //! runtextmacro Event_Implement("User")
    endstruct

    //! runtextmacro Struct("Controller")
        //! runtextmacro CreateSimpleAddState_OnlyGet("PlayerController")

        method Set takes PlayerController value returns nothing
            set this.value = value
            if (value == PlayerController.HUMAN) then
                set User.HUMANS_COUNT = User.HUMANS_COUNT + 1

                set User.HUMANS[User.HUMANS_COUNT] = this
            endif
        endmethod

        method Event_Create takes nothing returns nothing
            call this.Set(PlayerController.GetFromSelf(GetPlayerController(User(this).self)))
        endmethod
    endstruct

    //! runtextmacro Struct("HostAppointment")
        static EventType DUMMY_EVENT_TYPE
        static Event LEAVE_EVENT
        static gamecache TABLE

        static User VAL = NULL

		static method Count takes nothing returns integer
			local integer iteration = EventPriority.ALL_COUNT
			local integer c=0

            loop
                exitwhen (iteration < ARRAY_MIN)

                local EventPriority priority = EventPriority.ALL[iteration]

                local integer iteration2 = Event.CountAtStatics(thistype.DUMMY_EVENT_TYPE, priority)

                loop
                    exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                    set c=c+1

                    set iteration2 = iteration2 - 1
                endloop

                set iteration = iteration - 1
            endloop

            return c
		endmethod

        static method TriggerEvents takes User old, User val returns nothing
            local EventResponse params = EventResponse.Create(EventResponse.STATIC_SUBJECT_ID)

            call params.User.SetTrigger(val)

			local integer iteration = EventPriority.ALL_COUNT

            loop
                exitwhen (iteration < ARRAY_MIN)

                local EventPriority priority = EventPriority.ALL[iteration]

                local integer iteration2 = Event.CountAtStatics(thistype.DUMMY_EVENT_TYPE, priority)

                loop
                    exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                    call Event.GetFromStatics(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(params)

                    set iteration2 = iteration2 - 1
                endloop

                set iteration = iteration - 1
            endloop

            call params.Destroy()
        endmethod

        static method Set takes User val returns nothing
            local User old = thistype.VAL

            if (val == old) then
                return
            endif

            if (old != NULL) then
                call old.Event.Remove(thistype.LEAVE_EVENT)
            endif

            set thistype.VAL = val
            call val.Event.Add(thistype.LEAVE_EVENT)

            set User.HOST = val

            call InfoEx("new host is "+val.GetColoredName())

            call thistype.TriggerEvents(old, val)
        endmethod

        static method SetByNative takes nothing returns nothing
            call StoreInteger(thistype.TABLE, "", "", User.GetLocal())

            call TriggerSyncStart()

            call SyncStoredInteger(thistype.TABLE, "", "")

            call TriggerSyncReady()

            call thistype.Set(GetStoredInteger(thistype.TABLE, "", ""))
        endmethod

        eventMethod Event_Leave
            call Code.Run(function thistype.SetByNative)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DUMMY_EVENT_TYPE = EventType.Create()
            set thistype.LEAVE_EVENT = Event.Create(User.LEAVE_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Leave)
            set thistype.TABLE = InitGameCache(thistype.NAME)

            call thistype.Set(User.HUMANS[ARRAY_MIN])

            call Code.Run(function thistype.SetByNative)
        endmethod
    endstruct

    //! runtextmacro Struct("Hero")
        static Group ENUM_GROUP

        //! runtextmacro CreateSimpleAddState("Unit", "NULL")

        method EnumAll takes code actionFunction, boolean includeDead returns nothing
            local integer iteration = User.ALL_COUNT

            loop
                exitwhen (iteration < ARRAY_MIN)

                local Unit target = thistype(User.ALL[iteration]).Get()

                if target.Classes.Contains(UnitClass.DEAD) then
                    if includeDead then
                        call thistype.ENUM_GROUP.AddUnit(HeroRevival.GetGhostByUnit(target))
                    endif
                else
                    call thistype.ENUM_GROUP.AddUnit(target)
                endif

                set iteration = iteration - 1
            endloop

            call thistype.ENUM_GROUP.Do(actionFunction)
        endmethod

        method AddState takes UnitState whichState, real amount returns nothing
            if (this == User.ANY) then
                local integer iteration = User.ALL_COUNT

                loop
                    call User.ALL[iteration].Hero.AddState(whichState, amount)

                    set iteration = iteration - 1
                    exitwhen (iteration < ARRAY_MIN)
                endloop
            else
                local Unit thisUnit = this.Get()

                if (thisUnit != NULL) then
                    call whichState.Run(thisUnit, amount)
                endif
            endif
        endmethod

        static method Init takes nothing returns nothing
            set thistype.ENUM_GROUP = Group.Create()
        endmethod
    endstruct

    //! runtextmacro Folder("KeyEvent")
        //! runtextmacro Struct("DownArrow")
            static Event DESTROY_EVENT
            //! runtextmacro GetKey("KEY")
            //! runtextmacro GetKeyArray("KEY_ARRAY")
            static EventType PRESS_EVENT_TYPE
            static EventType RELEASE_EVENT_TYPE
            static real TRIGGER_INTERVAL_WEIGHT

			static boolean array IS_PRESSING

            real interval
            Timer intervalTimer
            real intervalWeight
            Event whichEvent
            User whichPlayer

			method IsPressing takes nothing returns boolean
				return thistype.IS_PRESSING[this]
			endmethod

            eventMethod Event_Destroy
                local Event whichEvent = params.Event.GetTrigger()

                local thistype this = whichEvent.Data.Integer.Get(KEY)

                local Timer intervalTimer = this.intervalTimer
                local User whichPlayer = this.whichPlayer

                call this.deallocate()
                call intervalTimer.Destroy()
                call whichEvent.Data.Integer.Remove(KEY)
                call whichEvent.RemoveEvent(DESTROY_EVENT)
                call whichPlayer.Data.Integer.Table.Remove(KEY_ARRAY, this)
                call whichPlayer.Event.Remove(whichEvent)
            endmethod

            static method Release_TriggerEvents takes User parent returns nothing
                local EventResponse params = EventResponse.Create(parent.Id.Get())

                call params.User.SetTrigger(parent)

				local integer iteration = EventPriority.ALL_COUNT

                loop
                    exitwhen (iteration < ARRAY_MIN)

                    local EventPriority priority = EventPriority.ALL[iteration]

                    local integer iteration2 = parent.Event.Count(thistype.RELEASE_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        call parent.Event.Get(thistype.RELEASE_EVENT_TYPE, priority, iteration2).Run(params)

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration = iteration - 1
                endloop

                call params.Destroy()
            endmethod

            trigMethod ReleaseTrig
                local User parent = USER.Event.Native.GetTrigger()

				set thistype.IS_PRESSING[parent] = false

                call thistype.Release_TriggerEvents(parent)

				local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

                loop
                    exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                    local thistype this = parent.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                    call this.intervalTimer.Pause()

                    set iteration = iteration - 1
                endloop
            endmethod

            static method Press_TriggerEvents takes User parent returns nothing
                local EventResponse params = EventResponse.Create(parent.Id.Get())

                call params.Real.SetIntervalWeight(1.)
                call params.User.SetTrigger(parent)

				local integer iteration = EventPriority.ALL_COUNT

                loop
                    exitwhen (iteration < ARRAY_MIN)

                    local EventPriority priority = EventPriority.ALL[iteration]

                    local integer iteration2 = parent.Event.Count(thistype.PRESS_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        call parent.Event.Get(thistype.PRESS_EVENT_TYPE, priority, iteration2).Run(params)

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration = iteration - 1
                endloop

                call params.Destroy()
            endmethod

            timerMethod Interval
                local thistype this = Timer.GetExpired().GetData()

                local EventResponse params = EventResponse.Create(EventResponse.DIRECT_SUBJECT_ID)

                call params.Real.SetIntervalWeight(this.intervalWeight)
                call params.User.SetTrigger(this.whichPlayer)

                call this.whichEvent.Run(params)

                call params.Destroy()
            endmethod

            trigMethod PressTrig
                local User parent = USER.Event.Native.GetTrigger()

				set thistype.IS_PRESSING[parent] = true

                call thistype.Press_TriggerEvents(parent)

				local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

                loop
                    exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                    local thistype this = parent.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                    call this.intervalTimer.Start(this.interval, true, function thistype.Interval)

                    set iteration = iteration - 1
                endloop
            endmethod

            method RegisterPress takes EventPriority priority, code actionFunction, real interval, real intervalWeight returns Event
                local User parent = this

                local Event result = Event.Create(thistype.PRESS_EVENT_TYPE, priority, actionFunction)

                if (interval > 0.) then
                    set this = thistype.allocate()

					local Timer intervalTimer = Timer.Create()

                    set this.interval = interval
                    set this.intervalTimer = intervalTimer
                    set this.intervalWeight = intervalWeight
                    set this.whichEvent = result
                    set this.whichPlayer = parent

                    call intervalTimer.SetData(this)
                    call parent.Data.Integer.Table.Add(KEY_ARRAY, this)
                    call result.AddEvent(DESTROY_EVENT)
                    call result.Data.Integer.Set(KEY, this)
                endif
                call parent.Event.Add(result)

                return result
            endmethod

	    	enumMethod InitPlayer
	    		local User parent = params.User.GetTrigger()

				set thistype.IS_PRESSING[parent] = false
	    	endmethod

            static method Init takes nothing returns nothing
                set thistype.DESTROY_EVENT = Event.Create(Event.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
                set thistype.PRESS_EVENT_TYPE = EventType.Create()
                set thistype.RELEASE_EVENT_TYPE = EventType.Create()
                call Trigger.CreateFromCode(function thistype.PressTrig).RegisterEvent.User(User.ANY, EVENT_PLAYER_ARROW_DOWN_DOWN)
                call Trigger.CreateFromCode(function thistype.ReleaseTrig).RegisterEvent.User(User.ANY, EVENT_PLAYER_ARROW_DOWN_UP)
                
                call Force.ALL_USERS.Do(function thistype.InitPlayer, NULL)
            endmethod
        endstruct

        //! runtextmacro Struct("LeftArrow")
            static Event DESTROY_EVENT
            //! runtextmacro GetKey("KEY")
            //! runtextmacro GetKeyArray("KEY_ARRAY")
            static EventType PRESS_EVENT_TYPE
            static EventType RELEASE_EVENT_TYPE
            static real TRIGGER_INTERVAL_WEIGHT

			static boolean array IS_PRESSING

            real interval
            Timer intervalTimer
            real intervalWeight
            Event whichEvent
            User whichPlayer

			method IsPressing takes nothing returns boolean
				return thistype.IS_PRESSING[this]
			endmethod

            eventMethod Event_Destroy
                local Event whichEvent = params.Event.GetTrigger()

                local thistype this = whichEvent.Data.Integer.Get(KEY)

                local Timer intervalTimer = this.intervalTimer
                local User whichPlayer = this.whichPlayer

                call this.deallocate()
                call intervalTimer.Destroy()
                call whichEvent.Data.Integer.Remove(KEY)
                call whichEvent.RemoveEvent(DESTROY_EVENT)
                call whichPlayer.Data.Integer.Table.Remove(KEY_ARRAY, this)
                call whichPlayer.Event.Remove(whichEvent)
            endmethod

            static method Release_TriggerEvents takes User parent returns nothing
                local EventResponse params = EventResponse.Create(parent.Id.Get())

                call params.User.SetTrigger(parent)

				local integer iteration = EventPriority.ALL_COUNT

                loop
                    exitwhen (iteration < ARRAY_MIN)

                    local EventPriority priority = EventPriority.ALL[iteration]

                    local integer iteration2 = parent.Event.Count(thistype.RELEASE_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        call parent.Event.Get(thistype.RELEASE_EVENT_TYPE, priority, iteration2).Run(params)

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration = iteration - 1
                endloop

                call params.Destroy()
            endmethod

            trigMethod ReleaseTrig
                local User parent = USER.Event.Native.GetTrigger()

				set thistype.IS_PRESSING[parent] = false

                call thistype.Release_TriggerEvents(parent)

				local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

                loop
                    exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                    local thistype this = parent.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                    call this.intervalTimer.Pause()

                    set iteration = iteration - 1
                endloop
            endmethod

            static method Press_TriggerEvents takes User parent returns nothing
                local EventResponse params = EventResponse.Create(parent.Id.Get())

                call params.Real.SetIntervalWeight(1.)
                call params.User.SetTrigger(parent)

				local integer iteration = EventPriority.ALL_COUNT

                loop
                    exitwhen (iteration < ARRAY_MIN)

                    local EventPriority priority = EventPriority.ALL[iteration]

                    local integer iteration2 = parent.Event.Count(thistype.PRESS_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        call parent.Event.Get(thistype.PRESS_EVENT_TYPE, priority, iteration2).Run(params)

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration = iteration - 1
                endloop

                call params.Destroy()
            endmethod

            timerMethod Interval
                local thistype this = Timer.GetExpired().GetData()

                local EventResponse params = EventResponse.Create(EventResponse.DIRECT_SUBJECT_ID)

                call params.Real.SetIntervalWeight(this.intervalWeight)
                call params.User.SetTrigger(this.whichPlayer)

                call this.whichEvent.Run(params)

                call params.Destroy()
            endmethod

            trigMethod PressTrig
                local User parent = USER.Event.Native.GetTrigger()

				set thistype.IS_PRESSING[parent] = true

                call thistype.Press_TriggerEvents(parent)

				local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

                loop
                    exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                    local thistype this = parent.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                    call this.intervalTimer.Start(this.interval, true, function thistype.Interval)

                    set iteration = iteration - 1
                endloop
            endmethod

            method RegisterPress takes EventPriority priority, code actionFunction, real interval, real intervalWeight returns Event
                local User parent = this

                local Event result = Event.Create(thistype.PRESS_EVENT_TYPE, priority, actionFunction)

                if (interval > 0.) then
                    set this = thistype.allocate()

					local Timer intervalTimer = Timer.Create()

                    set this.interval = interval
                    set this.intervalTimer = intervalTimer
                    set this.intervalWeight = intervalWeight
                    set this.whichEvent = result
                    set this.whichPlayer = parent

                    call intervalTimer.SetData(this)
                    call parent.Data.Integer.Table.Add(KEY_ARRAY, this)
                    call result.AddEvent(DESTROY_EVENT)
                    call result.Data.Integer.Set(KEY, this)
                endif
                call parent.Event.Add(result)

                return result
            endmethod

	    	enumMethod InitPlayer
	    		local User parent = params.User.GetTrigger()

				set thistype.IS_PRESSING[parent] = false
	    	endmethod

            static method Init takes nothing returns nothing
                set thistype.DESTROY_EVENT = Event.Create(Event.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
                set thistype.PRESS_EVENT_TYPE = EventType.Create()
                set thistype.RELEASE_EVENT_TYPE = EventType.Create()
                call Trigger.CreateFromCode(function thistype.PressTrig).RegisterEvent.User(User.ANY, EVENT_PLAYER_ARROW_LEFT_DOWN)
                call Trigger.CreateFromCode(function thistype.ReleaseTrig).RegisterEvent.User(User.ANY, EVENT_PLAYER_ARROW_LEFT_UP)
                
                call Force.ALL_USERS.Do(function thistype.InitPlayer, NULL)
            endmethod
        endstruct

        //! runtextmacro Struct("RightArrow")
            static Event DESTROY_EVENT
            //! runtextmacro GetKey("KEY")
            //! runtextmacro GetKeyArray("KEY_ARRAY")
            static EventType PRESS_EVENT_TYPE
            static EventType RELEASE_EVENT_TYPE
            static real TRIGGER_INTERVAL_WEIGHT

			static boolean array IS_PRESSING

            real interval
            Timer intervalTimer
            real intervalWeight
            Event whichEvent
            User whichPlayer

			method IsPressing takes nothing returns boolean
				return thistype.IS_PRESSING[this]
			endmethod

            eventMethod Event_Destroy
                local Event whichEvent = params.Event.GetTrigger()

                local thistype this = whichEvent.Data.Integer.Get(KEY)

                local Timer intervalTimer = this.intervalTimer
                local User whichPlayer = this.whichPlayer

                call this.deallocate()
                call intervalTimer.Destroy()
                call whichEvent.Data.Integer.Remove(KEY)
                call whichEvent.RemoveEvent(DESTROY_EVENT)
                call whichPlayer.Data.Integer.Table.Remove(KEY_ARRAY, this)
                call whichPlayer.Event.Remove(whichEvent)
            endmethod

            static method Release_TriggerEvents takes User parent returns nothing
                local EventResponse params = EventResponse.Create(parent.Id.Get())

                call params.User.SetTrigger(parent)

				local integer iteration = EventPriority.ALL_COUNT

                loop
                    exitwhen (iteration < ARRAY_MIN)

                    local EventPriority priority = EventPriority.ALL[iteration]

                    local integer iteration2 = parent.Event.Count(thistype.RELEASE_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        call parent.Event.Get(thistype.RELEASE_EVENT_TYPE, priority, iteration2).Run(params)

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration = iteration - 1
                endloop

                call params.Destroy()
            endmethod

            trigMethod ReleaseTrig
                local User parent = USER.Event.Native.GetTrigger()

				set thistype.IS_PRESSING[parent] = false

                call thistype.Release_TriggerEvents(parent)

				local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

                loop
                    exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                    local thistype this = parent.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                    call this.intervalTimer.Pause()

                    set iteration = iteration - 1
                endloop
            endmethod

            static method Press_TriggerEvents takes User parent returns nothing
                local EventResponse params = EventResponse.Create(parent.Id.Get())

                call params.Real.SetIntervalWeight(1.)
                call params.User.SetTrigger(parent)

				local integer iteration = EventPriority.ALL_COUNT

                loop
                    exitwhen (iteration < ARRAY_MIN)

                    local EventPriority priority = EventPriority.ALL[iteration]

                    local integer iteration2 = parent.Event.Count(thistype.PRESS_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        call parent.Event.Get(thistype.PRESS_EVENT_TYPE, priority, iteration2).Run(params)

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration = iteration - 1
                endloop

                call params.Destroy()
            endmethod

            timerMethod Interval
                local thistype this = Timer.GetExpired().GetData()

                local EventResponse params = EventResponse.Create(EventResponse.DIRECT_SUBJECT_ID)

                call params.Real.SetIntervalWeight(this.intervalWeight)
                call params.User.SetTrigger(this.whichPlayer)

                call this.whichEvent.Run(params)

                call params.Destroy()
            endmethod

            trigMethod PressTrig
                local User parent = USER.Event.Native.GetTrigger()

				set thistype.IS_PRESSING[parent] = true

                call thistype.Press_TriggerEvents(parent)

				local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

                loop
                    exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                    local thistype this = parent.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                    call this.intervalTimer.Start(this.interval, true, function thistype.Interval)

                    set iteration = iteration - 1
                endloop
            endmethod

            method RegisterPress takes EventPriority priority, code actionFunction, real interval, real intervalWeight returns Event
                local User parent = this

                local Event result = Event.Create(thistype.PRESS_EVENT_TYPE, priority, actionFunction)

                if (interval > 0.) then
                    set this = thistype.allocate()

					local Timer intervalTimer = Timer.Create()

                    set this.interval = interval
                    set this.intervalTimer = intervalTimer
                    set this.intervalWeight = intervalWeight
                    set this.whichEvent = result
                    set this.whichPlayer = parent

                    call intervalTimer.SetData(this)
                    call parent.Data.Integer.Table.Add(KEY_ARRAY, this)
                    call result.AddEvent(DESTROY_EVENT)
                    call result.Data.Integer.Set(KEY, this)
                endif
                call parent.Event.Add(result)

                return result
            endmethod

	    	enumMethod InitPlayer
	    		local User parent = params.User.GetTrigger()

				set thistype.IS_PRESSING[parent] = false
	    	endmethod

            static method Init takes nothing returns nothing
                set thistype.DESTROY_EVENT = Event.Create(Event.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
                set thistype.PRESS_EVENT_TYPE = EventType.Create()
                set thistype.RELEASE_EVENT_TYPE = EventType.Create()
                call Trigger.CreateFromCode(function thistype.PressTrig).RegisterEvent.User(User.ANY, EVENT_PLAYER_ARROW_RIGHT_DOWN)
                call Trigger.CreateFromCode(function thistype.ReleaseTrig).RegisterEvent.User(User.ANY, EVENT_PLAYER_ARROW_RIGHT_UP)
                
                call Force.ALL_USERS.Do(function thistype.InitPlayer, NULL)
            endmethod
        endstruct

        //! runtextmacro Struct("UpArrow")
            static Event DESTROY_EVENT
            //! runtextmacro GetKey("KEY")
            //! runtextmacro GetKeyArray("KEY_ARRAY")
            static EventType PRESS_EVENT_TYPE
            static EventType RELEASE_EVENT_TYPE
            static real TRIGGER_INTERVAL_WEIGHT

			static boolean array IS_PRESSING

            real interval
            Timer intervalTimer
            real intervalWeight
            Event whichEvent
            User whichPlayer

			method IsPressing takes nothing returns boolean
				return thistype.IS_PRESSING[this]
			endmethod

            eventMethod Event_Destroy
                local Event whichEvent = params.Event.GetTrigger()

                local thistype this = whichEvent.Data.Integer.Get(KEY)

                local Timer intervalTimer = this.intervalTimer
                local User whichPlayer = this.whichPlayer

                call this.deallocate()
                call intervalTimer.Destroy()
                call whichEvent.Data.Integer.Remove(KEY)
                call whichEvent.RemoveEvent(DESTROY_EVENT)
                call whichPlayer.Data.Integer.Table.Remove(KEY_ARRAY, this)
                call whichPlayer.Event.Remove(whichEvent)
            endmethod

            static method Release_TriggerEvents takes User parent returns nothing
                local EventResponse params = EventResponse.Create(parent.Id.Get())

                call params.User.SetTrigger(parent)

				local integer iteration = EventPriority.ALL_COUNT

                loop
                    exitwhen (iteration < ARRAY_MIN)

                    local EventPriority priority = EventPriority.ALL[iteration]

                    local integer iteration2 = parent.Event.Count(thistype.RELEASE_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        call parent.Event.Get(thistype.RELEASE_EVENT_TYPE, priority, iteration2).Run(params)

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration = iteration - 1
                endloop

                call params.Destroy()
            endmethod

            trigMethod ReleaseTrig
                local User parent = USER.Event.Native.GetTrigger()

				set thistype.IS_PRESSING[parent] = false

                call thistype.Release_TriggerEvents(parent)

                local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

                loop
                    exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                    local thistype this = parent.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                    call this.intervalTimer.Pause()

                    set iteration = iteration - 1
                endloop
            endmethod

            static method Press_TriggerEvents takes User parent returns nothing
                local EventResponse params = EventResponse.Create(parent.Id.Get())

                call params.Real.SetIntervalWeight(1.)
                call params.User.SetTrigger(parent)

				local integer iteration = EventPriority.ALL_COUNT

                loop
                    exitwhen (iteration < ARRAY_MIN)

                    local EventPriority priority = EventPriority.ALL[iteration]

                    local integer iteration2 = parent.Event.Count(thistype.PRESS_EVENT_TYPE, priority)

                    loop
                        exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                        call parent.Event.Get(thistype.PRESS_EVENT_TYPE, priority, iteration2).Run(params)

                        set iteration2 = iteration2 - 1
                    endloop

                    set iteration = iteration - 1
                endloop

                call params.Destroy()
            endmethod

            timerMethod Interval
                local thistype this = Timer.GetExpired().GetData()

                local EventResponse params = EventResponse.Create(EventResponse.DIRECT_SUBJECT_ID)

                call params.Real.SetIntervalWeight(this.intervalWeight)
                call params.User.SetTrigger(this.whichPlayer)

                call this.whichEvent.Run(params)

                call params.Destroy()
            endmethod

            trigMethod PressTrig
                local User parent = USER.Event.Native.GetTrigger()

				set thistype.IS_PRESSING[parent] = true

                call thistype.Press_TriggerEvents(parent)

				local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

                loop
                    exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                    local thistype this = parent.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                    call this.intervalTimer.Start(this.interval, true, function thistype.Interval)

                    set iteration = iteration - 1
                endloop
            endmethod

            method RegisterPress takes EventPriority priority, code actionFunction, real interval, real intervalWeight returns Event
                local User parent = this

                local Event result = Event.Create(thistype.PRESS_EVENT_TYPE, priority, actionFunction)

                if (interval > 0.) then
                    set this = thistype.allocate()

					local Timer intervalTimer = Timer.Create()

                    set this.interval = interval
                    set this.intervalTimer = intervalTimer
                    set this.intervalWeight = intervalWeight
                    set this.whichEvent = result
                    set this.whichPlayer = parent

                    call intervalTimer.SetData(this)
                    call parent.Data.Integer.Table.Add(KEY_ARRAY, this)
                    call result.AddEvent(DESTROY_EVENT)
                    call result.Data.Integer.Set(KEY, this)
                endif
                call parent.Event.Add(result)

                return result
            endmethod

	    	enumMethod InitPlayer
	    		local User parent = params.User.GetTrigger()

				set thistype.IS_PRESSING[parent] = false
	    	endmethod

            static method Init takes nothing returns nothing
                set thistype.DESTROY_EVENT = Event.Create(Event.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
                set thistype.PRESS_EVENT_TYPE = EventType.Create()
                set thistype.RELEASE_EVENT_TYPE = EventType.Create()
                call Trigger.CreateFromCode(function thistype.PressTrig).RegisterEvent.User(User.ANY, EVENT_PLAYER_ARROW_UP_DOWN)
                call Trigger.CreateFromCode(function thistype.ReleaseTrig).RegisterEvent.User(User.ANY, EVENT_PLAYER_ARROW_UP_UP)
                
                call Force.ALL_USERS.Do(function thistype.InitPlayer, NULL)
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("KeyEvent")
        static EventType ESC_EVENT_TYPE
        static Trigger ESC_TRIGGER

        //! runtextmacro LinkToStruct("KeyEvent", "DownArrow")
        //! runtextmacro LinkToStruct("KeyEvent", "LeftArrow")
        //! runtextmacro LinkToStruct("KeyEvent", "RightArrow")
        //! runtextmacro LinkToStruct("KeyEvent", "UpArrow")

        method Esc_TriggerEvents takes nothing returns nothing
            local EventResponse params = EventResponse.Create(EventResponse.STATIC_SUBJECT_ID)

            call params.User.SetTrigger(this)

			local integer iteration = EventPriority.ALL_COUNT

            loop
                exitwhen (iteration < ARRAY_MIN)

                local EventPriority priority = EventPriority.ALL[iteration]

                local integer iteration2 = Event.CountAtStatics(thistype.ESC_EVENT_TYPE, priority)

                loop
                    exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                    call Event.GetFromStatics(thistype.ESC_EVENT_TYPE, priority, iteration2).Run(params)

                    set iteration2 = iteration2 - 1
                endloop

                set iteration = iteration - 1
            endloop

            call params.Destroy()
        endmethod

        trigMethod EscTrig
            local thistype this = USER.Event.Native.GetTrigger()

            call this.Esc_TriggerEvents()
        endmethod

        static method Init takes nothing returns nothing
            set thistype.ESC_EVENT_TYPE = EventType.Create()
            set thistype.ESC_TRIGGER = Trigger.CreateFromCode(function thistype.EscTrig)

            call thistype.ESC_TRIGGER.RegisterEvent.User(User.ANY, EVENT_PLAYER_END_CINEMATIC)

            call thistype(NULL).DownArrow.Init()
            call thistype(NULL).LeftArrow.Init()
            call thistype(NULL).RightArrow.Init()
            call thistype(NULL).UpArrow.Init()
        endmethod
    endstruct

    //! runtextmacro Struct("SlotState")
        //! runtextmacro GetKey("PLAYING_HUMANS_KEY")

        //! runtextmacro CreateSimpleAddState_OnlyGet("PlayerSlotState")

        method ChangePlayingHumans takes PlayerSlotState oldValue, PlayerSlotState value returns nothing
            if (oldValue == PlayerSlotState.PLAYING) then
                local integer index = User(this).Data.Integer.Get(PLAYING_HUMANS_KEY)
                local User otherPlayer = User.PLAYING_HUMANS[User.PLAYING_HUMANS_COUNT]

                set User.PLAYING_HUMANS[index] = otherPlayer
                set User.PLAYING_HUMANS_COUNT = User.PLAYING_HUMANS_COUNT - 1
                call otherPlayer.Data.Integer.Set(PLAYING_HUMANS_KEY, index)
            elseif (value == PlayerSlotState.PLAYING) then
                set User.PLAYING_HUMANS_COUNT = User.PLAYING_HUMANS_COUNT + 1

                set User.PLAYING_HUMANS[User.PLAYING_HUMANS_COUNT] = this
                call User(this).Data.Integer.Set(PLAYING_HUMANS_KEY, User.PLAYING_HUMANS_COUNT)
            endif
        endmethod

        method Set takes PlayerSlotState value returns nothing
            local PlayerSlotState oldValue = this.value

            set this.value = value
            if ((oldValue != value) and (User(this).Controller.Get() == PlayerController.HUMAN)) then
                call this.ChangePlayingHumans(oldValue, value)
            endif
        endmethod

        //! runtextmacro CreateSimpleAddState_OnlyStart_UsePreset("PlayerSlotState.EMPTY", "PlayerSlotState.GetFromSelf(GetPlayerSlotState(User(this).self))")
    endstruct

    //! runtextmacro Struct("State")
        method Get takes playerstate whichPlayerState returns integer
            return GetPlayerState(User(this).self, whichPlayerState)
        endmethod

        method Set takes playerstate whichPlayerState, integer value returns nothing
            if (this == User.ANY) then
                local integer iteration = User.ALL_COUNT

                loop
                    call User.ALL[iteration].State.Set(whichPlayerState, value)

                    set iteration = iteration - 1
                    exitwhen (iteration < ARRAY_MIN)
                endloop
            else
                call SetPlayerState(User(this).self, whichPlayerState, value)
            endif
        endmethod

        method Add takes playerstate whichPlayerState, integer value returns nothing
            call this.Set(whichPlayerState, this.Get(whichPlayerState) + value)
        endmethod

        method Subtract takes playerstate whichPlayerState, integer value returns nothing
            call this.Set(whichPlayerState, this.Get(whichPlayerState) - value)
        endmethod
    endstruct

    //! runtextmacro Struct("Team")
        Team value

        method Get takes nothing returns Team
            return this.value
        endmethod

        method Set takes Team value returns nothing
            set this.value = value
            call value.AddPlayer(this)
        endmethod

        //! runtextmacro CreateSimpleAddState_OnlyStart("NULL")
    endstruct
endscope

globals
    constant integer User_MAX_AMOUNT_Wrapped = 16
endglobals

//! runtextmacro BaseStruct("User", "USER")
    static EventType CHAT_EVENT_TYPE
    //! runtextmacro GetKey("KEY")
    static EventType LEAVE_EVENT_TYPE
    static constant integer MAX_HUMAN_INDEX = 6
    static thistype TEMP
    static thistype array TEMPS

    static thistype ANY
    static thistype CASTLE
    static thistype CASTLE_CONTROLABLE
    static thistype CREEP
    static thistype DUMMY
    static thistype HOST
    static thistype array HUMANS
    static integer HUMANS_COUNT = ARRAY_EMPTY
    static thistype NEUTRAL_AGGRESSIVE
    static thistype NEUTRAL_PASSIVE
    static thistype array PLAYING_HUMANS
    static integer PLAYING_HUMANS_COUNT = ARRAY_EMPTY
    static thistype SPAWN

    playercolor color
    string name
    player self

    //! runtextmacro LinkToStruct("User", "Controller")
    //! runtextmacro LinkToStruct("User", "Data")
    //! runtextmacro LinkToStruct("User", "Event")
    //! runtextmacro LinkToStruct("User", "HostAppointment")
    //! runtextmacro LinkToStruct("User", "Hero")
    //! runtextmacro LinkToStruct("User", "Id")
    //! runtextmacro LinkToStruct("User", "KeyEvent")
    //! runtextmacro LinkToStruct("User", "SlotState")
    //! runtextmacro LinkToStruct("User", "State")
    //! runtextmacro LinkToStruct("User", "Team")

    //! runtextmacro CreateAnyState("colorString", "ColorString", "string")

    method GetColor takes nothing returns playercolor
        return this.color
    endmethod

    method GetColoredName takes nothing returns string
        return (String.Color.START + this.colorString + this.name + String.Color.RESET)
    endmethod

    static method GetFromSelf takes player self returns thistype
        return Memory.IntegerKeys.GetIntegerByHandle(self, KEY)
    endmethod

    static method GetLocal takes nothing returns thistype
        return GetFromSelf(GetLocalPlayer())
    endmethod

    method IsLocal takes nothing returns boolean
        if (this == thistype.GetLocal()) then
            return true
        endif
        if (this == thistype.ANY) then
            return true
        endif

        return false
    endmethod

    method GetName takes nothing returns string
        return this.name
    endmethod

    method GetSelf takes nothing returns player
        return this.self
    endmethod

    method Chat_TriggerEvents takes string input returns nothing        
        local EventResponse params = EventResponse.Create(EventResponse.STRING_DATA_SUBJECT_ID)

        call params.User.SetTrigger(this)

		local string matchInput = input

        loop
            exitwhen (matchInput == null)

            call params.String.SetChat(input)
            call params.String.SetMatch(matchInput)

            local integer iteration = EventPriority.ALL_COUNT

            loop
                exitwhen (iteration < ARRAY_MIN)

                local EventPriority priority = EventPriority.ALL[iteration]

                local integer iteration2 = StringData.Event.Count(matchInput, thistype.CHAT_EVENT_TYPE, priority)

                loop
                    exitwhen (iteration2 < Memory.StringKeys.Table.STARTED)

                    call StringData.Event.Get(matchInput, thistype.CHAT_EVENT_TYPE, priority, iteration2).Run(params)

                    set iteration2 = iteration2 - 1
                endloop

                set iteration = iteration - 1
            endloop

            set matchInput = String.SubLeft(matchInput, String.Length(matchInput) - 2)
        endloop

        call params.Destroy()
    endmethod

    trigMethod ChatTrig
        local string input = StringData.Event.Native.GetChat()
        local thistype this = USER.Event.Native.GetTrigger()

        call this.Chat_TriggerEvents(input)
    endmethod

    static method Chat_Init takes nothing returns nothing
        call Trigger.CreateFromCode(function thistype.ChatTrig).RegisterEvent.UserChat(thistype.ANY, "", false)
    endmethod

    method EnableAbilityBySelf takes integer spellId, boolean flag returns nothing
        if (this == thistype.ANY) then
            local integer iteration = thistype.ALL_COUNT

            loop
                call thistype.ALL[iteration].EnableAbilityBySelf(spellId, flag)

                set iteration = iteration - 1
                exitwhen (iteration < ARRAY_MIN)
            endloop
        else
            call SetPlayerAbilityAvailable(this.self, spellId, flag)
        endif
    endmethod

    method EnableAbility takes Spell whichSpell, boolean flag returns nothing
        call this.EnableAbilityBySelf(whichSpell.self, flag)
    endmethod

    method Leave_TriggerEvents takes nothing returns nothing
        local EventResponse params = EventResponse.Create(EventResponse.STATIC_SUBJECT_ID)
        local EventResponse userParams = EventResponse.Create(this.Id.Get())

        call params.User.SetTrigger(this)

        call userParams.User.SetTrigger(this)

		local integer iteration = EventPriority.ALL_COUNT

        loop
            exitwhen (iteration < ARRAY_MIN)

            local EventPriority priority = EventPriority.ALL[iteration]

            local integer iteration2 = Event.CountAtStatics(thistype.LEAVE_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call Event.GetFromStatics(thistype.LEAVE_EVENT_TYPE, priority, iteration2).Run(params)

                set iteration2 = iteration2 - 1
            endloop

            set iteration2 = this.Event.Count(thistype.LEAVE_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call this.Event.Get(thistype.LEAVE_EVENT_TYPE, priority, iteration2).Run(userParams)

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration - 1
        endloop

        call params.Destroy()
        call userParams.Destroy()
    endmethod

    trigMethod LeaveTrig
        local thistype this = USER.Event.Native.GetTrigger()

        call Game.DisplayTextTimed(thistype.ANY, String.Color.Do(this.GetName(), this.GetColorString()) + "'s footprints were blown away", 10.)

        call this.Leave_TriggerEvents()
    endmethod

    static method Leave_Init takes nothing returns nothing
        set thistype.LEAVE_EVENT_TYPE = EventType.Create()
        call Trigger.CreateFromCode(function thistype.LeaveTrig).RegisterEvent.User(thistype.ANY, EVENT_PLAYER_LEAVE)
    endmethod

    method EnumSelectedUnits takes code action returns nothing
        local integer iteration = UNIT.Selection.CountAtPlayer(this)

        if (iteration < Memory.IntegerKeys.Table.STARTED) then
            return
        endif

        local Group dummyGroup = Group.Create()

        loop
            call dummyGroup.AddUnit(UNIT.Selection.GetFromPlayer(this, iteration))

            set iteration = iteration - 1
            exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
        endloop

        call dummyGroup.Do(action)

        call dummyGroup.Destroy()
    endmethod

    method SendError takes string msg returns nothing
        call Game.DisplayTextTimed(this, String.Color.GOLD + msg + String.Color.RESET, 2.)
        call Sound.ERROR.PlayForPlayer(this)
    endmethod

    method SetColor takes playercolor value returns nothing
        set this.color = value

        call SetPlayerColor(this.self, value)
    endmethod

    method SetName takes string value returns nothing
        set this.name = value

        call SetPlayerName(this.self, value)
    endmethod

    method SetResearchBySelf takes integer researchId, integer level returns nothing
        if (this == thistype.ANY) then
            local integer iteration = thistype.ALL_COUNT

            loop
                call thistype.ALL[iteration].SetResearchBySelf(researchId, level)

                set iteration = iteration - 1
                exitwhen (iteration < ARRAY_MIN)
            endloop
        else
            call SetPlayerTechResearched(this.self, researchId, level)
        endif
    endmethod

    method SetTeam takes Team whichTeam returns nothing
        call this.Team.Set(whichTeam)
    endmethod

	method GetNativeIndex takes nothing returns integer
		if (this == NULL) then
			call DebugEx(thistype.NAME + "GetNativeIndex: no valid user " + Integer.ToString(this))
			
			return -1
		endif
		if (this.self == null) then
			call DebugEx(thistype.NAME + "GetNativeIndex: no valid self " + Integer.ToString(this))
			
			return -1
		endif
		
		return GetPlayerId(this.self)
	endmethod

    static method GetFromNativeIndex takes integer nativeIndex returns thistype
        if ((nativeIndex < 0) or (nativeIndex > User_MAX_AMOUNT_Wrapped - 1)) then
            call DebugEx(thistype.NAME + "GetFromNativeIndex: " + Integer.ToString(nativeIndex) + " out of bounds")

            return NULL
        endif

        local thistype this = User.GetFromSelf(Player(nativeIndex))

        if (this == NULL) then
            call DebugEx(thistype.NAME + "GetFromNativeIndex: " + Integer.ToString(nativeIndex) + " not assigned")

            return NULL
        endif

        return this
    endmethod

    static method Create takes string defaultName, integer nativeIndex, string colorString returns thistype
        local thistype this = thistype.allocate()

		local player self = Player(nativeIndex)

        set this.self = self
        call Memory.IntegerKeys.SetIntegerByHandle(self, KEY, this)
        call this.SetColor(GetPlayerColor(self))
        call this.SetColorString(colorString)
        call this.SetName(GetPlayerName(self))

        set self = null
        call this.AddToList()

        call this.Controller.Event_Create()
        call this.Hero.Event_Create()
        call this.Id.Event_Create()
        call this.SlotState.Event_Create()
        call this.Team.Event_Create()

        if ((GetPlayerController(this.self) != MAP_CONTROL_USER) or (GetPlayerSlotState(this.self) != PLAYER_SLOT_STATE_PLAYING)) then
            call this.SetName(defaultName)
        endif

        return this
    endmethod

    initMethod Init of Header_3
        set thistype.CHAT_EVENT_TYPE = EventType.Create()
        set thistype.LEAVE_EVENT_TYPE = EventType.Create()

        call thistype(NULL).Hero.Init()

        call PlayerController.Init()
        call PlayerSlotState.Init()
        call Team.Init()
        call Visibility.Init()

		local thistype this

        //Red
        set this = thistype.Create("HumanRed", 0, "ffff0000")

        call this.SetTeam(Team.DEFENDERS)

        //Blue
        set this = thistype.Create("HumanBlue", 1, "ff0000ff")

        call this.SetTeam(Team.DEFENDERS)

        //Teal
        set this = thistype.Create("HumanTeal", 2, "ff18e7bd")

        call this.SetTeam(Team.DEFENDERS)

        //Purple
        set this = thistype.Create("HumanPurple", 3, "ff520084")

        call this.SetTeam(Team.DEFENDERS)

        //Yellow
        set this = thistype.Create("HumanYellow", 4, "ffffff00")

        call this.SetTeam(Team.DEFENDERS)

        //Orange
        set this = thistype.Create("HumanOrange", 5, "ffff8a08")

        call this.SetTeam(Team.DEFENDERS)

        //Green
        set this = thistype.Create("HumanGreen", 6, "ff18be00")

        call this.SetTeam(Team.DEFENDERS)

        //Castle
        set this = thistype.Create("Castle", 7, "ffe759ad")

        set thistype.CASTLE = this
        call this.SetTeam(Team.DEFENDERS)

        call StartCampaignAI(this.self, thistype.LALA_AI)

        //Dummy
        set this = thistype.Create("Dummy", 8, "ff949694")

        set thistype.DUMMY = this
        call this.SetTeam(Team.STAFF)

        //Creep
        set this = thistype.Create("Creeps", 9, "ff7bbef7")

        set thistype.CREEP = this
        call this.SetColor(PLAYER_COLOR_AQUA)
        call this.SetTeam(Team.ATTACKERS)

        //Spawn
        set this = thistype.Create("Spawns", 10, "ff086142")

        set thistype.SPAWN = this
        call this.SetColor(PLAYER_COLOR_BROWN)
        call this.SetTeam(Team.ATTACKERS)

        //Castle (controlable)
        //4a2800
        set this = thistype.Create("Castle (controlable)", 11, "ffe759ad")

        set thistype.CASTLE_CONTROLABLE = this
        call this.SetColor(PLAYER_COLOR_PINK)
        call this.SetTeam(Team.DEFENDERS)

        //Neutral Aggressive
        set this = thistype.Create("Neutral aggressive", 12, "ff000000")

        set thistype.NEUTRAL_AGGRESSIVE = this
        call this.SetTeam(Team.ATTACKERS)

		call Team.SetStateOfPlayers(this, this, ALLIANCE_PASSIVE, false, false)

        //Neutral Passive
        set this = thistype.Create("Neutral passive", 15, "ff000000")

        set thistype.NEUTRAL_PASSIVE = this

        set thistype.ANY = NULL

        local integer iteration = thistype.ALL_COUNT

        loop
            exitwhen (iteration < ARRAY_MIN)

            call Team.SetStateOfPlayers(User.DUMMY, thistype.ALL[iteration], ALLIANCE_PASSIVE, true, true)
            if (thistype.ALL[iteration].Team.Get() == Team.DEFENDERS) then
                call Team.SetStateOfPlayers(User.CASTLE_CONTROLABLE, thistype.ALL[iteration], ALLIANCE_SHARED_ADVANCED_CONTROL, true, true)
                call Team.SetStateOfPlayers(User.CASTLE_CONTROLABLE, thistype.ALL[iteration], ALLIANCE_SHARED_CONTROL, true, true)
            endif

            set iteration = iteration - 1
        endloop

        call Visibility.AddRect(thistype.DUMMY, Rectangle.WORLD)
        call Visibility.AddRect(thistype.SPAWN, Rectangle.WORLD)

        call Team.SetStateOfPlayers(User.CREEP, User.CASTLE, ALLIANCE_PASSIVE, true, true)
        call Team.SetStateOfPlayers(User.CREEP, User.CASTLE_CONTROLABLE, ALLIANCE_PASSIVE, true, true)

        call thistype.Chat_Init()
        call thistype.Leave_Init()

        call thistype(NULL).HostAppointment.Init()

        call Force.Init()

        call thistype(NULL).KeyEvent.Init()
    endmethod
endstruct