//! runtextmacro BaseStruct("TeleportScroll", "TELEPORT_SCROLL")
    static Group ENUM_GROUP
    //! runtextmacro GetKeyArray("KEY_ARRAY")
    static real MAX_OFFSET_SQUARE
    static Event TARGET_DEATH_EVENT
    static BoolExpr TARGET_FILTER
    static Item TARGET_ITEM
    static real TARGET_X
    static real TARGET_Y

    Unit caster
    Timer delayTimer
    Unit target
    UnitEffect targetEffect
    real targetOffsetX
    real targetOffsetY

    static method Event_BuffLose takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()

        local thistype this = caster

        local Timer delayTimer = this.delayTimer
        local UnitEffect targetEffect = this.targetEffect

        call delayTimer.Destroy()
        if (target.Data.Integer.Table.Remove(KEY_ARRAY, this)) then
            call target.Event.Remove(TARGET_DEATH_EVENT)
        endif
        call targetEffect.Destroy()
    endmethod

    static method EndingByTimer takes nothing returns nothing
        local thistype this = Timer.GetExpired().GetData()

        local Unit caster = this.caster
        local Unit target = this.target
        local real targetOffsetX = this.targetOffsetX
        local real targetOffsetY = this.targetOffsetY

        call caster.Buffs.Remove(thistype.DUMMY_BUFF)

        call caster.Effects.Create(thistype.CASTER_ARRIVAL_EFFECT_PATH, thistype.CASTER_ARRIVAL_EFFECT_ATTACH_POINT, EffectLevel.NORMAL)

        call caster.Position.SetWithCollision(target.Position.X.Get() + targetOffsetX, target.Position.Y.Get() + targetOffsetY)
    endmethod

    static method Event_EndCast takes nothing returns nothing
        call UNIT.Event.GetTrigger().Buffs.Remove(thistype.DUMMY_BUFF)
    endmethod

    static method Event_TargetDeath takes nothing returns nothing
        local Unit target = UNIT.Event.GetTrigger()
        local thistype this

        local integer iteration = target.Data.Integer.Table.Count(KEY_ARRAY)

        loop
            set this = target.Data.Integer.Table.Get(KEY_ARRAY, iteration)

            call this.caster.Buffs.Remove(thistype.DUMMY_BUFF)

            set iteration = iteration - 1
            exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
        endloop
    endmethod

    static method Conditions takes nothing returns boolean
        local Unit filterUnit = UNIT.Event.Native.GetFilter()

        if (filterUnit.Classes.Contains(UnitClass.DEAD)) then
            return false
        endif
        if (filterUnit.Classes.Contains(UnitClass.STRUCTURE) == false) then
            return false
        endif
        if (filterUnit.IsAllyOf(User.TEMP) == false) then
            return false
        endif

        return true
    endmethod

    static method Event_BuffGain takes nothing returns nothing
        local real angle
        local Unit caster = UNIT.Event.GetTrigger()
        local Timer delayTimer = Timer.Create()
        local real dX
        local real dY
        local Item targetItem = thistype.TARGET_ITEM
        local Unit targetUnit
        local real targetUnitX
        local real targetUnitY
        local real targetOffsetX
        local real targetOffsetY
        local real targetSpotX = thistype.TARGET_X
        local real targetSpotY = thistype.TARGET_Y

        local thistype this = caster

        if (targetItem == NULL) then
            set User.TEMP = caster.Owner.Get()

            call thistype.ENUM_GROUP.EnumUnits.All(thistype.TARGET_FILTER)

            set targetUnit = thistype.ENUM_GROUP.GetNearest(targetSpotX, targetSpotY)

            if (targetUnit == NULL) then
                return
            endif

            set targetUnitX = targetUnit.Position.X.Get()
            set targetUnitY = targetUnit.Position.Y.Get()

            set dX = targetSpotX - targetUnitX
            set dY = targetSpotY - targetUnitY

            if (Math.DistanceSquareByDeltas(dX, dY) > thistype.MAX_OFFSET_SQUARE) then
                set angle = Math.AtanByDeltas(dY, dX)

                set targetOffsetX = thistype.MAX_OFFSET * Math.Cos(angle)
                set targetOffsetY = thistype.MAX_OFFSET * Math.Sin(angle)
            else
                set targetOffsetX = targetSpotX - targetUnitX
                set targetOffsetY = targetSpotY - targetUnitY
            endif
        else
            if (Meteorite.THIS_UNIT == NULL) then
                return
            endif

            if (Meteorite.THIS_UNIT.Classes.Contains(UnitClass.DEAD)) then
                return
            endif

            set targetOffsetX = 0.
            set targetOffsetY = 0.
            set targetUnit = Meteorite.THIS_UNIT
        endif

        set this.caster = caster
        set this.delayTimer = delayTimer
        set this.target = targetUnit
        set this.targetEffect = targetUnit.Effects.Create(thistype.TARGET_EFFECT_PATH, thistype.TARGET_EFFECT_ATTACH_POINT, EffectLevel.NORMAL)
        set this.targetOffsetX = targetOffsetX
        set this.targetOffsetY = targetOffsetY
        call delayTimer.SetData(this)
        if (targetUnit.Data.Integer.Table.Add(KEY_ARRAY, this)) then
            call targetUnit.Event.Add(TARGET_DEATH_EVENT)
        endif

        call delayTimer.Start(DELAY, false, function thistype.EndingByTimer)
    endmethod

    static method Event_SpellEffect takes nothing returns nothing
        local Unit caster = UNIT.Event.GetTrigger()

        set thistype.TARGET_ITEM = ITEM.Event.GetTarget()
        set thistype.TARGET_X = SPOT.Event.GetTargetX()
        set thistype.TARGET_Y = SPOT.Event.GetTargetY()

        call caster.Buffs.AddFresh(thistype.DUMMY_BUFF, SPELL.Event.GetLevel())
    endmethod

    static method Init takes nothing returns nothing
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.MAX_OFFSET_SQUARE = thistype.MAX_OFFSET * thistype.MAX_OFFSET
        set thistype.TARGET_DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_TargetDeath)
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Finish.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_EndCast))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))
    endmethod
endstruct