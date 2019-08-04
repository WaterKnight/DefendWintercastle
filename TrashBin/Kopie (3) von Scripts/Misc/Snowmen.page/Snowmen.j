//! runtextmacro BaseStruct("Snowmen", "SNOWMEN")
    static integer DEAD_SNOWMEN_AMOUNT = 0
    static constant string DEATH_EFFECT_ATTACH_POINT = AttachPoint.ORIGIN
    static constant string DEATH_EFFECT_PATH = "Other\\Possession\\Possession.mdl"
    static Event DEATH_EVENT
    static constant real DURATION = 30.
    static constant real DROP_INCREMENT = 0.25
    static Buff POSSESSION_BUFF

    static constant real RED_INCREMENT = -128.
    static constant real GREEN_INCREMENT = 0.
    static constant real BLUE_INCREMENT = -255.

    static UnitType THIS_UNIT_TYPE

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
        //! runtextmacro Unit_Create("/", "THIS_UNIT_TYPE", "SnM", "Snowman", "false", "OTHER", "1.")

        //! runtextmacro Unit_SetArmor("/", "MEDIUM", "0.", "Wood")
        //! runtextmacro Unit_SetBlend("/", "0.15")
        //! runtextmacro Unit_SetCasting("/", "0.", "0.51")
        //! runtextmacro Unit_AddClass("/", "NEUTRAL")
        //! runtextmacro Unit_AddClass("/", "STRUCTURE")
        //! runtextmacro Unit_SetCombatFlags("/", "ground,structure", "0.")
        //! runtextmacro Unit_SetDeathTime("/", "3.")
        //! runtextmacro Unit_SetElevation("/", "4", "50.", "0.", "0.")
        //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNSheep.blp")
        //! runtextmacro Unit_SetLife("/", "200.", "0.")
        //! runtextmacro Unit_SetMissilePoints("/", "120.", "0.", "0.", "60.")
        //! runtextmacro Unit_SetModel("/", "Doodads\\Icecrown\\Props\\SnowMan\\SnowMan.mdx", "", "", "", "")
        //! runtextmacro Unit_SetScale("/", "2.", "1.5")
        //! runtextmacro Unit_SetShadow("/", "BuildingShadowSmall", "0.", "0.", "0.", "0.")
        //! runtextmacro Unit_SetSight("/", "1500.", "1500.")
        //! runtextmacro Unit_SetSpellPower("/", "25.")
        //! runtextmacro Unit_SetSupply("/", "30")

        //! runtextmacro Unit_Finalize("/")

        set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Death)
        call thistype.THIS_UNIT_TYPE.Event.Add(Event.Create(Unit.CREATE_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Create))

            //! runtextmacro Buff_Create("/", "POSSESSION_BUFF", "Pos", "Possession", "1", "true", "ReplaceableTextures\\CommandButtons\\BTNMagicalSentry.blp", "This unit's owner is changed from the default one.")

            call thistype.POSSESSION_BUFF.SetShowCountdown(true)
    endmethod
endstruct