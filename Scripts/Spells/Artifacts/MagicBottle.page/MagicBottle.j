//! runtextmacro Folder("MagicBottle")
    //! runtextmacro Struct("Buff")
        static method Start takes integer level, Unit target returns nothing
            call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.DURATION[level])
        endmethod

        static method Init takes nothing returns nothing
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("MagicBottle", "MAGIC_BOTTLE")
    Unit caster
    integer level
    Unit target

    //! runtextmacro LinkToStruct("MagicBottle", "Buff")

    eventMethod Impact
        local Missile dummyMissile = params.Missile.GetTrigger()

        local thistype this = dummyMissile.GetData()

        local Unit caster = this.caster
        local integer level = this.level
        local Unit target = this.target

        call this.deallocate()
        call dummyMissile.Destroy()

        call target.Effects.Create(thistype.TARGET_EFFECT_PATH, thistype.TARGET_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()

        if target.IsAllyOf(caster.Owner.Get()) then
            call caster.HealManaBySpell(target, thistype.MANA_INC[level])

            call thistype(NULL).Buff.Start(level, target)
        else
            if (target.Buffs.Dispel(true, true, true) > 0) then
                call caster.HealManaBySpell(caster, thistype.MANA_INC[level])
            endif

			call target.Whirl.AddTimed(thistype.WHIRL_DURATION[level])

            call thistype(NULL).Buff.Start(level, caster)
        endif
    endmethod

    static method StartTarget takes Unit caster, integer level, Unit target returns nothing
        local thistype this = thistype.allocate()

		local Missile dummyMissile = Missile.Create()

        set this.caster = caster
        set this.level = level
        set this.target = target

        call dummyMissile.Arc.SetByPerc(0.06)
        call dummyMissile.CollisionSize.Set(10.)
        call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 2.)
        call dummyMissile.Impact.SetAction(function thistype.Impact)
        call dummyMissile.SetData(this)
        call dummyMissile.Speed.Set(900.)
        call dummyMissile.Position.SetFromUnit(caster)

        call dummyMissile.GoToUnit.Start(target, null)
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()
        local Unit target = params.Unit.GetTarget()

        call thistype.StartTarget(caster, level, target)
    endmethod

    initMethod Init of Spells_Artifacts
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call thistype(NULL).Buff.Init()
    endmethod
endstruct