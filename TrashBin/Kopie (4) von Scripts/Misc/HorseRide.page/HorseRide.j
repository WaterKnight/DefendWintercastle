//! runtextmacro Folder("HorseRide")
    //! runtextmacro Struct("Target")
        DummyUnit horse
        DummyUnitEffect horseEffect
        HorseRide parent

        static method GetHorse takes Unit target returns DummyUnit
            local thistype this = target

            return this.horse
        endmethod

        static method Event_BuffLose takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            local thistype this = target

            local DummyUnit horse = this.horse
            local DummyUnitEffect horseEffect = this.horseEffect

            call Camera.UnlockFromUnit(target.Owner.Get())
            call horse.Order.Immediate(Order.STOP)
            call horse.VertexColor.Timed.Subtract(0., 0., 0., 255., FADE_OUT)
            call horseEffect.Destroy()
            call target.Effects.Create(thistype.ENDING_EFFECT_PATH, thistype.ENDING_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()
            call target.Transport.Subtract()

            call horse.DestroyTimed.Start(thistype.FADE_OUT)

            call this.parent.RemoveUnit(target)
        endmethod

        static method DoEffect takes Unit target returns nothing
            local thistype this = target

            local DummyUnit horse = this.horse

            local real angle = horse.Facing.Get()
            local real x = horse.Position.X.GetNative()
            local real y = horse.Position.Y.GetNative()
            local real z = horse.Position.Z.GetNative()

            local DummyUnit dummyUnit = DummyUnit.Create(thistype.HORSE_ID, x + thistype.DUMMY_UNIT_OFFSET * Math.Cos(angle), y + thistype.DUMMY_UNIT_OFFSET * Math.Sin(angle), z, angle)

            call dummyUnit.Order.PointTarget(Order.MOVE, x, y)
            call dummyUnit.VertexColor.Set(255., 255., 255., 191.)
            call dummyUnit.VertexColor.Timed.Subtract(255., 255., 255., 191., thistype.DUMMY_UNIT_DURATION)

            call dummyUnit.DestroyTimed.Start(thistype.DUMMY_UNIT_DURATION)
        endmethod

        static method Update takes Unit target returns nothing
            local real dismountAngle
            local thistype this = target

            local DummyUnit horse = this.horse
            local Rectangle targetRect = this.parent.targetRect

            local real x = horse.Position.X.GetNative()
            local real y = horse.Position.Y.GetNative()

            call target.Transport.SetPosition(x, y)

            if (targetRect.ContainsCoords(x, y)) then
                set dismountAngle = horse.Facing.Get() - Math.PI

                call target.Buffs.Remove(thistype.DUMMY_BUFF)

                call target.Position.SetWithCollision(x + thistype.DISMOUNT_OFFSET * Math.Cos(dismountAngle), y + thistype.DISMOUNT_OFFSET * Math.Sin(dismountAngle))
            elseif (horse.Order.GetNative() == NULL) then
                call horse.Order.PointTarget(Order.MOVE, targetRect.GetCenterX(), targetRect.GetCenterY())
            endif
        endmethod

        static method Event_BuffGain takes nothing returns nothing
            local Unit target = UNIT.Event.GetTrigger()

            local DummyUnit horse = DummyUnit.Create(thistype.HORSE_ID, target.Position.X.Get(), target.Position.Y.Get(), target.Position.Z.Get(), Math.RandomAngle())
            local User targetOwner = target.Owner.Get()
            local thistype this = target

            set this.horse = horse
            set this.horseEffect = DummyUnitEffect.Create(horse, thistype.HORSE_EFFECT_PATH, thistype.HORSE_EFFECT_ATTACH_POINT, EffectLevel.LOW)
            set this.parent = HorseRide.TEMP

            call Camera.LockToDummyUnit(targetOwner, horse)
            call DummyUnitEffect.Create(horse, thistype.START_EFFECT_PATH, thistype.START_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()
            call horse.Owner.Set(targetOwner)
            call horse.SetMoveSpeed(522.)
            call target.Transport.Add()
        endmethod

        method Start takes Unit target returns nothing
            set HorseRide.TEMP = this

            call target.Buffs.AddFresh(thistype.DUMMY_BUFF, 1)
        endmethod

        static method Init takes nothing returns nothing
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("HorseRide", "HORSE_RIDE")
    static constant real DELAY = 2.
    static group DUMMY_GROUP
    static constant real EFFECT_INTERVAL = 0.625
    static thistype TEMP
    static constant real UPDATE_TIME = 1.

    static Rectangle ARTIFACT_INTRO_TARGET
    static Rectangle LEFT_TAVERN
    static Rectangle RIGHT_TAVERN

    Timer effectTimer
    Group targetGroup
    Rectangle targetRect
    Timer updateTimer

    //! runtextmacro LinkToStruct("HorseRide", "Target")

    method Ending takes nothing returns nothing
        local Timer effectTimer = this.effectTimer
        local Group targetGroup = this.targetGroup
        local Timer updateTimer = this.updateTimer

        call effectTimer.Destroy()
        call targetGroup.Destroy()
        call updateTimer.Destroy()
    endmethod

    method RemoveUnit takes Unit target returns nothing
        call targetGroup.RemoveUnit(target)

        if (targetGroup.IsEmpty()) then
            call this.Ending()
        endif
    endmethod

    static method DoEffectTargets takes nothing returns nothing
        call thistype(NULL).Target.DoEffect(UNIT.Event.Native.GetEnum())
    endmethod

    static method DoEffect takes nothing returns nothing
        local thistype this = Timer.GetExpired().GetData()

        call this.targetGroup.Do(function thistype.DoEffectTargets)
    endmethod

    static method UpdateTargets takes nothing returns nothing
        call thistype(NULL).Target.Update(UNIT.Event.Native.GetEnum())
    endmethod

    static method Update takes nothing returns nothing
        local thistype this = Timer.GetExpired().GetData()

        call this.targetGroup.Do(function thistype.UpdateTargets)
    endmethod

    static method GetHorses takes nothing returns nothing
        call GroupAddUnit(thistype.DUMMY_GROUP, thistype(NULL).Target.GetHorse(UNIT.Event.Native.GetEnum()).self)
    endmethod

    static method Delay takes nothing returns nothing
        local Timer updateTimer = Timer.GetExpired()

        local thistype this = updateTimer.GetData()

        local Group targetGroup = this.targetGroup
        local Rectangle targetRect = this.targetRect

        call GroupClear(thistype.DUMMY_GROUP)

        call targetGroup.Do(function thistype.GetHorses)

        call GroupPointOrderById(thistype.DUMMY_GROUP, Order.MOVE.self, targetRect.GetCenterX(), targetRect.GetCenterY())

        call this.effectTimer.Start(thistype.EFFECT_INTERVAL, true, function thistype.DoEffect)
        call updateTimer.Start(thistype.UPDATE_TIME, true, function thistype.Update)
    endmethod

    static method AddTargets takes nothing returns nothing
        call thistype.TEMP.Target.Start(UNIT.Event.Native.GetEnum())
    endmethod

    static method Start takes Group targetGroup, Rectangle targetRect returns nothing
        local Timer effectTimer = Timer.Create()
        local thistype this = targetGroup
        local Timer updateTimer = Timer.Create()

        set this.effectTimer = effectTimer
        set this.targetGroup = targetGroup
        set this.targetRect = targetRect
        set this.updateTimer = updateTimer
        call effectTimer.SetData(this)
        call updateTimer.SetData(this)

        call updateTimer.Start(thistype.DELAY, true, function thistype.Delay)

        set thistype.TEMP = this

        call targetGroup.Do(function thistype.AddTargets)
    endmethod

    static method AddHero takes nothing returns nothing
        call Group.TEMP.AddUnit(UNIT.Event.Native.GetEnum())
    endmethod

    static method Step2 takes nothing returns nothing
        set Group.TEMP = Group.Create()

        call USER.Hero.EnumAll(function thistype.AddHero, false)

        call thistype.Start(Group.TEMP, thistype.ARTIFACT_INTRO_TARGET)
    endmethod

    static method StartIntro takes nothing returns nothing
        call Game.DisplaySpeechFromUnit(Sebastian.THIS_UNIT, "Sire, Victor has just sent a message that the weapons you ordered have been completed.", 2.)
        call Game.DisplaySpeechFromUnit(Unit.DRAKUL, "Good. Saddle the horses!", 2.)
        call Game.DisplaySpeechFromUnit(Unit.DRAKUL, "Rosa, you delay them until we return.", 2.)
        call Game.DisplaySpeechFromUnit(Unit.ROSA, "At your command.", 2.)

        call Timer.Create().Start(8., false, function thistype.Step2)
    endmethod

    static method Event_Sell takes nothing returns nothing
        local boolean right = (UNIT.Event.GetTrigger() == Unit.GetFromSelf(gg_unit_uRiS_0044))
        local Group targetGroup = Group.Create()

        local Unit target = UNIT.Event.GetTarget()

        call targetGroup.AddUnit(target)

        if right then
            call thistype.Start(targetGroup, thistype.RIGHT_TAVERN)
        else
            call thistype.Start(targetGroup, thistype.LEFT_TAVERN)
        endif
    endmethod

    static method Init takes nothing returns nothing
        set thistype.ARTIFACT_INTRO_TARGET = Rectangle.CreateFromSelf(gg_rct_ArtifactIntroTarget)
        set thistype.DUMMY_GROUP = CreateGroup()
        set thistype.LEFT_TAVERN = Rectangle.CreateFromSelf(gg_rct_LeftTavern)
        set thistype.RIGHT_TAVERN = Rectangle.CreateFromSelf(gg_rct_RightTavern)
        call thistype.SHOP_ITEM.Event.Add(Event.Create(UNIT.Items.Events.Sell.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_Sell))

        call thistype(NULL).Target.Init()
    endmethod
endstruct