//! runtextmacro BaseStruct("LightningType", "LIGHTNING_TYPE")
    //! runtextmacro CreateAnyState("self", "Self", "string")

    static method Create takes string self returns thistype
        local thistype this = thistype.allocate()

        call this.SetSelf(self)

        return this
    endmethod

    //! runtextmacro GetKeyArray("INIT_KEY_ARRAY")

    static method AddInit takes code c, string name returns nothing
        call Trigger.AddObjectInit(INIT_KEY_ARRAY, c, name)
    endmethod

    static method Init takes nothing returns nothing
    endmethod
endstruct

//! runtextmacro Folder("Lightning")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("Lightning", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("Lightning", "Integer", "integer")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Integer")

        //! runtextmacro Data_Implement("Lightning")
    endstruct

    //! runtextmacro Struct("Event")
        //! runtextmacro Event_Implement("Lightning")
    endstruct

    //! runtextmacro Folder("Color")
        //! runtextmacro Struct("Red")
            //! runtextmacro CreateSimpleAddState("real", "GetLightningColorR(Lightning(this).self)")
        endstruct

        //! runtextmacro Struct("Green")
            //! runtextmacro CreateSimpleAddState("real", "GetLightningColorG(Lightning(this).self)")
        endstruct

        //! runtextmacro Struct("Blue")
            //! runtextmacro CreateSimpleAddState("real", "GetLightningColorB(Lightning(this).self)")
        endstruct

        //! runtextmacro Struct("Alpha")
            //! runtextmacro CreateSimpleAddState("real", "GetLightningColorA(Lightning(this).self)")
        endstruct

        //! runtextmacro Struct("Timed")
            static Event DESTROY_EVENT
            //! runtextmacro GetKey("KEY")
            //! runtextmacro GetKeyArray("KEY_ARRAY")
            //! runtextmacro CreateTimeByFramesAmount("UPDATE_TIME", "4")
            static Timer UPDATE_TIMER

            real bonusRedPerInterval
            real bonusGreenPerInterval
            real bonusBluePerInterval
            real bonusAlphaPerInterval
            Timer durationTimer
            Lightning parent

            method Ending takes Timer durationTimer, Lightning parent returns nothing
                call this.deallocate()
                call durationTimer.Destroy()
                if parent.Data.Integer.Table.Remove(KEY_ARRAY, this) then
                    call parent.Event.Remove(DESTROY_EVENT)
                endif
                if this.RemoveFromList() then
                    call thistype.UPDATE_TIMER.Pause()
                endif
            endmethod

            eventMethod Event_Destroy
                local Lightning parent = params.Lightning.GetTrigger()

                local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

                loop
                    local thistype this = parent.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                    call this.Ending(this.durationTimer, parent)

                    set iteration = iteration - 1
                    exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
                endloop
            endmethod

            timerMethod EndingByTimer
                local Timer durationTimer = Timer.GetExpired()

                local thistype this = durationTimer.GetData()

                call this.Ending(durationTimer, this.parent)
            endmethod

            timerMethod Update
                local integer iteration = thistype.ALL_COUNT

                loop
                    local thistype this = thistype.ALL[iteration]

                    call this.parent.Color.Add(this.bonusRedPerInterval, this.bonusGreenPerInterval, this.bonusBluePerInterval, this.bonusAlphaPerInterval)

                    set iteration = iteration - 1
                    exitwhen (iteration < ARRAY_MIN)
                endloop
            endmethod

            method Add takes real red, real green, real blue, real alpha, real duration returns nothing
                local Lightning parent = this

                if (duration == 0.) then
                    call Lightning(this).Color.Add(red, green, blue, alpha)

                    return
                endif
                
                local integer wavesAmount = Real.ToInt(duration / thistype.UPDATE_TIME)

				set this = thistype.allocate()

				local Timer durationTimer = Timer.Create()

                set this.bonusRedPerInterval = red / wavesAmount
                set this.bonusGreenPerInterval = green / wavesAmount
                set this.bonusBluePerInterval = blue / wavesAmount
                set this.bonusAlphaPerInterval = alpha / wavesAmount
                set this.durationTimer = durationTimer
                set this.parent = parent
                call durationTimer.SetData(this)
                if parent.Data.Integer.Table.Add(KEY_ARRAY, this) then
                    call parent.Event.Add(DESTROY_EVENT)
                endif

                if this.AddToList() then
                    call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.Update)
                endif

                call durationTimer.Start(duration, false, function thistype.EndingByTimer)
            endmethod

            method Subtract takes real red, real green, real blue, real alpha, real duration returns nothing
                call this.Add(-red, -green, -blue, -alpha, duration)
            endmethod

            static method Init takes nothing returns nothing
                set thistype.DESTROY_EVENT = Event.Create(Lightning.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
                set thistype.UPDATE_TIMER = Timer.Create()
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Color")
        //! runtextmacro LinkToStruct("Color", "Red")
        //! runtextmacro LinkToStruct("Color", "Green")
        //! runtextmacro LinkToStruct("Color", "Blue")
        //! runtextmacro LinkToStruct("Color", "Alpha")

        //! runtextmacro LinkToStruct("Color", "Timed")

        //! runtextmacro CreateSimpleAddState_OnlyGet("real")

        method Set takes real red, real green, real blue, real alpha returns nothing
            local User whichPlayer = User.GetLocal()

            call this.Red.Set(red)
            call this.Green.Set(green)
            call this.Blue.Set(blue)
            call this.Alpha.Set(alpha)

            set red = Math.Limit(red, 0., 1.)
            set green = Math.Limit(green, 0., 1.)
            set blue = Math.Limit(blue, 0., 1.)
            set alpha = Math.Limit(alpha, 0., 1.)

            call SetLightningColor(Lightning(this).self, red, green, blue, alpha)
        endmethod

        method Add takes real red, real green, real blue, real alpha returns nothing
            call this.Set(this.Red.Get() + red, this.Green.Get() + green, this.Blue.Get() + blue, this.Alpha.Get() + alpha)
        endmethod

        method Subtract takes real red, real green, real blue, real alpha returns nothing
            call this.Add(-red, -green, -blue, -alpha)
        endmethod

        method Update takes nothing returns nothing
            call this.Set(this.Red.Get(), this.Green.Get(), this.Blue.Get(), this.Alpha.Get())
        endmethod

        method Event_Create takes nothing returns nothing
            call this.Red.Event_Create()
            call this.Green.Event_Create()
            call this.Blue.Event_Create()
            call this.Alpha.Event_Create()

            call this.Set(this.Red.Get(), this.Green.Get(), this.Blue.Get(), this.Alpha.Get())
        endmethod

        static method Init takes nothing returns nothing
            call thistype(NULL).Timed.Init()
        endmethod
    endstruct

    //! runtextmacro Struct("FromDummyUnitToUnit")
        //! runtextmacro GetKeyArray("KEY")
        //! runtextmacro GetKeyArray("KEY_ARRAY")
        static Event PARENT_STOP_EVENT
        static Event SOURCE_DESTROY_EVENT
        static Event TARGET_DESTROY_EVENT
        //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "2")
        static Timer UPDATE_TIMER

        Lightning parent
        DummyUnit source
        real sourceX
        real sourceY
        real sourceZ
        real sourceZOffset
        Unit target
        real targetX
        real targetY
        real targetZ

        timerMethod Update
            local integer iteration = thistype.ALL_COUNT

            loop
                local thistype this = thistype.ALL[iteration]

                local DummyUnit source = this.source
                local Unit target = this.target

	            local real sourceX
	            local real sourceY
	            local real sourceZ

                if (source == NULL) then
                    set sourceX = this.sourceX
                    set sourceY = this.sourceY
                    set sourceZ = this.sourceZ
                else
                    set sourceX = source.Position.X.Get()
                    set sourceY = source.Position.Y.Get()
                    set sourceZ = source.Position.Z.Get() + this.sourceZOffset
                endif

	            local real targetX
	            local real targetY
	            local real targetZ

                if (target == NULL) then
                    set targetX = this.targetX
                    set targetY = this.targetY
                    set targetZ = this.targetZ
                else
                    set targetX = target.Position.X.Get()
                    set targetY = target.Position.Y.Get()
                    set targetZ = target.Position.Z.GetByCoords(targetX, targetY) + target.Impact.Z.Get(true)
                endif

                call this.parent.Move(sourceX, sourceY, sourceZ, targetX, targetY, targetZ)

                set iteration = iteration - 1
                exitwhen (iteration < ARRAY_MIN)
            endloop
        endmethod

        method SourceEnding takes DummyUnit source returns nothing
            if source.Data.Integer.Table.Remove(KEY_ARRAY, this) then
                call source.Event.Remove(SOURCE_DESTROY_EVENT)
            endif
        endmethod

        method TargetEnding takes Unit target returns nothing
            if target.Data.Integer.Table.Remove(KEY_ARRAY, this) then
                call target.Event.Remove(TARGET_DESTROY_EVENT)
                call target.Refs.Subtract()
            endif
        endmethod

        method Ending takes Lightning parent, DummyUnit source, Unit target returns nothing
            call this.deallocate()
            call parent.Data.Integer.Remove(KEY)
            call parent.Event.Remove(PARENT_STOP_EVENT)
            if (source != NULL) then
                call this.SourceEnding(source)
            endif
            if (target != NULL) then
                call this.TargetEnding(target)
            endif
            if this.RemoveFromList() then
                call thistype.UPDATE_TIMER.Pause()
            endif
        endmethod

        eventMethod Event_Parent_Stop
            local Lightning parent = params.Lightning.GetTrigger()

            local thistype this = parent.Data.Integer.Get(KEY)

            call this.Ending(parent, this.source, this.target)
        endmethod

        eventMethod Event_Source_Destroy
            local DummyUnit source = params.DummyUnit.GetTrigger()

            local integer iteration = source.Data.Integer.Table.Count(KEY_ARRAY)

            loop
                local thistype this = source.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                if (this.target == NULL) then
                    call this.Ending(this.parent, source, NULL)

                    call parent.Destroy()
                else
                    call this.SourceEnding(source)

                    set this.source = NULL
                    set this.sourceX = source.Position.X.Get()
                    set this.sourceY = source.Position.Y.Get()

                    set this.sourceZ = source.Position.Z.Get() + this.sourceZOffset
                endif

                set iteration = iteration - 1
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
            endloop
        endmethod

        eventMethod Event_Target_Destroy
            local Unit target = params.Unit.GetTrigger()

            local integer iteration = target.Data.Integer.Table.Count(KEY_ARRAY)

            loop
                local thistype this = target.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                if (this.source == NULL) then
                    call this.Ending(this.parent, NULL, target)

                    call parent.Destroy()
                else
                    local real targetX = target.Position.X.Get()
                    local real targetY = target.Position.Y.Get()
                    call this.TargetEnding(target)

                    set this.target = NULL
                    set this.targetX = targetX
                    set this.targetY = targetY

                    set this.targetZ = target.Position.Z.GetByCoords(targetX, targetY) + target.Impact.Z.Get(true)
                endif

                set iteration = iteration - 1
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
            endloop
        endmethod

        method Start takes DummyUnit source, real sourceZOffset, Unit target returns nothing
            local Lightning parent = this

            local real targetX = target.Position.X.Get()
            local real targetY = target.Position.Y.Get()

            call parent.Start()

            set this = thistype.allocate()

            set this.parent = parent
            set this.source = source
            set this.sourceZOffset = sourceZOffset
            set this.target = target
            call parent.Data.Integer.Set(KEY, this)
            call parent.Event.Add(PARENT_STOP_EVENT)
            if source.Data.Integer.Table.Add(KEY_ARRAY, this) then
                call source.Event.Add(SOURCE_DESTROY_EVENT)
            endif
            if target.Data.Integer.Table.Add(KEY_ARRAY, this) then
                call target.Event.Add(TARGET_DESTROY_EVENT)
                call target.Refs.Add()
            endif

            call parent.Move(source.Position.X.Get(), source.Position.Y.Get(), source.Position.Z.Get() + sourceZOffset, targetX, targetY, target.Position.Z.GetByCoords(targetX, targetY) + target.Impact.Z.Get(true))

            if this.AddToList() then
                call UPDATE_TIMER.Start(UPDATE_TIME, true, function thistype.Update)
            endif
        endmethod

        static method Init takes nothing returns nothing
            set thistype.PARENT_STOP_EVENT = Event.Create(Lightning.STOP_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Parent_Stop)
            set thistype.SOURCE_DESTROY_EVENT = Event.Create(DummyUnit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Source_Destroy)
            set thistype.TARGET_DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Target_Destroy)
            set thistype.UPDATE_TIMER = Timer.Create()
        endmethod
    endstruct

    //! runtextmacro Struct("FromSpotToDummyUnit")
        //! runtextmacro GetKeyArray("KEY")
        //! runtextmacro GetKeyArray("KEY_ARRAY")
        static Event PARENT_STOP_EVENT
        static Event TARGET_DESTROY_EVENT
        //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "2")
        static Timer UPDATE_TIMER

        Lightning parent
        real sourceX
        real sourceY
        real sourceZ
        DummyUnit target
        real targetX
        real targetY
        real targetZ

        timerMethod Update
            local integer iteration = thistype.ALL_COUNT

            loop
                local thistype this = thistype.ALL[iteration]

                local DummyUnit target = this.target

	            local real targetX
	            local real targetY
	            local real targetZ

                if (target == NULL) then
                    set targetX = this.targetX
                    set targetY = this.targetY
                    set targetZ = this.targetZ
                else
                    set targetX = target.Position.X.Get()
                    set targetY = target.Position.Y.Get()
                    set targetZ = target.Position.Z.Get()
                endif

                call this.parent.Move(this.sourceX, this.sourceY, this.sourceZ, targetX, targetY, targetZ)

                set iteration = iteration - 1
                exitwhen (iteration < ARRAY_MIN)
            endloop
        endmethod

        method Ending takes Lightning parent, DummyUnit target returns nothing
            call this.deallocate()
            call parent.Data.Integer.Remove(KEY)
            call parent.Event.Remove(PARENT_STOP_EVENT)
            if target.Data.Integer.Table.Remove(KEY_ARRAY, this) then
                call target.Event.Remove(TARGET_DESTROY_EVENT)
                //call target.Refs.Subtract()
            endif
            if this.RemoveFromList() then
                call thistype.UPDATE_TIMER.Pause()
            endif
        endmethod

        eventMethod Event_Parent_Stop
            local Lightning parent = params.Lightning.GetTrigger()

            local thistype this = parent.Data.Integer.Get(KEY)

            call this.Ending(parent, this.target)
        endmethod

        eventMethod Event_Target_Destroy
            local DummyUnit target = params.DummyUnit.GetTrigger()

            local integer iteration = target.Data.Integer.Table.Count(KEY_ARRAY)

            loop
                local thistype this = target.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                call this.Ending(this.parent, target)

                call parent.Destroy()

                set iteration = iteration - 1
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
            endloop
        endmethod

        method Start takes real sourceX, real sourceY, real sourceZ, DummyUnit target returns nothing
            local Lightning parent = this

            local real targetX = target.Position.X.Get()
            local real targetY = target.Position.Y.Get()
            local real targetZ = target.Position.Z.Get()

            call parent.Start()

            set this = thistype.allocate()

            set this.parent = parent
            set this.sourceX = sourceX
            set this.sourceY = sourceY
            set this.sourceZ = sourceZ
            set this.target = target
            call parent.Data.Integer.Set(KEY, this)
            call parent.Event.Add(PARENT_STOP_EVENT)
            if target.Data.Integer.Table.Add(KEY_ARRAY, this) then
                call target.Event.Add(TARGET_DESTROY_EVENT)
                //call target.Refs.Add()
            endif

            call parent.Move(sourceX, sourceY, sourceZ, targetX, targetY, targetZ)

            if this.AddToList() then
                call thistype.UPDATE_TIMER.Start(UPDATE_TIME, true, function thistype.Update)
            endif
        endmethod

        static method Init takes nothing returns nothing
            set thistype.PARENT_STOP_EVENT = Event.Create(Lightning.STOP_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Parent_Stop)
            set thistype.TARGET_DESTROY_EVENT = Event.Create(DummyUnit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Target_Destroy)
            set thistype.UPDATE_TIMER = Timer.Create()
        endmethod
    endstruct

    //! runtextmacro Struct("FromSpotToSpot")
        //! runtextmacro GetKeyArray("KEY")
        static Event PARENT_STOP_EVENT

        Lightning parent
        real sourceX
        real sourceY
        real sourceZ
        real targetX
        real targetY
        real targetZ

        method Ending takes Lightning parent returns nothing
            call this.deallocate()
            call parent.Data.Integer.Remove(KEY)
            call parent.Event.Remove(PARENT_STOP_EVENT)
        endmethod

        eventMethod Event_Parent_Stop
            local Lightning parent = params.Lightning.GetTrigger()

            local thistype this = parent.Data.Integer.Get(KEY)

            call this.Ending(parent)
        endmethod

        method Start takes real sourceX, real sourceY, real sourceZ, real targetX, real targetY, real targetZ returns nothing
            local Lightning parent = this

            call parent.Start()

            set this = thistype.allocate()

            set this.parent = parent
            set this.sourceX = sourceX
            set this.sourceY = sourceY
            set this.sourceZ = sourceZ
            set this.targetX = targetX
            set this.targetY = targetY
            set this.targetZ = targetZ
            call parent.Data.Integer.Set(KEY, this)
            call parent.Event.Add(PARENT_STOP_EVENT)

            call parent.Move(sourceX, sourceY, sourceZ, targetX, targetY, targetZ)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.PARENT_STOP_EVENT = Event.Create(Lightning.STOP_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Parent_Stop)
        endmethod
    endstruct

    //! runtextmacro Struct("FromSpotToUnit")
        //! runtextmacro GetKeyArray("KEY")
        //! runtextmacro GetKeyArray("KEY_ARRAY")
        static Event PARENT_STOP_EVENT
        static Event TARGET_DESTROY_EVENT
        //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "2")
        static Timer UPDATE_TIMER

        Lightning parent
        real sourceX
        real sourceY
        real sourceZ
        Unit target
        real targetX
        real targetY
        real targetZ

        timerMethod Update
            local integer iteration = thistype.ALL_COUNT

            loop
                local thistype this = thistype.ALL[iteration]

                local Unit target = this.target

	            local real targetX
	            local real targetY
	            local real targetZ

                if (target == NULL) then
                    set targetX = this.targetX
                    set targetY = this.targetY
                    set targetZ = this.targetZ
                else
                    set targetX = target.Position.X.Get()
                    set targetY = target.Position.Y.Get()
                    set targetZ = target.Position.Z.GetByCoords(targetX, targetY) + target.Impact.Z.Get(true)
                endif

                call this.parent.Move(this.sourceX, this.sourceY, this.sourceZ, targetX, targetY, targetZ)

                set iteration = iteration - 1
                exitwhen (iteration < ARRAY_MIN)
            endloop
        endmethod

        method Ending takes Lightning parent, Unit target returns nothing
            call this.deallocate()
            call parent.Data.Integer.Remove(KEY)
            call parent.Event.Remove(PARENT_STOP_EVENT)
            if target.Data.Integer.Table.Remove(KEY_ARRAY, this) then
                call target.Event.Remove(TARGET_DESTROY_EVENT)
                call target.Refs.Subtract()
            endif
            if this.RemoveFromList() then
                call thistype.UPDATE_TIMER.Pause()
            endif
        endmethod

        eventMethod Event_Parent_Stop
            local Lightning parent = params.Lightning.GetTrigger()

            local thistype this = parent.Data.Integer.Get(KEY)

            call this.Ending(parent, this.target)
        endmethod

        eventMethod Event_Target_Destroy
            local Unit target = params.Unit.GetTrigger()

            local integer iteration = target.Data.Integer.Table.Count(KEY_ARRAY)

            loop
                local thistype this = target.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                call this.Ending(this.parent, target)

                call parent.Destroy()

                set iteration = iteration - 1
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
            endloop
        endmethod

        method Start takes real sourceX, real sourceY, real sourceZ, Unit target returns nothing
            local Lightning parent = this

            local real targetX = target.Position.X.Get()
            local real targetY = target.Position.Y.Get()

            call parent.Start()

            set this = thistype.allocate()

            set this.parent = parent
            set this.sourceX = sourceX
            set this.sourceY = sourceY
            set this.sourceZ = sourceZ
            set this.target = target
            call parent.Data.Integer.Set(KEY, this)
            call parent.Event.Add(PARENT_STOP_EVENT)
            if target.Data.Integer.Table.Add(KEY_ARRAY, this) then
                call target.Event.Add(TARGET_DESTROY_EVENT)
                call target.Refs.Add()
            endif

            call parent.Move(sourceX, sourceY, sourceZ, targetX, targetY, target.Position.Z.GetByCoords(targetX, targetY) + target.Impact.Z.Get(true))

            if this.AddToList() then
                call thistype.UPDATE_TIMER.Start(UPDATE_TIME, true, function thistype.Update)
            endif
        endmethod

        static method Init takes nothing returns nothing
            set thistype.PARENT_STOP_EVENT = Event.Create(Lightning.STOP_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Parent_Stop)
            set thistype.TARGET_DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Target_Destroy)
            set thistype.UPDATE_TIMER = Timer.Create()
        endmethod
    endstruct

    //! runtextmacro Struct("FromUnitToUnit")
        //! runtextmacro GetKey("KEY")
        //! runtextmacro GetKeyArray("KEY_ARRAY")
        static Event PARENT_STOP_EVENT
        static Event POST_DESTROY_EVENT
        //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "2")
        static Timer UPDATE_TIMER

        Lightning parent
        Unit source
        real sourceX
        real sourceY
        real sourceZ
        Unit target
        real targetX
        real targetY
        real targetZ

        timerMethod Update
            local integer iteration = thistype.ALL_COUNT

            loop
                local thistype this = thistype.ALL[iteration]

                local Unit source = this.source
                local Unit target = this.target

	            local real sourceX
	            local real sourceY
	            local real sourceZ

                if (source == NULL) then
                    set sourceX = this.sourceX
                    set sourceY = this.sourceY
                    set sourceZ = this.sourceZ
                else
                    set sourceX = source.Position.X.Get()
                    set sourceY = source.Position.Y.Get()

                    set sourceZ = source.Position.Z.GetByCoords(sourceX, sourceY) + source.Outpact.Z.Get(true)
                endif

	            local real targetX
	            local real targetY
	            local real targetZ

                if (target == NULL) then
                    set targetX = this.targetX
                    set targetY = this.targetY
                    set targetZ = this.targetZ
                else
                    set targetX = target.Position.X.Get()
                    set targetY = target.Position.Y.Get()

                    set targetZ = target.Position.Z.GetByCoords(targetX, targetY) + target.Impact.Z.Get(true)
                endif

                call this.parent.Move(sourceX, sourceY, sourceZ, targetX, targetY, targetZ)

                set iteration = iteration - 1
                exitwhen (iteration < ARRAY_MIN)
            endloop
        endmethod

        method PostEnding takes Unit post returns nothing
            if post.Data.Integer.Table.Remove(KEY_ARRAY, this) then
                call post.Event.Remove(POST_DESTROY_EVENT)
                call post.Refs.Subtract()
            endif
        endmethod

        method Ending takes Lightning parent, Unit source, Unit target returns nothing
            call this.deallocate()
            call parent.Data.Integer.Remove(KEY)
            call parent.Event.Remove(PARENT_STOP_EVENT)
            if (source != NULL) then
                call this.PostEnding(source)
            endif
            if (target != NULL) then
                call this.PostEnding(target)
            endif
            if this.RemoveFromList() then
                call thistype.UPDATE_TIMER.Pause()
            endif
        endmethod

        eventMethod Event_Parent_Stop
            local Lightning parent = params.Lightning.GetTrigger()

            local thistype this = parent.Data.Integer.Get(KEY)

            call this.Ending(parent, this.source, this.target)
        endmethod

        eventMethod Event_Post_Destroy
            local Unit post = params.Unit.GetTrigger()

            local integer iteration = post.Data.Integer.Table.Count(KEY_ARRAY)

            loop
                local thistype this = post.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                if (post == this.source) then
                    if (this.target == NULL) then
                        call this.Ending(this.parent, post, NULL)

                        call parent.Destroy()
                    else
                        call this.PostEnding(post)

                        set this.source = NULL
                        set this.sourceX = post.Position.X.Get()
                        set this.sourceY = post.Position.Y.Get()
                        set this.sourceZ = post.Position.Z.Get() + post.Outpact.Z.Get(true)
                    endif
                else
                    if (this.source == NULL) then
                        call this.Ending(this.parent, NULL, post)

                        call parent.Destroy()
                    else
                        call this.PostEnding(post)

                        set this.target = NULL
                        set this.targetX = post.Position.X.Get()
                        set this.targetY = post.Position.Y.Get()
                        set this.targetZ = post.Position.Z.Get() + post.Impact.Z.Get(true)
                    endif
                endif

                set iteration = iteration - 1
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
            endloop
        endmethod

        method Start takes Unit source, Unit target returns nothing
            local Lightning parent = this

			if (source == target) then
				return
			endif

            local real sourceX = source.Position.X.Get()
            local real sourceY = source.Position.Y.Get()
            local real targetX = target.Position.X.Get()
            local real targetY = target.Position.Y.Get()

            call parent.Start()

            set this = thistype.allocate()

            set this.parent = parent
            set this.source = source
            set this.target = target
            call parent.Data.Integer.Set(KEY, this)
            call parent.Event.Add(PARENT_STOP_EVENT)
            if source.Data.Integer.Table.Add(KEY_ARRAY, this) then
                call source.Event.Add(POST_DESTROY_EVENT)
                call source.Refs.Add()
            endif
            if target.Data.Integer.Table.Add(KEY_ARRAY, this) then
                call target.Event.Add(POST_DESTROY_EVENT)
                call target.Refs.Add()
            endif

            call parent.Move(source.Position.X.Get(), source.Position.Y.Get(), source.Position.Z.GetByCoords(sourceX, sourceY) + source.Outpact.Z.Get(true), targetX, targetY, target.Position.Z.GetByCoords(targetX, targetY) + target.Impact.Z.Get(true))

            if this.AddToList() then
                call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.Update)
            endif
        endmethod

        static method Init takes nothing returns nothing
            set thistype.PARENT_STOP_EVENT = Event.Create(Lightning.STOP_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Parent_Stop)
            set thistype.POST_DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Post_Destroy)
            set thistype.UPDATE_TIMER = Timer.Create()
        endmethod
    endstruct

    //! runtextmacro Struct("DestroyTimed")
        static Event DESTROY_EVENT
        //! runtextmacro GetKey("KEY")

        Timer durationTimer
        Lightning parent

        method Ending takes Timer durationTimer, Lightning parent returns nothing
            call this.deallocate()
            call durationTimer.Destroy()
            call parent.Data.Integer.Remove(KEY)
            call parent.Event.Remove(DESTROY_EVENT)
        endmethod

        timerMethod EndingByTimer
            local Timer durationTimer = Timer.GetExpired()

            local thistype this = durationTimer.GetData()

            local Lightning parent = this.parent

            call this.Ending(durationTimer, parent)

            call parent.Destroy()
        endmethod

        eventMethod Event_Destroy
            local Lightning parent = params.Lightning.GetTrigger()

            local thistype this = parent.Data.Integer.Get(KEY)

            call this.Ending(this.durationTimer, parent)
        endmethod

        method Start takes real duration returns nothing
            local Lightning parent = this

            set this = parent.Data.Integer.Get(KEY)

            if (this != NULL) then
                call this.Ending(this.durationTimer, parent)
            endif

            set this = thistype.allocate()

			local Timer durationTimer = Timer.Create()

            set this.durationTimer = durationTimer
            set this.parent = parent
            call durationTimer.SetData(this)
            call parent.Data.Integer.Set(KEY, this)
            call parent.Event.Add(DESTROY_EVENT)

            call durationTimer.Start(duration, false, function thistype.EndingByTimer)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DESTROY_EVENT = Event.Create(Lightning.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Lightning", "LIGHTNING")
    static real FADE_OUT_DURATION = 0.35
    static EventType DESTROY_EVENT_TYPE
    static EventType STOP_EVENT_TYPE
    static thistype TEMP

    //! runtextmacro LinkToStruct("Lightning", "Color")
    //! runtextmacro LinkToStruct("Lightning", "Data")
    //! runtextmacro LinkToStruct("Lightning", "DestroyTimed")
    //! runtextmacro LinkToStruct("Lightning", "Event")
    //! runtextmacro LinkToStruct("Lightning", "FromDummyUnitToUnit")
    //! runtextmacro LinkToStruct("Lightning", "FromSpotToDummyUnit")
    //! runtextmacro LinkToStruct("Lightning", "FromSpotToSpot")
    //! runtextmacro LinkToStruct("Lightning", "FromSpotToUnit")
    //! runtextmacro LinkToStruct("Lightning", "FromUnitToUnit")
    //! runtextmacro LinkToStruct("Lightning", "Id")

    //! runtextmacro CreateAnyFlagState("hiddenInFog", "HiddenInFog")
    //! runtextmacro CreateAnyState("self", "Self", "lightning")

    boolean moving

    method SetColor takes integer red, integer green, integer blue, integer alpha returns nothing
        call SetLightningColor(this.self, red / 255., green / 255., blue / 255., alpha / 255.)
    endmethod

    method Stop_TriggerEvents takes nothing returns nothing
        local EventResponse params = EventResponse.Create(this.Id.Get())

        call params.Lightning.SetTrigger(this)

		local integer iteration = EventPriority.ALL_COUNT

        loop
            exitwhen (iteration < ARRAY_MIN)

            local EventPriority priority = EventPriority.ALL[iteration]

            local integer iteration2 = this.Event.Count(thistype.STOP_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call this.Event.Get(thistype.STOP_EVENT_TYPE, priority, iteration2).Run(params)

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration - 1
        endloop

        call params.Destroy()
    endmethod

    method Stop takes nothing returns nothing
        if this.moving then
            set this.moving = false

            call this.Stop_TriggerEvents()
        endif
    endmethod

    method Start takes nothing returns nothing
        if this.moving then
            call this.Stop()
        endif

        set this.moving = true
    endmethod

    method Destroy_TriggerEvents takes nothing returns nothing
        local EventResponse params = EventResponse.Create(this.Id.Get())

        call params.Lightning.SetTrigger(this)

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

    timerMethod CleanUp
        local Timer cleanUpTimer = Timer.GetExpired()

        local thistype this = cleanUpTimer.GetData()

        local lightning self = this.self

        call cleanUpTimer.Destroy()

        call this.deallocate()

        call DestroyLightning(self)

        set self = null
    endmethod

    method Destroy takes nothing returns nothing
        call this.Stop()

        local Timer cleanUpTimer = Timer.Create()

        call cleanUpTimer.SetData(this)

        call this.Destroy_TriggerEvents()

        call this.Color.Timed.Subtract(0., 0., 0., this.Color.Alpha.Get(), thistype.FADE_OUT_DURATION)

        call cleanUpTimer.Start(thistype.FADE_OUT_DURATION, false, function thistype.CleanUp)
    endmethod

    method Move takes real x, real y, real z, real x2, real y2, real z2 returns nothing
        call MoveLightningEx(this.self, this.hiddenInFog, x, y, z, x2, y2, z2)
    endmethod

    static method Create takes LightningType whichType returns thistype
        local thistype this = thistype.allocate()

		local lightning self = AddLightningEx(whichType.GetSelf(), false, 0., 0., 0., 0., 0., 0.)

        set this.hiddenInFog = true
        set this.moving = false
        set this.self = self

        call this.Id.Event_Create()

        call this.Color.Event_Create()

        return this
    endmethod

    static method CreatePrimarySecondary takes boolean takePrimary, LightningType primary, LightningType secondary returns thistype
        if takePrimary then
            return thistype.Create(primary)
        endif

        return thistype.Create(secondary)
    endmethod

    initMethod Init of Header_7
        call LightningType.Init()

        set thistype.DESTROY_EVENT_TYPE = EventType.Create()
        set thistype.STOP_EVENT_TYPE = EventType.Create()

        call thistype(NULL).Color.Init()
        call thistype(NULL).DestroyTimed.Init()
        call thistype(NULL).FromDummyUnitToUnit.Init()
        call thistype(NULL).FromSpotToDummyUnit.Init()
        call thistype(NULL).FromSpotToSpot.Init()
        call thistype(NULL).FromSpotToUnit.Init()
        call thistype(NULL).FromUnitToUnit.Init()
    endmethod
endstruct