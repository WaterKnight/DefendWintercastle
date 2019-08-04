//! runtextmacro BaseStruct("BoomerangStone", "BOOMERANG_STONE")
    static real DAMAGE
    //! runtextmacro DummyUnit_CreateSimpleType("/", "dBoS", "Boomerang Stone", "DUMMY_UNIT_ID", "Abilities\\Weapons\\RockBoltMissile\\RockBoltMissile.mdl")
    static real DURATION

    static Spell THIS_SPELL

    //! import "Spells\Items\Act1\BoomerangStone\obj.j"

    Unit caster
    Unit target

    static method CasterConditions takes Unit caster returns boolean
        if (caster.Classes.Contains(UnitClass.DEAD)) then
            return false
        endif

        return true
    endmethod

    static method CasterImpact takes nothing returns nothing
        local Missile dummyMissile = MISSILE.Event.GetTrigger()

        local thistype this = dummyMissile.GetData()

        local Unit caster = this.caster

        call this.deallocate()
        call dummyMissile.Destroy()

        if (thistype.CasterConditions(caster)) then
            call caster.Stun.AddTimed(thistype.DURATION, UNIT.Stun.NORMAL_BUFF)
        endif
    endmethod

    static method TargetConditions takes Unit target returns boolean
        if (target.Classes.Contains(UnitClass.DEAD)) then
            return false
        endif
        if (target.Classes.Contains(UnitClass.STRUCTURE)) then
            return false
        endif
        if (target.Invulnerability.Try()) then
            return false
        endif
        if (target.IsAllyOf(User.TEMP)) then
            return false
        endif

        return true
    endmethod

    static method TargetImpact takes nothing returns nothing
        local Missile dummyMissile = MISSILE.Event.GetTrigger()

        local thistype this = dummyMissile.GetData()

        local Unit caster = this.caster
        local Unit target = this.target

        set User.TEMP = caster.Owner.Get()

        if (thistype.TargetConditions(target)) then
            call target.Stun.AddTimed(thistype.DURATION, UNIT.Stun.NORMAL_BUFF)

            call caster.DamageUnitBySpell(target, thistype.DAMAGE, false, false)
        endif

        call dummyMissile.Impact.SetAction(function thistype.CasterImpact)
        call dummyMissile.Speed.Set(1100.)

        call dummyMissile.GoToUnit.Start(caster, false)

        call caster.Refs.Subtract()
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local Missile dummyMissile = Missile.Create()
        local Unit target = UNIT.Event.GetTarget()
        local thistype this = thistype.allocate()

        set this.caster = caster
        set this.target = target
        call caster.Refs.Add()

        call dummyMissile.CollisionSize.Set(10.)
        call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 2.)
        call dummyMissile.Impact.SetAction(function thistype.TargetImpact)
        call dummyMissile.SetData(this)
        call dummyMissile.Speed.Set(1250.)
        call dummyMissile.Position.SetFromUnit(caster)

        call Missile.Create().GoToUnit.Start(target, false)
    endmethod

    static method Init takes nothing returns nothing
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct