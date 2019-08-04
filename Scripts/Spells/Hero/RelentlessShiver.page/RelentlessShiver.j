//! runtextmacro Folder("RelentlessShiver")
    //! runtextmacro Struct("Buff")
        static method Start takes Unit caster, integer level, Unit target returns nothing
        	local real duration

			if target.Classes.Contains(UnitClass.HERO) then
				set duration = thistype.HERO_DURATION[level]
			else
				set duration = thistype.DURATION[level]
			endif

            call target.Buffs.Timed.Start(thistype.COLDNESS_BUFF, level, duration)
        endmethod

        static method Init takes nothing returns nothing
            call UNIT.Cold.NORMAL_BUFF.Variants.Add(thistype.COLDNESS_BUFF)
        endmethod
    endstruct

    //! runtextmacro Struct("Missile")
        Unit caster
        integer level

        eventMethod Impact
            local Missile dummyMissile = params.Missile.GetTrigger()
            local Unit target = params.Unit.GetTrigger()

            local thistype this = dummyMissile.GetData()

            local Unit caster = this.caster
            local integer level = this.level

            call this.deallocate()
            call dummyMissile.Destroy()

            call RELENTLESS_SHIVER.Buff.Start(caster, level, target)

            call caster.DamageUnitBySpell(target, thistype.DAMAGE[level], true, false)
        endmethod

        static method Start takes Unit caster, integer level, Unit target returns nothing
            local thistype this = thistype.allocate()

			local Missile dummyMissile = Missile.Create()

            set this.caster = caster
            set this.level = level

            call dummyMissile.Arc.SetByPerc(0.06)
            call dummyMissile.CollisionSize.Set(8.)
            call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 0.75)
            call dummyMissile.Impact.SetAction(function thistype.Impact)
            call dummyMissile.SetData(this)
            call dummyMissile.Speed.Set(500.)
            call dummyMissile.Position.SetFromUnit(caster)

            call dummyMissile.GoToUnit.Start(target, function Missile.Destruction)
        endmethod

        static method Init takes nothing returns nothing
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("RelentlessShiver", "RELENTLESS_SHIVER")
    static Group ENUM_GROUP
    static real array MANA_COST_PER_INTERVAL
    static BoolExpr TARGET_FILTER

    real areaRange
    Timer intervalTimer
    integer level
    real manaCostPerInterval

    //! runtextmacro LinkToStruct("RelentlessShiver", "Buff")
    //! runtextmacro LinkToStruct("RelentlessShiver", "Missile")

    condMethod Conditions
        local Unit target = UNIT.Event.Native.GetFilter()

        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if target.Classes.Contains(UnitClass.HERO) then
            return false
        endif
        if target.Classes.Contains(UnitClass.STRUCTURE) then
            return false
        endif
        if target.IsAllyOf(User.TEMP) then
            return false
        endif

        return true
    endmethod

    timerMethod Interval
        local thistype this = Timer.GetExpired().GetData()

        local Unit caster = this

        local real areaRange = this.areaRange
        local integer level = this.level
        local real manaCostPerInterval = this.manaCostPerInterval

        call caster.Mana.Subtract(manaCostPerInterval)

        if (caster.Mana.Get() < thistype.MANA_COST_BUFFER) then
            call caster.Buffs.Remove(thistype.DUMMY_BUFF)
        endif

        set User.TEMP = caster.Owner.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(caster.Position.X.Get(), caster.Position.Y.Get(), areaRange, thistype.TARGET_FILTER)

        local Unit target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            loop
                call thistype(NULL).Missile.Start(caster, level, target)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
    endmethod

    eventMethod Event_BuffLose
        local Unit caster = params.Unit.GetTrigger()

        local thistype this = caster

        local Timer intervalTimer = this.intervalTimer

        call intervalTimer.Destroy()

        call HeroSpell.ReplaceSlot(thistype.REVERT_SPELL.GetClass(), thistype.THIS_SPELL, caster)
    endmethod

    eventMethod Event_BuffGain
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Buff.GetLevel()

        local thistype this = caster

		local Timer intervalTimer = Timer.Create()

        set this.areaRange = thistype.THIS_SPELL.GetAreaRange(level)
        set this.intervalTimer = intervalTimer
        set this.level = level
        set this.manaCostPerInterval = thistype.MANA_COST_PER_INTERVAL[level]
        call intervalTimer.SetData(this)

        call intervalTimer.Start(thistype.INTERVAL, true, function thistype.Interval)

        call HeroSpell.ReplaceSlot(thistype.THIS_SPELL.GetClass(), thistype.REVERT_SPELL, caster)
    endmethod

    eventMethod Event_RevertSpellEffect
        call params.Unit.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

    eventMethod Event_SpellEffect
        call params.Unit.GetTrigger().Buffs.Add(thistype.DUMMY_BUFF, params.Spell.GetLevel())
    endmethod

    initMethod Init of Spells_Hero
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.REVERT_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_RevertSpellEffect))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        local integer iteration = thistype.THIS_SPELL.GetLevelsAmount()

        loop
            exitwhen (iteration < 1)

            set thistype.MANA_COST_PER_INTERVAL[iteration] = thistype.MANA_COST_PER_SECOND[iteration] * thistype.INTERVAL

            set iteration = iteration - 1
        endloop

        call thistype(NULL).Buff.Init()
        call thistype(NULL).Missile.Init()
    endmethod
endstruct