//! runtextmacro Folder("Fireburst")
    //! runtextmacro Struct("Shot")
        static Group ENUM_GROUP
        static Group ENUM_GROUP2
        static BoolExpr COLLISION_FILTER
        static BoolExpr TARGET_FILTER

        real damageExtra
        Fireburst parent

        condMethod Conditions
            local Unit target = UNIT.Event.Native.GetFilter()

            if target.Classes.Contains(UnitClass.DEAD) then
                return false
            endif
            if target.MagicImmunity.Try() then
                return false
            endif
            if target.IsAllyOf(User.TEMP) then
                return false
            endif

            return true
        endmethod

        condEventMethod Collision_Conditions
			local Missile dummyMissile = params.Missile.GetTrigger()
            local Unit target = UNIT.Event.Native.GetFilter()

            local thistype this = dummyMissile.GetData()

            local Fireburst parent = this.parent

            if target.Classes.Contains(UnitClass.DEAD) then
                return false
            endif
            if target.IsAllyOf(parent.caster.Owner.Get()) then
                return false
            endif
        endmethod

        eventMethod ImpactExtra
            local Missile dummyMissile = params.Missile.GetTrigger()

            local thistype this = dummyMissile.GetData()

            local Fireburst parent = this.parent

            local Unit caster = parent.caster
            local integer level = parent.level
            local Unit target = parent.target
            local real targetX = dummyMissile.Position.X.Get()
            local real targetY = dummyMissile.Position.Y.Get()

            call dummyMissile.Destroy()

            call target.Buffs.Timed.StartEx(thistype.IGNITION_BUFF, level, caster, thistype.IGNITION_DURATION[level])

            call caster.DamageUnitBySpell(target, this.damageExtra, true, false)

            call parent.SubtractRef()

            call this.deallocate()
        endmethod

        eventMethod Impact
            local Missile dummyMissile = params.Missile.GetTrigger()
            local Unit target = params.Unit.GetTrigger()

            local thistype this = dummyMissile.GetData()

            local Fireburst parent = this.parent

            local Unit caster = parent.caster
            local integer level = parent.level
            local real targetX = dummyMissile.Position.X.Get()
            local real targetY = dummyMissile.Position.Y.Get()

            call dummyMissile.Destroy()

			call Spot.CreateEffect(targetX, targetY, "Objects\\Spawnmodels\\Other\\NeutralBuildingExplosion\\NeutralBuildingExplosion.mdl", EffectLevel.NORMAL).Destroy()

			if (target != NULL) then
            	call target.Buffs.Timed.StartEx(thistype.IGNITION_BUFF, level, caster, thistype.IGNITION_DURATION[level])
            endif

            set User.TEMP = caster.Owner.Get()

            call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(targetX, targetY, Fireburst.THIS_SPELL.GetAreaRange(level), thistype.TARGET_FILTER)

			//if (target != NULL) then
            	//call thistype.ENUM_GROUP.RemoveUnit(target)
            //endif

            set target = thistype.ENUM_GROUP.FetchFirst()

            if (target != NULL) then
                local real casterX = parent.x
                local real casterY = parent.y
                local real colSize = caster.CollisionSize.Get(true)
                local real damage = thistype.DAMAGE[level]

                loop
                    local real d = Math.DistanceByDeltas(target.Position.X.Get() - casterX, target.Position.Y.Get() - casterY)

                    local real rangeFactor = Math.Shapes.LinearFromCoords(colSize, thistype.RANGE_FACTOR_CLOSE, Fireburst.THIS_SPELL.GetRange(level), thistype.RANGE_FACTOR_FAR, d)

                    set rangeFactor = Math.Limit(rangeFactor, thistype.RANGE_FACTOR_CLOSE, thistype.RANGE_FACTOR_FAR)

                    call thistype.ENUM_GROUP2.AddUnit(target)

                    call caster.DamageUnitBySpell(target, damage * rangeFactor, true, false)

                    set target = thistype.ENUM_GROUP.FetchFirst()
                    exitwhen (target == NULL)
                endloop
            endif

            set User.TEMP = caster.Owner.Get()

            call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(targetX, targetY, Fireburst.THIS_SPELL.GetRange(level), thistype.TARGET_FILTER)

            call thistype.ENUM_GROUP.RemoveUnit(parent.target)

            loop
                set target = thistype.ENUM_GROUP2.FetchFirst()
                exitwhen (target == NULL)

                call thistype.ENUM_GROUP.RemoveUnit(target)
            endloop

            set target = thistype.ENUM_GROUP.GetNearestWithCollision(targetX, targetY)

            if ((target == NULL) or not caster.Buffs.Contains(FairyShape.DUMMY_BUFF)) then
                call parent.SubtractRef()

                call this.deallocate()

                return
            endif

            set this.damageExtra = thistype.DAMAGE[level] * FairyShape.FIREBURST_EXTRA_DMG_FACTOR[caster.Buffs.GetLevel(FairyShape.DUMMY_BUFF)]

            set dummyMissile = Missile.Create()

            call dummyMissile.Arc.SetByPerc(0.06)
            call dummyMissile.CollisionSize.Set(10.)
            call dummyMissile.Impact.SetAction(function thistype.ImpactExtra)
            call dummyMissile.SetData(this)
            call dummyMissile.Speed.Set(900.)
            call dummyMissile.Position.SetFromUnit(caster)

            call dummyMissile.GoToUnit.Start(target, null)

            call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_EXTRA_ID, 0.75)
        endmethod

        static method Start takes Fireburst parent returns nothing
            local Unit caster = parent.caster
            local DummyUnit dummyUnit = parent.dummyUnit
            local Unit target = parent.target

            local Missile dummyMissile = Missile.Create()
            local thistype this = thistype.allocate()

            set this.parent = parent

            call parent.AddRef()

            local real sourceX = dummyUnit.Position.X.Get()
            local real sourceY = dummyUnit.Position.Y.Get()

            local real angle = Math.AtanByDeltas(target.Position.Y.Get() - sourceY, target.Position.X.Get() - sourceX)

            call dummyUnit.Facing.Set(angle)

            call dummyMissile.Arc.SetByPerc(0.2)
            call dummyMissile.CollisionSize.Set(10.)
            call dummyMissile.Impact.SetAction(function thistype.Impact)
            call dummyMissile.SetData(this)
            call dummyMissile.Speed.Set(1000.)

