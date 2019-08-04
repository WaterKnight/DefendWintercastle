//! runtextmacro Folder("CameraField")
    //! runtextmacro Struct("Timed")
        //! runtextmacro GetKeyArray("KEY_ARRAY_DETAIL")
        //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "1")
        static Timer UPDATE_TIMER

        Timer durationTimer
        CameraField parent
        real remainingWavesAmount
        real value
        User whichPlayer

        method Ending takes Timer durationTimer, CameraField parent, User whichPlayer returns nothing
            call this.deallocate()
            call durationTimer.Destroy()
            if this.RemoveFromList() then
                call thistype.UPDATE_TIMER.Pause()
            endif
            call whichPlayer.Data.Integer.Remove(KEY_ARRAY_DETAIL + parent)
        endmethod

        static method EndingByTimer takes nothing returns nothing
            local Timer durationTimer = Timer.GetExpired()

            local thistype this = durationTimer.GetData()

            local CameraField parent = this.parent
            local real value = this.value
            local User whichPlayer = this.whichPlayer

            call this.Ending(durationTimer, parent, whichPlayer)

            call parent.Set(whichPlayer, value)
        endmethod

        static method Update takes nothing returns nothing
            local integer iteration = thistype.ALL_COUNT

            loop
                local thistype this = thistype.ALL[iteration]

                local CameraField parent = this.parent
                local real remainingWavesAmount = this.remainingWavesAmount

                local real oldValue = parent.Get()

                set this.remainingWavesAmount = remainingWavesAmount - 1
                call parent.Set(this.whichPlayer, oldValue + (this.value - oldValue) / remainingWavesAmount)

                set iteration = iteration - 1
                exitwhen (iteration < ARRAY_MIN)
            endloop
        endmethod

        method Set takes User whichPlayer, real value, real duration returns nothing
            local CameraField parent = this

            set this = whichPlayer.Data.Integer.Get(KEY_ARRAY_DETAIL + parent)

            if (this != NULL) then
                call this.Ending(this.durationTimer, parent, whichPlayer)
            endif

            set this = thistype.allocate()

			local Timer durationTimer = Timer.Create()

            set this.durationTimer = durationTimer
            set this.parent = parent
            set this.remainingWavesAmount = duration / thistype.UPDATE_TIME
            set this.value = value
            set this.whichPlayer = whichPlayer
            call durationTimer.SetData(this)
            call whichPlayer.Data.Integer.Set(KEY_ARRAY_DETAIL + parent, this)

            if this.AddToList() then
                call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.Update)
            endif

            call durationTimer.Start(duration, false, function thistype.EndingByTimer)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.UPDATE_TIMER = Timer.Create()
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("CameraField", "CAMERA_FIELD")
    static thistype FAR_Z
    static thistype FIELD_OF_VIEW
    static thistype PITCH
    static thistype ROLL
    static thistype TARGET_DISTANCE
    static thistype YAW
    static thistype Z

    camerafield self

    //! runtextmacro LinkToStruct("CameraField", "Timed")

    //! runtextmacro CreateSimpleAddState_OnlyGet("real")

    method Set takes User whichPlayer, real value returns nothing
        if whichPlayer.IsLocal() then
            set this.value = value
            call SetCameraField(this.self, value, 0.)
        endif
    endmethod

    static method Create takes camerafield self returns thistype
        local thistype this = thistype.allocate()

        set this.self = self

        return this
    endmethod

    static method Init takes nothing returns nothing
        call thistype(NULL).Timed.Init()

        //Far Z
        set thistype.FAR_Z = thistype.Create(CAMERA_FIELD_FARZ)

        //Field of View
        set thistype.FIELD_OF_VIEW = thistype.Create(CAMERA_FIELD_FIELD_OF_VIEW)

        //Pitch
        set thistype.PITCH = thistype.Create(CAMERA_FIELD_ANGLE_OF_ATTACK)

        //Roll
        set thistype.ROLL = thistype.Create(CAMERA_FIELD_ROLL)

        //Target Distance
        set thistype.TARGET_DISTANCE = thistype.Create(CAMERA_FIELD_TARGET_DISTANCE)

        //Yaw
        set thistype.YAW = thistype.Create(CAMERA_FIELD_ROTATION)

        //Z
        set thistype.Z = thistype.Create(CAMERA_FIELD_ZOFFSET)
    endmethod
