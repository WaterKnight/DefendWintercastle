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
            if (this.RemoveFromList()) then
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
            local real oldValue
            local CameraField parent
            local real remainingWavesAmount
            local thistype this

            loop
                set this = thistype.ALL[iteration]

                set parent = this.parent
                set remainingWavesAmount = this.remainingWavesAmount

                set oldValue = parent.Get()

                set this.remainingWavesAmount = remainingWavesAmount - 1
                call parent.Set(this.whichPlayer, oldValue + (this.value - oldValue) / remainingWavesAmount)

                set iteration = iteration - 1
                exitwhen (iteration < ARRAY_MIN)
            endloop
        endmethod

        method Set takes User whichPlayer, real value, real duration returns nothing
            local Timer durationTimer = Timer.Create()
            local CameraField parent = this

            set this = whichPlayer.Data.Integer.Get(KEY_ARRAY_DETAIL + parent)

            if (this != NULL) then
                call this.Ending(this.durationTimer, parent, whichPlayer)
            endif

            set this = thistype.allocate()

            set this.durationTimer = durationTimer
            set this.parent = parent
            set this.remainingWavesAmount = duration / thistype.UPDATE_TIME
            set this.value = value
            set this.whichPlayer = whichPlayer
            call durationTimer.SetData(this)
            call whichPlayer.Data.Integer.Set(KEY_ARRAY_DETAIL + parent, this)

            if (this.AddToList()) then
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
        if (whichPlayer.IsLocal()) then
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
    //! runtextmacro LinkToStruct("Camera", "Target")

    method Apply takes boolean pan, real duration returns nothing
        call CameraSetupApplyForceDuration(this.self, pan, duration)
    endmethod

    static method Lock takes User whichPlayer returns nothing
        local real x
        local real y

        if (whichPlayer.IsLocal()) then
            set thistype.LOCK_AMOUNT = thistype.LOCK_AMOUNT + 1

            if (thistype.LOCK_AMOUNT == 1) then
                set x = Target.GetX()
                set y = Target.GetY()

                call SetCameraBounds(x, y, x, y, x, y, x, y)
            endif
        endif
    endmethod

    static method Unlock takes User whichPlayer returns nothing
        if (whichPlayer.IsLocal()) then
            set thistype.LOCK_AMOUNT = thistype.LOCK_AMOUNT - 1

            if (thistype.LOCK_AMOUNT == 0) then
                call SetCameraBounds(thistype.BOUNDS_X, thistype.BOUNDS_Y, thistype.BOUNDS_X2, thistype.BOUNDS_Y2, thistype.BOUNDS_X3, thistype.BOUNDS_Y3, thistype.BOUNDS_X4, thistype.BOUNDS_Y4)
            endif
        endif
    endmethod

    static method LockToDummyUnit takes User whichPlayer, DummyUnit whichUnit returns nothing
        if (whichPlayer.IsLocal()) then
            call SetCameraTargetController(whichUnit.self, 0., 0., false)
        endif
    endmethod

    static method UnlockFromUnit takes User whichPlayer returns nothing
        call thistype.Reset(whichPlayer, 0.)
    endmethod

    static method PanTimed takes User whichPlayer, real x, real y, real duration returns nothing
        if (whichPlayer.IsLocal()) then
            call PanCameraToTimed(x, y, duration)
        endif
    endmethod

    static method Reset takes User whichPlayer, real duration returns nothing
        if (whichPlayer.IsLocal()) then
            call ResetToGameCamera(duration)
        endif
    endmethod

    static method SetBounds takes User whichPlayer, real x, real y, real x2, real y2, real x3, real y3, real x4, real y4 returns nothing
        if (whichPlayer.IsLocal()) then
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
        if (whichPlayer.IsLocal()) then
            call CameraSetSmoothingFactor(value)
        endif
    endmethod

    static method CreateFromSelf takes camerasetup self returns thistype
        local thistype this = thistype.allocate()

        set this.self = self

        return this
    endmethod

    static method Init takes nothing returns nothing
        call CameraField.Init()
    endmethod
endstruct