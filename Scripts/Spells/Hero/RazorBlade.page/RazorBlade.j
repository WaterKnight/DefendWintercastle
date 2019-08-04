//! runtextmacro Folder("RazorBladeDrawBack")
    //! runtextmacro Struct("Blade")
        static Event CHECKPOINT_IMPACT_EVENT
        static Group ENUM_GROUP
        static BoolExpr TARGET_FILTER
        //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "2")
        static Timer UPDATE_TIMER

        //! runtextmacro CreateList("ACTIVE_LIST")
        //! runtextmacro CreateForEachList("FOR_EACH_LIST", "ACTIVE_LIST")

        Timer checkpointTimer
        Lightning dummyLightning
        Missile dummyMissile
        RazorBladeDrawBack parent
        UnitList targetGroup

        eventMethod ImpactCaster
            local Missile dummyMissile = params.Missile.GetTrigger()

            local thistype this = dummyMissile.GetData()

            local Timer checkpointTimer = this.checkpointTimer
            local Lightning dummyLightning = this.dummyLightning

            local RazorBladeDrawBack parent = this.parent

            if thistype.ACTIVE_LIST_Remove(this) then
                call thistype.UPDATE_TIMER.Pause()
            endif

            call dummyMissile.Event.Remove(CHECKPOINT_IMPACT_EVENT)

            call checkpointTimer.Destroy()
            call dummyLightning.Destroy()
            call dummyMissile.Destroy()

            if (parent.remainingBladesAmount == 1) then
                call parent.Ending()
            else
                set parent.remainingBladesAmount = parent.remainingBladesAmount - 1
            endif
        endmethod

        condMethod TargetConditions
            local Unit target = UNIT.Event.Native.GetFilter()

            if UnitList.TEMP.Contains(target) then
                return false
            endif

            if target.Classes.Contains(UnitClass.DEAD) then
                return false
            endif

            if target.IsAllyOf(User.TEMP) then
                return false
            endif

            return true
        endmethod

        timerMethod Update
            call thistype.FOR_EACH_LIST_Set()

            loop
                local thistype this = thistype.FOR_EACH_LIST_FetchFirst()

                exitwhen (this == NULL)

                local real areaRange = parent.areaRange
                local Unit caster = parent.caster
                local real damage = parent.damage
                local Missile dummyMissile = this.dummyMissile
                local UnitList targetGroup = this.targetGroup

                set UnitList.TEMP = targetGroup

                set User.TEMP = caster.Owner.Get()

                call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.DoWithZ(dummyMissile.Position.X.Get(), dummyMissile.Position.Y.Get(), dummyMissile.Position.Z.Get(), areaRange, thistype.TARGET_FILTER)

                local Unit target = thistype.ENUM_GROUP.FetchFirst()

                if (target != NULL) then
                    loop
                        call target.Effects.Create(thistype.TARGET_EFFECT_PATH, thistype.TARGET_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()
                        call targetGroup.Add(target)

                        call caster.DamageUnitBySpell(target, damage, false, true)

                        set target = thistype.ENUM_GROUP.FetchFirst()
                        exitwhen (target == NULL)
                    endloop
                endif
            endloop
        endmethod

        timerMethod Delay
            local Timer delayTimer = Timer.GetExpired()

            local Missile dummyMissile = delayTimer.GetData()

            call delayTimer.Destroy()

            local thistype this = dummyMissile.GetData()

            local RazorBladeDrawBack parent = this.parent

            call dummyMissile.Acceleration.Set(500.)
            call dummyMissile.CollisionSize.Set(parent.areaRange)
            call dummyMissile.Impact.SetAction(function thistype.ImpactCaster)
            call dummyMissile.Speed.Set(850.)

            call dummyMissile.GoToUnit.Start(parent.caster, null)
        endmethod

        eventMethod ImpactSpread
            local Missile dummyMissile = params.Missile.GetTrigger()

            local Timer delayTimer = Timer.Create()

            call delayTimer.SetData(dummyMissile)

            call delayTimer.Start(SetVar.GetValDefR("delay", thistype.DELAY), false, function thistype.Delay)
        endmethod

        //! runtextmacro GetKey("CHECKPOINT_BOLT_KEY")

        eventMethod CheckpointImpact
            local MissileCheckpoint checkpoint = params.MissileCheckpoint.GetTrigger()

            local Lightning dummyBolt = checkpoint.Data.Integer.Get(CHECKPOINT_BOLT_KEY)

            call dummyBolt.Destroy()
        endmethod

        timerMethod NewCheckpoint
            local thistype this = Timer.GetExpired().GetData()

            local Unit caster = this.parent.caster

            local real x = caster.Position.X.Get()
            local real y = caster.Position.Y.Get()
            local real z = caster.Position.Z.Get()

            local MissileCheckpoint newCheckpoint = this.dummyMissile.Checkpoints.Create(x, y, z)
            local MissileCheckpoint prevCheckpoint

            local Lightning newBolt = Lightning.Create(thistype.BOLT)

            call newCheckpoint.Data.Integer.Set(CHECKPOINT_BOLT_KEY, newBolt)

            if (newCheckpoint == this.dummyMissile.Checkpoints.GetFirst()) then
                call newBolt.FromSpotToDummyUnit.Start(x, y, z, this.dummyMissile.DummyUnit.Get())
            else
                set prevCheckpoint = this.dummyMissile.Checkpoints.GetPrev(newCheckpoint)

                call newBolt.FromSpotToSpot.Start(x, y, z, prevCheckpoint.GetX(), prevCheckpoint.GetY(), prevCheckpoint.GetZ())
            endif

            call this.dummyLightning.FromSpotToUnit.Start(x, y, z, caster)
        endmethod

        method StartBlade takes real angle, real spreadRange returns nothing
        	local RazorBladeDrawBack parent = this

            local real sourceX = parent.sourceX
            local real sourceY = parent.sourceY
            local real sourceZ = parent.sourceZ

            set this = thistype.allocate()

            local Timer checkpointTimer = Timer.Create()
            local Lightning dummyLightning = Lightning.Create(thistype.BOLT)
            local Missile dummyMissile = Missile.Create()

            set this.checkpointTimer = checkpointTimer
            set this.dummyLightning = dummyLightning
            set this.dummyMissile = dummyMissile
            set this.parent = parent
            set this.targetGroup = UnitList.Create()
            call checkpointTimer.SetData(this)

            call dummyMissile.Event.Add(CHECKPOINT_IMPACT_EVENT)

            call dummyMissile.Acceleration.Set(SetVar.GetValDefR("acc", 0.))
            call dummyMissile.CollisionSize.Set(0.)
            call dummyMissile.Impact.SetAction(function thistype.ImpactSpread)
            call dummyMissile.SetData(this)
            call dummyMissile.Speed.Set(SetVar.GetValDefR("speed", 600.))
            call dummyMissile.Position.Set(sourceX, sourceY, sourceZ)

            call dummyMissile.GoToSpot.Start(sourceX + spreadRange * Math.Cos(angle), sourceY + spreadRange * Math.Sin(angle), sourceZ)

            call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 1.)//.AddEffect(thistype.MISSILE_EFFECT_PATH, thistype.MISSILE_EFFECT_ATTACH_POINT, EffectLevel.NORMAL)

            call dummyLightning.FromDummyUnitToUnit.Start(dummyMissile.DummyUnit.Get(), 0., parent.caster)

            if thistype.ACTIVE_LIST_Add(this) then
                call thistype.UPDATE_TIMER.Start(thistype.UPDATE_TIME, true, function thistype.Update)
            endif

            call checkpointTimer.Start(SetVar.GetValDefR("smooth", 0.5), true, function thistype.NewCheckpoint)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.CHECKPOINT_IMPACT_EVENT = Event.Create(MISSILE.Checkpoints.IMPACT_EVENT_TYPE, EventPriority.SPELLS, function thistype.CheckpointImpact)
            set thistype.ENUM_GROUP = Group.Create()
            set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.TargetConditions)
            set thistype.UPDATE_TIMER = Timer.Create()
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("RazorBladeDrawBack", "RAZOR_BLADE_DRAW_BACK")
    real areaRange
    integer bladesToSpawnAmount
    Unit caster
    real damage
    Timer intervalTimer
    integer level
    Lightning parentBolt
    Missile parentMissile
    real parentMissileScaleAdd
    integer remainingBladesAmount
    real sourceX
    real sourceY
    real sourceZ

    //! runtextmacro LinkToStruct("RazorBladeDrawBack", "Blade")

    method Ending takes nothing returns nothing
        call this.intervalTimer.Destroy()
        //call this.parentBolt.Destroy()
        call this.parentMissile.Destroy()

        call this.deallocate()
    endmethod

    method StartBlade takes nothing returns nothing
        set this.bladesToSpawnAmount = this.bladesToSpawnAmount - 1

        if (this.bladesToSpawnAmount == 0) then
            call this.intervalTimer.Pause()

            call this.parentBolt.Color.Set(255, 255, 255, 0)
        endif

        call this.parentMissile.DummyUnit.Get().Scale.Add(this.parentMissileScaleAdd)

        call this.Blade.StartBlade(Math.FULL_ANGLE / thistype.MISSILES_AMOUNT[this.level] * this.bladesToSpawnAmount, thistype.SPREAD_RANGE)
    endmethod

    timerMethod Interval
        local thistype this = Timer.GetExpired().GetData()

        call this.StartBlade()
    endmethod

    static method Start takes Lightning parentBolt, Missile parentMissile, Unit caster, integer level, real sourceX, real sourceY, real sourceZ returns nothing
        local thistype this = thistype.allocate()

		local Timer intervalTimer = Timer.Create()

        set this.areaRange = thistype.AREA_RANGE[level]
        set this.bladesToSpawnAmount = thistype.MISSILES_AMOUNT[level]
        set this.caster = caster
        set this.damage = thistype.DAMAGE[level]
        set this.intervalTimer = intervalTimer
        set this.level = level
        set this.parentBolt = parentBolt
        set this.parentMissile = parentMissile
        set this.parentMissileScaleAdd = -parentMissile.DummyUnit.Get().Scale.Get() / thistype.MISSILES_AMOUNT[level]
        set this.sourceX = sourceX
        set this.sourceY = sourceY
        set this.sourceZ = sourceZ
        set this.remainingBladesAmount = thistype.MISSILES_AMOUNT[level]

        call intervalTimer.Start(SetVar.GetValDefR("interval", thistype.INTERVAL[level]), true, function thistype.Interval)

        call this.StartBlade()
    endmethod

    initMethod Init of Spells_Hero
        call thistype(NULL).Blade.Init()
    endmethod
