//! runtextmacro Folder("PurgingRain")
    //! runtextmacro Struct("Wave")
        static Group ENUM_GROUP
        static BoolExpr TARGET_FILTER

        real areaRange
        Unit caster
        real damage
        real targetX
        real targetY

        condMethod Conditions
            local Unit target = UNIT.Event.Native.GetFilter()

            if target.Classes.Contains(UnitClass.DEAD) then
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

        timerMethod Ending
            local Timer durationTimer = Timer.GetExpired()

            local thistype this = durationTimer.GetData()

            local real areaRange = this.areaRange
            local Unit caster = this.caster
            local real damage = this.damage
            local real targetX = this.targetX
            local real targetY = this.targetY

            local SpellInstance whichInstance = SpellInstance.Create(caster, PurgingRain.THIS_SPELL)

            local integer level = whichInstance.GetLevel()

            call this.deallocate()
            call durationTimer.Destroy()
            call whichInstance.Destroy()

            set User.TEMP = caster.Owner.Get()

            call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(targetX, targetY, areaRange, thistype.TARGET_FILTER)

            loop
                local Unit target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)

                call Purge.Start(level, target, thistype.PURGE_DURATION[level])

                call caster.DamageUnitBySpell(target, damage, true, false)
            endloop
        endmethod

        static method Start takes Unit caster, integer level, real targetX, real targetY, integer waveCount returns nothing
            local real areaRange = PurgingRain.THIS_SPELL.GetAreaRange(level)

            local thistype this = thistype.allocate()

			local Timer durationTimer = Timer.Create()

            set this.areaRange = areaRange
            set this.caster = caster
            set this.damage = thistype.DAMAGE[level] * (1 + thistype.DAMAGE_REL_ADD[level] * (waveCount - 1))
            set this.targetX = targetX
            set this.targetY = targetY
            call durationTimer.SetData(this)

            set areaRange = areaRange * 0.75

			local integer iteration = thistype.DEBRIS_AMOUNT[level]

            loop
                exitwhen (iteration < 1)

                local real angle = Math.RandomAngle()
                local real offset = Math.Random(0., areaRange)

                call Spot.CreateEffect(targetX + offset * Math.Cos(angle), targetY + offset * Math.Sin(angle), thistype.SPECIAL_EFFECT_PATH, EffectLevel.LOW).Destroy()

                set iteration = iteration - 1
            endloop

            call durationTimer.Start(thistype.DAMAGE_DELAY, false, function thistype.Ending)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.ENUM_GROUP = Group.Create()
            set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("PurgingRain", "PURGING_RAIN")
    static SpellInstance WHICH_INSTANCE

    Timer durationTimer
    Timer intervalTimer
    integer level
    real targetX
    real targetY
    integer waveCount

    //! runtextmacro LinkToStruct("PurgingRain", "Wave")

    timerMethod EndingByTimer
        local thistype this = Timer.GetExpired().GetData()

        local Unit target = this

        call target.Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

    timerMethod Interval
        local thistype this = Timer.GetExpired().GetData()

        local Unit target = this

		local integer waveCount = this.waveCount + 1

		set this.waveCount = waveCount

        call thistype(NULL).Wave.Start(target, this.level, this.targetX, this.targetY, waveCount)
    endmethod

    eventMethod Event_BuffLose
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

        local Timer durationTimer = this.durationTimer
        local Timer intervalTimer = this.intervalTimer

        call durationTimer.Destroy()
        call intervalTimer.Destroy()
    endmethod

    eventMethod Event_BuffGain
        local integer level = params.Buff.GetLevel()
        local SpellInstance whichInstance = thistype.WHICH_INSTANCE

        local Unit target = whichInstance.GetCaster()
        local real targetX = whichInstance.GetTargetX()
        local real targetY = whichInstance.GetTargetY()

        local thistype this = target

        local Timer durationTimer = Timer.Create()
        local Timer intervalTimer = Timer.Create()

        set this.durationTimer = durationTimer
        set this.intervalTimer = intervalTimer
        set this.level = level
        set this.targetX = targetX
        set this.targetY = targetY
        set this.waveCount = 1
        call durationTimer.SetData(this)
        call intervalTimer.SetData(this)

        call intervalTimer.Start(thistype.INTERVAL[level], true, function thistype.Interval)

        call durationTimer.Start(thistype.THIS_SPELL.GetChannelTime(level), false, function thistype.EndingByTimer)

        call thistype(NULL).Wave.Start(target, level, targetX, targetY, 1)
    endmethod

    eventMethod Event_EndCast
        local Unit caster = params.Unit.GetTrigger()

        if caster.Buffs.Contains(FairyShape.DUMMY_BUFF) then
            return
        endif

        call caster.Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()
        local SpellInstance whichInstance = params.SpellInstance.GetTrigger()

        if caster.Buffs.Contains(FairyShape.DUMMY_BUFF) then
            call caster.Buffs.Remove(caster.Abilities.Events.Effect.Channeling.DUMMY_BUFF)
        endif

        set thistype.WHICH_INSTANCE = whichInstance

        call caster.Buffs.AddFresh(thistype.DUMMY_BUFF, level)
    endmethod

    initMethod Init of Spells_Hero
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Finish.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_EndCast))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call thistype(NULL).Wave.Init()
    endmethod
endstruct