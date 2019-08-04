//! runtextmacro BaseStruct("VictoryRush", "VICTORY_RUSH")
    static Event DEATH_EVENT
    static Group ENUM_GROUP
    static BoolExpr TARGET_FILTER

    condMethod Conditions
        local Unit target = UNIT.Event.Native.GetFilter()

        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if target.Classes.Contains(UnitClass.STRUCTURE) then
            return false
        endif
        if not target.IsAllyOf(User.SPAWN) then
            return false
        endif

        return true
    endmethod

    eventMethod Event_Death
        local Unit whichUnit = params.Unit.GetTrigger()

        local real x = whichUnit.Position.X.Get()
        local real y = whichUnit.Position.Y.Get()

        call Spot.CreateEffect(x, y, thistype.SPECIAL_EFFECT_PATH, EffectLevel.LOW).Destroy()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(x, y, thistype.AREA_RANGE, thistype.TARGET_FILTER)

        local Unit target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            loop
                call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, 1, thistype.DURATION)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif

        call Difficulty.SELECTED.SetLifeFactor(Difficulty.SELECTED.GetLifeFactor() + 0.01)

        call Game.DisplayTextTimed(User.ANY, String.Color.Do("Notification:", String.Color.GOLD) + " A defender died: Spawns have now " + Real.ToIntString(Difficulty.SELECTED.GetLifeFactor() * 100.) + Char.PERCENT + " life.", 10.)
    endmethod

    eventMethod Event_HeroPick
        call params.Unit.GetTrigger().Event.Add(DEATH_EVENT)
    endmethod

    initMethod Init of Misc_2
        set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Death)
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        //call Event.Create(HeroSelection.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_HeroPick).AddToStatics()
    endmethod
endstruct