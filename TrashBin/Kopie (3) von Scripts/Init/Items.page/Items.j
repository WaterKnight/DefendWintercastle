//! runtextmacro BaseStruct("InitItems", "INIT_ITEMS")
    static method Init takes nothing returns nothing
        //! runtextmacro Load("Items")
        call EmergencyProvisions.Init()
        call FireWater.Init()
        call HerbalOintment.Init()
        call IceTea.Init()
        call Meat.Init()
        call MeteoriteShard.Init()
        call TropicalRainbow.Init()

        //! runtextmacro Load("Items Act1")
        //Act1
        call BoomerangStone.Init()
        call EyeOfTheFlame.Init()
        call Mallet.Init()
        call PenguinFeather.Init()
        call RabbitsFoot.Init()
        call RamblersStick.Init()
        call ScrollOfProtection.Init()
        call TeleportScroll.Init()

        //! runtextmacro Load("Items Act2")
        //Act2
        call GruntAxe.Init()
        call RobynsHood.Init()

        //! runtextmacro Load("Items Act3")
        //Act3
        call ElfinDagger.Init()
        call SpearOfTheDefender.Init()
    endmethod
endstruct