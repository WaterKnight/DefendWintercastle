//! runtextmacro Folder("SacredAura")
    //! runtextmacro Struct("Target")
    	static Event ENDING_EVENT
        static Event START_EVENT

		eventMethod Event_Ending
			local Aura aura = params.Aura.GetTrigger()
			local Unit target = params.Unit.GetTrigger()

			local SacredAura parent = aura.GetData()

			call target.Buffs.Subtract(thistype.DUMMY_BUFF)
		endmethod

		eventMethod Event_Start
			local Aura aura = params.Aura.GetTrigger()
			local Unit target = params.Unit.GetTrigger()

			local Unit caster = aura.GetCaster()
			local SacredAura parent = aura.GetData()

			local integer level = parent.level

			call target.Buffs.Add(thistype.DUMMY_BUFF, level)
		endmethod

        static method Init takes nothing returns nothing
            set thistype.ENDING_EVENT = Event.Create(AURA.Target.ENDING_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Ending)
            set thistype.START_EVENT = Event.Create(AURA.Target.START_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Start)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("SacredAura", "SACRED_AURA")
    static BoolExpr TARGET_FILTER

    Aura aura
    Unit caster
    integer level

    //! runtextmacro LinkToStruct("SacredAura", "Target")

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

    eventMethod Event_BuffLose
        local Unit monolith = params.Unit.GetTrigger()

        local thistype this = monolith

        local Aura aura = this.aura

        call aura.Destroy()
    endmethod

    eventMethod Event_BuffGain
        local Unit caster = params.Buff.GetData()
        local Unit monolith = params.Unit.GetTrigger()
        local integer level = params.Buff.GetLevel()

        local thistype this = monolith

		local Aura aura = Aura.Create(monolith)

		set this.aura = aura
        set this.caster = caster
        set this.level = level
        call aura.SetData(this)

		call aura.SetAreaRange(Monolith.THIS_SPELL.GetAreaRange(level))
        call aura.SetTargetFilter(thistype.TARGET_FILTER)

		call aura.Event.Add(thistype(NULL).Target.ENDING_EVENT)
		call aura.Event.Add(thistype(NULL).Target.START_EVENT)

		call aura.Enable()
    endmethod

    static method AddAbility takes Unit monolith, Unit caster, integer level returns nothing
        call monolith.Animation.Set(UNIT.Animation.WORK)

        call monolith.Buffs.AddEx(thistype.DUMMY_BUFF, level, caster)
    endmethod

    initMethod Init of Spells_Hero
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)

        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))

		call thistype(NULL).Target.Init()
    endmethod
endstruct