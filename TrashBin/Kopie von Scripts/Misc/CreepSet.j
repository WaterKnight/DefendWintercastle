//! runtextmacro Folder("CreepLoot")
endscope

//! runtextmacro BaseStruct("CreepLoot", "CREEP_LOOT")
    static method Init takes nothing returns nothing
    endmethod
endstruct

//! runtextmacro BaseStruct("Creep", "CREEP")
    real angle
    CustomDrop whichDrop
    UnitType whichUnitType
    real x
    real y

    method AddDrop takes CustomDrop value returns nothing
        set this.whichDrop = value
    endmethod

    method Run takes real addX, real addY returns Unit
        local Unit result = Unit.Create(this.whichUnitType, User.CREEP, this.x, this.y, this.angle)
        local CustomDrop whichDrop = this.whichDrop

        if (whichDrop != NULL) then
            call result.Drop.Add(whichDrop)
        endif

        return result
    endmethod

    static method Create takes UnitType whichUnitType, unit dummy returns thistype
        local real angle = Math.DEG_TO_RAD * GetUnitFacing(dummy)
        local thistype this = thistype.allocate()
        local real x = GetUnitX(dummy)
        local real y = GetUnitY(dummy)

        call RemoveUnit(dummy)

        set this.angle = angle
        set this.whichDrop = NULL
        set this.whichUnitType = whichUnitType
        set this.x = x
        set this.y = y

        return this
    endmethod

    static method Init takes nothing returns nothing
    endmethod
endstruct

//! runtextmacro BaseStruct("CreepLocation", "CREEP_LOCATION")
    static Event DEATH_EVENT
    //! runtextmacro GetKey("KEY")

    static thistype LEFT_AIR
    static thistype LEFT_BOSS
    static thistype LEFT_MELEE
    static thistype RIGHT_BUFF
    static thistype RIGHT_DEMON
    static thistype RIGHT_MINOR

    Group currentUnitsGroup
    Ping whichPing
    Rectangle whichRect

    method GetX takes nothing returns real
        return this.whichRect.GetCenterX()
    endmethod

    method GetY takes nothing returns real
        return this.whichRect.GetCenterY()
    endmethod

    method ClearUnits takes nothing returns nothing
        local Group currentUnitsGroup = this.currentUnitsGroup
        local Unit whichUnit

        loop
            set whichUnit = currentUnitsGroup.GetFirst()
            exitwhen (whichUnit == NULL)

            call whichUnit.Kill()
        endloop
    endmethod

    static method Event_Death takes nothing returns nothing
        local Unit whichUnit = UNIT.Event.GetTrigger()

        local thistype this = whichUnit.Data.Integer.Get(KEY)

        local Group currentUnitsGroup = this.currentUnitsGroup

        call currentUnitsGroup.RemoveUnit(whichUnit)
        call whichUnit.Data.Integer.Remove(KEY)
        call whichUnit.Event.Remove(DEATH_EVENT)

        if (currentUnitsGroup.GetFirst() == NULL) then
            call this.whichPing.Destroy()
        endif
    endmethod

    method AddUnit takes Unit whichUnit returns nothing
        call this.currentUnitsGroup.AddUnit(whichUnit)
        call whichUnit.Data.Integer.Set(KEY, this)
        call whichUnit.Event.Add(DEATH_EVENT)
    endmethod

    method Start takes Ping whichPing returns nothing
        set this.whichPing = whichPing
        call whichPing.Show()
        call whichPing.Start()
    endmethod

    static method Create takes Rectangle whichRect returns thistype
        local thistype this = thistype.allocate()

        set this.currentUnitsGroup = Group.Create()
        set this.whichRect = whichRect

        return this
    endmethod

    static method Init takes nothing returns nothing
        set thistype.DEATH_EVENT = Event.Create(UNIT.Death.Events.DUMMY_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Death)

        set thistype.LEFT_AIR = thistype.Create(Rectangle.CreateFromSelf(gg_rct_Creeps_Left_Air))
        set thistype.LEFT_BOSS = thistype.Create(Rectangle.CreateFromSelf(gg_rct_Creeps_Left_Boss))
        set thistype.LEFT_MELEE = thistype.Create(Rectangle.CreateFromSelf(gg_rct_Creeps_Left_Melee))
        set thistype.RIGHT_BUFF = thistype.Create(Rectangle.CreateFromSelf(gg_rct_Creeps_Right_Buff))
        set thistype.RIGHT_DEMON = thistype.Create(Rectangle.CreateFromSelf(gg_rct_Creeps_Right_Demon))
        set thistype.RIGHT_MINOR = thistype.Create(Rectangle.CreateFromSelf(gg_rct_Creeps_Right_Minor))
    endmethod
