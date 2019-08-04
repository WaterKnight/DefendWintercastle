//! runtextmacro BaseStruct("DeprivingShock", "DEPRIVING_SHOCK")
    static Event DEATH_EVENT
    static Event DESTROY_EVENT
    //! runtextmacro GetKeyArray("KEY_ARRAY")

    real areaRange
    real burnedMana
    real damage
    real damagePerMana
    Timer damageTimer
    Lightning effectLightning
    integer level
    Unit target
    boolean targetAlive

	static method ReviveUnit takes Unit target, User casterOwner, integer level returns nothing
		if not target.Classes.Contains(UnitClass.DEAD) then
			return
		endif

        call target.Effects.Create(thistype.SUMMON_EFFECT_PATH, thistype.SUMMON_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

        call target.Revive()

        call target.Buffs.Add(thistype.SUMMON_BUFF, level)
        call target.Owner.Set(casterOwner)

        call target.SetSummon(thistype.SUMMON_DURATION[level])

        call target.BloodExplosion.Set(thistype.SUMMON_DEATH_EFFECT_PATH)
        call target.VertexColor.Add(-128, -128, -128, 0)
	endmethod

    eventMethod Event_Death
        local Unit target = params.Unit.GetTrigger()

        call target.Event.Remove(DEATH_EVENT)
        call target.Event.Remove(DESTROY_EVENT)

		local integer iteration = target.Data.Integer.Table.Count(KEY_ARRAY)

        loop
            local thistype this = target.Data.Integer.Table.Get(KEY_ARRAY, iteration)

			local Unit caster = this

            set this.targetAlive = false
            call target.Data.Integer.Table.Remove(KEY_ARRAY, this)

			call thistype.ReviveUnit(target, caster.Owner.Get(), this.level)

            set iteration = iteration - 1
            exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
        endloop
    endmethod

    eventMethod Event_Destroy
        local Unit target = params.Unit.GetTrigger()

        call target.Event.Remove(DEATH_EVENT)
        call target.Event.Remove(DESTROY_EVENT)

		local integer iteration = target.Data.Integer.Table.Count(KEY_ARRAY)

        loop
            local thistype this = target.Data.Integer.Table.Get(KEY_ARRAY, iteration)

            set this.targetAlive = false
            call target.Data.Integer.Table.Remove(KEY_ARRAY, this)

            set iteration = iteration - 1
            exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
        endloop
    endmethod

    timerMethod DamageInterval
        local thistype this = Timer.GetExpired().GetData()

        local Unit caster = this
        local Unit target = this.target

		local real burnedMana = Math.Min(this.burnedMana, target.Mana.Get())

        call caster.BurnManaBySpell(target, burnedMana)

        call caster.DamageUnitBySpell(target, this.damage + burnedMana * damagePerMana, true, false)

        call caster.HealManaBySpell(caster, burnedMana * thistype.TRANSFERED_MANA_FACTOR)
    endmethod

    eventMethod Event_EndCast
        local Unit caster = params.Unit.GetTrigger()
        local boolean success = params.Spell.IsChannelComplete()

        local thistype this = caster

        local Timer damageTimer = this.damageTimer
        local Lightning effectLightning = this.effectLightning
        local integer level = this.level
        local Unit target = this.target

        local boolean targetAlive = this.targetAlive

        call damageTimer.Destroy()
        call effectLightning.Destroy()
        if targetAlive then
            if target.Data.Integer.Table.Remove(KEY_ARRAY, this) then
                call target.Event.Remove(DEATH_EVENT)
                call target.Event.Remove(DESTROY_EVENT)
            endif
        endif

        if success then
            call Swiftness.Start(caster, level)
        endif

        call target.Effects.Create(thistype.TARGET_EXPLOSION_EFFECT_PATH, thistype.TARGET_EXPLOSION_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()

        call target.Buffs.Timed.Start(thistype.STUN_BUFF, level, thistype.STUN_OVER_DURATION[level])

        call target.Buffs.Subtract(thistype.STUN_BUFF)

        call target.Refs.Subtract()
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()
        local Unit target = params.Unit.GetTarget()

        local thistype this = caster

        local Timer damageTimer = Timer.Create()
        local Lightning effectLightning = Lightning.Create(thistype.BOLT)

        set this.burnedMana = thistype.BURNED_MANA_PER_SECOND[level] * thistype.DAMAGE_INTERVAL
        set this.damage = thistype.DAMAGE_PER_SECOND[level] * thistype.DAMAGE_INTERVAL
        set this.damagePerMana = thistype.DAMAGE_PER_MANA[level]
        set this.damageTimer = damageTimer
        set this.effectLightning = effectLightning
        set this.level = level
        set this.target = target
        set this.targetAlive = true
        call damageTimer.SetData(this)
        if target.Data.Integer.Table.Add(KEY_ARRAY, this) then
            call target.Event.Add(DEATH_EVENT)
            call target.Event.Add(DESTROY_EVENT)
        endif

        call effectLightning.FromUnitToUnit.Start(caster, target)
        call target.Refs.Add()

        call target.Buffs.Add(thistype.STUN_BUFF, level)

        call damageTimer.Start(thistype.DAMAGE_INTERVAL, true, function thistype.DamageInterval)
    endmethod

    initMethod Init of Spells_Hero
        set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Death)
        set thistype.DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Destroy)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Finish.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_EndCast))
        call UNIT.Stun.NORMAL_BUFF.Variants.Add(thistype.STUN_BUFF)
    endmethod
endstruct