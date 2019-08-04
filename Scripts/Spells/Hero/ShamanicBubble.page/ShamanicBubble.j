//! runtextmacro Folder("ShamanicBubble")
    //! runtextmacro Struct("Target")
    	static Event ENDING_EVENT
        static Event START_EVENT

		eventMethod Event_Ending
			local Aura aura = params.Aura.GetTrigger()
			local Unit target = params.Unit.GetTrigger()

			local ShamanicBubble parent = aura.GetData()

			call target.Buffs.Subtract(thistype.DUMMY_BUFF)
		endmethod

		eventMethod Event_Start
			local Aura aura = params.Aura.GetTrigger()
			local Unit target = params.Unit.GetTrigger()

			local Unit caster = aura.GetCaster()
			local ShamanicBubble parent = aura.GetData()

			local integer level = parent.level

			call target.Buffs.Add(thistype.DUMMY_BUFF, level)
		endmethod

        static method Init takes nothing returns nothing
            set thistype.ENDING_EVENT = Event.Create(AURA.Target.ENDING_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Ending)
            set thistype.START_EVENT = Event.Create(AURA.Target.START_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Start)
        endmethod
    endstruct

    //! runtextmacro Struct("Transition")
        static SpellInstance WHICH_SPELL_INSTANCE

        Timer delayTimer
        real scale
        SpellInstance whichSpellInstance

        timerMethod Delay
            local thistype this = Timer.GetExpired().GetData()

            local Unit target = this

            call target.Buffs.Remove(thistype.DUMMY_BUFF)

            call ShamanicBubble.Start(this.whichSpellInstance)
        endmethod

        eventMethod Event_BuffLose
            local Unit target = params.Unit.GetTrigger()

            local thistype this = target

            local Timer delayTimer = this.delayTimer
            local real scale = this.scale

            call delayTimer.Destroy()

            call target.Scale.Timed.Add(scale, thistype.DELAY)
        endmethod

        eventMethod Event_BuffGain
            local Unit target = params.Unit.GetTrigger()
            local SpellInstance whichSpellInstance = thistype.WHICH_SPELL_INSTANCE

            local real scale = target.Scale.Get()

            local thistype this = target

			local Timer delayTimer = Timer.Create()

            set this.delayTimer = delayTimer
            set this.scale = scale
            set this.whichSpellInstance = whichSpellInstance
            call delayTimer.SetData(this)

            call target.Scale.Timed.Subtract(scale, thistype.DELAY)

            call delayTimer.Start(thistype.DELAY, false, function thistype.Delay)
        endmethod

        static method Start takes SpellInstance whichInstance returns nothing
            set thistype.WHICH_SPELL_INSTANCE = whichInstance

            call whichInstance.GetCaster().Buffs.Timed.Start(thistype.DUMMY_BUFF, 1, thistype.DELAY)
        endmethod

        static method Init takes nothing returns nothing
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("ShamanicBubble", "SHAMANIC_BUBBLE")
    static BoolExpr TARGET_FILTER

    Aura aura
    integer level

    //! runtextmacro LinkToStruct("ShamanicBubble", "Target")
    //! runtextmacro LinkToStruct("ShamanicBubble", "Transition")

    condMethod Conditions
        local Unit target = UNIT.Event.Native.GetFilter()

        if target.Classes.Contains(UnitClass.DEAD) then
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
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

		local Aura aura = this.aura

        call aura.Destroy()
    endmethod

    eventMethod Event_BuffGain
        local integer level = params.Buff.GetLevel()
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

		local Aura aura = Aura.Create(target)

        set this.aura = aura
        set this.level = level
        call aura.SetData(this)

		call aura.SetAreaRange(thistype.THIS_SPELL.GetAreaRange(level))
        call aura.SetTargetFilter(thistype.TARGET_FILTER)

		call aura.Event.Add(thistype(NULL).Target.ENDING_EVENT)
		call aura.Event.Add(thistype(NULL).Target.START_EVENT)

		call aura.Enable()
    endmethod

    eventMethod Event_EndCast
        local Unit caster = params.Unit.GetTrigger()

        call caster.Buffs.Remove(thistype(NULL).Transition.DUMMY_BUFF)

        call caster.Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

    static method Start takes SpellInstance whichInstance returns nothing
        local Unit caster = whichInstance.GetCaster()
        local integer level = whichInstance.GetLevel()
        local real targetX = whichInstance.GetTargetX()
        local real targetY = whichInstance.GetTargetY()

        call caster.Position.SetXYZ(targetX, targetY, Spot.GetHeight(targetX, targetY))

        call caster.Buffs.Add(thistype.DUMMY_BUFF, level)
    endmethod

    eventMethod Event_SpellEffect
        call thistype(NULL).Transition.Start(params.SpellInstance.GetTrigger())
    endmethod

    initMethod Init of Spells_Hero
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Finish.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_EndCast))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call thistype(NULL).Target.Init()
        call thistype(NULL).Transition.Init()
    endmethod
endstruct