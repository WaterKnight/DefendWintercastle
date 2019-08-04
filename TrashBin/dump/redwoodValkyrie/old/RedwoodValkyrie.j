//! runtextmacro BaseStruct("RedwoodValkyrie", "REDWOOD_VALKYRIE")
    static Group ENUM_GROUP
    static BoolExpr SPLASH_FILTER
    static BoolExpr TARGET_FILTER

    boolean onAir
    Unit caster
    real damage
    integer level
    real maxLength
    real sourceX
    real sourceY
    real splashAreaRange
    real splashDamage

    static method SplashConditions takes nothing returns boolean
        local Unit target = UNIT.Event.Native.GetFilter()

        if (target == Unit.TEMP) then
            return false
        endif

        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if (target.Classes.Contains(UnitClass.GROUND) == false) then
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

    static method TargetConditions takes nothing returns boolean
        local Missile dummyMissile
        local EventResponse params = EventResponse.GetTrigger()
        local Unit target = UNIT.Event.Native.GetFilter()
        local thistype this

        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if (target.Classes.Contains(UnitClass.GROUND) == false) then
            return false
        endif

        set dummyMissile = params.Missile.GetTrigger()

        set this = dummyMissile.GetData()

        if (target.IsAllyOf(this.caster.Owner.Get()) and (target.Type.Get() != HopNDrop(NULL).SetMines.Mine.SUMMON_UNIT_TYPE)) then
            return false
        endif

        return true
    endmethod

    static method DealSplash takes Unit caster, real splashAreaRange, real splashDamage, Unit target, real x, real y returns nothing
        call Spot.CreateEffect(x, y, "Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl", EffectLevel.NORMAL).Destroy()

        set User.TEMP = caster.Owner.Get()
        set Unit.TEMP = target

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, splashAreaRange, thistype.SPLASH_FILTER)

        set target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            loop
                call caster.DamageUnitBySpell(target, splashDamage, true, false)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
    endmethod

    eventMethod Impact
        local Unit caster
        local real damage
        local Missile dummyMissile = params.Missile.GetTrigger()
        local integer level
        local real splashAreaRange
        local real splashDamage
        local Unit target = params.Unit.GetTrigger()

        local thistype this = dummyMissile.GetData()
        local real x = dummyMissile.Position.X.Get()
        local real y = dummyMissile.Position.Y.Get()

        local real damageDistanceFactor = Math.Min(Math.DistanceByDeltas(x - this.sourceX, y - this.sourceY) / this.maxLength, 1.) * (1. + thistype.DAMAGE_DISTANCE_FACTOR)

        local boolean onAir = this.onAir

        if (onAir == false) then
            if (target == NULL) then
                set caster = this.caster
                set splashAreaRange = this.splashAreaRange
                set splashDamage = this.splashDamage * damageDistanceFactor

                call this.deallocate()
                call dummyMissile.Destroy()

                call thistype.DealSplash(caster, splashAreaRange, splashDamage, NULL, x, y)

                return
            endif
        endif

        set caster = this.caster
        set damage = this.damage * damageDistanceFactor
        set level = this.level
        set x = target.Position.X.Get()
        set y = target.Position.Y.Get()
        if (onAir == false) then
            set splashAreaRange = this.splashAreaRange
            set splashDamage = this.splashDamage
        endif

        call this.deallocate()

        call dummyMissile.Destroy()

        call target.Ignited.AddTimedByBuff(thistype.IGNITION_BUFF, level, thistype.IGNITE_DURATION, caster)

        call caster.Damage.Events.VsUnit(target, true, damage)

        if onAir then
            return
        endif

        call thistype.DealSplash(caster, splashAreaRange, splashDamage, target, x, y)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local real angle
        local Unit caster = params.Unit.GetTrigger()
        local Missile dummyMissile = Missile.Create()
        local integer level = params.Spell.GetLevel()
        local Unit target = params.Unit.GetTarget()
        local real targetX = params.Spot.GetTargetX()
        local real targetY = params.Spot.GetTargetY()
        local thistype this = thistype.allocate()

        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()
        local real maxLength = thistype.THIS_SPELL.GetRange(level)

        set this.caster = caster
        set this.damage = thistype.DAMAGE[level] + caster.Damage.Get() * thistype.DAMAGE_DAMAGE_MOD_FACTOR[level]
        set this.level = level
        set this.maxLength = maxLength
        set this.sourceX = casterX
        set this.sourceY = casterY

        call caster.Effects.Create(thistype.LAUNCH_EFFECT_PATH, thistype.LAUNCH_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()

        if ((target == NULL) or target.Classes.Contains(UnitClass.GROUND)) then
            set angle = Math.AtanByDeltas(targetY - casterY, targetX - casterX)

            set this.onAir = false

            call dummyMissile.CollisionSize.Set(thistype.THIS_SPELL.GetAreaRange(level))
            call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 1.5).AddEffect(thistype.MISSILE_EFFECT_PATH, thistype.MISSILE_EFFECT_ATTACH_POINT, EffectLevel.NORMAL)
            call dummyMissile.Impact.SetAction(function thistype.Impact)
            call dummyMissile.SetData(this)
            call dummyMissile.Speed.Set(thistype.SPEED)
            call dummyMissile.Position.SetFromUnit(caster)

            call dummyMissile.GoToSpot.Start(casterX + maxLength * Math.Cos(angle), casterY + maxLength * Math.Sin(angle), Spot.GetHeight(targetX, targetY) + UNIT_TYPE.Impact.Z.STANDARD)

            call dummyMissile.Impact.SetFilter(thistype.TARGET_FILTER)
        else
            set this.onAir = true
            set this.splashAreaRange = thistype.SPLASH_AREA_RANGE[level]
            set this.splashDamage = thistype.SPLASH_DAMAGE[level]

            call dummyMissile.Arc.SetByPerc(0.06)
            call dummyMissile.CollisionSize.Set(thistype.THIS_SPELL.GetAreaRange(level))
            call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 1.5).AddEffect(thistype.MISSILE_EFFECT_PATH, thistype.MISSILE_EFFECT_ATTACH_POINT, EffectLevel.NORMAL)
            call dummyMissile.Impact.SetAction(function thistype.Impact)
            call dummyMissile.SetData(this)
            call dummyMissile.Speed.Set(thistype.SPEED)
            call dummyMissile.Position.SetFromUnit(caster)

            call dummyMissile.GoToUnit.Start(target, true)
        endif

        call dummyMissile.DummyUnit.Get().Scale.Timed.Add(thistype.DAMAGE_DISTANCE_FACTOR, Math.GetMovementDuration(maxLength, thistype.SPEED, thistype.ACCELERATION))
    endmethod

    static method Init takes nothing returns nothing
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.SPLASH_FILTER = BoolExpr.GetFromFunction(function thistype.SplashConditions)
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.TargetConditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
        call UNIT.Ignited.CreateVariant(thistype.IGNITION_BUFF)
    endmethod
endstruct