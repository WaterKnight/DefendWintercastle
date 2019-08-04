//! runtextmacro BaseStruct("Drop", "DROP")
    static constant real AREA_RANGE = 1000.
    static Group ENUM_GROUP
    static real SUPPLY_FACTOR = 1.
    static BoolExpr TARGET_FILTER

    static method Conditions takes nothing returns boolean
        local Unit filterUnit = UNIT.Event.Native.GetFilter()

        if (filterUnit.Classes.Contains(UnitClass.HERO) == false) then
            return false
        endif

        if (filterUnit.Classes.Contains(UnitClass.DEAD)) then
            return false
        endif
        if (filterUnit.IsAllyOf(User.TEMP) == false) then
            return false
        endif

        return true
    endmethod

    static method Exp_Event_Death takes nothing returns nothing
        local real amount
        local real add
        local Unit killer = UNIT.Event.GetKiller()
        local real killerBonus
        local User killerOwner
        local integer pickedAmount
        local real shared
        local Unit target
        local Unit whichUnit

        if (killer == NULL) then
            return
        endif

        set killerOwner = killer.Owner.Get()
        set whichUnit = UNIT.Event.GetTrigger()

        if (whichUnit.IsAllyOf(killerOwner) == false) then
            set amount = whichUnit.Type.Get().Drop.Exp.Get()

            set User.TEMP = killerOwner

            call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(whichUnit.Position.X.Get(), whichUnit.Position.Y.Get(), thistype.AREA_RANGE, thistype.TARGET_FILTER)

            set pickedAmount = thistype.ENUM_GROUP.Count()

            if (pickedAmount == 0) then
                set killerBonus = 1.
            else
                set killerBonus = 0.4 - 0.05 * pickedAmount
            endif

            set shared = 1. - killerBonus
            call killer.Exp.Add(killerBonus * amount)

            set target = thistype.ENUM_GROUP.FetchFirst()

            if (target != NULL) then
                loop
                    call target.Exp.Add(shared * amount)

                    set target = thistype.ENUM_GROUP.FetchFirst()
                    exitwhen (target == NULL)
                endloop
            endif
        endif
    endmethod

    static method GetDrop takes Unit killer, Unit whichUnit returns integer
        return Real.ToInt(whichUnit.Drop.Supply.Get())
    endmethod

    static method Supply_Event_Death takes nothing returns nothing
        local integer drop
        local Unit killer = UNIT.Event.GetKiller()
        local User killerOwner
        local Unit whichUnit = UNIT.Event.GetTrigger()

        if (killer == NULL) then
            return
        endif

        if (whichUnit.Owner.Get().Team.Get() != Team.ATTACKERS) then
            return
        endif

        set killerOwner = killer.Owner.Get()

        if (killerOwner.Team.Get() != Team.DEFENDERS) then
            return
        endif
        if (killerOwner == User.CASTLE) then
            return
        endif

        set drop = Real.ToInt(thistype.GetDrop(killer, whichUnit) * thistype.SUPPLY_FACTOR)

        if (drop <= 0) then
            return
        endif

        call killerOwner.State.Add(PLAYER_STATE_RESOURCE_GOLD, drop)
        if (drop > whichUnit.Type.Get().Drop.Supply.Get()) then
            call whichUnit.AddJumpingTextTagEx(String.Color.Do(Char.PLUS + Integer.ToString(drop), String.Color.GOLD), 1.15 * TextTag.STANDARD_SIZE, TextTag.GetFreeId(), false, false)
        else
            call whichUnit.AddJumpingTextTagEx(String.Color.Do(Char.PLUS + Integer.ToString(drop), String.Color.GOLD), 1. * TextTag.STANDARD_SIZE, TextTag.GetFreeId(), false, false)
        endif
    endmethod

    static method AddSupplyFactor takes real value returns nothing
        set thistype.SUPPLY_FACTOR = thistype.SUPPLY_FACTOR + value
    endmethod

    static method SubtractSupplyFactor takes real value returns nothing
        set thistype.SUPPLY_FACTOR = thistype.SUPPLY_FACTOR - value
    endmethod

    static method Init takes nothing returns nothing
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Exp_Event_Death).AddToStatics()
        call Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Supply_Event_Death).AddToStatics()
    endmethod
endstruct