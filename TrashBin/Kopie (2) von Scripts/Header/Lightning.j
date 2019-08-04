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
        //! runtextmacro CreateAnyStaticStateDefault("TRIGGER", "Trigger", "Lightning", "NULL")

        //! runtextmacro Event_Implement("Lightning")
    endstruct

    //! runtextmacro Struct("FromDummyUnitToUnit")
        //! runtextmacro GetKeyArray("KEY")
        //! runtextmacro GetKeyArray("KEY_ARRAY")
        static Event PARENT_DESTROY_EVENT
        static Event SOURCE_DESTROY_EVENT
        static Event TARGET_DEATH_EVENT
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

        method SourceEnding takes DummyUnit source returns nothing
            if (source.Data.Integer.Table.Remove(KEY_ARRAY, this)) then
                call source.Event.Remove(SOURCE_DESTROY_EVENT)
            endif
        endmethod

        method TargetEnding takes Unit target returns nothing
            if (target.Data.Integer.Table.Remove(KEY_ARRAY, this)) then
                call target.Event.Remove(TARGET_DEATH_EVENT)
                call target.Refs.Subtract()
            endif
        endmethod

        method Ending takes Lightning parent, DummyUnit source, Unit target returns nothing
            call this.deallocate()
            call parent.Data.Integer.Remove(KEY)
            call parent.Event.Remove(PARENT_DESTROY_EVENT)
            if (source != NULL) then
                call this.SourceEnding(source)
            endif
            if (target != NULL) then
                call this.TargetEnding(target)
            endif
            if (this.RemoveFromList()) then
                call thistype.UPDATE_TIMER.Pause()
            endif
        endmethod

        static method Event_Parent_Destroy takes nothing returns nothing
            local Lightning parent = LIGHTNING.Event.GetTrigger()

            local thistype this = parent.Data.Integer.Get(KEY)

            call this.Ending(parent, this.source, this.target)
        endmethod

        static method Event_Source_Destroy takes nothing returns nothing
            local DummyUnit source = DUMMY_UNIT.Event.GetTrigger()
            local thistype this

            local integer iteration = source.Data.Integer.Table.Count(KEY_ARRAY)

            loop
                set this = source.Data.Integer.Table.Get(KEY_ARRAY, iteration)

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

        static method Event_Target_Death takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()
            local real targetX
            local real targetY
            local thistype this

            local integer iteration = target.Data.Integer.Table.Count(KEY_ARRAY)

            loop
                set this = target.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                if (this.source == NULL) then
                    call this.Ending(this.parent, NULL, target)

                    call parent.Destroy()
                else
                    set targetX = target.Position.X.Get()
                    set targetY = target.Position.Y.Get()
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

        static method Update takes nothing returns nothing
            local integer iteration = thistype.ALL_COUNT
            local DummyUnit source
            local real sourceX
            local real sourceY
            local real sourceZ
            local Unit target
            local real targetX
            local real targetY
            local real targetZ
            local thistype this

            loop
                set this = thistype.ALL[iteration]

                set source = this.source
                set target = this.target

                if (source == NULL) then
                    set sourceX = this.sourceX
                    set sourceY = this.sourceY
                    set sourceZ = this.sourceZ
                else
                    set sourceX = source.Position.X.Get()
                    set sourceY = source.Position.Y.Get()
                    set sourceZ = source.Position.Z.Get() + this.sourceZOffset
                endif
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

        method Start takes DummyUnit source, real sourceZOffset, Unit target returns nothing
            local Lightning parent = this
            local real targetX = target.Position.X.Get()
            local real targetY = target.Position.Y.Get()

            set this = thistype.allocate()
            set this.parent = parent
            set this.source = source
            set this.sourceZOffset = sourceZOffset
            set this.target = target
            call parent.Data.Integer.Set(KEY, this)
            call parent.Event.Add(PARENT_DESTROY_EVENT)
            call parent.Move(source.Position.X.Get(), source.Position.Y.Get(), source.Position.Z.Get() + sourceZOffset, targetX, targetY, target.Position.Z.GetByCoords(targetX, targetY) + target.Impact.Z.Get(true))
            if (source.Data.Integer.Table.Add(KEY_ARRAY, this)) then
                call source.Event.Add(SOURCE_DESTROY_EVENT)
            endif
            if (target.Data.Integer.Table.Add(KEY_ARRAY, this)) then
                call target.Event.Add(TARGET_DEATH_EVENT)
                call target.Refs.Add()
            endif

            if (this.AddToList()) then
                call UPDATE_TIMER.Start(UPDATE_TIME, true, function thistype.Update)
            endif
        endmethod

        static method Init takes nothing returns nothing
            set thistype.PARENT_DESTROY_EVENT = Event.Create(Lightning.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Parent_Destroy)
            set thistype.SOURCE_DESTROY_EVENT = Event.Create(DummyUnit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Source_Destroy)
            set thistype.TARGET_DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Target_Death)
            set thistype.UPDATE_TIMER = Timer.Create()
        endmethod
    endstruct

    //! runtextmacro Struct("FromSpotToUnit")
        //! runtextmacro GetKeyArray("KEY")
        //! runtextmacro GetKeyArray("KEY_ARRAY")
        static Event PARENT_DESTROY_EVENT
        static Event TARGET_DEATH_EVENT
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

        method Ending takes Lightning parent, Unit target returns nothing
            call this.deallocate()
            call parent.Data.Integer.Remove(KEY)
            call parent.Event.Remove(PARENT_DESTROY_EVENT)
            if (target.Data.Integer.Table.Remove(KEY_ARRAY, this)) then
                call target.Event.Remove(TARGET_DEATH_EVENT)
                call target.Refs.Subtract()
            endif
            if (this.RemoveFromList()) then
                call thistype.UPDATE_TIMER.Pause()
            endif
        endmethod

        static method Event_Parent_Destroy takes nothing returns nothing
            local Lightning parent = LIGHTNING.Event.GetTrigger()

            local thistype this = parent.Data.Integer.Get(KEY)

            call this.Ending(parent, this.target)
        endmethod

        static method Event_Target_Death takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()
            local real targetX
            local real targetY
            local thistype this

            local integer iteration = target.Data.Integer.Table.Count(KEY_ARRAY)

            loop
                set this = target.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                call this.Ending(this.parent, target)

                call parent.Destroy()

                set iteration = iteration - 1
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
            endloop
        endmethod

        static method Update takes nothing returns nothing
            local integer iteration = thistype.ALL_COUNT
            local Unit target
            local real targetX
            local real targetY
            local real targetZ
            local thistype this

            loop
                set this = thistype.ALL[iteration]

                set target = this.target

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

        method Start takes real sourceX, real sourceY, real sourceZ, Unit target returns nothing
            local Lightning parent = this
            local real targetX = target.Position.X.Get()
            local real targetY = target.Position.Y.Get()

            set this = thistype.allocate()
            set this.parent = parent
            set this.sourceX = sourceX
            set this.sourceY = sourceY
            set this.sourceZ = sourceZ
            set this.target = target
            call parent.Data.Integer.Set(KEY, this)
            call parent.Event.Add(PARENT_DESTROY_EVENT)
            call parent.Move(sourceX, sourceY, sourceZ, targetX, targetY, target.Position.Z.GetByCoords(targetX, targetY) + target.Impact.Z.Get(true))
            if (target.Data.Integer.Table.Add(KEY_ARRAY, this)) then
                call target.Event.Add(TARGET_DEATH_EVENT)
                call target.Refs.Add()
            endif

            if (this.AddToList()) then
                call thistype.UPDATE_TIMER.Start(UPDATE_TIME, true, function thistype.Update)
            endif
        endmethod

        static method Init takes nothing returns nothing
            set thistype.PARENT_DESTROY_EVENT = Event.Create(Lightning.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Parent_Destroy)
            set thistype.TARGET_DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Target_Death)
            set thistype.UPDATE_TIMER = Timer.Create()
        endmethod
    endstruct

    //! runtextmacro Struct("FromUnitToUnit")
        //! runtextmacro GetKey("KEY")
        //! runtextmacro GetKeyArray("KEY_ARRAY")
        static Event PARENT_DESTROY_EVENT
        static Event POST_DEATH_EVENT
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

        method PostEnding takes Unit post returns nothing
            if (post.Data.Integer.Table.Remove(KEY_ARRAY, this)) then
                call post.Event.Remove(POST_DEATH_EVENT)
                call post.Refs.Subtract()
            endif
        endmethod

        method Ending takes Lightning parent, Unit source, Unit target returns nothing
            call this.deallocate()
            call parent.Data.Integer.Remove(KEY)
            call parent.Event.Remove(PARENT_DESTROY_EVENT)
            if (source != NULL) then
                call this.PostEnding(source)
            endif
            if (target != NULL) then
                call this.PostEnding(target)
            endif
            if (this.RemoveFromList()) then
                call thistype.UPDATE_TIMER.Pause()
            endif
        endmethod

        static method Event_Parent_Destroy takes nothing returns nothing
            local Lightning parent = LIGHTNING.Event.GetTrigger()

            local thistype this = parent.Data.Integer.Get(KEY)

            call this.Ending(parent, this.source, this.target)
        endmethod

        static method Event_Post_Death takes nothing returns nothing
            local Unit post = UNIT.Event.GetTrigger()
            local thistype this

            local integer iteration = post.Data.Integer.Table.Count(KEY_ARRAY)

            loop
                set this = post.Data.Integer.Table.Get(KEY_ARRAY, iteration)

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

        static method Update takes nothing returns nothing
            local integer iteration = thistype.ALL_COUNT
            local Unit source
            local real sourceX
            local real sourceY
            local real sourceZ
            local Unit target
            local real targetX
            local real targetY
            local real targetZ
            local thistype this

            loop
                set this = thistype.ALL[iteration]

                set source = this.source
                set target = this.target

                if (source == NULL) then
                    set sourceX = this.sourceX
                    set sourceY = this.sourceY
                    set sourceZ = this.sourceZ
                else
                    set sourceX = source.Position.X.Get()
                    set sourceY = source.Position.Y.Get()

                    set sourceZ = source.Position.Z.GetByCoords(sourceX, sourceY) + source.Outpact.Z.Get(true)
                endif
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

        method Start takes Unit source, Unit target returns nothing
            local Lightning parent = this
            local real sourceX = source.Position.X.Get()
            local real sourceY = source.Position.Y.Get()
            local real targetX = target.Position.X.Get()
            local real targetY = target.Position.Y.Get()

            set this = thistype.allocate()
            set this.parent = parent
            set this.source = source
            set this.target = target
            call parent.Data.Integer.Set(KEY, this)
            call parent.Event.Add(PARENT_DESTROY_EVENT)
            call parent.Move(source.Position.X.Get(), source.Position.Y.Get(), source.Position.Z.GetByCoords(sourceX, sourceY) + source.Outpact.Z.Get(true), targetX, targetY, target.Position.Z.GetByCoords(targetX, targetY) + target.Impact.Z.Get(true))
            if (source.Data.Integer.Table.Add(KEY_ARRAY, this)) then
                call source.Event.Add(POST_DEATH_EVENT)
                call source.Refs.Add()
            endif
            if (target.Data.Integer.Table.Add(KEY_ARRAY, this)) then
                call target.Event.Add(POST_DEATH_EVENT)
                call target.Refs.Add()
            endif

            if (this.AddToList()) then
                call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.Update)
            endif
        endmethod

        static method Init takes nothing returns nothing
            set thistype.PARENT_DESTROY_EVENT = Event.Create(Lightning.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Parent_Destroy)
            set thistype.POST_DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Post_Death)
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

        static method EndingByTimer takes nothing returns nothing
            local Timer durationTimer = Timer.GetExpired()

            local thistype this = durationTimer.GetData()

            local Lightning parent = this.parent

            call this.Ending(durationTimer, parent)

            call parent.Destroy()
        endmethod

        static method Event_Destroy takes nothing returns nothing
            local Lightning parent = LIGHTNING.Event.GetTrigger()

            local thistype this = parent.Data.Integer.Get(KEY)

            call this.Ending(this.durationTimer, parent)
        endmethod

        method Start takes real duration returns nothing
            local Timer durationTimer = Timer.Create()
            local Lightning parent = this

            set this = parent.Data.Integer.Get(KEY)

            if (this != NULL) then
                call this.Ending(this.durationTimer, parent)
            endif

            set this = thistype.allocate()

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
    static EventType DESTROY_EVENT_TYPE
    static thistype TEMP

    //! runtextmacro LinkToStruct("Lightning", "Data")
    //! runtextmacro LinkToStruct("Lightning", "DestroyTimed")
    //! runtextmacro LinkToStruct("Lightning", "Event")
    //! runtextmacro LinkToStruct("Lightning", "FromDummyUnitToUnit")
    //! runtextmacro LinkToStruct("Lightning", "FromSpotToUnit")
    //! runtextmacro LinkToStruct("Lightning", "FromUnitToUnit")
    //! runtextmacro LinkToStruct("Lightning", "Id")

    //! runtextmacro CreateAnyFlagState("hiddenInFog", "HiddenInFog")
    //! runtextmacro CreateAnyState("self", "Self", "lightning")

    method SetColor takes integer red, integer green, integer blue, integer alpha returns nothing
        call SetLightningColor(this.self, red / 255., green / 255., blue / 255., alpha / 255.)
    endmethod

    method Destroy_TriggerEvents takes nothing returns nothing
        local integer iteration = EventPriority.ALL_COUNT
        local integer iteration2
        local EventPriority priority

        loop
            exitwhen (iteration < ARRAY_MIN)

            set priority = EventPriority.ALL[iteration]

            set iteration2 = this.Event.Count(thistype.DESTROY_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call LIGHTNING.Event.SetTrigger(this)
                call this.Event.Get(thistype.DESTROY_EVENT_TYPE, priority, iteration2).Run()

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration - 1
        endloop
    endmethod

    method Destroy takes nothing returns nothing
        local lightning self = this.self

        call this.Destroy_TriggerEvents()

        call this.deallocate()
        call DestroyLightning(self)

        set self = null
    endmethod

    method Move takes real x, real y, real z, real x2, real y2, real z2 returns nothing
        call MoveLightningEx(this.self, this.hiddenInFog, x, y, z, x2, y2, z2)
    endmethod

    static method Create takes string codeName returns thistype
        local lightning self = AddLightningEx(codeName, false, 0., 0., 0., 0., 0., 0.)
        local thistype this = thistype.allocate()

        set this.hiddenInFog = true
        set this.self = self

        call this.Id.Event_Create()

        return this
    endmethod

    static method Init takes nothing returns nothing
        set thistype.DESTROY_EVENT_TYPE = EventType.Create()

        call thistype(NULL).DestroyTimed.Init()
        call thistype(NULL).FromDummyUnitToUnit.Init()
        call thistype(NULL).FromSpotToUnit.Init()
        call thistype(NULL).FromUnitToUnit.Init()
    endmethod
endstruct