endstruct

//! runtextmacro Folder("Camera")
    //! runtextmacro Struct("Eye")
        static method GetX takes nothing returns real
            return GetCameraEyePositionX()
        endmethod

        static method GetY takes nothing returns real
            return GetCameraEyePositionY()
        endmethod

        static method GetZ takes nothing returns real
            return GetCameraEyePositionZ()
        endmethod
    endstruct

    //! runtextmacro Struct("Target")
        static method GetX takes nothing returns real
            return GetCameraTargetPositionX()
        endmethod

        static method GetY takes nothing returns real
            return GetCameraTargetPositionY()
        endmethod

        static method GetZ takes nothing returns real
            return GetCameraTargetPositionZ()
        endmethod
    endstruct
    
    //! runtextmacro Struct("PanTimedViaBounds")
    	//! runtextmacro CreateList("ACTIVE_LIST")
    	//! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "1")
    	static Timer UPDATE_TIMER

		Timer durationTimer
		boolean running
    	real xAdd
    	real yAdd
    	
    	static method EndingByTimer takes nothing returns nothing
    		local thistype this = Timer.GetExpired().GetData()

			local User whichPlayer = this

    		set this.running = false
    		
    		if thistype.ACTIVE_LIST_Remove(this) then
    			call thistype.UPDATE_TIMER.Pause()
    		endif
    		
    		call Camera.UpdateBounds(whichPlayer)
    	endmethod
    	
    	static code UPDATE_ALL_FUNC
    	
    	timerMethod UpdateReset
    		local integer i = thistype.ACTIVE_LIST_ALL_COUNT

    		loop
    			exitwhen (i < ARRAY_MIN)
    			
    			local thistype this = thistype.ACTIVE_LIST_ALL[i]
    			
    			local User whichPlayer = this
    			
    			if whichPlayer.IsLocal() then
    				call Camera.UpdateBounds(whichPlayer)
    			endif
    			
    			set i = i - 1
    		endloop
    		
    		call Timer.GetExpired().Start(0.03, false, thistype.UPDATE_ALL_FUNC)
    	endmethod
    	
    	timerMethod UpdateAll
    		local integer i = thistype.ACTIVE_LIST_ALL_COUNT
    		
    		loop
    			exitwhen (i < ARRAY_MIN)
    			
    			local thistype this = thistype.ACTIVE_LIST_ALL[i]
    			
    			local User whichPlayer = this
    			
    			local real xAdd = this.xAdd
    			local real yAdd = this.yAdd

                local real x = CAMERA.Target.GetX() + xAdd
                local real y = CAMERA.Target.GetY() + yAdd
                
                if whichPlayer.IsLocal() then
                    if whichPlayer.KeyEvent.LeftArrow.IsPressing() then
                        set x = x - 6000 * thistype.UPDATE_TIME
                        //call DebugEx("left")
                    endif
                    if whichPlayer.KeyEvent.RightArrow.IsPressing() then
                        set x = x + 6000 * thistype.UPDATE_TIME
                        //call DebugEx("right")
                    endif
                    if whichPlayer.KeyEvent.DownArrow.IsPressing() then
                        set y = y - 6000 * thistype.UPDATE_TIME
                        //call DebugEx("down")
                    endif
                    if whichPlayer.KeyEvent.UpArrow.IsPressing() then
                        set y = y + 6000 * thistype.UPDATE_TIME
                        //call DebugEx("up")
                    endif

                	//call SetCameraPosition(x, y)
                endif
                
                if whichPlayer.IsLocal() then
                	call SetCameraBounds(x, y, x, y, x, y, x, y)
                endif
                
                set i = i - 1
    		endloop
    		
    		call Timer.GetExpired().Start(0.03, false, function thistype.UpdateReset)
    	endmethod
    	
    	static method Start takes User whichPlayer, real x, real y, real duration returns nothing
    		local real dX = x - CAMERA.Target.GetX()
    		local real dY = y - CAMERA.Target.GetY()
    		
    		local thistype this = whichPlayer

    		set this.xAdd = dX * thistype.UPDATE_TIME / duration
    		set this.yAdd = dY * thistype.UPDATE_TIME / duration
    		//call DebugEx("start shake with "+R2S(duration))
    		call this.durationTimer.Start(duration, false, function thistype.EndingByTimer)
    		
    		if this.running then
                return
            endif
    		
    		set this.running = true
    		
    		if thistype.ACTIVE_LIST_Add(this) then
    			call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.UpdateAll)
    		endif
    	endmethod
    	
    	enumMethod InitPlayer
    		local User whichPlayer = params.User.GetTrigger()
    		
    		local thistype this = whichPlayer

			local Timer durationTimer = Timer.Create()

			set this.durationTimer = durationTimer
			set this.running = false
			call durationTimer.SetData(this)
    	endmethod
    	
    	static method Init takes nothing returns nothing
    		set thistype.UPDATE_ALL_FUNC = function thistype.UpdateAll
    		set thistype.UPDATE_TIMER = Timer.Create()
    		
    		call Force.ALL_USERS.Do(function thistype.InitPlayer, NULL)
    	endmethod
    endstruct
    
    //! runtextmacro Struct("Shake")
    	//! runtextmacro CreateList("ACTIVE_LIST")
    	//! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "2")
    	static Timer UPDATE_TIMER
    	
    	real cur
    	real power
    	real powerAdd
    	real xAdd
    	real yAdd
    	
    	timerMethod UpdateAll
    		local integer i = thistype.ACTIVE_LIST_ALL_COUNT
    		
    		loop
    			exitwhen (i < ARRAY_MIN)
    			
    			local thistype this = thistype.ACTIVE_LIST_ALL[i]
    			
    			local User whichPlayer = this
    			
    			local real power = this.power + this.powerAdd
