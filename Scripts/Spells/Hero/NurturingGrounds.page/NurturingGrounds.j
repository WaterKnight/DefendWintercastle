//! runtextmacro Folder("NurturingGrounds")
	//! runtextmacro Struct("Egg")
		static Event HEAL_EVENT

		eventMethod Event_Heal
			local Unit egg = params.Unit.GetTrigger()

			local integer level = egg.Buffs.GetLevel(thistype.DUMMY_BUFF)

			call egg.Buffs.Remove(thistype.DUMMY_BUFF)

			call egg.Type.SetWithChangerAbility(thistype.TREANT[level], thistype.CHANGER_ABILITY_ID[level])
		endmethod

		eventMethod Event_BuffLose
			local Unit egg = params.Unit.GetTrigger()

			call egg.Event.Remove(HEAL_EVENT)
		endmethod

		eventMethod Event_BuffGain
			local Unit egg = params.Unit.GetTrigger()

			call egg.Event.Add(HEAL_EVENT)
		endmethod

		static method Create takes real x, real y, Unit caster, integer level returns nothing
			local Unit summon = Unit.Create(thistype.EGG, caster.Owner.Get(), x, y, UNIT.Facing.STANDARD)

            call summon.Classes.Add(UnitClass.SUMMON)

            call summon.ApplyTimedLife(thistype.DURATION[level])

			call summon.Buffs.Add(thistype.DUMMY_BUFF, level)

			call summon.Animation.Set(Animation.BIRTH)
		endmethod

		static method Init takes nothing returns nothing
			set thistype.HEAL_EVENT = Event.Create(Unit.HEALED_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_Heal)
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
		endmethod
	endstruct
endscope

