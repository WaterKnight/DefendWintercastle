//! runtextmacro BaseStruct("Thunderstrike", "THUNDER_STRIKE")
    static Group ENUM_GROUP
    static BoolExpr TARGET_FILTER

    DummyUnit chargeDummyUnit
    DummyUnit lightDummyUnit
    real areaRange
    Unit caster
    real damage
    Timer delayTimer
    real targetX
    real targetY
    real targetZ
    SpellInstance whichInstance

    condMethod Conditions
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
        if target.MagicImmunity.Try() then
            return false
        endif

        return true
    endmethod

    timerMethod Nova
        local Timer delayTimer = Timer.GetExpired()

        local thistype this = delayTimer.GetData()

        local real targetX = this.targetX
        local real targetY = this.targetY

        local SpellInstance whichInstance = this.whichInstance

        local integer level = whichInstance.GetLevel()

        local DummyUnit novaDummy = DummyUnit.Create(thistype.NOVA_DUMMY_UNIT_ID, targetX, targetY, Spot.GetHeight(targetX, targetY), 0.)

        call this.deallocate()
        call delayTimer.Destroy()
        call lightDummyUnit.DestroyInstantly()
        call whichInstance.Destroy()

        call novaDummy.Scale.Set(thistype.THIS_SPELL.GetAreaRange(level) / (100.))

        call novaDummy.DestroyTimed.Start(2.)
    endmethod

    timerMethod Delay
        local Timer delayTimer = Timer.GetExpired()

        local thistype this = delayTimer.GetData()

        local real areaRange = this.areaRange
        local Unit caster = this.caster
        local DummyUnit chargeDummyUnit = this.chargeDummyUnit
        local real damage = this.damage
        local real targetX = this.targetX
        local real targetY = this.targetY
        local SpellInstance whichInstance = this.whichInstance

        local integer level = whichInstance.GetLevel()

        call chargeDummyUnit.DestroyInstantly()

        call Spot.CreateEffect(targetX, targetY, thistype.BOLT_EFFECT_PATH, EffectLevel.LOW).DestroyTimed.Start(0.5)

        set User.TEMP = caster.Owner.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(targetX, targetY, areaRange, thistype.TARGET_FILTER)

        local Unit target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            local real stunHeroDuration = thistype.STUN_HERO_DURATION[level]
            local real stunNormDuration = thistype.STUN_DURATION[level]

            loop
            	local real stunDuration

				if target.Classes.Contains(UnitClass.HERO) then
					set stunDuration = stunHeroDuration
				else
					set stunDuration = stunNormDuration
				endif

                call target.Buffs.Timed.Start(UNIT.Stun.NORMAL_BUFF, level, stunDuration)

                call caster.DamageUnitBySpell(target, damage, true, true)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif

        call delayTimer.Start(0.15, false, function thistype.Nova)
    endmethod

    static method Start takes Unit caster, integer level, real targetX, real targetY, SpellInstance whichInstance returns nothing
        local real areaRange = thistype.THIS_SPELL.GetAreaRange(level)
        local real targetZ = Spot.GetHeight(targetX, targetY)

        local thistype this = thistype.allocate()

        local DummyUnit chargeDummyUnit = DummyUnit.Create(thistype.CHARGE_DUMMY_UNIT_ID, targetX, targetY, targetZ, UNIT.Facing.STANDARD)
		local Timer delayTimer = Timer.Create()
        local DummyUnit lightDummyUnit = DummyUnit.Create(thistype.LIGHT_DUMMY_UNIT_ID, targetX, targetY, targetZ, UNIT.Facing.STANDARD)

        set this.areaRange = areaRange
        set this.caster = caster
        set this.chargeDummyUnit = chargeDummyUnit
        set this.damage = thistype.DAMAGE[level]
        set this.delayTimer = delayTimer
        set this.lightDummyUnit = lightDummyUnit
        set this.targetX = targetX
        set this.targetY = targetY
        set this.targetZ = targetZ
        set this.whichInstance = whichInstance
        call delayTimer.SetData(this)

        call lightDummyUnit.SetScale(areaRange / (256. / 5))
        call lightDummyUnit.VertexColor.Set(255, 255, 255, 127)

        call chargeDummyUnit.Position.Z.SetFlyHeightNative(thistype.CHARGE_DUMMY_HEIGHT, thistype.DELAY - thistype.CHARGE_DUMMY_WAIT_AFTER_TIME)
        call chargeDummyUnit.Scale.Timed.Add(areaRange / 128. - 1., thistype.DELAY)

        call delayTimer.Start(thistype.DELAY, false, function thistype.Delay)
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()

        call thistype.Start(caster, params.Spell.GetLevel(), params.Spot.GetTargetX(), params.Spot.GetTargetY(), SpellInstance.Create(caster, thistype.THIS_SPELL))
    endmethod

    initMethod Init of Spells_Purchasable
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct