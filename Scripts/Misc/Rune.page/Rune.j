//! runtextmacro BaseStruct("Rune", "RUNE")
    static Group ENUM_GROUP
    //! runtextmacro GetKey("KEY")
    static Event RUNE_DEATH_EVENT
    static BoolExpr TARGET_FILTER
    static CustomDrop THIS_DROP

    static integer SPAWN_AMOUNT = ARRAY_MIN

    Timer durationTimer
    Item rune

    condMethod Conditions
        local Unit target = UNIT.Event.Native.GetFilter()

        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if not target.IsAllyOf(User.TEMP) then
            return false
        endif

        return true
    endmethod

    eventMethod Event_ItemUse
        local Unit target
        local Item whichItem = params.Item.GetTrigger()
        local Unit whichUnit = params.Unit.GetTrigger()

        local real whichItemX = whichItem.Position.GetX()
        local real whichItemY = whichItem.Position.GetY()

        call Spot.CreateEffect(whichItemX, whichItemY, thistype.AREA_EFFECT_PATH, EffectLevel.NORMAL).Destroy()

        set User.TEMP = whichUnit.Owner.Get()

        call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(whichItemX, whichItemY, thistype.AREA_RANGE, thistype.TARGET_FILTER)

        set target = thistype.ENUM_GROUP.FetchFirst()

        if (target != NULL) then
            loop
                call target.HealBySpell(target, target.MaxLife.Get() * thistype.HEAL_LIFE_RELATIVE_AMOUNT)
                call target.Mana.Add(target.MaxMana.Get() * thistype.HEAL_MANA_RELATIVE_AMOUNT)

                set target = thistype.ENUM_GROUP.FetchFirst()
                exitwhen (target == NULL)
            endloop
        endif
    endmethod

    method Ending takes Timer durationTimer, Item rune returns nothing
        call durationTimer.Destroy()
        call rune.Data.Integer.Remove(KEY)
        call rune.Event.Remove(RUNE_DEATH_EVENT)

		call this.deallocate()
    endmethod

    timerMethod EndingByTimer
        local Timer durationTimer = Timer.GetExpired()

        local thistype this = durationTimer.GetData()

        local Item rune = this.rune

        call this.Ending(durationTimer, rune)

        call rune.Kill()
    endmethod

    eventMethod Event_Rune_Death
        local Item rune = params.Item.GetTrigger()

        local thistype this = rune.Data.Integer.Get(KEY)

        call this.Ending(this.durationTimer, rune)
    endmethod

    eventMethod Event_Spawn_Death
        local Unit whichUnit = params.Unit.GetTrigger()

        if (params.Unit.GetKiller() == NULL) then
            return
        endif

        if (thistype.SPAWN_AMOUNT < thistype.SPAWN_AMOUNT_FOR_RUNE) then
            set thistype.SPAWN_AMOUNT = thistype.SPAWN_AMOUNT + 1

            return
        endif

        set thistype.SPAWN_AMOUNT = 0

        local thistype this = thistype.allocate()

		local Timer durationTimer = Timer.Create()

        local Item rune = Item.Create(thistype.THIS_ITEM, whichUnit.Position.X.Get(), whichUnit.Position.Y.Get())

        set this.durationTimer = durationTimer
        set this.rune = rune
        call durationTimer.SetData(this)
        call rune.Data.Integer.Set(KEY, this)
        call rune.Event.Add(RUNE_DEATH_EVENT)

        call durationTimer.Start(thistype.DURATION, false, function thistype.EndingByTimer)
    endmethod

    eventMethod Event_Spawn
        local Unit whichUnit = params.Unit.GetTrigger()

        call whichUnit.Drop.Add(thistype.THIS_DROP)
    endmethod

    initMethod Init of Misc_5
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        set thistype.THIS_DROP = CustomDrop.Create(Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_Spawn_Death), null, null, EffectLevel.NORMAL)
        set thistype.RUNE_DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Rune_Death)
        call Event.Create(Spawn.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Spawn).AddToStatics()
        call thistype.THIS_ITEM.Event.Add(Event.Create(UNIT.Items.Events.Use.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_ItemUse))
    endmethod
endstruct