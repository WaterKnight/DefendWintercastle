//! runtextmacro BaseStruct("HeroRevival", "HERO_REVIVAL")
    static Event DEATH_EVENT
    static constant real DURATION = 15.
    //! runtextmacro GetKey("KEY")
    static Event REVIVE_EVENT
    static Rectangle array REVIVAL_RECTS
    static constant string SPECIAL_EFFECT_ATTACH_POINT = AttachPoint.ORIGIN
    static constant string SPECIAL_EFFECT_PATH = "Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl"

    Timer durationTimer
    Timer intervalTimer
    Unit whichUnit

    static method GetByWhichUnit takes Unit whichUnit returns thistype
        return whichUnit.Data.Integer.Get(KEY)
    endmethod

    method Ending takes Timer durationTimer, Unit whichUnit returns nothing
        local Timer intervalTimer = this.intervalTimer

        call this.deallocate()
        call durationTimer.Data.Integer.Remove(KEY)
        call durationTimer.Destroy()
        call intervalTimer.Data.Integer.Remove(KEY)
        call intervalTimer.Destroy()
        call whichUnit.Data.Integer.Remove(KEY)
        call whichUnit.Event.Remove(REVIVE_EVENT)
    endmethod

    static method EndingByTimer takes nothing returns nothing
        local Timer durationTimer = Timer.GetExpired()
        local Rectangle revivalRect = REVIVAL_RECTS[Math.RandomI(0, 1)]

        local thistype this = durationTimer.Data.Integer.Get(KEY)

        local Unit whichUnit = this.whichUnit

        local User whichUnitOwner = whichUnit.Owner.Get()

        call this.Ending(durationTimer, this.whichUnit)

        call whichUnit.Effects.Create(SPECIAL_EFFECT_PATH, SPECIAL_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()
        call whichUnit.Hero.Revive(revivalRect.GetCenterX(), revivalRect.GetCenterY())
        call Camera.PanTimed(whichUnitOwner, whichUnit.Position.X.Get(), whichUnit.Position.Y.Get(), 0.)
        call INFOBOARD.User.Update(whichUnit.Owner.Get())

        call whichUnit.Select(whichUnitOwner, true)
        call whichUnit.Life.Set(whichUnit.MaxLife.GetAll())
        call whichUnit.Mana.Set(whichUnit.MaxMana.GetAll())
    endmethod

    static method CountDown takes nothing returns nothing
        local thistype this = Timer.GetExpired().Data.Integer.Get(KEY)

        call INFOBOARD.User.Update(this.whichUnit.Owner.Get())
    endmethod

    static method Event_Revive takes nothing returns nothing
        local Unit whichUnit = UNIT.Event.GetTrigger()

        local thistype this = whichUnit.Data.Integer.Get(KEY)

        call this.Ending(this.durationTimer, whichUnit)
    endmethod

    static method Event_Death takes nothing returns nothing
        local Timer durationTimer
        local Timer intervalTimer
        local thistype this
        local Unit whichUnit = UNIT.Event.GetTrigger()

        if (whichUnit.Revival.Is() == false) then
            set durationTimer = Timer.Create()
            set intervalTimer = Timer.Create()
            set this = thistype.allocate()

            set this.durationTimer = durationTimer
            set this.intervalTimer = intervalTimer
            set this.whichUnit = whichUnit
            call durationTimer.Data.Integer.Set(KEY, this)
            call intervalTimer.Data.Integer.Set(KEY, this)
            call whichUnit.Data.Integer.Set(KEY, this)
            call whichUnit.Event.Add(REVIVE_EVENT)
            call whichUnit.Revival.Set(true)

            call durationTimer.Start(DURATION, false, function thistype.EndingByTimer)

            call intervalTimer.Start(1., true, function thistype.CountDown)

            call INFOBOARD.User.Update(whichUnit.Owner.Get())
        endif
    endmethod

    static method Event_Create takes nothing returns nothing
        local Unit whichUnit = UNIT.Event.GetTrigger()

        if (whichUnit.Type.Is(UNIT.Type.HERO) and (whichUnit.Type.Is(UNIT.Type.ILLUSION) == false)) then
            call whichUnit.Event.Add(DEATH_EVENT)
        endif
    endmethod

    static method Init takes nothing returns nothing
        set DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Death)
        set REVIVE_EVENT = Event.Create(UNIT.Revival.Events.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Revive)
        set REVIVAL_RECTS[0] = Rectangle.CreateFromSelf(gg_rct_HeroRevival)
        set REVIVAL_RECTS[1] = Rectangle.CreateFromSelf(gg_rct_HeroRevival2)
        call Event.Create(EventType.CREATE, EventPriority.MISC, function thistype.Event_Create).AddToStatics()
    endmethod
endstruct