//! runtextmacro Folder("Order")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("Order", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("Order", "Integer", "integer")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Integer")

        //! runtextmacro Data_Implement("Order")
    endstruct

    //! runtextmacro Folder("Event")
        //! runtextmacro Struct("Native")
            //! textmacro Order_Event_Native_CreateResponse takes name, source
                static method Get$name$ takes nothing returns Order
                    return Order.GetFromSelf($source$())
                endmethod
            //! endtextmacro

            //! runtextmacro Order_Event_Native_CreateResponse("Trigger", "GetIssuedOrderId")
        endstruct
    endscope

    //! runtextmacro Struct("Event")
        //! runtextmacro LinkToStruct("Event", "Native")

        //! runtextmacro CreateAnyStaticStateDefault("TRIGGER", "Trigger", "Order", "NULL")

        //! runtextmacro Event_Implement("Order")
    endstruct
endscope

//! runtextmacro BaseStruct("Order", "ORDER")
    //! runtextmacro GetKey("KEY")

    static thistype ACID_BOMB
    static thistype ANCESTRAL_SPIRIT
    static thistype ANIMATE_DEAD
    static thistype ATTACK
    static thistype AVATAR
    static thistype BANISH
    static thistype BERSERK
    static thistype BLIZZARD
    static thistype BLOOD_LUST
    static thistype BREATH_OF_FIRE
    static thistype BREATH_OF_FROST
    static thistype CANNIBALIZE
    static thistype CARRION_SWARM
    static thistype CHAIN_LIGHTNING
    static thistype CLUSTER_ROCKETS
    static thistype CRIPPLE
    static thistype DARK_CONVERSION
    static thistype DARK_PORTAL
    static thistype DEATH_AND_DECAY
    static thistype DEATH_COIL
    static thistype DOOM
    static thistype DRUNKEN_HAZE
    static thistype EAT_TREE
    static thistype ENSNARE
    static thistype ENTANGLING_ROOTS
    static thistype EVIL_EYE
    static thistype FIREBOLT
    static thistype HEAL
    static thistype HEALING_WAVE
    static thistype HEX
    static thistype HOWL_OF_TERROR
    static thistype INFERNO
    static thistype INNER_FIRE
    static thistype LIGHTNING_SHIELD
    static thistype LOAD
    static thistype MANA_BURN
    static thistype MANA_SHIELD_ON
    static thistype MIRROR_IMAGE
    static thistype MONSOON
    static thistype MOVE
    static thistype MOVE_ITEM_TO_SLOT_0
    static thistype MOVE_ITEM_TO_SLOT_1
    static thistype MOVE_ITEM_TO_SLOT_2
    static thistype MOVE_ITEM_TO_SLOT_3
    static thistype MOVE_ITEM_TO_SLOT_4
    static thistype MOVE_ITEM_TO_SLOT_5
    static thistype PHASE_SHIFT
    static thistype PURGE
    static thistype RAISE_DEAD
    static thistype RESURRECTION
    static thistype ROAR
    static thistype SANCTUARY
    static thistype SELF_DESTRUCT
    static thistype SHOCK_WAVE
    static thistype SLEEP
    static thistype SMART
    static thistype SOULBURN
    static thistype SPIRIT_WOLF
    static thistype STAR_FALL
    static thistype STASIS_TRAP
    static thistype STOP
    static thistype STUNNED
    static thistype SUMMON_FACTORY
    static thistype SUMMON_GRIZZLY
    static thistype SUMMON_WAR_EAGLE
    static thistype TAUNT
    static thistype THUNDER_BOLT
    static thistype THUNDER_CLAP
    static thistype USE_ITEM_IN_SLOT_0
    static thistype USE_ITEM_IN_SLOT_1
    static thistype USE_ITEM_IN_SLOT_2
    static thistype USE_ITEM_IN_SLOT_3
    static thistype USE_ITEM_IN_SLOT_4
    static thistype USE_ITEM_IN_SLOT_5
    static thistype VOODOO
    static thistype WARD
    static thistype WIND_WALK

    integer self

    //! runtextmacro LinkToStruct("Order", "Data")
    //! runtextmacro LinkToStruct("Order", "Event")
    //! runtextmacro LinkToStruct("Order", "Id")

    //! runtextmacro CreateAnyState("name", "Name", "string")

    static method GetFromSelf takes integer self returns thistype
        return Memory.IntegerKeys.GetInteger(self, KEY)
    endmethod

    method GetSelf takes nothing returns integer
        return this.self
    endmethod

    method GetInventoryIndex takes nothing returns integer
        return (this - thistype.USE_ITEM_IN_SLOT_0)
    endmethod

    method IsInventoryUse takes nothing returns boolean
        return ((this >= thistype.USE_ITEM_IN_SLOT_0) and (this <= thistype.USE_ITEM_IN_SLOT_5))
    endmethod

    static method Create takes string name, integer self returns thistype
        local thistype this = thistype.allocate()

        set this.self = self
        call Memory.IntegerKeys.SetInteger(self, KEY, this)

        call this.Id.Event_Create()

        call this.SetName(name)

        return this
    endmethod

    static method Init takes nothing returns nothing
        set thistype.ACID_BOMB = thistype.Create("acid bomb", 852662)
        set thistype.ANCESTRAL_SPIRIT = thistype.Create("ancestral spirit", 852490)
        set thistype.ANIMATE_DEAD = thistype.Create("animate dead", 852217)
        set thistype.ATTACK = thistype.Create("attack", 851983)
        set thistype.AVATAR = thistype.Create("avatar", 852086)
        set thistype.BANISH = thistype.Create("banish", 852486)
        set thistype.BERSERK = thistype.Create("berserk", 852100)
        set thistype.BLIZZARD = thistype.Create("blizzard", 852089)
        set thistype.BLOOD_LUST = thistype.Create("blood lust", 852101)
        set thistype.BREATH_OF_FIRE = thistype.Create("breath of fire", 852580)
        set thistype.BREATH_OF_FROST = thistype.Create("breath of frost", 852560)
        set thistype.CANNIBALIZE = thistype.Create("cannibalize", 852188)
        set thistype.CARRION_SWARM = thistype.Create("carrion swarm", 852218)
        set thistype.CHAIN_LIGHTNING = thistype.Create("chain lightning", 852119)
        set thistype.CLUSTER_ROCKETS = thistype.Create("cluster rockets", 852652)
        set thistype.CRIPPLE = thistype.Create("cripple", 852189)
        set thistype.DARK_CONVERSION = thistype.Create("dark conversion", 852228)
        set thistype.DARK_PORTAL = thistype.Create("dark portal", 852229)
        set thistype.DEATH_AND_DECAY = thistype.Create("death and decay", 852221)
        set thistype.DEATH_COIL = thistype.Create("death coil", 852222)
        set thistype.DOOM = thistype.Create("doom", 852583)
        set thistype.DRUNKEN_HAZE = thistype.Create("drunken haze", 852585)
        set thistype.EAT_TREE = thistype.Create("eat tree", 852146)
        set thistype.ENSNARE = thistype.Create("ensnare", 852106)
        set thistype.ENTANGLING_ROOTS = thistype.Create("entangling roots", 852171)
        set thistype.EVIL_EYE = thistype.Create("evil eye", 852105)
        set thistype.FIREBOLT = thistype.Create("firebolt", 852231)
        set thistype.HEAL = thistype.Create("heal", 852063)
        set thistype.HEALING_WAVE = thistype.Create("healing wave", 852501)
        set thistype.HEX = thistype.Create("hex", 852502)
        set thistype.HOWL_OF_TERROR = thistype.Create("howl of terror", 852588)
        set thistype.INFERNO = thistype.Create("inferno", 852232)
        set thistype.INNER_FIRE = thistype.Create("inner fire", 852066)
        set thistype.LIGHTNING_SHIELD = thistype.Create("lightning shield", 852110)
        set thistype.LOAD = thistype.Create("load", 852046)
        set thistype.MANA_BURN = thistype.Create("mana burn", 852179)
        set thistype.MANA_SHIELD_ON = thistype.Create("mana shield on", 852589)
        set thistype.MIRROR_IMAGE = thistype.Create("mirror image", 852123)
        set thistype.MONSOON = thistype.Create("monsoon", 851591)
        set thistype.MOVE = thistype.Create("move", 851986)
        set thistype.MOVE_ITEM_TO_SLOT_0 = thistype.Create("move item to slot 0", 852002)
        set thistype.MOVE_ITEM_TO_SLOT_1 = thistype.Create("move item to slot 1", 852003)
        set thistype.MOVE_ITEM_TO_SLOT_2 = thistype.Create("move item to slot 2", 852004)
        set thistype.MOVE_ITEM_TO_SLOT_3 = thistype.Create("move item to slot 3", 852005)
        set thistype.MOVE_ITEM_TO_SLOT_4 = thistype.Create("move item to slot 4", 852006)
        set thistype.MOVE_ITEM_TO_SLOT_5 = thistype.Create("move item to slot 5", 852007)
        set thistype.PHASE_SHIFT = thistype.Create("phase shift", 852514)
        set thistype.PURGE = thistype.Create("purge", 852111)
        set thistype.RAISE_DEAD = thistype.Create("raise dead", 852197)
        set thistype.RESURRECTION = thistype.Create("resurrection", 852094)
        set thistype.ROAR = thistype.Create("roar", 852164)
        set thistype.SELF_DESTRUCT = thistype.Create("self destruct", 852040)
        set thistype.SANCTUARY = thistype.Create("sanctuary", 852569)
        set thistype.SHOCK_WAVE = thistype.Create("shock wave", 852125)
        set thistype.SLEEP = thistype.Create("sleep", 852227)
        set thistype.SMART = thistype.Create("smart", 851971)
        set thistype.SOULBURN = thistype.Create("soulburn", 852668)
        set thistype.SPIRIT_WOLF = thistype.Create("spirit wolf", 852126)
        set thistype.STAR_FALL = thistype.Create("star fall", 852183)
        set thistype.STASIS_TRAP = thistype.Create("stasis trap", 852114)
        set thistype.STOP = thistype.Create("stop", 851972)
        set thistype.STUNNED = thistype.Create("stunned", 851973)
        set thistype.SUMMON_FACTORY = thistype.Create("summon factory", 852658)
        set thistype.SUMMON_GRIZZLY = thistype.Create("summon grizzly", 852594)
        set thistype.SUMMON_WAR_EAGLE = thistype.Create("summon war eagle", 852596)
        set thistype.TAUNT = thistype.Create("taunt", 852520)
        set thistype.THUNDER_BOLT = thistype.Create("thunder bolt", 852095)
        set thistype.THUNDER_CLAP = thistype.Create("tunder clap", 852096)
        set thistype.USE_ITEM_IN_SLOT_0 = thistype.Create("use item in slot 0", 852008)
        set thistype.USE_ITEM_IN_SLOT_1 = thistype.Create("use item in slot 1", 852009)
        set thistype.USE_ITEM_IN_SLOT_2 = thistype.Create("use item in slot 2", 852010)
        set thistype.USE_ITEM_IN_SLOT_3 = thistype.Create("use item in slot 3", 852011)
        set thistype.USE_ITEM_IN_SLOT_4 = thistype.Create("use item in slot 4", 852012)
        set thistype.USE_ITEM_IN_SLOT_5 = thistype.Create("use item in slot 5", 852013)
        set thistype.VOODOO = thistype.Create("voodoo", 852503)
        set thistype.WARD = thistype.Create("ward", 852504)
        set thistype.WIND_WALK = thistype.Create("wind walk", 852129)
    endmethod
endstruct