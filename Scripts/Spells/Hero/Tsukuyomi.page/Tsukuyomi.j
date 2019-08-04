//! runtextmacro Folder("Tsukuyomi")
    //! runtextmacro Struct("Missile")
        Unit caster
        integer level
        real targetX
        real targetY

        eventMethod Impact
            local Missile dummyMissile = params.Missile.GetTrigger()

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
            local thistype this = thistype.allocate()

			local Missile dummyMissile = Missile.Create()

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
        eventMethod Event_SpellEffect
            local Unit caster = params.Unit.GetTrigger()
            local real targetX = params.Spot.GetTargetX()
            local real targetY = params.Spot.GetTargetY()

            local Tsukuyomi parent = caster

            call parent.movingDummyUnit.Order.PointTarget(Order.MOVE, targetX, targetY)
        endmethod

        static method Init takes nothing returns nothing
            call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
        endmethod
    endstruct

    //! runtextmacro Struct("Target")
    	static Event ENDING_EVENT
        static Event START_EVENT

		eventMethod Event_Ending
			local Aura aura = params.Aura.GetTrigger()
			local Unit target = params.Unit.GetTrigger()

			local Tsukuyomi parent = aura.GetData()

			call target.Buffs.Subtract(thistype.DUMMY_BUFF)
		endmethod

		eventMethod Event_Start
			local Aura aura = params.Aura.GetTrigger()
			local Unit target = params.Unit.GetTrigger()

			local Unit caster = aura.GetCaster()
			local Tsukuyomi parent = aura.GetData()

			local integer level = parent.level

			call target.Buffs.Add(thistype.DUMMY_BUFF, level)
		endmethod

        static method Init takes nothing returns nothing
            set thistype.ENDING_EVENT = Event.Create(AURA.Target.ENDING_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Ending)
            set thistype.START_EVENT = Event.Create(AURA.Target.START_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Start)
            call UNIT.Eclipse.NORMAL_BUFF.Variants.Add(thistype.DUMMY_BUFF)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Tsukuyomi", "TSUKUYOMI")
    static Group ENUM_GROUP
    static BoolExpr TARGET_FILTER
    static real TARGET_X
    static real TARGET_Y

    Aura aura
    DummyUnit dummyUnit
    DummyUnit dummyUnit2
    Timer intervalTimer
    integer level
    DummyUnit movingDummyUnit
    real pullFactor
    real stolenMana
    real targetX
    real targetY

    //! runtextmacro LinkToStruct("Tsukuyomi", "Missile")
    //! runtextmacro LinkToStruct("Tsukuyomi", "Relocate")
    //! runtextmacro LinkToStruct("Tsukuyomi", "Target")

    condMethod Conditions
        local Unit target = UNIT.Event.Native.GetFilter()

        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if target.Classes.Contains(UnitClass.STRUCTURE) then
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

    timerMethod Interval
        local thistype this = Timer.GetExpired().GetData()

        local Unit caster = this

        local DummyUnit movingDummyUnit = this.dummyUnit

        local real x = movingDummyUnit.Position.X.GetNative()
        local real y = movingDummyUnit.Position.Y.GetNative()

        local User casterOwner = caster.Owner.Get()

        set User.TEMP = casterOwner

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, this.aura.GetAreaRange(), thistype.TARGET_FILTER)

        local Unit target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            local real pullFactor = this.pullFactor
            local real stolenManaAll = 0.
            local real stolenManaMax = this.stolenMana

            loop
                call target.Position.Timed.AddSpeedDirection(target.Movement.Speed.Get() * pullFactor, Math.AtanByDeltas(y - target.Position.Y.Get(), x - target.Position.X.Get()), thistype.INTERVAL)

                if target.IsAllyOf(casterOwner) then
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

    eventMethod Event_BuffLose
        local Unit target = params.Unit.GetTrigger()

        local thistype this = target

		local Aura aura = this.aura
        local DummyUnit dummyUnit = this.dummyUnit
        local DummyUnit dummyUnit2 = this.dummyUnit2
        local Timer intervalTimer = this.intervalTimer

		call aura.Destroy()
        call dummyUnit.DestroyInstantly()
        call dummyUnit2.Destroy()
        call intervalTimer.Destroy()

        call HeroSpell.AddToUnit(thistype.THIS_SPELL, target)
    endmethod

    eventMethod Event_BuffGain
        local integer level = params.Buff.GetLevel()
        local Unit target = params.Unit.GetTrigger()
        local real targetX = thistype.TARGET_X
        local real targetY = thistype.TARGET_Y
        local real targetZ = Spot.GetHeight(targetX, targetY)

		local real areaRange = thistype.THIS_SPELL.GetAreaRange(level)

        local thistype this = target

		local Aura aura = Aura.Create(target)
        local DummyUnit dummyUnit = DummyUnit.Create(thistype.DUMMY_UNIT_ID, targetX, targetY, targetZ - 80., 0.)
        local DummyUnit dummyUnit2 = DummyUnit.Create(thistype.DUMMY_UNIT2_ID, targetX, targetY, targetZ + 150., 0.)
        local Timer intervalTimer = Timer.Create()
        local DummyUnit movingDummyUnit = DummyUnit.Create(thistype.MOVING_DUMMY_UNIT_ID, targetX, targetY, targetZ, 0.)

        set this.aura = aura
        set this.dummyUnit = dummyUnit
        set this.dummyUnit2 = dummyUnit2
        set this.intervalTimer = intervalTimer
        set this.level = level
        set this.movingDummyUnit = movingDummyUnit
        set this.pullFactor = thistype.PULL_FACTOR[level]
        set this.stolenMana = thistype.STOLEN_MANA[level]
        set this.targetX = targetX
        set this.targetY = targetY
        call aura.SetData(this)
        call intervalTimer.SetData(this)

		call aura.SetAreaRange(areaRange)
        call aura.SetTargetFilter(thistype.TARGET_FILTER)

		call aura.Event.Add(thistype(NULL).Target.ENDING_EVENT)
		call aura.Event.Add(thistype(NULL).Target.START_EVENT)

		call aura.Enable()

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

        call HeroSpell.AddToUnit(thistype(NULL).Relocate.THIS_SPELL, target)
    endmethod

    eventMethod Event_SpellEffect
        call thistype(NULL).Missile.Start(params.Unit.GetTrigger(), params.Spell.GetLevel(), params.Spot.GetTargetX(), params.Spot.GetTargetY())
    endmethod

    initMethod Init of Spells_Hero
    	set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        local integer iteration = thistype.THIS_SPELL.GetLevelsAmount()

        loop
            set thistype.STOLEN_MANA[iteration] = thistype.STOLEN_MANA[iteration] * thistype.INTERVAL

            set iteration = iteration - 1
            exitwhen (iteration < 1)
        endloop

        call thistype(NULL).Target.Init()

        call thistype(NULL).Relocate.Init()
    endmethod
endstruct