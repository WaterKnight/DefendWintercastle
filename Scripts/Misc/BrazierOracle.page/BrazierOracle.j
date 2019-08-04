//! runtextmacro BaseStruct("BrazierOracle", "BRAZIER_ORACLE")
	static Event DAMAGE_EVENT
    static constant real HEIGHT = 280.
    static DummyUnit LEFT_UNIT = NULL
    static real LEFT_X
    static real LEFT_Y
    static DummyUnit RIGHT_UNIT = NULL
    static real RIGHT_X
    static real RIGHT_Y

    static method Set takes UnitType modelUnitType, real x, real y, boolean right returns nothing
        local playercolor color = User.SPAWN.GetColor()

        local real red = modelUnitType.VertexColor.Red.Get()
        local real green = modelUnitType.VertexColor.Red.Get()
        local real blue = modelUnitType.VertexColor.Red.Get()

		local DummyUnit dummyUnit

        if right then
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

        if right then
            set thistype.RIGHT_UNIT = dummyUnit
        else
            set thistype.LEFT_UNIT = dummyUnit
        endif
    endmethod

    eventMethod Event_GameOver
        if (thistype.LEFT_UNIT != NULL) then
            call thistype.LEFT_UNIT.DestroyInstantly()
        endif
        if (thistype.RIGHT_UNIT != NULL) then
            call thistype.RIGHT_UNIT.DestroyInstantly()
        endif

        call SetDoodadAnimationRect(Rectangle.WORLD.self, 'D01K', Animation.DEATH, false)
        call SetDoodadAnimationRect(Rectangle.WORLD.self, 'D01M', Animation.DEATH, false)
    endmethod

    eventMethod Event_LevelStart
        local Level whichLevel = params.Level.GetTrigger()

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

	eventMethod Event_Damage
        local Unit damager = params.Unit.GetDamager()
        local Unit target = params.Unit.GetTarget()

        local integer protectionLevel = target.Abilities.GetLevel(MeteoriteProtection.THIS_SPELL)

        if (protectionLevel == 1) then
            return
        endif

        //call target.Death.Explosion.Add()

        if (protectionLevel == 2) then
            call params.Real.SetDamage(target.MaxLife.Get() * 0.15 * (1 - target.Armor.Spell.Get()))
        else
            call params.Real.SetDamage(target.MaxLife.Get() * 0.4 * (1 - target.Armor.Spell.Get()))
        endif

		call target.Buffs.Timed.Start(thistype.DAMAGE_BUFF, 1, 1)
        //call target.Death.Explosion.Subtract()
	endmethod

	static method CreateBrazier takes real x, real y
		local Unit u = Unit.Create(thistype.THIS_UNIT_TYPE, User.CASTLE_CONTROLABLE, x, y, UNIT.Facing.STANDARD)

		call u.Event.Add(DAMAGE_EVENT)
	endmethod

    eventMethod Event_Start
    	call thistype.CreateBrazier(thistype.LEFT_X, thistype.LEFT_Y)
    	call thistype.CreateBrazier(thistype.RIGHT_X, thistype.RIGHT_Y)

        call Event.Create(Level.START_EVENT_TYPE, EventPriority.MISC2, function thistype.Event_LevelStart).AddToStatics()
    endmethod

    initMethod Init of Misc_2
        local Rectangle leftRect = Rectangle.CreateFromSelf(gg_rct_LeftBrazier)
        local Rectangle rightRect = Rectangle.CreateFromSelf(gg_rct_RightBrazier)

        set thistype.LEFT_X = leftRect.GetCenterX()
        set thistype.LEFT_Y = leftRect.GetCenterY()
        set thistype.RIGHT_X = rightRect.GetCenterX()
        set thistype.RIGHT_Y = rightRect.GetCenterY()
        call Event.Create(EventType.START, EventPriority.MISC, function thistype.Event_Start).AddToStatics()
        call Event.Create(Meteorite.GAME_OVER_EVENT_TYPE, EventPriority.MISC, function thistype.Event_GameOver).AddToStatics()

		set thistype.DAMAGE_EVENT = Event.Create(UNIT.Damage.Events.ATTACKER_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Damage)
		call UNIT.Death.Explosion.DUMMY_BUFF.Variants.Add(thistype.DAMAGE_BUFF)
    endmethod
endstruct