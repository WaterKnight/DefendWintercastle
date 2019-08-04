//! runtextmacro BaseStruct("Stampede", "STAMPEDE")
    static real DAMAGE_SPEED_FACTOR_PER_INTERVAL
    static real DURATION
    static Group ENUM_GROUP
    static real LENGTH
    static real LENGTH_ADD
    static BoolExpr TARGET_FILTER
    //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "2")

    Timer intervalTimer
    real speed
    real speedAdd
    Timer updateTimer
    real xAdd
    real xAddAdd
    real yAdd
    real yAddAdd

    condMethod Conditions
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

        return true
    endmethod

    timerMethod Interval
        local thistype this = Timer.GetExpired().GetData()

        local Unit caster = this

        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()

        set User.TEMP = caster.Owner.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(casterX, casterY, caster.CollisionSize.Get(true), thistype.TARGET_FILTER)

        local Unit target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            local real damageAmount = thistype.DAMAGE_SPEED_FACTOR_PER_INTERVAL * this.speed

            call SpotEffectWithSize.Create(casterX, casterY, thistype.SPECIAL_EFFECT_PATH, EffectLevel.NORMAL, thistype.SPECIAL_EFFECT_SCALE * caster.Scale.Get()).Destroy()

            loop
                call target.Effects.Create(thistype.TARGET_EFFECT_PATH, thistype.TARGET_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()

                call caster.DamageUnitBySpell(target, damageAmount, false, false)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
    endmethod

    timerMethod Move
        local thistype this = Timer.GetExpired().GetData()

        local Unit target = this
        local real xAdd = this.xAdd + this.xAddAdd
        local real yAdd = this.yAdd + this.yAddAdd

        set this.speed = this.speed + this.speedAdd
        set this.xAdd = xAdd
        set this.yAdd = yAdd

        call target.Position.X.Add(xAdd)
        call target.Position.Y.Add(yAdd)
    endmethod

    eventMethod Event_BuffLose
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

        local Timer intervalTimer = this.intervalTimer
        local Timer updateTimer = this.updateTimer

        call intervalTimer.Destroy()
        call updateTimer.Destroy()
    endmethod

    eventMethod Event_BuffGain
        local EventResponse castParams = params.Buff.GetData()
        local Unit target = params.Unit.GetTrigger()

        local real targetX = castParams.Spot.GetTargetX()
        local real targetY = castParams.Spot.GetTargetY()

        local real angle = target.CastAngle(targetX - target.Position.X.Get(), targetY - target.Position.Y.Get())

        local thistype this = target

		local Timer intervalTimer = Timer.Create()
        local Timer updateTimer = Timer.Create()
        local real xPart = Math.Cos(angle)
        local real yPart = Math.Sin(angle)

        set this.intervalTimer = intervalTimer
        set this.speed = thistype.SPEED
        set this.speedAdd = thistype.SPEED_ADD * thistype.UPDATE_TIME
        set this.updateTimer = updateTimer
        set this.xAdd = thistype.LENGTH * xPart
        set this.xAddAdd = LENGTH_ADD * xPart
        set this.yAdd = thistype.LENGTH * yPart
        set this.yAddAdd = LENGTH_ADD * yPart
        call intervalTimer.SetData(this)
        call updateTimer.SetData(this)

        call intervalTimer.Start(thistype.INTERVAL, true, function thistype.Interval)
        call updateTimer.Start(thistype.UPDATE_TIME, true, function thistype.Move)
    endmethod

    eventMethod Event_SpellEffect
        call params.Unit.GetTrigger().Buffs.Timed.StartEx(thistype.DUMMY_BUFF, params.Spell.GetLevel(), params, thistype.DURATION)
    endmethod

    initMethod Init of Spells_Act1
        set thistype.DAMAGE_SPEED_FACTOR_PER_INTERVAL = thistype.DAMAGE_SPEED_FACTOR_PER_SECOND * thistype.INTERVAL
        set thistype.DURATION = -thistype.SPEED / thistype.SPEED_ADD + Math.Sqrt(thistype.SPEED * thistype.SPEED / thistype.SPEED_ADD / thistype.SPEED_ADD + 2 * thistype.MAX_LENGTH / thistype.SPEED_ADD)
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.LENGTH = thistype.SPEED * thistype.UPDATE_TIME
        set thistype.LENGTH_ADD = thistype.SPEED_ADD * thistype.UPDATE_TIME * thistype.UPDATE_TIME
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct