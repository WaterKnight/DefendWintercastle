//! runtextmacro Folder("Knockout")
    //! runtextmacro Struct("Target")
        eventMethod Event_BuffGain
            local integer level = params.Buff.GetLevel()
            local Unit target = params.Unit.GetTrigger()

            local thistype this = target

            call target.Buffs.Timed.Start(UNIT.Stun.NORMAL_BUFF, level, thistype.STUN_DURATION)
        endmethod

        static method Start takes Unit caster, integer level, Unit target returns nothing
            if not target.Buffs.Contains(thistype.DUMMY_BUFF) then
                call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.BUFF_DURATION)
            endif

            call target.Position.Timed.Accelerated.AddKnockback(900., -900., Math.AtanByDeltas(target.Position.Y.Get() - caster.Position.Y.Get(), target.Position.X.Get() - caster.Position.X.Get()), 0.14)

            call caster.DamageUnitBySpell(target, thistype.DAMAGE, true, false)
        endmethod

        static method Init takes nothing returns nothing
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Knockout", "KNOCKOUT")
    Unit caster
    integer level
    Unit target

    //! runtextmacro LinkToStruct("Knockout", "Target")

    static method Conditions takes Unit caster, Unit target returns boolean
        if (target == NULL) then
            return false
        endif

        if target.IsAllyOf(caster.Owner.Get()) then
            return false
        endif
        if target.MagicImmunity.Try() then
            return false
        endif

        return true
    endmethod

    eventMethod Impact
        local Missile dummyMissile = params.Missile.GetTrigger()

        local thistype this = dummyMissile.GetData()

        local Unit caster = this.caster
        local integer level = this.level
        local Unit target = this.target

		call this.deallocate_demount()
        call dummyMissile.Destroy()

		if (target == NULL) then
			return
		endif

        if thistype.Conditions(caster, target) then
            call thistype(NULL).Target.Start(caster, level, target)
        endif
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

        call caster.Position.SetWithCollision(target.Position.X.Get(), target.Position.Y.Get())

        call caster.Facing.SetToUnit(target)

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

        call thistype(NULL).Target.Init()
    endmethod
endstruct