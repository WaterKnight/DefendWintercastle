//! runtextmacro Folder("ZodiacAura")
    //! runtextmacro Struct("Target")
    	static Event ENDING_EVENT
        static Event START_EVENT

		eventMethod Event_Ending
			local Aura aura = params.Aura.GetTrigger()
			local Unit target = params.Unit.GetTrigger()

			local ZodiacAura parent = aura.GetData()

			call target.Buffs.Subtract(thistype.DUMMY_BUFF)
		endmethod

		eventMethod Event_Start
			local Aura aura = params.Aura.GetTrigger()
			local Unit target = params.Unit.GetTrigger()

			local Unit caster = aura.GetCaster()
			local ZodiacAura parent = aura.GetData()

			local integer level = parent.level

			call target.Buffs.Add(thistype.DUMMY_BUFF, level)
		endmethod

        static method Init takes nothing returns nothing
            set thistype.ENDING_EVENT = Event.Create(AURA.Target.ENDING_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Ending)
            set thistype.START_EVENT = Event.Create(AURA.Target.START_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Start)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("ZodiacAura", "ZODIAC_AURA")
    static real array HEAL_PER_INTERVAL
    static BoolExpr TARGET_FILTER

	Aura aura
    Unit caster
    real heal
    Timer intervalTimer
    integer level

    //! runtextmacro LinkToStruct("ZodiacAura", "Target")

    condMethod Conditions
        local Unit target = UNIT.Event.Native.GetFilter()

        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if target.Classes.Contains(UnitClass.MECHANICAL) then
            return false
        endif
        if target.Classes.Contains(UnitClass.STRUCTURE) then
            return false
        endif
        if not target.IsAllyOf(User.TEMP) then
            return false
        endif

        return true
    endmethod

	eventMethod DoHeal
		local Unit target = params.Unit.GetTrigger()
		local thistype this = params.GetData()

		call target.Life.Add(this.heal)
        //call this.caster.HealBySpell(target, this.heal)
	endmethod

    timerMethod Interval
        local thistype this = Timer.GetExpired().GetData()

        call this.aura.GetTargetGroup().DoEx(function thistype.DoHeal, this)
    endmethod

    eventMethod Event_BuffLose
        local Unit source = params.Unit.GetTrigger()

        local thistype this = source

		local Aura aura = this.aura
        local Timer intervalTimer = this.intervalTimer

		call aura.Destroy()
        call intervalTimer.Destroy()
    endmethod

    eventMethod Event_BuffGain
        local Unit caster = params.Buff.GetData()
        local integer level = params.Buff.GetLevel()
        local Unit source = params.Unit.GetTrigger()

        local thistype this = source

		local Aura aura = Aura.Create(caster)
        local Timer intervalTimer = Timer.Create()

        set this.aura = aura
        set this.caster = caster
        set this.heal = thistype.HEAL_PER_INTERVAL[level] + caster.Intelligence.Get() * thistype.HEAL_PER_SECOND_PER_ANIMUS[level] * thistype.HEAL_INTERVAL
        set this.intervalTimer = intervalTimer
        set this.level = level
        call aura.SetData(this)
        call intervalTimer.SetData(this)

		call aura.SetAreaRange(Zodiac.THIS_SPELL.GetAreaRange(level))
        call aura.SetTargetFilter(thistype.TARGET_FILTER)

		call aura.Event.Add(thistype(NULL).Target.ENDING_EVENT)
		call aura.Event.Add(thistype(NULL).Target.START_EVENT)

		call aura.Enable()

        call intervalTimer.Start(thistype.HEAL_INTERVAL, true, function thistype.Interval)
    endmethod

    static method AddAbility takes Unit source, Unit caster, integer level returns nothing
        call source.Buffs.AddEx(thistype.DUMMY_BUFF, level, caster)
    endmethod

    initMethod Init of Spells_Hero
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)

        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))

        local integer iteration = Zodiac.THIS_SPELL.GetLevelsAmount()

        loop
            exitwhen (iteration < 1)

            set thistype.HEAL_PER_INTERVAL[iteration] = thistype.HEAL_PER_SECOND[iteration] * thistype.HEAL_INTERVAL

            set iteration = iteration - 1
        endloop

		call thistype(NULL).Target.Init()
    endmethod
endstruct

//! runtextmacro BaseStruct("Zodiac", "ZODIAC")	
    eventMethod Event_BuffLose
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

		call this.deallocate_demount()

		call target.Death.Protection.Subtract()

        call target.Buffs.Remove(ZodiacAura.DUMMY_BUFF)
    endmethod

    eventMethod Event_BuffGain
    	local Unit caster = params.Buff.GetData()
        local integer level = params.Buff.GetLevel()
        local Unit target = params.Unit.GetTrigger()

        local thistype this = thistype.allocate_mount(target)

		call target.Death.Protection.Add()

        call ZodiacAura.AddAbility(target, caster, level)
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()
        local Unit target = params.Unit.GetTarget()

        call target.Buffs.Timed.StartEx(thistype.DUMMY_BUFF, level, caster, thistype.BUFF_DURATION[level])
    endmethod

    initMethod Init of Spells_Hero
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct