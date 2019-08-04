globals
    constant integer SpawnLocation_MAX_Wrapped = 4
endglobals

//! runtextmacro BaseStruct("SpawnLocation", "SPAWN_LOCATION")
    static integer ALL_AMOUNT = 0

    static thistype BOTTOM
    static thistype LEFT
    static thistype RIGHT

    real angle
    real maxX
    real maxY
    real minX
    real minY

    static method Create takes Rectangle source returns thistype
        local Waypoint sourceWaypoint = Waypoint.GetFromSource(source)
        local real x = source.GetCenterX()
        local real y = source.GetCenterY()

        local Waypoint targetWaypoint = sourceWaypoint.GetNext()

		local thistype this = thistype.allocate()

        set this.angle = Math.AtanByDeltas(targetWaypoint.GetCenterY() - y, targetWaypoint.GetCenterX() - x)
        set this.maxX = source.GetMaxX()
        set this.maxY = source.GetMaxY()
        set this.minX = source.GetMinX()
        set this.minY = source.GetMinY()

        set thistype.ALL_AMOUNT = thistype.ALL_AMOUNT + 1
        call this.AddToList()

        return this
    endmethod

    static method Init takes nothing returns nothing
        set thistype.BOTTOM = thistype.Create(Rectangle.CreateFromSelf(gg_rct_SpawnBottomIn))
        set thistype.LEFT = thistype.Create(Rectangle.CreateFromSelf(gg_rct_SpawnLeftIn))
        set thistype.RIGHT = thistype.Create(Rectangle.CreateFromSelf(gg_rct_SpawnRightIn))
    endmethod
endstruct

//! runtextmacro Folder("SpawnGroup")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("SpawnGroup", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("SpawnGroup", "Integer", "integer")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Integer")

        //! runtextmacro Data_Implement("SpawnGroup")
    endstruct
endscope

//! runtextmacro BaseStruct("SpawnGroup", "SPAWN_GROUP")
    //! runtextmacro GetKeyArray("LOCATIONS_KEY_ARRAY")
    //! runtextmacro GetKeyArray("TYPE_AMOUNT_KEY_ARRAY_DETAIL")
    //! runtextmacro GetKeyArray("TYPES_KEY_ARRAY")

    //! runtextmacro LinkToStruct("SpawnGroup", "Data")
    //! runtextmacro LinkToStruct("SpawnGroup", "Id")

    method CountLocations takes nothing returns integer
        return this.Data.Integer.Table.Count(LOCATIONS_KEY_ARRAY)
    endmethod

    method GetLocation takes integer index returns SpawnLocation
        return this.Data.Integer.Table.Get(LOCATIONS_KEY_ARRAY, index)
    endmethod

    method AddLocation takes SpawnLocation whichLocation returns nothing
        call this.Data.Integer.Table.Add(LOCATIONS_KEY_ARRAY, whichLocation)
    endmethod

    method CountTypes takes nothing returns integer
        return this.Data.Integer.Table.Count(TYPES_KEY_ARRAY)
    endmethod

    method GetType takes integer index returns SpawnType
        return this.Data.Integer.Table.Get(TYPES_KEY_ARRAY, index)
    endmethod

    method GetTypeAmount takes SpawnType whichType returns integer
        return this.Data.Integer.Get(TYPE_AMOUNT_KEY_ARRAY_DETAIL + whichType)
    endmethod

    method AddType takes SpawnType whichType, integer amount returns nothing
        call this.Data.Integer.Set(TYPE_AMOUNT_KEY_ARRAY_DETAIL + whichType, amount)
        call this.Data.Integer.Table.Add(TYPES_KEY_ARRAY, whichType)
    endmethod

    static method Create takes nothing returns thistype
        local thistype this = thistype.allocate()

        call this.Id.Event_Create()

        call this.AddLocation(SpawnLocation.LEFT)
        call this.AddLocation(SpawnLocation.RIGHT)
        call this.AddLocation(SpawnLocation.BOTTOM)

        return this
    endmethod
endstruct

