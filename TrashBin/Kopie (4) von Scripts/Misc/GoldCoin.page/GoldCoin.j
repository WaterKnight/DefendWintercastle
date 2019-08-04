//! runtextmacro BaseStruct("GoldCoin", "GOLD_COIN")
    //! runtextmacro GetKey("AMOUNT_KEY")
    static Event COIN_DEATH_EVENT
    static CustomDrop THIS_DROP

    integer amount

    static method Event_ItemUse takes nothing returns nothing
        local Sound dummySound = Sound.Create("Abilities\\Spells\\Items\\ResourceItems\\ReceiveGold.wav", false, true, true, 10, 10, SoundEax.SPELL)
        local integer iteration = User.ALL_COUNT
        local Item thisItem = ITEM.Event.GetTrigger()
        local Unit whichUnit = UNIT.Event.GetTrigger()

        local thistype this = thisItem
        local real x = thisItem.Position.GetX()
        local real y = thisItem.Position.GetY()
        local real z = thisItem.Position.GetZ()

        call dummySound.SetPositionAndPlay(x, y, z)
        call TEXT_TAG.CreateJumping.Create(String.Color.Do(Char.PLUS + Integer.ToString(amount), String.Color.GOLD), 1.15 * TextTag.STANDARD_SIZE, thisItem.Position.GetX(), thisItem.Position.GetY(), thisItem.Position.GetZ(), TextTag.GetFreeId())

        call dummySound.Destroy(true)

        loop
            exitwhen (iteration < ARRAY_MIN)

            call User.ALL[iteration].State.Add(PLAYER_STATE_RESOURCE_GOLD, this.amount)

            set iteration = iteration - 1
        endloop
    endmethod

    static method Event_Coin_Death takes nothing returns nothing
        local Item thisItem = ITEM.Event.GetTrigger()

        local thistype this = thisItem

        call thisItem.Event.Remove(COIN_DEATH_EVENT)
    endmethod

    static method Event_Spawn_Death takes nothing returns nothing
        local thistype this
        local Item thisItem
        local Unit whichUnit

        set whichUnit = UNIT.Event.GetTrigger()

        set thisItem = Item.Create(thistype.THIS_ITEM, whichUnit.Position.X.Get(), whichUnit.Position.Y.Get())

        set this = thisItem

        set this.amount = whichUnit.Type.Get().Data.Integer.Get(AMOUNT_KEY)
        call thisItem.Event.Add(COIN_DEATH_EVENT)
    endmethod

    static method AddToUnitType takes UnitType whichType, integer amount returns nothing
        call whichType.Data.Integer.Set(AMOUNT_KEY, amount)

        call whichType.Drop.Add(thistype.THIS_DROP)
    endmethod

    static method Init takes nothing returns nothing
        set thistype.COIN_DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Coin_Death)
        set thistype.THIS_DROP = CustomDrop.Create(Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.ITEMS, function thistype.Event_Spawn_Death), null, null, EffectLevel.NORMAL)
        call thistype.THIS_ITEM.Event.Add(Event.Create(UNIT.Items.Events.Use.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_ItemUse))
    endmethod
endstruct