//! runtextmacro Folder("VioletEarring")
    //! runtextmacro Struct("Charge")
        static Event DAMAGE_EVENT

        boolean exists

        eventMethod Event_ActiveBuffLose
            local Unit caster = params.Unit.GetTrigger()
            local integer level = params.Buff.GetLevel()

            call caster.Event.Remove(DAMAGE_EVENT)

			call caster.Abilities.RemoveBySelf(thistype.MISSILE_ART_SPELL_ID)
        endmethod

        eventMethod Event_ActiveBuffGain
            local Unit caster = params.Unit.GetTrigger()

            call caster.Event.Add(DAMAGE_EVENT)

			call caster.Abilities.AddBySelf(thistype.MISSILE_ART_SPELL_ID)
        endmethod

        eventMethod Event_CooldownBuffLose
            local Unit caster = params.Unit.GetTrigger()
            local integer level = params.Buff.GetLevel()

            local thistype this = caster

            if this.exists then
                call caster.Buffs.Add(thistype.ACTIVE_BUFF, level)
            endif
        endmethod

        eventMethod Event_CooldownBuffGain
            local Unit caster = params.Unit.GetTrigger()

            call caster.Buffs.Remove(thistype.ACTIVE_BUFF)
        endmethod

        eventMethod Event_Damage
            local real amount = params.Real.GetDamage()
            local Unit caster = params.Unit.GetDamager()
            local Unit target = params.Unit.GetTrigger()

            local integer level = caster.Buffs.GetLevel(thistype.ACTIVE_BUFF)

            if (target.Abilities.GetLevelBySelf(thistype.MISSILE_ART_BUFF_ID) == 0) then
                return
            endif

            call target.Abilities.RemoveBySelf(thistype.MISSILE_ART_BUFF_ID)

			local real banishDuration
			
			if target.Classes.Contains(UnitClass.HERO) then
				set banishDuration = thistype.BANISH_HERO_DURATION[level]
			else
				set banishDuration = thistype.BANISH_DURATION[level]
			endif

            call target.Buffs.Timed.Start(thistype.BANISH_BUFF, level, banishDuration)

            call caster.Buffs.Timed.Start(thistype.COOLDOWN_BUFF, level, thistype.COOLDOWN[level])

            call params.Real.SetDamage(amount * thistype.DAMAGE_FACTOR[level])
        endmethod

        eventMethod Event_BuffLose
            local Unit caster = params.Unit.GetTrigger()

            local thistype this = caster

            set this.exists = false

            call caster.Buffs.Remove(thistype.ACTIVE_BUFF)
            call caster.Buffs.Remove(thistype.COOLDOWN_BUFF)
        endmethod

        eventMethod Event_BuffGain
            local Unit caster = params.Unit.GetTrigger()
            local integer level = params.Buff.GetLevel()

            local thistype this = caster

            set this.exists = true

            call caster.Buffs.Add(thistype.ACTIVE_BUFF, level)
        endmethod

        eventMethod Event_Unlearn
            call params.Unit.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
        endmethod

        eventMethod Event_ChangeLevel
            call params.Unit.GetTrigger().Buffs.AddFresh(thistype.DUMMY_BUFF, params.Spell.GetLevel())
        endmethod

        eventMethod Event_Learn
            call params.Unit.GetTrigger().Buffs.Add(thistype.DUMMY_BUFF, params.Spell.GetLevel())
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DAMAGE_EVENT = Event.Create(UNIT.Damage.Events.ATTACKER_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Damage)
            call thistype.ACTIVE_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_ActiveBuffGain))
            call thistype.ACTIVE_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_ActiveBuffLose))
            call thistype.COOLDOWN_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_CooldownBuffGain))
            call thistype.COOLDOWN_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_CooldownBuffLose))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
            call VioletEarring.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Learn.CHANGE_LEVEL_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_ChangeLevel))
            call VioletEarring.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Learn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Learn))
            call VioletEarring.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Unlearn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Unlearn))

            call UNIT.Banish.NORMAL_BUFF.Variants.Add(thistype.BANISH_BUFF)
        endmethod
    endstruct

    //! runtextmacro Struct("Port")
        static Event MISSILE_DESTROY_EVENT

        SpellInstance parent

        eventMethod Event_Missile_Destroy
            local Missile dummyMissile = params.Missile.GetTrigger()

            local thistype this = dummyMissile.GetData()

            local SpellInstance parent = this.parent

            call dummyMissile.Event.Remove(MISSILE_DESTROY_EVENT)

            call parent.Refs.Subtract()

            call this.deallocate()
        endmethod

        eventMethod Impact
            local Missile dummyMissile = params.Missile.GetTrigger()
            local Unit target = params.Unit.GetTrigger()

            local thistype this = dummyMissile.GetData()

            local SpellInstance parent = this.parent

            local Unit caster = parent.GetCaster()
            local integer level = parent.GetLevel()

            call dummyMissile.Destroy()

            local real casterX = caster.Position.X.Get()
            local real casterY = caster.Position.Y.Get()

            call caster.Effects.Create(thistype.SPECIAL_EFFECT_PATH, thistype.SPECIAL_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

            call caster.Position.SetXY(target.Position.X.Get(), target.Position.Y.Get())

            call target.Effects.Create(thistype.SPECIAL_EFFECT_PATH, thistype.SPECIAL_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

            call target.Position.SetXY(casterX, casterY)

            call caster.Buffs.Subtract(thistype.DUMMY_BUFF)
            call target.Buffs.Subtract(thistype.DUMMY_BUFF)
        endmethod

        static method Start takes SpellInstance parent returns nothing
            local Unit caster = parent.GetCaster()
            local Unit target = parent.GetTargetUnit()

            local thistype this = thistype.allocate()

			local Missile dummyMissile = Missile.Create()

            set this.parent = parent

            call parent.Refs.Add()

            call caster.Buffs.Add(thistype.DUMMY_BUFF, 1)
            call target.Buffs.Add(thistype.DUMMY_BUFF, 1)

            call dummyMissile.Event.Add(MISSILE_DESTROY_EVENT)

            call dummyMissile.Arc.SetByPerc(0.)
            call dummyMissile.CollisionSize.Set(10.)
            call dummyMissile.Impact.SetAction(function thistype.Impact)
            call dummyMissile.SetData(this)
            call dummyMissile.Speed.Set(600.)
            call dummyMissile.Position.SetFromUnit(caster)

            call dummyMissile.GoToUnit.Start(target, function Missile.Destruction)

            call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 1.)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.MISSILE_DESTROY_EVENT = Event.Create(Missile.DESTROY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Missile_Destroy)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("VioletEarring", "VIOLET_EARRING")
    SpellInstance whichInstance

    //! runtextmacro LinkToStruct("VioletEarring", "Charge")
    //! runtextmacro LinkToStruct("VioletEarring", "Port")

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()
        local Unit target = params.Unit.GetTarget()
        local SpellInstance whichInstance = params.SpellInstance.GetTrigger()

        call caster.Effects.Create(thistype.CASTER_EFFECT_PATH, thistype.CASTER_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

        call caster.Abilities.Refresh(PurgingRain.THIS_SPELL)
        call caster.Abilities.Refresh(ArcaneAttractor.THIS_SPELL)
        call caster.Mana.Add(thistype.MANA_INC[level])

        if (caster != target) then
            call thistype(NULL).Port.Start(whichInstance)
        endif
    endmethod

    initMethod Init of Spells_Artifacts
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call thistype(NULL).Charge.Init()
        call thistype(NULL).Port.Init()
    endmethod
endstruct