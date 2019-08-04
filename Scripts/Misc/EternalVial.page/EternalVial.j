//! runtextmacro BaseStruct("EternalVial", "ETERNAL_VIAL")
	static real INTERVAL

	Timer intervalTimer

	static method DoHeal takes Unit target
		call target.Effects.Create(thistype.HEAL_EFFECT_PATH, thistype.HEAL_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()
		call target.Effects.Create(thistype.HEAL_EFFECT_PATH, thistype.HEAL_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

		call target.HealBySpell(target, thistype.HEAL_FACTOR_PER_INTERVAL * target.MaxLife.Get())
		call target.HealManaBySpell(target, thistype.HEAL_MANA_FACTOR_PER_INTERVAL * target.MaxMana.Get())
		call target.HealStaminaBySpell(target, thistype.HEAL_STAMINA_FACTOR_PER_INTERVAL * target.MaxStamina.Get())
	endmethod

	timerMethod Interval
		local thistype this = Timer.GetExpired().GetData()

		local Unit target = this

		call thistype.DoHeal(target)
	endmethod

	eventMethod Event_BuffLose
		local Unit target = params.Unit.GetTrigger()

		local thistype this = target

		call this.intervalTimer.Destroy()
	endmethod

	eventMethod Event_BuffGain
		local Unit target = params.Unit.GetTrigger()

		local thistype this = target

		local Timer intervalTimer = Timer.Create()

		set this.intervalTimer = intervalTimer
		call intervalTimer.SetData(this)

		call intervalTimer.Start(thistype.INTERVAL, true, function thistype.Interval)
	endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()

        call caster.Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.DURATION)

		call thistype.DoHeal(caster)
    endmethod

    initMethod Init of Spells_Misc
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_SpellEffect))

		set thistype.INTERVAL = thistype.DURATION / (thistype.INTERVALS_AMOUNT - 1)
    endmethod
endstruct