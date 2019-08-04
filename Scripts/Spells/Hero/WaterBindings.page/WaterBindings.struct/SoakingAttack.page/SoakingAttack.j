//! runtextmacro Folder("SoakingAttack")
    //! runtextmacro Struct("Target")
	    integer count
	    Timer intervalTimer
	
	    timerMethod Interval
	        local thistype this = Timer.GetExpired().GetData()
	
	        local Unit target = this
	
	        local integer count = this.count
	
	        call target.Buffs.Remove(thistype.CHARGE_BUFF[count])
	
	        set this.count = count - 1
	call DebugEx("reduce to "+I2S(count-1))
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
	    	local integer level = params.Buff.GetLevel()
	        local Unit target = params.Unit.GetTrigger()
	
	        local thistype this = target
	
	        local Timer intervalTimer = Timer.Create()
	
	        set this.intervalTimer = intervalTimer
	        call intervalTimer.SetData(this)
	    endmethod
	
		static method StartTimer takes integer level, Unit target returns nothing
			local thistype this = target
			
			local Timer intervalTimer = this.intervalTimer

			local real duration
			
			if target.Classes.Contains(UnitClass.HERO) then
				set duration = thistype.HERO_DURATION[level]
			else
				set duration = thistype.DURATION[level]
			endif
	
	        call intervalTimer.Start(duration, true, function thistype.Interval)
		endmethod
	
	    static method Start takes Unit caster, integer level, Unit target returns nothing
	        local integer count
	
	        local thistype this = target
	
	        if (target.Buffs.Contains(thistype.TIMER_BUFF) == false) then
	            set count = 1
	        else
	            set count = Math.MinI(this.count + 1, 3)
	        endif
	
	        set this.count = count
	call DebugEx("apply "+I2S(count))
	        call target.Buffs.Add(thistype.CHARGE_BUFF[count], level)
	        
	        call target.Buffs.Add(thistype.TIMER_BUFF, 1)
	        
	        call thistype.StartTimer(level, target)
	    endmethod

        static method Init takes nothing returns nothing
    	    call thistype.TIMER_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Timer_BuffGain))
	        call thistype.TIMER_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Timer_BuffLose))
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("SoakingAttack", "SOAKING_ATTACK")
    static Event DAMAGE_EVENT

    //! runtextmacro LinkToStruct("SoakingAttack", "Target")

    static method Conditions takes Unit target returns boolean
        if target.Classes.Contains(UnitClass.MECHANICAL) then
            return false
        endif
        if target.Classes.Contains(UnitClass.STRUCTURE) then
            return false
        endif

        return true
    endmethod

    eventMethod Event_Damage
        local Unit target = params.Unit.GetTrigger()

        if not thistype.Conditions(target) then
            return
        endif

        call thistype(NULL).Target.Start(params.Unit.GetDamager(), params.Unit.GetDamager().Abilities.GetLevel(thistype.THIS_SPELL), target)
    endmethod

    eventMethod Event_BuffLose
        call params.Unit.GetTrigger().Event.Remove(DAMAGE_EVENT)
    endmethod

    eventMethod Event_BuffGain
        call params.Unit.GetTrigger().Event.Add(DAMAGE_EVENT)
    endmethod

    eventMethod Event_Unlearn
        call params.Unit.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

    eventMethod Event_Learn
        call params.Unit.GetTrigger().Buffs.Add(thistype.DUMMY_BUFF, params.Spell.GetLevel())
    endmethod

    initMethod Init of Spells_Hero
        set thistype.DAMAGE_EVENT = Event.Create(UNIT.Damage.Events.ATTACKER_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Damage)
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Learn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Learn))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Unlearn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Unlearn))

        call thistype(NULL).Target.Init()
    endmethod
endstruct