//            call dummyMissile.Checkpoints.Create(dummyMissile.Position.X.Get(), dummyMissile.Position.Y.Get(), dummyMissile.Position.Z.Get() + caster.Outpact.Z.Get(true) * 2)

            call dummyMissile.GoToUnit.Start(target, null)

            call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 1.)

            call dummyMissile.Position.AddCollision(function thistype.Impact, thistype.COLLISION_FILTER)

            call dummyMissile.Position.Set(sourceX + thistype.LAUNCH_OFFSET * Math.Cos(angle), sourceY + thistype.LAUNCH_OFFSET * Math.Sin(angle), dummyUnit.Position.Z.Get())
        endmethod

        static method Init takes nothing returns nothing
            set thistype.COLLISION_FILTER = BoolExpr.GetFromFunction(function thistype.Collision_Conditions)
            set thistype.ENUM_GROUP = Group.Create()
            set thistype.ENUM_GROUP2 = Group.Create()
            set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)

            call UNIT.Ignited.NORMAL_BUFF.Variants.Add(thistype.IGNITION_BUFF)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Fireburst", "FIREBURST")
    //! runtextmacro GetKeyArray("KEY_ARRAY")

    Unit caster
    DummyUnit dummyUnit
    integer level
    Timer intervalTimer
    Unit target
    integer remainingMissilesToSpawn
    SpellInstance whichInstance
    real x
    real y

    boolean destroyed
    integer refs

    //! runtextmacro LinkToStruct("Fireburst", "Shot")

    method CheckForDestroy takes nothing returns nothing
        if not this.destroyed then
            return
        endif
        if (this.refs > 0) then
            return
        endif

        call this.deallocate()
    endmethod

    method SubtractRef takes nothing returns nothing
        set this.refs = this.refs - 1

        call this.CheckForDestroy()
    endmethod

    method AddRef takes nothing returns nothing
        set this.refs = this.refs + 1
    endmethod

    method Ending takes nothing returns nothing
        local DummyUnit dummyUnit = this.dummyUnit
        local Timer intervalTimer = this.intervalTimer
        local SpellInstance whichInstance = this.whichInstance

        call dummyUnit.Destroy()
        call intervalTimer.Destroy()

        if caster.Data.Integer.Table.Remove(KEY_ARRAY, this) then
            call caster.Buffs.Remove(thistype.DUMMY_BUFF)
        endif

        set this.destroyed = true

        call this.CheckForDestroy()
    endmethod

    static method EndingAll takes Unit caster returns nothing
        local integer iteration = caster.Data.Integer.Table.Count(KEY_ARRAY)

        loop
            exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

            local thistype this = caster.Data.Integer.Table.Get(KEY_ARRAY, iteration)

            call this.Ending()
        endloop
    endmethod

    method Interval takes nothing returns nothing
        call thistype(NULL).Shot.Start(this)

        if (this.remainingMissilesToSpawn == 1) then
            call this.Ending()
        else
            set this.remainingMissilesToSpawn = this.remainingMissilesToSpawn - 1
        endif
    endmethod

    timerMethod IntervalByTimer
        local thistype this = Timer.GetExpired().GetData()

        call this.Interval()
    endmethod

    timerMethod Delay
        local thistype this = Timer.GetExpired().GetData()

        call intervalTimer.Start(thistype.MISSILES_SPAWN_INTERVAL, true, function thistype.IntervalByTimer)

        call this.Interval()
    endmethod

    eventMethod Event_BuffLose
        local Unit caster = params.Unit.GetTrigger()

        call thistype.EndingAll(caster)
    endmethod

    eventMethod Event_BuffGain
        local Unit caster = params.Unit.GetTrigger()
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()
        local Unit target = params.Unit.GetTarget()
        local SpellInstance whichInstance = params.SpellInstance.GetTrigger()

        local real x = caster.Position.X.Get()
        local real y = caster.Position.Y.Get()
        local real z = caster.Position.Z.Get() + caster.Outpact.Z.Get(true) * 3

        local thistype this = thistype.allocate()

        local DummyUnit dummyUnit = DummyUnit.Create(thistype.DUMMY_UNIT_ID, x, y, z, whichInstance.GetAngle())
        local Timer intervalTimer = Timer.Create()

        set this.caster = caster
        set this.destroyed = false
        set this.dummyUnit = dummyUnit
        set this.intervalTimer = intervalTimer
        set this.level = level
        set this.refs = 0
        set this.remainingMissilesToSpawn = thistype.MISSILES_AMOUNT[level]
        set this.target = target
        set this.whichInstance = whichInstance
        set this.x = x
        set this.y = y
        call intervalTimer.SetData(this)

        call dummyUnit.CreateEffect(thistype.DUMMY_UNIT_SPECIAL_EFFECT_PATH, thistype.DUMMY_UNIT_SPECIAL_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).Destroy()

        call dummyUnit.Animation.Set(Animation.SPELL)
        call dummyUnit.PlayerColor.Set(caster.Color.Get())
        call dummyUnit.VertexColor.Set(0, 0, 0, 0)
        call dummyUnit.VertexColor.Timed.Add(255, 255, 255, 255, thistype.MISSILES_SPAWN_DELAY)

        if caster.Data.Integer.Table.Add(KEY_ARRAY, this) then
            call caster.Buffs.Add(thistype.DUMMY_BUFF, level)
        endif

        call intervalTimer.Start(thistype.MISSILES_SPAWN_DELAY, false, function thistype.Delay)
    endmethod

    initMethod Init of Spells_Purchasable
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))

        call thistype(NULL).Shot.Init()
    endmethod
endstruct