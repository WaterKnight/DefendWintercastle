//! runtextmacro Folder("Missile")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Struct("Boolean")
            //! runtextmacro Data_Type_Implement("ItemType", "Boolean", "boolean")
        endstruct

        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("ItemType", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("ItemType", "Integer", "integer")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Boolean")
        //! runtextmacro LinkToStruct("Data", "Integer")

        //! runtextmacro Data_Implement("ItemType")
    endstruct

    //! runtextmacro Struct("Event")
        //! runtextmacro CreateAnyStaticStateDefault("TRIGGER", "Trigger", "ItemType", "NULL")

        //! runtextmacro Event_Implement("ItemType")
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

        method Event_Create takes nothing returns nothing
            call this.X.Event_Create()
            call this.Y.Event_Create()
            call this.Z.Event_Create()
        endmethod
    endstruct

    //! runtextmacro Struct("FromSpotToSpot")
        static Event DESTROY_EVENT
        static Group ENUM_GROUP
        //! runtextmacro GetKey("KEY")
        //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "2")
        static Timer UPDATE_TIMER

        Trigger actionTrigger
        real collisionSize
        DummyUnit dummyUnit
        Timer durationTimer
        BoolExpr impactFilter
        real targetX
        real targetY
        real targetZ
        real xAdd
        real yAdd
        real zAdd

        method GetDummyUnit takes nothing returns DummyUnit
            return this.dummyUnit
        endmethod

        method Ending takes Timer durationTimer returns nothing
            local Trigger actionTrigger = this.actionTrigger
            local DummyUnit dummyUnit = this.dummyUnit

            call dummyUnit.Destroy()
            call durationTimer.Destroy()
            call Missile(this).Event.Remove(DESTROY_EVENT)
            if (this.RemoveFromForEachList()) then
                call UPDATE_TIMER.Pause()
            endif
        endmethod

        static method EndingByTimer takes nothing returns nothing
            local Timer durationTimer = Timer.GetExpired()

            local thistype this = durationTimer.GetData()

            call this.Ending(durationTimer)

            call Missile(this).Impact(actionTrigger, NULL)
        endmethod

        static method Event_Destroy takes nothing returns nothing
            local thistype this = Missile.GetTrigger()

            call this.Ending(this.durationTimer)
        endmethod

        static method Update takes nothing returns nothing
            local DummyUnit dummyUnit
            local BoolExpr impactFilter
            local Unit impactUnit
            local thistype this
            local real x
            local real y
            local real z

            call thistype.SetForEachList()

            loop
                set this = thistype.GetFromForEachList()

                exitwhen (this == NULL)

                set dummyUnit = this.dummyUnit
                set impactFilter = this.impactFilter
                set x = Missile(this).Position.X.Get() + this.xAdd
                set y = Missile(this).Position.Y.Get() + this.yAdd
                set z = Missile(this).Position.Z.Get() + this.zAdd

                call dummyUnit.Position.X.Set(x)
                call dummyUnit.Position.Y.Set(y)
                call dummyUnit.Position.Z.SetByCoords(x, y, z)
                call Missile(this).Position.X.Set(x)
                call Missile(this).Position.Y.Set(y)
                call Missile(this).Position.Z.Set(z)

                if (impactFilter != NULL) then
                    call Missile.SetTrigger(this)

                    call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, this.collisionSize, impactFilter)

                    set impactUnit = thistype.ENUM_GROUP.GetFirst()

                    if (impactUnit != NULL) then
                        call Missile(this).Impact(this.actionTrigger, impactUnit)
                    endif
                endif
            endloop
        endmethod

        method ImpactOnUnits takes BoolExpr whichFilter returns nothing
            set this.impactFilter = whichFilter
        endmethod

        method Start takes real sourceX, real sourceY, real sourceZ, real targetX, real targetY, real targetZ, integer dummyUnitId, real scale, real speed, real collisionSize, code actionFunction, integer data returns nothing
            local Trigger actionTrigger = Trigger.Create()
            local real dX = targetX - sourceX
            local real dY = targetY - sourceY
            local real dZ = targetZ - sourceZ
            local Timer durationTimer = Timer.Create()

            local real angle = Math.AtanByDeltas(dY, dX)
            local real d = Math.DistanceByDeltasWithZ(dX, dY, dZ)

            local real duration = (d - collisionSize) / speed

            local DummyUnit dummyUnit = DummyUnit.Create(dummyUnitId, sourceX, sourceY, sourceZ, angle)

            set this.actionTrigger = actionTrigger
            set this.collisionSize = collisionSize
            set this.dummyUnit = dummyUnit
            set this.durationTimer = durationTimer
            set this.impactFilter = NULL
            set this.targetX = targetX
            set this.targetY = targetY
            set this.targetZ = targetZ
            set this.xAdd = dX / d * speed * thistype.UPDATE_TIME
            set this.yAdd = dY / d * speed * thistype.UPDATE_TIME
            set this.zAdd = dZ / d * speed * thistype.UPDATE_TIME
            call actionTrigger.AddCode(actionFunction)
            call durationTimer.SetData(this)
            call Missile(this).SetData(data)
            call Missile(this).Event.Add(DESTROY_EVENT)

            call dummyUnit.SetScale(scale)
            call Missile(this).Position.X.Set(sourceX)
            call Missile(this).Position.Y.Set(sourceY)
            call Missile(this).Position.Z.Set(sourceZ)

            if (this.AddToList()) then
                call UPDATE_TIMER.Start(UPDATE_TIME, true, function thistype.Update)
            endif

            call durationTimer.Start(duration, false, function thistype.EndingByTimer)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DESTROY_EVENT = Event.Create(Missile.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
            set thistype.ENUM_GROUP = Group.Create()
            set thistype.UPDATE_TIMER = Timer.Create()
        endmethod
    endstruct

    //! runtextmacro Struct("FromSpotToUnit")
        static Event DEATH_EVENT
        static Event DESTROY_EVENT
        //! runtextmacro GetKey("KEY")
        //! runtextmacro GetKeyArray("KEY_ARRAY")
        //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "2")

        Trigger actionTrigger
        boolean cancelOnTargetDeath
        real collisionSize
        DummyUnit dummyUnit
        real length
        Timer moveTimer
        Unit target
        real targetX
        real targetY
        real targetZ

        method GetDummyUnit takes nothing returns DummyUnit
            return this.dummyUnit
        endmethod

        method ReleaseFromTarget takes Unit target returns nothing
            if (target.Data.Integer.Table.Remove(KEY_ARRAY, this)) then
                call target.Event.Remove(DEATH_EVENT)
                call target.Refs.Subtract()
            endif
        endmethod

        method Ending takes DummyUnit dummyUnit, Timer moveTimer, Unit target returns nothing
            call dummyUnit.Destroy()
            call moveTimer.Destroy()
            if (target != NULL) then
                call this.ReleaseFromTarget(target)
            endif
            call Missile(this).Event.Remove(DESTROY_EVENT)
        endmethod

        static method Event_Destroy takes nothing returns nothing
            local thistype this = Missile.GetTrigger()

            call this.Ending(this.dummyUnit, this.moveTimer, this.target)
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

            local DummyUnit dummyUnit = this.dummyUnit
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

            set reachesTarget = (d < length + this.collisionSize)

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

            call dummyUnit.Position.X.Set(x)
            call dummyUnit.Position.Y.Set(y)
            call dummyUnit.Position.Z.SetByCoords(x, y, z)
            call Missile(this).Position.X.Set(x)
            call Missile(this).Position.Y.Set(y)
            call Missile(this).Position.Z.Set(z)

            if (reachesTarget) then
                call this.Ending(dummyUnit, moveTimer, target)

                call Missile(this).Impact(this.actionTrigger, target)
            endif
        endmethod

        method Start takes real sourceX, real sourceY, real sourceZ, Unit target, integer dummyUnitId, real scale, real speed, real collisionSize, code actionFunction, boolean cancelOnTargetDeath, integer data returns nothing
            local Trigger actionTrigger = Trigger.Create()
            local Timer moveTimer = Timer.Create()
            local real targetX = target.Position.X.Get()
            local real targetY = target.Position.Y.Get()

            local real angle = Math.AtanByDeltas(targetY - sourceY, targetX - sourceX)

            local DummyUnit dummyUnit = DummyUnit.Create(dummyUnitId, sourceX, sourceY, sourceZ, angle)

            set this.actionTrigger = actionTrigger
            set this.cancelOnTargetDeath = cancelOnTargetDeath
            set this.collisionSize = collisionSize
            set this.dummyUnit = dummyUnit
            set this.length = speed * thistype.UPDATE_TIME
            set this.moveTimer = moveTimer
            set this.target = target
            call actionTrigger.AddCode(actionFunction)
            call moveTimer.SetData(this)
            if (target.Data.Integer.Table.Add(KEY_ARRAY, this)) then
                call target.Event.Add(DEATH_EVENT)
                call target.Refs.Add()
            endif
            call Missile(this).SetData(data)
            call Missile(this).Event.Add(DESTROY_EVENT)

            call dummyUnit.SetScale(scale)
            call Missile(this).Position.X.Set(sourceX)
            call Missile(this).Position.Y.Set(sourceY)
            call Missile(this).Position.Z.Set(sourceZ)

            call moveTimer.Start(thistype.UPDATE_TIME, true, function thistype.Move)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Death)
            set thistype.DESTROY_EVENT = Event.Create(Missile.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
        endmethod
    endstruct

    //! runtextmacro Struct("FromUnitToSpot")
        static Event DESTROY_EVENT
        static Group ENUM_GROUP
        //! runtextmacro GetKey("KEY")
        //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "1")
        static Timer UPDATE_TIMER

        Trigger actionTrigger
        real collisionSize
        DummyUnit dummyUnit
        Timer durationTimer
        BoolExpr impactFilter
        real targetX
        real targetY
        real targetZ
        real xAdd
        real xAddAdd
        real yAdd
        real yAddAdd
        real zAdd
        real zAddAdd

        method GetDummyUnit takes nothing returns DummyUnit
            return this.dummyUnit
        endmethod

        method Ending takes Timer durationTimer returns nothing
            local Trigger actionTrigger = this.actionTrigger
            local DummyUnit dummyUnit = this.dummyUnit

            call dummyUnit.Destroy()
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

            call Missile(this).Impact(actionTrigger, NULL)
        endmethod

        static method Event_Destroy takes nothing returns nothing
            local thistype this = Missile.GetTrigger()

            call this.Ending(this.durationTimer)
        endmethod

        static method Update takes nothing returns nothing
            local DummyUnit dummyUnit
            local BoolExpr impactFilter
            local Unit impactUnit
            local thistype this
            local real x
            local real xAdd
            local real y
            local real yAdd
            local real z
            local real zAdd

            call thistype.SetForEachList()

            loop
                set this = thistype.GetFromForEachList()

                exitwhen (this == NULL)

                set dummyUnit = this.dummyUnit
                set impactFilter = this.impactFilter
                set xAdd = this.xAdd
                set yAdd = this.yAdd
                set zAdd = this.zAdd

                set x = Missile(this).Position.X.Get() + xAdd
                set y = Missile(this).Position.Y.Get() + yAdd
                set z = Missile(this).Position.Z.Get() + zAdd

                set this.xAdd = xAdd + this.xAddAdd
                set this.yAdd = yAdd + this.yAddAdd
                set this.zAdd = zAdd + this.zAddAdd
                call dummyUnit.Position.X.Set(x)
                call dummyUnit.Position.Y.Set(y)
                call dummyUnit.Position.Z.SetByCoords(x, y, z)
                call Missile(this).Position.X.Set(x)
                call Missile(this).Position.Y.Set(y)
                call Missile(this).Position.Z.Set(z)

                if (impactFilter != NULL) then
                    call Missile.SetTrigger(this)

                    call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, this.collisionSize, impactFilter)

                    set impactUnit = thistype.ENUM_GROUP.GetFirst()

                    if (impactUnit != NULL) then
                        call Missile(this).Impact(this.actionTrigger, impactUnit)
                    endif
                endif
            endloop
        endmethod

        method ImpactOnUnits takes BoolExpr whichFilter returns nothing
            set this.impactFilter = whichFilter
        endmethod

        method SetAcceleration takes real value returns nothing
            local real dX = this.xAdd
            local real dY = this.yAdd
            local real dZ = this.zAdd
            local real speed

            local real d = Math.DistanceByDeltasWithZ(dX, dY, dZ)

            if (d == 0.) then
                return
            endif

            set speed = d / thistype.UPDATE_TIME
            set this.xAddAdd = dX / d * value * thistype.UPDATE_TIME * thistype.UPDATE_TIME
            set this.yAddAdd = dY / d * value * thistype.UPDATE_TIME * thistype.UPDATE_TIME
            set this.zAddAdd = dZ / d * value * thistype.UPDATE_TIME * thistype.UPDATE_TIME

            set d = Math.DistanceByDeltasWithZ(this.targetX - Missile(this).Position.X.Get(), this.targetY - Missile(this).Position.Y.Get(), this.targetZ - Missile(this).Position.Z.Get())

            call durationTimer.Start(Math.GetMovementDuration(Math.Max(0., d - this.collisionSize), speed, value), false, function thistype.EndingByTimer)
        endmethod

        method StartWithAcceleration takes Unit source, real targetX, real targetY, real targetZ, integer dummyUnitId, real scale, real speed, real acceleration, real collisionSize, code actionFunction, integer data returns nothing
            local Trigger actionTrigger = Trigger.Create()
            local Timer durationTimer = Timer.Create()
            local real sourceX = source.Position.X.Get()
            local real sourceY = source.Position.Y.Get()

            local real dX = targetX - sourceX
            local real dY = targetY - sourceY
            local real sourceZ = source.Position.Z.GetByCoords(sourceX, sourceY) + source.Outpact.Z.Get(true)

            local real angle = source.CastAngle(dX, dY)
            local real dZ = targetZ - sourceZ

            local real d = Math.DistanceByDeltasWithZ(dX, dY, dZ)
            local real duration = Math.GetMovementDuration(Math.Max(0., d - collisionSize), speed, acceleration)

            local DummyUnit dummyUnit = DummyUnit.Create(dummyUnitId, sourceX, sourceY, sourceZ, angle)
            local real xPart = dX / d
            local real yPart = dY / d
            local real zPart = dZ / d

            set this.actionTrigger = actionTrigger
            set this.collisionSize = collisionSize
            set this.dummyUnit = dummyUnit
            set this.durationTimer = durationTimer
            set this.impactFilter = NULL
            set this.targetX = targetX
            set this.targetY = targetY
            set this.targetZ = targetZ
            set this.xAdd = xPart * speed * thistype.UPDATE_TIME
            set this.yAdd = yPart * speed * thistype.UPDATE_TIME
            set this.zAdd = zPart * speed * thistype.UPDATE_TIME
            set this.xAddAdd = xPart * acceleration * thistype.UPDATE_TIME * thistype.UPDATE_TIME
            set this.yAddAdd = yPart * acceleration * thistype.UPDATE_TIME * thistype.UPDATE_TIME
            set this.zAddAdd = zPart * acceleration * thistype.UPDATE_TIME * thistype.UPDATE_TIME
            call actionTrigger.AddCode(actionFunction)
            call durationTimer.SetData(this)
            call Missile(this).SetData(data)
            call Missile(this).Event.Add(DESTROY_EVENT)

            call dummyUnit.SetScale(scale)
            call Missile(this).Position.X.Set(sourceX)
            call Missile(this).Position.Y.Set(sourceY)
            call Missile(this).Position.Z.Set(sourceZ)

            if (this.AddToList()) then
                call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.Update)
            endif

            call durationTimer.Start(duration, false, function thistype.EndingByTimer)
        endmethod

        method Start takes Unit source, real targetX, real targetY, real targetZ, integer dummyUnitId, real scale, real speed, real collisionSize, code actionFunction, integer data returns nothing
            call this.StartWithAcceleration(source, targetX, targetY, targetZ, dummyUnitId, scale, speed, 0., collisionSize, actionFunction, data)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DESTROY_EVENT = Event.Create(Missile.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
            set thistype.ENUM_GROUP = Group.Create()
            set thistype.UPDATE_TIMER = Timer.Create()
        endmethod
    endstruct

    //! runtextmacro Struct("FromUnitToUnit")
        static Event DEATH_EVENT
        static Event DESTROY_EVENT
        //! runtextmacro GetKey("KEY")
        //! runtextmacro GetKeyArray("KEY_ARRAY")
        //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "2")

        Trigger actionTrigger
        boolean cancelOnTargetDeath
        real collisionSize
        DummyUnit dummyUnit
        real length
        Timer moveTimer
        Unit target
        real targetX
        real targetY
        real targetZ

        method GetDummyUnit takes nothing returns DummyUnit
            return this.dummyUnit
        endmethod

        method ReleaseFromTarget takes Unit target returns nothing
            if (target.Data.Integer.Table.Remove(KEY_ARRAY, this)) then
                call target.Event.Remove(DEATH_EVENT)
                call target.Refs.Subtract()
            endif
        endmethod

        method Ending takes DummyUnit dummyUnit, Timer moveTimer, Unit target returns nothing
            call dummyUnit.Destroy()
            call moveTimer.Destroy()
            if (target != NULL) then
                call this.ReleaseFromTarget(target)
            endif
            call Missile(this).Event.Remove(DESTROY_EVENT)
        endmethod

        static method Event_Destroy takes nothing returns nothing
            local thistype this = Missile.GetTrigger()

            call this.Ending(this.dummyUnit, this.moveTimer, this.target)
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

            local DummyUnit dummyUnit = this.dummyUnit
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

            set reachesTarget = (d < length + this.collisionSize)

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

            call dummyUnit.Position.X.Set(x)
            call dummyUnit.Position.Y.Set(y)
            call dummyUnit.Position.Z.SetByCoords(x, y, z)
            call Missile(this).Position.X.Set(x)
            call Missile(this).Position.Y.Set(y)
            call Missile(this).Position.Z.Set(z)

            if (reachesTarget) then
                call this.Ending(dummyUnit, moveTimer, target)

                call Missile(this).Impact(this.actionTrigger, target)
            endif
        endmethod

        method Start takes Unit source, Unit target, integer dummyUnitId, real scale, real speed, real collisionSize, code actionFunction, boolean cancelOnTargetDeath, integer data returns nothing
            local Trigger actionTrigger = Trigger.Create()
            local real sourceX = source.Position.X.Get()
            local real sourceY = source.Position.Y.Get()
            local Timer moveTimer = Timer.Create()
            local real targetX = target.Position.X.Get()
            local real targetY = target.Position.Y.Get()

            local real angle = source.CastAngle(targetX - sourceX, targetY - sourceY)
            local real sourceZ = source.Position.Z.GetByCoords(sourceX, sourceY) + source.Outpact.Z.Get(true)

            local DummyUnit dummyUnit = DummyUnit.Create(dummyUnitId, sourceX, sourceY, sourceZ, angle)

            set this.actionTrigger = actionTrigger
            set this.cancelOnTargetDeath = cancelOnTargetDeath
            set this.collisionSize = collisionSize
            set this.dummyUnit = dummyUnit
            set this.length = speed * UPDATE_TIME
            set this.moveTimer = moveTimer
            set this.target = target
            call actionTrigger.AddCode(actionFunction)
            call moveTimer.SetData(this)
            if (target.Data.Integer.Table.Add(KEY_ARRAY, this)) then
                call target.Event.Add(DEATH_EVENT)
                call target.Refs.Add()
            endif
            call Missile(this).SetData(data)
            call Missile(this).Event.Add(DESTROY_EVENT)

            call dummyUnit.SetScale(scale)
            call Missile(this).Position.X.Set(sourceX)
            call Missile(this).Position.Y.Set(sourceY)
            call Missile(this).Position.Z.Set(sourceZ)

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

    //! runtextmacro LinkToStruct("Missile", "Data")
    //! runtextmacro LinkToStruct("Missile", "Event")
    //! runtextmacro LinkToStruct("Missile", "FromSpotToSpot")
    //! runtextmacro LinkToStruct("Missile", "FromSpotToUnit")
    //! runtextmacro LinkToStruct("Missile", "FromUnitToSpot")
    //! runtextmacro LinkToStruct("Missile", "FromUnitToUnit")
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

    method Impact takes Trigger action, Unit targetUnit returns nothing
        call UNIT.Event.SetTrigger(targetUnit)
        call thistype.SetTrigger(this)

        call action.Run()
    endmethod

    static method Create takes nothing returns thistype
        local thistype this = thistype.allocate()

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