//! runtextmacro BaseStruct("NurturingGrounds", "NURTURING_GROUNDS")
	static Event GRASS_ENTER_EVENT
	static Event GRASS_LEAVE_EVENT
	//! runtextmacro GetKey("KEY")
    //! runtextmacro CreateHumanEyeTime("UPDATE_TIME", "2")

    Unit caster
    real curLength
    Timer eggSpawnTimer
    Region grassRegion
    real lengthAdd
    integer level
    real spreadDuration
    Timer spreadEndTimer
    UnitList targetGroup
    real targetX
    real targetY
    Queue tiles
    Timer updateTimer

    //! runtextmacro LinkToStruct("NurturingGrounds", "Egg")

	timerMethod SpawnEggByTimer
		local thistype this = Timer.GetExpired().GetData()

		local real angle = Math.RandomAngle()
		local real length = Math.Random(0., this.curLength)

		local real x = this.targetX + length * Math.Cos(angle)
		local real y = this.targetY + length * Math.Sin(angle)

		call thistype(NULL).Egg.Create(x, y, this.caster, this.level)
	endmethod

	eventMethod Event_GrassLeave
		local Unit target = params.Unit.GetTrigger()
		local Region whichRegion = params.Region.GetTrigger()

		local thistype this = whichRegion.Data.Integer.Get(KEY)

		if not this.targetGroup.Contains(target) then
			return
		endif

		call this.targetGroup.Remove(target)

		call target.Buffs.Subtract(thistype.POISON_BUFF)
	endmethod

	eventMethod Event_GrassEnter
		local Unit target = params.Unit.GetTrigger()
		local Region whichRegion = params.Region.GetTrigger()

		local thistype this = whichRegion.Data.Integer.Get(KEY)

		if target.IsAllyOf(this.caster.Owner.Get()) then
			return
		endif

		call this.targetGroup.Add(target)

		call target.Buffs.Add(thistype.POISON_BUFF, level)
	endmethod

    method SpawnGrass takes real x, real y, real duration returns nothing
        local Tile val = Tile.GetFromCoords(x, y)

        if this.tiles.Contains(val) then
            call val.RemoveRef()

            return
        endif

		call this.tiles.Add(val)

        call TileTypeMod.Create(x, y, TileType.GRASS).DestroyTimed.Start(duration)

		call this.grassRegion.AddCells(x - Tile.CELL_DIST / 2, y - Tile.CELL_DIST / 2, x + Tile.CELL_DIST / 2, y + Tile.CELL_DIST / 2)
    endmethod

	timerMethod Spread
		local thistype this = Timer.GetExpired().GetData()

		local real curLength = this.curLength + this.lengthAdd

		set this.curLength = curLength

		local real targetX = this.targetX
		local real targetY = this.targetY

		local real xStart = targetX - curLength
		local real xEnd = targetX + curLength
		local real yStart = targetY - curLength
		local real yEnd = targetY + curLength

		local real curLengthSquare = curLength * curLength
		local real y = yStart

		loop
			exitwhen (y > yEnd)

			local real x = xStart

			loop
				exitwhen (x > xEnd)

				if (Math.DistanceSquareByDeltas(x - targetX, y - targetY) <= curLengthSquare) then
					call this.SpawnGrass(x, y, thistype.DURATION[level] + 2 * (1 - this.curLength / thistype.THIS_SPELL.GetAreaRange(level)) * thistype.SPREAD_DURATION[level])
				endif

				set x = x + Tile.CELL_DIST
			endloop

			set y = y + Tile.CELL_DIST
		endloop
	endmethod

	timerMethod EndSpread
		local Timer spreadEndTimer = Timer.GetExpired()

		local thistype this = spreadEndTimer.GetData()

		call spreadEndTimer.Pause()
		call updateTimer.Pause()
	endmethod

	timerMethod EndingByTimer
		local Timer durationTimer = Timer.GetExpired()

		local thistype this = durationTimer.GetData()

		call this.grassRegion.Clear()

		call durationTimer.Destroy()
		call this.eggSpawnTimer.Destroy()
		call this.grassRegion.Data.Integer.Remove(KEY)
		call this.grassRegion.Event.Remove(GRASS_ENTER_EVENT)
		call this.grassRegion.Event.Remove(GRASS_LEAVE_EVENT)
		call this.grassRegion.Destroy()
		call this.spreadEndTimer.Destroy()
		call this.targetGroup.Destroy()
		call this.tiles.Destroy()
		call this.updateTimer.Destroy()

		call this.deallocate()
	endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()
        local real targetX = params.Spot.GetTargetX()
        local real targetY = params.Spot.GetTargetY()

		local real areaRange = thistype.THIS_SPELL.GetAreaRange(level)
		local real duration = thistype.DURATION[level]
		local real spreadDuration = thistype.SPREAD_DURATION[level]

		call Spot.CreateEffectWithSize(targetX, targetY, thistype.SPECIAL_EFFECT_PATH, EffectLevel.LOW, areaRange / 256).DestroyTimed.Start(2.)

		local thistype this = thistype.allocate()

		local Timer durationTimer = Timer.Create()
		local Timer eggSpawnTimer = Timer.Create()
		local Region grassRegion = Region.Create()
		local Timer spreadEndTimer = Timer.Create()
		local Timer updateTimer = Timer.Create()

		set this.caster = caster
		set this.curLength = 0.
		set this.eggSpawnTimer = eggSpawnTimer
		set this.grassRegion = grassRegion
        set this.lengthAdd = areaRange / spreadDuration * thistype.UPDATE_TIME
        set this.level = level
        set this.spreadDuration = spreadDuration
        set this.spreadEndTimer = spreadEndTimer
        set this.targetGroup = UnitList.Create()
        set this.targetX = targetX
        set this.targetY = targetY
        set this.tiles = Queue.Create()
        set this.updateTimer = updateTimer
        call durationTimer.SetData(this)
        call eggSpawnTimer.SetData(this)
        call grassRegion.Data.Integer.Set(KEY, this)
        call spreadEndTimer.SetData(this)
        call updateTimer.SetData(this)

		call grassRegion.Event.Add(GRASS_ENTER_EVENT)
		call grassRegion.Event.Add(GRASS_LEAVE_EVENT)
		call UNIT.Movement.Events.Region.InitRegion(grassRegion)

        call updateTimer.Start(thistype.UPDATE_TIME, true, function thistype.Spread)

        call spreadEndTimer.Start(spreadDuration, false, function thistype.EndSpread)

		call durationTimer.Start(duration + spreadDuration, false, function thistype.EndingByTimer)

		call eggSpawnTimer.Start((duration + spreadDuration) / (thistype.EGGS_AMOUNT[level] + 1), true, function thistype.SpawnEggByTimer)
    endmethod

    initMethod Init of Spells_Purchasable
    	set thistype.GRASS_ENTER_EVENT = Event.Create(UNIT.Movement.Events.Region.ENTER_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_GrassEnter)
    	set thistype.GRASS_LEAVE_EVENT = Event.Create(UNIT.Movement.Events.Region.LEAVE_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_GrassLeave)
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

		call UNIT.Poisoned.NORMAL_BUFF.Variants.Add(thistype.POISON_BUFF)

        local integer iteration = thistype.THIS_SPELL.GetLevelsAmount()

        loop
            set iteration = iteration - 1
            exitwhen (iteration < 1)
        endloop

        call thistype(NULL).Egg.Init()
    endmethod
endstruct