//call DebugEx("power "+R2S(power))
    			if (power < 1) then
                     call CAMERA.PanTimedViaBounds.Start(whichPlayer, CAMERA.Target.GetX() - this.xAdd, CAMERA.Target.GetY() - this.yAdd, 1.)
                     
                     set this.cur = 0.
                     set this.power = 0.
                     set this.xAdd = 0.
                     set this.yAdd = 0.
                     
                     if thistype.ACTIVE_LIST_Remove(this) then
					     call thistype.UPDATE_TIMER.Pause()
                     endif
                else
                    local real angle = Math.RandomAngle()
                    local real cur = this.cur + 0.9
                    
                    local real curSin = Math.Sin(cur)
                    
                    set this.cur = cur
                    set this.power = power
                    set this.xAdd = Math.Cos(angle) * curSin * power
                    set this.yAdd = Math.Sin(angle) * curSin * power
                    
                    call CAMERA.PanTimedViaBounds.Start(whichPlayer, CAMERA.Target.GetX() + this.xAdd, CAMERA.Target.GetY() + this.yAdd, 1.)
                endif
                
                set i = i - 1
    		endloop
    	endmethod
    	
    	static method Add takes User whichPlayer, real power, real duration returns nothing
    		local thistype this = whichPlayer
    		
    		set this.power = this.power + power
    		set this.powerAdd = this.powerAdd + (-power / duration * thistype.UPDATE_TIME)
    		
    		if thistype.ACTIVE_LIST_Add(this) then
    			call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.UpdateAll)
    		endif
    	endmethod
    	
    	enumMethod InitPlayer
    		local User whichPlayer = params.User.GetTrigger()

    		local thistype this = whichPlayer

    		set this.cur = 0.
    		set this.power = 0.
    		set this.powerAdd = 0.
    		set this.xAdd = 0.
    		set this.yAdd = 0.
    	endmethod
    	
    	static method Init takes nothing returns nothing
    		set thistype.UPDATE_TIMER = Timer.Create()
    		
    		call Force.ALL_USERS.Do(function thistype.InitPlayer, NULL)
    	endmethod
    endstruct
    
    //! runtextmacro Struct("Seismic")
    	//! runtextmacro CreateList("ACTIVE_LIST")
    	static GameCache SYNC_CACHE
    	//! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "4")
    	static Timer UPDATE_TIMER
    	
    	static boolean SYNCING = false
    	
    	Timer durationTimer
    	real falloff
    	real length
    	real lengthAdd
    	real powerMax
    	real powerMin
    	Force targetForce
    	real x
    	real y
    	real z
    	
    	method Ending takes nothing returns nothing
    		local Timer durationTimer = this.durationTimer
    		local Force targetForce = this.targetForce
    		
    		call durationTimer.Destroy()
    		call targetForce.Destroy()
    		
    		call this.deallocate()
    		
    		if thistype.ACTIVE_LIST_Remove(this) then
                call thistype.UPDATE_TIMER.Pause()
    		endif
    	endmethod
    	
    	static method EndingByTimer takes nothing returns nothing
    		local thistype this = Timer.GetExpired().GetData()
    		
    		call this.Ending()
    	endmethod
    	
    	static string array SYNC_X_KEYS
    	static string array SYNC_Y_KEYS
    	static string array SYNC_Z_KEYS
    	
    	static method UpdateAll_Exec takes nothing returns nothing
			local real eyeX = CAMERA.Eye.GetX()
			local real eyeY = CAMERA.Eye.GetY()
			local real eyeZ = CAMERA.Eye.GetZ()

    		local real array eyeXs
    		local real array eyeYs
    		local real array eyeZs
    		local real length
    		local thistype this
    		local User whichPlayer

			local string syncXKey
			local string syncYKey
			local string syncZKey

    		local integer i = thistype.ACTIVE_LIST_ALL_COUNT

    		loop
    			exitwhen (i < ARRAY_MIN)
    			
    			set this = thistype.ACTIVE_LIST_ALL[i]
    			
    			set length = this.length + this.lengthAdd 
    		
    			set this.length = length

    			set i = i - 1
    		endloop

    		if thistype.SYNCING then
                return
            endif

    		set i = User.PLAYING_HUMANS_COUNT 

    		loop
    			exitwhen (i < ARRAY_MIN)
    			
    			set whichPlayer = User.PLAYING_HUMANS[i]
    			
    			if whichPlayer.IsLocal() then
                	set syncXKey = SYNC_X_KEYS[whichPlayer]
                	set syncYKey = SYNC_Y_KEYS[whichPlayer]
                	set syncZKey = SYNC_Z_KEYS[whichPlayer]
                    
                    call thistype.SYNC_CACHE.Real.SetAndSync(syncXKey, syncXKey, CAMERA.Eye.GetX())
                    call thistype.SYNC_CACHE.Real.SetAndSync(syncYKey, syncYKey, CAMERA.Eye.GetY())                    
                    call thistype.SYNC_CACHE.Real.SetAndSync(syncZKey, syncZKey, CAMERA.Eye.GetZ())
                endif
    			
    			set i = i - 1
    		endloop

			set thistype.SYNCING = true

            call TriggerSyncStart()
            call TriggerSyncReady()

			set thistype.SYNCING = false

    		set i = User.PLAYING_HUMANS_COUNT
    		
    		loop
    			exitwhen (i < ARRAY_MIN)

				set whichPlayer = User.PLAYING_HUMANS[i]

                set syncXKey = SYNC_X_KEYS[whichPlayer]
                set syncYKey = SYNC_Y_KEYS[whichPlayer]
                set syncZKey = SYNC_Z_KEYS[whichPlayer]
                
                set eyeXs[whichPlayer] = thistype.SYNC_CACHE.Real.Get(syncXKey, syncXKey)
                set eyeYs[whichPlayer] = thistype.SYNC_CACHE.Real.Get(syncYKey, syncYKey)
                set eyeZs[whichPlayer] = thistype.SYNC_CACHE.Real.Get(syncZKey, syncZKey)
    			
    			set i = i - 1
    		endloop
    		
    		set i = thistype.ACTIVE_LIST_ALL_COUNT

    		loop
    			exitwhen (i < ARRAY_MIN)
    			
    			set this = thistype.ACTIVE_LIST_ALL[i]
    			
    			set length = this.length
    			
    			local integer playerIndex = User.PLAYING_HUMANS_COUNT
    			
    			loop
    				exitwhen (playerIndex < ARRAY_MIN)
    				
    				set whichPlayer = User.PLAYING_HUMANS[i]

    				if (this.targetForce.ContainsPlayer(whichPlayer) == false) then
    					set eyeX = eyeXs[whichPlayer]
    					set eyeY = eyeYs[whichPlayer]
    					set eyeZ = eyeZs[whichPlayer]
    				
    					local real camDist = Math.DistanceByDeltasWithZ(this.x - eyeX, this.y - eyeY, this.z - eyeZ) - length * length

    					if (camDist < this.falloff) then
                            //call this.targetForce.AddPlayer(whichPlayer)
                            
                        	call CAMERA.Shake.Add(User.PLAYING_HUMANS[whichPlayer], (1. - Math.Abs(camDist - length) / this.falloff) * (this.powerMin + (this.powerMax - this.powerMin) * (1 - length / this.falloff)), 5.)
                    	endif
                    endif
    				
    				set playerIndex = playerIndex - 1
    			endloop
    			
    			set i = i - 1
    		endloop
    	endmethod
    	
    	static trigger DUMMY_TRIGGER
    	
    	static method UpdateAll takes nothing returns nothing
    		call TriggerExecute(thistype.DUMMY_TRIGGER)
    	endmethod
    	
    	static method Create takes real x, real y, real z, real powerMax, real powerMin, real falloff, real speed returns nothing
    		local thistype this = thistype.allocate()

			local Timer durationTimer = Timer.Create()

			set this.durationTimer = durationTimer
			set this.falloff = falloff
			set this.length = 0.
			set this.lengthAdd = speed * thistype.UPDATE_TIME
			set this.powerMax = powerMax
			set this.powerMin = powerMin
			set this.targetForce = Force.Create()
    		set this.x = x
    		set this.y = y
    		set this.z = z
    		call durationTimer.SetData(this)

    		call durationTimer.Start(Math.GetMovementDuration(falloff, speed, 0.), false, function thistype.EndingByTimer)
    		
    		if thistype.ACTIVE_LIST_Add(this) then
                call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.UpdateAll)
            endif
    	endmethod
    	
    	static method Init takes nothing returns nothing
    		set thistype.DUMMY_TRIGGER = CreateTrigger()
    		set thistype.SYNC_CACHE = GameCache.Create()
    		set thistype.UPDATE_TIMER = Timer.Create()

			call TriggerAddAction(thistype.DUMMY_TRIGGER, function thistype.UpdateAll_Exec)

    		local integer i = User.PLAYING_HUMANS_COUNT
    		
    		loop
    			exitwhen (i < ARRAY_MIN)

				local User whichPlayer = User.PLAYING_HUMANS[i] 

				set SYNC_X_KEYS[whichPlayer] = "x" + Integer.ToString(whichPlayer)
				set SYNC_Y_KEYS[whichPlayer] = "y" + Integer.ToString(whichPlayer)
				set SYNC_Z_KEYS[whichPlayer] = "z" + Integer.ToString(whichPlayer) 
    			
    			set i = i - 1
    		endloop
    	endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Camera", "CAMERA")
    static real BOUNDS_X
    static real BOUNDS_X2
    static real BOUNDS_X3
    static real BOUNDS_X4
    static real BOUNDS_Y
    static real BOUNDS_Y2
    static real BOUNDS_Y3
    static real BOUNDS_Y4
    static integer LOCK_AMOUNT = 0

    camerasetup self

    //! runtextmacro LinkToStruct("Camera", "Eye")
    //! runtextmacro LinkToStruct("Camera", "PanTimedViaBounds")
    //! runtextmacro LinkToStruct("Camera", "Seismic")
    //! runtextmacro LinkToStruct("Camera", "Shake")
    //! runtextmacro LinkToStruct("Camera", "Target")

    method Apply takes boolean pan, real duration returns nothing
        call CameraSetupApplyForceDuration(this.self, pan, duration)
    endmethod

    static method Lock takes User whichPlayer returns nothing
        if whichPlayer.IsLocal() then
            set thistype.LOCK_AMOUNT = thistype.LOCK_AMOUNT + 1

            if (thistype.LOCK_AMOUNT == 1) then
                local real x = Target.GetX()
                local real y = Target.GetY()

                call SetCameraBounds(x, y, x, y, x, y, x, y)
            endif
        endif
    endmethod

    static method Unlock takes User whichPlayer returns nothing
        if whichPlayer.IsLocal() then
            set thistype.LOCK_AMOUNT = thistype.LOCK_AMOUNT - 1

            if (thistype.LOCK_AMOUNT == 0) then
                call SetCameraBounds(thistype.BOUNDS_X, thistype.BOUNDS_Y, thistype.BOUNDS_X2, thistype.BOUNDS_Y2, thistype.BOUNDS_X3, thistype.BOUNDS_Y3, thistype.BOUNDS_X4, thistype.BOUNDS_Y4)
            endif
        endif
    endmethod

    static method LockToDummyUnit takes User whichPlayer, DummyUnit whichUnit returns nothing
        if whichPlayer.IsLocal() then
            call SetCameraTargetController(whichUnit.self, 0., 0., false)
        endif
    endmethod

    static method UnlockFromUnit takes User whichPlayer returns nothing
        call thistype.Reset(whichPlayer, 0.)
    endmethod

    static method PanTimed takes User whichPlayer, real x, real y, real duration returns nothing
        if whichPlayer.IsLocal() then
            call PanCameraToTimed(x, y, duration)
        endif
    endmethod

    static method Reset takes User whichPlayer, real duration returns nothing
        if whichPlayer.IsLocal() then
            call ResetToGameCamera(duration)
        endif
    endmethod

	static method UpdateBounds takes User whichPlayer returns nothing
		if whichPlayer.IsLocal() then
			call SetCameraBounds(CAMERA.BOUNDS_X, CAMERA.BOUNDS_Y, CAMERA.BOUNDS_X2, CAMERA.BOUNDS_Y2, CAMERA.BOUNDS_X3, CAMERA.BOUNDS_Y3, CAMERA.BOUNDS_X4, CAMERA.BOUNDS_Y4)
		endif
	endmethod

    static method SetBounds takes User whichPlayer, real x, real y, real x2, real y2, real x3, real y3, real x4, real y4 returns nothing
        if whichPlayer.IsLocal() then
            set thistype.BOUNDS_X = x
            set thistype.BOUNDS_X2 = x2
            set thistype.BOUNDS_X3 = x3
            set thistype.BOUNDS_X4 = x4
            set thistype.BOUNDS_Y = y
            set thistype.BOUNDS_Y2 = y2
            set thistype.BOUNDS_Y3 = y3
            set thistype.BOUNDS_Y4 = y4

            call SetCameraBounds(x, y, x2, y2, x3, y3, x4, y4)
        endif
    endmethod

    static method SetSmoothing takes User whichPlayer, real value returns nothing
        if whichPlayer.IsLocal() then
            call CameraSetSmoothingFactor(value)
        endif
    endmethod

    static method CreateFromSelf takes camerasetup self returns thistype
        local thistype this = thistype.allocate()

        set this.self = self

        return this
    endmethod

    initMethod Init of Header_4
    	call thistype(NULL).PanTimedViaBounds.Init()
    	call thistype(NULL).Seismic.Init()
    	call thistype(NULL).Shake.Init()
    	
        call CameraField.Init()
    endmethod
endstruct