//! runtextmacro Folder("RedwoodValkyrie")
    //! runtextmacro Struct("Air")
        static Group ENUM_GROUP
        static BoolExpr SPLASH_FILTER

        SpellInstance whichInstance

        condMethod SplashConditions
            local Unit target = UNIT.Event.Native.GetFilter()

            if target.Classes.Contains(UnitClass.DEAD) then
                return false
            endif
            if not target.Classes.Contains(UnitClass.AIR) then
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

        static method DealSplash takes Unit caster, real splashAreaRange, real splashDamage, real x, real y returns nothing
            call Spot.CreateEffect(x, y, "Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl", EffectLevel.NORMAL).Destroy()

            set User.TEMP = caster.Owner.Get()

            call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, splashAreaRange, thistype.SPLASH_FILTER)

            local Unit target = thistype.ENUM_GROUP.FetchFirst()

            if (target != NULL) then
                loop
                    call caster.DamageUnitBySpell(target, splashDamage, true, false)

                    set target = thistype.ENUM_GROUP.FetchFirst()
                    exitwhen (target == NULL)
                endloop
            endif
        endmethod

        eventMethod Impact
            local Missile dummyMissile = params.Missile.GetTrigger()

            local thistype this = dummyMissile.GetData()
            local real x = dummyMissile.Position.X.Get()
            local real y = dummyMissile.Position.Y.Get()

            local SpellInstance whichInstance = this.whichInstance

            local Unit caster = whichInstance.GetCaster()
            local integer level = whichInstance.GetLevel()

            call this.deallocate_demount()
            call dummyMissile.Destroy()

            call thistype.DealSplash(caster, thistype.AREA_RANGE[level], thistype.DAMAGE[level] + whichInstance.GetDamageMod() * thistype.DAMAGE_DAMAGE_MOD_FACTOR, x, y)

            call whichInstance.Refs.Subtract()
        endmethod

        static method Start takes SpellInstance whichInstance returns nothing
            local Unit caster = whichInstance.GetCaster()
            local integer level = whichInstance.GetLevel()
            local Unit target = whichInstance.GetTargetUnit()

			local Missile dummyMissile = Missile.Create()

			local thistype this = thistype.allocate_mount(dummyMissile)

            set this.whichInstance = whichInstance

            call dummyMissile.CollisionSize.Set(RedwoodValkyrie.THIS_SPELL.GetAreaRange(level))
            call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 1.5).AddEffect(thistype.MISSILE_EFFECT_PATH, thistype.MISSILE_EFFECT_ATTACH_POINT, EffectLevel.NORMAL)
            call dummyMissile.Impact.SetAction(function thistype.Impact)
            call dummyMissile.SetData(this)
            call dummyMissile.Speed.Set(RedwoodValkyrie.SPEED)
            call dummyMissile.Position.SetFromUnit(caster)

            call dummyMissile.GoToUnit.Start(target, null)

            call whichInstance.Refs.Add()
        endmethod

        static method Init takes nothing returns nothing
            set thistype.ENUM_GROUP = Group.Create()
            set thistype.SPLASH_FILTER = BoolExpr.GetFromFunction(function thistype.SplashConditions)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("RedwoodValkyrie", "REDWOOD_VALKYRIE")
    static BoolExpr TARGET_FILTER

    real damage
    real maxLength
    real sourceX
    real sourceY
    UnitList targetGroup
    SpellInstance whichInstance

    //! runtextmacro LinkToStruct("RedwoodValkyrie", "Air")

    condEventMethod TargetConditions
		local Missile dummyMissile = params.Missile.GetTrigger()
        local Unit target = UNIT.Event.Native.GetFilter()

        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if not target.Classes.Contains(UnitClass.GROUND) then
            return false
        endif

        local thistype this = dummyMissile.GetData()

        if this.targetGroup.Contains(target) then
            return false
        endif

        local SpellInstance whichInstance = this.whichInstance

        if target.IsAllyOf(whichInstance.GetCaster().Owner.Get()) then
            return false
        endif

        return true
    endmethod

    eventMethod Impact
        local Missile dummyMissile = params.Missile.GetTrigger()

        local thistype this = dummyMissile.GetData()

        call this.targetGroup.Destroy()

        call this.deallocate()
        call dummyMissile.Destroy()
    endmethod

    eventMethod Collision
        local Missile dummyMissile = params.Missile.GetTrigger()
        local Unit target = params.Unit.GetTrigger()

        local thistype this = dummyMissile.GetData()

        local real damage = this.damage
        local SpellInstance whichInstance = this.whichInstance

        local Unit caster = whichInstance.GetCaster()

        call this.targetGroup.Add(target)

		local real igniteDuration

		if target.Classes.Contains(UnitClass.HERO) then
			set igniteDuration = thistype.IGNITE_HERO_DURATION
		else
			set igniteDuration = thistype.IGNITE_DURATION
		endif

        call target.Buffs.Timed.StartEx(thistype.IGNITION_BUFF, whichInstance.GetLevel(), caster, igniteDuration)

        call caster.Damage.Events.VsUnit(target, true, damage)
    endmethod

    static method Start takes SpellInstance whichInstance returns nothing
        local Unit caster = whichInstance.GetCaster()
        local integer level = whichInstance.GetLevel()
        local real targetX = whichInstance.GetTargetX()
        local real targetY = whichInstance.GetTargetY()

        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()
        local real maxLength = thistype.THIS_SPELL.GetRange(level)

        local thistype this = thistype.allocate()

		local Missile dummyMissile = Missile.Create()

        local real angle = Math.AtanByDeltas(targetY - casterY, targetX - casterX)

        set this.damage = thistype.DAMAGE[level] + caster.Damage.Get() * thistype.DAMAGE_DAMAGE_MOD_FACTOR[level]
        set this.maxLength = maxLength
        set this.sourceX = casterX
        set this.sourceY = casterY
        set this.targetGroup = UnitList.Create()
        set this.whichInstance = whichInstance

        call dummyMissile.CollisionSize.Set(thistype.THIS_SPELL.GetAreaRange(level))
        call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 1.5).AddEffect(thistype.MISSILE_EFFECT_PATH, thistype.MISSILE_EFFECT_ATTACH_POINT, EffectLevel.NORMAL)
        call dummyMissile.SetData(this)
        call dummyMissile.Impact.SetAction(function thistype.Impact)
        call dummyMissile.Speed.Set(thistype.SPEED)
        call dummyMissile.Position.SetFromUnit(caster)

        call dummyMissile.GoToSpot.Start(casterX + maxLength * Math.Cos(angle), casterY + maxLength * Math.Sin(angle), Spot.GetHeight(targetX, targetY) + UNIT_TYPE.Impact.Z.STANDARD)

        call dummyMissile.Position.AddCollision(function thistype.Collision, thistype.TARGET_FILTER)
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local Unit target = params.Unit.GetTarget()
        local SpellInstance whichInstance = params.SpellInstance.GetTrigger()

        call caster.Effects.Create(thistype.LAUNCH_EFFECT_PATH, thistype.LAUNCH_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()

        if ((target != NULL) and not target.Classes.Contains(UnitClass.GROUND)) then
            call thistype(NULL).Air.Start(whichInstance)

            return
        endif

        call thistype.Start(whichInstance)
    endmethod

    initMethod Init of Spells_Artifacts
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.TargetConditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
        call UNIT.Ignited.NORMAL_BUFF.Variants.Add(thistype.IGNITION_BUFF)

        call thistype(NULL).Air.Init()
    endmethod
endstruct