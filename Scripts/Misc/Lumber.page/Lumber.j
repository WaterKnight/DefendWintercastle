//! runtextmacro BaseStruct("Lumber", "LUMBER")
    static constant integer AMOUNT = 15
    static constant real DELAY = 30.
    static constant real EFFECT_TIME = 5.
    static Event DESTROY_EVENT
    //! runtextmacro GetKey("KEY")

    DummyUnit dummyUnit
    Timer delayTimer
    Timer effectTimer
    DummyUnit pad
    SpotEffect restoreEffect
    SpotEffect staticEffect
    real x
    real y

    eventMethod Event_ItemUse
        local Sound dummySound = Sound.CreateFromType(thistype.DUMMY_SOUND)
        local Item thisItem = params.Item.GetTrigger()
        local Unit whichUnit = params.Unit.GetTrigger()

        local real x = thisItem.Position.GetX()
        local real y = thisItem.Position.GetY()
        local real z = thisItem.Position.GetZ()

		local thistype this = thisItem

        call dummySound.SetPositionAndPlay(x, y, z)
        call TEXT_TAG.CreateJumping.Create(String.Color.Do(Char.PLUS + Integer.ToString(thistype.AMOUNT), String.Color.LUMBER), 1.15 * TextTag.STANDARD_SIZE, x, y, z, TextTag.GetFreeId())

        call dummySound.Destroy(true)

		local integer iteration = User.ALL_COUNT

        loop
            exitwhen (iteration < ARRAY_MIN)

            call User.ALL[iteration].State.Add(PLAYER_STATE_RESOURCE_LUMBER, thistype.AMOUNT)

            set iteration = iteration - 1
        endloop
    endmethod

    timerMethod Restore
        local thistype this = Timer.GetExpired().GetData()

        local Item thisItem = Item.Create(thistype.THIS_ITEM_TYPE, this.x, this.y)

        call this.restoreEffect.Destroy()

        call thisItem.Data.Integer.Set(KEY, this)
        call thisItem.Event.Add(DESTROY_EVENT)
    endmethod

    static method CreateRestoreEffect takes nothing returns nothing
        local thistype this = Timer.GetExpired().GetData()

        set this.restoreEffect = SpotEffect.Create(this.x, this.y, "Abilities\\Spells\\Human\\slow\\slowtarget.mdl", EffectLevel.LOW)
    endmethod

    method Start takes nothing returns nothing
        call this.delayTimer.Start(thistype.DELAY, false, function thistype.Restore)
        call this.effectTimer.Start(thistype.DELAY - thistype.EFFECT_TIME, false, function thistype.CreateRestoreEffect)
    endmethod

    eventMethod Event_Destroy
        local Item thisItem = params.Item.GetTrigger()

        local thistype this = thisItem.Data.Integer.Get(KEY)

        call thisItem.Data.Integer.Remove(KEY)
        call thisItem.Event.Remove(DESTROY_EVENT)

        call this.Start()
    endmethod

    static method Create takes Destructable source, Rectangle target returns thistype
        local real x = target.GetCenterX()
        local real y = target.GetCenterY()

    	local thistype this = thistype.allocate()

        local Timer delayTimer = Timer.Create()
        local DummyUnit dummyUnit = DummyUnit.Create(thistype.DUMMY_UNIT_ID, source.GetX(), source.GetY(), source.GetZ(), Math.SOUTH_ANGLE)
        local Timer effectTimer = Timer.Create()

        set this.delayTimer = delayTimer
        set this.effectTimer = effectTimer
        set this.dummyUnit = dummyUnit
        set this.pad = DummyUnit.Create(thistype.PAD_UNIT_ID, x, y, Spot.GetHeight(x, y), Math.SOUTH_ANGLE)
        set this.staticEffect = Spot.CreateEffect(x, y, "buildings\\other\\CircleOfPower\\CircleOfPower.mdl", EffectLevel.LOW)
        set this.x = x
        set this.y = y
        call delayTimer.SetData(this)
        call effectTimer.SetData(this)

        call dummyUnit.Animation.SetByIndex(3)
        call dummyUnit.Scale.Set(2.)

        call this.Start()

        return this
    endmethod

    eventMethod Event_Start
        call thistype.Create(Destructable.GetFromSelf(gg_dest_C00H_1704), Rectangle.CreateFromSelf(gg_rct_Lumber))
        call thistype.Create(Destructable.GetFromSelf(gg_dest_C00H_1725), Rectangle.CreateFromSelf(gg_rct_Lumber2))
        call thistype.Create(Destructable.GetFromSelf(gg_dest_C00H_1724), Rectangle.CreateFromSelf(gg_rct_Lumber3))
        call thistype.Create(Destructable.GetFromSelf(gg_dest_C00H_1726), Rectangle.CreateFromSelf(gg_rct_Lumber4))
        call thistype.Create(Destructable.GetFromSelf(gg_dest_C00H_0188), Rectangle.CreateFromSelf(gg_rct_Lumber5))

        call thistype.Create(Destructable.GetFromSelf(gg_dest_C00H_1731), Rectangle.CreateFromSelf(gg_rct_Lumber6))
        call thistype.Create(Destructable.GetFromSelf(gg_dest_C00H_1732), Rectangle.CreateFromSelf(gg_rct_Lumber7))
        call thistype.Create(Destructable.GetFromSelf(gg_dest_C00H_1734), Rectangle.CreateFromSelf(gg_rct_Lumber8))
        call thistype.Create(Destructable.GetFromSelf(gg_dest_C00H_1733), Rectangle.CreateFromSelf(gg_rct_Lumber9))
        call thistype.Create(Destructable.GetFromSelf(gg_dest_C00H_1730), Rectangle.CreateFromSelf(gg_rct_Lumber10))

        call thistype.Create(Destructable.GetFromSelf(gg_dest_C00H_1727), Rectangle.CreateFromSelf(gg_rct_Lumber11))
        call thistype.Create(Destructable.GetFromSelf(gg_dest_C00H_1729), Rectangle.CreateFromSelf(gg_rct_Lumber12))
        call thistype.Create(Destructable.GetFromSelf(gg_dest_C00H_1728), Rectangle.CreateFromSelf(gg_rct_Lumber13))
    endmethod

    initMethod Init of Misc
        set thistype.DESTROY_EVENT = Event.Create(Item.DESTROY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Destroy)
        call Event.Create(EventType.START, EventPriority.MISC, function thistype.Event_Start).AddToStatics()
        call thistype.THIS_ITEM_TYPE.Event.Add(Event.Create(UNIT.Items.Events.Use.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_ItemUse))
    endmethod
endstruct