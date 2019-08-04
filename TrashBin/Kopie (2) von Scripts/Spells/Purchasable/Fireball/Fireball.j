//! runtextmacro Spell_OpenScope("/")

//! runtextmacro BaseStruct("Fireball", "FIREBALL")
    static real array DAMAGE
    static real DAMAGE_SPELL_POWER_MOD_FACTOR
    //! runtextmacro DummyUnit_CreateSimpleType("/", "dFir", "Fireball", "DUMMY_UNIT_ID", "Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile.mdl")
    static Group ENUM_GROUP
    static real FRIENDLY_FIRE_FACTOR
    static real MIN_DAMAGE_FACTOR
    static real MIN_DAMAGE_RANGE
    static BoolExpr TARGET_FILTER

    static Spell THIS_SPELL

    Unit caster
    integer level
    Unit target
    SpellInstance whichInstance
    real x
    real y

    static method Conditions takes nothing returns boolean
        local Unit target = UNIT.Event.Native.GetFilter()

        if (target.Classes.Contains(UnitClass.DEAD)) then
            return false
        endif
        if (target.MagicImmunity.Try()) then
            return false
        endif

        return true
    endmethod

    static method Impact takes nothing returns nothing
        local User casterOwner
        local real damage
        local real damageAlly
        local Missile dummyMissile = MISSILE.Event.GetTrigger()

        local thistype this = dummyMissile.GetData()

        local Unit caster = this.caster
        local integer level = this.level
        local Unit target = this.target
        local SpellInstance whichInstance = this.whichInstance
        local real targetX = dummyMissile.Position.X.Get()
        local real targetY = dummyMissile.Position.Y.Get()

        call this.deallocate()
        call dummyMissile.Destroy()
        call whichInstance.Destroy()

        call Spot.CreateEffect(targetX, targetY, "Objects\\Spawnmodels\\Other\\NeutralBuildingExplosion\\NeutralBuildingExplosion.mdl", EffectLevel.NORMAL).Destroy()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(targetX, targetY, thistype.THIS_SPELL.GetAreaRange(level), thistype.TARGET_FILTER)

        set target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            set casterOwner = caster.Owner.Get()
            set damage = thistype.DAMAGE[level] + whichInstance.GetSpellPowerMod() * thistype.DAMAGE_SPELL_POWER_MOD_FACTOR * (1. - Math.Min(Math.DistanceByDeltas(targetX - x, targetY - y) / thistype.MIN_DAMAGE_RANGE, 1.) * (1. - thistype.MIN_DAMAGE_FACTOR))

            set damageAlly = damage * thistype.FRIENDLY_FIRE_FACTOR

            loop
                if (target.IsAllyOf(casterOwner)) then
                    call caster.DamageUnitBySpell(target, damageAlly, true, false)
                else
                    call caster.DamageUnitBySpell(target, damage, true, false)
                endif

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local Missile dummyMissile = Missile.Create()
        local DummyUnit dummyUnit
        local Unit target = UNIT.Event.GetTarget()
        local thistype this = thistype.allocate()
        local SpellInstance whichInstance = SpellInstance.Create(caster, thistype.THIS_SPELL)

        set this.caster = caster
        set this.level = whichInstance.GetLevel()
        set this.target = target
        set this.whichInstance = whichInstance
        set this.x = caster.Position.X.Get()
        set this.y = caster.Position.Y.Get()

        call dummyMissile.Arc.SetByPerc(0.06)
        call dummyMissile.CollisionSize.Set(10.)
        call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 2.)
        call dummyMissile.Impact.SetAction(function thistype.Impact)
        call dummyMissile.SetData(this)
        call dummyMissile.Speed.Set(900.)
        call dummyMissile.Position.SetFromUnit(caster)

        call dummyMissile.GoToUnit.Start(target, false)
    endmethod

    static method Init takes nothing returns nothing
        //! import obj_Fireball.j

        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        //! runtextmacro Spell_Finalize("/")
    endmethod
endstruct