//! runtextmacro BaseStruct("TranslationAccelerated", "TRANSLATION_ACCELERATED")
    static Event DEATH_EVENT
    static Event DESTROY_EVENT
    //! runtextmacro GetKey("KEY")
    //! runtextmacro GetKeyArray("KEY_ARRAY")
    //! runtextmacro CreateTimeByFramesAmount("UPDATE_TIME", "4")
    static Timer UPDATE_TIMER

    Timer durationTimer
    Unit target
    real xAdd
    real xAddAdd
    real yAdd
    real yAddAdd
    real zAdd
    real zAddAdd

	//! runtextmacro Id_Implement("TranslationAccelerated")
	//! runtextmacro Data_Implement2("TranslationAccelerated")

    timerMethod Update
        local integer iteration = thistype.ALL_COUNT

        loop
            local thistype this = thistype.ALL[iteration]

            local Unit target = this.target
            local real xAdd = this.xAdd + this.xAddAdd
            local real yAdd = this.yAdd + this.yAddAdd
            local real zAdd = this.zAdd + this.zAddAdd

            set this.xAdd = xAdd
            set this.yAdd = yAdd
            set this.zAdd = zAdd

            call target.Position.X.Add(xAdd)
            call target.Position.Y.Add(yAdd)
            call target.Position.Z.Add(zAdd)

            set iteration = iteration - 1
            exitwhen (iteration < ARRAY_MIN)
        endloop
    endmethod

    destroyMethod Destroy
    	local Unit target = this.target

        call this.durationTimer.Destroy()
        if target.Data.Integer.Table.Remove(KEY_ARRAY, this) then
            call target.Event.Remove(DEATH_EVENT)
            call target.Event.Remove(DESTROY_EVENT)
        endif
        if this.RemoveFromList() then
            call thistype.UPDATE_TIMER.Pause()
        endif

		//call this.deallocate()

		call target.Position.Nudge()
    endmethod

	static method EndAllOfTarget takes Unit target
        local integer iteration = target.Data.Integer.Table.Count(KEY_ARRAY)

        loop
            local thistype this = target.Data.Integer.Table.Get(KEY_ARRAY, iteration)

            call this.Destroy()

            set iteration = iteration - 1
            exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
        endloop
	endmethod

    eventMethod Event_Death
		call thistype.EndAllOfTarget(params.Unit.GetTrigger())
    endmethod

    eventMethod Event_Destroy
		call thistype.EndAllOfTarget(params.Unit.GetTrigger())
    endmethod

    timerMethod DestroyByTimer
        local thistype this = Timer.GetExpired().GetData()

        call this.Destroy()
    endmethod

    static method CreateIn takes Unit target, real xAdd, real yAdd, real zAdd, real xAddAdd, real yAddAdd, real zAddAdd, real duration returns thistype
        if not Translation.ValidTarget(target) then
            return NULL
        endif

        local integer wavesAmount = Math.MaxI(1, Real.ToInt(duration / thistype.UPDATE_TIME + 0.5))

        local thistype this = thistype.allocate()

		local Timer durationTimer = Timer.Create()

        set this.durationTimer = durationTimer
        set this.target = target
        set this.xAdd = xAdd / wavesAmount
        set this.xAddAdd = xAddAdd / wavesAmount * thistype.UPDATE_TIME
        set this.yAdd = yAdd / wavesAmount
        set this.yAddAdd = yAddAdd / wavesAmount * thistype.UPDATE_TIME
        set this.zAdd = zAdd / wavesAmount
        set this.zAddAdd = zAddAdd / wavesAmount * thistype.UPDATE_TIME

        call durationTimer.SetData(this)
        if target.Data.Integer.Table.Add(KEY_ARRAY, this) then
            call target.Event.Add(DEATH_EVENT)
            call target.Event.Add(DESTROY_EVENT)
        endif

        if this.AddToList() then
            call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.Update)
        endif

        call durationTimer.Start(duration, false, function thistype.DestroyByTimer)
    endmethod

    static method CreateForNoCheck takes Unit target, real xAdd, real yAdd, real zAdd, real xAddAdd, real yAddAdd, real zAddAdd, real duration returns thistype
        local thistype this = thistype.allocate()

		local Timer durationTimer = Timer.Create()

        set this.durationTimer = durationTimer
        set this.target = target
        set this.xAdd = xAdd
        set this.xAddAdd = xAddAdd
        set this.yAdd = yAdd
        set this.yAddAdd = yAddAdd
        set this.zAdd = zAdd
        set this.zAddAdd = zAddAdd
        call durationTimer.SetData(this)
        if target.Data.Integer.Table.Add(KEY_ARRAY, this) then
            call target.Event.Add(DEATH_EVENT)
            call target.Event.Add(DESTROY_EVENT)
        endif

        if this.AddToList() then
            call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.Update)
        endif

        call durationTimer.Start(duration, false, function thistype.DestroyByTimer)

		return this
    endmethod

    static method CreateFor takes Unit target, real xAdd, real yAdd, real zAdd, real xAddAdd, real yAddAdd, real zAddAdd, real duration returns thistype
        if not Translation.ValidTarget(target) then
            return NULL
        endif

		return thistype.CreateForNoCheck(target, xAdd, yAdd, zAdd, xAddAdd, yAddAdd, zAddAdd, duration)
    endmethod

    static method CreateForMundane takes Unit target, real xSpeed, real ySpeed, real zSpeed, real xAcc, real yAcc, real zAcc, real duration returns thistype
        if not Translation.ValidTarget(target) then
            return NULL
        endif

		return thistype.CreateForNoCheck(target, xSpeed * thistype.UPDATE_TIME, ySpeed * thistype.UPDATE_TIME, zSpeed * thistype.UPDATE_TIME, xAcc * thistype.UPDATE_TIME * thistype.UPDATE_TIME, yAcc * thistype.UPDATE_TIME * thistype.UPDATE_TIME, zAcc * thistype.UPDATE_TIME * thistype.UPDATE_TIME, duration)
    endmethod

    static method CreateSpeedDirection takes Unit target, real speed, real acceleration, real angle, real duration returns thistype
        local real xPart = Math.Cos(angle)
        local real yPart = Math.Sin(angle)

        set acceleration = acceleration * thistype.UPDATE_TIME * thistype.UPDATE_TIME
        set speed = speed * thistype.UPDATE_TIME

        return thistype.CreateFor(target, speed * xPart, speed * yPart, 0., acceleration * xPart, acceleration * yPart, 0., duration)
    endmethod

    static method Init
        set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Death)
        set thistype.DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
        set thistype.UPDATE_TIMER = Timer.Create()
    endmethod
