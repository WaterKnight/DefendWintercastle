//! runtextmacro Folder("HopNDrop")
    //! runtextmacro Folder("SetMines")
        //! runtextmacro Struct("Mine")
            static Event DEATH_EVENT
            static Group ENUM_GROUP
            static BoolExpr TARGET_FILTER

            real areaRange
            Unit caster
            real damageAmount
            Unit mine

            condMethod Conditions
                local Unit target = UNIT.Event.Native.GetFilter()

                if target.Classes.Contains(UnitClass.DEAD) then
                    return false
                endif
                if not target.Classes.Contains(UnitClass.GROUND) then
                    return false
                endif
                if target.Classes.Contains(UnitClass.WARD) then
                    return false
                endif
                if target.IsAllyOf(User.TEMP) then
                    return false
                endif

                return true
            endmethod

            eventMethod Event_Death
                local Unit mine = params.Unit.GetTrigger()

                local real mineX = mine.Position.X.Get()
                local real mineY = mine.Position.Y.Get()

                local thistype this = mine

                local real areaRange = this.areaRange
                local Unit caster = this.caster
                local real damageAmount = this.damageAmount

                local User casterOwner = caster.Owner.Get()

                call mine.Event.Remove(DEATH_EVENT)

                call mine.Animation.Set(Animation.SPELL)
                call mine.Buffs.Remove(thistype.DUMMY_BUFF)
                //call mine.Invisibility.Subtract()

                set User.TEMP = casterOwner

                call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(mineX, mineY, areaRange, thistype.TARGET_FILTER)

                local Unit target = thistype.ENUM_GROUP.FetchFirst()

                if (target != NULL) then
                    loop
                        call target.Death.Explosion.Add()
                        call target.Movement.SubtractTimed(thistype.STUN_DURATION)

                        call caster.DamageUnitBySpell(target, damageAmount, false, true)

                        call target.Death.Explosion.Subtract()

                        set target = thistype.ENUM_GROUP.FetchFirst()
                        exitwhen (target == NULL)
                    endloop
                endif
            endmethod

            static method Start takes real areaRange, Unit caster, real damageAmount, integer level, real x, real y, real z returns nothing
                local Unit mine = Unit.Create(thistype.SUMMON_UNIT_TYPE, caster.Owner.Get(), x, y, caster.Facing.Get())

                local thistype this = mine

                set this.areaRange = areaRange
                set this.caster = caster
                set this.damageAmount = damageAmount

                //call mine.Abilities.AddBySelf(DummyUnit.LOCUST_SPELL_ID)
                //call mine.Buffs.Add(thistype.DUMMY_BUFF, level)
                call mine.Event.Add(DEATH_EVENT)
                call mine.Ghost.Add()
                //call mine.Invisibility.Add()
                call mine.Pathing.Subtract()
                call mine.Position.Z.Set(z)
                call mine.Scale.Set((64 + areaRange) / 192)

                call mine.Position.Timed.Accelerated.AddForNoCheck(0., 0., thistype.MOVE_Z_SPEED_START * TranslationAccelerated.UPDATE_TIME, 0., 0., 2 * ((Spot.GetHeight(x, y) - z) / thistype.MOVE_DURATION / thistype.MOVE_DURATION - thistype.MOVE_Z_SPEED_START / thistype.MOVE_DURATION) * TranslationAccelerated.UPDATE_TIME * TranslationAccelerated.UPDATE_TIME, thistype.MOVE_DURATION)

                call mine.ApplyTimedLife(thistype.EXPLOSION_DELAY)
            endmethod

            static method Init takes nothing returns nothing
                set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Death)
                set thistype.ENUM_GROUP = Group.Create()
                set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("SetMines")
        static real INTERVAL

        real areaRange
        real damageAmount
        Timer intervalTimer
        integer level

        //! runtextmacro LinkToStruct("SetMines", "Mine")

        timerMethod Interval
            local thistype this = Timer.GetExpired().GetData()

            local Unit target = this

            call thistype(NULL).Mine.Start(this.areaRange, target, this.damageAmount, this.level, target.Position.X.Get(), target.Position.Y.Get(), target.Position.Z.Get())
        endmethod

        eventMethod Event_BuffLose
            local Unit target = params.Unit.GetTrigger()

            local thistype this = target

            local Timer intervalTimer = this.intervalTimer

            call intervalTimer.Destroy()
        endmethod

        eventMethod Event_BuffGain
            local integer level = params.Buff.GetLevel()
            local Unit target = params.Unit.GetTrigger()

            local thistype this = target

			local Timer intervalTimer = Timer.Create()

            set this.areaRange = thistype.AREA_RANGE[level]
            set this.damageAmount = thistype.DAMAGE[level]
            set this.intervalTimer = intervalTimer
            set this.level = level
            call intervalTimer.SetData(this)

            call intervalTimer.Start(thistype.INTERVAL, true, function thistype.Interval)
        endmethod

        static method Start takes Unit caster, integer level returns nothing
            call caster.Buffs.Timed.Start(thistype.DUMMY_BUFF, level, HopNDrop.DURATION)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.INTERVAL = HopNDrop.DURATION / (thistype.WAVES_AMOUNT + 1) + Math.EPSILON
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))

            call thistype(NULL).Mine.Init()
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("HopNDrop", "HOP_N_DROP")
    static real DURATION_Z_SPEED_START_FACTOR
    static real HALF_DURATION
    static real LENGTH
    //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "1")
    static integer WAVES_AMOUNT
    static integer WAVES_AMOUNT_SQUARE
    static real Z_ADD_ADD
    static real Z_ADD_ADD_FORM
    static real Z_ADD_FORM

    static real TARGET_X
    static real TARGET_Y

    Timer durationTimer
    Timer moveTimer
    real xAdd
    real yAdd
    real zAdd
    real zAddAdd

    //! runtextmacro LinkToStruct("HopNDrop", "SetMines")

    timerMethod Move
        local thistype this = Timer.GetExpired().GetData()

        local Unit target = this
        local real zAdd = this.zAdd + this.zAddAdd

        local real x = target.Position.X.Get() + this.xAdd
        local real y = target.Position.Y.Get() + this.yAdd
        local real z = target.Position.Z.Get() + zAdd

        local real floorZ = Spot.GetHeight(x, y)

        set this.zAdd = zAdd

        call target.Position.SetXYWithTerrainWalkableCollision(x, y)

        if ((zAdd < 0.) and (z < floorZ + thistype.FLOOR_TOLERANCE)) then
            call target.Position.Z.Set(floorZ)

            call target.Buffs.Remove(thistype.DUMMY_BUFF)
        else
            call target.Position.Z.Set(z)
        endif
    endmethod

    eventMethod Event_BuffLose
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

        local Timer moveTimer = this.moveTimer

        call moveTimer.Destroy()

        call target.Position.Nudge()
    endmethod

    eventMethod Event_BuffGain
        local Unit target = params.Unit.GetTrigger()
        local real targetX = thistype.TARGET_X
        local real targetY = thistype.TARGET_Y

        local real angle = Math.AtanByDeltas(targetY - target.Position.Y.Get(), targetX - target.Position.X.Get())

        local thistype this = target

		local Timer moveTimer = Timer.Create()
        local real zD = Spot.GetHeight(targetX, targetY) - target.Position.Z.Get()

        set this.moveTimer = moveTimer
        set this.xAdd = Math.Cos(angle) * thistype.LENGTH
        set this.yAdd = Math.Sin(angle) * thistype.LENGTH
        set this.zAdd = thistype.Z_ADD_FORM - zD / thistype.WAVES_AMOUNT
        set this.zAddAdd = thistype.Z_ADD_ADD_FORM + 4 * zD / thistype.WAVES_AMOUNT_SQUARE
        call moveTimer.SetData(this)

        call moveTimer.Start(thistype.UPDATE_TIME, true, function thistype.Move)
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()

        set thistype.TARGET_X = params.Spot.GetTargetX()
        set thistype.TARGET_Y = params.Spot.GetTargetY()
        call caster.Buffs.Add(thistype.DUMMY_BUFF, level)

        call thistype(NULL).SetMines.Start(caster, level)
    endmethod

    initMethod Init of Spells_Hero
        set thistype.HALF_DURATION = thistype.DURATION / 2.
        set thistype.WAVES_AMOUNT = Real.ToInt(thistype.DURATION / thistype.UPDATE_TIME)
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        set thistype.DURATION_Z_SPEED_START_FACTOR = thistype.DURATION * thistype.DURATION / thistype.HALF_DURATION / thistype.HALF_DURATION * thistype.UPDATE_TIME
        set thistype.LENGTH = thistype.MAX_LENGTH / thistype.WAVES_AMOUNT
        set thistype.WAVES_AMOUNT_SQUARE = thistype.WAVES_AMOUNT * thistype.WAVES_AMOUNT
        set thistype.Z_ADD_ADD = -2 * thistype.HEIGHT * thistype.UPDATE_TIME * thistype.UPDATE_TIME / thistype.HALF_DURATION / thistype.HALF_DURATION
        set thistype.Z_ADD_FORM = 2 * thistype.HEIGHT / thistype.WAVES_AMOUNT

        set thistype.Z_ADD_ADD_FORM = -4 * thistype.HEIGHT / thistype.WAVES_AMOUNT_SQUARE

        call thistype(NULL).SetMines.Init()
    endmethod
endstruct