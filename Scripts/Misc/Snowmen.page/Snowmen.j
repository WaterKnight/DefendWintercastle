//! runtextmacro BaseStruct("Snowmen", "SNOWMEN")
    static Event DEATH_EVENT
    static constant real DURATION = 30.
    static constant real DROP_INCREMENT = 0.25

    static constant real RED_INCREMENT = -128.
    static constant real GREEN_INCREMENT = 0.
    static constant real BLUE_INCREMENT = -255.

    static integer FLOWERS_AMOUNT = 0

    eventMethod Event_Death
        local Unit flower = params.Unit.GetTrigger()

        local real x = flower.Position.X.Get()
        local real y = flower.Position.Y.Get()

        call flower.Destroy()

        call Item.Create(thistype.THIS_ITEM_TYPE, x, y)

        set thistype.FLOWERS_AMOUNT = thistype.FLOWERS_AMOUNT - 1

        if (thistype.FLOWERS_AMOUNT == 0) then
            call Drop.SubtractSupplyFactor(thistype.DROP_INCREMENT)
            call Game.DisplayTextTimed(User.ANY, String.Color.Do("Notification:", String.Color.GOLD) + " " + String.Color.Do("You lost control of the last Flower. The spawns' supply loot is reset to the default value.", String.Color.MALUS), 10.)
        endif
    endmethod

    eventMethod Event_Use
        local Item seed = params.Item.GetTrigger()

        local real x = seed.Position.GetX()
        local real y = seed.Position.GetY()

        local Unit flower = Unit.Create(thistype.THIS_UNIT_TYPE, User.CASTLE, x, y, UNIT.Facing.STANDARD)

        call flower.Event.Add(DEATH_EVENT)
        call flower.Abilities.Add(Invulnerability.THIS_SPELL)
        call flower.Abilities.AddWithLevel(RevealAura.THIS_SPELL, 2)
        call flower.Animation.Set(Animation.BIRTH)
        call flower.Animation.Queue(Animation.STAND)
        call flower.Buffs.Timed.Start(thistype.POSSESSION_BUFF, 1, thistype.DURATION + 0.01)
        call flower.Effects.Create(thistype.DEATH_EFFECT_PATH, thistype.DEATH_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).DestroyTimed.Start(2.)

        call flower.ApplyTimedLife(thistype.DURATION)

        set thistype.FLOWERS_AMOUNT = thistype.FLOWERS_AMOUNT + 1

        if (thistype.FLOWERS_AMOUNT == 1) then
            call Drop.AddSupplyFactor(thistype.DROP_INCREMENT)
            call Game.DisplayTextTimed(User.ANY, String.Color.Do("Notification:", String.Color.GOLD) + " " + String.Color.Do("You got control of a Flower, all enemy units drop " + Real.ToIntString(thistype.DROP_INCREMENT * 100.) + Char.PERCENT + " more supply.", String.Color.BONUS), 10.)
        endif
    endmethod

    eventMethod Event_Create
        call params.Item.GetTrigger().SetInvulnerable(true)
    endmethod

    initMethod Init of Misc
        set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Death)
        call thistype.THIS_ITEM_TYPE.Event.Add(Event.Create(Item.CREATE_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Create))
        call thistype.THIS_ITEM_TYPE.Event.Add(Event.Create(UNIT.Items.Events.Use.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Use))
    endmethod
endstruct