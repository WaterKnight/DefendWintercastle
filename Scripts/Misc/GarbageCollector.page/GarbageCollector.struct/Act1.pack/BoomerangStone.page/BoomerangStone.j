//! runtextmacro BaseStruct("BoomerangStone", "BOOMERANG_STONE")
    Unit caster
    Unit target

    static method CasterConditions takes Unit caster returns boolean
        if caster.Classes.Contains(UnitClass.DEAD) then
            return false
        endif

        return true
    endmethod

    eventMethod CasterImpact
        local Missile dummyMissile = params.Missile.GetTrigger()

        local thistype this = dummyMissile.GetData()

        local Unit caster = this.caster

        call this.deallocate()
        call dummyMissile.Destroy()

        if thistype.CasterConditions(caster) then
            //call caster.Buffs.Timed.Start(UNIT.Stun.NORMAL_BUFF, 1, thistype.DURATION * 0.5)
        endif
    endmethod

    static method TargetConditions takes Unit target returns boolean
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

        return true
    endmethod

    eventMethod TargetImpact
        local Missile dummyMissile = params.Missile.GetTrigger()

        local thistype this = dummyMissile.GetData()

        local Unit caster = this.caster
        local Unit target = this.target

        set User.TEMP = caster.Owner.Get()

        if thistype.TargetConditions(target) then
            call target.Buffs.Timed.Start(UNIT.Stun.NORMAL_BUFF, 1, thistype.DURATION)

            call caster.DamageUnitBySpell(target, thistype.DAMAGE, false, false)
        endif

        call dummyMissile.Impact.SetAction(function thistype.CasterImpact)
        call dummyMissile.Speed.Set(1100.)

        call dummyMissile.GoToUnit.Start(caster, function Missile.Destruction)

        call caster.Refs.Subtract()
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local Missile dummyMissile = Missile.Create()
        local Unit target = params.Unit.GetTarget()

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

        call dummyMissile.GoToUnit.Start(target, function Missile.Destruction)
    endmethod

    initMethod Init of Items_Act1
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct