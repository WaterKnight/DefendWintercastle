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
        //! runtextmacro CreateAnyStaticStateDefault("TRIGGER", "Trigger", "Missile", "NULL")

        //! runtextmacro Event_Implement("Missile")
    endstruct

    //! runtextmacro Struct("Arc")
        real acceleration
        real distance
        real duration
        real speed

        //! runtextmacro CreateSimpleAddState_NotStart("real")

        method GetHeight takes nothing returns real
            local real distance = this.distance
            local real time

            if (distance == 0.) then
                return 0.
            endif

            set time = (1 - Missile(this).GetTargetDistance() / distance) * this.duration

            return ((acceleration / 2) * time * time + speed * time)
        endmethod

        method SetByPerc takes real value returns nothing
            call this.Set(Math.QUARTER_ANGLE * value)
        endmethod

        method Start takes nothing returns nothing
            local real acceleration
            local real distance = Math.DistanceByDeltasWithZ(Missile(this).Position.X.Get() - Missile(this).GetTargetX(), Missile(this).Position.Y.Get() - Missile(this).GetTargetY(), Missile(this).Position.Z.Get() - Missile(this).GetTargetZ())
            local real speed = Missile(this).Speed.GetX()

            local real duration = Math.GetMovementDuration(distance, speed, Missile(this).Acceleration.GetX())

            if (duration == 0.) then
                return
            endif

            set speed = speed * Math.Tan(this.Get())

            set acceleration = -2 * speed / duration

            set this.acceleration = acceleration
            set this.distance = distance
            set this.duration = duration
            set this.speed = speed
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
            set this.filter = NULL

            call Missile(this).Position.Set(x, y, z)

            call MISSILE.Event.SetTrigger(this)
            call UNIT.Event.SetTrigger(NULL)

            call this.action.Run()
        endmethod

        method DoOnUnit takes Unit target returns nothing
            set this.filter = NULL

            call Missile(this).Position.SetToUnit(target)

            call MISSILE.Event.SetTrigger(this)
            call UNIT.Event.SetTrigger(target)

            call this.action.Run()
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

        static method Event_Destroy takes nothing returns nothing
            local DummyUnit value = DUMMY_UNIT.Event.GetTrigger()

            local thistype this = value.Data.Integer.Get(KEY)

            call this.Set(NULL)
        endmethod

        static method Event_ParentDestroy takes nothing returns nothing
            local Missile parent = MISSILE.Event.GetTrigger()

            local thistype this = parent

            local DummyUnit value = this.Get()

            call this.Set(NULL)

            call value.Destroy()
        endmethod

        method Create takes integer id, real scale returns DummyUnit
            local DummyUnit value = DummyUnit.Create(id, Missile(this).Position.X.Get(), Missile(this).Position.Y.Get(), Missile(this).Position.Z.Get(), Missile(this).Angle.GetXY())

            call this.Set(value)

            call value.Scale.Set(scale)

            return value
        endmethod

        method Event_Create takes nothing returns nothing
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
            local DummyUnit dummyUnit = Missile(this).DummyUnit.Get()

            call this.SetXPart(dX / d)
            call this.SetYPart(dY / d)
            call this.SetZPart(dZ / d)
            if (dummyUnit != NULL) then
                call dummyUnit.Facing.Set(Math.AtanByDeltas(dY, dX))
            endif
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

        //! runtextmacro LinkToStruct("Position", "X")
        //! runtextmacro LinkToStruct("Position", "Y")
        //! runtextmacro LinkToStruct("Position", "Z")

        method Set takes real x, real y, real z returns nothing
            local DummyUnit dummyUnit = Missile(this).DummyUnit.Get()
            local BoolExpr impactFilter = Missile(this).Impact.GetFilter()
            local Unit impactUnit

            call this.X.Set(x)
            call this.Y.Set(y)
            call this.Z.Set(z)

            if (dummyUnit != NULL) then
                call dummyUnit.Position.Set(x, y, z + Missile(this).Arc.GetHeight())
            endif

            if (impactFilter != NULL) then
                call MISSILE.Event.SetTrigger(this)

                call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, Missile(this).CollisionSize.Get(), impactFilter)

                set impactUnit = thistype.ENUM_GROUP.GetFirst()

                if (impactUnit != NULL) then
                    call Missile(this).Impact.DoOnUnit(impactUnit)
                endif
            endif
        endmethod

        method Add takes real x, real y, real z returns nothing
            call this.Set(this.X.Get() + x, this.Y.Get() + y, this.Z.Get() + z)
        endmethod

        method SetFromUnit takes Unit source returns nothing
            call this.Set(source.Position.X.Get() + source.Outpact.X.Get(true), source.Position.Y.Get() + source.Outpact.Y.Get(true), source.Position.Z.Get() + source.Outpact.Z.Get(true))
        endmethod

        method SetToUnitWithOffset takes Unit target, real offsetX, real offsetY, real offsetZ returns nothing
            call this.Set(target.Position.X.Get() + target.Impact.X.Get(true) + offsetX, target.Position.Y.Get() + target.Impact.Y.Get(true) + offsetY, target.Position.Z.Get() + target.Impact.Z.Get(true) + offsetZ)
        endmethod

        method SetToUnit takes Unit target returns nothing
            call this.SetToUnitWithOffset(target, 0., 0., 0.)
        endmethod

        method Event_Create takes nothing returns nothing
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
    endstruct

    //! runtextmacro Struct("Acceleration")
        //! runtextmacro CreateAnyState("x", "X", "real")
        //! runtextmacro CreateAnyState("xAdd", "XAdd", "real")
        //! runtextmacro CreateAnyState("y", "Y", "real")
        //! runtextmacro CreateAnyState("yAdd", "YAdd", "real")
        //! runtextmacro CreateAnyState("z", "Z", "real")
        //! runtextmacro CreateAnyState("zAdd", "ZAdd", "real")

        method SetPolar takes real x, real y, real z returns nothing
            set this.x = x
            set this.xAdd = x * MISSILE.UpdateTime.VALUE
            set this.y = y
            set this.yAdd = y * MISSILE.UpdateTime.VALUE
            set this.z = z
            set this.zAdd = z * MISSILE.UpdateTime.VALUE
        endmethod

        method Set takes real value returns nothing
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

        method SetPolar takes real x, real y, real z returns nothing
            set this.x = x
            set this.xAdd = x * MISSILE.UpdateTime.VALUE
            set this.y = y
            set this.yAdd = y * MISSILE.UpdateTime.VALUE
            set this.z = z
            set this.zAdd = z * MISSILE.UpdateTime.VALUE
        endmethod

        method Set takes real value returns nothing
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
            if (thistype.ACTIVE_LIST_Remove(this)) then
                call thistype.UPDATE_TIMER.Pause()
            endif
        endmethod

        static method Event_Stop takes nothing returns nothing
            local thistype this = MISSILE.Event.GetTrigger()

            call this.Ending()
        endmethod

        static method Update takes nothing returns nothing
            local real d
            local real dX
            local real dY
            local real dZ
            local real speedX
            local real speedY
            local real speedZ
            local real targetX
            local real targetY
            local real targetZ
            local thistype this

            call thistype.FOR_EACH_LIST_Set()

            loop
                set this = thistype.FOR_EACH_LIST_FetchFirst()

                exitwhen (this == NULL)

                set speedX = Missile(this).Speed.GetXAdd()
                set speedY = Missile(this).Speed.GetYAdd()
                set speedZ = Missile(this).Speed.GetZAdd()
                set targetX = this.targetX
                set targetY = this.targetY
                set targetZ = this.targetZ

                set dX = targetX - Missile(this).Position.X.Get()
                set dY = targetY - Missile(this).Position.Y.Get()
                set dZ = targetZ - Missile(this).Position.Z.Get()

                set d = Math.DistanceByDeltasWithZ(dX, dY, dZ)

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

            if (thistype.ACTIVE_LIST_Add(this)) then
                call thistype.UPDATE_TIMER.Start(MISSILE.UpdateTime.VALUE, true, function thistype.Update)
            endif
        endmethod

        static method Init takes nothing returns nothing
            set thistype.STOP_EVENT = Event.Create(Missile.STOP_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Stop)
            set thistype.UPDATE_TIMER = Timer.Create()
        endmethod
    endstruct

    //! runtextmacro Struct("GoToUnit")
        static Event DEATH_EVENT
        //! runtextmacro GetKeyArray("KEY_ARRAY")
        static Event STOP_EVENT
        static Timer UPDATE_TIMER

        boolean cancelOnTargetDeath
        real offsetX
        real offsetY
        real offsetZ
        Unit target
        real targetX
        real targetY
        real targetZ

        //! runtextmacro CreateList("ACTIVE_LIST")
        //! runtextmacro CreateForEachList("FOR_EACH_LIST", "ACTIVE_LIST")

        method ReleaseFromTarget takes Unit target returns nothing
            if (target.Data.Integer.Table.Remove(KEY_ARRAY, this)) then
                call target.Event.Remove(DEATH_EVENT)
                call target.Refs.Subtract()
            endif
        endmethod

        method Ending takes Unit target returns nothing
            if (target != NULL) then
                call this.ReleaseFromTarget(target)
            endif
            call Missile(this).Event.Remove(STOP_EVENT)
            if (thistype.ACTIVE_LIST_Remove(this)) then
                call thistype.UPDATE_TIMER.Pause()
            endif
        endmethod

        static method Event_Stop takes nothing returns nothing
            local thistype this = MISSILE.Event.GetTrigger()

            call this.Ending(this.target)
        endmethod

        static method Event_Death takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()
            local thistype this

            local integer iteration = target.Data.Integer.Table.Count(KEY_ARRAY)
            local real targetX = target.Position.X.Get()
            local real targetY = target.Position.Y.Get()

            local real targetZ = target.Position.Z.GetByCoords(targetX, targetY) + target.Impact.Z.Get(true)

            loop
                set this = target.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                if (this.cancelOnTargetDeath) then
                    call this.Ending(target)
                else
                    call this.ReleaseFromTarget(target)

                    set this.target = NULL
                    set this.targetX = targetX + this.offsetX
                    set this.targetY = targetY + this.offsetY
                    set this.targetZ = targetZ + this.offsetZ
                endif

                set iteration = iteration - 1
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
            endloop
        endmethod

        static method Update takes nothing returns nothing
            local real d
            local real dX
            local real dY
            local real dZ
            local real speedX
            local real speedY
            local real speedZ
            local Unit target
            local real targetX
            local real targetY
            local real targetZ
            local thistype this
            local real x
            local real y
            local real z

            call thistype.FOR_EACH_LIST_Set()

            loop
                set this = thistype.FOR_EACH_LIST_FetchFirst()

                exitwhen (this == NULL)

                set speedX = Missile(this).Speed.GetXAdd()
                set speedY = Missile(this).Speed.GetYAdd()
                set speedZ = Missile(this).Speed.GetZAdd()
                set target = this.target
                set x = Missile(this).Position.X.Get()
                set y = Missile(this).Position.Y.Get()
                set z = Missile(this).Position.Z.Get()

                if (target == NULL) then
                    set targetX = this.targetX
                    set targetY = this.targetY
                    set targetZ = this.targetZ
                else
                    set targetX = target.Position.X.Get() + this.offsetX
                    set targetY = target.Position.Y.Get() + this.offsetY

                    set targetZ = target.Position.Z.GetByCoords(targetX, targetY) + target.Impact.Z.Get(true) + this.offsetZ
                endif

                set dX = targetX - x
                set dY = targetY - y
                set dZ = targetZ - z

                set d = Math.DistanceByDeltasWithZ(dX, dY, dZ)

                if (d < speedX + Missile(this).CollisionSize.Get()) then
                    call this.Ending(target)

                    if (target == NULL) then
                        call Missile(this).Impact.Do(targetX, targetY, targetZ)
                    else
                        call Missile(this).Impact.DoOnUnit(target)
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

        method StartWithOffset takes Unit target, real offsetX, real offsetY, real offsetZ, boolean cancelOnTargetDeath returns nothing
            call Missile(this).Start(target.Position.X.Get() + offsetX, target.Position.Y.Get() + offsetY, target.Position.Z.Get() + target.Impact.Z.Get(true) + offsetZ)

            set this.cancelOnTargetDeath = cancelOnTargetDeath
            set this.offsetX = offsetX
            set this.offsetY = offsetY
            set this.offsetZ = offsetZ
            set this.target = target
            if (target.Data.Integer.Table.Add(KEY_ARRAY, this)) then
                call target.Event.Add(DEATH_EVENT)
                call target.Refs.Add()
            endif
            call Missile(this).Event.Add(STOP_EVENT)

            call Missile(this).Arc.Start()

            if (thistype.ACTIVE_LIST_Add(this)) then
                call thistype.UPDATE_TIMER.Start(MISSILE.UpdateTime.VALUE, true, function thistype.Update)
            endif
        endmethod

        method Start takes Unit target, boolean cancelOnTargetDeath returns nothing
            call this.StartWithOffset(target, 0., 0., 0., cancelOnTargetDeath)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Death)
            set thistype.STOP_EVENT = Event.Create(Missile.STOP_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Stop)
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

    method GetTargetDistance takes nothing returns real
        return Math.DistanceByDeltasWithZ(this.Position.X.Get() - this.GetTargetX(), this.Position.Y.Get() - this.GetTargetY(), this.Position.Z.Get() - this.GetTargetZ())
    endmethod

    method Stop_TriggerEvents takes nothing returns nothing
        local integer iteration = EventPriority.ALL_COUNT
        local integer iteration2
        local EventPriority priority

        loop
            exitwhen (iteration < ARRAY_MIN)

            set priority = EventPriority.ALL[iteration]

            set iteration2 = this.Event.Count(thistype.STOP_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call MISSILE.Event.SetTrigger(this)

                call this.Event.Get(thistype.STOP_EVENT_TYPE, priority, iteration2).Run()

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration - 1
        endloop
    endmethod

    method Stop takes nothing returns nothing
        if (this.moving) then
            set this.moving = false

            call this.Stop_TriggerEvents()
        endif
    endmethod

    method Start takes real targetX, real targetY, real targetZ returns nothing
        if (this.moving) then
            call this.Stop()
        endif

        set this.moving = true
        call this.SetTargetX(targetX)
        call this.SetTargetY(targetY)
        call this.SetTargetZ(targetZ)
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

                call MISSILE.Event.SetTrigger(this)

                call this.Event.Get(thistype.DESTROY_EVENT_TYPE, priority, iteration2).Run()

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration - 1
        endloop
    endmethod

    method Destroy takes nothing returns nothing
        call this.Stop()

        call this.Destroy_TriggerEvents()

        call this.deallocate()
    endmethod

    static method Create takes nothing returns thistype
        local thistype this = thistype.allocate()

        set this.moving = false

        call this.Acceleration.Event_Create()
        call this.Arc.Event_Create()
        call this.CollisionSize.Event_Create()
        call this.DummyUnit.Event_Create()
        call this.Id.Event_Create()
        call this.Impact.Event_Create()
        call this.Position.Event_Create()
        call this.Speed.Event_Create()

        return this
    endmethod

    static method Init takes nothing returns nothing
        set thistype.DESTROY_EVENT_TYPE = EventType.Create()
        set thistype.STOP_EVENT_TYPE = EventType.Create()

        call thistype(NULL).DummyUnit.Init()
        call thistype(NULL).GoToSpot.Init()
        call thistype(NULL).GoToUnit.Init()
        call thistype(NULL).Position.Init()
    endmethod
endstruct