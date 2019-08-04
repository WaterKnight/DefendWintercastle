//! runtextmacro BaseStruct("Brotherhood", "BROTHERHOOD")
	static Event DAMAGE_EVENT
	
	static Unit BROTHER
	
	Unit brother
	
	eventMethod Event_Damage
		local Unit damager = params.Unit.GetDamager()
		local real dmg = params.Real.GetDamage()
		local Unit target = params.Unit.GetTrigger()
		
		local thistype this = target
		
		local Unit brother = this.brother
		
		if (brother.IsDestroyed() or brother.Classes.Contains(UnitClass.DEAD)) then
			return
		endif
		
		local real dmgSplit = dmg * thistype.DMG_SPLIT / 2
		
		if (dmgSplit <= 0.) then
			return
		endif
		
		call damager.DamageUnit(brother, dmgSplit, false)
		
		call params.Real.SetDamage(dmg - dmgSplit)
	endmethod
	
    eventMethod Event_BuffLose
    	local Unit target = params.Unit.GetTrigger()
    	
    	local thistype this = target
    	
    	local Unit brother = this.brother
    	
        call target.Event.Remove(DAMAGE_EVENT)
        
        call brother.Refs.Subtract()
    endmethod

    eventMethod Event_BuffGain
    	local Unit brother = thistype.BROTHER
    	local Unit target = params.Unit.GetTrigger()
    	
    	local thistype this = target
    	
    	set this.brother = brother
    	
        call target.Event.Add(DAMAGE_EVENT)
        
        call brother.Refs.Add()
    endmethod

    eventMethod Event_Unlearn
        call params.Unit.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

    eventMethod Event_Learn
        call params.Unit.GetTrigger().Buffs.AddFresh(thistype.DUMMY_BUFF, params.Spell.GetLevel())
    endmethod

	static method Add takes Unit firstTarget, integer level, Unit secondTarget returns nothing
		set thistype.BROTHER = secondTarget
		
		call firstTarget.Abilities.AddWithLevel(thistype.THIS_SPELL, level)
	endmethod

    initMethod Init of Spells_Hero
    	set thistype.DAMAGE_EVENT = Event.Create(UNIT.Damage.Events.TARGET_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Damage)
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Learn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Learn))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Unlearn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Unlearn))
    endmethod
endstruct