//! runtextmacro Folder("HandOfNature")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("HandOfNature", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("HandOfNature", "Integer", "integer")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Integer")

        //! runtextmacro Data_Implement("HandOfNature")
    endstruct

    //! runtextmacro Struct("Prison")
        method Subtract takes Unit target returns nothing
            call target.Buffs.Subtract(thistype.DUMMY_BUFF)
        endmethod

        method Add takes Unit target returns nothing
            call target.Buffs.Add(thistype.DUMMY_BUFF, 1)
        endmethod

        static method Init takes nothing returns nothing
        endmethod
    endstruct

    //! runtextmacro Folder("Roots")
        //! runtextmacro Struct("Buff")
            static real array DAMAGE_PER_INTERVAL

            Unit caster
            real damage
            Timer intervalTimer
            Unit target

            timerMethod DealDamage
                local thistype this = Timer.GetExpired().GetData()

                call this.caster.DamageUnitBySpell(this.target, this.damage, true, false)
            endmethod

            eventMethod Event_BuffLose
                local Unit target = params.Unit.GetTrigger()

                local thistype this = target

                local Timer intervalTimer = this.intervalTimer

                call intervalTimer.Destroy()
            endmethod

            eventMethod Event_BuffGain
                local Unit caster = Unit.TEMP
                local integer level = params.Buff.GetLevel()
                local Unit target = params.Unit.GetTrigger()

                local thistype this = target

				local Timer intervalTimer = Timer.Create()

                set this.caster = caster
                set this.damage = thistype.DAMAGE_PER_INTERVAL[level]
                set this.intervalTimer = intervalTimer
                set this.target = target
                call intervalTimer.SetData(this)

                call intervalTimer.Start(thistype.INTERVAL, true, function thistype.DealDamage)
            endmethod

            static method Start takes Unit caster, integer level, Unit target returns nothing
                local real duration

                if target.Classes.Contains(UnitClass.HERO) then
                    set duration = thistype.HERO_DURATION[level]
                else
                    set duration = thistype.DURATION[level]
                endif

                set Unit.TEMP = caster

                call target.Buffs.Timed.Start(thistype.DUMMY_BUFF, level, duration)
            endmethod

            static method Init takes nothing returns nothing
                local integer iteration = HandOfNature.THIS_SPELL.GetLevelsAmount()

                loop
                    set thistype.DAMAGE_PER_INTERVAL[iteration] = thistype.DAMAGE[iteration] * thistype.INTERVAL / thistype.DURATION[iteration]

                    set iteration = iteration - 1
                    exitwhen (iteration < 1)
                endloop

                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffGain))
                call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
                call UNIT.Stun.DUMMY_BUFF.Variants.Add(thistype.DUMMY_BUFF)
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Roots")
		Unit caster
        Missile dummyMissile
        integer effectAlignment
        Timer intervalTimer
        integer level
        Unit target

        //! runtextmacro LinkToStruct("Roots", "Buff")

        eventMethod Impact
            local Missile dummyMissile = params.Missile.GetTrigger()

            local thistype this = dummyMissile.GetData()

            local Unit caster = this.caster
            local Timer intervalTimer = this.intervalTimer
            local integer level = this.level
            local Unit target = this.target

            call this.deallocate()
            call dummyMissile.Destroy()
            call intervalTimer.Destroy()

            call thistype(NULL).Buff.Start(caster, level, target)
        endmethod

        timerMethod Interval
            local thistype this = Timer.GetExpired().GetData()

            local Missile dummyMissile = this.dummyMissile
            local integer effectAligment = -this.effectAlignment

            call Spot.CreateEffect(dummyMissile.Position.X.Get() + effectAlignment * Math.Random(25., 50.), dummyMissile.Position.Y.Get() + effectAlignment * Math.Random(25., 50.), SPECIAL_EFFECT_PATH, EffectLevel.NORMAL).Destroy()

            set this.effectAlignment = effectAlignment
        endmethod

        static method StartTarget takes Unit caster, integer level, Unit target returns nothing
            local thistype this = thistype.allocate()

            local Missile dummyMissile = Missile.Create()
            local Timer intervalTimer = Timer.Create()

            set this.caster = caster
            set this.dummyMissile = dummyMissile
            set this.effectAlignment = -1
            set this.intervalTimer = intervalTimer
            set this.level = level
            set this.target = target
            call intervalTimer.SetData(this)

            call intervalTimer.Start(thistype.INTERVAL, true, function thistype.Interval)

            call dummyMissile.CollisionSize.Set(10.)
            call dummyMissile.Impact.SetAction(function thistype.Impact)
            call dummyMissile.SetData(this)
            call dummyMissile.Speed.Set(400.)
            call dummyMissile.Position.SetFromUnit(caster)

            call dummyMissile.GoToUnit.Start(target, null)
        endmethod

        static method Init takes nothing returns nothing
            call thistype(NULL).Buff.Init()
        endmethod
    endstruct
    
    //! runtextmacro Struct("Nova")
    	Timer durationTimer
    	Timer intervalTimer
    	real length
    	real lengthAdd
    	real sourceX
    	real sourceY
    	Queue tiles
    	Queue tileMods
    	
    	real overDuration
    	
	    method SpawnGrass takes real x, real y returns nothing
	        local Tile val = Tile.GetFromCoords(x, y)
	
	        if this.tiles.Contains(val) then
	            call val.RemoveRef()
	
	            return
	        endif
	
			call this.tiles.Add(val)
	
	        local TileTypeMod mod = TileTypeMod.Create(x, y, TileType.GRASS)
	        
	        set thistype(mod).overDuration = this.durationTimer.GetRemaining() * 2 + 2
	        call this.tileMods.Add(mod)
	    endmethod

        timerMethod IntervalByTimer
        	local thistype this = Timer.GetExpired().GetData()
        	
        	local real sourceX = this.sourceX
        	local real sourceY = this.sourceY
        	
        	local real length = this.length + this.lengthAdd
        	
        	set this.length = length
        	
        	local real angle = Math.RandomAngle()
        	
        	loop
        		exitwhen (angle > Math.FULL_ANGLE)
        		
        		call this.SpawnGrass(sourceX + length * Math.Cos(angle), sourceY + length * Math.Sin(angle))
        		
        		set angle = angle + Math.QUARTER_ANGLE / 2
        	endloop
        endmethod
    	
    	method Ending takes nothing returns nothing
    		local Timer durationTimer = this.durationTimer
    		local Timer intervalTimer = this.intervalTimer
    		local Queue tiles = this.tiles
    		local Queue tileMods = this.tileMods
    		
    		call durationTimer.Destroy()
    		call intervalTimer.Destroy()
    		call tiles.Destroy()
    		
    		local TileTypeMod mod = tileMods.GetFirst()
    		
    		loop
    			exitwhen (mod == NULL)
    		
    			call mod.DestroyTimed.Start(thistype(mod).overDuration)
    		
    			set mod = tileMods.GetNext(mod)
    		endloop
    		
    		call tileMods.Destroy()
    	endmethod
    	
    	timerMethod PauseByTimer
    		local thistype this = Timer.GetExpired().GetData()
    		
    		call this.intervalTimer.Pause()
    	endmethod
    	
    	/*timerMethod EndingByTimer
    		local thistype this = Timer.GetExpired().GetData()
    		
    		call this.Ending()
    	endmethod*/
    	
        method Start takes SpellInstance whichInstance returns nothing        	
        	local integer level = whichInstance.GetLevel()

			local real duration = HandOfNature.DURATION[level]

			local integer wavesAmount = Real.ToInt(thistype.DURATION / thistype.INTERVAL)

			local Timer durationTimer = Timer.Create()        	
        	local Timer intervalTimer = Timer.Create()
        	
        	set this.durationTimer = durationTimer
        	set this.intervalTimer = intervalTimer
        	set this.length = 0.
        	set this.lengthAdd = HandOfNature.THIS_SPELL.GetAreaRange(level) / wavesAmount
        	set this.sourceX = whichInstance.GetTargetX()
        	set this.sourceY = whichInstance.GetTargetY()
        	set this.tiles = Queue.Create()
        	set this.tileMods = Queue.Create()
        	call durationTimer.SetData(this)
        	call intervalTimer.SetData(this)
        	
        	call intervalTimer.Start(thistype.INTERVAL, true, function thistype.IntervalByTimer)
        	call durationTimer.Start(thistype.DURATION, false, function thistype.PauseByTimer)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("HandOfNature", "HAND_OF_NATURE")
    static Group ENUM_GROUP
    //! runtextmacro GetKey("KEY")
    //! runtextmacro GetKeyArray("SUMMONS_KEY_ARRAY")
    static BoolExpr TARGET_FILTER

    Unit caster
    boolean prisoned
    Unit target

    //! runtextmacro LinkToStruct("HandOfNature", "Data")
    //! runtextmacro LinkToStruct("HandOfNature", "Id")
    //! runtextmacro LinkToStruct("HandOfNature", "Nova")
    //! runtextmacro LinkToStruct("HandOfNature", "Prison")
    //! runtextmacro LinkToStruct("HandOfNature", "Roots")

    eventMethod Event_BuffLose
        local Unit summon = params.Unit.GetTrigger()

        local thistype this = summon.Data.Integer.Get(KEY)

        if this.prisoned then
            set this.prisoned = false

            call thistype(NULL).Prison.Subtract(this.target)
        endif

        if this.Data.Integer.Table.Remove(SUMMONS_KEY_ARRAY, summon) then
			call this.Nova.Ending()
			
            call this.deallocate()
        endif
    endmethod

    condMethod Conditions
        local Unit target = UNIT.Event.Native.GetFilter()

        if target.Classes.Contains(UnitClass.DEAD) then
            return false
        endif
        if not target.Classes.Contains(UnitClass.GROUND) then
            return false
        endif
        if target.Classes.Contains(UnitClass.MECHANICAL) then
            return false
        endif
        if target.IsAllyOf(User.TEMP) then
            return false
        endif
        if target.MagicImmunity.Try() then
            return false
        endif

        return true
    endmethod

    eventMethod Event_SpellEffect
        local Unit caster = params.Unit.GetTrigger()
        local integer level = params.Spell.GetLevel()
        local Unit target = params.Unit.GetTarget()
        local real targetX = params.Spot.GetTargetX()
        local real targetY = params.Spot.GetTargetY()
        local SpellInstance whichInstance = params.SpellInstance.GetTrigger()

		local thistype this = thistype.allocate()

        call this.Id.Event_Create()

        set this.caster = caster

		local real offset

        if (target == NULL) then
            set offset = 2 * thistype.SUMMON_UNIT_TYPE[level].CollisionSize.Get() * thistype.SUMMON_UNIT_TYPE[level].Scale.Get()

            set this.prisoned = false
        else
            set offset = target.CollisionSize.Get(true) + S2R(SetVar.GetVal("hon")) * thistype.SUMMON_UNIT_TYPE[level].CollisionSize.Get() * thistype.SUMMON_UNIT_TYPE[level].Scale.Get()

            set this.prisoned = true
            set this.target = target

            call thistype(NULL).Prison.Add(target)
        endif

        call Spot.CreateEffect(targetX, targetY, thistype.SUMMON_EFFECT_PATH, EffectLevel.NORMAL).Destroy()

		local real angle = Math.AtanByDeltas(targetY - caster.Position.Y.Get(), targetX - caster.Position.X.Get())

		local integer maxSummonsAmount = thistype.MAX_SUMMONS_AMOUNT[level]
		local integer summonsAmount = 1

        loop
            exitwhen (summonsAmount > maxSummonsAmount)

            local real x = targetX + offset * Math.Cos(angle)
            local real y = targetY + offset * Math.Sin(angle)

            local Unit summon = Unit.CreateSummon(thistype.SUMMON_UNIT_TYPE[level], caster.Owner.Get(), x, y, angle, thistype.DURATION[level])

            call summon.Data.Integer.Set(KEY, this)
      call DebugEx(I2S(this)+";"+I2S(this.Id.Get())+" add "+I2S(this.Data.Integer.Table.Count(SUMMONS_KEY_ARRAY)))
            call this.Data.Integer.Table.Add(SUMMONS_KEY_ARRAY, summon)

            call summon.Abilities.AddWithLevel(SlowPoison.THIS_SPELL, level)
            call summon.Buffs.Add(thistype.DUMMY_BUFF, 1)

            call summon.Position.SetXY(x, y)

            call summon.Scale.Set(0.)
            call summon.Scale.Timed.Add(thistype.SUMMON_UNIT_TYPE[level].Scale.Get(), 1.)

            set User.TEMP = summon.Owner.Get()

            call thistype.ENUM_GROUP.EnumUnits.InRange.WithCollision.Do(targetX, targetY, thistype.THIS_SPELL.GetAreaRange(level), TARGET_FILTER)

			local integer maxTargetsAmount = thistype.MAX_TARGETS_AMOUNT[level]
            local integer targetsAmount = 1

            loop
                exitwhen (targetsAmount > maxTargetsAmount)

                set target = thistype.ENUM_GROUP.GetNearest(targetX, targetY)

                exitwhen (target == NULL)

                call thistype.ENUM_GROUP.RemoveUnit(target)

                if (target != NULL) then
                    call thistype(NULL).Roots.StartTarget(summon, level, target)
                endif

                set targetsAmount = targetsAmount + 1
            endloop

            set angle = angle + Math.FULL_ANGLE / maxSummonsAmount
            set summonsAmount = summonsAmount + 1
        endloop
        
        call this.Nova.Start(whichInstance)
    endmethod

    initMethod Init of Spells_Hero
        set thistype.ENUM_GROUP = Group.Create()
        set thistype.TARGET_FILTER = BoolExpr.GetFromFunction(function thistype.Conditions)
        call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_BuffLose))
        call thistype.THIS_SPELL.Event.Add(Event.Create(UNIT.Abilities.Events.Effect.DUMMY_EVENT_TYPE, EventPriority.SPELLS, function thistype.Event_SpellEffect))

        call thistype(NULL).Prison.Init()
        call thistype(NULL).Roots.Init()
    endmethod
endstruct