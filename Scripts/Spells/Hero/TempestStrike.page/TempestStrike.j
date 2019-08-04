//! runtextmacro Folder("TempestStrike")
    //! runtextmacro Struct("CriticalAttacks")
        static method Start takes integer level, Unit target returns nothing
            call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.DURATION)
        endmethod

        static method Init takes nothing returns nothing
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("TempestStrike", "TEMPEST_STRIKE")
    static Group ENUM_GROUP
    static BoolExpr TARGET_FILTER
    //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "1")

    real damage
    integer level
    UnitList targetGroup
    Timer updateTimer

    //! runtextmacro LinkToStruct("TempestStrike", "CriticalAttacks")

    condMethod Conditions
        local Unit target = UNIT.Event.Native.GetFilter()

        if UnitList.TEMP.Contains(target) then
            return false
        endif

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

    timerMethod Update
        local thistype this = Timer.GetExpired().GetData()

        local Unit caster = this

        local UnitList targetGroup = this.targetGroup

		//if (caster.Order.Get() == NULL) then
        	call caster.Animation.SetByIndex(0)
        //endif

        set UnitList.TEMP = targetGroup
        set User.TEMP = caster.Owner.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(caster.Position.X.Get(), caster.Position.Y.Get(), thistype.THIS_SPELL.GetAreaRange(level), thistype.TARGET_FILTER)

        local Unit target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            local real damage = this.damage

            loop
                call target.Effects.Create(thistype.TARGET_EFFECT_PATH, thistype.TARGET_EFFECT_ATTACH_POINT, EffectLevel.NORMAL)
                call targetGroup.Add(target)

                call caster.DamageUnitBySpell(target, damage, false, true)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
    endmethod

    eventMethod Event_BuffLose
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

        local integer level = this.level
        local UnitList targetGroup = this.targetGroup
        local Timer updateTimer = this.updateTimer

        local boolean useBuff = (targetGroup.GetFirst() != NULL)

        call targetGroup.Destroy()
        call updateTimer.Destroy()

        call target.Animation.Queue(UNIT.Animation.STAND)

        if useBuff then
            call thistype(NULL).CriticalAttacks.Start(level, target)
        endif
    endmethod

    eventMethod Event_BuffGain
        local EventResponse castParams = params.Buff.GetData()
        local integer level = params.Buff.GetLevel()
        local Unit target = params.Unit.GetTrigger()

		local thistype this = target

		local Timer updateTimer = Timer.Create()

        set this.damage = thistype.DAMAGE[level]
        set this.level = level
        set this.targetGroup = UnitList.Create()
        set this.updateTimer = updateTimer
        call updateTimer.SetData(this)

        local real targetX = castParams.Spot.GetTargetX()
        local real targetY = castParams.Spot.GetTargetY()

        call target.Effects.Create(thistype.SPECIAL_EFFECT_ATTACH_POINT, thistype.SPECIAL_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).DestroyTimed.Start(thistype.DURATION)

        set thistype.DURATION = SetVar.GetValDefR("dur", thistype.DURATION)
        set thistype.LENGTH = SetVar.GetValDefR("length", thistype.LENGTH)
        set thistype.SPEED_END = SetVar.GetValDefR("speedEnd", thistype.SPEED_END)

        call target.Position.Timed.Accelerated.AddKnockback(2. * thistype.LENGTH / thistype.DURATION - thistype.SPEED_END, 2. / thistype.DURATION * (thistype.SPEED_END - thistype.LENGTH / thistype.DURATION), Math.AtanByDeltas(targetY - target.Position.Y.Get(), targetX - target.Position.X.Get()), thistype.DURATION)

        call updateTimer.Start(thistype.UPDATE_TIME, true, function thistype.Update)

        call target.Abilities.Refresh(SapphireblueDagger.THIS_SPELL)
    endmethod

    eventMethod Event_SpellEffect
        call params.Unit.GetTrigger().Buffs.Timed.StartEx(thistype.DUMMY_BUFF, params.Spell.GetLevel(), params, thistype.DURATION)
    endmethod

    initMethod Init of Spells_Hero
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call thistype(NULL).CriticalAttacks.Init()
    endmethod
endstruct