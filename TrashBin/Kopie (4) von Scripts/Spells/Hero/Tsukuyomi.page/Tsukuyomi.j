//! runtextmacro Folder("Tsukuyomi")
    //! runtextmacro Struct("Missile")
        Unit caster
        integer level
        real targetX
        real targetY

        static method Impact takes nothing returns nothing
            local Missile dummyMissile = MISSILE.Event.GetTrigger()

            local thistype this = dummyMissile.GetData()

            local Unit caster = this.caster
            local integer level = this.level
            local real targetX = this.targetX
            local real targetY = this.targetY

            call this.deallocate()
            call dummyMissile.Destroy()

            set Tsukuyomi.TARGET_X = targetX
            set Tsukuyomi.TARGET_Y = targetY

            call caster.Buffs.Timed.Start(Tsukuyomi.DUMMY_BUFF, level, Tsukuyomi.DURATION[level])
        endmethod

        static method Start takes Unit caster, integer level, real targetX, real targetY returns nothing
            local Missile dummyMissile = Missile.Create()
            local thistype this = thistype.allocate()

            set this.caster = caster
            set this.level = level
            set this.targetX = targetX
            set this.targetY = targetY

            call dummyMissile.Acceleration.Set(2000.)
            call dummyMissile.Arc.SetByPerc(0.2)
            call dummyMissile.CollisionSize.Set(48.)
            call dummyMissile.DummyUnit.Create(thistype.DUMMY_UNIT_ID, 1.)
            call dummyMissile.Impact.SetAction(function thistype.Impact)
            call dummyMissile.SetData(this)
            call dummyMissile.Speed.Set(500.)
            call dummyMissile.Position.SetFromUnit(caster)

            call dummyMissile.GoToSpot.Start(targetX, targetY, Spot.GetHeight(targetX, targetY))
        endmethod
    endstruct

    //! runtextmacro Struct("Relocate")
        static method Event_SpellEffect takes nothing returns nothing
            local Unit caster = UNIT.Event.GetTrigger()
            local real targetX = SPOT.Event.GetTargetX()
            local real targetY = SPOT.Event.GetTargetY()

            local Tsukuyomi parent = caster

            call parent.movingDummyUnit.Order.PointTarget(Order.MOVE, targetX, targetY)
        endmethod

        static method Init takes nothing returns nothing
            call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
        endmethod
    endstruct

    //! runtextmacro Struct("Target")
        static Event DEATH_EVENT
        //! runtextmacro GetKeyArray("KEY_ARRAY")
        //! runtextmacro GetKeyArray("KEY_ARRAY_DETAIL")

        Tsukuyomi parent

        method Ending takes Tsukuyomi parent, Unit target, Group targetGroup returns nothing
        call BJDebugMsg("ending with "+I2S(target.Data.Integer.Table.Count(KEY_ARRAY))+" on "+target.GetName())
            if (target.Data.Integer.Table.Remove(KEY_ARRAY, this)) then
            call BJDebugMsg("ending")
                call target.Event.Remove(DEATH_EVENT)

                call target.Eclipse.AddTimed(thistype.DURATION)

                call target.Eclipse.Subtract()
            endif
            call target.Data.Integer.Remove(KEY_ARRAY_DETAIL + parent)
            call targetGroup.RemoveUnit(target)
        endmethod

        method EndingByParent takes Unit target, Group targetGroup returns nothing
            local Tsukuyomi parent = this

            set this = target.Data.Integer.Get(KEY_ARRAY_DETAIL + parent)

            call this.Ending(parent, target, targetGroup)
        endmethod

        static method Event_Death takes nothing returns nothing
            local Tsukuyomi parent
            local Unit target = UNIT.Event.GetTrigger()
            local thistype this

            local integer iteration = target.Data.Integer.Table.Count(KEY_ARRAY)

            loop
                set this = target.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                set parent = this.parent

                call this.Ending(parent, target, parent.targetGroup)

                set iteration = iteration - 1
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
            endloop
        endmethod

        method Start takes integer level, Unit target, Group targetGroup returns nothing
            local Tsukuyomi parent = this

            set this = thistype.allocate()

            set this.parent = parent

            if (target.Data.Integer.Table.Add(KEY_ARRAY, this)) then
                call target.Event.Add(DEATH_EVENT)

                call target.Eclipse.Add()
            endif
            call target.Data.Integer.Set(KEY_ARRAY_DETAIL + parent, this)
            call targetGroup.AddUnit(target)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Death)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Tsukuyomi", "TSUKUYOMI")
    static Group ENUM_GROUP
    static Group ENUM_GROUP2
    static BoolExpr TARGET_FILTER
    static real TARGET_X
    static real TARGET_Y
    static constant real UPDATE_TIME = 0.5

    real areaRange
    DummyUnit dummyUnit
    DummyUnit dummyUnit2
    Timer intervalTimer
    integer level
    DummyUnit movingDummyUnit
    real pullFactor
    real stolenMana
    Group targetGroup
    real targetX
    real targetY
    Timer updateTimer

    //! runtextmacro LinkToStruct("Tsukuyomi", "Missile")
    //! runtextmacro LinkToStruct("Tsukuyomi", "Relocate")
    //! runtextmacro LinkToStruct("Tsukuyomi", "Target")

    static method Conditions takes nothing returns boolean
        local Unit target = UNIT.Event.Native.GetFilter()

        if (target.Classes.Contains(UnitClass.DEAD)) then
            return false
        endif
        if (target.Classes.Contains(UnitClass.STRUCTURE)) then
            return false
        endif
        if (target.IsAllyOf(User.TEMP)) then
            return false
        endif
        if (target.MagicImmunity.Try()) then
            return false
        endif

        return true
    endmethod

    static method Update takes nothing returns nothing
        local integer level
        local Unit target
        local thistype this = Timer.GetExpired().GetData()

        local Unit caster = this
        local DummyUnit movingDummyUnit = this.movingDummyUnit
        local Group targetGroup = this.targetGroup

        local real x = movingDummyUnit.Position.X.GetNative()
        local real y = movingDummyUnit.Position.Y.GetNative()

        set User.TEMP = caster.Owner.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, this.areaRange, thistype.TARGET_FILTER)

        set target = targetGroup.GetFirst()

        if (target != NULL) then
            loop
                if (thistype.ENUM_GROUP.ContainsUnit(target)) then
                    call targetGroup.RemoveUnit(target)

                    call thistype.ENUM_GROUP.RemoveUnit(target)
                    call thistype.ENUM_GROUP2.AddUnit(target)
                else
                    call this.Target.EndingByParent(target, targetGroup)
                endif

                set target = targetGroup.GetFirst()
                exitwhen (target == NULL)
            endloop

            call targetGroup.AddGroupClear(thistype.ENUM_GROUP2)
        endif

        set target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            set level = this.level

            loop
                call this.Target.Start(level, target, targetGroup)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
    endmethod

    static method Interval takes nothing returns nothing
        local real absorbedMana
        local real pullFactor
        local real stolenManaAll
        local real stolenManaMax
        local Unit target
        local thistype this = Timer.GetExpired().GetData()

        local Unit caster = this

        local DummyUnit movingDummyUnit = this.dummyUnit

        local real x = movingDummyUnit.Position.X.GetNative()
        local real y = movingDummyUnit.Position.Y.GetNative()

        local User casterOwner = caster.Owner.Get()

        set User.TEMP = casterOwner

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, this.areaRange, thistype.TARGET_FILTER)

        set target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            set pullFactor = this.pullFactor
            set stolenManaAll = 0.
            set stolenManaMax = this.stolenMana

            loop
                call target.Position.Timed.AddSpeedDirection(target.Movement.Speed.Get() * pullFactor, Math.AtanByDeltas(y - target.Position.Y.Get(), x - target.Position.X.Get()), thistype.INTERVAL)

                if (target.IsAllyOf(casterOwner)) then
                    call target.Mana.Subtract(stolenManaMax)
                else
                    set stolenMana = Math.Min(target.Mana.Get(), stolenManaMax)

                    call caster.BurnManaBySpell(target, stolenMana)

                    set stolenManaAll = stolenManaAll + stolenMana
                endif

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop

            if (stolenManaAll > 0.) then
                call caster.HealManaBySpell(caster, stolenManaAll * thistype.STOLEN_MANA_ABSORPTION_FACTOR)
            endif
        endif
    endmethod

    method ClearTargetGroup takes Group targetGroup returns nothing
        local Unit target

        loop
            set target = targetGroup.GetFirst()
            exitwhen (target == NULL)

            call this.Target.EndingByParent(target, targetGroup)
        endloop
    endmethod

    static method Event_BuffLose takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()

        local thistype this = target

        local DummyUnit dummyUnit = this.dummyUnit
        local DummyUnit dummyUnit2 = this.dummyUnit2
        local Timer intervalTimer = this.intervalTimer
        local Group targetGroup = this.targetGroup
        local Timer updateTimer = this.updateTimer

        call this.ClearTargetGroup(targetGroup)

        call dummyUnit.DestroyInstantly()
        call dummyUnit2.Destroy()
        call intervalTimer.Destroy()
        call targetGroup.Destroy()
        call updateTimer.Destroy()

        call HeroSpell.AddToUnit(thistype.THIS_SPELL, target)
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        local Timer intervalTimer = Timer.Create()
        local integer level = BUFF.Event.GetLevel()
        local Unit target = UNIT.Event.GetTrigger()
        local real targetX = thistype.TARGET_X
        local real targetY = thistype.TARGET_Y
        local Timer updateTimer = Timer.Create()

        local real areaRange = thistype.THIS_SPELL.GetAreaRange(level)
        local real targetZ = Spot.GetHeight(targetX, targetY)
        local thistype this = target

        local DummyUnit dummyUnit = DummyUnit.Create(thistype.DUMMY_UNIT_ID, targetX, targetY, targetZ - 80., 0.)
        local DummyUnit dummyUnit2 = DummyUnit.Create(thistype.DUMMY_UNIT2_ID, targetX, targetY, targetZ + 150., 0.)
        local DummyUnit movingDummyUnit = DummyUnit.Create(thistype.MOVING_DUMMY_UNIT_ID, targetX, targetY, targetZ, 0.)

        set this.areaRange = thistype.THIS_SPELL.GetAreaRange(level)
        set this.dummyUnit = dummyUnit
        set this.dummyUnit2 = dummyUnit2
        set this.intervalTimer = intervalTimer
        set this.level = level
        set this.movingDummyUnit = movingDummyUnit
        set this.pullFactor = thistype.PULL_FACTOR[level]
        set this.stolenMana = thistype.STOLEN_MANA[level]
        set this.targetGroup = Group.Create()
        set this.targetX = targetX
        set this.targetY = targetY
        set this.updateTimer = updateTimer
        call intervalTimer.SetData(this)
        call updateTimer.SetData(this)

        call dummyUnit.FollowDummyUnit.Start(movingDummyUnit, false, 0., 0., -80.)
        call dummyUnit.Scale.Set(0.)
        call dummyUnit.Scale.Timed.Add(areaRange * 5 / (3 * 128.), 0.25)
        call dummyUnit2.FollowDummyUnit.Start(movingDummyUnit, false, 0., 0., 150.)
        call dummyUnit2.Scale.Set(0.)
        call dummyUnit2.Scale.Timed.Add(areaRange * 8 / (3 * 128.), 0.25)
        if (target.Type.Get() == UnitType.JOTA) then
            call dummyUnit.VertexColor.Set(0., 200., 255., 200.)
            call dummyUnit2.VertexColor.Set(0., 200., 200., 255.)
        elseif (target.Type.Get() == UnitType.LIZZY) then
            call dummyUnit.VertexColor.Set(255., 255., 255., 200.)
        elseif (target.Type.Get() == UnitType.TAJRAN) then
            call dummyUnit.VertexColor.Set(63., 255., 0., 200.)
            call dummyUnit2.VertexColor.Set(63., 255., 0., 255.)
        endif
        call movingDummyUnit.SetMoveSpeed(thistype(NULL).Relocate.SPEED)
        call movingDummyUnit.SetMoveWindow(1.)
        call movingDummyUnit.SetTurnSpeed(Math.FULL_ANGLE)

        call intervalTimer.Start(thistype.INTERVAL, true, function thistype.Interval)
        call updateTimer.Start(thistype.UPDATE_TIME, true, function thistype.Update)

        call HeroSpell.AddToUnit(thistype(NULL).Relocate.THIS_SPELL, target)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        call thistype(NULL).Missile.Start(UNIT.Event.GetTrigger(), SPELL.Event.GetLevel(), SPOT.Event.GetTargetX(), SPOT.Event.GetTargetY())
    endmethod

    static method Init takes nothing returns nothing
        local integer iteration

        set thistype.ENUM_GROUP = Group.Create()
        set thistype.ENUM_GROUP2 = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

            set iteration = thistype.THIS_SPELL.GetLevelsAmount()

            loop
                set thistype.STOLEN_MANA[iteration] = thistype.STOLEN_MANA[iteration] * thistype.INTERVAL

                set iteration = iteration - 1
                exitwhen (iteration < 1)
            endloop

        call thistype(NULL).Target.Init()

        call thistype(NULL).Relocate.Init()
    endmethod
endstruct