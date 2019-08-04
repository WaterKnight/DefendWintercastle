//! runtextmacro BaseStruct("BurningSpiritMeteorite", "BURNING_SPIRIT_METEORITE")
    Unit caster
    integer level
    Unit target

    eventMethod Impact
        local Missile dummyMissile = params.Missile.GetTrigger()

        local thistype this = dummyMissile.GetData()

        local Unit caster = this.caster
        local integer level = this.level
        local Unit target = this.target

        call this.deallocate_demount()
        call dummyMissile.Destroy()

        call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.DURATION)
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()
        local Unit target = params.Unit.GetTarget()

		local Missile dummyMissile = Missile.Create()

		local thistype this = thistype.allocate_mount(dummyMissile)

        set this.caster = caster
        set this.level = level
        set this.target = target

        call dummyMissile.CollisionSize.Set(10.)
        call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 2.)
        call dummyMissile.Impact.SetAction(function thistype.Impact)
        call dummyMissile.SetData(this)
        call dummyMissile.Speed.Set(900.)
        call dummyMissile.Position.SetFromUnit(caster)

        call dummyMissile.GoToUnit.Start(target, null)
    endmethod

    initMethod Init of Spells_Misc
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct