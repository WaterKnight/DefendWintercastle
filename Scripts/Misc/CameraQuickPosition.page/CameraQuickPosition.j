//! runtextmacro BaseStruct("CameraQuickPosition", "CAMERA_QUICK_POSITION")
    static Event PICK_EVENT
    static constant real UPDATE_TIME = 0.035

    timerMethod Update
        local Unit hero = User.GetLocal().Hero.Get()

        if (hero == NULL) then
            return
        endif

        call SetCameraQuickPosition(hero.Position.X.Get(), hero.Position.Y.Get())
    endmethod

    eventMethod Event_HeroPick
        call thistype.PICK_EVENT.RemoveFromStatics()

        call Timer.Create().Start(thistype.UPDATE_TIME, true, function thistype.Update)
    endmethod

    initMethod Init of Misc_2
        set thistype.PICK_EVENT = Event.Create(HeroSelection.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_HeroPick)

        call thistype.PICK_EVENT.AddToStatics()
    endmethod
endstruct