//! runtextmacro Folder("SpawnWave")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("SpawnWave", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("SpawnWave", "Integer", "integer")
        endstruct

        //! runtextmacro Folder("Real")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("SpawnWave", "Real", "real")
            endstruct
        endscope

        //! runtextmacro Struct("Real")
            //! runtextmacro LinkToStruct("Real", "Table")

            //! runtextmacro Data_Type_Implement("SpawnWave", "Real", "real")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Integer")
        //! runtextmacro LinkToStruct("Data", "Real")

        //! runtextmacro Data_Implement("SpawnWave")
    endstruct

    //! runtextmacro Struct("Groups")
        //! runtextmacro GetKeyArray("DELAY_KEY_ARRAY_DETAIL")
        //! runtextmacro GetKeyArray("KEY_ARRAY")
        //! runtextmacro GetKeyArray("TIMER_KEY_ARRAY_DETAIL")

        method Count takes nothing returns integer
            return SpawnWave(this).Data.Integer.Table.Count(KEY_ARRAY)
        endmethod

        method Get takes integer index returns thistype
            return SpawnWave(this).Data.Integer.Table.Get(KEY_ARRAY, index)
        endmethod

        method GetDelay takes SpawnGroup whichGroup returns real
            return SpawnWave(this).Data.Real.Get(DELAY_KEY_ARRAY_DETAIL + whichGroup)
        endmethod

        method GetDelayTimer takes SpawnGroup whichGroup returns Timer
            return SpawnWave(this).Data.Integer.Get(TIMER_KEY_ARRAY_DETAIL + whichGroup)
        endmethod

        method Add takes SpawnGroup whichGroup, real delay returns nothing
            local SpawnWave parent = this
            
			local integer iteration = whichGroup.CountTypes()

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                local SpawnType whichType = whichGroup.GetType(iteration)

                if whichType.IsMelee() then
                    call parent.SetMelee(true)
                endif
                if whichType.IsRanged() then
                    call parent.SetRanged(true)
                endif
                if whichType.IsMagician() then
                    call parent.SetMagician(true)
                endif

                if whichType.IsRunner() then
                    call parent.SetRunner(true)
                endif
                if whichType.IsInvis() then
                    call parent.SetInvis(true)
                endif
                if whichType.IsMagicImmune() then
                    call parent.SetMagicImmune(true)
                endif
                if whichType.IsKamikaze() then
                    call parent.SetKamikaze(true)
                endif
                if whichType.IsBoss() then
                    call parent.SetBoss(true)
                endif

                set iteration = iteration - 1
            endloop

			local Timer delayTimer = Timer.Create()

            call delayTimer.SetData(whichGroup)
            call parent.SetGroupsDuration(delay)
            call parent.Data.Integer.Table.Add(KEY_ARRAY, whichGroup)
            call parent.Data.Real.Set(DELAY_KEY_ARRAY_DETAIL + whichGroup, delay)
            call parent.Data.Integer.Set(TIMER_KEY_ARRAY_DETAIL + whichGroup, delayTimer)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("SpawnWave", "SPAWN_WAVE")
    //! runtextmacro GetKey("KEY")

    //! runtextmacro CreateList("RUNNING_LIST")
    //! runtextmacro CreateForEachList("RUNNING_LIST_FOR_EACH", "RUNNING_LIST")

    Timer durationTimer
    Level whichLevel

    //! runtextmacro LinkToStruct("SpawnWave", "Data")
    //! runtextmacro LinkToStruct("SpawnWave", "Groups")
    //! runtextmacro LinkToStruct("SpawnWave", "Id")

    //! runtextmacro CreateAnyState("duration", "Duration", "real")
    //! runtextmacro CreateAnyState("modelUnitType", "ModelUnitType", "UnitType")
    //! runtextmacro CreateAnyFlagState("waitForClearance", "WaitForClearance")
    //! runtextmacro CreateAnyState("groupsDuration", "GroupsDuration", "real")
    //! runtextmacro CreateAnyState("waitAfter", "WaitAfter", "real")
    //! runtextmacro CreateAnyState("waitBefore", "WaitBefore", "real")

    //! runtextmacro CreateAnyFlagState("melee", "Melee")
    //! runtextmacro CreateAnyFlagState("ranged", "Ranged")
    //! runtextmacro CreateAnyFlagState("magician", "Magician")

    //! runtextmacro CreateAnyFlagState("runner", "Runner")
    //! runtextmacro CreateAnyFlagState("invis", "Invis")
    //! runtextmacro CreateAnyFlagState("magicImmune", "MagicImmune")
    //! runtextmacro CreateAnyFlagState("kamikaze", "Kamikaze")
    //! runtextmacro CreateAnyFlagState("boss", "Boss")

    static method GetFromLevel takes Level whichLevel returns thistype
        return whichLevel.Data.Integer.Get(KEY)
    endmethod

    method GetDurationMax takes nothing returns real
        return Math.Max(this.GetDuration(), this.GetGroupsDuration())
    endmethod

    timerMethod GroupSpawn
        local SpawnGroup whichGroup = Timer.GetExpired().GetData()

        local integer iteration = whichGroup.CountLocations()

        loop
            exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

            local SpawnLocation currentLocation = whichGroup.GetLocation(iteration)

            local real angle = currentLocation.angle
            local real maxX = currentLocation.maxX
            local real maxY = currentLocation.maxY
            local real minX = currentLocation.minX
            local real minY = currentLocation.minY

            local integer iteration2 = whichGroup.CountTypes()

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                local SpawnType whichType = whichGroup.GetType(iteration2)

                local integer amount = whichGroup.GetTypeAmount(whichType)

                loop
                    exitwhen (amount < 1)

                    call Spawn.AddNewQueued(whichType, whichType.GetType(), Math.Random(minX, maxX), Math.Random(minY, maxY), angle)

                    set amount = amount - 1
                endloop

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration - 1
        endloop
    endmethod

    method Pause takes nothing returns nothing
        if (this == NULL) then
            return
        endif

        if not thistype.RUNNING_LIST_Contains(this) then
            return
        endif

        call thistype.RUNNING_LIST_Remove(this)

        local integer iteration = this.Groups.Count()

        loop
            exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

            local SpawnGroup whichGroup = this.Groups.Get(iteration)

            call this.Groups.GetDelayTimer(whichGroup).Pause()

            call this.durationTimer.Pause()

            set iteration = iteration - 1
        endloop
    endmethod

    static method PauseAll takes nothing returns nothing
        call thistype.RUNNING_LIST_FOR_EACH_Set()

        loop
            local thistype this = thistype.RUNNING_LIST_FOR_EACH_FetchFirst()
            exitwhen (this == NULL)

            call this.Pause()
        endloop
    endmethod

    static method Ending takes nothing returns nothing
        local thistype this = Timer.GetExpired().GetData()

        call this.Pause()
    endmethod

    method Run takes nothing returns nothing
        call thistype.RUNNING_LIST_Add(this)

		local integer iteration = this.Groups.Count()

        loop
            exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

            local SpawnGroup whichGroup = this.Groups.Get(iteration)

            call this.Groups.GetDelayTimer(whichGroup).Start(this.Groups.GetDelay(whichGroup), false, function thistype.GroupSpawn)

            call this.durationTimer.Start(this.GetDurationMax(), false, function thistype.Ending)

            set iteration = iteration - 1
        endloop
    endmethod

    method SetLevel takes Level value returns nothing
        set this.whichLevel = value
        call value.Data.Integer.Set(KEY, this)
    endmethod

    static method CreateFromLevel takes Level whichLevel returns thistype
        local thistype this = thistype.allocate()

		local Timer durationTimer = Timer.Create()

        set this.durationTimer = durationTimer
        call durationTimer.SetData(this)

        call this.Id.Event_Create()

        call this.SetDuration(30.)
        call this.SetLevel(whichLevel)
        call this.SetWaitAfter(0.)
        call this.SetWaitBefore(0.)
        call this.SetWaitForClearance(whichLevel == whichLevel.GetLevelSet().Levels.Get(whichLevel.GetLevelSet().Levels.Count()))

        return this
    endmethod

    static method Init_Deers takes nothing returns nothing
    	local thistype this = thistype.CreateFromLevel(Level.DEERS)

        local real delay = 0.
        local integer intervalsAmount = 7

        call this.SetModelUnitType(UnitType.DEER)

        loop
            exitwhen (intervalsAmount < 1)

            set delay = delay + 10.

            local SpawnGroup whichGroup = SpawnGroup.Create()

            call whichGroup.AddType(SpawnType.DEER, 2)
            call whichGroup.AddType(SpawnType.GNOLL_MAGE, 1)

            call this.Groups.Add(whichGroup, delay)

            set intervalsAmount = intervalsAmount - 1
        endloop
    endmethod

    static method Init_Trolls takes nothing returns nothing
        local thistype this = thistype.CreateFromLevel(Level.TROLLS)

        local real delay = 0.
        local integer intervalsAmount = 7

        call this.SetModelUnitType(UnitType.TROLL)

        loop
            exitwhen (intervalsAmount < 1)

            set delay = delay + 10.

            local SpawnGroup whichGroup = SpawnGroup.Create()

            call whichGroup.AddType(SpawnType.TROLL, 2)
            call whichGroup.AddType(SpawnType.TROLL_PRIEST, 1)

            call this.Groups.Add(whichGroup, delay)

            set intervalsAmount = intervalsAmount - 1
        endloop
    endmethod

    static method Init_Gnolls takes nothing returns nothing
    	local thistype this = thistype.CreateFromLevel(Level.GNOLLS)

        local real delay = 0.
        local integer intervalsAmount = 7

        call this.SetModelUnitType(UnitType.GNOLL_MAGE)

        set whichGroup = SpawnGroup.Create()

        call whichGroup.AddType(SpawnType.FURBOLG, 1)

        call this.Groups.Add(whichGroup, delay + 40.)

        loop
            exitwhen (intervalsAmount < 1)

            set delay = delay + 10.

            local SpawnGroup whichGroup = SpawnGroup.Create()

            call whichGroup.AddType(SpawnType.GNOLL_MAGE, 2)

            call this.Groups.Add(whichGroup, delay)

            set whichGroup = SpawnGroup.Create()

            call whichGroup.AddType(SpawnType.TROLL_PRIEST, 1)

            call this.Groups.Add(whichGroup, delay + 5.)

            set intervalsAmount = intervalsAmount - 1
        endloop
    endmethod

    static method Init_Wolves takes nothing returns nothing
        local thistype this = thistype.CreateFromLevel(Level.WOLVES)

        local real delay = 0.
        local integer intervalsAmount = 7

        call this.SetModelUnitType(UnitType.WOLF)

        local SpawnGroup whichGroup = SpawnGroup.Create()

        call whichGroup.AddType(SpawnType.FURBOLG, 1)

        call this.Groups.Add(whichGroup, delay + 30.)

        loop
            exitwhen (intervalsAmount < 1)

            set delay = delay + 10.

            set whichGroup = SpawnGroup.Create()

            call whichGroup.AddType(SpawnType.WOLF, 2)
            call whichGroup.AddType(SpawnType.TROLL_PRIEST, 1)

            call this.Groups.Add(whichGroup, delay)

            set intervalsAmount = intervalsAmount - 1
        endloop
    endmethod

    static method Init_Moonkins takes nothing returns nothing
        local thistype this = thistype.CreateFromLevel(Level.MOONKINS)

        local real delay = 0.
        local integer intervalsAmount = 7

        call this.SetModelUnitType(UnitType.MOONKIN)

        loop
            exitwhen (intervalsAmount < 1)

            set delay = delay + 10.

            local SpawnGroup whichGroup = SpawnGroup.Create()

            call whichGroup.AddType(SpawnType.MOONKIN, 2)

            call this.Groups.Add(whichGroup, delay)

            set intervalsAmount = intervalsAmount - 1
        endloop
    endmethod

    static method Init_SnowFalcons takes nothing returns nothing
        local thistype this = thistype.CreateFromLevel(Level.SNOW_FALCONS)

        local real delay = 0.
        local integer intervalsAmount = 7

        call this.SetModelUnitType(UnitType.SNOW_FALCON)

        loop
            exitwhen (intervalsAmount < 1)

            set delay = delay + 12.

            local SpawnGroup whichGroup = SpawnGroup.Create()

            call whichGroup.AddType(SpawnType.SNOW_FALCON, 2)
            call whichGroup.AddType(SpawnType.TREANT_PURPLE, 2)

            call this.Groups.Add(whichGroup, delay)

            set intervalsAmount = intervalsAmount - 1
        endloop
    endmethod

    static method Init_Kobolds takes nothing returns nothing
        local thistype this = thistype.CreateFromLevel(Level.WOLVES)

        local real delay = 0.
        local integer intervalsAmount = 7

        call this.SetModelUnitType(UnitType.KOBOLD_RED)

        local SpawnGroup whichGroup = SpawnGroup.Create()

        call whichGroup.AddType(SpawnType.FURBOLG, 1)

        call this.Groups.Add(whichGroup, delay + 30.)

        loop
            exitwhen (intervalsAmount < 1)

            set delay = delay + 10.
            set whichGroup = SpawnGroup.Create()

            call whichGroup.AddType(SpawnType.KOBOLD_RED, 4)

            call this.Groups.Add(whichGroup, delay)

            set intervalsAmount = intervalsAmount - 1
        endloop

        set delay = 0.
        set intervalsAmount = 2

        loop
            exitwhen (intervalsAmount < 1)

            set delay = delay + 25.
            set whichGroup = SpawnGroup.Create()

            call whichGroup.AddType(SpawnType.SATYR_CHAMP, 2)

            call this.Groups.Add(whichGroup, delay)

            set intervalsAmount = intervalsAmount - 1
        endloop
    endmethod

    static method Init_Treants takes nothing returns nothing
        local thistype this = thistype.CreateFromLevel(Level.TREANTS)

        local real delay = 0.
        local integer intervalsAmount = 7

        call this.SetModelUnitType(UnitType.TREANT_GREEN)

        loop
            exitwhen (intervalsAmount < 1)

            set delay = delay + 10.

            local SpawnGroup whichGroup = SpawnGroup.Create()

            call whichGroup.AddType(SpawnType.TREANT_PURPLE, 2)
            call whichGroup.AddType(SpawnType.TREANT_GREEN, 1)

            call this.Groups.Add(whichGroup, delay)

            set intervalsAmount = intervalsAmount - 1
        endloop
    endmethod

    static method Init_FurbolgOracle takes nothing returns nothing
        local thistype this = thistype.CreateFromLevel(Level.FURBOLG_ORACLE)

        local SpawnGroup whichGroup = SpawnGroup.Create()

        call whichGroup.AddType(SpawnType.FURBOLG_ORACLE, 1)

        call this.Groups.Add(whichGroup, 0.)
    endmethod

    static method Init_Penguins takes nothing returns nothing
        local thistype this = thistype.CreateFromLevel(Level.PENGUINS)

        local real delay = 10.
        local integer intervalsAmount = 7

		local SpawnGroup whichGroup

        loop
            exitwhen (intervalsAmount < 1)

            set delay = delay + 10.

            set whichGroup = SpawnGroup.Create()

            call whichGroup.AddType(SpawnType.PENGUIN, 2)
            call whichGroup.AddType(SpawnType.FLYING_PENGUIN, 1)

            call this.Groups.Add(whichGroup, delay)

            set intervalsAmount = intervalsAmount - 1
        endloop

        set whichGroup = SpawnGroup.Create()

        call whichGroup.AddType(SpawnType.PENGUIN_CHAMP, 1)

        call this.Groups.Add(whichGroup, 30.)

        call this.SetGroupsDuration(Intro.DURATION)
    endmethod

    static method Init takes nothing returns nothing
        //Act1
            call thistype.Init_Deers()
            call thistype.Init_Trolls()
            call thistype.Init_Gnolls()

            call thistype.Init_Wolves()
            call thistype.Init_Moonkins()
            call thistype.Init_SnowFalcons()

            call thistype.Init_Kobolds()
            call thistype.Init_Treants()
            call thistype.Init_FurbolgOracle()

        /*//Act2
            //Scouts
            set this = thistype.CreateFromLevel(Level.SCOUTS)

            call this.Type.Add(SpawnType.SPEAR_SCOUT, true)

            call this.Type.Add(SpawnType.DRUMMER_CHAMP, true)

            set thisTypeIndex = this.Type.Add(SpawnType.WINGED_SCOUT, true)

            call this.Type.SetIntervalsAmountByParent(thisTypeIndex, thistype(NULL).Type.STANDARD_INTERVALS_AMOUNT div 2)

            //Axe Fighters
            set this = thistype.CreateFromLevel(Level.AXE_FIGHTERS)

            call this.Type.Add(SpawnType.AXE_FIGHTER, true)

            call this.Type.Add(SpawnType.DRUMMER_CHAMP, true)

            //Raiders
            set this = thistype.CreateFromLevel(Level.RAIDERS)

            call this.Type.Add(SpawnType.RAIDER, true)

            call this.Type.Add(SpawnType.DRUMMER_CHAMP, true)

            set thisTypeIndex = this.Type.Add(SpawnType.BALDUIR, false)

            call this.Type.SetAmountByParent(thisTypeIndex, 1)
            call this.Type.SetFadeInByParent(thisTypeIndex, 20.)
            call this.Type.SetIntervalsAmountByParent(thisTypeIndex, 1)
            call this.Type.AddLocationByParent(thisTypeIndex, SpawnLocation.ALL[Math.RandomI(ARRAY_MIN, SpawnLocation.ALL_COUNT)])

            //Catapults
            set this = thistype.CreateFromLevel(Level.CATAPULTS)

            set thisTypeIndex = this.Type.Add(SpawnType.CATAPULT, true)

            call this.Type.AddSupporter(SpawnType.PEON, thisTypeIndex, 3, 1.25)
            call this.Type.SetAmountByParent(thisTypeIndex, 1)
            call this.Type.SetIntervalByParent(thisTypeIndex, 8.)
            call this.Type.SetIntervalsAmountByParent(thisTypeIndex, 10)

            //Assassins
            set this = thistype.CreateFromLevel(Level.ASSASSINS)

            call this.Type.Add(SpawnType.ASSASSIN, true)

            //BOSS - Leader
            set this = thistype.CreateFromLevel(Level.LEADER)

            call this.Type.Add(SpawnType.LEADER, false)

            call this.Type.Add(SpawnType.DEMOLISHER, false)*/

        //Bonus
            //Penguins
            call thistype.Init_Penguins()
    endmethod
