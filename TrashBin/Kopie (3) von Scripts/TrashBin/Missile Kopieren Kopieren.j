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

    //! runtextmacro Struct("Impact")
        Trigger action

        //! runtextmacro CreateAnyState("BoolExpr", "impactFilter")

        method Do takes real x, real y, real z returns nothing
            call Missile(this).Event.SetTrigger(this)

            call this.action.Run()
        endmethod

        method DoOnUnit takes Unit target returns nothing
            call UNIT.Event.SetTrigger(targetUnit)
            call Missile(this).Event.SetTrigger(this)

            call this.action.Run()
        endmethod

        method Set takes code actionFunction returns nothing
            set this.value = Trigger.CreateFromCode(actionFunction)
        endmethod

        method Event_Create takes nothing returns nothing
            set this.action = NULL
            set this.impactFilter = NULL
        endmethod

        static method Init takes nothing returns nothing
        endmethod
    endstruct

    //! runtextmacro Struct("CollisionSize")
        //! runtextmacro CreateSimpleAddState("real", "0.")
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
                call dummyUnit.Position.Set(x, y, z)
            endif

            if (impactFilter != NULL) then
                call Missile.SetTrigger(this)

                call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, Missile(this).CollisionSize.Get(), impactFilter)

                set impactUnit = thistype.ENUM_GROUP.GetFirst()

                if (impactUnit != NULL) then
                    call Missile(this).Impact.DoOnUnit(impactUnit)
                endif
            endif
        endmethod

        method SetFromUnit takes Unit source, boolean useScale returns nothing
            call this.Set(source.Position.X.Get() + source.Outpact.X.Get(useScale), source.Position.Y.Get() + source.Outpact.Y.Get(useScale), source.Position.Z.Get() + source.Outpact.Z.Get(useScale))
        endmethod

        method SetToUnit takes Unit target, boolean useScale returns nothing
            call this.Set(target.Position.X.Get() + target.Impact.X.Get(useScale), target.Position.Y.Get() + target.Impact.Y.Get(useScale), target.Position.Z.Get() + target.Impact.Z.Get(useScale))
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

    //! runtextmacro Struct("GoToSpot")
        static Event DESTROY_EVENT
        //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "2")
        static Timer UPDATE_TIMER

            static Event ACCELERATION_CHANGE_EVENT
            static Event COLLISION_SIZE_CHANGE_EVENT
            static Event POSITION_CHANGE_EVENT
            static Event SPEED_CHANGE_EVENT

        Timer durationTimer
        real targetX
        real targetY
        real targetZ
        real xAdd
        real yAdd
        real zAdd

            real xAddAdd
            real yAddAdd
            real zAddAdd

        method Ending takes Timer durationTimer returns nothing
            call durationTimer.Destroy()
            call Missile(this).Event.Remove(DESTROY_EVENT)
            if (this.RemoveFromForEachList()) then
                call thistype.UPDATE_TIMER.Pause()
            endif
        endmethod

        static method EndingByTimer takes nothing returns nothing
            local Timer durationTimer = Timer.GetExpired()

            local thistype this = durationTimer.GetData()

            call this.Ending(durationTimer)

            call Missile(this).Impact.Do(this.targetX, this.targetY, this.targetZ)
        endmethod

        static method Event_Destroy takes nothing returns nothing
            local thistype this = Missile.GetTrigger()

            call this.Ending(this.durationTimer)
        endmethod

        static method Update takes nothing returns nothing
            local thistype this
            local real xAdd
            local real yAdd
            local real zAdd

            call thistype.SetForEachList()

            loop
                set this = thistype.GetFromForEachList()

                exitwhen (this == NULL)

                set xAdd = this.xAdd
                set yAdd = this.yAdd
                set zAdd = this.zAdd

                set this.xAdd = xAdd + this.xAddAdd
                set this.yAdd = yAdd + this.yAddAdd
                set this.zAdd = zAdd + this.zAddAdd

                call Missile(this).Position.Set(Missile(this).Position.X.Get() + xAdd, Missile(this).Position.Y.Get() + yAdd, Missile(this).Position.Z.Get() + zAdd)
            endloop
        endmethod

        method UpdateParams takes nothing returns nothing
            local real duration
            local real dX = this.targetX - Missile(this).Position.X.Get()
            local real dY = this.targetY - Missile(this).Position.Y.Get()
            local real dZ = this.targetZ - Missile(this).Position.Z.Get()

            local real d = Math.DistanceByDeltasWithZ(dX, dY, dZ)

            local real xPart = dX / d * thistype.UPDATE_TIME
            local real yPart = dY / d * thistype.UPDATE_TIME
            local real zPart = dZ / d * thistype.UPDATE_TIME

            set duration = Math.GetMovementDuration(Math.Max(0., d - Missile(this).CollisionSize.Get()), Missile(this).Speed.Get(), Missile(this).Acceleration.Get())

            set this.xAdd = xPart * speed
            set this.yAdd = yPart * speed
            set this.zAdd = zPart * speed

                set this.xAddAdd = xPart * value * thistype.UPDATE_TIME
                set this.yAddAdd = yPart * value * thistype.UPDATE_TIME
                set this.zAddAdd = zPart * value * thistype.UPDATE_TIME

            if (duration > 0.) then
                call durationTimer.Start(duration, false, function thistype.EndingByTimer)
            endif
        endmethod

        static method Event_ParamsChange takes nothing returns nothing
            call this.UpdateParams()
        endmethod

        method Start takes real targetX, real targetY, real targetZ returns nothing
            local Timer durationTimer = Timer.Create()

            set this.durationTimer = durationTimer
            set this.targetX = targetX
            set this.targetY = targetY
            set this.targetZ = targetZ
            call durationTimer.SetData(this)
            call Missile(this).Event.Add(DESTROY_EVENT)

            if (this.AddToList()) then
                call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.Update)
            endif

            call this.UpdateParams()
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DESTROY_EVENT = Event.Create(Missile.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
            set thistype.UPDATE_TIMER = Timer.Create()

                set thistype.ACCELERATION_CHANGE_EVENT = Event.Create(MISSILE.Acceleration.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_ParamsChange)
                set thistype.POSITION_CHANGE_EVENT = Event.Create(MISSILE.Position.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_ParamsChange)
                set thistype.SPEED_CHANGE_EVENT = Event.Create(MISSILE.Acceleration.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_ParamsChange)
        endmethod
    endstruct

    //! runtextmacro Struct("GoToUnit")
        static Event DEATH_EVENT
        static Event DESTROY_EVENT
        //! runtextmacro GetKeyArray("KEY_ARRAY")
        //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "2")

        boolean cancelOnTargetDeath
        real length
        Timer moveTimer
        Unit target
        real targetX
        real targetY
        real targetZ

        method ReleaseFromTarget takes Unit target returns nothing
            if (target.Data.Integer.Table.Remove(KEY_ARRAY, this)) then
                call target.Event.Remove(DEATH_EVENT)
                call target.Refs.Subtract()
            endif
        endmethod

        method Ending takes Timer moveTimer, Unit target returns nothing
            call moveTimer.Destroy()
            if (target != NULL) then
                call this.ReleaseFromTarget(target)
            endif
            call Missile(this).Event.Remove(DESTROY_EVENT)
        endmethod

        static method Event_Destroy takes nothing returns nothing
            local thistype this = Missile.GetTrigger()

            call this.Ending(this.moveTimer, this.target)
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
                    call this.Ending(this.dummyUnit, this.moveTimer, target)
                else
                    call this.ReleaseFromTarget(target)

                    set this.target = NULL
                    set this.targetX = targetX
                    set this.targetY = targetY
                    set this.targetZ = targetZ
                endif

                set iteration = iteration - 1
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
            endloop
        endmethod

        static method Move takes nothing returns nothing
            local real angleXY
            local real angleLengthXYZ
            local real d
            local real dX
            local real dY
            local real dZ
            local real lengthXY
            local Timer moveTimer = Timer.GetExpired()
            local boolean reachesTarget
            local real targetX
            local real targetY
            local real targetZ

            local thistype this = moveTimer.GetData()

            local real length = this.length
            local Unit target = this.target
            local real x = Missile(this).Position.X.Get()
            local real y = Missile(this).Position.Y.Get()
            local real z = Missile(this).Position.Z.Get()

            if (target == NULL) then
                set targetX = this.targetX
                set targetY = this.targetY
                set targetZ = this.targetZ
            else
                set targetX = target.Position.X.Get()
                set targetY = target.Position.Y.Get()

                set targetZ = target.Position.Z.GetByCoords(targetX, targetY) + target.Impact.Z.Get(true)
            endif

            set dX = targetX - x
            set dY = targetY - y
            set dZ = targetZ - z

            set d = Math.DistanceByDeltasWithZ(dX, dY, dZ)

            set reachesTarget = (d < length + Missile(this).CollisionSize.Get())

            if (reachesTarget) then
                set x = targetX
                set y = targetY
                set z = targetZ
            else
                set angleLengthXYZ = Math.AtanByDeltas(dZ, Math.DistanceByDeltas(dX, dY))
                set angleXY = Math.AtanByDeltas(dY, dX)
                call dummyUnit.Facing.Set(angleXY)

                set lengthXY = length * Math.Cos(angleLengthXYZ)
                set z = z + length * Math.Sin(angleLengthXYZ)

                set x = x + lengthXY * Math.Cos(angleXY)
                set y = y + lengthXY * Math.Sin(angleXY)
            endif

            if (reachesTarget) then
                call this.Ending(moveTimer, target)

                call Missile(this).Impact.DoOnUnit(target)
            else
                call Missile(this).Position.Set(x, y, z)
            endif
        endmethod

        method Start takes Unit target, boolean cancelOnTargetDeath, integer data returns nothing
            local Timer moveTimer = Timer.Create()

            set this.cancelOnTargetDeath = cancelOnTargetDeath
            set this.length = speed * thistype.UPDATE_TIME
            set this.moveTimer = moveTimer
            set this.target = target
            call moveTimer.SetData(this)
            if (target.Data.Integer.Table.Add(KEY_ARRAY, this)) then
                call target.Event.Add(DEATH_EVENT)
                call target.Refs.Add()
            endif
            call Missile(this).Event.Add(DESTROY_EVENT)

            call moveTimer.Start(thistype.UPDATE_TIME, true, function thistype.Move)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Death)
            set thistype.DESTROY_EVENT = Event.Create(Missile.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Missile", "MISSILE")
    static EventType DESTROY_EVENT_TYPE

    DummyUnit dummyUnit

    //! runtextmacro LinkToStruct("Missile", "CollisionSize")
    //! runtextmacro LinkToStruct("Missile", "Data")
    //! runtextmacro LinkToStruct("Missile", "Event")
    //! runtextmacro LinkToStruct("Missile", "GoToSpot")
    //! runtextmacro LinkToStruct("Missile", "GoToUnit")
    //! runtextmacro LinkToStruct("Missile", "Id")
    //! runtextmacro LinkToStruct("Missile", "Position")

    //! runtextmacro CreateAnyStaticState("TRIGGER", "Trigger", "thistype")

    //! runtextmacro CreateAnyState("data", "Data", "integer")

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

                call thistype.SetTrigger(this)

                call this.Event.Get(thistype.DESTROY_EVENT_TYPE, priority, iteration2).Run()

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration - 1
        endloop
    endmethod

    method Destroy takes nothing returns nothing
        call this.Destroy_TriggerEvents()

        call this.deallocate()
    endmethod

    static method Create takes integer dummyUnitId, real x, real y, real z, real angle returns thistype
        local DummyUnit dummyUnit = DummyUnit.Create(dummyUnitId, x, y, z, angle)
        local thistype this = thistype.allocate()

        call this.CollisionSize.Event_Create()
        call this.Id.Event_Create()
        call this.Position.Event_Create()

        return this
    endmethod

    static method Init takes nothing returns nothing
        set thistype.DESTROY_EVENT_TYPE = EventType.Create()

        call thistype(NULL).FromSpotToSpot.Init()
        call thistype(NULL).FromSpotToUnit.Init()
        call thistype(NULL).FromUnitToSpot.Init()
        call thistype(NULL).FromUnitToUnit.Init()
    endmethod
endstruct