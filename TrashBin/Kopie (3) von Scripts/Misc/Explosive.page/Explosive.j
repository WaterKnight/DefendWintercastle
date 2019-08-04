//! runtextmacro BaseStruct("Explosive", "EXPLOSIVE")
    static constant real AREA_RANGE = 300.
    static Event CREATE_EVENT
    static constant real DAMAGE = 200.
    static constant real DELAY = 0.35
    static Event DEATH_EVENT
    static Group ENUM_GROUP
    //! runtextmacro GetKey("KEY")
    static constant real MAX_DAMAGE = 900.
    static constant string SPECIAL_EFFECT_PATH = "Objects\\Spawnmodels\\Other\\NeutralBuildingExplosion\\NeutralBuildingExplosion.mdl"
    static BoolExpr TARGET_FILTER

    real x
    real y

    static method Conditions takes nothing returns boolean
        local Unit filterUnit = UNIT.Event.Native.GetFilter()

        if (filterUnit.Classes.Contains(UnitClass.DEAD)) then
            return false
        endif
        if (filterUnit.Invulnerability.Get() > 0) then
            return false
        endif

        return true
    endmethod

    static method DestructableEnum takes nothing returns nothing
        call DESTRUCTABLE.Event.Native.GetEnum().Life.Subtract(thistype.DAMAGE)
    endmethod

    static method Ending takes nothing returns nothing
        local real damage
        local real damageAll
        local Timer delayTimer = Timer.GetExpired()
        local Unit target

        local thistype this = delayTimer.GetData()

        call this.deallocate()
        call delayTimer.Destroy()

        call Spot.CreateEffect(x, y, thistype.SPECIAL_EFFECT_PATH, EffectLevel.LOW).Destroy()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, thistype.AREA_RANGE, thistype.TARGET_FILTER)

        set target = thistype.ENUM_GROUP.GetNearest(x, y)

        if (target != NULL) then
            set damageAll = thistype.MAX_DAMAGE

            loop
                exitwhen (damageAll == 0)

                set damage = Math.Min(thistype.DAMAGE, target.Life.Get())
                call thistype.ENUM_GROUP.RemoveUnit(target)

                set damageAll = damageAll - damage
                call target.Life.Subtract(damage)

                set target = thistype.ENUM_GROUP.GetNearest(x, y)
                exitwhen (target == NULL)
            endloop
        endif

        call DESTRUCTABLE.Enum.InRange.Do(x, y, thistype.AREA_RANGE, function thistype.DestructableEnum)
    endmethod

    static method Event_Death takes nothing returns nothing
        local Timer delayTimer = Timer.Create()
        local Destructable explosive = DESTRUCTABLE.Event.GetTrigger()
        local thistype this = thistype.allocate()

        local real x = explosive.GetX()
        local real y = explosive.GetY()

        set this.x = x
        set this.y = y
        call delayTimer.SetData(this)
        call explosive.Event.Remove(DEATH_EVENT)

        call delayTimer.Start(thistype.DELAY, false, function thistype.Ending)
    endmethod

    static method Event_Create takes nothing returns nothing
        call DESTRUCTABLE.Event.GetTrigger().Event.Add(DEATH_EVENT)
    endmethod

    static method Init takes nothing returns nothing
        set thistype.CREATE_EVENT = Event.Create(Destructable.CREATE_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Create)
        set thistype.DEATH_EVENT = Event.Create(Destructable.DEATH_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Death)
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)

        call DestructableType.EXPLOSIVE.Event.Add(CREATE_EVENT)
        call DestructableType.KEG.Event.Add(CREATE_EVENT)
    endmethod
endstruct