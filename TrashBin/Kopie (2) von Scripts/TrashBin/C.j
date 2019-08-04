//! runtextmacro Struct("GoToSpot")
    static Event DESTROY_EVENT
    //! runtextmacro GetKey("KEY")
    //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "2")
    static Timer UPDATE_TIMER

    Timer durationTimer
    real targetX
    real targetY
    real targetZ
    real xAdd
    real xAddAdd
    real yAdd
    real yAddAdd
    real zAdd
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

    method StartWithAcceleration takes Unit source, real targetX, real targetY, real targetZ, integer data returns nothing
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

        local real xPart = dX / d
        local real yPart = dY / d
        local real zPart = dZ / d

        set this.durationTimer = durationTimer
        set this.targetX = targetX
        set this.targetY = targetY
        set this.targetZ = targetZ
        set this.xAdd = xPart * speed * thistype.UPDATE_TIME
        set this.yAdd = yPart * speed * thistype.UPDATE_TIME
        set this.zAdd = zPart * speed * thistype.UPDATE_TIME
        set this.xAddAdd = xPart * acceleration * thistype.UPDATE_TIME * thistype.UPDATE_TIME
        set this.yAddAdd = yPart * acceleration * thistype.UPDATE_TIME * thistype.UPDATE_TIME
        set this.zAddAdd = zPart * acceleration * thistype.UPDATE_TIME * thistype.UPDATE_TIME
        call durationTimer.SetData(this)
        call Missile(this).SetData(data)
        call Missile(this).Event.Add(DESTROY_EVENT)

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
        set thistype.UPDATE_TIMER = Timer.Create()
    endmethod
endstruct