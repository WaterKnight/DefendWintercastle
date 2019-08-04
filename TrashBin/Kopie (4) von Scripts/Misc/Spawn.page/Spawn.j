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
        local thistype this = thistype.allocate()
        local real x = source.GetCenterX()
        local real y = source.GetCenterY()

        local Waypoint targetWaypoint = sourceWaypoint.GetNext()

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

//! runtextmacro Folder("SpawnType")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("SpawnType", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("SpawnType", "Integer", "integer")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Integer")

        //! runtextmacro Data_Implement("SpawnType")
    endstruct

    //! runtextmacro Struct("Event")
        //! runtextmacro CreateAnyStaticStateDefault("TRIGGER", "Trigger", "SpawnType", "NULL")

        //! runtextmacro Event_Implement("SpawnType")
    endstruct

    //! runtextmacro Struct("Champion")
        static constant real DAMAGE_INCREMENT = 1.
        static constant real LIFE_INCREMENT = 1.
        static constant real SCALE_INCREMENT = 0.35
        static Event SPAWN_EVENT

        boolean flag

        static method Event_Spawn takes nothing returns nothing
            local SpawnType whichType = SPAWN_TYPE.Event.GetTrigger()
            local Unit whichUnit = UNIT.Event.GetTrigger()

            call whichUnit.Abilities.Add(MeteoriteProtection.THIS_SPELL)
            call whichUnit.Damage.Relative.Add(DAMAGE_INCREMENT)
            call whichUnit.MaxLife.Add(thistype.LIFE_INCREMENT * whichUnit.MaxLife.Get())
            call whichUnit.Scale.Add(thistype.SCALE_INCREMENT * whichType.whichUnitType.Scale.Get())
        endmethod

        method Is takes nothing returns boolean
            return this.flag
        endmethod

        method Set takes nothing returns nothing
            set this.flag = true
            call SpawnType(this).Event.Add(SPAWN_EVENT)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.SPAWN_EVENT = Event.Create(Spawn.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Spawn)
        endmethod
    endstruct

    //! runtextmacro Struct("Items")
        //! runtextmacro GetKeyArray("KEY_ARRAY")
        static Event SPAWN_EVENT

        static method Event_Spawn takes nothing returns nothing
            local SpawnType whichType = SPAWN_TYPE.Event.GetTrigger()
            local Unit whichUnit = UNIT.Event.GetTrigger()

            local thistype this = whichType

            local integer iteration = this.Count()

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                call whichUnit.Items.Add(this.Get(iteration))

                set iteration = iteration - 1
            endloop

            call whichUnit.Attachments.Add("Abilities\\Spells\\Orc\\CommandAura\\CommandAura.mdl", AttachPoint.ORIGIN, EffectLevel.NORMAL)
        endmethod

        method Count takes nothing returns integer
            return SpawnType(this).Data.Integer.Table.Count(KEY_ARRAY)
        endmethod

        method Get takes integer index returns ItemType
            return SpawnType(this).Data.Integer.Table.Get(KEY_ARRAY, index)
        endmethod

        method Add takes ItemType whichItemType returns nothing
            call SpawnType(this).Data.Integer.Table.Add(KEY_ARRAY, whichItemType)
        endmethod

        static method Init takes nothing returns nothing
            set thistype.SPAWN_EVENT = Event.Create(Spawn.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Spawn)
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("SpawnType", "SPAWN_TYPE")
    //! runtextmacro GetKey("KEY")

    //Bonus
    static thistype FLYING_PENGUIN
    static thistype PENGUIN
    static thistype PENGUIN_CHAMP

    //Act1
    static thistype DEER
    static thistype FURBOLG_ORACLE
    static thistype GNOLL_MAGE
    static thistype MOONKIN
    static thistype MOONKIN_CHAMP
    static thistype SATYR_CHAMP
    static thistype SNOW_FALCON
    static thistype TROLL
    static thistype TROLL_PRIEST
    static thistype WOLF

    //Act2
    static thistype ASSASSIN
    static thistype AXE_FIGHTER
    static thistype BALDUIR
    static thistype CATAPULT
    static thistype DEMOLISHER
    static thistype DRUMMER_CHAMP
    static thistype LEADER
    static thistype PEON
    static thistype RAIDER
    static thistype SPEAR_SCOUT
    static thistype WINGED_SCOUT

    static constant real STANDARD_MANA = 100.
    static constant real STANDARD_MANA_REGENERATION = 2.

    UnitType whichUnitType

    //! runtextmacro LinkToStruct("SpawnType", "Champion")
    //! runtextmacro LinkToStruct("SpawnType", "Data")
    //! runtextmacro LinkToStruct("SpawnType", "Event")
    //! runtextmacro LinkToStruct("SpawnType", "Id")
    //! runtextmacro LinkToStruct("SpawnType", "Items")

    //! runtextmacro CreateAnyFlagStateDefault("melee", "Melee", "false")
    //! runtextmacro CreateAnyFlagStateDefault("ranged", "Ranged", "false")
    //! runtextmacro CreateAnyFlagStateDefault("magician", "Magician", "false")

    //! runtextmacro CreateAnyFlagStateDefault("runner", "Runner", "false")
    //! runtextmacro CreateAnyFlagStateDefault("invis", "Invis", "false")
    //! runtextmacro CreateAnyFlagStateDefault("magicImmune", "MagicImmune", "false")
    //! runtextmacro CreateAnyFlagStateDefault("kamikaze", "Kamikaze", "false")
    //! runtextmacro CreateAnyFlagStateDefault("boss", "Boss", "false")

    static method GetFromType takes UnitType whichUnitType returns thistype
        return whichUnitType.Data.Integer.Get(KEY)
    endmethod

    method GetType takes nothing returns UnitType
        return this.whichUnitType
    endmethod

    method AddGoldCoinDrop takes integer amount returns nothing
        call GoldCoin.AddToUnitType(this.whichUnitType, amount)
    endmethod

    static method Finalize takes nothing returns nothing
        local integer iteration = thistype.ALL_COUNT
        local thistype this
        local UnitType whichUnitType

        loop
            exitwhen (iteration < ARRAY_MIN)

            set this = thistype.ALL[iteration]

            set whichUnitType = this.GetType()

            call whichUnitType.Speed.Add(whichUnitType.Speed.Get() * 0.75)

            if (this.IsBoss()) then
                call whichUnitType.Abilities.Add(MeteoriteProtection.THIS_SPELL)
            endif
            if (this.IsInvis()) then
                call whichUnitType.Abilities.Add(Invisibility.THIS_SPELL)
            endif

            set iteration = iteration - 1
        endloop
    endmethod

    method SetType takes UnitType value returns nothing
        set this.whichUnitType = value
        call value.Data.Integer.Set(KEY, this)
    endmethod

    static method Create takes UnitType whichUnitType returns thistype
        local thistype this = thistype.allocate()

        call this.SetType(whichUnitType)

        call this.AddToList()

        call this.Id.Event_Create()

        return this
    endmethod

    static method Init takes nothing returns nothing
        local thistype this

        call thistype(NULL).Champion.Init()
        call thistype(NULL).Items.Init()

        //Bonus
            //Flying Penguin
            set this = thistype.Create(UnitType.FLYING_PENGUIN)

            set thistype.FLYING_PENGUIN = this
            call this.SetRanged(true)

            //Penguin
            set this = thistype.Create(UnitType.PENGUIN)

            set thistype.PENGUIN = this
            call this.SetMelee(true)

            //Penguin Champ
            set this = thistype.Create(UnitType.PENGUIN_CHAMP)

            set thistype.PENGUIN_CHAMP = this
            call this.Champion.Set()
            call this.SetMelee(true)

        //Act1
            //Deer
            set this = thistype.Create(UnitType.DEER)

            set thistype.DEER = this
            call this.SetMelee(true)

            //Furbolg Oracle
            set this = thistype.Create(UnitType.FURBOLG_ORACLE)

            set thistype.FURBOLG_ORACLE = this
            call this.AddGoldCoinDrop(350)
            call this.SetBoss(true)
            call this.SetMelee(true)
            call this.SetMagician(true)

            //Moonkin
            set this = thistype.Create(UnitType.MOONKIN)

            set thistype.MOONKIN = this
            call this.SetMelee(true)

            //Moonkin Champ
            set this = thistype.Create(UnitType.MOONKIN)

            set thistype.MOONKIN_CHAMP = this
            call this.Champion.Set()

            //Gnoll Mage
            set this = thistype.Create(UnitType.GNOLL_MAGE)

            set thistype.GNOLL_MAGE = this
            call this.SetMagician(true)
            call this.SetRanged(true)

            //Satyr Champ
            set this = thistype.Create(UnitType.SATYR)

            set thistype.SATYR_CHAMP = this
            call this.Champion.Set()
            call this.SetMelee(true)

            //Snow Falcon
            set this = thistype.Create(UnitType.SNOW_FALCON)

            set thistype.SNOW_FALCON = this
            call this.SetRanged(true)

            //Troll
            set this = thistype.Create(UnitType.TROLL)

            set thistype.TROLL = this
            call this.SetRanged(true)

            //Troll Priest
            set this = thistype.Create(UnitType.TROLL_PRIEST)

            set thistype.TROLL_PRIEST = this
            call this.SetMagician(true)
            call this.SetRanged(true)

            //Wolf
            set this = thistype.Create(UnitType.WOLF)

            set thistype.WOLF = this
            call this.SetMelee(true)
            call this.SetRunner(true)

        //Act2
            //Assassin
            set this = thistype.Create(UnitType.ASSASSIN)

            set thistype.ASSASSIN = this
            call this.SetInvis(true)
            call this.SetMelee(true)

            //Axe Fighter
            set this = thistype.Create(UnitType.AXE_FIGHTER)

            set thistype.AXE_FIGHTER = this
            call this.SetMelee(true)

            //Balduir
            set this = thistype.Create(UnitType.BALDUIR)

            set thistype.BALDUIR = this
            call this.AddGoldCoinDrop(200)

            //Catapult
            set this = thistype.Create(UnitType.CATAPULT)

            set thistype.CATAPULT = this
            call this.SetMagicImmune(true)
            call this.SetRanged(true)

            //Demolisher
            set this = thistype.Create(UnitType.DEMOLISHER)

            set thistype.DEMOLISHER = this
            call this.SetBoss(true)
            call this.SetRanged(true)

            //Drummer Champ
            set this = thistype.Create(UnitType.DRUMMER)

            set thistype.DRUMMER_CHAMP = this
            call this.AddGoldCoinDrop(55)
            call this.Champion.Set()
            call this.SetRanged(true)

            //Leader
            set this = thistype.Create(UnitType.LEADER)

            set thistype.LEADER = this
            call this.SetBoss(true)
            call this.SetMelee(true)

            //Peon
            set this = thistype.Create(UnitType.PEON)

            set thistype.PEON = this
            call this.SetMelee(true)

            //Raider
            set this = thistype.Create(UnitType.RAIDER)

            set thistype.RAIDER = this
            call this.SetMelee(true)
            call this.SetRunner(true)

            //Spear Scout
            set this = thistype.Create(UnitType.SPEAR_SCOUT)

            set thistype.SPEAR_SCOUT = this
            call this.SetRanged(true)

            //Winged Scout
            set this = thistype.Create(UnitType.SPEAR_SCOUT)

            set thistype.WINGED_SCOUT = this
            call this.SetRanged(true)

        call thistype.Finalize()
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
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Integer")

        //! runtextmacro Data_Implement("SpawnWave")
    endstruct

    //! runtextmacro Struct("Type")
        //! runtextmacro GetKeyArray("AMOUNT_FOR_LOCATION_KEY_ARRAY_DETAIL")
        //! runtextmacro GetKey("KEY")
        //! runtextmacro GetKeyArray("KEY_ARRAY")
        static constant integer STANDARD_AMOUNT = 2
        static constant integer STANDARD_AMOUNT_CHAMPION = 2
        static constant integer STANDARD_AMOUNT_EXTRA = 1
        static constant real STANDARD_INTERVAL = 7.5
        static constant real STANDARD_INTERVAL_CHAMPION = 22.
        static constant real STANDARD_INTERVAL_EXTRA = 17.
        static constant integer STANDARD_INTERVALS_AMOUNT = 7
        static constant integer STANDARD_INTERVALS_AMOUNT_CHAMPION = 2
        static constant integer STANDARD_INTERVALS_AMOUNT_EXTRA = 3

        integer amount
        Timer durationTimer
        real fadeIn
        real interval
        integer intervalsAmount
        Timer intervalTimer
        SpawnWave parent
        integer parentIndex
        SpawnType whichType

        method GetByParent takes integer index returns thistype
            return SpawnWave(this).Data.Integer.Table.Get(KEY_ARRAY, index)
        endmethod

        method CountLocations takes nothing returns integer
            return Memory.IntegerKeys.Table.CountIntegers(KEY_ARRAY + this, KEY_ARRAY)
        endmethod

        method ClearLocations takes nothing returns nothing
            call Memory.IntegerKeys.Table.Clear(KEY_ARRAY + this, KEY_ARRAY)
        endmethod

        method ClearLocationsByParent takes integer index returns nothing
            call this.GetByParent(index).ClearLocations()
        endmethod

        method GetAmountForLocation takes SpawnLocation whichLocation returns integer
            return Memory.IntegerKeys.GetInteger(KEY_ARRAY + this, thistype.AMOUNT_FOR_LOCATION_KEY_ARRAY_DETAIL + whichLocation)
        endmethod

        method GetDuration takes nothing returns real
            return (this.fadeIn + this.intervalsAmount * this.interval)
        endmethod

        method GetDurationByParent takes integer index returns real
            return this.GetByParent(index).GetDuration()
        endmethod

        method GetLocation takes integer index returns SpawnLocation
            return Memory.IntegerKeys.Table.GetInteger(KEY_ARRAY + this, KEY_ARRAY, index)
        endmethod

        method AddLocation takes SpawnLocation whichLocation returns nothing
            call Memory.IntegerKeys.Table.AddInteger(KEY_ARRAY + this, KEY_ARRAY, whichLocation)
        endmethod

        method AddLocationByParent takes integer index, SpawnLocation whichLocation returns nothing
            call this.GetByParent(index).AddLocation(whichLocation)
        endmethod

        method UpdateDuration takes nothing returns nothing
            local SpawnWave parent = this.parent

            local real duration = parent.duration
            local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

            loop
                set this = parent.Data.Integer.Table.Get(KEY_ARRAY, iteration)

                set duration = Math.Max(duration, this.GetDuration())

                set iteration = iteration - 1
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
            endloop

            set parent.typesDuration = duration
        endmethod

        method SetAmount takes integer value returns nothing
            set this.amount = value
        endmethod

        method SetAmountByParent takes integer index, integer value returns nothing
            call this.GetByParent(index).SetAmount(value)
        endmethod

        method SetAmountForLocation takes SpawnLocation whichLocation, integer value returns nothing
            local integer iteration = this.CountLocations()

            loop
                exitwhen (iteration < ARRAY_MIN)

                exitwhen (this.GetLocation(iteration) == whichLocation)

                set iteration = iteration - 1
            endloop

            if (iteration > ARRAY_EMPTY) then
                call Memory.IntegerKeys.SetInteger(KEY_ARRAY + this, thistype.AMOUNT_FOR_LOCATION_KEY_ARRAY_DETAIL + whichLocation, value)
            endif
        endmethod

        method SetAmountForLocationByParent takes integer index, SpawnLocation whichLocation, integer value returns nothing
            call this.GetByParent(index).SetAmountForLocation(whichLocation, value)
        endmethod

        method SetFadeIn takes real value returns nothing
            set this.fadeIn = value

            call this.UpdateDuration()
        endmethod

        method SetFadeInByParent takes integer index, real value returns nothing
            call this.GetByParent(index).SetFadeIn(value)
        endmethod

        method SetInterval takes real value returns nothing
            set this.interval = value

            call this.UpdateDuration()
        endmethod

        method SetIntervalByParent takes integer index, real value returns nothing
            call this.GetByParent(index).SetInterval(value)
        endmethod

        method SetIntervalsAmount takes integer value returns nothing
            set this.intervalsAmount = value

            call this.UpdateDuration()
        endmethod

        method SetIntervalsAmountByParent takes integer index, integer value returns nothing
            call this.GetByParent(index).SetIntervalsAmount(value)
        endmethod

        method Add takes SpawnType whichType, boolean useStandards returns integer
            local integer index = SpawnWave(this).Data.Integer.Table.Count(KEY_ARRAY) + 1
            local integer iteration = SpawnLocation.ALL_COUNT
            local Timer durationTimer = Timer.Create()
            local Timer intervalTimer = Timer.Create()
            local boolean isChampion = whichType.Champion.Is()
            local SpawnWave parent = this
            local thistype parentThis = this
            local integer random

            set this = thistype.allocate()

            set this.durationTimer = durationTimer
            set this.amount = 0
            set this.fadeIn = 0.
            set this.interval = 0.
            set this.intervalsAmount = 0
            set this.intervalTimer = intervalTimer
            set this.parent = parent
            set this.parentIndex = index
            set this.whichType = whichType

            call durationTimer.SetData(this)
            call intervalTimer.SetData(this)
            if (parent.Data.Integer.Table.Add(KEY_ARRAY, this)) then
                call parent.SetModelUnitType(whichType.GetType())
            endif

            if (useStandards) then
                if (isChampion) then
                    set random = Math.RandomI(ARRAY_MIN, SpawnLocation.ALL_COUNT)
                    set useStandards = false
                    call this.AddLocation(SpawnLocation.ALL[random])
                    call this.AddLocation(SpawnLocation.ALL[Math.ModI(random + Math.RandomI(1, SpawnLocation.ALL_AMOUNT - 1), SpawnLocation.ALL_AMOUNT)])
                    call this.SetAmount(thistype.STANDARD_AMOUNT_CHAMPION)
                    call this.SetInterval(thistype.STANDARD_INTERVAL_CHAMPION)

                    call this.SetIntervalsAmount(thistype.STANDARD_INTERVALS_AMOUNT_CHAMPION)
                else
                    call this.AddLocation(SpawnLocation.BOTTOM)
                    call this.AddLocation(SpawnLocation.LEFT)
                    call this.AddLocation(SpawnLocation.RIGHT)
                    call this.SetAmount(thistype.STANDARD_AMOUNT)
                    call this.SetInterval(thistype.STANDARD_INTERVAL)

                    call this.SetIntervalsAmount(thistype.STANDARD_INTERVALS_AMOUNT)
                endif
            endif
            if (isChampion == false) then
                if (whichType.IsMelee()) then
                    call parent.SetMelee(true)
                endif
                if (whichType.IsRanged()) then
                    call parent.SetRanged(true)
                endif
                if (whichType.IsMagician()) then
                    call parent.SetMagician(true)
                endif

                if (whichType.IsRunner()) then
                    call parent.SetRunner(true)
                endif
                if (whichType.IsInvis()) then
                    call parent.SetInvis(true)
                endif
                if (whichType.IsMagicImmune()) then
                    call parent.SetMagicImmune(true)
                endif
                if (whichType.IsKamikaze()) then
                    call parent.SetKamikaze(true)
                endif
                if (whichType.IsBoss()) then
                    call parent.SetBoss(true)
                endif
            endif

            if (useStandards) then
                set this = parentThis.GetByParent(parentThis.Add(whichType, false))

                call this.AddLocation(SpawnLocation.LEFT)
                call this.AddLocation(SpawnLocation.RIGHT)
                call this.SetAmount(thistype.STANDARD_AMOUNT_EXTRA)
                call this.SetInterval(thistype.STANDARD_INTERVAL_EXTRA)
                call this.SetIntervalsAmount(thistype.STANDARD_INTERVALS_AMOUNT_EXTRA)
            endif

            return index
        endmethod

        method AddSupporter takes SpawnType whichType, integer forWhichIndex, integer amount, real intervalFactor returns integer
            local SpawnWave parent = this
            local thistype parentThis = this

            local thistype supportedThis = parentThis.GetByParent(forWhichIndex)

            local integer result = parentThis.Add(whichType, false)

            set this = parentThis.GetByParent(result)

            call this.AddLocation(SpawnLocation.BOTTOM)
            call this.AddLocation(SpawnLocation.LEFT)
            call this.AddLocation(SpawnLocation.RIGHT)
            call this.SetAmount(amount)
            call this.SetInterval(supportedThis.interval * intervalFactor)

            return result
        endmethod

        static method Ending takes nothing returns nothing
            local thistype this = Timer.GetExpired().GetData()

            call this.intervalTimer.Pause()
        endmethod

        static method Interval takes nothing returns nothing
            local real angle
            local SpawnLocation currentLocation
            local integer iteration2
            local real maxX
            local real maxY
            local real minX
            local real minY
            local thistype this = Timer.GetExpired().GetData()

            local integer amount = this.amount
            local integer iteration = this.CountLocations()
            local SpawnType whichType = this.whichType

            local UnitType whichTypeUnitType = whichType.GetType()

            loop
                exitwhen (iteration < ARRAY_MIN)

                set currentLocation = this.GetLocation(iteration)

                set angle = currentLocation.angle
                set iteration2 = amount + this.GetAmountForLocation(currentLocation)
                set maxX = currentLocation.maxX
                set maxY = currentLocation.maxY
                set minX = currentLocation.minX
                set minY = currentLocation.minY

                loop
                    exitwhen (iteration2 < 1)

                    call Spawn.AddNew(whichType, whichTypeUnitType, Math.Random(minX, maxX), Math.Random(minY, maxY), angle)

                    set iteration2 = iteration2 - 1
                endloop

                set iteration = iteration - 1
            endloop
        endmethod

        method Pause takes nothing returns nothing
            local SpawnWave parent = this

            local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                set this = thistype(parent).GetByParent(iteration)

                call this.intervalTimer.Pause()

                call this.durationTimer.Pause()

                set iteration = iteration - 1
            endloop
        endmethod

        static method RunByTimer takes nothing returns nothing
            local Timer intervalTimer = Timer.GetExpired()

            local thistype this = intervalTimer.GetData()

            call intervalTimer.Start(this.interval, true, function thistype.Interval)

            call this.durationTimer.Start(this.GetDuration() - this.fadeIn, false, function thistype.Ending)
        endmethod

        method Run takes nothing returns nothing
            local real duration
            local real fadeIn
            local SpawnWave parent = this

            local integer iteration = parent.Data.Integer.Table.Count(KEY_ARRAY)

            loop
                exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)

                set this = thistype(parent).GetByParent(iteration)

                set duration = this.GetDuration()
                set fadeIn = this.fadeIn

                if (fadeIn > 0.) then
                    call this.intervalTimer.Start(fadeIn, false, function thistype.RunByTimer)
                else
                    call this.intervalTimer.Start(this.interval, true, function thistype.Interval)
                endif

                if (duration > 0.) then
                    call this.durationTimer.Start(duration, false, function thistype.Ending)
                else
                    call this.durationTimer.Start(parent.GetTypesDuration(), false, function thistype.Ending)
                endif

                set iteration = iteration - 1
            endloop
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("SpawnWave", "SPAWN_WAVE")
    static thistype CURRENT = NULL
    //! runtextmacro GetKey("KEY")

    Level whichLevel

    //! runtextmacro LinkToStruct("SpawnWave", "Data")
    //! runtextmacro LinkToStruct("SpawnWave", "Id")
    //! runtextmacro LinkToStruct("SpawnWave", "Type")

    //! runtextmacro CreateAnyState("duration", "Duration", "real")
    //! runtextmacro CreateAnyState("modelUnitType", "ModelUnitType", "UnitType")
    //! runtextmacro CreateAnyState("typesDuration", "TypesDuration", "real")
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

    method Run takes nothing returns nothing
        set thistype.CURRENT = this

        call this.Type.Run()
    endmethod

    method Pause takes nothing returns nothing
        set thistype.CURRENT = NULL

        call this.Type.Pause()
    endmethod

    method SetLevel takes Level value returns nothing
        set this.whichLevel = value
        call value.Data.Integer.Set(KEY, this)
    endmethod

    static method CreateFromLevel takes Level whichLevel returns thistype
        local thistype this = thistype.allocate()

        call this.SetDuration(30.)
        call this.SetLevel(whichLevel)
        call this.SetWaitAfter(10.)
        call this.SetWaitBefore(20.)

        call this.Id.Event_Create()

        return this
    endmethod

    static method Init takes nothing returns nothing
        local thistype this
        local integer thisTypeIndex

        //Act1
            //Deers
            set this = thistype.CreateFromLevel(Level.DEERS)

            call this.Type.Add(SpawnType.DEER, true)
            call this.Type.Add(SpawnType.SATYR_CHAMP, true)

            //Trolls
            set this = thistype.CreateFromLevel(Level.TROLLS)

            set thisTypeIndex = this.Type.Add(SpawnType.TROLL, true)
            call this.Type.Add(SpawnType.SATYR_CHAMP, true)

            call this.Type.AddSupporter(SpawnType.TROLL_PRIEST, thisTypeIndex, 1, 1.5)

            //Gnolls
            set this = thistype.CreateFromLevel(Level.GNOLLS)

            call this.Type.Add(SpawnType.GNOLL_MAGE, true)

            call this.Type.Add(SpawnType.MOONKIN_CHAMP, true)

            //Wolves
            set this = thistype.CreateFromLevel(Level.WOLVES)

            call this.Type.Add(SpawnType.WOLF, true)

            //Moonkins
            set this = thistype.CreateFromLevel(Level.MOONKINS)

            call this.Type.Add(SpawnType.MOONKIN, true)

            call this.Type.Add(SpawnType.SNOW_FALCON, true)

            //BOSS - Furbolg Oracle
            set this = thistype.CreateFromLevel(Level.FURBOLG_ORACLE)

            set thisTypeIndex = this.Type.Add(SpawnType.FURBOLG_ORACLE, false)

            call this.Type.SetAmountByParent(thisTypeIndex, 1)
            call this.Type.SetIntervalByParent(thisTypeIndex, 0.)
            call this.Type.SetIntervalsAmountByParent(thisTypeIndex, 1)

        //Act2
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

            call this.Type.Add(SpawnType.DEMOLISHER, false)

        //Bonus
            //Penguins
            set this = thistype.CreateFromLevel(Level.PENGUINS)

            set thisTypeIndex = this.Type.Add(SpawnType.PENGUIN, true)

            call this.Type.AddSupporter(SpawnType.FLYING_PENGUIN, thisTypeIndex, 1, 1.5)

            call this.Type.Add(SpawnType.PENGUIN_CHAMP, true)

            call this.SetTypesDuration(Intro.DURATION)
    endmethod
