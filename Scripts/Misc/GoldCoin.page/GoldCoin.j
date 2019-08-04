//! runtextmacro BaseStruct("GoldCoin", "GOLD_COIN")
    //! runtextmacro GetKey("AMOUNT_KEY")
    static Event COIN_DESTROY_EVENT
    static CustomDrop THIS_DROP

    integer amount

    eventMethod Event_ItemUse
        local Item thisItem = params.Item.GetTrigger()
        local Unit whichUnit = params.Unit.GetTrigger()

        local real x = thisItem.Position.GetX()
        local real y = thisItem.Position.GetY()
        local real z = thisItem.Position.GetZ()

		local thistype this = thisItem

        local Sound dummySound = Sound.CreateFromType(thistype.DUMMY_SOUND)

        call dummySound.SetPositionAndPlay(x, y, z)
        call TEXT_TAG.CreateJumping.Create(String.Color.Do(Char.PLUS + Integer.ToString(amount), String.Color.GOLD), 1.15 * TextTag.STANDARD_SIZE, thisItem.Position.GetX(), thisItem.Position.GetY(), thisItem.Position.GetZ(), TextTag.GetFreeId())

        call dummySound.Destroy(true)

		local integer iteration = User.ALL_COUNT

        loop
            exitwhen (iteration < ARRAY_MIN)

            call User.ALL[iteration].State.Add(PLAYER_STATE_RESOURCE_GOLD, this.amount)

            set iteration = iteration - 1
        endloop
    endmethod

    eventMethod Event_Coin_Destroy
        local Item thisItem = params.Item.GetTrigger()

        local thistype this = thisItem

        call thisItem.Event.Remove(COIN_DESTROY_EVENT)
    endmethod

    eventMethod Event_Spawn_Death
        local Unit whichUnit = params.Unit.GetTrigger()

        local Item thisItem = Item.Create(thistype.THIS_ITEM, whichUnit.Position.X.Get(), whichUnit.Position.Y.Get())

        local thistype this = thisItem

        set this.amount = whichUnit.Type.Get().Data.Integer.Get(AMOUNT_KEY)
        call thisItem.Event.Add(COIN_DESTROY_EVENT)
    endmethod

    static method AddToUnitType takes UnitType whichType, integer amount returns nothing
        call whichType.Data.Integer.Set(AMOUNT_KEY, amount)

        call whichType.Drop.Add(thistype.THIS_DROP)
    endmethod

    initMethod Init of Misc
        set thistype.COIN_DESTROY_EVENT = Event.Create(Item.DESTROY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Coin_Destroy)
        set thistype.THIS_DROP = CustomDrop.Create(Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_Spawn_Death), null, null, EffectLevel.NORMAL)
        call thistype.THIS_ITEM.Event.Add(Event.Create(UNIT.Items.Events.Use.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_ItemUse))
    endmethod
endstruct