//! runtextmacro Folder("EmphaticBite")
    //! runtextmacro Struct("Buff")
        static method Start takes integer level, Unit target returns nothing
            call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.DURATION[level])
        endmethod

        static method Init takes nothing returns nothing
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("EmphaticBite", "EMPHATIC_BITE")
    static real LENGTH
    //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "1")

    integer level
    Timer moveTimer
    real sourceX
    real sourceY
    Unit target
    real targetX
    real targetY
    SpellInstance whichInstance

    //! runtextmacro LinkToStruct("EmphaticBite", "Buff")

    timerMethod Move
        local thistype this = Timer.GetExpired().GetData()

        local Unit caster = this
        local integer level = this.level
        local Unit target = this.target

        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()

        local real targetX
        local real targetY

        if (target == NULL) then
            set targetX = this.targetX
            set targetY = this.targetY
        else
            set targetX = target.Position.X.Get()
            set targetY = target.Position.Y.Get()
        endif

        local real dX = targetX - casterX
        local real dY = targetY - casterY

        local real d = Math.DistanceByDeltas(dX, dY)
        local real length = thistype.LENGTH

        local real angle = Math.AtanByDeltas(dY, dX)
        local boolean reachesTarget = (d < length + thistype.HIT_RANGE)

        local real newX = casterX + length * Math.Cos(angle)
        local real newY = casterY + length * Math.Sin(angle)

        call caster.Position.X.Set(newX)
        call caster.Position.Y.Set(newY)

        if reachesTarget then
            call caster.Buffs.Remove(thistype.CASTER_BUFF)

            if (target != NULL) then
                call target.Effects.Create(thistype.TARGET_EFFECT_PATH, thistype.TARGET_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()

                if target.IsAllyOf(caster.Owner.Get()) then
                    call thistype(NULL).Buff.Start(level, target)

                    call caster.HealBySpell(target, thistype.HEAL_ALLY[level])
                else
                    call caster.DamageUnitBySpell(target, thistype.DAMAGE[level], false, true)

                    call target.Buffs.Timed.Start(thistype.TARGET_BUFF, level, thistype.DEBUFF_DURATION[level])

					call target.Position.Timed.Accelerated.AddKnockback(thistype.SPEED * thistype.KNOCKBACK_SPEED_FACTOR, 0., angle, UNIT.Knockup.DURATION)
					call target.Knockup.Start()
                endif

                call caster.HealBySpell(caster, thistype.HEAL[level])
            endif
        endif
    endmethod

    eventMethod Event_BuffLose
        local Unit caster = params.Unit.GetTrigger()

        local thistype this = caster

        local Timer moveTimer = this.moveTimer
        local Unit target = this.target
        local SpellInstance whichInstance = this.whichInstance

        call moveTimer.Destroy()
        call whichInstance.Destroy()

        //call caster.Position.SetWithCollision(sourceX, sourceY)
    endmethod

    eventMethod Event_BuffGain
        local integer level = params.Buff.GetLevel()
        local Unit caster = params.Unit.GetTrigger()
        local Unit target = params.Buff.GetData()

        local real sourceX = caster.Position.X.Get()
        local real sourceY = caster.Position.Y.Get()

        local real targetX = target.Position.X.Get()
        local real targetY = target.Position.Y.Get()

        local real dist = Math.DistanceByDeltas(targetX - sourceX, targetY - sourceY)

        local real expDuration = Math.GetMovementDuration(dist, thistype.SPEED, 0.)

        local real height = thistype.DIST_HEIGHT_FACTOR * dist

		local thistype this = caster

		local Timer moveTimer = Timer.Create()
		local SpellInstance whichInstance = SpellInstance.Create(caster, thistype.THIS_SPELL)

        set this.level = level
        set this.moveTimer = moveTimer
        set this.sourceX = sourceX
        set this.sourceY = sourceY
        set this.target = target
        set this.whichInstance = whichInstance
        call moveTimer.SetData(this)

        call caster.Animation.Set(Animation.ATTACK)
        call caster.Animation.Queue(Animation.STAND)
/*y=a/2*t²+v0*t

height=a/2*T²/4+v0*T/2

v=a*t+v0

0=a*T/2+v0

a=-2*v0/T


height=T/4*v0


v0=4*height/T
a=-8*height/T²*/
        if (expDuration > 0) then
            local real speedZ = 4 * height / expDuration

            local real accZ = -8 * height / expDuration / expDuration

            call caster.Position.Timed.Accelerated.AddForMundane(0., 0., speedZ, 0., 0., accZ, expDuration)
        endif

        call moveTimer.Start(thistype.UPDATE_TIME, true, function thistype.Move)
    endmethod

    eventMethod Event_SpellEffect
        call params.Unit.GetTrigger().Buffs.AddFreshEx(thistype.CASTER_BUFF, params.Spell.GetLevel(), params.Unit.GetTarget())
    endmethod

    initMethod Init of Spells_Hero
        set thistype.LENGTH = thistype.SPEED * thistype.UPDATE_TIME
        call thistype.CASTER_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.CASTER_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
        call UNIT.Silence.NORMAL_BUFF.Variants.Add(thistype.TARGET_BUFF)
        call UNIT.Bleeding.NORMAL_BUFF.Variants.Add(thistype.TARGET_BUFF)

        call thistype(NULL).Buff.Init()
    endmethod
endstruct