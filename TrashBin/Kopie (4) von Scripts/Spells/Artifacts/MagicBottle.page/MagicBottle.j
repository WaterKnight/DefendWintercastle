//! runtextmacro Folder("MagicBottle")
    //! runtextmacro Struct("Buff")
        real attackSpeedAdd
        real spellPowerAdd

        static method Event_BuffLose takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = target

            local real attackSpeedAdd = this.attackSpeedAdd
            local real spellPowerAdd = this.spellPowerAdd

            call target.Attack.Speed.BonusA.Subtract(attackSpeedAdd)
            call target.SpellPower.Bonus.Subtract(spellPowerAdd)
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local integer level = BUFF.Event.GetLevel()
            local Unit target = UNIT.Event.GetTrigger()

            local real attackSpeedAdd = thistype.ATTACK_SPEED_INCREMENT[level]
            local real spellPowerAdd = thistype.SPELL_POWER_INCREMENT[level]
            local thistype this = target

            set this.attackSpeedAdd = attackSpeedAdd
            set this.spellPowerAdd = spellPowerAdd

            call target.Attack.Speed.BonusA.Add(attackSpeedAdd)
            call target.SpellPower.Bonus.Add(spellPowerAdd)
        endmethod

        static method Start takes Unit caster, integer level, Unit target returns nothing
            local real manaAdd = thistype.MANA_INCREMENT[level]

            call target.Effects.Create(thistype.TARGET_EFFECT_PATH, thistype.TARGET_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()

            call caster.HealManaBySpell(target, manaAdd)

            call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.DURATION[level])
        endmethod

        static method Init takes nothing returns nothing
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("MagicBottle", "MAGIC_BOTTLE")
    Unit caster
    integer level
    Unit target

    //! runtextmacro LinkToStruct("MagicBottle", "Buff")

    static method Impact takes nothing returns nothing
        local Missile dummyMissile = MISSILE.Event.GetTrigger()

        local thistype this = dummyMissile.GetData()

        local Unit caster = this.caster
        local integer level = this.level
        local Unit target = this.target

        call this.deallocate()
        call dummyMissile.Destroy()

        call thistype(NULL).Buff.Start(caster, level, target)
    endmethod

    static method StartTarget takes Unit caster, integer level, Unit target returns nothing
        local Missile dummyMissile = Missile.Create()
        local DummyUnit dummyUnit
        local thistype this = thistype.allocate()

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

        call dummyMissile.GoToUnit.Start(target, false)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local integer level = SPELL.Event.GetLevel()
        local Unit target = UNIT.Event.GetTarget()

        if (caster != target) then
            call thistype.StartTarget(caster, level, target)
        endif

        call thistype(NULL).Buff.Start(caster, level, caster)

        call target.Stamina.Add(target.MaxStamina.GetAll() * thistype.STAMINA_RELATIVE_INCREMENT + thistype.STAMINA_INCREMENT[level])
    endmethod

    static method Init takes nothing returns nothing
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call thistype(NULL).Buff.Init()
    endmethod
endstruct