endstruct

//! runtextmacro Folder("RazorBlade")
    //! runtextmacro Struct("Vamp")
        eventMethod Event_Unlearn
            call params.Unit.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
        endmethod

        eventMethod Event_Learn
            call params.Unit.GetTrigger().Buffs.AddFresh(thistype.DUMMY_BUFF, params.Spell.GetLevel())
        endmethod

        static method Init takes nothing returns nothing
            call RazorBlade.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Learn.CHANGE_LEVEL_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Learn))
            call RazorBlade.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Learn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Learn))
            call RazorBlade.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Unlearn.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Unlearn))
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("RazorBlade", "RAZOR_BLADE")
    static Group ENUM_GROUP
    static BoolExpr TARGET_FILTER
    //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "2")

    Unit caster
    real damage
    Lightning dummyLightning
    Missile dummyMissile
    integer level
    UnitList targetGroup
    real targetX
    real targetY
    Timer updateTimer

    //! runtextmacro LinkToStruct("RazorBlade", "Vamp")

    eventMethod Impact
        local Missile dummyMissile = params.Missile.GetTrigger()

        local thistype this = dummyMissile.GetData()

        local Unit caster = this.caster
        local integer level = this.level
        local Timer updateTimer = this.updateTimer
        local real x = dummyMissile.Position.X.Get()
        local real y = dummyMissile.Position.Y.Get()
        local real z = dummyMissile.Position.Z.Get()

        call updateTimer.Destroy()

        call this.deallocate()

        call RazorBladeDrawBack.Start(dummyLightning, dummyMissile, caster, level, x, y, z)
    endmethod

    condMethod TargetConditions
        local Unit target = UNIT.Event.Native.GetFilter()

        /*if UnitList.TEMP.Contains(target) then
            return false
        endif*/

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

        local Unit caster = this.caster
        local Missile dummyMissile = this.dummyMissile
        local UnitList targetGroup = this.targetGroup
        local real targetX = this.targetX
        local real targetY = this.targetY

        set UnitList.TEMP = targetGroup
        set User.TEMP = caster.Owner.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.DoWithZ(dummyMissile.Position.X.Get(), dummyMissile.Position.Y.Get(), dummyMissile.Position.Z.Get(), thistype.THIS_SPELL.GetAreaRange(level), thistype.TARGET_FILTER)

        local Unit target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            local real damage = this.damage

            loop
                if not targetGroup.Contains(target) then
                    call target.Effects.Create(thistype.TARGET_EFFECT_PATH, thistype.TARGET_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()
                    call target.Position.Timed.Accelerated.AddKnockback(650., -200., Math.AtanByDeltas(targetY - target.Position.Y.Get(), targetX - target.Position.X.Get()), 1.)
                    call targetGroup.Add(target)

                    call caster.DamageUnitBySpell(target, damage, false, true)
                endif

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()
        local real targetX = params.Spot.GetTargetX()
        local real targetY = params.Spot.GetTargetY()

        local real casterX = caster.Position.X.Get()
        local real casterY = caster.Position.Y.Get()
        local real maxLength = thistype.MAX_LENGTH[level]

        local real angle = caster.CastAngle(targetX - casterX, targetY - casterY)

        set targetX = casterX + maxLength * Math.Cos(angle)
        set targetY = casterY + maxLength * Math.Sin(angle)

        local thistype this = thistype.allocate()

        local Lightning dummyLightning = NULL//Lightning.Create(thistype.BOLT)
        local Missile dummyMissile = Missile.Create()
        local Timer updateTimer = Timer.Create()

        set this.caster = caster
        set this.damage = thistype.DAMAGE[level]
        set this.dummyMissile = dummyMissile
        set this.dummyLightning = dummyLightning
        set this.level = level
        set this.targetGroup = UnitList.Create()
        set this.targetX = targetX
        set this.targetY = targetY
        set this.updateTimer = updateTimer
        call updateTimer.SetData(this)

        call dummyMissile.Acceleration.Set(-400.)
        call dummyMissile.CollisionSize.Set(thistype.THIS_SPELL.GetAreaRange(level))
        call dummyMissile.Impact.SetAction(function thistype.Impact)
        call dummyMissile.SetData(this)
        call dummyMissile.Speed.Set(1100.)
        call dummyMissile.Position.SetFromUnit(caster)

        call dummyMissile.GoToSpot.Start(targetX, targetY, Spot.GetHeight(targetX, targetY) + UNIT_TYPE.Impact.Z.STANDARD)

        call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 2.)//.AddEffect(thistype.MISSILE_EFFECT_PATH, thistype.MISSILE_EFFECT_ATTACH_POINT, EffectLevel.NORMAL)

        //call dummyLightning.FromDummyUnitToUnit.Start(dummyMissile.DummyUnit.Get(), 0., caster)

        call updateTimer.Start(thistype.UPDATE_TIME, true, function thistype.Update)
    endmethod

    initMethod Init of Spells_Hero
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.TargetConditions)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call thistype(NULL).Vamp.Init()
    endmethod
endstruct