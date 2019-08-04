//! runtextmacro Folder("WanShroud")
    //! runtextmacro Struct("Missile")
        Unit caster
        integer level
        real targetX
        real targetY

        eventMethod Impact
            local Missile dummyMissile = params.Missile.GetTrigger()

            local thistype this = dummyMissile.GetData()

            local Unit caster = this.caster
            local integer level = this.level
            local real targetX = this.targetX
            local real targetY = this.targetY

            call this.deallocate()
            call dummyMissile.Destroy()

            call WanShroud.Start(caster, level, targetX, targetY)
        endmethod

        static method Start takes Unit caster, integer level, real targetX, real targetY returns nothing
            local thistype this = thistype.allocate()

			local Missile dummyMissile = Missile.Create()

            set this.caster = caster
            set this.level = level
            set this.targetX = targetX
            set this.targetY = targetY

            call dummyMissile.Acceleration.Set(2000.)
            call dummyMissile.Arc.SetByPerc(0.2)
            call dummyMissile.CollisionSize.Set(48.)
            call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 1.)
            call dummyMissile.Impact.SetAction(function thistype.Impact)
            call dummyMissile.SetData(this)
            call dummyMissile.Speed.Set(500.)
            call dummyMissile.Position.SetFromUnit(caster)

            call dummyMissile.GoToSpot.Start(targetX, targetY, Spot.GetHeight(targetX, targetY))
        endmethod
    endstruct

    //! runtextmacro Struct("Target")
        static Event DAMAGE_EVENT
    	static Event ENDING_EVENT
        static Event START_EVENT

        eventMethod Event_Damage
            local Unit damager = params.Unit.GetDamager()
            local Unit target = params.Unit.GetTrigger()

	        local Unit userHero = damager.Owner.Get().Hero.Get()

	        if ((userHero != NULL) and not userHero.Classes.Contains(UnitClass.DEAD)) then
	            set damager = userHero
	        endif

			call damager.LifeLeech.DoWithVal(target, thistype.LIFE_LEECH[target.Buffs.GetLevel(thistype.DUMMY_BUFF)])
            call damager.ManaLeech.DoWithVal(target, thistype.MANA_LEECH[target.Buffs.GetLevel(thistype.DUMMY_BUFF)])
        endmethod

        eventMethod Event_BuffLose
            local Unit target = params.Unit.GetTrigger()

            call target.Event.Remove(DAMAGE_EVENT)
        endmethod

        eventMethod Event_BuffGain
            local Unit target = params.Unit.GetTrigger()

            call target.Event.Add(DAMAGE_EVENT)
        endmethod

		eventMethod Event_Ending
			local Aura aura = params.Aura.GetTrigger()
			local Unit target = params.Unit.GetTrigger()

			local WanShroud parent = aura.GetData()

			call target.Buffs.Subtract(thistype.DUMMY_BUFF)
		endmethod

		eventMethod Event_Start
			local Aura aura = params.Aura.GetTrigger()
			local Unit target = params.Unit.GetTrigger()

			local Unit caster = aura.GetCaster()
			local WanShroud parent = aura.GetData()

			local integer level = parent.level

			call target.Buffs.Add(thistype.DUMMY_BUFF, level)
		endmethod

        static method Init takes nothing returns nothing
        	set thistype.DAMAGE_EVENT = Event.Create(UNIT.Damage.Events.TARGET_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Damage)
            set thistype.ENDING_EVENT = Event.Create(AURA.Target.ENDING_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Ending)
            set thistype.START_EVENT = Event.Create(AURA.Target.START_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Start)

            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("WanShroud", "WAN_SHROUD")
    static BoolExpr AURA_FILTER
    static BoolExpr DAMAGE_FILTER
    static real array DAMAGE_PER_INTERVAL

    DummyUnit areaDummyUnit
    Aura aura
    Unit caster
    real damage
    Timer intervalTimer
    integer level
    real targetX
    real targetY

    //! runtextmacro LinkToStruct("WanShroud", "Missile")
    //! runtextmacro LinkToStruct("WanShroud", "Target")

    timerMethod Ending
        local Timer durationTimer = Timer.GetExpired()

        local thistype this = durationTimer.GetData()

		local Aura aura = this.aura
        local DummyUnit areaDummyUnit = this.areaDummyUnit
        local Timer intervalTimer = this.intervalTimer

        call areaDummyUnit.Destroy()
        call aura.Destroy()
        call durationTimer.Destroy()
        call intervalTimer.Destroy()
    endmethod

    condMethod DamageConditions
        local Unit target = UNIT.Event.Native.GetFilter()

        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if target.Classes.Contains(UnitClass.STRUCTURE) then
            return false
        endif
        if target.Invulnerability.Try() then
            return false
        endif
        if target.IsAllyOf(User.TEMP) then
            return false
        endif
        if target.MagicImmunity.Try() then
            return false
        endif

        return true
    endmethod

	eventMethod DealDamage
		local thistype this = params.GetData()
		local Unit target = params.Unit.GetTrigger()

        call target.Effects.Create(thistype.DAMAGE_EFFECT_PATH, thistype.DAMAGE_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

        call this.caster.DamageUnitBySpell(target, damage, true, false)
	endmethod

    timerMethod Interval
        local thistype this = Timer.GetExpired().GetData()

		call this.aura.GetTargetGroup().DoEx(function thistype.DealDamage, this)
    endmethod

    condMethod AuraConditions
        local Unit target = UNIT.Event.Native.GetFilter()

        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if not target.Classes.Contains(UnitClass.GROUND) then
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

    static method Start takes Unit caster, integer level, real targetX, real targetY returns nothing
        local real areaRange = thistype.THIS_SPELL.GetAreaRange(level)
        local real targetZ = Spot.GetHeight(targetX, targetY)

        local thistype this = thistype.allocate()

        local DummyUnit areaDummyUnit = DummyUnit.Create(thistype.AREA_DUMMY_UNIT_ID, targetX, targetY, targetZ, 0.)
        local Aura aura = Aura.Create(caster)
        local Timer durationTimer = Timer.Create()
        local Timer intervalTimer = Timer.Create()

        set this.areaDummyUnit = areaDummyUnit
        set this.aura = aura
        set this.caster = caster
        set this.damage = thistype.DAMAGE_PER_INTERVAL[level]
        set this.intervalTimer = intervalTimer
        set this.level = level
        set this.targetX = targetX
        set this.targetY = targetY
        call aura.SetData(this)
        call durationTimer.SetData(this)
        call intervalTimer.SetData(this)

        call areaDummyUnit.Scale.Set(areaRange / 180.)

		call aura.SetAreaRange(thistype.THIS_SPELL.GetAreaRange(level))
        call aura.SetTargetFilter(thistype.AURA_FILTER)

		call aura.Event.Add(thistype(NULL).Target.ENDING_EVENT)
		call aura.Event.Add(thistype(NULL).Target.START_EVENT)

		call aura.Enable()

        call intervalTimer.Start(thistype.INTERVAL, true, function thistype.Interval)

        call durationTimer.Start(thistype.DURATION[level], false, function thistype.Ending)
    endmethod

    eventMethod Event_SpellEffect
        call thistype(NULL).Missile.Start(params.Unit.GetTrigger(), params.Spell.GetLevel(), params.Spot.GetTargetX(), params.Spot.GetTargetY())
    endmethod

    initMethod Init of Spells_Hero
        set thistype.AURA_FILTER = BoolExpr.GetFromFunction(function thistype.AuraConditions)
        set thistype.DAMAGE_FILTER = BoolExpr.GetFromFunction(function thistype.DamageConditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

		local integer level = thistype.THIS_SPELL.GetLevelsAmount()

		loop
			exitwhen (level < 1)

			set thistype.DAMAGE_PER_INTERVAL[level] = thistype.DAMAGE_PER_SECOND[level] * thistype.INTERVAL

			set level = level - 1
		endloop

        call thistype(NULL).Target.Init()
    endmethod
endstruct