endstruct

//! runtextmacro Folder("Spawn")
    //! runtextmacro Struct("Queue")
        static constant real INTERVAL = 0.75
        static Timer INTERVAL_TIMER

        //! runtextmacro CreateQueue("ACTIVE_QUEUE")

        SpawnType whichType
        UnitType whichTypeUnitType
        real x
        real y
        real angle

        timerMethod Interval
            local thistype this = thistype.ACTIVE_QUEUE_FetchFirst()

            local SpawnType whichType = this.whichType
            local UnitType whichTypeUnitType = this.whichTypeUnitType
            local real x = this.x
            local real y = this.y
            local real angle = this.angle

            call this.deallocate()

            if thistype.ACTIVE_QUEUE_IsEmpty() then
                call thistype.INTERVAL_TIMER.Pause()
            endif

            call Spawn.AddNew(whichType, whichTypeUnitType, x, y, angle)
        endmethod

        static method Create takes SpawnType whichType, UnitType whichTypeUnitType, real x, real y, real angle returns nothing
            local thistype this = thistype.allocate()

            set this.whichType = whichType
            set this.whichTypeUnitType = whichTypeUnitType
            set this.x = x
            set this.y = y
            set this.angle = angle

            if thistype.ACTIVE_QUEUE_Add(this) then
                call thistype.INTERVAL_TIMER.Start(thistype.INTERVAL, true, function thistype.Interval)
            endif
        endmethod

        static method Init takes nothing returns nothing
            set thistype.INTERVAL_TIMER = Timer.Create()
        endmethod
    endstruct

    //! runtextmacro Struct("Shadow")
        static constant real REVIVE_INTERVAL = 1.25

        static Event DAMAGE_EVENT
        static Event DEATH_EVENT
        static Event DESTROY_EVENT
        //! runtextmacro GetKey("KEY")
        static Event IDLE_EVENT
        static Timer REVIVE_TIMER
        static Event SHADOW_DEATH_EVENT

        static Unit SPAWN

        //! runtextmacro CreateQueue("REVIVE_QUEUE")

        Unit spawn

        method Destroy takes nothing returns nothing
            local Unit shadow = this

            call SpotEffect.Create(shadow.Position.X.Get(), shadow.Position.Y.Get(), "Objects\\Spawnmodels\\Undead\\UndeadDissipate\\UndeadDissipate.mdx", EffectLevel.LOW).Destroy()

            call shadow.Destroy()
        endmethod

        eventMethod Event_Destroy
            local Unit spawn = params.Unit.GetTrigger()

            local thistype this = spawn.Data.Integer.Get(KEY)

            call this.Destroy()
        endmethod

        eventMethod Event_Death
            local Unit spawn = params.Unit.GetTrigger()

            local thistype this = spawn.Data.Integer.Get(KEY)

            call this.Destroy()
        endmethod

        eventMethod Event_Damage
            local real damage = params.Real.GetDamage()
            local Unit shadow = params.Unit.GetDamager()
            local Unit target = params.Unit.GetTarget()

            local real burnedMana = Math.Min(target.Mana.Get(), damage)
