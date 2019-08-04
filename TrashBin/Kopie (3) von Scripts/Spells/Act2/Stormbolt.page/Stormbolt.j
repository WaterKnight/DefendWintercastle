//! runtextmacro BaseStruct("Stormbolt", "STORMBOLT")
    //! runtextmacro DummyUnit_CreateSimpleType("/", "dStb", "Stormbolt", "DUMMY_UNIT_ID", "Abilities\\Spells\\Human\\StormBolt\\StormBoltMissile.mdl")

    Unit caster
    Unit target

    static method Impact takes nothing returns nothing
        local Missile dummyMissile = MISSILE.Event.GetTrigger()

        local thistype this = dummyMissile.GetData()

        local Unit caster = this.caster
        local Unit target = this.target

        call this.deallocate()
        call dummyMissile.Destroy()

        if (target.MagicImmunity.Try()) then
            return
        endif

        call target.Stun.AddTimed(thistype.DURATION, UNIT.Stun.NORMAL_BUFF)

        call caster.DamageUnitBySpell(target, thistype.DAMAGE, true, false)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local Missile dummyMissile = Missile.Create()
        local Unit target = UNIT.Event.GetTarget()
        local thistype this = thistype.allocate()

        set this.caster = caster
        set this.target = target

        call dummyMissile.CollisionSize.Set(10.)
        call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 2.)
        call dummyMissile.Impact.SetAction(function thistype.Impact)
        call dummyMissile.SetData(this)
        call dummyMissile.Speed.Set(700.)
        call dummyMissile.Position.SetFromUnit(caster)

        call dummyMissile.GoToUnit.Start(target, false)
    endmethod

    static method Init takes nothing returns nothing
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct