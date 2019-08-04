//! runtextmacro Folder("MissileCheckpoint")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Struct("Boolean")
            //! runtextmacro Data_Type_Implement("MissileCheckpoint", "Boolean", "boolean")
        endstruct

        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("MissileCheckpoint", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("MissileCheckpoint", "Integer", "integer")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Boolean")
        //! runtextmacro LinkToStruct("Data", "Integer")

        //! runtextmacro Data_Implement("MissileCheckpoint")
    endstruct
endscope

//! runtextmacro BaseStruct("MissileCheckpoint", "MISSILE_CHECKPOINT")
    //! runtextmacro LinkToStruct("MissileCheckpoint", "Data")
    //! runtextmacro LinkToStruct("MissileCheckpoint", "Id")

    //! runtextmacro CreateAnyState("x", "X", "real")
    //! runtextmacro CreateAnyState("y", "Y", "real")
    //! runtextmacro CreateAnyState("z", "Z", "real")

    method Destroy takes nothing returns nothing
        call this.deallocate()
    endmethod

    static method Create takes real x, real y, real z returns thistype
        local thistype this = thistype.allocate()

        call this.Id.Event_Create()

        call this.SetX(x)
        call this.SetY(y)
        call this.SetZ(z)

        return this
    endmethod
endstruct

//! runtextmacro Folder("Missile")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Struct("Boolean")
            //! runtextmacro Data_Type_Implement("Missile", "Boolean", "boolean")
        endstruct

        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("Missile", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("Missile", "Integer", "integer")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Boolean")
        //! runtextmacro LinkToStruct("Data", "Integer")

        //! runtextmacro Data_Implement("Missile")
    endstruct

    //! runtextmacro Struct("Event")
        //! runtextmacro Event_Implement("Missile")
    endstruct

    //! runtextmacro Struct("Arc")
        real acceleration
        real distance
        real duration
        real speed
        real startX
        real startY

        //! runtextmacro CreateSimpleAddState_NotStart("real")

        method GetHeight takes nothing returns real
            local real distance = Math.DistanceByDeltas(Missile(this).GetTargetX() - this.startX, Missile(this).GetTargetY() - this.startY)

            if (distance == 0.) then
                return 0.
            endif

            local real duration = this.duration

            if (duration == 0.) then
                return 0.
            endif

            local real distFactor = Math.Limit(Math.DistanceByDeltas(Missile(this).Position.X.Get() - this.startX, Missile(this).Position.Y.Get() - this.startY) / distance, 0, 1)

            local real time = (1 - distFactor) * duration

            return ((this.acceleration / 2) * time * time + this.speed * time)
        endmethod

        method SetByPerc takes real value returns nothing
            call this.Set(Math.QUARTER_ANGLE * value)
        endmethod

        method Start takes nothing returns nothing
            local real distance = Missile(this).GetTargetDistanceXY()
            local real speed = Missile(this).Speed.GetX()

            local real duration = Math.GetMovementDuration(distance, speed, Missile(this).Acceleration.GetX())

            if (duration == 0.) then
                set this.acceleration = 0.
                set this.distance = 0.
                set this.duration = 0.
                set this.speed = 0.
                set this.startX = Missile(this).Position.X.Get()
                set this.startY = Missile(this).Position.Y.Get()

                return
            endif

            set this.distance = distance

            set distance = distance * Math.Tan(this.Get())

            set speed = distance / duration
//call DebugEx("height "+R2S(distance)+";"+R2S(this.Get())+";"+R2S(Math.Tan(this.Get())))
            local real acceleration = -2 * speed / duration

            set this.acceleration = acceleration
            set this.duration = duration
            set this.speed = speed
            set this.startX = Missile(this).Position.X.Get()
            set this.startY = Missile(this).Position.Y.Get()
        endmethod

        method Event_Create takes nothing returns nothing
            set this.acceleration = 0.
            set this.distance = 0.
            set this.duration = 0.
            set this.speed = 0.
            call this.Set(0.)
        endmethod
    endstruct

    //! runtextmacro Struct("Impact")
        Trigger action

        //! runtextmacro CreateAnyState("filter", "Filter", "BoolExpr")

        method Do takes real x, real y, real z returns nothing
            local BoolExpr filter = this.filter
            local EventResponse params = EventResponse.Create(Missile(this).Id.Get())

            set this.filter = NULL

            call Missile(this).Position.Set(x, y, z)

            set this.filter = filter

            call params.Missile.SetTrigger(this)
            call params.Unit.SetTrigger(NULL)

            call EventResponse.SetTrigger(params)

            call this.action.Run()

            call params.Destroy()
        endmethod

		method DoCur takes nothing returns nothing
			call this.Do(Missile(this).Position.X.Get(), Missile(this).Position.Y.Get(), Missile(this).Position.Z.Get())
		endmethod

        method DoOnUnit takes Unit target returns nothing
            local BoolExpr filter = this.filter
            local EventResponse params = EventResponse.Create(Missile(this).Id.Get())

            set this.filter = NULL

            call Missile(this).Position.SetToUnit(target)

            set this.filter = filter

            call params.Missile.SetTrigger(this)
            call params.Unit.SetTrigger(target)

            call EventResponse.SetTrigger(params)

            call this.action.Run()

            call params.Destroy()
        endmethod

        method SetAction takes code actionFunction returns nothing
            set this.action = Trigger.GetFromCode(actionFunction)
        endmethod

        method Event_Create takes nothing returns nothing
            set this.action = NULL
            set this.filter = NULL
        endmethod
    endstruct

    //! runtextmacro Struct("CollisionSize")
        //! runtextmacro CreateSimpleAddState("real", "0.")
    endstruct

    //! runtextmacro Struct("DummyUnit")
        static Event DESTROY_EVENT
        static Event PARENT_DESTROY_EVENT
        //! runtextmacro GetKey("KEY")

        boolean facingLocked
        real facing

        //! runtextmacro CreateSimpleAddState_OnlyGet("DummyUnit")

        method Set takes DummyUnit value returns nothing
            local DummyUnit oldValue = this.Get()

            if (oldValue != NULL) then
                call oldValue.Data.Integer.Remove(KEY)
                call oldValue.Event.Remove(DESTROY_EVENT)
                call Missile(this).Event.Remove(PARENT_DESTROY_EVENT)
            endif

            set this.value = value
            if (value != NULL) then
                call Missile(this).Event.Add(PARENT_DESTROY_EVENT)
                call value.Data.Integer.Set(KEY, this)
                call value.Event.Add(DESTROY_EVENT)
            endif
        endmethod

        eventMethod Event_Destroy
            local DummyUnit value = params.DummyUnit.GetTrigger()

            local thistype this = value.Data.Integer.Get(KEY)

            call this.Set(NULL)
        endmethod

        eventMethod Event_ParentDestroy
            local Missile parent = params.Missile.GetTrigger()

            local thistype this = parent

            local DummyUnit value = this.Get()

            call this.Set(NULL)

            call value.Destroy()
        endmethod

        method Update takes nothing returns nothing
            local DummyUnit val = this.Get()

            if (val != NULL) then
                if this.facingLocked then
                    //call val.Facing.Set(this.facing)
                else
                    call val.Facing.Set(Missile(this).Angle.GetXY())
                endif
            endif
        endmethod

        method LockFacing takes real val returns nothing
            set this.facing = val
            set this.facingLocked = true

            call this.Update()
        endmethod

        method Create takes integer id, real scale returns DummyUnit
            local real facing

            if this.facingLocked then
                set facing = this.facing
            else
                set facing = Missile(this).Angle.GetXY()
            endif

            local DummyUnit value = DummyUnit.Create(id, Missile(this).Position.X.Get(), Missile(this).Position.Y.Get(), Missile(this).Position.Z.Get(), facing)

            call this.Set(value)

            call value.Scale.Set(scale)

            return value
        endmethod

        method CreateWithAngle takes integer id, real scale, real facing returns DummyUnit
            local DummyUnit value = DummyUnit.Create(id, Missile(this).Position.X.Get(), Missile(this).Position.Y.Get(), Missile(this).Position.Z.Get(), facing)

            call this.Set(value)

            call value.Scale.Set(scale)

            return value
        endmethod

        method Event_Create takes nothing returns nothing
            set this.facingLocked = false
            set this.value = NULL
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DESTROY_EVENT = Event.Create(DummyUnit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
            set thistype.PARENT_DESTROY_EVENT = Event.Create(Missile.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_ParentDestroy)
        endmethod
    endstruct

    //! runtextmacro Struct("Angle")
        //! runtextmacro CreateAnyState("xPart", "XPart", "real")
        //! runtextmacro CreateAnyState("yPart", "YPart", "real")
        //! runtextmacro CreateAnyState("zPart", "ZPart", "real")

        method GetXY takes nothing returns real
            return Math.AtanByDeltas(this.GetYPart(), this.GetXPart())
        endmethod

        method Set takes real dX, real dY, real dZ returns nothing
            local real d = Math.DistanceByDeltasWithZ(dX, dY, dZ)

            call this.SetXPart(dX / d)
            call this.SetYPart(dY / d)
            call this.SetZPart(dZ / d)

            call Missile(this).DummyUnit.Update()
        endmethod

        method DirectToSpot takes real x, real y, real z returns nothing
            call this.Set(x - Missile(this).Position.X.Get(), y - Missile(this).Position.Y.Get(), z - Missile(this).Position.Z.Get())
        endmethod
    endstruct

    //! runtextmacro Folder("Position")
        //! runtextmacro Struct("X")
            //! runtextmacro CreateSimpleAddState("real", "0.")
        endstruct

        //! runtextmacro Struct("Y")
            //! runtextmacro CreateSimpleAddState("real", "0.")
        endstruct

        //! runtextmacro Struct("Z")
            //! runtextmacro CreateSimpleAddState("real", "0.")
        endstruct
    endscope

    //! runtextmacro Struct("Position")
        static Group ENUM_GROUP

        Trigger collisionAction
        BoolExpr collisionFilter

        //! runtextmacro LinkToStruct("Position", "X")
        //! runtextmacro LinkToStruct("Position", "Y")
        //! runtextmacro LinkToStruct("Position", "Z")

        method Set takes real x, real y, real z returns nothing
            local DummyUnit dummyUnit = Missile(this).DummyUnit.Get()
            local BoolExpr impactFilter = Missile(this).Impact.GetFilter()

            call this.X.Set(x)
            call this.Y.Set(y)
            call this.Z.Set(z)

            if (dummyUnit != NULL) then
                call dummyUnit.Position.Set(x, y, z + Missile(this).Arc.GetHeight())
            endif

			local Unit impactUnit
			local EventResponse params

            if (impactFilter != NULL) then
                set params = EventResponse.Create(EventResponse.DIRECT_SUBJECT_ID)

                call params.Missile.SetTrigger(this)

                call EventResponse.SetTrigger(params)

                call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, Missile(this).CollisionSize.Get(), impactFilter)

                call params.Destroy()

                set impactUnit = thistype.ENUM_GROUP.GetFirst()

                if (impactUnit != NULL) then
                    call Missile(this).Impact.DoOnUnit(impactUnit)
                endif
            endif

            if (this.collisionFilter != NULL) then
                set params = EventResponse.Create(EventResponse.DIRECT_SUBJECT_ID)

                call params.Missile.SetTrigger(this)

                call EventResponse.SetTrigger(params)

                call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, Missile(this).CollisionSize.Get(), this.collisionFilter)

                set impactUnit = thistype.ENUM_GROUP.FetchFirst()

                if (impactUnit != NULL) then
                    loop
                        call EventResponse.SetTrigger(params)
                        call params.Unit.SetTrigger(impactUnit)

                        call this.collisionAction.Run()

                        set impactUnit = thistype.ENUM_GROUP.FetchFirst()
                        exitwhen (impactUnit == NULL)
                    endloop
                endif

                call params.Destroy()
            endif
        endmethod

        method Add takes real x, real y, real z returns nothing
            call this.Set(this.X.Get() + x, this.Y.Get() + y, this.Z.Get() + z)
        endmethod

        method AddCollision takes code actionFunction, BoolExpr filter returns nothing
            set this.collisionAction = Trigger.GetFromCode(actionFunction)
            set this.collisionFilter = filter
        endmethod

        method SetFromUnit takes Unit source returns nothing
            local real angle = source.Facing.Get()
            local real width = source.Outpact.X.Get(true)
            local real length = source.Outpact.Y.Get(true)

            local real x = source.Position.X.Get() + length * Math.Cos(angle) + width * Math.Cos(angle - Math.QUARTER_ANGLE)
            local real y = source.Position.Y.Get() + length * Math.Sin(angle) + width * Math.Sin(angle - Math.QUARTER_ANGLE)
            local real z = source.Position.Z.Get() + source.Outpact.Z.Get(true)

            call this.Set(x, y, z)
        endmethod

        method SetToUnitWithOffset takes Unit target, real offsetX, real offsetY, real offsetZ returns nothing
            call this.Set(target.Position.X.Get() + target.Impact.X.Get(true) + offsetX, target.Position.Y.Get() + target.Impact.Y.Get(true) + offsetY, target.Position.Z.Get() + target.Impact.Z.Get(true) + offsetZ)
        endmethod

        method SetToUnit takes Unit target returns nothing
            call this.SetToUnitWithOffset(target, 0., 0., 0.)
        endmethod

        method Event_Create takes nothing returns nothing
        	set this.collisionAction = NULL
        	set this.collisionFilter = NULL

            call this.X.Event_Create()
            call this.Y.Event_Create()
            call this.Z.Event_Create()
        endmethod

        static method Init takes nothing returns nothing
            set thistype.ENUM_GROUP = Group.Create()
        endmethod
    endstruct

    //! runtextmacro Struct("UpdateTime")
        //! runtextmacro CreateHumanEyeTime("VALUE", "1")
        
        method Get takes nothing returns real
        	return thistype.VALUE
        endmethod
    endstruct

    //! runtextmacro Struct("Acceleration")
        //! runtextmacro CreateAnyState("x", "X", "real")
        //! runtextmacro CreateAnyState("xAdd", "XAdd", "real")
        //! runtextmacro CreateAnyState("y", "Y", "real")
        //! runtextmacro CreateAnyState("yAdd", "YAdd", "real")
        //! runtextmacro CreateAnyState("z", "Z", "real")
        //! runtextmacro CreateAnyState("zAdd", "ZAdd", "real")

        //! runtextmacro CreateSimpleAddState_OnlyGet("real")

        method SetPolar takes real x, real y, real z returns nothing
            set this.x = x
            set this.xAdd = x * MISSILE.UpdateTime.VALUE
            set this.y = y
            set this.yAdd = y * MISSILE.UpdateTime.VALUE
            set this.z = z
            set this.zAdd = z * MISSILE.UpdateTime.VALUE
        endmethod

        method Set takes real value returns nothing
            set this.value = value
            call this.SetPolar(value, 0., 0.)
        endmethod

        method AddPolar takes real x, real y, real z returns nothing
            call this.SetPolar(this.GetX() + x, this.GetY() + y, this.GetZ() + z)
        endmethod

        method Add takes real value returns nothing
            call this.Set(this.GetX() + value)
        endmethod

        method Event_Create takes nothing returns nothing
            call this.Set(0.)
        endmethod
    endstruct

    //! runtextmacro Struct("Speed")
        //! runtextmacro CreateAnyState("x", "X", "real")
        //! runtextmacro CreateAnyState("xAdd", "XAdd", "real")
        //! runtextmacro CreateAnyState("y", "Y", "real")
        //! runtextmacro CreateAnyState("yAdd", "YAdd", "real")
        //! runtextmacro CreateAnyState("z", "Z", "real")
        //! runtextmacro CreateAnyState("zAdd", "ZAdd", "real")

        real min
        boolean minSet
        real minSquare

        //! runtextmacro CreateSimpleAddState_OnlyGet("real")

        method SetPolar takes real x, real y, real z returns nothing
        	local real d = Math.DistanceByDeltasWithZ(x, y, z)

            if this.minSet then
				local real min

                if (d > 0) then
                    if (d < this.min) then
                        set min = this.min

                        set x = x / d * min
                        set y = y / d * min
                        set z = z / d * min
                    endif
                else
                    set min = this.min

                    if (min == 0) then
                        set x = 0.
                        set y = 0.
                        set z = 0.
                    else
                        return
                    endif
                endif
            endif

			set this.value = d
            set this.x = x
            set this.xAdd = x * MISSILE.UpdateTime.VALUE
            set this.y = y
            set this.yAdd = y * MISSILE.UpdateTime.VALUE
            set this.z = z
            set this.zAdd = z * MISSILE.UpdateTime.VALUE
        endmethod

        method SetMin takes real val returns nothing
            set this.min = val
            set this.minSet = true
            set this.minSquare = val * val
        endmethod

        method Set takes real value returns nothing
            if (value < this.min) then
                set value = this.min
            endif

            set this.value = value
            call this.SetPolar(value, 0., 0.)
        endmethod

        method AddPolar takes real x, real y, real z returns nothing
            call this.SetPolar(this.GetX() + x, this.GetY() + y, this.GetZ() + z)
        endmethod

        method Add takes real value returns nothing
            call this.Set(this.GetX() + value)
        endmethod

        method Event_Create takes nothing returns nothing
            set this.min = 0.
            set this.minSet = false
            set this.minSquare = 0.

            call this.Set(0.)
        endmethod
    endstruct

    //! runtextmacro Struct("GoToSpot")
        static Event STOP_EVENT
        static Timer UPDATE_TIMER

        real targetX
        real targetY
        real targetZ

        //! runtextmacro CreateList("ACTIVE_LIST")
        //! runtextmacro CreateForEachList("FOR_EACH_LIST", "ACTIVE_LIST")

        method Ending takes nothing returns nothing
            call Missile(this).Event.Remove(STOP_EVENT)
            if thistype.ACTIVE_LIST_Remove(this) then
                call thistype.UPDATE_TIMER.Pause()
            endif
        endmethod

        eventMethod Event_Stop
            local thistype this = params.Missile.GetTrigger()

            call this.Ending()
        endmethod

        timerMethod Update
            call thistype.FOR_EACH_LIST_Set()

            loop
                local thistype this = thistype.FOR_EACH_LIST_FetchFirst()

                exitwhen (this == NULL)

                local real speedX = Missile(this).Speed.GetXAdd()
                local real speedY = Missile(this).Speed.GetYAdd()
                local real speedZ = Missile(this).Speed.GetZAdd()
                local real targetX = this.targetX
                local real targetY = this.targetY
                local real targetZ = this.targetZ

                local real dX = targetX - Missile(this).Position.X.Get()
                local real dY = targetY - Missile(this).Position.Y.Get()
                local real dZ = targetZ - Missile(this).Position.Z.Get()

                local real d = Math.DistanceByDeltasWithZ(dX, dY, dZ)

                if (d < speedX + Missile(this).CollisionSize.Get()) then
                    call this.Ending()

                    call Missile(this).Impact.Do(targetX, targetY, targetZ)
                else
                    set dX = dX / d
                    set dY = dY / d
                    set dZ = dZ / d
                    call Missile(this).Speed.AddPolar(Missile(this).Acceleration.GetXAdd(), Missile(this).Acceleration.GetYAdd(), Missile(this).Acceleration.GetZAdd())

                    call Missile(this).Position.Add(speedX * dX, speedX * dY, speedX * dZ)
                endif
            endloop
        endmethod

        method Start takes real targetX, real targetY, real targetZ returns nothing
            call Missile(this).Start(targetX, targetY, targetZ)

            set this.targetX = targetX
            set this.targetY = targetY
            set this.targetZ = targetZ
            call Missile(this).Event.Add(STOP_EVENT)

            call Missile(this).Angle.Set(targetX - Missile(this).Position.X.Get(), targetY - Missile(this).Position.Y.Get(), targetZ - Missile(this).Position.Z.Get())
            call Missile(this).Arc.Start()

            if thistype.ACTIVE_LIST_Add(this) then
                call thistype.UPDATE_TIMER.Start(MISSILE.UpdateTime.VALUE, true, function thistype.Update)
            endif
        endmethod

        static method Init takes nothing returns nothing
            set thistype.STOP_EVENT = Event.Create(Missile.STOP_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Stop)
            set thistype.UPDATE_TIMER = Timer.Create()
        endmethod
    endstruct

    //! runtextmacro Struct("Checkpoints")
        static EventType ADD_EVENT_TYPE
        static EventType IMPACT_EVENT_TYPE
        static Event DESTROY_EVENT

        Queue vals

        method Impact_TriggerEvents takes MissileCheckpoint point returns nothing
            local EventResponse params = EventResponse.Create(Missile(this).Id.Get())

            call params.Missile.SetTrigger(this)
            call params.MissileCheckpoint.SetTrigger(point)

			local integer iteration = EventPriority.ALL_COUNT

            loop
                exitwhen (iteration < ARRAY_MIN)

                local EventPriority priority = EventPriority.ALL[iteration]

                local integer iteration2 = Missile(this).Event.Count(thistype.IMPACT_EVENT_TYPE, priority)

                loop
                    exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                    call Missile(this).Event.Get(thistype.IMPACT_EVENT_TYPE, priority, iteration2).Run(params)

                    set iteration2 = iteration2 - 1
                endloop

                set iteration = iteration - 1
            endloop

            call params.Destroy()
        endmethod

        method Impact takes MissileCheckpoint point returns nothing
            call this.Impact_TriggerEvents(point)
        endmethod

        method Count takes nothing returns integer
            return this.vals.Count()
        endmethod

        method GetFirst takes nothing returns MissileCheckpoint
            return this.vals.GetFirst()
        endmethod

        method GetNext takes MissileCheckpoint val returns MissileCheckpoint
            return this.vals.GetNext(val)
        endmethod

        method GetPrev takes MissileCheckpoint val returns MissileCheckpoint
            return this.vals.GetPrev(val)
        endmethod

        method Clear takes nothing returns nothing
            call this.vals.Clear()
        endmethod

        eventMethod Event_Destroy
            local Missile parent = params.Missile.GetTrigger()

            local thistype this = parent

            call parent.Event.Remove(DESTROY_EVENT)

            call this.Clear()

            call this.vals.Destroy()
        endmethod

        method Remove takes MissileCheckpoint point returns boolean
            if (this.vals == NULL) then
                return false
            endif

            return this.vals.Remove(point)
        endmethod

        method Add_TriggerEvents takes MissileCheckpoint point returns nothing
            local EventResponse params = EventResponse.Create(Missile(this).Id.Get())

            call params.Missile.SetTrigger(this)
            call params.MissileCheckpoint.SetTrigger(point)

			local integer iteration = EventPriority.ALL_COUNT

            loop
                exitwhen (iteration < ARRAY_MIN)

                local EventPriority priority = EventPriority.ALL[iteration]

                local integer iteration2 = Missile(this).Event.Count(thistype.ADD_EVENT_TYPE, priority)

                loop
                    exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                    call Missile(this).Event.Get(thistype.ADD_EVENT_TYPE, priority, iteration2).Run(params)

                    set iteration2 = iteration2 - 1
                endloop

                set iteration = iteration - 1
            endloop

            call params.Destroy()
        endmethod

        method Add takes MissileCheckpoint point returns boolean
            if (this.vals == NULL) then
                set this.vals = Queue.Create()

                call Missile(this).Event.Add(DESTROY_EVENT)
            endif

            local boolean result = this.vals.Add(point)

            call this.Add_TriggerEvents(point)

            return result
        endmethod

        method Create takes real x, real y, real z returns MissileCheckpoint
            local MissileCheckpoint result = MissileCheckpoint.Create(x, y, z)

            call this.Add(result)

            return result
        endmethod

        method Event_Create takes nothing returns nothing
            set this.vals = NULL
        endmethod

        static method Init takes nothing returns nothing
            set thistype.ADD_EVENT_TYPE = EventType.Create()
            set thistype.IMPACT_EVENT_TYPE = EventType.Create()
            set thistype.DESTROY_EVENT = Event.Create(Missile.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
        endmethod
    endstruct

    //! runtextmacro Struct("GoToUnit")
        static Event CHECKPOINT_ADD_EVENT
        //! runtextmacro GetKeyArray("KEY_ARRAY")
        static Event STOP_EVENT
        static Event TARGET_DEATH_EVENT
        static Event TARGET_DESTROY_EVENT
        static Timer UPDATE_TIMER

        boolean cancelOnTargetDeath
        MissileCheckpoint nextCheckpoint
        real offsetX
        real offsetY
        real offsetZ
        Unit target
        real targetX
        real targetY
        real targetZ
        Trigger targetResetAction

        //! runtextmacro CreateList("ACTIVE_LIST")
        //! runtextmacro CreateForEachList("FOR_EACH_LIST", "ACTIVE_LIST")

        method ReleaseFromTarget takes Unit target returns nothing
            if target.Data.Integer.Table.Remove(KEY_ARRAY, this) then
                call target.Event.Remove(TARGET_DEATH_EVENT)
                call target.Event.Remove(TARGET_DESTROY_EVENT)
                call target.Refs.Subtract()
            endif
        endmethod

        method Ending takes Unit target returns nothing
            if (target != NULL) then
                call this.ReleaseFromTarget(target)
            endif
            call Missile(this).Event.Remove(CHECKPOINT_ADD_EVENT)
            call Missile(this).Event.Remove(STOP_EVENT)

            if thistype.ACTIVE_LIST_Remove(this) then
                call thistype.UPDATE_TIMER.Pause()
            endif
        endmethod

        eventMethod Event_Stop
            local thistype this = params.Missile.GetTrigger()

            call this.Ending(this.target)
        endmethod

		static method ResetFromTarget takes Unit target, EventResponse resetParams returns nothing
            local real targetX = target.Position.X.Get()
            local real targetY = target.Position.Y.Get()

            local real targetZ = target.Position.Z.GetByCoords(targetX, targetY) + target.Impact.Z.Get(true)

			local integer iteration = target.Data.Integer.Table.Count(KEY_ARRAY)

            loop
                local thistype this = target.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                call this.ReleaseFromTarget(target)

                set this.target = NULL
                set this.targetX = targetX + this.offsetX
                set this.targetY = targetY + this.offsetY
                set this.targetZ = targetZ + this.offsetZ

				if (this.targetResetAction != NULL) then
					call resetParams.Missile.SetTrigger(this)

					call this.targetResetAction.RunWithParams(resetParams)
				endif

                set iteration = iteration - 1
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
            endloop
		endmethod

        eventMethod Event_TargetDeath
            local Unit target = params.Unit.GetTrigger()

			call thistype.ResetFromTarget(target, params)
        endmethod

		eventMethod Event_TargetDestroy
            local Unit target = params.Unit.GetTrigger()

            call thistype.ResetFromTarget(target, params)
		endmethod

        timerMethod Update
            call thistype.FOR_EACH_LIST_Set()

            loop
                local thistype this = thistype.FOR_EACH_LIST_FetchFirst()

                exitwhen (this == NULL)

                local MissileCheckpoint nextCheckpoint = this.nextCheckpoint
                local real speedX = Missile(this).Speed.GetXAdd()
                local real speedY = Missile(this).Speed.GetYAdd()
                local real speedZ = Missile(this).Speed.GetZAdd()
                local real x = Missile(this).Position.X.Get()
                local real y = Missile(this).Position.Y.Get()
                local real z = Missile(this).Position.Z.Get()

				local Unit target = this.target
				local real targetX
				local real targetY
				local real targetZ

                if (nextCheckpoint != NULL) then
                    set targetX = nextCheckpoint.GetX()
                    set targetY = nextCheckpoint.GetY()
                    set targetZ = nextCheckpoint.GetZ()
                elseif (target == NULL) then
                    set targetX = this.targetX
                    set targetY = this.targetY
                    set targetZ = this.targetZ
                else
                    set targetX = target.Position.X.Get() + this.offsetX
                    set targetY = target.Position.Y.Get() + this.offsetY

                    set targetZ = target.Position.Z.GetByCoords(targetX, targetY) + target.Impact.Z.Get(true) + this.offsetZ
                endif

                local real dX = targetX - x
                local real dY = targetY - y
                local real dZ = targetZ - z

                local real d = Math.DistanceByDeltasWithZ(dX, dY, dZ)

                if (d < speedX + Missile(this).CollisionSize.Get()) then
                    if (nextCheckpoint == NULL) then
                        call this.Ending(target)

                        if (target == NULL) then
                            call Missile(this).Impact.Do(targetX, targetY, targetZ)
                        else
                            call Missile(this).Impact.DoOnUnit(target)
                        endif
                    else
                        set this.nextCheckpoint = Missile(this).Checkpoints.GetNext(nextCheckpoint)

                        call Missile(this).Checkpoints.Impact(nextCheckpoint)
                    endif
                else
                    set dX = dX / d
                    set dY = dY / d
                    set dZ = dZ / d
                    call Missile(this).Angle.Set(dX, dY, dZ)
                    call Missile(this).Speed.AddPolar(Missile(this).Acceleration.GetXAdd(), Missile(this).Acceleration.GetYAdd(), Missile(this).Acceleration.GetZAdd())

                    call Missile(this).Position.Add(speedX * dX, speedX * dY, speedX * dZ)
                endif
            endloop
        endmethod

        eventMethod Event_CheckpointAdd
            local Missile parent = params.Missile.GetTrigger()

            if (thistype(parent).nextCheckpoint != NULL) then
                return
            endif

            set thistype(parent).nextCheckpoint = params.MissileCheckpoint.GetTrigger()
        endmethod

        method StartWithOffset takes Unit target, real offsetX, real offsetY, real offsetZ, code targetResetActionFunc returns nothing
            call Missile(this).Start(target.Position.X.Get() + offsetX, target.Position.Y.Get() + offsetY, target.Position.Z.Get() + target.Impact.Z.Get(true) + offsetZ)

            set this.cancelOnTargetDeath = cancelOnTargetDeath
            set this.nextCheckpoint = Missile(this).Checkpoints.GetFirst()
            set this.offsetX = offsetX
            set this.offsetY = offsetY
            set this.offsetZ = offsetZ
            set this.target = target
            set this.targetResetAction = Trigger.GetFromCode(targetResetActionFunc)
            if target.Data.Integer.Table.Add(KEY_ARRAY, this) then
                call target.Event.Add(TARGET_DEATH_EVENT)
                call target.Event.Add(TARGET_DESTROY_EVENT)
                call target.Refs.Add()
            endif
            call Missile(this).Event.Add(CHECKPOINT_ADD_EVENT)
            call Missile(this).Event.Add(STOP_EVENT)

            call Missile(this).Arc.Start()

            if thistype.ACTIVE_LIST_Add(this) then
                call thistype.UPDATE_TIMER.Start(MISSILE.UpdateTime.VALUE, true, function thistype.Update)
            endif
        endmethod

        method Start takes Unit target, code targetResetActionFunc returns nothing
            call this.StartWithOffset(target, 0., 0., 0., targetResetActionFunc)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.CHECKPOINT_ADD_EVENT = Event.Create(MISSILE.Checkpoints.ADD_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_CheckpointAdd)
            set thistype.STOP_EVENT = Event.Create(Missile.STOP_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Stop)
            set thistype.TARGET_DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TargetDeath)
            set thistype.TARGET_DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_TargetDestroy)
            set thistype.UPDATE_TIMER = Timer.Create()
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Missile", "MISSILE")
    static EventType DESTROY_EVENT_TYPE
    static EventType STOP_EVENT_TYPE

    boolean moving

    //! runtextmacro LinkToStruct("Missile", "Acceleration")
    //! runtextmacro LinkToStruct("Missile", "Angle")
    //! runtextmacro LinkToStruct("Missile", "Arc")
    //! runtextmacro LinkToStruct("Missile", "Checkpoints")
    //! runtextmacro LinkToStruct("Missile", "CollisionSize")
    //! runtextmacro LinkToStruct("Missile", "Data")
    //! runtextmacro LinkToStruct("Missile", "DummyUnit")
    //! runtextmacro LinkToStruct("Missile", "Event")
    //! runtextmacro LinkToStruct("Missile", "GoToSpot")
    //! runtextmacro LinkToStruct("Missile", "GoToUnit")
    //! runtextmacro LinkToStruct("Missile", "Id")
    //! runtextmacro LinkToStruct("Missile", "Impact")
    //! runtextmacro LinkToStruct("Missile", "Position")
    //! runtextmacro LinkToStruct("Missile", "Speed")
    //! runtextmacro LinkToStruct("Missile", "UpdateTime")

    //! runtextmacro CreateAnyState("data", "Data", "integer")
    //! runtextmacro CreateAnyState("targetX", "TargetX", "real")
    //! runtextmacro CreateAnyState("targetY", "TargetY", "real")
    //! runtextmacro CreateAnyState("targetZ", "TargetZ", "real")

    method GetTargetDistanceXY takes nothing returns real
        return Math.DistanceByDeltas(this.Position.X.Get() - this.GetTargetX(), this.Position.Y.Get() - this.GetTargetY())
    endmethod

    method GetTargetDistance takes nothing returns real
        return Math.DistanceByDeltasWithZ(this.Position.X.Get() - this.GetTargetX(), this.Position.Y.Get() - this.GetTargetY(), this.Position.Z.Get() - this.GetTargetZ())
    endmethod

    method Stop_TriggerEvents takes nothing returns nothing
        local EventResponse params = EventResponse.Create(this.Id.Get())

        call params.Missile.SetTrigger(this)

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

    method Start takes real targetX, real targetY, real targetZ returns nothing
        if this.moving then
            call this.Stop()
        endif

        set this.moving = true
        call this.SetTargetX(targetX)
        call this.SetTargetY(targetY)
        call this.SetTargetZ(targetZ)
    endmethod

    method Destroy_TriggerEvents takes nothing returns nothing
        local EventResponse params = EventResponse.Create(this.Id.Get())

        call params.Missile.SetTrigger(this)

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
        call this.Stop()

        call this.Destroy_TriggerEvents()

        call this.deallocate()
    endmethod

	eventMethod Destruction
		call params.Missile.GetTrigger().Destroy()
	endmethod

    static method Create takes nothing returns thistype
        local thistype this = thistype.allocate()

        set this.moving = false

        call this.Acceleration.Event_Create()
        call this.Arc.Event_Create()
        call this.Checkpoints.Event_Create()
        call this.CollisionSize.Event_Create()
        call this.DummyUnit.Event_Create()
        call this.Id.Event_Create()
        call this.Impact.Event_Create()
        call this.Position.Event_Create()
        call this.Speed.Event_Create()

        return this
    endmethod

    initMethod Init of Header_7
        set thistype.DESTROY_EVENT_TYPE = EventType.Create()
        set thistype.STOP_EVENT_TYPE = EventType.Create()

        call thistype(NULL).Checkpoints.Init()
        call thistype(NULL).DummyUnit.Init()
        call thistype(NULL).GoToSpot.Init()
        call thistype(NULL).GoToUnit.Init()
        call thistype(NULL).Position.Init()
    endmethod
endstruct