endstruct

//! runtextmacro BaseStruct("Spawn", "SPAWN")
    static Group ALL_GROUP
    static Event DEATH_EVENT
    static EventType DUMMY_EVENT_TYPE
    static integer INTERVALS_AMOUNT
    static constant string REFRESH_EFFECT_ATTACH_POINT = AttachPoint.ORIGIN
    static constant string REFRESH_EFFECT_PATH = "Abilities\\Spells\\Items\\AIre\\AIreTarget.mdl"
    static Timer WAIT_TIMER
    static TimerDialog WAIT_TIMER_DIALOG
    static boolean WAITING_FOR_BOSS = false

    static method RefreshHeroes takes nothing returns nothing
        local integer iteration = User.PLAYING_HUMANS_COUNT
        local Unit whichUnit

        loop
            exitwhen (iteration < ARRAY_MIN)

            set whichUnit = User.PLAYING_HUMANS[iteration].Hero.Get()

            if (whichUnit.Classes.Contains(UnitClass.DEAD)) then
                call whichUnit.Hero.Revive(whichUnit.Position.X.Get(), whichUnit.Position.Y.Get())
            endif

            call whichUnit.Effects.Create(thistype.REFRESH_EFFECT_PATH, thistype.REFRESH_EFFECT_ATTACH_POINT, EffectLevel.LOW)
            call whichUnit.Life.Set(whichUnit.MaxLife.GetAll())
            call whichUnit.Mana.Set(whichUnit.MaxMana.GetAll())

            set iteration = iteration - 1
        endloop
    endmethod

    static method Event_ActEnding takes nothing returns nothing
        local Act whichAct = ACT.Event.GetTrigger()

        if (whichAct.IsBonus() and (whichAct.GetNext().IsBonus() == false)) then
            call thistype.RemoveAllUnits()

            call thistype.RefreshHeroes()
        endif
    endmethod

    static method CheckForLevelEnding takes nothing returns nothing
        if (thistype.WAITING_FOR_BOSS) then
            if (thistype.ALL_GROUP.IsEmpty() == false) then
                return
            endif

            set thistype.WAITING_FOR_BOSS = false
        endif

        call Level.CURRENT.Ending()
    endmethod

    static method Event_Death takes nothing returns nothing
        local Unit spawn = UNIT.Event.GetTrigger()

        call spawn.Event.Remove(DEATH_EVENT)

        call thistype.ALL_GROUP.RemoveUnit(spawn)

        if (thistype.WAITING_FOR_BOSS == false) then
            return
        endif

        call thistype.CheckForLevelEnding()
    endmethod

    static method EndSpawn takes nothing returns nothing
        if (SpawnWave.CURRENT.IsBoss()) then
            if (thistype.ALL_GROUP.IsEmpty() == false) then
                set thistype.WAITING_FOR_BOSS = true
            endif
        endif

        call thistype.CheckForLevelEnding()
    endmethod

    static method RemoveAllUnits takes nothing returns nothing
        local Unit spawn

        loop
            set spawn = thistype.ALL_GROUP.FetchFirst()
            exitwhen (spawn == NULL)

            call spawn.Destroy()
        endloop
    endmethod

    static method Add_TriggerEvents takes SpawnType whichType, Unit whichUnit returns nothing
        local integer iteration = EventPriority.ALL_COUNT
        local integer iteration2
        local integer priority

        loop
            exitwhen (iteration < ARRAY_MIN)

            set priority = EventPriority.ALL[iteration]

            set iteration2 = Event.CountAtStatics(thistype.DUMMY_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call Event.SetSubjectId(0)
                call SPAWN_TYPE.Event.SetTrigger(whichType)
                call UNIT.Event.SetTrigger(whichUnit)

                call Event.GetFromStatics(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run()

                set iteration2 = iteration2 - 1
            endloop

            set iteration2 = whichType.Event.Count(thistype.DUMMY_EVENT_TYPE, priority)

            loop
                exitwhen (iteration2 < Memory.IntegerKeys.Table.STARTED)

                call Event.SetSubjectId(whichType.Id.Get())
                call SPAWN_TYPE.Event.SetTrigger(whichType)
                call UNIT.Event.SetTrigger(whichUnit)

                call whichType.Event.Get(thistype.DUMMY_EVENT_TYPE, priority, iteration2).Run()

                set iteration2 = iteration2 - 1
            endloop

            set iteration = iteration - 1
        endloop
    endmethod

    static method AddNew takes SpawnType whichType, UnitType whichTypeUnitType, real x, real y, real angle returns nothing
        local real alpha = whichTypeUnitType.VertexColor.Alpha.Get()
        local Unit newUnit

        call whichTypeUnitType.VertexColor.Alpha.Set(0.)

        set newUnit = Unit.Create(whichTypeUnitType, User.SPAWN, x, y, angle)

        call thistype.ALL_GROUP.AddUnit(newUnit)
        call newUnit.Event.Add(DEATH_EVENT)
        call newUnit.VertexColor.Timed.Add(0., 0., 0., alpha, 3.)
        call whichTypeUnitType.VertexColor.Alpha.Set(alpha)

        call thistype.Add_TriggerEvents(whichType, newUnit)

        call newUnit.Damage.Set(Difficulty.SELECTED.GetDamageFactor() * newUnit.Damage.Get())
        call newUnit.MaxLife.Set(Math.Max(UNIT.Life.LIMIT_OF_DEATH, Difficulty.SELECTED.GetLifeFactor() * newUnit.MaxLife.Get()))

        call newUnit.Life.Set(newUnit.MaxLife.GetAll())
    endmethod

    static method Event_GameOver takes nothing returns nothing
        call thistype.WAIT_TIMER.Pause()
    endmethod

    static method Event_LevelEnding takes nothing returns nothing
        call SpawnWave.GetFromLevel(LEVEL.Event.GetTrigger()).Pause()
    endmethod

    static method Event_LevelStart takes nothing returns nothing
        local Level whichLevel = LEVEL.Event.GetTrigger()

        local Level nextLevel = whichLevel.GetNext()
        local SpawnWave thisWave = SpawnWave.GetFromLevel(whichLevel)

        local SpawnWave nextWave = SpawnWave.GetFromLevel(nextLevel)

        set thistype.INTERVALS_AMOUNT = 0

        if (nextLevel == NULL) then
            call thistype.WAIT_TIMER_DIALOG.Hide()

            call thistype.WAIT_TIMER.Start(thisWave.GetTypesDuration() + thisWave.GetWaitAfter(), false, function thistype.EndSpawn)
        else
            if (thisWave.IsBoss()) then
                call thistype.WAIT_TIMER_DIALOG.Hide()
            else
                call thistype.WAIT_TIMER_DIALOG.SetTitle("Level " + Integer.ToString(nextLevel.GetIndex() + 1) + " begins in: ")
                call thistype.WAIT_TIMER_DIALOG.Show()

                call thistype.WAIT_TIMER.Start(thisWave.GetTypesDuration() + thisWave.GetWaitAfter() + nextWave.GetWaitBefore(), false, function thistype.EndSpawn)
            endif
        endif

        call thisWave.Run()
    endmethod

    static method StartWave takes nothing returns nothing
        call Level.CURRENT.GetNext().Start()
    endmethod

    static method Event_Start takes nothing returns nothing
        call Event.Create(Level.ENDING_EVENT_TYPE, EventPriority.MISC, function thistype.Event_LevelEnding).AddToStatics()
        call Event.Create(Level.START_EVENT_TYPE, EventPriority.MISC, function thistype.Event_LevelStart).AddToStatics()
    endmethod

    static method Init takes nothing returns nothing
        set thistype.ALL_GROUP = Group.Create()
        set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Death)
        set thistype.DUMMY_EVENT_TYPE = EventType.Create()
        set thistype.WAIT_TIMER = Timer.Create()
        call Event.Create(Act.ENDING_EVENT_TYPE, EventPriority.MISC, function thistype.Event_ActEnding).AddToStatics()
        call Event.Create(EventType.START, EventPriority.MISC, function thistype.Event_Start).AddToStatics()
        call Event.Create(Meteorite.GAME_OVER_EVENT_TYPE, EventPriority.MISC, function thistype.Event_GameOver).AddToStatics()

        set thistype.WAIT_TIMER_DIALOG = TimerDialog.CreateFromTimer(thistype.WAIT_TIMER)

        call SpawnLocation.Init()
        call SpawnType.Init()

        call SpawnWave.Init()
    endmethod
endstruct