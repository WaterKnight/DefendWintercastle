//! runtextmacro BaseStruct("WarmthMagnetism", "WARMTH_MAGNETISM")
    static Event DEATH_EVENT
    //! runtextmacro GetKeyArray("KEY_ARRAY")
    static real LENGTH
    //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "2")

    static Unit CASTER

    Unit caster
    real casterX
    real casterY
    real damage
    Lightning effectLightning
    Timer intervalTimer
    integer level
    Timer moveTimer

    method Ending_Caster takes Unit caster returns nothing
        if caster.Data.Integer.Table.Remove(KEY_ARRAY, this) then
            call caster.Event.Remove(DEATH_EVENT)
        endif
    endmethod

    eventMethod Event_Caster_Death
        local Unit caster = params.Unit.GetTrigger()

        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()

        local integer iteration = caster.Data.Integer.Table.Count(KEY_ARRAY)

        loop
            local thistype this = caster.Data.Integer.Table.Get(KEY_ARRAY, iteration)

            call this.Ending_Caster(caster)

            set this.caster = NULL
            set this.casterX = casterX
            set this.casterY = casterY

            set iteration = iteration - 1
            exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
        endloop
    endmethod

    timerMethod Interval
        local thistype this = Timer.GetExpired().GetData()

        local Unit target = this

        call this.caster.DamageUnitBySpell(target, this.damage, true, false)
    endmethod

    timerMethod Move        
        local thistype this = Timer.GetExpired().GetData()

        local Unit caster = this.caster
        local integer level = this.level
        local Unit target = this

        local real targetX = target.Position.X.Get()
        local real targetY = target.Position.Y.Get()

		local real casterX
		local real casterY

        if (caster == NULL) then
            set casterX = this.casterX
            set casterY = this.casterY
        else
            set casterX = caster.Position.X.Get()
            set casterY = caster.Position.Y.Get()
        endif

        local real dX = casterX - targetX
        local real dY = casterY - targetY

        local real d = Math.DistanceByDeltas(dX, dY)
        local real length = thistype.LENGTH

        local real angle = Math.AtanByDeltas(dY, dX)
        local boolean reachesCaster = (d < length + thistype.HIT_RANGE)

        local real newX = targetX + length * Math.Cos(angle)
        local real newY = targetY + length * Math.Sin(angle)

        call target.Position.X.Set(newX)
        call target.Position.Y.Set(newY)

        if reachesCaster then
            call target.Buffs.Remove(thistype.DUMMY_BUFF)
        endif
    endmethod

    eventMethod Event_BuffLose
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

        local Unit caster = this.caster
        local Lightning effectLightning = this.effectLightning
        local Timer intervalTimer = this.intervalTimer
        local Timer moveTimer = this.moveTimer

        if (caster != NULL) then
            call this.Ending_Caster(caster)
        endif
        call effectLightning.Destroy()
        call intervalTimer.Destroy()
        call moveTimer.Destroy()
    endmethod

    eventMethod Event_BuffGain
        local Unit caster = thistype.CASTER
        local integer level = params.Buff.GetLevel()
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

        local Lightning effectLightning = Lightning.Create(thistype.BOLT)
        local Timer intervalTimer = Timer.Create()
        local Timer moveTimer = Timer.Create()

        set this.caster = caster
        set this.damage = thistype.DAMAGE_PER_INTERVAL[level]
        set this.effectLightning = effectLightning
        set this.intervalTimer = intervalTimer
        set this.level = level
        set this.moveTimer = moveTimer
        if caster.Data.Integer.Table.Add(KEY_ARRAY, this) then
            call caster.Event.Add(DEATH_EVENT)
        endif
        call intervalTimer.SetData(this)
        call moveTimer.SetData(this)

        call effectLightning.FromUnitToUnit.Start(target, caster)
        call target.Effects.Create(thistype.TARGET_EFFECT_PATH, thistype.TARGET_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()

        call intervalTimer.Start(thistype.DAMAGE_INTERVAL, true, function thistype.Interval)
        call moveTimer.Start(thistype.UPDATE_TIME, true, function thistype.Move)
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()

        set thistype.CASTER = caster

        call params.Unit.GetTarget().Buffs.AddFresh(thistype.DUMMY_BUFF, params.Spell.GetLevel())
    endmethod

    initMethod Init of Spells_Purchasable
        set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Caster_Death)
        set thistype.LENGTH = thistype.SPEED * thistype.UPDATE_TIME
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
        call UNIT.Silence.NORMAL_BUFF.Variants.Add(thistype.DUMMY_BUFF)
    endmethod
endstruct