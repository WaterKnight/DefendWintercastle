//! runtextmacro Folder("MassMimesis")
	//! runtextmacro Struct("Charm")
    	eventMethod Event_SpellEffect
    		local Unit caster = params.Unit.GetTrigger()
    	    local integer level = params.Buff.GetLevel()
	        local Unit target = params.Unit.GetTarget()

			local MassMimesis parent = caster

			if ((caster != target) and target.Classes.Contains(UnitClass.HERO)) then
				return
			endif

			call Spot.CreateEffectWithSize(target.Position.X.Get(), target.Position.Y.Get(), thistype.SOURCE_EFFECT_PATH, EffectLevel.LOW, target.Scale.Get()).Destroy()

			call target.Position.SetWithCollision(parent.targetX, parent.targetY)

			call Spot.CreateEffectWithSize(target.Position.X.Get(), target.Position.Y.Get(), thistype.TARGET_EFFECT_PATH, EffectLevel.LOW, target.Scale.Get()).Destroy()
        endmethod

		static method Init takes nothing returns nothing
			call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
		endmethod
	endstruct

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

            set MassMimesis.TARGET_X = targetX
            set MassMimesis.TARGET_Y = targetY

            call caster.Buffs.Timed.Start(MassMimesis.DUMMY_BUFF, level, MassMimesis.DURATION[level])
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
endscope

//! runtextmacro BaseStruct("MassMimesis", "MASS_MIMESIS")
	static Event ANY_CAST_EVENT

    static real TARGET_X
    static real TARGET_Y

    real areaRange
    DummyUnit dummyUnit
    DummyUnit dummyUnit2
    integer level
    UnitList targetGroup
    real targetX
    real targetY

	//! runtextmacro LinkToStruct("MassMimesis", "Charm")
    //! runtextmacro LinkToStruct("MassMimesis", "Missile")

	static method AnyCast_Conditions takes Unit caster, Unit target returns boolean
		if (target.Classes.Contains(UnitClass.HERO) and not target.IsAllyOf(caster.Owner.Get())) then
			return false
		endif
		if target.Classes.Contains(UnitClass.ILLUSION) then
			return false
		endif
		if target.Classes.Contains(UnitClass.STRUCTURE) then
			return false
		endif
		if target.Classes.Contains(UnitClass.WARD) then
			return false
		endif

		return true
	endmethod

	eventMethod Event_AnyCast
		local Unit caster = params.Unit.GetTrigger()
		local Unit target = params.Unit.GetTarget()
		local Spell whichSpell = params.Spell.GetTrigger()

		if (target == NULL) then
			return
		endif

		if not thistype.AnyCast_Conditions(caster, target) then
			return
		endif

		local thistype this = caster

		local UnitList targetGroup = this.targetGroup

		if targetGroup.Contains(target) then
			return
		endif

		call targetGroup.Add(target)

		local integer level = this.level

		local real illuX = this.targetX
		local real illuY = this.targetY
		local real targetX = target.Position.X.Get()
		local real targetY = target.Position.Y.Get()

		local real dX = targetX - illuX
		local real dY = targetY - illuY

		local Unit illu = Unit.CreateIllusion(target.Type.Get(), caster.Owner.Get(), this.targetX, this.targetY, Math.AtanByDeltas(dY, dX), thistype.SUMMON_DURATION[level], thistype.SUMMON_DEATH_EFFECT_PATH)

		call illu.Effects.Create(thistype.SUMMON_BIRTH_EFFECT_PATH, thistype.SUMMON_BIRTH_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

		call illu.Ghost.Add()
		call illu.Pathing.Subtract()
		call illu.Abilities.Add(Invulnerability.THIS_SPELL)

		call illu.Order.PointTarget(Order.ATTACK, targetX, targetY)
	endmethod

    eventMethod Event_BuffLose
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

        local DummyUnit dummyUnit = this.dummyUnit
        local DummyUnit dummyUnit2 = this.dummyUnit2
        local UnitList targetGroup = this.targetGroup

        call dummyUnit.DestroyInstantly()
        call dummyUnit2.Destroy()
        call targetGroup.Destroy()

		call target.Event.Remove(ANY_CAST_EVENT)

		call HeroSpell.AddToUnit(thistype.THIS_SPELL, target)
    endmethod

    eventMethod Event_BuffGain
        local integer level = params.Buff.GetLevel()
        local Unit target = params.Unit.GetTrigger()
        local real targetX = thistype.TARGET_X
        local real targetY = thistype.TARGET_Y

        local real areaRange = thistype.THIS_SPELL.GetAreaRange(level)
        local real targetZ = Spot.GetHeight(targetX, targetY)

        local thistype this = target

        local DummyUnit dummyUnit = DummyUnit.Create(thistype.DUMMY_UNIT_ID, targetX, targetY, targetZ, 0.)
        local DummyUnit dummyUnit2 = DummyUnit.Create(thistype.DUMMY_UNIT2_ID, targetX, targetY, targetZ, 0.)

        set this.areaRange = thistype.THIS_SPELL.GetAreaRange(level)
        set this.dummyUnit = dummyUnit
        set this.dummyUnit2 = dummyUnit2
        set this.level = level
        set this.targetGroup = UnitList.Create()
        set this.targetX = targetX
        set this.targetY = targetY

		call target.Event.Add(ANY_CAST_EVENT)

        //call dummyUnit.Scale.Set(0.)
        //call dummyUnit.Scale.Timed.Add(areaRange * 5 / (3 * 128.), 0.25)
        //call dummyUnit2.Scale.Set(0.)
        //call dummyUnit2.Scale.Timed.Add(areaRange * 8 / (3 * 128.), 0.25)

		call HeroSpell.AddToUnit(thistype(NULL).Charm.THIS_SPELL, target)
    endmethod

    eventMethod Event_SpellEffect
        call thistype(NULL).Missile.Start(params.Unit.GetTrigger(), params.Spell.GetLevel(), params.Spot.GetTargetX(), params.Spot.GetTargetY())
    endmethod

    initMethod Init of Spells_Hero
    	set thistype.ANY_CAST_EVENT = Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_AnyCast)
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        local integer iteration = thistype.THIS_SPELL.GetLevelsAmount()

        loop
            set iteration = iteration - 1
            exitwhen (iteration < 1)
        endloop

		call thistype(NULL).Charm.Init()
    endmethod
endstruct