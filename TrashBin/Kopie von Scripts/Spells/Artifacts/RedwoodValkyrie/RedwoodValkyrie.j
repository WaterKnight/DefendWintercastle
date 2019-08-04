//! runtextmacro Spell_OpenScope("/")

//! runtextmacro BaseStruct("RedwoodValkyrie", "REDWOOD_VALKYRIE")
    static real array DAMAGE
    static real array DAMAGE_DAMAGE_MOD_FACTOR
    //! runtextmacro DummyUnit_CreateSimpleType("/", "dRwV", "RedwoodValkyrie", "DUMMY_UNIT_ID", "Spells\\RedwoodValkyrie\\Missile.mdx")
    static Group ENUM_GROUP
    static real IGNITE_DURATION
    static string LAUNCH_EFFECT_ATTACH_POINT
    static string LAUNCH_EFFECT_PATH
    static string MISSILE_EFFECT_ATTACH_POINT
    static string MISSILE_EFFECT_PATH
    static real array SPLASH_AREA_RANGE
    static real array SPLASH_DAMAGE
    static BoolExpr SPLASH_FILTER
    static BoolExpr TARGET_FILTER

    static Spell THIS_SPELL

    boolean onAir
    Unit caster
    real damage
    real splashAreaRange
    real splashDamage

    static method SplashConditions takes nothing returns boolean
        local Unit target = UNIT.Event.Native.GetFilter()

        if (target == Unit.TEMP) then
            return false
        endif

        if (target.Classes.Contains(UnitClass.DEAD)) then
            return false
        endif
        if (target.Classes.Contains(UnitClass.GROUND) == false) then
            return false
        endif
        if (target.Invulnerability.Try()) then
            return false
        endif
        if (target.IsAllyOf(User.TEMP)) then
            return false
        endif
        if (target.MagicImmunity.Try()) then
            return false
        endif

        return true
    endmethod

    static method TargetConditions takes nothing returns boolean
        local Missile dummyMissile
        local Unit filterUnit = UNIT.Event.Native.GetFilter()
        local thistype this

        if (filterUnit.Classes.Contains(UnitClass.DEAD)) then
            return false
        endif
        if (filterUnit.Classes.Contains(UnitClass.GROUND) == false) then
            return false
        endif

        set dummyMissile = MISSILE.Event.GetTrigger()

        set this = dummyMissile.GetData()

        if (filterUnit.IsAllyOf(this.caster.Owner.Get()) and (filterUnit.Type.Get() != UnitType.TRAP_MINE)) then
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

    static method Impact takes nothing returns nothing
        local Unit caster
        local real damage
        local Missile dummyMissile = MISSILE.Event.GetTrigger()
        local real splashAreaRange
        local real splashDamage
        local Unit target = UNIT.Event.GetTrigger()
        local real x
        local real y

        local thistype this = dummyMissile.GetData()

        local boolean onAir = this.onAir

        if (onAir == false) then
            if (target == NULL) then
                set caster = this.caster
                set splashAreaRange = this.splashAreaRange
                set splashDamage = this.splashDamage
                set x = dummyMissile.Position.X.Get()
                set y = dummyMissile.Position.Y.Get()

                call this.deallocate()
                call dummyMissile.Destroy()

                call thistype.DealSplash(caster, splashAreaRange, splashDamage, NULL, x, y)

                return
            endif
        endif

        if (target.Type.Get() == UnitType.TRAP_MINE) then
            call target.Kill()

            return
        endif

        set caster = this.caster
        set damage = this.damage
        set x = target.Position.X.Get()
        set y = target.Position.Y.Get()
        if (onAir == false) then
            set splashAreaRange = this.splashAreaRange
            set splashDamage = this.splashDamage
        endif

        call this.deallocate()
        call dummyMissile.Destroy()

        call target.Ignited.AddTimed(caster, thistype.IGNITE_DURATION)

        call caster.Damage.Events.VsUnit(target, true, damage)

        if (onAir) then
            return
        endif

        call thistype.DealSplash(caster, splashAreaRange, splashDamage, target, x, y)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local real angle
        local Unit caster = UNIT.Event.GetTrigger()
        local real casterX
        local real casterY
        local Missile dummyMissile = Missile.Create()
        local integer level = SPELL.Event.GetLevel()
        local real maxLength
        local Unit target = UNIT.Event.GetTarget()
        local real targetX = SPOT.Event.GetTargetX()
        local real targetY = SPOT.Event.GetTargetY()
        local thistype this = thistype.allocate()

        set this.caster = caster
        set this.damage = thistype.DAMAGE[level] + caster.Damage.GetAll() * thistype.DAMAGE_DAMAGE_MOD_FACTOR[level]

        call caster.Effects.Create(thistype.LAUNCH_EFFECT_PATH, thistype.LAUNCH_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()

        if ((target == NULL) or target.Classes.Contains(UnitClass.GROUND)) then
            set casterX = caster.Position.X.Get()
            set casterY = caster.Position.Y.Get()
            set maxLength = thistype.THIS_SPELL.GetRange(level)

            set angle = Math.AtanByDeltas(targetY - casterY, targetX - casterX)

            set this.onAir = false

            call dummyMissile.CollisionSize.Set(thistype.THIS_SPELL.GetAreaRange(level))
            call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 1.5).AddEffect(thistype.MISSILE_EFFECT_PATH, thistype.MISSILE_EFFECT_ATTACH_POINT, EffectLevel.NORMAL)
            call dummyMissile.Impact.SetAction(function thistype.Impact)
            call dummyMissile.SetData(this)
            call dummyMissile.Speed.Set(1300.)
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
            call dummyMissile.Speed.Set(1300.)
            call dummyMissile.Position.SetFromUnit(caster)

            call dummyMissile.GoToUnit.Start(target, true)
        endif
    endmethod

    static method Init takes nothing returns nothing
        //! import obj_RedwoodValkyrie.j

        set thistype.ENUM_GROUP = Group.Create()
        set thistype.SPLASH_FILTER = BoolExpr.GetFromFunction(function thistype.SplashConditions)
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.TargetConditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct