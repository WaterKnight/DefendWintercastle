//! runtextmacro Folder("FairyShape")
    //! runtextmacro Struct("Revert")
        static real X
        static real Y

        SpotEffect sourceEffect
        real x
        real y

        eventMethod Event_SpellEffect
            local Unit caster = params.Unit.GetTrigger()

            local thistype this = caster

            local real x = this.x
            local real y = this.y

            call caster.Buffs.Remove(thistype.DUMMY_BUFF)

            call Spot.CreateEffect(caster.Position.X.Get(), caster.Position.Y.Get(), thistype.CAST_EFFECT_PATH, EffectLevel.LOW).Destroy()

            call caster.Position.SetXYZ(x, y, Spot.GetHeight(x, y))
            call Spot.CreateEffect(x, y, thistype.CAST_END_EFFECT_PATH, EffectLevel.LOW).Destroy()

            call caster.Buffs.Remove(FairyShape.DUMMY_BUFF)
        endmethod

        eventMethod Event_BuffLose
            local Unit target = params.Unit.GetTrigger()

            local thistype this = target

            local SpotEffect sourceEffect = this.sourceEffect

            call sourceEffect.Destroy()
        endmethod

        eventMethod Event_BuffGain
            local Unit target = params.Unit.GetTrigger()
            local real x = thistype.X
            local real y = thistype.Y

            local thistype this = target

            set this.sourceEffect = Spot.CreateEffect(x, y, thistype.SOURCE_EFFECT_PATH, EffectLevel.LOW)
            set this.x = x
            set this.y = y
        endmethod

        static method Ending takes Unit target returns nothing
            call target.Buffs.Remove(thistype.DUMMY_BUFF)

            call HeroSpell.ReplaceSlot(SpellClass.HERO_ULTIMATE, FairyShape.THIS_SPELL, target)
        endmethod

        static method Start takes Unit target, integer level returns nothing
            local real x = target.Position.X.Get()
            local real y = target.Position.Y.Get()

            set thistype.X = x
            set thistype.Y = y
            call target.Buffs.Add(thistype.DUMMY_BUFF, level)

            call HeroSpell.ReplaceSlot(SpellClass.HERO_ULTIMATE, thistype.THIS_SPELL, target)
        endmethod

        static method Init takes nothing returns nothing
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
            call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("FairyShape", "FAIRY_SHAPE")
    static Group ENUM_GROUP
    //! runtextmacro GetKeyArray("KEY_ARRAY_DETAIL")
    static BoolExpr TARGET_FILTER

    static integer LOWEST_HIT_COUNT

    real areaRange
    real burnedMana
    real heal
    Timer intervalTimer
    integer level
    UnitType origUnitType
    Group targetGroup

    //! runtextmacro LinkToStruct("FairyShape", "Revert")

    condMethod Conditions
        local Unit caster = Unit.TEMP
        local Unit target = UNIT.Event.Native.GetFilter()

        if target.Classes.Contains(UnitClass.DEAD) then
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
        if (target.Mana.Get() <= 0.) then
            return false
        endif

        local integer hitCount = caster.Data.Integer.Get(KEY_ARRAY_DETAIL + target)

        if (hitCount < thistype.LOWEST_HIT_COUNT) then
            set thistype.LOWEST_HIT_COUNT = hitCount
        endif

        return true
    endmethod

    enumMethod RemoveHigherHitCountsEnum
        local Unit target = UNIT.Event.Native.GetEnum()

        if (Unit.TEMP.Data.Integer.Get(KEY_ARRAY_DETAIL + target) > thistype.LOWEST_HIT_COUNT) then
            call thistype.ENUM_GROUP.RemoveUnit(target)
        endif
    endmethod

    timerMethod Interval
        local thistype this = Timer.GetExpired().GetData()

        local real areaRange = this.areaRange
        local Unit caster = this
        local integer level = this.level

        local real x = caster.Position.X.Get()
        local real y = caster.Position.Y.Get()

        set User.TEMP = caster.Owner.Get()
        set Unit.TEMP = caster
        set thistype.LOWEST_HIT_COUNT = Math.Integer.MAX

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, areaRange, thistype.TARGET_FILTER)

        call thistype.ENUM_GROUP.Do(function thistype.RemoveHigherHitCountsEnum)

        local Unit target = thistype.ENUM_GROUP.GetNearest(x, y)

        if (target != NULL) then
            local real burnedManaMax = this.burnedMana
            local real heal = this.heal
            local Group targetGroup = this.targetGroup

            call caster.Data.Integer.Add(KEY_ARRAY_DETAIL + target, 1)
            if not targetGroup.ContainsUnit(target) then
                call target.Refs.Add()
                call targetGroup.AddUnit(target)
            endif

			local Lightning effectLightning = Lightning.Create(thistype.BOLT)

            call effectLightning.FromUnitToUnit.Start(caster, target)
            call effectLightning.DestroyTimed.Start(0.35)
            call target.Effects.Create(thistype.TARGET_EFFECT_PATH, thistype.TARGET_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()

            if not target.MagicImmunity.Try() then
				local real eclipseDuration

				if target.Classes.Contains(UnitClass.HERO) then
					set eclipseDuration = thistype.ECLIPSE_HERO_DURATION[level]
				else
					set eclipseDuration = thistype.ECLIPSE_DURATION[level]
				endif

                call target.Buffs.Timed.Start(thistype.ECLIPSE_BUFF, level, eclipseDuration)

				local real burnedMana = Math.Min(target.Mana.Get(), burnedManaMax)

                call caster.BurnManaBySpell(target, burnedMana)
                call caster.HealBySpell(caster, burnedMana / burnedManaMax * heal)
            endif
        endif
    endmethod

    eventMethod Event_BuffLose
        local Unit caster = params.Unit.GetTrigger()

        local thistype this = caster

        local Timer intervalTimer = this.intervalTimer
        local UnitType origUnitType = this.origUnitType
        local Group targetGroup = this.targetGroup

        call intervalTimer.Destroy()

        loop
            local Unit target = targetGroup.FetchFirst()
            exitwhen (target == NULL)

            call caster.Data.Integer.Remove(KEY_ARRAY_DETAIL + target)
            call target.Refs.Subtract()
        endloop

        call caster.Type.SetWithChangerAbility(origUnitType, thistype.REVERT_ABILITY_ID)

        //call thistype(NULL).Revert.Ending(caster)
    endmethod

    eventMethod Event_BuffGain
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Buff.GetLevel()

        local thistype this = caster

		local Timer intervalTimer = Timer.Create()

        set this.areaRange = thistype.THIS_SPELL.GetAreaRange(level)
        set this.burnedMana = thistype.BURNED_MANA[level]
        set this.heal = thistype.HEAL[level]
        set this.level = level
        set this.origUnitType = caster.Type.Get()
        set this.intervalTimer = intervalTimer
        set this.targetGroup = Group.Create()
        call intervalTimer.SetData(this)

        call caster.Type.SetWithChangerAbility(thistype.THIS_UNIT_TYPE, thistype.CHANGER_ABILITY_ID)

        call intervalTimer.Start(thistype.INTERVAL[level], true, function thistype.Interval)

        //call thistype(NULL).Revert.Start(caster, level)

        if caster.Buffs.Contains(PurgingRain.DUMMY_BUFF) then
            call caster.Buffs.Remove(UNIT.Abilities.Events.Effect.Channeling.DUMMY_BUFF)
        endif
    endmethod

    eventMethod Event_SpellEffect
        local integer level = params.Spell.GetLevel()

        call params.Unit.GetTrigger().Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.DURATION[level])
    endmethod

    initMethod Init of Spells_Hero
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call UNIT.Eclipse.NORMAL_BUFF.Variants.Add(thistype.ECLIPSE_BUFF)

        call thistype(NULL).Revert.Init()
    endmethod
endstruct