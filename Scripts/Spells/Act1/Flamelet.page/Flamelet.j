//! runtextmacro BaseStruct("Flamelet", "FLAMELET")
    static BoolExpr TARGET_FILTER

    real damage
    Missile dummyMissile
    integer level
    real maxLength
    real sourceX
    real sourceY
    SpellInstance whichInstance

    condMethod TargetConditions
        local EventResponse params = EventResponse.GetTrigger()
        local Unit target = UNIT.Event.Native.GetFilter()

        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if not target.Classes.Contains(UnitClass.GROUND) then
            return false
        endif

        local Missile dummyMissile = params.Missile.GetTrigger()

        local thistype this = dummyMissile.GetData()

        local SpellInstance whichInstance = this.whichInstance

        if target.IsAllyOf(whichInstance.GetCaster().Owner.Get()) then
            return false
        endif

        return true
    endmethod

    eventMethod Impact
        local Missile dummyMissile = params.Missile.GetTrigger()

        local thistype this = dummyMissile.GetData()

        call dummyMissile.Destroy()
    endmethod

    eventMethod Collision
        local Missile dummyMissile = params.Missile.GetTrigger()
        local Unit target = params.Unit.GetTrigger()

        local thistype this = dummyMissile.GetData()

        local real damage = this.damage
        local integer level = this.level
        local SpellInstance whichInstance = this.whichInstance

        local Unit caster = whichInstance.GetCaster()

        call dummyMissile.Destroy()
        call whichInstance.Refs.Subtract()

		local real duration

		if target.Classes.Contains(UnitClass.HERO) then
			set duration = thistype.IGNITE_HERO_DURATION
		else
			set duration = thistype.IGNITE_DURATION
		endif

		call target.Buffs.Timed.StartEx(thistype.IGNITION_BUFF, level, caster, duration)

        call caster.DamageUnitBySpell(target, damage, true, false)
    endmethod

    static method Start takes SpellInstance whichInstance returns nothing
        local Unit caster = whichInstance.GetCaster()
        local integer level = whichInstance.GetLevel()
        local real targetX = whichInstance.GetTargetX()
        local real targetY = whichInstance.GetTargetY()

        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()
        local real maxLength = thistype.THIS_SPELL.GetRange(level)

		local real angle = Math.AtanByDeltas(targetY - casterY, targetX - casterX)

        local thistype this = thistype.allocate()

        local Missile dummyMissile = this.dummyMissile

        set this.damage = thistype.DAMAGE
        set this.level = level
        set this.maxLength = maxLength
        set this.sourceX = casterX
        set this.sourceY = casterY
        set this.whichInstance = whichInstance

        call whichInstance.Refs.Add()

        call dummyMissile.CollisionSize.Set(thistype.THIS_SPELL.GetAreaRange(level))
        call dummyMissile.SetData(this)
        call dummyMissile.Impact.SetAction(function thistype.Impact)
        call dummyMissile.Speed.Set(thistype.SPEED)

        call dummyMissile.GoToSpot.Start(casterX + maxLength * Math.Cos(angle), casterY + maxLength * Math.Sin(angle), Spot.GetHeight(targetX, targetY) + UNIT_TYPE.Impact.Z.STANDARD)

        call dummyMissile.Position.AddCollision(function thistype.Collision, thistype.TARGET_FILTER)
    endmethod

    eventMethod Event_EndCast
        local boolean success = params.Spell.IsChannelComplete()
        local SpellInstance whichInstance = params.SpellInstance.GetTrigger()

        local thistype this = whichInstance

        if not success then
            call this.dummyMissile.Destroy()

            return
        endif

        call thistype.Start(whichInstance)
    endmethod

    static method StartCharging takes SpellInstance whichInstance returns nothing
        local thistype this = whichInstance

        local Unit caster = whichInstance.GetCaster()
        local integer level = whichInstance.GetLevel()

        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()
        local real maxLength = thistype.THIS_SPELL.GetRange(level)
        local real targetX = whichInstance.GetTargetX()
        local real targetY = whichInstance.GetTargetY()

        local real angle = Math.AtanByDeltas(targetY - casterY, targetX - casterX)
		local Missile dummyMissile = Missile.Create()

        set this.dummyMissile = dummyMissile
        set this.whichInstance = whichInstance

        call dummyMissile.Position.SetFromUnit(caster)

        call dummyMissile.Angle.DirectToSpot(casterX + maxLength * Math.Cos(angle), casterY + maxLength * Math.Sin(angle), Spot.GetHeight(targetX, targetY) + UNIT_TYPE.Impact.Z.STANDARD)

        local DummyUnit dummyUnit = dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 1.5)

        call dummyUnit.Scale.Timed.Add(1, whichInstance.GetSpell().GetChannelTime(level))
        call dummyUnit.AddEffect(thistype.MISSILE_EFFECT_PATH, thistype.MISSILE_EFFECT_ATTACH_POINT, EffectLevel.NORMAL)
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local SpellInstance whichInstance = params.SpellInstance.GetTrigger()

        call caster.Effects.Create(thistype.LAUNCH_EFFECT_PATH, thistype.LAUNCH_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()

        call thistype.StartCharging(whichInstance)
    endmethod

    initMethod Init of Spells_Act1
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.TargetConditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Finish.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_EndCast))
        call UNIT.Ignited.NORMAL_BUFF.Variants.Add(thistype.IGNITION_BUFF)
    endmethod
endstruct