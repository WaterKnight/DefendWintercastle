//! runtextmacro BaseStruct("SerpentWard", "SERPENT_WARD")
    //! runtextmacro DummyUnit_CreateSimpleType("/", "dSeW", "Serpent Ward", "DUMMY_UNIT_ID", "Other\\FireTail\\FireTail.mdl")

    Unit caster
    real targetX
    real targetY

    static method Start takes Unit caster, real targetX, real targetY returns nothing
        local User casterOwner = caster.Owner.Get()
        local integer iteration = thistype.SUMMON_AMOUNT

        loop
            call Unit.CreateSummon(thistype.SUMMON_UNIT_TYPE, casterOwner, targetX, targetY, UNIT.Facing.STANDARD, thistype.DURATION)

            set iteration = iteration - 1
            exitwhen (iteration < 1)
        endloop
    endmethod

    static method Impact takes nothing returns nothing
        local Missile dummyMissile = MISSILE.Event.GetTrigger()

        local thistype this = dummyMissile.GetData()

        local Unit caster = this.caster
        local real targetX = this.targetX
        local real targetY = this.targetY

        call this.deallocate()
        call dummyMissile.Destroy()

        call thistype.Start(caster, targetX, targetY)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local Missile dummyMissile = Missile.Create()
        local real targetX = SPOT.Event.GetTargetX()
        local real targetY = SPOT.Event.GetTargetY()
        local thistype this = thistype.allocate()

        set this.caster = caster
        set this.targetX = targetX
        set this.targetY = targetY

        call dummyMissile.Arc.SetByPerc(0.1)
        call dummyMissile.CollisionSize.Set(10.)
        call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 2.)
        call dummyMissile.Impact.SetAction(function thistype.Impact)
        call dummyMissile.SetData(this)
        call dummyMissile.Speed.Set(900.)
        call dummyMissile.Position.SetFromUnit(caster)

        call dummyMissile.GoToSpot.Start(targetX, targetY, Spot.GetHeight(targetX, targetY))
    endmethod

    static method Init takes nothing returns nothing
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct