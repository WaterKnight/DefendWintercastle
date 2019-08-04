//! runtextmacro BaseStruct("Snowmen", "SNOWMEN")
    static constant string DEATH_EFFECT_ATTACH_POINT = AttachPoint.ORIGIN
    static constant string DEATH_EFFECT_PATH = "Other\\Possession\\Possession.mdl"
    static Event DEATH_EVENT
    static constant real DURATION = 30.
    static constant real DROP_INCREMENT = 0.25

    static constant real RED_INCREMENT = -128.
    static constant real GREEN_INCREMENT = 0.
    static constant real BLUE_INCREMENT = -255.

    static integer DEAD_SNOWMEN_AMOUNT = 0

    static method Event_Death takes nothing returns nothing
        local Unit snowman = UNIT.Event.GetTrigger()

        call snowman.Revive()

        if (snowman.Owner.Get() == User.NEUTRAL_AGGRESSIVE) then
            set thistype.DEAD_SNOWMEN_AMOUNT = thistype.DEAD_SNOWMEN_AMOUNT + 1
            call snowman.Abilities.AddWithLevel(RevealAura.THIS_SPELL, 2)
            call snowman.Buffs.Timed.Start(thistype.POSSESSION_BUFF, 1, thistype.DURATION + 0.01)
            call snowman.Effects.Create(thistype.DEATH_EFFECT_PATH, thistype.DEATH_EFFECT_ATTACH_POINT, EffectLevel.NORMAL).DestroyTimed.Start(2.)
            call snowman.Invulnerability.Add(UNIT.Invulnerability.NONE_BUFF)
            call snowman.Owner.Set(User.CASTLE)
            call snowman.VertexColor.Subtract(thistype.RED_INCREMENT, thistype.GREEN_INCREMENT, thistype.BLUE_INCREMENT, 0.)

            if (thistype.DEAD_SNOWMEN_AMOUNT == 1) then
                call Drop.AddSupplyFactor(thistype.DROP_INCREMENT)
                call Game.DisplayTextTimed(User.ANY, String.Color.Do("Notification:", String.Color.GOLD) + " " + String.Color.Do("You got control of a Snowman, all enemy units drop " + Real.ToIntString(thistype.DROP_INCREMENT * 100.) + Char.PERCENT + " more supply.", String.Color.BONUS), 10.)
            endif
            call snowman.ApplyTimedLife(thistype.DURATION)
        else
            set thistype.DEAD_SNOWMEN_AMOUNT = thistype.DEAD_SNOWMEN_AMOUNT - 1
            call snowman.Abilities.Remove(RevealAura.THIS_SPELL)
            call snowman.Buffs.Remove(thistype.POSSESSION_BUFF)
            call snowman.Invulnerability.Subtract(UNIT.Invulnerability.NONE_BUFF)
            call snowman.Owner.Set(User.NEUTRAL_AGGRESSIVE)
            call snowman.VertexColor.Add(thistype.RED_INCREMENT, thistype.GREEN_INCREMENT, thistype.BLUE_INCREMENT, 0.)

            if (thistype.DEAD_SNOWMEN_AMOUNT == 0) then
                call Drop.SubtractSupplyFactor(thistype.DROP_INCREMENT)
                call Game.DisplayTextTimed(User.ANY, String.Color.Do("Notification:", String.Color.GOLD) + " " + String.Color.Do("You lost control of the last Snowman. The spawns' supply loot is reset to the default value.", String.Color.MALUS), 10.)
            endif

            call snowman.Invulnerability.AddTimed(5., UNIT.Invulnerability.NORMAL_BUFF)
        endif
    endmethod

    static method Event_Create takes nothing returns nothing
        local Unit snowman = UNIT.Event.GetTrigger()

        call snowman.Event.Add(DEATH_EVENT)
    endmethod

    static method Init takes nothing returns nothing
        set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Death)
        call thistype.THIS_UNIT_TYPE.Event.Add(Event.Create(Unit.CREATE_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Create))
    endmethod
endstruct