//! runtextmacro BaseStruct("BrazierOracle", "BRAZIER_ORACLE")
    static constant real HEIGHT = 280.
    static DummyUnit LEFT_UNIT = NULL
    static real LEFT_X
    static real LEFT_Y
    static DummyUnit RIGHT_UNIT = NULL
    static real RIGHT_X
    static real RIGHT_Y

    static method Set takes UnitType modelUnitType, real x, real y, boolean right returns nothing
        local playercolor color = User.SPAWN.GetColor()
        local DummyUnit dummyUnit

        local real red = modelUnitType.VertexColor.Red.Get()
        local real green = modelUnitType.VertexColor.Red.Get()
        local real blue = modelUnitType.VertexColor.Red.Get()

        if (right) then
            set dummyUnit = thistype.RIGHT_UNIT
        else
            set dummyUnit = thistype.LEFT_UNIT
        endif

        if (dummyUnit != NULL) then
            call dummyUnit.DestroyInstantly()
        endif

        set dummyUnit = DummyUnit.Create(modelUnitType.self, x, y, Spot.GetHeight(x, y) + thistype.HEIGHT, UNIT.Facing.STANDARD)
        call dummyUnit.SetScale(1.5)
        call dummyUnit.SetLocust()
        call dummyUnit.PlayerColor.Set(color)
        call dummyUnit.Rotate.Start(Math.FULL_ANGLE / 3.)
        call dummyUnit.VertexColor.Set(red, green, blue, 180.)

        if (right) then
            set thistype.RIGHT_UNIT = dummyUnit
        else
            set thistype.LEFT_UNIT = dummyUnit
        endif
    endmethod

    static method Event_GameOver takes nothing returns nothing
        if (thistype.LEFT_UNIT != NULL) then
            call thistype.LEFT_UNIT.DestroyInstantly()
        endif
        if (thistype.RIGHT_UNIT != NULL) then
            call thistype.RIGHT_UNIT.DestroyInstantly()
        endif

        call SetDoodadAnimationRect(Rectangle.WORLD.self, 'D01K', Animation.DEATH, false)
        call SetDoodadAnimationRect(Rectangle.WORLD.self, 'D01M', Animation.DEATH, false)
    endmethod

    static method Event_LevelStart takes nothing returns nothing
        local Level whichLevel = LEVEL.Event.GetTrigger()

        local SpawnWave whichWave = SpawnWave.GetFromLevel(whichLevel)

        if (whichWave != NULL) then
            call thistype.Set(whichWave.GetModelUnitType(), thistype.LEFT_X, thistype.LEFT_Y, false)
        endif

        set whichLevel = whichLevel.GetNext()

        if (whichLevel != NULL) then
            set whichWave = SpawnWave.GetFromLevel(whichLevel)

            if (whichWave != NULL) then
                call thistype.Set(whichWave.GetModelUnitType(), thistype.RIGHT_X, thistype.RIGHT_Y, true)
            endif
        endif
    endmethod

    static method Event_Start takes nothing returns nothing
        call Event.Create(Level.START_EVENT_TYPE, EventPriority.MISC2, function thistype.Event_LevelStart).AddToStatics()
    endmethod

    static method Init takes nothing returns nothing
        local Rectangle leftRect = Rectangle.CreateFromSelf(gg_rct_LeftBrazier)
        local Rectangle rightRect = Rectangle.CreateFromSelf(gg_rct_RightBrazier)

        set thistype.LEFT_X = leftRect.GetCenterX()
        set thistype.LEFT_Y = leftRect.GetCenterY()
        set thistype.RIGHT_X = rightRect.GetCenterX()
        set thistype.RIGHT_Y = rightRect.GetCenterY()
        call Event.Create(EventType.START, EventPriority.MISC, function thistype.Event_Start).AddToStatics()
        call Event.Create(Meteorite.GAME_OVER_EVENT_TYPE, EventPriority.MISC, function thistype.Event_GameOver).AddToStatics()
    endmethod
endstruct