//! runtextmacro BaseStruct("Vomit", "VOMIT")
    static real array DAMAGE
    //! runtextmacro DummyUnit_CreateSimpleType("/", "dVom", "Vomit", "DUMMY_UNIT_ID", "Abilities\\Weapons\\ChimaeraAcidMissile\\ChimaeraAcidMissile.mdl")
    static real array POISON_DURATION
    static real array POISON_HERO_DURATION

    static Spell THIS_SPELL

    //! import "Spells\Artifacts\Vomit\obj.j"

    Unit caster
    integer level
    Unit target
    SpellInstance whichInstance
    real x
    real y

    static method Impact takes nothing returns nothing
        local Missile dummyMissile = MISSILE.Event.GetTrigger()

        local thistype this = dummyMissile.GetData()

        local Unit caster = this.caster
        local integer level = this.level
        local Unit target = this.target
        local SpellInstance whichInstance = this.whichInstance

        call this.deallocate()
        call dummyMissile.Destroy()

        if (target.Classes.Contains(UnitClass.HERO)) then
            call target.Poisoned.AddTimed(thistype.POISON_HERO_DURATION[level])
        else
            call target.Poisoned.AddTimed(thistype.POISON_DURATION[level])
        endif

        call caster.DamageUnitBySpell(target, thistype.DAMAGE[level], true, false)

        call whichInstance.Destroy()
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
        call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 1.)
        call dummyMissile.Impact.SetAction(function thistype.Impact)
        call dummyMissile.SetData(this)
        call dummyMissile.Speed.Set(900.)
        call dummyMissile.Position.SetFromUnit(caster)

        call dummyMissile.GoToUnit.Start(target, false)
    endmethod

    static method Init takes nothing returns nothing
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct