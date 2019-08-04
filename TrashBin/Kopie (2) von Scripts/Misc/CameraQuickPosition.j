//! runtextmacro BaseStruct("CameraQuickPosition", "CAMERA_QUICK_POSITION")
    static Event PICK_EVENT
    static constant real UPDATE_TIME = 0.035

    static method Update takes nothing returns nothing
        local Unit hero = User.GetLocal().Hero.Get()

        if (hero == NULL) then
            return
        endif

        call SetCameraQuickPosition(hero.Position.X.Get(), hero.Position.Y.Get())
    endmethod

    static method Event_HeroPick takes nothing returns nothing
        call thistype.PICK_EVENT.RemoveFromStatics()

        call Timer.Create().Start(thistype.UPDATE_TIME, true, function thistype.Update)
    endmethod

    static method Init takes nothing returns nothing
        set thistype.PICK_EVENT = Event.Create(HeroSelection.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_HeroPick)

        call thistype.PICK_EVENT.AddToStatics()
    endmethod
endstruct