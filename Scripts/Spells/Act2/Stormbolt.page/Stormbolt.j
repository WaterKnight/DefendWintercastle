//! runtextmacro BaseStruct("Stormbolt", "STORMBOLT")
    Unit caster
    integer level
    Unit target

    eventMethod Impact
        local Missile dummyMissile = params.Missile.GetTrigger()
        local Unit target = params.Unit.GetTrigger()

        local thistype this = dummyMissile.GetData()

        local Unit caster = this.caster

        call this.deallocate_demount()
        call dummyMissile.Destroy()

		if (target == NULL) then
			return
		endif

        if target.MagicImmunity.Try() then
            return
        endif

        call target.Buffs.Timed.Start(UNIT.Stun.NORMAL_BUFF, this.level, thistype.DURATION)

        call caster.DamageUnitBySpell(target, thistype.DAMAGE, true, false)
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()
        local Unit target = params.Unit.GetTarget()

		local Missile dummyMissile = Missile.Create()

		local thistype this = thistype.allocate_mount(dummyMissile)

        set this.caster = caster
        set this.level = level

        call dummyMissile.CollisionSize.Set(10.)
        call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 2.)
        call dummyMissile.Impact.SetAction(function thistype.Impact)
        call dummyMissile.SetData(this)
        call dummyMissile.Speed.Set(700.)
        call dummyMissile.Position.SetFromUnit(caster)

        call dummyMissile.GoToUnit.Start(target, null)
    endmethod

    initMethod Init of Spells_Act2
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct