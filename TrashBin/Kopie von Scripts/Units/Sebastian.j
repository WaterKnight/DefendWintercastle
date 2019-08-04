//! runtextmacro BaseStruct("Sebastian", "SEBASTIAN")
    static Unit THIS_UNIT
    static UnitType THIS_UNIT_TYPE

    static method Event_Start takes nothing returns nothing
        set thistype.THIS_UNIT = Unit.CreateFromSelf(gg_unit_uSeb_0040)
    endmethod

    static method Init takes nothing returns nothing
        //! runtextmacro Unit_Create("/", "THIS_UNIT_TYPE", "Seb", "Sebastian", "false", "DEFENDER", "1.")

        //! runtextmacro Unit_SetArmor("/", "UNARMORED", "0.", "Flesh")
        //! runtextmacro Unit_SetBlend("/", "0.15")
        //! runtextmacro Unit_SetCasting("/", "0.5", "0.67")
        //! runtextmacro Unit_AddClass("/", "NEUTRAL")
        //! runtextmacro Unit_SetCombatFlags("/", "", "0.")
        //! runtextmacro Unit_SetDeathTime("/", "2.")
        //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "10.")
        //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNPriest.blp")
        //! runtextmacro Unit_SetLife("/", "120.", "0.")
        //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
        //! runtextmacro Unit_SetModel("/", "units\\human\\Priest\\Priest.mdx", "", "", "", "")
        //! runtextmacro Unit_SetScale("/", "1.", "1.")
        //! runtextmacro Unit_SetShadow("/", "NORMAL", "120.", "120.", "50.", "50.")
        //! runtextmacro Unit_SetSight("/", "500.", "500.")
        //! runtextmacro Unit_SetSoundset("/", "Priest")
        //! runtextmacro Unit_SetSpellPower("/", "400.")

        //! runtextmacro Unit_Finalize("/")

        call Event.Create(EventType.START, EventPriority.MISC, function thistype.Event_Start).AddToStatics()
    endmethod
endstruct