endstruct

//! runtextmacro Folder("CreepSet")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("CreepSet", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("CreepSet", "Integer", "integer")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Integer")

        //! runtextmacro Data_Implement("CreepSet")
    endstruct

    //! runtextmacro Struct("Event")
        //! runtextmacro CreateAnyStaticStateDefault("TRIGGER", "Trigger", "CreepSet", "NULL")

        //! runtextmacro Event_Implement("CreepSet")
    endstruct
endscope

//! runtextmacro BaseStruct("CreepSet", "CREEP_SET")
    //! runtextmacro GetKeyArray("CREEP_KEY_ARRAY")
    //! runtextmacro GetKeyArray("KEY_ARRAY")
    static Event LEVEL_START_EVENT

    //Act1
    static thistype BLUE_SPAWNS
    static thistype FURBOLG_MOTHER
    static thistype KOBOLDS
    static thistype PANDARENES
    static thistype TREANTS
    static thistype WOLVES

    //Act2

    //! runtextmacro LinkToStruct("CreepSet", "Data")
    //! runtextmacro LinkToStruct("CreepSet", "Event")
    //! runtextmacro LinkToStruct("CreepSet", "Id")

    //! runtextmacro CreateAnyState("name", "Name", "string")
    //! runtextmacro CreateAnyState("whichLocation", "Location", "CreepLocation")

    method CountCreeps takes nothing returns integer
        return this.Data.Integer.Table.Count(CREEP_KEY_ARRAY)
    endmethod

    method GetCreep takes integer index returns Creep
        return this.Data.Integer.Table.Get(CREEP_KEY_ARRAY, index)
    endmethod

    method AddCreep takes Creep whichCreep returns nothing
        call this.Data.Integer.Table.Add(CREEP_KEY_ARRAY, whichCreep)
    endmethod

    method Run takes nothing returns nothing
        local integer iteration = this.Data.Integer.Table.Count(CREEP_KEY_ARRAY)
        local Creep whichCreep
        local CreepLocation whichLocation = this.GetLocation()
        local PingColor whichPingColor = PingColor.RandomUnused()

        local real centerX = whichLocation.GetX()
        local real centerY = whichLocation.GetY()

        local Ping whichPing = Ping.Create(centerX, centerY, whichPingColor)

        call whichLocation.ClearUnits()

        if (whichPingColor == NULL) then
            call Game.DisplayTextTimed(User.ANY, String.Color.Do(this.GetName(), String.Color.GOLD) + " has/have spawned.", 10.)
        else
            call Game.DisplayTextTimed(User.ANY, String.Color.Do(this.GetName(), String.Color.GOLD) + " has/have spawned at the " + whichPingColor.GetName() + " spot.", 10.)
        endif

        call whichLocation.Start(whichPing)

        loop
            set whichCreep = this.Data.Integer.Table.Get(CREEP_KEY_ARRAY, iteration)

            call whichLocation.AddUnit(whichCreep.Run(centerX, centerY))

            set iteration = iteration - 1
            exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
        endloop
    endmethod

    static method Event_Warning_LevelStart takes nothing returns nothing
        local integer count
        local integer iteration
        local string msg
        local Level whichLevel = LEVEL.Event.GetTrigger().GetNext()

        if (whichLevel == NULL) then
            return
        endif

        set count = whichLevel.Data.Integer.Table.Count(KEY_ARRAY)

        if (count < Memory.IntegerKeys.Table.STARTED) then
            return
        endif

        set iteration = count
        set msg = ""

        loop
            if (iteration != count) then
                if (iteration == Memory.IntegerKeys.Table.STARTED) then
                    set msg = msg + " and "
                else
                    set msg = msg + ", "
                endif
            endif

            set msg = msg + String.Color.Do(thistype(whichLevel.Data.Integer.Table.Get(KEY_ARRAY, iteration)).GetName(), String.Color.GOLD)

            set iteration = iteration - 1
            exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
        endloop

        call Game.DisplayTextTimed(User.ANY, String.Color.Do("Notification:", String.Color.GOLD) + " Next level features the creeps " + msg + ".", 10.)
    endmethod

    static method Event_LevelStart takes nothing returns nothing
        local Level whichLevel = LEVEL.Event.GetTrigger()

        local integer iteration = whichLevel.Data.Integer.Table.Count(KEY_ARRAY)

        loop
            call thistype(whichLevel.Data.Integer.Table.Get(KEY_ARRAY, iteration)).Run()

            set iteration = iteration - 1
            exitwhen (iteration < Memory.IntegerKeys.Table.STARTED)
        endloop
    endmethod

    static method CountAtLevel takes Level whichLevel returns thistype
        return whichLevel.Data.Integer.Table.Count(KEY_ARRAY)
    endmethod

    static method GetFromLevel takes Level whichLevel, integer index returns thistype
        return whichLevel.Data.Integer.Table.Get(KEY_ARRAY, index)
    endmethod

    method AttachToLevel takes Level whichLevel returns nothing
        if (whichLevel.Data.Integer.Table.Add(KEY_ARRAY, this)) then
            call whichLevel.Event.Add(LEVEL_START_EVENT)
        endif
    endmethod

    static method Create takes string name, CreepLocation whichLocation returns thistype
        local thistype this = thistype.allocate()

        call this.SetLocation(whichLocation)
        call this.SetName(name)

        call this.Id.Event_Create()

        return this
    endmethod

    static method Init takes nothing returns nothing
        local thistype this

        call Creep.Init()
        call CreepLocation.Init()
        call CreepLoot.Init()

        set thistype.LEVEL_START_EVENT = Event.Create(Level.START_EVENT_TYPE, EventPriority.MISC, function thistype.Event_LevelStart)
        call Event.Create(Level.START_EVENT_TYPE, EventPriority.MISC, function thistype.Event_Warning_LevelStart).AddToStatics()

        //Act1
            //Blue Spawns
            set this = thistype.Create("Blue Dragon Spawns", CreepLocation.LEFT_AIR)

            set thistype.BLUE_SPAWNS = this
            call this.AddCreep(Creep.Create(UnitType.BLUE_DRAGON_SPAWN, gg_unit_nadw_0081))
            call this.AddCreep(Creep.Create(UnitType.BLUE_DRAGON_SPAWN, gg_unit_nadw_0117))
            call this.AddCreep(Creep.Create(UnitType.TUSKAR, gg_unit_ntka_0112))
            call this.AddCreep(Creep.Create(UnitType.TUSKAR, gg_unit_ntkf_0099))
            call this.AttachToLevel(Level.TROLLS)

            //Furbolg Mother
            set this = thistype.Create("Furbolg Mother", CreepLocation.LEFT_BOSS)

            set thistype.FURBOLG_MOTHER = this
            call this.AddCreep(Creep.Create(UnitType.FURBOLG_MOTHER, gg_unit_nfrg_0110))
            call this.AddCreep(Creep.Create(UnitType.KOBOLD_BROWN, gg_unit_nkob_0115))
            call this.AddCreep(Creep.Create(UnitType.KOBOLD_BROWN, gg_unit_nkob_0116))
            call this.AttachToLevel(Level.GNOLLS)

            //Kobolds
            set this = thistype.Create("Kobolds", CreepLocation.RIGHT_MINOR)

            set thistype.TREANTS = this
            call this.AddCreep(Creep.Create(UnitType.KOBOLD_BLUE, gg_unit_nkog_0102))
            call this.AddCreep(Creep.Create(UnitType.KOBOLD_BLUE, gg_unit_nkog_0124))
            call this.AddCreep(Creep.Create(UnitType.KOBOLD_RED, gg_unit_nkot_0113))
            call this.AddCreep(Creep.Create(UnitType.KOBOLD_RED, gg_unit_nkot_0114))
            call this.AttachToLevel(Level.GNOLLS)

            //Pandarenes
            set this = thistype.Create("Pandarenes", CreepLocation.LEFT_MELEE)

            set thistype.PANDARENES = this
            call this.AddCreep(Creep.Create(UnitType.PANDARENE, gg_unit_nfrp_0079))
            call this.AddCreep(Creep.Create(UnitType.PANDARENE, gg_unit_nfrp_0083))
            call this.AttachToLevel(Level.GNOLLS)

            //Treants
            set this = thistype.Create("Treants", CreepLocation.RIGHT_DEMON)

            set thistype.TREANTS = this
            call this.AddCreep(Creep.Create(UnitType.TREANT_GREEN, gg_unit_uTrP_0133))
            call this.AddCreep(Creep.Create(UnitType.TREANT_GREEN, gg_unit_uTrP_0134))
            call this.AddCreep(Creep.Create(UnitType.TREANT_PURPLE, gg_unit_uTrG_0132))
            call this.AttachToLevel(Level.GNOLLS)

            //Wolves
            set this = thistype.Create("Wolves", CreepLocation.RIGHT_BUFF)

            set thistype.WOLVES = this
            call this.AddCreep(Creep.Create(UnitType.WOLF, gg_unit_nwwf_0097))
            call this.AddCreep(Creep.Create(UnitType.WOLF, gg_unit_nwwf_0123))
            call this.AddCreep(Creep.Create(UnitType.WOLF_MOTHER, gg_unit_nwwd_0122))
            call this.AttachToLevel(Level.GNOLLS)
        //Act2
    endmethod
endstruct