endstruct

//! runtextmacro BaseStruct("Translation", "TRANSLATION")
    static Event DEATH_EVENT
    static Event DESTROY_EVENT
    //! runtextmacro GetKey("KEY")
    //! runtextmacro GetKeyArray("KEY_ARRAY")
    //! runtextmacro CreateTimeByFramesAmount("UPDATE_TIME", "4")
    static Timer UPDATE_TIMER

    Timer durationTimer
    Unit target
    real xAdd
    real yAdd
    real zAdd

	//! runtextmacro Id_Implement("Translation")
	//! runtextmacro Data_Implement2("Translation")

    timerMethod Update
        local integer iteration = thistype.ALL_COUNT

        loop
            local thistype this = thistype.ALL[iteration]

            local Unit target = this.target

            call target.Position.X.Add(this.xAdd)
            call target.Position.Y.Add(this.yAdd)
            call target.Position.Z.Add(this.zAdd)

            set iteration = iteration - 1
            exitwhen (iteration < ARRAY_MIN)
        endloop
    endmethod

    destroyMethod Destroy
    	local Unit target = this.target

        call durationTimer.Destroy()
        if target.Data.Integer.Table.Remove(KEY_ARRAY, this) then
            call target.Event.Remove(DEATH_EVENT)
            call target.Event.Remove(DESTROY_EVENT)
        endif
        if this.RemoveFromList() then
            call thistype.UPDATE_TIMER.Pause()
        endif

		//call this.deallocate()

        call target.Position.Nudge()
    endmethod

	static method EndAllOfTarget takes Unit target
        local integer iteration = target.Data.Integer.Table.Count(KEY_ARRAY)

        loop
            local thistype this = target.Data.Integer.Table.Get(KEY_ARRAY, iteration)

            call this.Destroy()

            set iteration = iteration - 1
            exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
        endloop
	endmethod

    eventMethod Event_Death
		call thistype.EndAllOfTarget(params.Unit.GetTrigger())
    endmethod

    eventMethod Event_Destroy
		call thistype.EndAllOfTarget(params.Unit.GetTrigger())
    endmethod

    timerMethod DestroyByTimer
        local thistype this = Timer.GetExpired().GetData()

        call this.Destroy()
    endmethod

    static method ValidTarget takes Unit target returns boolean
        if (target.Type.Get().Speed.Get() <= 0.) then
            return false
        endif

        return true
    endmethod

    static method CreateNoCheck takes Unit target, real xAdd, real yAdd, real zAdd, real duration returns thistype
        local integer wavesAmount = Real.ToInt(duration / thistype.UPDATE_TIME)

        local thistype this = thistype.allocate()

		local Timer durationTimer = Timer.Create()

        set this.durationTimer = durationTimer
        set this.target = target
        set this.xAdd = xAdd / wavesAmount
        set this.yAdd = yAdd / wavesAmount
        set this.zAdd = zAdd / wavesAmount
        call durationTimer.SetData(this)
        if target.Data.Integer.Table.Add(KEY_ARRAY, this) then
            call target.Event.Add(DEATH_EVENT)
            call target.Event.Add(DESTROY_EVENT)
        endif

        if this.AddToList() then
            call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.Update)
        endif

        call durationTimer.Start(duration, false, function thistype.DestroyByTimer)

		return this
    endmethod

    static method Create takes Unit target, real xAdd, real yAdd, real zAdd, real duration returns thistype
        if not thistype.ValidTarget(target) then
            return NULL
        endif

        return thistype.CreateNoCheck(target, xAdd, yAdd, zAdd, duration)
    endmethod

    static method CreateSpeedDirection takes Unit target, real speed, real angle, real duration returns thistype
        //set speed = speed * thistype.UPDATE_TIME

        return thistype.Create(target, speed * Math.Cos(angle), speed * Math.Sin(angle), 0., duration)
    endmethod

    static method CreateTo takes Unit target, real x, real y, real z, real duration
        call thistype.Create(target, x - target.Position.X.Get(), y - target.Position.Y.Get(), z - target.Position.Z.Get(), duration)
    endmethod

    static method CreateToXY takes Unit target, real x, real y, real duration
        call thistype.CreateTo(target, x, y, Spot.GetHeight(x, y) + target.Position.Z.GetFlyHeight(), duration)
    endmethod

    static method Init
        set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Death)
        set thistype.DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.HEADER, function thistype.Event_Destroy)
        set thistype.UPDATE_TIMER = Timer.Create()

        call TranslationAccelerated.Init()
        call Knockback.Init()
    endmethod
endstruct