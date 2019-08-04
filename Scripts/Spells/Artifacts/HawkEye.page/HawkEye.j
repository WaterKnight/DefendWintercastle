//! runtextmacro BaseStruct("HawkEye", "HAWK_EYE")
	static Event DAMAGE_EVENT
	static Event DEATH_EVENT
    static Group ENUM_GROUP
    static BoolExpr TARGET_FILTER

	real healAmount

	eventMethod Impact
		local Missile dummyMissile = params.Missile.GetTrigger()
		local Unit target = params.Unit.GetTrigger()
		
		local thistype this = dummyMissile.GetData()
		
		local real healAmount = this.healAmount
		
		call dummyMissile.Destroy()
		
		call this.deallocate()
		
		if (target == NULL) then
			return
		endif
		
		call target.HealManaBySpell(target, healAmount)
	endmethod

	static method StartManaMissile takes Unit source, Unit target, real healAmount returns nothing
        local thistype this = thistype.allocate()

		local Missile dummyMissile = Missile.Create()

        set this.healAmount = healAmount

        call dummyMissile.Arc.SetByPerc(0.1)
        call dummyMissile.CollisionSize.Set(32.)
        call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 1.25)
        call dummyMissile.Impact.SetAction(function thistype.Impact)
        call dummyMissile.SetData(this)
        call dummyMissile.Speed.Set(500.)
        call dummyMissile.Position.SetFromUnit(source)

        call dummyMissile.GoToUnit.Start(target, null)
	endmethod

	eventMethod Event_Damage
		local Unit damager = params.Unit.GetDamager()
		local Unit target = params.Unit.GetTrigger()
		
		local integer level = target.Buffs.GetLevel(thistype.DUMMY_BUFF)

		call target.Buffs.Timed.StartEx(thistype.BLEEDING_BUFF, level, damager, thistype.BLEED_DURATION[level])
	endmethod

    eventMethod Event_Death
    	local Unit killer = params.Unit.GetKiller()
        local Unit target = params.Unit.GetTrigger()

        local integer level = target.Buffs.GetLevel(thistype.DUMMY_BUFF)

        local Unit userHero = killer.Owner.Get().Hero.Get()

        if ((userHero != NULL) and not userHero.Classes.Contains(UnitClass.DEAD)) then
            set killer = userHero
        endif

        call thistype.StartManaMissile(target, killer, thistype.MANA_HEAL[level])
    endmethod

    eventMethod Event_BuffLose
        local integer level = params.Buff.GetLevel()
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

		call target.Event.Remove(DAMAGE_EVENT)
        call target.Event.Remove(DEATH_EVENT)
        
        call target.Invisibility.Reveal.Subtract()
    endmethod

    eventMethod Event_BuffGain
        local integer level = params.Buff.GetLevel()
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

		call target.Event.Add(DAMAGE_EVENT)
        call target.Event.Add(DEATH_EVENT)
        
        call target.Invisibility.Reveal.Add()
    endmethod

    condMethod Conditions
        local Unit target = UNIT.Event.Native.GetFilter()

        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if target.IsAllyOf(User.TEMP) then
            return false
        endif

        return true
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()

		local real casterX = caster.Position.X.Get()
		local real casterY = caster.Position.Y.Get()

		local string specialEffectPath

		if (EffectLevel.CURRENT == EffectLevel.LOW) then
			set specialEffectPath = thistype.SPECIAL_EFFECT_PATH
		else
			set specialEffectPath = thistype.SPECIAL_EFFECT2_PATH
		endif

		call Spot.CreateEffect(casterX, casterY, specialEffectPath, EffectLevel.LOW).Destroy()
		
		local Sound effectSound = Sound.CreateFromType(thistype.DUMMY_SOUND)

		call effectSound.SetPositionAndPlay(casterX, casterY, caster.Position.Z.Get())

		call effectSound.Destroy(true)

        set User.TEMP = caster.Owner.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(casterX, casterY, thistype.THIS_SPELL.GetAreaRange(level), thistype.TARGET_FILTER)

        local Unit target = thistype.ENUM_GROUP.GetNearest(casterX, casterY)

        if (target != NULL) then
            local integer targetsAmount = thistype.TARGETS_AMOUNT[level]
            
            loop
            	call thistype.ENUM_GROUP.RemoveUnit(target)
            	
            	local Sound hitSound = Sound.CreateFromType(thistype.HIT_SOUND)

				call hitSound.AttachToUnitAndPlay(target)

				call hitSound.Destroy(true)
            	
            	call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.BUFF_DURATION[level])
                
                set targetsAmount = targetsAmount - 1
                exitwhen (targetsAmount < 1)

                set target = thistype.ENUM_GROUP.GetNearest(casterX, casterY)
                exitwhen (target == NULL)
            endloop
        endif
    endmethod

    initMethod Init of Spells_Artifacts
    	set thistype.DAMAGE_EVENT = Event.Create(UNIT.Damage.Events.TARGET_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Damage)
    	set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Death)
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
        
        call UNIT.Bleeding.NORMAL_BUFF.Variants.Add(thistype.BLEEDING_BUFF)
    endmethod
endstruct