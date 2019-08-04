//! runtextmacro Spell_OpenScope("/")

//! runtextmacro BaseStruct("WarmthMagnetism", "WARMTH_MAGNETISM")
    static real DAMAGE_INTERVAL
    static real array DAMAGE_PER_INTERVAL
    static Event DEATH_EVENT
    static Buff DUMMY_BUFF
    static string EFFECT_LIGHTNING_PATH
    static real HIT_RANGE
    //! runtextmacro GetKeyArray("KEY_ARRAY")
    static real LENGTH
    static real SPEED
    static string TARGET_EFFECT_ATTACH_POINT
    static string TARGET_EFFECT_PATH
    //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "2")

    static Spell THIS_SPELL

    Unit caster
    real casterX
    real casterY
    real damage
    Lightning effectLightning
    Timer intervalTimer
    integer level
    Timer moveTimer

    method Ending_Caster takes Unit caster returns nothing
        if (caster.Data.Integer.Table.Remove(KEY_ARRAY, this)) then
            call caster.Event.Remove(DEATH_EVENT)
        endif
    endmethod

    static method Event_BuffLose takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

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

        call target.Movement.Add()
        call target.Silence.Subtract(UNIT.Silence.NORMAL_BUFF)
    endmethod

    static method Event_Caster_Death takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()
        local thistype this

        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()
        local integer iteration = caster.Data.Integer.Table.Count(KEY_ARRAY)

        loop
            set this = caster.Data.Integer.Table.Get(KEY_ARRAY, iteration)

            call this.Ending_Caster(caster)

            set this.caster = NULL
            set this.casterX = casterX
            set this.casterY = casterY

            set iteration = iteration - 1
            exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
        endloop
    endmethod

    static method Interval takes nothing returns nothing
        local thistype this = Timer.GetExpired().GetData()

        local Unit target = this

        call this.caster.DamageUnitBySpell(target, this.damage, true, false)
    endmethod

    static method Move takes nothing returns nothing
        local real angle
        local real casterX
        local real casterY
        local real d
        local real dealtDamage
        local real dX
        local real dY
        local real length = thistype.LENGTH
        local real newX
        local real newY
        local boolean reachesCaster
        local thistype this = Timer.GetExpired().GetData()

        local Unit caster = this.caster
        local integer level = this.level
        local Unit target = this

        local real targetX = target.Position.X.Get()
        local real targetY = target.Position.Y.Get()

        if (caster == NULL) then
            set casterX = this.casterX
            set casterY = this.casterY
        else
            set casterX = caster.Position.X.Get()
            set casterY = caster.Position.Y.Get()
        endif

        set dX = casterX - targetX
        set dY = casterY - targetY

        set d = Math.DistanceByDeltas(dX, dY)

        set angle = Math.AtanByDeltas(dY, dX)
        set reachesCaster = (d < length + thistype.HIT_RANGE)

        set newX = targetX + length * Math.Cos(angle)
        set newY = targetY + length * Math.Sin(angle)

        call target.Position.X.Set(newX)
        call target.Position.Y.Set(newY)

        if (reachesCaster) then
            call target.Buffs.Remove(thistype.DUMMY_BUFF)
        endif
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        local Unit caster = Unit.TEMP
        local Lightning effectLightning = Lightning.Create(thistype.EFFECT_LIGHTNING_PATH)
        local Timer intervalTimer = Timer.Create()
        local integer level = BUFF.Event.GetLevel()
        local Timer moveTimer = Timer.Create()
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        set this.caster = caster
        set this.damage = thistype.DAMAGE_PER_INTERVAL[level]
        set this.effectLightning = effectLightning
        set this.intervalTimer = intervalTimer
        set this.level = level
        set this.moveTimer = moveTimer
        if (caster.Data.Integer.Table.Add(KEY_ARRAY, this)) then
            call caster.Event.Add(DEATH_EVENT)
        endif
        call intervalTimer.SetData(this)
        call moveTimer.SetData(this)

        call effectLightning.FromUnitToUnit.Start(target, caster)
        call target.Effects.Create(thistype.TARGET_EFFECT_PATH, thistype.TARGET_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()
        call target.Movement.Subtract()
        call target.Silence.Add(UNIT.Silence.NORMAL_BUFF)

        call intervalTimer.Start(thistype.DAMAGE_INTERVAL, true, function thistype.Interval)
        call moveTimer.Start(thistype.UPDATE_TIME, true, function thistype.Move)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()

        set Unit.TEMP = caster

        call UNIT.Event.GetTarget().Buffs.AddFresh(thistype.DUMMY_BUFF, SPELL.Event.GetLevel())
    endmethod

    static method Init takes nothing returns nothing
        //! import obj_WarmthMagnetism.j

        set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Caster_Death)
        set thistype.LENGTH = thistype.SPEED * thistype.UPDATE_TIME
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

            set thistype.DUMMY_BUFF = Buff.CreateHidden(thistype.NAME)

            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
            call thistype.DUMMY_BUFF.SetLostOnDeath(true)
            call thistype.DUMMY_BUFF.SetLostOnDispel(true)

        //! runtextmacro Spell_Finalize("/")
    endmethod
endstruct