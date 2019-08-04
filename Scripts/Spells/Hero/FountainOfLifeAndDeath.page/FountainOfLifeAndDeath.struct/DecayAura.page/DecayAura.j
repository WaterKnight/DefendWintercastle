//! runtextmacro Folder("DecayAura")
    //! runtextmacro Struct("Target")
    	static Event ENDING_EVENT
        static Event START_EVENT

		eventMethod Event_Ending
			local Aura aura = params.Aura.GetTrigger()
			local Unit target = params.Unit.GetTrigger()

			local DecayAura parent = aura.GetData()

			call target.Buffs.Subtract(thistype.DUMMY_BUFF)
		endmethod

		eventMethod Event_Start
			local Aura aura = params.Aura.GetTrigger()
			local Unit target = params.Unit.GetTrigger()

			local Unit caster = aura.GetCaster()
			local DecayAura parent = aura.GetData()

			local integer level = parent.level

			call target.Buffs.Add(thistype.DUMMY_BUFF, level)
		endmethod

        static method Init takes nothing returns nothing
            set thistype.ENDING_EVENT = Event.Create(AURA.Target.ENDING_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Ending)
            set thistype.START_EVENT = Event.Create(AURA.Target.START_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Start)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("DecayAura", "DECAY_AURA")
    static real array DAMAGE_PER_INTERVAL
    static BoolExpr TARGET_FILTER

    Aura aura
    Unit caster
    real damage
    Timer intervalTimer
    integer level

    //! runtextmacro LinkToStruct("DecayAura", "Target")

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
        if target.IsAllyOf(User.TEMP) then
            return false
        endif

        return true
    endmethod

	eventMethod DealDamage
		local Unit target = params.Unit.GetTrigger()
		local thistype this = params.GetData()

		call this.caster.DamageUnitBySpell(target, this.damage, true, false)
	endmethod

    timerMethod Interval
        local thistype this = Timer.GetExpired().GetData()

		call this.aura.GetTargetGroup().DoEx(function thistype.DealDamage, this)
    endmethod

    eventMethod Event_BuffLose
        local Unit fountain = params.Unit.GetTrigger()

        local thistype this = fountain

		local Aura aura = this.aura
        local Timer intervalTimer = this.intervalTimer

		call aura.Destroy()
        call intervalTimer.Destroy()
    endmethod

    eventMethod Event_BuffGain
        local Unit caster = params.Buff.GetData()
        local Unit fountain = params.Unit.GetTrigger()
        local integer level = params.Buff.GetLevel()

		local Aura aura = Aura.Create(fountain)
        local Timer intervalTimer = Timer.Create()

        local thistype this = fountain

        set this.aura = aura
        set this.caster = caster
        set this.damage = thistype.DAMAGE_PER_INTERVAL[level]
        set this.intervalTimer = intervalTimer
        set this.level = level
        call aura.SetData(this)
        call intervalTimer.SetData(this)

		call aura.SetAreaRange(FountainOfLifeAndDeath.THIS_SPELL.GetAreaRange(level))
        call aura.SetTargetFilter(thistype.TARGET_FILTER)

		call aura.Event.Add(thistype(NULL).Target.ENDING_EVENT)
		call aura.Event.Add(thistype(NULL).Target.START_EVENT)

		call aura.Enable()

		call intervalTimer.Start(thistype.DAMAGE_INTERVAL, true, function thistype.Interval)
    endmethod

    static method AddAbility takes Unit fountain, Unit caster, integer level returns nothing
        call fountain.Buffs.AddEx(thistype.DUMMY_BUFF, level, caster)
    endmethod

    initMethod Init of Spells_Hero
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)

        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))

        local integer iteration = thistype.THIS_SPELL.GetLevelsAmount()

        loop
            exitwhen (iteration < 1)

            set thistype.DAMAGE_PER_INTERVAL[iteration] = thistype.DAMAGE_PER_SECOND[iteration] * thistype.DAMAGE_INTERVAL

            set iteration = iteration - 1
        endloop

		call thistype(NULL).Target.Init()
    endmethod
endstruct