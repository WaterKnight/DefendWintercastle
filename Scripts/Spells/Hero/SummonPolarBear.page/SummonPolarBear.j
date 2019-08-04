//! runtextmacro Folder("SummonPolarBear")
	//! runtextmacro Folder("Summon")
    	//! runtextmacro Struct("Callback")

    	endstruct
	endscope

    //! runtextmacro Struct("Summon")
        static Event BEAR_DEATH_EVENT
        static Event CASTER_DEATH_EVENT
        //! runtextmacro GetKey("KEY")

        Unit bear
        Unit caster
        integer level

		method KillBear takes nothing returns nothing
			local Unit bear = this.bear
			local Unit caster = this.caster
			local integer level = this.level

            local real remainingLife = bear.Life.Get()

            call bear.KillInstantly()

            call caster.HealBySpell(caster, thistype.HEAL[level] + remainingLife * thistype.HEAL_FACTOR[level])
		endmethod

        eventMethod Event_Bear_Death
            local Unit bear = params.Unit.GetTrigger()

            local thistype this = bear.Data.Integer.Get(KEY)

            local Unit caster = this.caster

            call this.deallocate()
            call bear.Data.Integer.Remove(KEY)
            call bear.Event.Remove(BEAR_DEATH_EVENT)
            call caster.Data.Integer.Remove(KEY)
            call caster.Event.Remove(CASTER_DEATH_EVENT)

			call HeroSpell.ReplaceSlot(SpellClass.HERO_SECOND, SummonPolarBear.THIS_SPELL, caster)
        endmethod

        eventMethod Event_Caster_Death
            local thistype this = params.Unit.GetTrigger().Data.Integer.Get(KEY)

            call this.bear.KillInstantly()
        endmethod

        static method Start takes Unit caster, integer level, Unit target, real x, real y returns nothing            
            local thistype this = caster.Data.Integer.Get(KEY)

			local Unit bear

            if (this != NULL) then
                call this.KillBear()
            endif

			local User casterOwner = caster.Owner.Get()

            set bear = Unit.CreateSummon(thistype.SUMMON_UNIT_TYPE[level], casterOwner, x, y, UNIT.Facing.STANDARD, thistype.DURATION[level])

            set this = thistype.allocate()

            set this.bear = bear
            set this.caster = caster
            set this.level = level
            call bear.Data.Integer.Set(KEY, this)
            call bear.Event.Add(BEAR_DEATH_EVENT)
            call caster.Data.Integer.Set(KEY, this)
            call caster.Event.Add(CASTER_DEATH_EVENT)

			call HeroSpell.ReplaceSlot(SpellClass.HERO_SECOND, thistype.CALLBACK_SPELL, caster)

            call bear.Buffs.Timed.Start(UNIT.Invulnerability.NORMAL_BUFF, level, thistype.INVU_DURATION[level])

            call bear.Abilities.Add(thistype.TAUNT_SPELL)

            call casterOwner.EnableAbility(thistype.TAUNT_SPELL, true)

            call bear.Order.Immediate(Order.TAUNT)

            call casterOwner.EnableAbility(thistype.TAUNT_SPELL, false)

            if target.IsAllyOf(casterOwner) then
                call bear.Abilities.AddWithLevel(ArcticBlink.THIS_SPELL, level)

                call target.Buffs.Timed.Start(UNIT.Invulnerability.NORMAL_BUFF, level, thistype.INVU_DURATION[level])
            else
                call bear.Abilities.AddWithLevel(ArcticBlink.THIS_SPELL, level + 1)

                //call bear.Order.UnitTarget(Order.ATTACK, target)
                call bear.Order.UnitTargetBySpell(ArcticBlink.THIS_SPELL, target)
            endif
        endmethod

		eventMethod Event_SpellEffect
			local Unit caster = params.Unit.GetTrigger()

			local thistype this = caster.Data.Integer.Get(KEY)

			call this.KillBear()
		endmethod

        static method Init takes nothing returns nothing
            set thistype.BEAR_DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Bear_Death)
            set thistype.CASTER_DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Caster_Death)
            call thistype.CALLBACK_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("SummonPolarBear", "SUMMON_POLAR_BEAR")
    Unit caster
    integer level
    Unit target

    //! runtextmacro LinkToStruct("SummonPolarBear", "Summon")

    eventMethod Impact
        local Missile dummyMissile = params.Missile.GetTrigger()

        local thistype this = dummyMissile.GetData()

        local Unit caster = this.caster
        local integer level = this.level
        local Unit target = this.target
        local real targetX = dummyMissile.Position.X.Get()
        local real targetY = dummyMissile.Position.Y.Get()

        call this.deallocate()
        call dummyMissile.Destroy()

        call thistype(NULL).Summon.Start(caster, level, target, targetX, targetY)
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()
        local Unit target = params.Unit.GetTarget()

        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()
        local real targetX = target.Position.X.Get()
        local real targetY = target.Position.Y.Get()

        local thistype this = thistype.allocate()

		local Missile dummyMissile = Missile.Create()

        set this.caster = caster
        set this.level = level
        set this.target = target

		local UnitType summonType = thistype(NULL).Summon.SUMMON_UNIT_TYPE[level]

        call dummyMissile.Arc.SetByPerc(0.06)
        call dummyMissile.CollisionSize.Set(2 * summonType.CollisionSize.Get())
        call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 0.25)
        call dummyMissile.Impact.SetAction(function thistype.Impact)
        call dummyMissile.SetData(this)
        call dummyMissile.Speed.Set(summonType.Speed.Get() * 4.)
        call dummyMissile.Position.SetFromUnit(caster)

        call dummyMissile.GoToSpot.Start(targetX, targetY, Spot.GetHeight(targetX, targetY))
    endmethod

    initMethod Init of Spells_Hero
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call thistype(NULL).Summon.Init()
    endmethod
endstruct