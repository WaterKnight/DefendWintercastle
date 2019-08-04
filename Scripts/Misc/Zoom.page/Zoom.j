//! runtextmacro BaseStruct("Zoom", "ZOOM")
    //! runtextmacro GetKey("KEY")
    static constant real UPDATE_TIME = 20 * FRAME_UPDATE_TIME
    static Timer UPDATE_TIMER
    static real VALUE = 2450.//2150

    real oldX
    real oldY

    static method RpgCam takes nothing returns nothing
        if not RPG_CAM_ON then
            return
        endif

        if (User.GetLocal().Hero.Get() == NULL) then
            return
        endif

        if (Math.DistanceSquareByDeltas(CAMERA.Target.GetX() - User.GetLocal().Hero.Get().Position.X.Get(), CAMERA.Target.GetY() - User.GetLocal().Hero.Get().Position.Y.Get()) < 500 * 500) then
            call SetCameraField(CAMERA_FIELD_ROTATION, User.GetLocal().Hero.Get().Facing.Get() * bj_RADTODEG, RPG_CAM_TIME)
        endif
    endmethod

    timerMethod Update
        local real newX = CAMERA.Target.GetX()
        local real newY = CAMERA.Target.GetY()

        local integer iteration = thistype.ALL_COUNT

        loop
            local thistype this = thistype.ALL[iteration]

			local User whichUser = this

            local real newZ = thistype.VALUE//Math.Limit(Math.Power(Math.DistanceByDeltas(newX - this.oldX, newY - this.oldY), 1.5), VALUE, VALUE)//2400.-3000.

            set this.oldX = newX
            set this.oldY = newY

            call CameraField.TARGET_DISTANCE.Timed.Set(whichUser, newZ, 1.)//2923.08

            set iteration = iteration - 1
            exitwhen (iteration < ARRAY_MIN)
        endloop
    endmethod

    eventMethod Event_AfterIntro
        local thistype this = params.User.GetTrigger()

        set this.oldX = CAMERA.Target.GetX()
        set this.oldY = CAMERA.Target.GetY()

        if this.AddToList() then
            call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.Update)
        endif
    endmethod

    initMethod Init of Misc_2
        set thistype.UPDATE_TIMER = Timer.Create()
        call Event.Create(AfterIntro.FOR_PLAYER_EVENT_TYPE, EventPriority.MISC, function thistype.Event_AfterIntro).AddToStatics()
    endmethod
endstruct