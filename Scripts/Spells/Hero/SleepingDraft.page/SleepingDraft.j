//! runtextmacro Folder("SleepingDraft")
    //! runtextmacro Struct("Buff")
        static Event DAMAGE_EVENT

        integer level

        eventMethod Event_Damage
            local Unit target = params.Unit.GetDamager()
            local Unit victim = params.Unit.GetTarget()

            local thistype this = target

			local integer level = this.level

            call victim.Buffs.Timed.Start(thistype.COLDNESS_BUFF, level, thistype.COLDNESS_DURATION[level])
            call victim.Effects.Create("Abilities\\Weapons\\LichMissile\\LichMissile.mdl", AttachPoint.CHEST, EffectLevel.NORMAL).Destroy()
        endmethod

        eventMethod Event_BuffLose
            local Unit target = params.Unit.GetTrigger()

            local thistype this = target

            call target.Event.Remove(DAMAGE_EVENT)
        endmethod

        eventMethod Event_BuffGain
            local integer level = params.Buff.GetLevel()
            local Unit target = params.Unit.GetTrigger()

            local thistype this = target

            set this.level = level

            call target.Event.Add(DAMAGE_EVENT)
        endmethod

        static method Start takes integer level, Unit target returns nothing
            call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.DURATION[level])
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DAMAGE_EVENT = Event.Create(UNIT.Damage.Events.ATTACKER_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Damage)
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
            call UNIT.Cold.NORMAL_BUFF.Variants.Add(thistype.COLDNESS_BUFF)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("SleepingDraft", "SLEEPING_DRAFT")
    static Group ENUM_GROUP
    static BoolExpr TARGET_FILTER

    Unit caster
    integer level

    //! runtextmacro LinkToStruct("SleepingDraft", "Buff")

    condMethod Conditions
        local Unit target = UNIT.Event.Native.GetFilter()

        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if target.Classes.Contains(UnitClass.MECHANICAL) then
            return false
        endif
        if target.IsAllyOf(User.TEMP) then
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

        call this.deallocate()
        call dummyMissile.Destroy()

        set User.TEMP = caster.Owner.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, thistype.THIS_SPELL.GetAreaRange(level), thistype.TARGET_FILTER)

		local integer maxTargetsAmount = thistype.TARGETS_AMOUNT[level]

		if (maxTargetsAmount > 0) then
	        local Unit target = thistype.ENUM_GROUP.GetNearest(x, y)
	
	        if (target != NULL) then
	            local integer iteration = 1
	
	            loop
	                call thistype.ENUM_GROUP.RemoveUnit(target)
	
	                call target.Effects.Create(thistype.TARGET_EFFECT_PATH, thistype.TARGET_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()
	
	                if target.Classes.Contains(UnitClass.HERO) then
	                    call target.Buffs.Timed.Start(thistype.SLEEP_BUFF, level, thistype.HERO_DURATION[level])
	                else
	                    call target.Buffs.Timed.Start(thistype.SLEEP_BUFF, level, thistype.DURATION[level])
	                endif

	                set iteration = iteration + 1
	                exitwhen (iteration > maxTargetsAmount)

	                set target = thistype.ENUM_GROUP.GetNearest(x, y)
	                exitwhen (target == NULL)
	            endloop
	        endif
        endif
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()
        local Unit target = params.Unit.GetTarget()

        local thistype this = thistype.allocate()

		local Missile dummyMissile = Missile.Create()

        set this.caster = caster
        set this.level = level

        call dummyMissile.Arc.SetByPerc(0.2)
        call dummyMissile.CollisionSize.Set(10.)
        call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 1.5)
        call dummyMissile.Impact.SetAction(function thistype.Impact)
        call dummyMissile.SetData(this)
        call dummyMissile.Speed.Set(700.)
        call dummyMissile.Position.SetToUnit(caster)

        call dummyMissile.GoToUnit.Start(target, null)

        call thistype(NULL).Buff.Start(level, caster)

        call caster.HealStaminaBySpell(caster, caster.MaxStamina.Get() * thistype.STAMINA_REL_INC + thistype.STAMINA_INC[level])
    endmethod

    initMethod Init of Spells_Hero
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
        call UNIT.Sleep.NORMAL_BUFF.Variants.Add(thistype.SLEEP_BUFF)

        call thistype(NULL).Buff.Init()
    endmethod
endstruct