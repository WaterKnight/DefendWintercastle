//! runtextmacro BaseStruct("TeleportScroll", "TELEPORT_SCROLL")
    static Group ENUM_GROUP
    //! runtextmacro GetKeyArray("KEY_ARRAY")
    static real MAX_OFFSET_SQUARE
    static Event TARGET_DEATH_EVENT
    static BoolExpr TARGET_FILTER
    static Item TARGET_ITEM
    static real TARGET_X
    static real TARGET_Y

    Unit target
    UnitEffect targetEffect
    real targetOffsetX
    real targetOffsetY

    eventMethod Event_TargetDeath
        local Unit target = params.Unit.GetTrigger()

        local integer iteration = target.Data.Integer.Table.Count(KEY_ARRAY)

        loop
            local thistype this = target.Data.Integer.Table.Get(KEY_ARRAY, iteration)

            local Unit caster = this

            call caster.Buffs.Remove(thistype.DUMMY_BUFF)

            set iteration = iteration - 1
            exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
        endloop
    endmethod

    condMethod Conditions
        local Unit target = UNIT.Event.Native.GetFilter()

        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if not target.Classes.Contains(UnitClass.STRUCTURE) then
            return false
        endif
        if not target.IsAllyOf(User.TEMP) then
            return false
        endif

        return true
    endmethod

    eventMethod Event_BuffLose
        local Unit caster = params.Unit.GetTrigger()

        local thistype this = caster

        local Unit target = this.target
        local UnitEffect targetEffect = this.targetEffect

        if target.Data.Integer.Table.Remove(KEY_ARRAY, this) then
            call target.Event.Remove(TARGET_DEATH_EVENT)
        endif
        call targetEffect.Destroy()

        call caster.Abilities.Remove(Invulnerability.THIS_SPELL)
    endmethod

    eventMethod Event_BuffGain
        local Unit caster = params.Unit.GetTrigger()
        local Item targetItem = thistype.TARGET_ITEM
        local real targetSpotX = thistype.TARGET_X
        local real targetSpotY = thistype.TARGET_Y

        local thistype this = caster

		local Unit targetUnit

		local real targetOffsetX
		local real targetOffsetY

        if (targetItem == NULL) then
            set User.TEMP = caster.Owner.Get()

            call thistype.ENUM_GROUP.EnumUnits.All(thistype.TARGET_FILTER)

            set targetUnit = thistype.ENUM_GROUP.GetNearestWithCollision(targetSpotX, targetSpotY)

            if (targetUnit == NULL) then
                return
            endif

            local real targetUnitX = targetUnit.Position.X.Get()
            local real targetUnitY = targetUnit.Position.Y.Get()

            local real dX = targetSpotX - targetUnitX
            local real dY = targetSpotY - targetUnitY

            if (Math.DistanceSquareByDeltas(dX, dY) > thistype.MAX_OFFSET_SQUARE) then
                local real angle = Math.AtanByDeltas(dY, dX)

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

            if Meteorite.THIS_UNIT.Classes.Contains(UnitClass.DEAD) then
                return
            endif

            set targetOffsetX = 0.
            set targetOffsetY = 0.
            set targetUnit = Meteorite.THIS_UNIT
        endif

        set this.target = targetUnit
        set this.targetEffect = targetUnit.Effects.Create(thistype.TARGET_EFFECT_PATH, thistype.TARGET_EFFECT_ATTACH_POINT, EffectLevel.NORMAL)
        set this.targetOffsetX = targetOffsetX
        set this.targetOffsetY = targetOffsetY
        if targetUnit.Data.Integer.Table.Add(KEY_ARRAY, this) then
            call targetUnit.Event.Add(TARGET_DEATH_EVENT)
        endif

        call caster.Abilities.Add(Invulnerability.THIS_SPELL)
    endmethod

    eventMethod Event_EndCast
        local Unit caster = params.Unit.GetTrigger()
        local boolean success = params.Spell.IsChannelComplete()

        local thistype this = caster

        local Unit target = this.target
        local real targetOffsetX = this.targetOffsetX
        local real targetOffsetY = this.targetOffsetY

        call caster.Buffs.Remove(thistype.DUMMY_BUFF)

        if success then
            call caster.Effects.Create(thistype.CASTER_ARRIVAL_EFFECT_PATH, thistype.CASTER_ARRIVAL_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).DestroyTimed.Start(2.)

            call caster.Position.SetWithCollision(target.Position.X.Get() + targetOffsetX, target.Position.Y.Get() + targetOffsetY)
        endif
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()

        set thistype.TARGET_ITEM = params.Item.GetTarget()
        set thistype.TARGET_X = params.Spot.GetTargetX()
        set thistype.TARGET_Y = params.Spot.GetTargetY()

        call caster.Buffs.AddFresh(thistype.DUMMY_BUFF, params.Spell.GetLevel())
    endmethod

    initMethod Init of Items_Misc
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