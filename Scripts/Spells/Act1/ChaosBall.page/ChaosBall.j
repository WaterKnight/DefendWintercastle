//! runtextmacro BaseStruct("ChaosBall", "CHAOS_BALL")
    static real array CANCEL_RANGE_SQUARE
    static Group ENUM_GROUP
    //! runtextmacro GetKey("KEY")
    static BoolExpr TARGET_FILTER

    Unit caster
    Missile dummyMissile
    integer level
    Unit target

    condMethod TargetConditions
        local Unit target = UNIT.Event.Native.GetFilter()

        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if not target.Classes.Contains(UnitClass.GROUND) then
            return false
        endif
        if target.IsAllyOf(User.TEMP) then
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
        local real x = dummyMissile.Position.X.Get()
        local real y = dummyMissile.Position.Y.Get()

        local Unit caster = this.caster
        local integer level = this.level

        call this.deallocate_demount()
        call dummyMissile.Destroy()

        call Spot.CreateEffect(x, y, thistype.SPECIAL_EFFECT_PATH, EffectLevel.NORMAL).Destroy()

        set User.TEMP = caster.Owner.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, thistype.THIS_SPELL.GetAreaRange(level), thistype.TARGET_FILTER)

        local Unit target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            local real damage = thistype.DAMAGE
            local real heroDuration = thistype.HERO_DURATION
            local real normDuration = thistype.DURATION

            loop
            	local real duration

				if target.Classes.Contains(UnitClass.HERO) then
					set duration = heroDuration
				else
					set duration = normDuration
				endif

				call target.Buffs.Timed.Start(thistype.POISON_BUFF, level, duration)

                call caster.DamageUnitBySpell(target, damage, true, false)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
    endmethod

    eventMethod Event_EndCast
        local Unit caster = params.Unit.GetTrigger()
        local boolean success = params.Spell.IsChannelComplete()

        local thistype this = caster.Data.Integer.Get(KEY)

        local Missile dummyMissile = this.dummyMissile
        local integer level = this.level

        call caster.Data.Integer.Remove(KEY)

        if success then
            set target = this.target

            local real targetX = target.Position.X.Get()
            local real targetY = target.Position.Y.Get()

            if (Math.DistanceSquareByDeltas(targetX - caster.Position.X.Get(), targetY - caster.Position.Y.Get()) < thistype.CANCEL_RANGE_SQUARE[level]) then
                set this.caster = caster

                call dummyMissile.Acceleration.Set(600.)
                call dummyMissile.Arc.SetByPerc(0.1)
                call dummyMissile.Impact.SetAction(function thistype.Impact)
                call dummyMissile.SetData(this)
                call dummyMissile.Speed.Set(700.)
                call dummyMissile.Position.SetToUnit(caster)

                call dummyMissile.GoToSpot.Start(targetX, targetY, Spot.GetHeight(targetX, targetY))

                return
            endif
        endif

        call this.deallocate_demount()
        call dummyMissile.Destroy()

        call caster.Mana.Add(thistype.THIS_SPELL.GetManaCost(level))
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()
		
        local real duration = thistype.THIS_SPELL.GetChannelTime(level)

		local Missile dummyMissile = Missile.Create()

		local thistype this = thistype.allocate_mount(dummyMissile)

        set this.dummyMissile = dummyMissile
        set this.level = level
        set this.target = params.Unit.GetTarget()
        call caster.Data.Integer.Set(KEY, this)

        local DummyUnit dummyUnit = dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 1.)
        call dummyMissile.Speed.Set(thistype.OFFSET_Z / duration)
        call dummyMissile.Position.SetFromUnit(caster)

        call dummyMissile.GoToUnit.StartWithOffset(caster, 0., 0., thistype.OFFSET_Z, null)
        call dummyUnit.Scale.Timed.Add(1., duration)
    endmethod

    initMethod Init of Spells_Act1
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.TargetConditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Finish.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_EndCast))
        call UNIT.Poisoned.NORMAL_BUFF.Variants.Add(thistype.POISON_BUFF)

        local integer iteration = thistype.THIS_SPELL.GetLevelsAmount()

        loop
            set thistype.CANCEL_RANGE_SQUARE[iteration] = Math.Square(thistype.THIS_SPELL.GetRange(iteration) + thistype.RANGE_TOLERANCE)

            set iteration = iteration - 1
            exitwhen (iteration < 1)
        endloop
    endmethod
endstruct