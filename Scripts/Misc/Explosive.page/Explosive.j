//! runtextmacro BaseStruct("Explosive", "EXPLOSIVE")
    static constant real AREA_RANGE = 300.
    static Event CREATE_EVENT
    static constant real DAMAGE = 200.
    static constant real DELAY = 0.35
    static Event DEATH_EVENT
    static Group ENUM_GROUP
    //! runtextmacro GetKey("KEY")
    static constant real MAX_DAMAGE = 900.
    static BoolExpr TARGET_FILTER

    real x
    real y

    condMethod Conditions
        local Unit target = UNIT.Event.Native.GetFilter()

        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if target.Invulnerability.Try() then
            return false
        endif

        return true
    endmethod

    enumMethod DestructableEnum
        call DESTRUCTABLE.Event.Native.GetEnum().Life.Subtract(thistype.DAMAGE)
    endmethod

    static method Ending takes nothing returns nothing
        local Timer delayTimer = Timer.GetExpired()

        local thistype this = delayTimer.GetData()

        call this.deallocate()
        call delayTimer.Destroy()

        call Spot.CreateEffect(x, y, thistype.SPECIAL_EFFECT_PATH, EffectLevel.LOW).Destroy()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, thistype.AREA_RANGE, thistype.TARGET_FILTER)

        local Unit target = thistype.ENUM_GROUP.GetNearest(x, y)

        if (target != NULL) then
            local real damageAll = thistype.MAX_DAMAGE

            loop
                exitwhen (damageAll == 0)

                local real damage = Math.Min(thistype.DAMAGE, target.Life.Get())
                call thistype.ENUM_GROUP.RemoveUnit(target)

                set damageAll = damageAll - damage
                call target.Life.Subtract(damage)

                set target = thistype.ENUM_GROUP.GetNearest(x, y)
                exitwhen (target == NULL)
            endloop
        endif

        call DESTRUCTABLE.Enum.InRange.Do(x, y, thistype.AREA_RANGE, function thistype.DestructableEnum)
    endmethod

    eventMethod Event_Death
        local Destructable explosive = params.Destructable.GetTrigger()

        local thistype this = thistype.allocate()

		local Timer delayTimer = Timer.Create()

        local real x = explosive.GetX()
        local real y = explosive.GetY()

        set this.x = x
        set this.y = y
        call delayTimer.SetData(this)
        call explosive.Event.Remove(DEATH_EVENT)

        call delayTimer.Start(thistype.DELAY, false, function thistype.Ending)
    endmethod

    eventMethod Event_Create
        call params.Destructable.GetTrigger().Event.Add(DEATH_EVENT)
    endmethod

    initMethod Init of Misc
        set thistype.CREATE_EVENT = Event.Create(Destructable.CREATE_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Create)
        set thistype.DEATH_EVENT = Event.Create(Destructable.DEATH_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Death)
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)

        call DestructableType.EXPLOSIVE.Event.Add(CREATE_EVENT)
        call DestructableType.KEG.Event.Add(CREATE_EVENT)
    endmethod
endstruct