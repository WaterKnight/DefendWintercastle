//! runtextmacro BaseStruct("InitHeader", "INIT_HEADER")
    static method Init takes nothing returns nothing
        //! runtextmacro Load("Header")
        call Math.Init()
        call Memory.Init()
        call Primitive.Init()
        call StringData.Init()

        call EffectLevel.Init()

        //! runtextmacro Load("Header-2")
        call BoolExpr.Init()
        call Buff.Init()
        call Camera.Init()
        //call Constants.Init()
        call Dialog.Init()
        call Game.Init()
        call Group.Init()
        //call Model.Init()
        call Order.Init()
        call Region.Init()
        call Sound.Init()
        call Spot.Init()
        call TextTag.Init()
        call Timer.Init()
        call Trigger.Init()

        //! runtextmacro Load("Header-3")
        call Event.Init()
        call User.Init()

        //! runtextmacro Load("Header-4")

        //! runtextmacro Load("Header-5")
        call Destructable.Init()
        call EventCombination.Init()
        call Item.Init()
        call Misc.Init()
        call Multiboard.Init()
        call WeatherEffect.Init()

        //! runtextmacro Load("Header-6")
        call Unit.Init()

        //! runtextmacro Load("Header-7")
        call Effect.Init()
        call Lightning.Init()
        call Missile.Init()
        call Spell.Init()

        //! runtextmacro Load("Header-8")
        call Trigger.RunObjectInits(ItemType.INIT_KEY_ARRAY)
        call Trigger.RunObjectInits(UnitType.INIT_KEY_ARRAY)
    endmethod
endstruct