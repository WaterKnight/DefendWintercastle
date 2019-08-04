//! runtextmacro Folder("GreenNova")
    //! runtextmacro Struct("Buff")
        static method Start takes integer level, Unit target returns nothing
        	local real duration

			if target.Classes.Contains(UnitClass.HERO) then
				set duration = thistype.HERO_DURATION
			else
				set duration = thistype.DURATION
			endif

            call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, level, duration)
        endmethod

        static method Init takes nothing returns nothing
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("GreenNova", "GREEN_NOVA")
    static real DURATION
    static Group ENUM_GROUP
    static real RADIUS_ADD
    static BoolExpr TARGET_FILTER

    real angle
    Unit caster
    Timer intervalTimer
    integer level
    real radius
    real radiusAdd
    real x
    real y

    //! runtextmacro LinkToStruct("GreenNova", "Buff")

    static method Ending takes nothing returns nothing
        local Timer durationTimer = Timer.GetExpired()

        local thistype this = durationTimer.GetData()

        local Timer intervalTimer = this.intervalTimer

        call durationTimer.Destroy()
        call intervalTimer.Destroy()
    endmethod

    condMethod Conditions
        local Unit target = UNIT.Event.Native.GetFilter()

        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if not target.Classes.Contains(UnitClass.GROUND) then
            return false
        endif
        if target.Classes.Contains(UnitClass.MECHANICAL) then
            return false
        endif
        if target.Classes.Contains(UnitClass.STRUCTURE) then
            return false
        endif
        if target.IsAllyOf(User.TEMP) then
            return false
        endif
        if target.MagicImmunity.Try() then
            return false
        endif
        if target.Position.InRangeWithCollision(TEMP_REAL2, TEMP_REAL3, TEMP_REAL) then
            return false
        endif

        return true
    endmethod

    timerMethod Interval
        local thistype this = Timer.GetExpired().GetData()

        local real angle = this.angle
        local integer level = this.level
        local real radius = this.radius + this.radiusAdd
        local real x = this.x
        local real y = this.y

        local real angleAdd = thistype.SPECIAL_EFFECT_PERIMETER_INTERVAL / radius
        local integer iteration = Real.ToInt(2 * Math.PI * radius / thistype.SPECIAL_EFFECT_PERIMETER_INTERVAL)

        set this.radius = radius

        loop
            call Spot.CreateEffect(x + radius * Math.Cos(angle), y + radius * Math.Sin(angle), thistype.SPECIAL_EFFECT_PATH, EffectLevel.Random(EffectLevel.LOW, EffectLevel.NORMAL)).Destroy()

            set iteration = iteration - 1
            exitwhen (iteration < 1)

            set angle = angle + angleAdd
        endloop

        set TEMP_REAL = radius - this.radiusAdd
        set TEMP_REAL2 = x
        set TEMP_REAL3 = y
        set User.TEMP = this.caster.Owner.Get()

        call ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, radius, thistype.TARGET_FILTER)

        loop
            local Unit target = ENUM_GROUP.FetchFirst()
            exitwhen (target == NULL)

            call thistype(NULL).Buff.Start(level, target)
        endloop
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()

        local thistype this = thistype.allocate()

        local Timer durationTimer = Timer.Create()
        local Timer intervalTimer = Timer.Create()

        set this.angle = caster.Facing.Get()
        set this.caster = caster
        set this.intervalTimer = intervalTimer
        set this.level = params.Spell.GetLevel()
        set this.radius = 0.
        set this.radiusAdd = thistype.RADIUS_ADD
        set this.x = caster.Position.X.Get()
        set this.y = caster.Position.Y.Get()
        call durationTimer.SetData(this)
        call intervalTimer.SetData(this)

        call intervalTimer.Start(thistype.INTERVAL, true, function thistype.Interval)

        call durationTimer.Start(thistype.DURATION, false, function thistype.Ending)
    endmethod

    initMethod Init of Spells_Act1
        set thistype.DURATION = thistype.INTERVAL * thistype.WAVES_AMOUNT
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.RADIUS_ADD = thistype.MAX_RADIUS / thistype.WAVES_AMOUNT
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call thistype(NULL).Buff.Init()
    endmethod
endstruct