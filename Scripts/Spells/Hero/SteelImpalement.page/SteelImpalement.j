//! runtextmacro Folder("SteelImpalement")
    //! runtextmacro Struct("Target")
        static method Start takes Unit target, Unit caster, integer level returns nothing
        	call target.Effects.Create(thistype.SPECIAL_EFFECT_PATH, thistype.SPECIAL_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

        	call target.Knockup.Start()

            call target.Buffs.Timed.StartEx(thistype.DUMMY_BUFF, level, caster, thistype.DURATION[level])
        endmethod

        static method Init takes nothing returns nothing
            call UNIT.Bleeding.NORMAL_BUFF.Variants.Add(thistype.DUMMY_BUFF)
            call UNIT.Movement.DISABLE_BUFF.Variants.Add(thistype.DUMMY_BUFF)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("SteelImpalement", "STEEL_IMPALEMENT")
    static Group ENUM_GROUP
    static BoolExpr TARGET_FILTER
    static constant real UPDATE_TIME = 1.5

    real animSpeedAdd
    real areaRange
    real areaRangeAdd
    real damage
    UnitList targetGroup
    SpellInstance whichInstance
    Timer updateTimer
    Timer waveTimer

    //! runtextmacro LinkToStruct("SteelImpalement", "Target")

    condMethod Conditions
        local Unit target = UNIT.Event.Native.GetFilter()

        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if target.Classes.Contains(UnitClass.STRUCTURE) then
            return false
        endif
        if UnitList.TEMP.Contains(target) then
            return false
        endif
        if target.IsAllyOf(User.TEMP) then
            return false
        endif

        return true
    endmethod

    timerMethod Update
        local thistype this = Timer.GetExpired().GetData()

        local Unit caster = this

        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()

        local real areaRange = this.areaRange + this.areaRangeAdd
        local integer level = this.whichInstance.GetLevel()
        local UnitList targetGroup = this.targetGroup

        set this.areaRange = areaRange

        local real peri = Math.DOUBLE_PI * areaRange

        local real angle = Math.RandomAngle()

        local integer sfxToSpawn = Real.ToInt(peri / SetVar.GetValDefR("sfxdist", thistype.SFX_DIST))

        local real angleAdd = Math.FULL_ANGLE / sfxToSpawn

        loop
            exitwhen (sfxToSpawn < 1)

            set angle = angle + angleAdd

            call Spot.CreateEffect(casterX + areaRange * Math.Cos(angle), casterY + areaRange * Math.Sin(angle), thistype.SPECIAL_EFFECT_PATH, EffectLevel.LOW).Destroy()

            set sfxToSpawn = sfxToSpawn - 1
        endloop

        set User.TEMP = caster.Owner.Get()
        set UnitList.TEMP = targetGroup

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(casterX, casterY, areaRange, thistype.TARGET_FILTER)

        local Unit target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            loop
                call targetGroup.Add(target)

                call thistype(NULL).Target.Start(target, caster, level)

                call caster.DamageUnitBySpell(target, this.damage, false, false)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
    endmethod

	timerMethod NewWave
		local thistype this = Timer.GetExpired().GetData()

		set this.areaRange = 0.

		call this.targetGroup.Clear()
	endmethod

    eventMethod Event_BuffLose
        local Unit caster = params.Unit.GetTrigger()

        local thistype this = caster

        local real animSpeedAdd = this.animSpeedAdd
        local Timer updateTimer = this.updateTimer
        local Timer waveTimer = this.waveTimer

        call updateTimer.Destroy()
        call waveTimer.Destroy()

        call caster.Animation.Speed.Subtract(animSpeedAdd)
        call caster.Death.Protection.Subtract()
    endmethod

    eventMethod Event_BuffGain
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Buff.GetLevel()
        local SpellInstance whichInstance = params.Buff.GetData()

        local real animSpeedAdd = SetVar.GetValDefR("animspeed", 0.5) * 1.2 / thistype.THIS_SPELL.GetChannelTime(level) - 1
        local real updateTime = thistype.UPDATE_TIME / thistype.WAVES_AMOUNT[level]

		local thistype this = caster

        local Timer updateTimer = Timer.Create()
        local Timer waveTimer = Timer.Create()

        set this.animSpeedAdd = animSpeedAdd
        set this.areaRange = 0.
        set this.areaRangeAdd = thistype.THIS_SPELL.GetAreaRange(level) / thistype.THIS_SPELL.GetChannelTime(level) * thistype.WAVES_AMOUNT[level] * updateTime
        set this.damage = thistype.DAMAGE[level]
        set this.targetGroup = UnitList.Create()
        set this.updateTimer = updateTimer
        set this.waveTimer = waveTimer
        set this.whichInstance = whichInstance
        call updateTimer.SetData(this)
        call waveTimer.SetData(this)

        call caster.Animation.Speed.Add(animSpeedAdd)
        call caster.Death.Protection.Add()

        call updateTimer.Start(updateTime, true, function thistype.Update)

		call waveTimer.Start(thistype.THIS_SPELL.GetChannelTime(level) / thistype.WAVES_AMOUNT[level], true, function thistype.NewWave)
    endmethod

    eventMethod Event_EndCast
        call params.Unit.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

    eventMethod Event_SpellEffect
        call params.Unit.GetTrigger().Buffs.AddEx(thistype.DUMMY_BUFF, params.Spell.GetLevel(), params.SpellInstance.GetTrigger())
    endmethod

    initMethod Init of Spells_Hero
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))

        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Finish.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_EndCast))

        call thistype(NULL).Target.Init()
    endmethod
endstruct