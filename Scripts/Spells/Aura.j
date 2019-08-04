//! runtextmacro Folder("Aura")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Struct("Boolean")
            //! runtextmacro Data_Type_Implement("Aura", "Boolean", "boolean")
        endstruct

        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("Aura", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("Aura", "Integer", "integer")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Boolean")
        //! runtextmacro LinkToStruct("Data", "Integer")

        //! runtextmacro Data_Implement("Aura")
    endstruct

    //! runtextmacro Struct("Event")
        //! runtextmacro Event_Implement("Aura")
    endstruct

	//! runtextmacro Struct("Target")
		static EventType ENDING_EVENT_TYPE
		static EventType START_EVENT_TYPE

		method Ending_TriggerEvents takes Unit target returns nothing
			local Aura parent = this

            local EventResponse params = EventResponse.Create(parent.Id.Get())

            call params.Aura.SetTrigger(parent)
            call params.Unit.SetTrigger(target)

			local integer iteration = EventPriority.ALL_COUNT

            loop
                exitwhen (iteration < ARRAY_MIN)

                local EventPriority priority = EventPriority.ALL[iteration]

                local integer iteration2 = parent.Event.Count(thistype.ENDING_EVENT_TYPE, priority)

                loop
                    exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                    call parent.Event.Get(thistype.ENDING_EVENT_TYPE, priority, iteration2).Run(params)

                    set iteration2 = iteration2 - 1
                endloop

                set iteration = iteration - 1
            endloop

            call params.Destroy()
		endmethod

		method Ending takes Unit target returns nothing
			local Aura parent = this

			call this.Ending_TriggerEvents(target)
		endmethod

		method Start_TriggerEvents takes Unit target returns nothing
			local Aura parent = this

            local EventResponse params = EventResponse.Create(parent.Id.Get())

            call params.Aura.SetTrigger(parent)
            call params.Unit.SetTrigger(target)

			local integer iteration = EventPriority.ALL_COUNT

            loop
                exitwhen (iteration < ARRAY_MIN)

                local EventPriority priority = EventPriority.ALL[iteration]

                local integer iteration2 = parent.Event.Count(thistype.START_EVENT_TYPE, priority)

                loop
                    exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                    call parent.Event.Get(thistype.START_EVENT_TYPE, priority, iteration2).Run(params)

                    set iteration2 = iteration2 - 1
                endloop

                set iteration = iteration - 1
            endloop

            call params.Destroy()
		endmethod

		method Start takes Unit target returns nothing
			local Aura parent = this

			call this.Start_TriggerEvents(target)
		endmethod

		static method Init takes nothing returns nothing
			set thistype.ENDING_EVENT_TYPE = EventType.Create()
			set thistype.START_EVENT_TYPE = EventType.Create()
		endmethod
	endstruct
endscope

//! runtextmacro BaseStruct("Aura", "AURA")
	static Group ENUM_GROUP
	static Group ENUM_GROUP2
	//! runtextmacro GetKeyArray("KEY_ARRAY")
	static Event TRANSPORT_ENDING_EVENT
	static Event TRANSPORT_START_EVENT
	static constant real UPDATE_TIME = 0.75
	static Timer UPDATE_TIMER

	//! runtextmacro CreateList("ACTIVE_LIST")
	//! runtextmacro CreateForEachList("FOR_EACH_LIST", "ACTIVE_LIST")
	//! runtextmacro CreateList("REG_LIST")

	//! runtextmacro LinkToStruct("Aura", "Data")
	//! runtextmacro LinkToStruct("Aura", "Event")
	//! runtextmacro LinkToStruct("Aura", "Id")

	//! runtextmacro LinkToStruct("Aura", "Target")

	//! runtextmacro CreateAnyState("areaRange", "AreaRange", "real")
	//! runtextmacro CreateAnyState("caster", "Caster", "Unit")
	//! runtextmacro CreateAnyState("data", "Data", "integer")
	//! runtextmacro CreateAnyState("targetFilter", "TargetFilter", "BoolExpr")
	//! runtextmacro CreateAnyState("targetGroup", "TargetGroup", "UnitList")

    method ClearTargetGroup takes nothing returns nothing
    	local UnitList targetGroup = this.GetTargetGroup()

        loop
            local Unit target = targetGroup.FetchFirst()
            exitwhen (target == NULL)

            call this.Target.Ending(target)
        endloop
    endmethod

	method Update takes nothing returns nothing
        local Unit caster = this.GetCaster()
        local UnitList targetGroup = this.GetTargetGroup()

        local real x = caster.Position.X.Get()
        local real y = caster.Position.Y.Get()

        set User.TEMP = caster.Owner.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, this.GetAreaRange(), this.GetTargetFilter())

		call thistype.ENUM_GROUP.RemoveUnit(caster)

        local Unit target = targetGroup.GetFirst()

        if (target != NULL) then
            loop
                if thistype.ENUM_GROUP.ContainsUnit(target) then
                    call targetGroup.Remove(target)

                    call thistype.ENUM_GROUP.RemoveUnit(target)
                    call thistype.ENUM_GROUP2.AddUnit(target)
                else
                    call targetGroup.Remove(target)

                    call this.Target.Ending(target)
                endif

                set target = targetGroup.GetFirst()
                exitwhen (target == NULL)
            endloop

            call targetGroup.AddGroup2Clear(thistype.ENUM_GROUP2)
        endif

        set target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            loop
                call targetGroup.Add(target)

                call this.Target.Start(target)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
	endmethod

	timerMethod UpdateByTimer
        call thistype.FOR_EACH_LIST_Set()

        loop
            local thistype this = thistype.FOR_EACH_LIST_FetchFirst()
            exitwhen (this == NULL)

            call this.Update()
        endloop
	endmethod

	method Deactivate takes nothing returns nothing
		if thistype.ACTIVE_LIST_Remove(this) then
			call thistype.UPDATE_TIMER.Pause()
		endif

		call this.ClearTargetGroup()
	endmethod

	method TryActivate_Conditions takes nothing returns boolean
		if caster.Transport.Is() then
			return false
		endif

		return true
	endmethod

	method TryActivate takes nothing returns nothing
		if not this.TryActivate_Conditions() then
			return
		endif

		if thistype.ACTIVE_LIST_Add(this) then
			call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.UpdateByTimer)
		endif
	endmethod

	eventMethod Event_TransportEnding
		local Unit caster = params.Unit.GetTrigger()

		local integer iteration = caster.Data.Integer.Table.Count(KEY_ARRAY)

		loop
			local thistype this = caster.Data.Integer.Table.Get(KEY_ARRAY, iteration)

			call this.TryActivate()

			set iteration = iteration - 1
			exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
		endloop
	endmethod

	eventMethod Event_TransportStart
		local Unit caster = params.Unit.GetTrigger()

		local integer iteration = caster.Data.Integer.Table.Count(KEY_ARRAY)

		loop
			local thistype this = caster.Data.Integer.Table.Get(KEY_ARRAY, iteration)

			call this.Deactivate()

			set iteration = iteration - 1
			exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
		endloop
	endmethod

	method Disable takes nothing returns nothing
		local Unit caster = this.GetCaster()

		if caster.Data.Integer.Table.Remove(KEY_ARRAY, this) then
			call caster.Event.Remove(TRANSPORT_ENDING_EVENT)
			call caster.Event.Remove(TRANSPORT_START_EVENT)
		endif

		call thistype.REG_LIST_Remove(this)

		call this.Deactivate()
	endmethod

	method Enable takes nothing returns nothing
		local Unit caster = this.GetCaster()

		if caster.Data.Integer.Table.Add(KEY_ARRAY, this) then
			call caster.Event.Add(TRANSPORT_ENDING_EVENT)
			call caster.Event.Add(TRANSPORT_START_EVENT)
		endif

		call thistype.REG_LIST_Add(this)

		call this.TryActivate()
	endmethod

	method Destroy takes nothing returns nothing
		local Unit caster = this.GetCaster()
		local UnitList targetGroup = this.GetTargetGroup()

		call this.Disable()

		call targetGroup.Destroy()

		call this.Event.Clear()

		call this.deallocate()
	endmethod

	static method Create takes Unit caster returns thistype
		local thistype this = thistype.allocate()

		call this.Id.Event_Create()

		call this.SetAreaRange(0.)
		call this.SetCaster(caster)
		call this.SetTargetFilter(NULL)
		call this.SetTargetGroup(UnitList.Create())

		return this
	endmethod

	initMethod Init of Spells_Header
		set thistype.ENUM_GROUP = Group.Create()
		set thistype.ENUM_GROUP2 = Group.Create()
        set thistype.TRANSPORT_ENDING_EVENT = Event.Create(UNIT.Transport.ENDING_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_TransportEnding)
        set thistype.TRANSPORT_START_EVENT = Event.Create(UNIT.Transport.START_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_TransportStart)
		set thistype.UPDATE_TIMER = Timer.Create()

		call thistype(NULL).Target.Init()
	endmethod
endstruct