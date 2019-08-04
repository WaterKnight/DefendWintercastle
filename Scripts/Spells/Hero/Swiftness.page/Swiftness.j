//! runtextmacro BaseStruct("Swiftness", "SWIFTNESS")
    integer count
    Timer intervalTimer

    timerMethod Interval
        local thistype this = Timer.GetExpired().GetData()

        local Unit target = this

        local integer count = this.count

        call target.Buffs.Remove(thistype.CHARGE_BUFF[count])

        set this.count = count - 1

        if (count == 1) then
            call target.Buffs.Remove(thistype.TIMER_BUFF)
        endif
    endmethod

    eventMethod Event_Timer_BuffLose
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

        local integer count = this.count
        local Timer intervalTimer = this.intervalTimer

        call intervalTimer.Destroy()

        loop
            exitwhen (count < 1)

            call target.Buffs.Remove(thistype.CHARGE_BUFF[count])

            set count = count - 1
        endloop
    endmethod

    eventMethod Event_Timer_BuffGain
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

        local Timer intervalTimer = Timer.Create()

        set this.intervalTimer = intervalTimer
        call intervalTimer.SetData(this)

        call intervalTimer.Start(thistype.DURATION[1], true, function thistype.Interval)
    endmethod

    static method Start takes Unit target, integer level returns nothing
        local thistype this = target

		local integer count

        if not target.Buffs.Contains(thistype.TIMER_BUFF) then
            set count = 1
        else
            set count = this.count + 1
        endif

        set this.count = count

        call target.Buffs.Add(thistype.TIMER_BUFF, 1)

        call target.Buffs.Add(thistype.CHARGE_BUFF[count], level)
    endmethod

    initMethod Init of Spells_Hero
        call thistype.TIMER_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Timer_BuffGain))
        call thistype.TIMER_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Timer_BuffLose))
    endmethod
endstruct