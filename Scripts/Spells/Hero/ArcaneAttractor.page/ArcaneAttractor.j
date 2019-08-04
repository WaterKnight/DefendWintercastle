//! runtextmacro Folder("ArcaneAttractor")
    //! runtextmacro Struct("Target")
        method Start takes Unit caster, integer level, Unit target returns nothing
            local ArcaneAttractor parent = this

            local Lightning dummyLightning = Lightning.Create(thistype.BOLT)

            call dummyLightning.FromUnitToUnit.Start(parent.summon, target)

            call dummyLightning.DestroyTimed.Start(UNIT.Knockup.DURATION)

            set Unit.TEMP = caster

            call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, level, thistype.DURATION[level])
        endmethod

        real duration
        ArcaneAttractor parent

        eventMethod Enum
            local Unit target = params.Unit.GetTrigger()
            local thistype this = params.GetData()

            local ArcaneAttractor parent = this.parent

            local Lightning dummyLightning = Lightning.Create(thistype.BOLT)

            call dummyLightning.FromUnitToUnit.Start(parent.summon, target)

            call dummyLightning.DestroyTimed.Start(UNIT.Knockup.DURATION)
        endmethod

        method StartGroup takes Group targetGroup, integer level returns nothing
            local ArcaneAttractor parent = this

            set this = parent

            set this.duration = thistype.DURATION[level]
            set this.parent = parent

            call targetGroup.DoEx(function thistype.Enum, this)

            call targetGroup.AddBuff(thistype.DUMMY_BUFF, level, thistype.DURATION[level])
        endmethod

        static method Init takes nothing returns nothing
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("ArcaneAttractor", "ARCANE_ATTRACTOR")
    static Group ENUM_GROUP
    static Event SUMMON_DESTROY_EVENT
    static BoolExpr TARGET_FILTER

    Timer durationTimer
    Timer intervalTimer
    Unit summon
    SpellInstance whichInstance

    //! runtextmacro LinkToStruct("ArcaneAttractor", "Target")

    condMethod Conditions
        local Unit target = UNIT.Event.Native.GetFilter()

        if target.Buffs.Contains(thistype(NULL).Target.DUMMY_BUFF) then
            return false
        endif
        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if target.Classes.Contains(UnitClass.MECHANICAL) then
            return false
        endif
        if target.IsAllyOf(User.TEMP) then
            return false
        endif
        if target.MagicImmunity.Try() then
            return false
        endif
        if (Math.Random(0., 1.) > thistype.TARGET_CHANCE) then
            return false
        endif

        return true
    endmethod

    timerMethod IntervalByTimer
        local thistype this = Timer.GetExpired().GetData()

        local SpellInstance whichInstance = this.whichInstance

        local Unit caster = whichInstance.GetCaster()
        local integer level = whichInstance.GetLevel()

        local Unit summon = this.summon

        local real x = summon.Position.X.Get()
        local real y = summon.Position.Y.Get()

        set User.TEMP = caster.Owner.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, thistype.THIS_SPELL.GetAreaRange(level), thistype.TARGET_FILTER)

        local Unit target = thistype.ENUM_GROUP.GetNearest(x, y)

        if (target != NULL) then
            local real damage = thistype.DAMAGE[level]
            local real damageLifeFactor = thistype.DAMAGE_LIFE_FACTOR[level]

            call this.Target.Start(caster, level, target)

            call target.Knockup.Start()
            call target.Position.Timed.Accelerated.AddKnockback(450., 0., Math.AtanByDeltas(target.Position.Y.Get() - y, target.Position.X.Get() - x) + Math.HALF_ANGLE, UNIT.Knockup.DURATION)
            if caster.Buffs.Contains(FairyShape.DUMMY_BUFF) then
                call target.Stun.AddTimedBy(UNIT.Stun.NORMAL_BUFF, FairyShape.ARCANE_ATTRACTOR_STUN_DURATION[caster.Buffs.GetLevel(FairyShape.DUMMY_BUFF)])
            endif

            call target.Effects.Create(thistype(NULL).Target.DAMAGE_EFFECT_PATH, thistype(NULL).Target.DAMAGE_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()

            call caster.DamageUnitBySpell(target, damage + damageLifeFactor * target.Life.Get(), true, false)
        endif
/*
        set target = thistype.ENUM_GROUP.GetFirst()

        if (target != NULL) then
            local real damage = thistype.DAMAGE[level]
            local real damageLifeFactor = thistype.DAMAGE_LIFE_FACTOR[level]

            call this.Target.StartGroup(thistype.ENUM_GROUP, level)

            call thistype.ENUM_GROUP.RemoveUnit(target)

            loop
                call target.Knockup.Start()
                if caster.Buffs.Contains(FairyShape.DUMMY_BUFF) then
                    call target.Stun.AddTimedBy(UNIT.Stun.NORMAL_BUFF, FairyShape.ARCANE_ATTRACTOR_STUN_DURATION[caster.Buffs.GetLevel(FairyShape.DUMMY_BUFF)])
                endif

                call target.Position.Timed.Accelerated.AddKnockback(450., 0., Math.AtanByDeltas(target.Position.Y.Get() - y, target.Position.X.Get() - x) + Math.HALF_ANGLE, UNIT.Knockup.DURATION)

                call thistype(NULL).Target.Start(caster, level, target)

                call target.Effects.Create(thistype(NULL).Target.DAMAGE_EFFECT_PATH, thistype(NULL).Target.DAMAGE_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()

                call caster.DamageUnitBySpell(target, damage + damageLifeFactor * target.Life.Get(), true, false)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
*/
    endmethod

    method Ending takes nothing returns nothing
        local Timer durationTimer = this.durationTimer
        local Timer intervalTimer = this.intervalTimer
        local Unit summon = this.summon

        call durationTimer.Destroy()
        call intervalTimer.Destroy()

        call summon.Event.Remove(SUMMON_DESTROY_EVENT)
        call summon.Destroy()

        //call this.deallocate()
    endmethod

    eventMethod Event_Summon_Destroy
        local Unit summon = params.Unit.GetTrigger()

        local thistype this = summon

        call this.Ending()
    endmethod

    timerMethod EndingByTimer
        local thistype this = Timer.GetExpired().GetData()

        call this.Ending()
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()
        local real targetX = params.Spot.GetTargetX()
        local real targetY = params.Spot.GetTargetY()
//        local real targetZ = Spot.GetHeight(targetX, targetY)
        local SpellInstance whichInstance = params.SpellInstance.GetTrigger()

        local Unit summon = Unit.CreateSummon(thistype.SUMMON_UNIT_TYPE, caster.Owner.Get(), targetX, targetY, whichInstance.GetAngle(), thistype.DURATION[level])

        local thistype this = summon

        local Timer durationTimer = Timer.Create()
        local Timer intervalTimer = Timer.Create()

        set this.durationTimer = durationTimer
        set this.intervalTimer = intervalTimer
        set this.summon = summon
        set this.whichInstance = whichInstance
        call durationTimer.SetData(this)
        call intervalTimer.SetData(this)

        call summon.Event.Add(SUMMON_DESTROY_EVENT)

        call summon.Effects.Create(thistype.DUMMY_UNIT_SPECIAL_EFFECT_PATH, thistype.DUMMY_UNIT_SPECIAL_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()

        call summon.Animation.Set(Animation.CHANNEL)
        call summon.Color.Set(caster.Color.Get())
        call summon.Position.Z.SetFlyHeight(thistype.DUMMY_UNIT_HEIGHT)
        call summon.VertexColor.Set(0, 0, 0, 0)
        call summon.VertexColor.Timed.Add(255, 255, 255, 255, 1.)

        call Spot.CreateEffect(targetX, targetY, thistype.AREA_EFFECT_PATH, EffectLevel.LOW).Destroy()

        call intervalTimer.Start(thistype.INTERVAL, true, function thistype.IntervalByTimer)
        call durationTimer.Start(thistype.DURATION[level], false, function thistype.EndingByTimer)
    endmethod

    initMethod Init of Spells_Hero
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.SUMMON_DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Summon_Destroy)
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call thistype(NULL).Target.Init()
    endmethod
endstruct