call DebugEx("burn mana")
            call shadow.BurnManaBySpell(target, burnedMana)

            call params.Real.SetDamage(damage - burnedMana)
        endmethod

        timerMethod ReviveInterval
            local Unit shadow = thistype.REVIVE_QUEUE_FetchFirst()

            local thistype this = shadow

            if thistype.REVIVE_QUEUE_IsEmpty() then
                call thistype.REVIVE_TIMER.Pause()
            endif

            call ShowUnit(shadow.self, true)

            call shadow.Revival.Do()

            call shadow.Position.SetWithCollision(Meteorite.THIS_UNIT.Position.X.Get(), Meteorite.THIS_UNIT.Position.Y.Get())

            call shadow.Order.PointTarget(Order.ATTACK, this.spawn.Position.X.Get(), this.spawn.Position.Y.Get())

            call shadow.TimedLife.Start(60.)
        endmethod

        eventMethod Event_ShadowDeath
            local Unit shadow = params.Unit.GetTrigger()

            local thistype this = shadow

            call SpotEffect.Create(shadow.Position.X.Get(), shadow.Position.Y.Get(), "Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl", EffectLevel.LOW).Destroy()

            call shadow.Position.SetWithCollision(Meteorite.THIS_UNIT.Position.X.Get(), Meteorite.THIS_UNIT.Position.Y.Get())

            call ShowUnit(shadow.self, false)

            if thistype.REVIVE_QUEUE_Add(shadow) then
                call thistype.REVIVE_TIMER.Start(thistype.REVIVE_INTERVAL, true, function thistype.ReviveInterval)
            endif
        endmethod

        eventMethod Event_Idle
            local Unit shadow = params.Unit.GetTrigger()

            local thistype this = shadow

            call shadow.Order.PointTarget(Order.ATTACK, this.spawn.Position.X.Get(), this.spawn.Position.Y.Get())
        endmethod

        eventMethod Event_BuffLose
            local Unit shadow = params.Unit.GetTrigger()

            local thistype this = shadow

            local Unit spawn = this.spawn

            call shadow.Event.Remove(DAMAGE_EVENT)
            call shadow.Event.Remove(SHADOW_DEATH_EVENT)
            call shadow.Order.Events.Idle.Unreg(IDLE_EVENT)
            call spawn.Data.Integer.Remove(KEY)
            call spawn.Event.Remove(DEATH_EVENT)
            call spawn.Event.Remove(DESTROY_EVENT)

            if thistype.REVIVE_QUEUE_Remove(shadow) then
                call thistype.REVIVE_TIMER.Pause()
            endif
        endmethod

        eventMethod Event_BuffGain
            local Unit shadow = params.Unit.GetTrigger()
            local Unit spawn = thistype.SPAWN

            local thistype this = shadow

            set this.spawn = spawn
            call shadow.Event.Add(DAMAGE_EVENT)
            call shadow.Event.Add(SHADOW_DEATH_EVENT)
            call shadow.Order.Events.Idle.Reg(IDLE_EVENT)
            call spawn.Data.Integer.Set(KEY, this)
            call spawn.Event.Add(DEATH_EVENT)
            call spawn.Event.Add(DESTROY_EVENT)
        endmethod

        static method Create takes Unit spawn returns nothing
            local real x = Meteorite.THIS_UNIT.Position.X.Get()
            local real y = Meteorite.THIS_UNIT.Position.Y.Get()

            local Unit shadow = Unit.CreateSummon(spawn.Type.Get(), User.CREEP, x, y, UNIT.Facing.STANDARD, INFINITE_DURATION)

            set thistype.SPAWN = spawn

            call shadow.Buffs.Add(thistype.DUMMY_BUFF, 1)

            //call shadow.Attack.Subtract()
            call shadow.Classes.Add(UnitClass.UNDECAYABLE)
            call shadow.Damage.Base.Subtract(shadow.Damage.Base.Get() / 2)
            call shadow.Drop.Supply.Set(1)
            call shadow.Ghost.Add()
            call shadow.MaxLife.Base.Subtract(shadow.MaxLife.Base.Get() / 4)
            call shadow.Movement.Speed.BaseA.Subtract(shadow.Movement.Speed.BaseA.Get() / 2)
            call shadow.Order.PointTarget(Order.ATTACK, spawn.Position.X.Get(), spawn.Position.Y.Get())
            call shadow.Pathing.Subtract()
            call shadow.Silence.Add()
            call shadow.VertexColor.Set(0.65 * 255, 0.25 * 255, 0.25 * 255, shadow.VertexColor.Alpha.Get())

            call shadow.TimedLife.Start(60.)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.DAMAGE_EVENT = Event.Create(UNIT.Damage.Events.ATTACKER_EDIT_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Damage)
            set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Death)
            set thistype.DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Destroy)
            set thistype.IDLE_EVENT = Event.Create(UNIT.Order.Events.Idle.START_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Idle)
            set thistype.REVIVE_TIMER = Timer.Create()
            set thistype.SHADOW_DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_ShadowDeath)

            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Gain.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_BuffGain))
            call thistype.DUMMY_BUFF.Event.Add(Event.Create(UNIT.Buffs.Events.Lose.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_BuffLose))
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("Spawn", "SPAWN")
    static UnitList ALL_GROUP
    static Event CLEAR_CHAT_EVENT
    static constant string CLEAR_INPUT = "-clear wave"
    static Event DESTROY_EVENT
    static EventType DUMMY_EVENT_TYPE
    static integer INTERVALS_AMOUNT
    static constant string REFRESH_EFFECT_ATTACH_POINT = AttachPoint.ORIGIN
    static constant string REFRESH_EFFECT_PATH = "Abilities\\Spells\\Items\\AIre\\AIreTarget.mdl"
    static Timer WAIT_TIMER
    static TimerDialog WAIT_TIMER_DIALOG

    //! runtextmacro LinkToStruct("Spawn", "Queue")
    //! runtextmacro LinkToStruct("Spawn", "Shadow")

    static method RefreshHeroes takes nothing returns nothing
        local integer iteration = User.PLAYING_HUMANS_COUNT

        loop
            exitwhen (iteration < ARRAY_MIN)

            local Unit whichUnit = User.PLAYING_HUMANS[iteration].Hero.Get()

			if (whichUnit != NULL) then
	            if whichUnit.Classes.Contains(UnitClass.DEAD) then
	                call whichUnit.Hero.Revive(whichUnit.Position.X.Get(), whichUnit.Position.Y.Get())
	            endif

	            call whichUnit.Effects.Create(thistype.REFRESH_EFFECT_PATH, thistype.REFRESH_EFFECT_ATTACH_POINT, EffectLevel.LOW).Destroy()
	            call whichUnit.Life.Set(whichUnit.MaxLife.Get())
	            call whichUnit.Mana.Set(whichUnit.MaxMana.Get())
            endif

            set iteration = iteration - 1
        endloop
    endmethod

    eventMethod Event_ActEnding
        local Act whichAct = params.Act.GetTrigger()

        if (whichAct.IsBonus() and not whichAct.GetNext().IsBonus()) then
            call thistype.RemoveAllUnits()

            call thistype.RefreshHeroes()
        endif
    endmethod

    static method CheckForLevelEnding takes nothing returns nothing
        if SpawnWave.GetFromLevel(Level.CURRENT).IsWaitForClearance() then
            if (not thistype.ALL_GROUP.IsEmpty() or not SpawnWave.RUNNING_LIST_IsEmpty()) then
                return
            endif
        endif

        call Level.CURRENT.Ending()
    endmethod

    eventMethod Event_Destroy
        local Unit spawn = params.Unit.GetTrigger()

        call spawn.Event.Remove(DESTROY_EVENT)

        call thistype.ALL_GROUP.Remove(spawn)

        if SpawnWave.GetFromLevel(Level.CURRENT).IsWaitForClearance() then
            call thistype.CheckForLevelEnding()
        endif
    endmethod

    static method EndSpawn takes nothing returns nothing
        call thistype.CheckForLevelEnding()
    endmethod

    static method RemoveAllUnits takes nothing returns nothing
        loop
            local Unit spawn = thistype.ALL_GROUP.GetFirst()
            exitwhen (spawn == NULL)

            call spawn.Destroy()
        endloop
    endmethod

    static method Event_ClearChat takes nothing returns nothing
        call thistype.RemoveAllUnits()
    endmethod

    static method Add_TriggerEvents takes SpawnType whichType, Unit whichUnit returns nothing
        local EventResponse params = EventResponse.Create(EventResponse.STATIC_SUBJECT_ID)

        call params.SpawnType.SetTrigger(whichType)
        call params.Unit.SetTrigger(whichUnit)

		local EventResponse typeParams = EventResponse.Create(whichType.Id.Get())

        call typeParams.SpawnType.SetTrigger(whichType)
        call typeParams.Unit.SetTrigger(whichUnit)

		local integer iteration = EventPriority.ALL_COUNT

        loop
            exitwhen (iteration < ARRAY_MIN)

            local EventPriority priority = EventPriority.ALL[iteration]

            local integer iteration2 = Event.CountAtStatics(thistype.DUMMY_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call Event.GetFromStatics(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(params)

                set iteration2 = iteration2 - 1
            endloop

            set iteration2 = whichType.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call whichType.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run(typeParams)

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration - 1
        endloop

        call params.Destroy()
        call typeParams.Destroy()
    endmethod

    static method AddNew takes SpawnType whichType, UnitType whichTypeUnitType, real x, real y, real angle returns nothing
        local real alpha = whichTypeUnitType.VertexColor.Alpha.Get()
        local real speed = whichTypeUnitType.Speed.Get()

        call whichTypeUnitType.Speed.Set(speed * 0.5)
        call whichTypeUnitType.VertexColor.Alpha.Set(0.)

        local Unit newUnit = Unit.Create(whichTypeUnitType, User.SPAWN, x, y, angle)

        call thistype.ALL_GROUP.Add(newUnit)
        call newUnit.Event.Add(DESTROY_EVENT)
        call newUnit.VertexColor.Timed.Add(0., 0., 0., alpha, 3.)
        call whichTypeUnitType.Speed.Set(speed)
        call whichTypeUnitType.VertexColor.Alpha.Set(alpha)

        if (Math.RandomI(1, 17) == 17) then
            call Tomes.RandomForUnit(newUnit)
        endif

        call thistype.Add_TriggerEvents(whichType, newUnit)

        call newUnit.Damage.Set(Difficulty.SELECTED.GetDamageFactor() * newUnit.Damage.Get())

        call newUnit.MaxLife.Set(Math.Max(UNIT.Life.LIMIT_OF_DEATH, Difficulty.SELECTED.GetLifeFactor() * newUnit.MaxLife.Get()))

        call newUnit.Life.Set(newUnit.MaxLife.Get())

        //call thistype(NULL).Shadow.Create(newUnit)
    endmethod

    static method AddNewQueued takes SpawnType whichType, UnitType whichTypeUnitType, real x, real y, real angle returns nothing
        call thistype(NULL).Queue.Create(whichType, whichTypeUnitType, x, y, angle)
    endmethod

    eventMethod Event_GameOver
        call thistype.WAIT_TIMER.Pause()

        call SpawnWave.PauseAll()
    endmethod

    eventMethod Event_LevelEnding
        call SpawnWave.GetFromLevel(params.Level.GetTrigger()).Pause()
    endmethod

    eventMethod Event_LevelStart
        local Level whichLevel = params.Level.GetTrigger()

        local SpawnWave thisWave = SpawnWave.GetFromLevel(whichLevel)

        if (thisWave == NULL) then
            return
        endif

        local Level nextLevel = whichLevel.GetNext()

        local SpawnWave nextWave = SpawnWave.GetFromLevel(nextLevel)

        set thistype.INTERVALS_AMOUNT = 0

        if (nextLevel == NULL) then
            call thistype.WAIT_TIMER_DIALOG.Hide()

            call thistype.WAIT_TIMER.Start(thisWave.GetDurationMax() + thisWave.GetWaitAfter(), false, function thistype.EndSpawn)
        else
            if thisWave.IsWaitForClearance() then
                call thistype.WAIT_TIMER_DIALOG.Hide()
            else
                call thistype.WAIT_TIMER_DIALOG.SetTitle("Level " + nextLevel.GetName() + " begins in: ")
                //call thistype.WAIT_TIMER_DIALOG.Show()

                call thistype.WAIT_TIMER.Start(thisWave.GetDurationMax() + thisWave.GetWaitAfter() + nextWave.GetWaitBefore(), false, function thistype.EndSpawn)
            endif
        endif

        call thisWave.Run()
    endmethod

    eventMethod Event_Start
        call Event.Create(Level.ENDING_EVENT_TYPE, EventPriority.MISC, function thistype.Event_LevelEnding).AddToStatics()
        call Event.Create(Level.START_EVENT_TYPE, EventPriority.MISC, function thistype.Event_LevelStart).AddToStatics()
    endmethod

    initMethod Init of Misc_4
        set thistype.ALL_GROUP = UnitList.Create()
        set thistype.CLEAR_CHAT_EVENT = Event.Create(User.CHAT_EVENT_TYPE, EventPriority.MISC, function thistype.Event_ClearChat)
        set thistype.DESTROY_EVENT = Event.Create(Unit.DESTROY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Destroy)
        set thistype.DUMMY_EVENT_TYPE = EventType.Create()
        set thistype.WAIT_TIMER = Timer.Create()
        call Event.Create(Act.ENDING_EVENT_TYPE, EventPriority.MISC, function thistype.Event_ActEnding).AddToStatics()
        call Event.Create(EventType.START, EventPriority.MISC, function thistype.Event_Start).AddToStatics()
        call Event.Create(Meteorite.GAME_OVER_EVENT_TYPE, EventPriority.MISC, function thistype.Event_GameOver).AddToStatics()

        set thistype.WAIT_TIMER_DIALOG = TimerDialog.CreateFromTimer(thistype.WAIT_TIMER)
        call StringData.Event.Add(thistype.CLEAR_INPUT, thistype.CLEAR_CHAT_EVENT)

        call thistype(NULL).Queue.Init()
        call thistype(NULL).Shadow.Init()

        call SpawnLocation.Init()
        call SpawnType.Init()

        call SpawnWave.Init()
    endmethod
endstruct