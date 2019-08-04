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
        //! runtextmacro Event_Implement("SpawnType")
    endstruct

    //! runtextmacro Struct("Champion")
        static constant real DAMAGE_INCREMENT = 1.
        static constant real LIFE_INCREMENT = 1.
        static constant real SCALE_INCREMENT = 0.35
        static Event SPAWN_EVENT

        boolean flag

        eventMethod Event_Spawn
            local SpawnType whichType = params.SpawnType.GetTrigger()
            local Unit whichUnit = params.Unit.GetTrigger()

			call whichUnit.Armor.Spell.Add(0.25)
            call whichUnit.Abilities.AddWithLevel(MeteoriteProtection.THIS_SPELL, 2)
            //call whichUnit.Damage.Relative.Add(DAMAGE_INCREMENT)
            //call whichUnit.MaxLife.Add(thistype.LIFE_INCREMENT * whichUnit.MaxLife.Get())
            //call whichUnit.Scale.Add(thistype.SCALE_INCREMENT * whichType.whichUnitType.Scale.Get())
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

        eventMethod Event_Spawn
            local SpawnType whichType = params.SpawnType.GetTrigger()
            local Unit whichUnit = params.Unit.GetTrigger()

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
    static thistype FURBOLG
    static thistype FURBOLG_ORACLE
    static thistype GNOLL_MAGE
    static thistype KOBOLD_RED
    static thistype MOONKIN
    static thistype MOONKIN_CHAMP
    static thistype SATYR_CHAMP
    static thistype SNOW_FALCON
    static thistype TREANT_GREEN
    static thistype TREANT_PURPLE
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

        loop
            exitwhen (iteration < ARRAY_MIN)

            local thistype this = thistype.ALL[iteration]

            local UnitType whichUnitType = this.GetType()

            call whichUnitType.Speed.Add(whichUnitType.Speed.Get() * 0.75)

            if this.IsBoss() then
                call whichUnitType.Abilities.Add(MeteoriteProtection.THIS_SPELL)
            endif
            if this.IsInvis() then
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

            //Furbolg
            set this = thistype.Create(UnitType.FURBOLG_MOTHER)

            set thistype.FURBOLG = this
            call this.AddGoldCoinDrop(100)
            call this.SetMelee(true)
            call this.Champion.Set()

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

            //KoboldRed
            set this = thistype.Create(UnitType.KOBOLD_RED)

            set thistype.KOBOLD_RED = this
            call this.SetMelee(true)

            //Satyr Champ
            set this = thistype.Create(UnitType.SATYR)

            set thistype.SATYR_CHAMP = this
            call this.Champion.Set()
            call this.SetMelee(true)

            //Snow Falcon
            set this = thistype.Create(UnitType.SNOW_FALCON)

            set thistype.SNOW_FALCON = this
            call this.SetRanged(true)

            //TreantGreen
            set this = thistype.Create(UnitType.TREANT_GREEN)

            set thistype.TREANT_GREEN = this
            call this.SetMagician(true)
            call this.SetMelee(true)

            //TreantPurple
            set this = thistype.Create(UnitType.TREANT_PURPLE)

            set thistype.TREANT_PURPLE = this
            call this.SetMelee(true)

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