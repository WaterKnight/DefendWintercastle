//! runtextmacro Folder("UnitType")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Folder("Boolean")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("UnitType", "Boolean", "boolean")
            endstruct
        endscope

        //! runtextmacro Struct("Boolean")
            //! runtextmacro LinkToStruct("Boolean", "Table")

            //! runtextmacro Data_Type_Implement("UnitType", "Boolean", "boolean")

            //! runtextmacro Data_Boolean_Implement("UnitType")
        endstruct

        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("UnitType", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("UnitType", "Integer", "integer")
        endstruct

        //! runtextmacro Folder("Real")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("UnitType", "Real", "real")
            endstruct
        endscope

        //! runtextmacro Struct("Real")
            //! runtextmacro LinkToStruct("Real", "Table")

            //! runtextmacro Data_Type_Implement("UnitType", "Real", "real")
        endstruct

        //! runtextmacro Folder("String")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("UnitType", "String", "string")
            endstruct
        endscope

        //! runtextmacro Struct("String")
            //! runtextmacro LinkToStruct("String", "Table")

            //! runtextmacro Data_Type_Implement("UnitType", "String", "string")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Boolean")
        //! runtextmacro LinkToStruct("Data", "Integer")
        //! runtextmacro LinkToStruct("Data", "Real")
        //! runtextmacro LinkToStruct("Data", "String")

        //! runtextmacro Data_Implement("UnitType")
    endstruct

    //! runtextmacro Struct("Event")
        //! runtextmacro CreateAnyStaticStateDefault("SOURCE", "Source", "UnitType", "NULL")
        //! runtextmacro CreateAnyStaticStateDefault("TRIGGER", "Trigger", "UnitType", "NULL")

        //! runtextmacro Event_Implement("UnitType")
    endstruct

    //! runtextmacro Folder("Abilities")
        //! runtextmacro Struct("ArrayBuild")
            //! runtextmacro GetKeyArray("KEY_ARRAY")
            //! runtextmacro GetKeyArray("LEVEL_KEY_ARRAY_DETAIL")

            method Count takes nothing returns integer
                return UnitType(this).Data.Integer.Table.Count(KEY_ARRAY)
            endmethod

            method Get takes integer index returns Spell
                return UnitType(this).Data.Integer.Table.Get(KEY_ARRAY, index)
            endmethod

            method GetLevel takes Spell whichSpell returns integer
                return UnitType(this).Data.Integer.Get(LEVEL_KEY_ARRAY_DETAIL + whichSpell)
            endmethod

            method Add takes Spell whichSpell, integer level returns nothing
                call UnitType(this).Data.Integer.Table.Add(KEY_ARRAY, whichSpell)
                call UnitType(this).Data.Integer.Set(LEVEL_KEY_ARRAY_DETAIL + whichSpell, level)
            endmethod

            method Event_Create takes nothing returns nothing
            endmethod
        endstruct

        //! runtextmacro Struct("Hero")
            //! runtextmacro GetKeyArray("KEY_ARRAY_DETAIL")
            integer valuesCount

            method Count takes nothing returns integer
                return this.valuesCount
            endmethod

            method Get takes integer index returns Spell
                return UnitType(this).Data.Integer.Get(KEY_ARRAY_DETAIL + index)
            endmethod

            method Add takes Spell whichSpell returns nothing
                local integer valuesCount = this.valuesCount + 1

                set this.valuesCount = valuesCount
                call UnitType(this).Data.Integer.Set(KEY_ARRAY_DETAIL + valuesCount, whichSpell)
            endmethod

            method Add4 takes Spell first, Spell second, Spell third, Spell fourth returns nothing
                if (first != NULL) then
                    call this.Add(first)
                endif

                if (second != NULL) then
                    call this.Add(second)
                endif

                if (third != NULL) then
                    call this.Add(third)
                endif

                if (fourth != NULL) then
                    call this.Add(fourth)
                endif
            endmethod

            method Event_Create takes nothing returns nothing
                set this.valuesCount = ARRAY_EMPTY
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Abilities")
        //! runtextmacro LinkToStruct("Abilities", "ArrayBuild")
        //! runtextmacro LinkToStruct("Abilities", "Hero")

        method Count takes nothing returns integer
            return this.ArrayBuild.Count()
        endmethod

        method Get takes integer index returns Spell
            return this.ArrayBuild.Get(index)
        endmethod

        method GetLevel takes integer index returns integer
            return this.ArrayBuild.GetLevel(index)
        endmethod

        method Add takes Spell whichSpell returns nothing
            call this.ArrayBuild.Add(whichSpell, 1)
        endmethod

        method AddWithLevel takes Spell whichSpell, integer level returns nothing
            call this.ArrayBuild.Add(whichSpell, level)
        endmethod

        method Event_Create takes nothing returns nothing
            call this.ArrayBuild.Event_Create()
            call this.Hero.Event_Create()
        endmethod
    endstruct

    //! runtextmacro Folder("Armor")
        //! runtextmacro Struct("Type")
            //! runtextmacro CreateSimpleAddState("integer", "0")
        endstruct
    endscope

    //! runtextmacro Struct("Armor")
        //! runtextmacro LinkToStruct("Armor", "Type")

        //! runtextmacro CreateSimpleAddState_NotStart("real")

        method Event_Create takes nothing returns nothing
            call this.Set(0.)

            call this.Type.Event_Create()
        endmethod
    endstruct

    //! runtextmacro Struct("Attachments")
        //! runtextmacro GetKeyArray("ATTACH_POINT_KEY_ARRAY")
        //! runtextmacro GetKeyArray("LEVEL_KEY_ARRAY")
        //! runtextmacro GetKeyArray("PATH_KEY_ARRAY")

        method Count takes nothing returns integer
            return UnitType(this).Data.String.Table.Count(PATH_KEY_ARRAY)
        endmethod

        method GetAttachPoint takes integer index returns string
            return UnitType(this).Data.String.Table.Get(ATTACH_POINT_KEY_ARRAY, index)
        endmethod

        method GetLevel takes integer index returns EffectLevel
            return UnitType(this).Data.Integer.Table.Get(LEVEL_KEY_ARRAY, index)
        endmethod

        method GetPath takes integer index returns string
            return UnitType(this).Data.String.Table.Get(PATH_KEY_ARRAY, index)
        endmethod

        method Add takes string path, string attachPoint, EffectLevel level returns nothing
            call UnitType(this).Data.String.Table.Add(ATTACH_POINT_KEY_ARRAY, attachPoint)
            call UnitType(this).Data.Integer.Table.Add(LEVEL_KEY_ARRAY, level)
            call UnitType(this).Data.String.Table.Add(PATH_KEY_ARRAY, path)
        endmethod
    endstruct

    //! runtextmacro Folder("Attack")
        //! runtextmacro Folder("Missile")
            //! runtextmacro Struct("Speed")
                //! runtextmacro CreateSimpleAddState("real", "0.")
            endstruct
        endscope

        //! runtextmacro Struct("Missile")
            //! runtextmacro LinkToStruct("Missile", "Speed")

            method Event_Create takes nothing returns nothing
                call this.Speed.Event_Create()
            endmethod
        endstruct

        //! runtextmacro Struct("Range")
            //! runtextmacro CreateSimpleAddState("real", "0.")
        endstruct

        //! runtextmacro Struct("Speed")
            //! runtextmacro CreateSimpleAddState("real", "0.")

            method SetByCooldown takes real cooldown returns nothing
                call this.Set(1. / cooldown)
            endmethod
        endstruct

        //! runtextmacro Folder("Splash")
            //! runtextmacro Struct("TargetFlag")
                //! runtextmacro GetKeyArray("KEY_ARRAY_DETAIL")

                method Is takes integer whichFlag returns boolean
                    return UnitType(this).Data.Boolean.Get(KEY_ARRAY_DETAIL + whichFlag)
                endmethod

                method Add takes integer whichFlag returns nothing
                    call UnitType(this).Data.Boolean.Add(KEY_ARRAY_DETAIL + whichFlag)
                endmethod
            endstruct
        endscope

        //! runtextmacro Struct("Splash")
            //! runtextmacro GetKeyArray("AREA_RANGE_KEY_ARRAY")
            //! runtextmacro GetKeyArray("DAMAGE_KEY_ARRAY")

            //! runtextmacro LinkToStruct("Splash", "TargetFlag")

            method Count takes nothing returns integer
                return UnitType(this).Data.Real.Table.Count(AREA_RANGE_KEY_ARRAY)
            endmethod

            method GetAreaRange takes integer index returns real
                return UnitType(this).Data.Real.Table.Get(AREA_RANGE_KEY_ARRAY, index)
            endmethod

            method GetDamageFactor takes integer index returns real
                return UnitType(this).Data.Real.Table.Get(DAMAGE_KEY_ARRAY, index)
            endmethod

            method Add takes real areaRange, real damageFactor returns nothing
                call UnitType(this).Data.Real.Table.Add(AREA_RANGE_KEY_ARRAY, areaRange)
                call UnitType(this).Data.Real.Table.Add(DAMAGE_KEY_ARRAY, damageFactor)
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Attack")
        //! runtextmacro LinkToStruct("Attack", "Missile")
        //! runtextmacro LinkToStruct("Attack", "Range")
        //! runtextmacro LinkToStruct("Attack", "Speed")
        //! runtextmacro LinkToStruct("Attack", "Splash")

        //! runtextmacro CreateSimpleAddState_NotStart("Attack")

        method Event_Create takes nothing returns nothing
            set this.value = NULL

            call this.Missile.Event_Create()
            call this.Range.Event_Create()
            call this.Speed.Event_Create()
        endmethod
    endstruct

    //! runtextmacro Struct("Blood")
        //! runtextmacro CreateSimpleAddState_NotAdd("string", "null")
    endstruct

    //! runtextmacro Struct("BloodExplosion")
        //! runtextmacro CreateSimpleAddState_NotAdd("string", "null")
    endstruct

    //! runtextmacro Struct("Classes")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        method Count takes nothing returns integer
            return UnitType(this).Data.Integer.Table.Count(KEY_ARRAY)
        endmethod

        method Get takes integer index returns UnitClass
            return UnitType(this).Data.Integer.Table.Get(KEY_ARRAY, index)
        endmethod

        method Add takes UnitClass value returns nothing
            call UnitType(this).Data.Integer.Table.Add(KEY_ARRAY, value)
        endmethod
    endstruct

    //! runtextmacro Struct("CollisionSize")
        //! runtextmacro CreateSimpleAddState("real", "0.")

        method SetByScale takes real value, real scale returns nothing
            call this.Set(value / scale)
        endmethod
    endstruct

    //! runtextmacro Folder("Damage")
        //! runtextmacro Struct("Delay")
            //! runtextmacro CreateSimpleAddState("real", "0.")
        endstruct

        //! runtextmacro Struct("Dices")
            //! runtextmacro CreateSimpleAddState("integer", "0")
        endstruct

        //! runtextmacro Struct("Sides")
            //! runtextmacro CreateSimpleAddState("integer", "0")
        endstruct

        //! runtextmacro Struct("Type")
            //! runtextmacro CreateSimpleAddState("integer", "-1")
        endstruct
    endscope

    //! runtextmacro Struct("Damage")
        //! runtextmacro LinkToStruct("Damage", "Delay")
        //! runtextmacro LinkToStruct("Damage", "Dices")
        //! runtextmacro LinkToStruct("Damage", "Sides")
        //! runtextmacro LinkToStruct("Damage", "Type")

        //! runtextmacro CreateAnyState("valueBJ", "BJ", "real")

        //! runtextmacro CreateSimpleAddState_NotStart("real")

        method Event_Create takes nothing returns nothing
            call this.Set(0.)

            call this.Delay.Event_Create()
            call this.Dices.Event_Create()
            call this.Sides.Event_Create()
            call this.Type.Event_Create()
        endmethod
    endstruct

    //! runtextmacro Folder("Decay")
        //! runtextmacro Struct("Duration")
            //! runtextmacro CreateSimpleAddState("real", "10.")
        endstruct
    endscope

    //! runtextmacro Struct("Decay")
        //! runtextmacro LinkToStruct("Decay", "Duration")

        //! runtextmacro CreateSimpleFlagState_NotStart()

        method Event_Create takes nothing returns nothing
            call this.Set(true)

            call this.Duration.Event_Create()
        endmethod
    endstruct

    //! runtextmacro Folder("Drop")
        //! runtextmacro Struct("Exp")
            //! runtextmacro CreateSimpleAddState("integer", "0")
        endstruct

        //! runtextmacro Struct("Supply")
            //! runtextmacro CreateSimpleAddState("integer", "0")
        endstruct
    endscope

    //! runtextmacro Struct("Drop")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro LinkToStruct("Drop", "Exp")
        //! runtextmacro LinkToStruct("Drop", "Supply")

        method Count takes nothing returns integer
            return UnitType(this).Data.Integer.Table.Count(KEY_ARRAY)
        endmethod

        method Get takes integer index returns Drop
            return UnitType(this).Data.Integer.Table.Get(KEY_ARRAY, index)
        endmethod

        method Add takes Drop whichDrop returns nothing
            call UnitType(this).Data.Integer.Table.Add(KEY_ARRAY, whichDrop)
        endmethod

        method Event_Create takes nothing returns nothing
            call this.Exp.Event_Create()
            call this.Supply.Event_Create()
        endmethod
    endstruct

    //! runtextmacro Folder("Impact")
        //! runtextmacro Struct("Z")
            static constant real STANDARD = 60.

            //! runtextmacro CreateSimpleAddState("real", "STANDARD")
        endstruct
    endscope

    //! runtextmacro Struct("Impact")
        //! runtextmacro LinkToStruct("Impact", "Z")

        method Event_Create takes nothing returns nothing
            call this.Z.Event_Create()
        endmethod
    endstruct

    //! runtextmacro Folder("Outpact")
        //! runtextmacro Struct("Z")
            static constant real STANDARD = 60.

            //! runtextmacro CreateSimpleAddState("real", "STANDARD")
        endstruct
    endscope

    //! runtextmacro Struct("Outpact")
        //! runtextmacro LinkToStruct("Outpact", "Z")

        method Event_Create takes nothing returns nothing
            call this.Z.Event_Create()
        endmethod
    endstruct

    //! runtextmacro Struct("Life")
        static constant real BLACK_DISPLAY = 150000.

        //! runtextmacro CreateAnyState("valueBJ", "BJ", "real")

        //! runtextmacro CreateSimpleAddState("real", "0.")
    endstruct

    //! runtextmacro Struct("LifeRegeneration")
        //! runtextmacro CreateSimpleAddState("real", "0.")
    endstruct

    //! runtextmacro Struct("Mana")
        //! runtextmacro CreateAnyState("valueBJ", "BJ", "real")

        //! runtextmacro CreateSimpleAddState("real", "0.")
    endstruct

    //! runtextmacro Struct("ManaRegeneration")
        //! runtextmacro CreateSimpleAddState("real", "0.")
    endstruct

    //! runtextmacro Struct("Preload")
        method Event_Create takes nothing returns nothing
            local unit dummyUnit = CreateUnit(User.DUMMY.self, UnitType(this).self, 0., 0., 0.)

            call KillUnit(dummyUnit)

            call RemoveUnit(dummyUnit)

            set dummyUnit = null
        endmethod
    endstruct

    //! runtextmacro Struct("Revivalable")
        //! runtextmacro CreateSimpleFlagState("true")
    endstruct

    //! runtextmacro Struct("Scale")
        //! runtextmacro CreateSimpleAddState("real", "1.")
    endstruct

    //! runtextmacro Struct("SightRange")
        //! runtextmacro CreateAnyState("valueBJ", "BJ", "real")

        //! runtextmacro CreateSimpleAddState_NotAdd("real", "800.")
    endstruct

    //! runtextmacro Struct("Speed")
        //! runtextmacro CreateSimpleAddState("real", "0.")
    endstruct

    //! runtextmacro Struct("SpellPower")
        //! runtextmacro CreateSimpleAddState("real", "0.")
    endstruct

    //! runtextmacro Folder("VertexColor")
        //! runtextmacro Struct("Red")
            //! runtextmacro CreateSimpleAddState("real", "255.")
        endstruct

        //! runtextmacro Struct("Green")
            //! runtextmacro CreateSimpleAddState("real", "255.")
        endstruct

        //! runtextmacro Struct("Blue")
            //! runtextmacro CreateSimpleAddState("real", "255.")
        endstruct

        //! runtextmacro Struct("Alpha")
            //! runtextmacro CreateSimpleAddState("real", "255.")
        endstruct
    endscope

    //! runtextmacro Struct("VertexColor")
        //! runtextmacro LinkToStruct("VertexColor", "Red")
        //! runtextmacro LinkToStruct("VertexColor", "Green")
        //! runtextmacro LinkToStruct("VertexColor", "Blue")
        //! runtextmacro LinkToStruct("VertexColor", "Alpha")

        method Set takes real red, real green, real blue, real alpha returns nothing
            call this.Red.Set(red)
            call this.Green.Set(green)
            call this.Blue.Set(blue)
            call this.Alpha.Set(alpha)
        endmethod

        method Event_Create takes nothing returns nothing
            call this.Red.Event_Create()
            call this.Green.Event_Create()
            call this.Blue.Event_Create()
            call this.Alpha.Event_Create()
        endmethod
    endstruct

    //! runtextmacro Folder("Hero")
        //! runtextmacro Struct("PrimaryAttribute")

            static constant integer AGILITY = 1
            static constant integer INTELLIGENCE = 2
            static constant integer STRENGTH = 3

            //! runtextmacro CreateSimpleAddState("integer", "0")
        endstruct

        //! runtextmacro Folder("Agility")
            //! runtextmacro Struct("PerLevel")
                //! runtextmacro CreateSimpleAddState("real", "0.")
            endstruct
        endscope

        //! runtextmacro Struct("Agility")
            //! runtextmacro LinkToStruct("Agility", "PerLevel")

            //! runtextmacro CreateSimpleAddState_NotStart("real")

            method Event_Create takes nothing returns nothing
                call this.Set(0.)

                call this.PerLevel.Event_Create()
            endmethod
        endstruct

        //! runtextmacro Struct("ArmorPerLevel")
            //! runtextmacro CreateSimpleAddState("real", "0.")
        endstruct

        //! runtextmacro Folder("Intelligence")
            //! runtextmacro Struct("PerLevel")
                //! runtextmacro CreateSimpleAddState("real", "0.")
            endstruct
        endscope

        //! runtextmacro Struct("Intelligence")
            //! runtextmacro LinkToStruct("Intelligence", "PerLevel")

            //! runtextmacro CreateSimpleAddState_NotStart("real")

            method Event_Create takes nothing returns nothing
                call this.Set(0.)

                call this.PerLevel.Event_Create()
            endmethod
        endstruct

        //! runtextmacro Folder("Strength")
            //! runtextmacro Struct("PerLevel")
                //! runtextmacro CreateSimpleAddState("real", "0.")
            endstruct
        endscope

        //! runtextmacro Struct("Strength")
            //! runtextmacro LinkToStruct("Strength", "PerLevel")

            //! runtextmacro CreateSimpleAddState_NotStart("real")

            method Event_Create takes nothing returns nothing
                call this.Set(0.)

                call this.PerLevel.Event_Create()
            endmethod
        endstruct
    endscope

    //! runtextmacro Struct("Hero")
        //! runtextmacro LinkToStruct("Hero", "Agility")
        //! runtextmacro LinkToStruct("Hero", "ArmorPerLevel")
        //! runtextmacro LinkToStruct("Hero", "Intelligence")
        //! runtextmacro LinkToStruct("Hero", "PrimaryAttribute")
        //! runtextmacro LinkToStruct("Hero", "Strength")

        method Event_Create takes nothing returns nothing
            call this.Agility.Event_Create()
            call this.ArmorPerLevel.Event_Create()
            call this.Intelligence.Event_Create()
            call this.PrimaryAttribute.Event_Create()
            call this.Strength.Event_Create()
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("UnitType", "UNIT_TYPE")
    //! runtextmacro GetKey("KEY")
    static thistype TEMP

    // Heroes
    static constant real HEROES_ARMOR_BASE = 0.

    static thistype ARURUW
    static thistype DRAKUL
    static thistype KERA
    static thistype JOTA
    static thistype LIZZY
    static thistype ROCKETEYE
    static thistype SMOKEALOT
    static thistype STORMY
    static thistype TAJRAN

    // Spawns
        //Bonus
        static thistype FLYING_PENGUIN_BONUS
        static thistype PENGUIN_BONUS
        static thistype PENGUIN_CHAMP_BONUS

        //Act1
        static thistype DEER
        static thistype FURBOLG_ORACLE
        static thistype GNOLL_MAGE
        static thistype MOONKIN
        static thistype SATYR
        static thistype SNOW_FALCON
        static thistype TROLL
        static thistype TROLL_PRIEST
        static thistype WOLF

            //Creeps
            static thistype BLUE_DRAGON_SPAWN
            static thistype FURBOLG_MOTHER
            static thistype KOBOLD_BROWN
            static thistype KOBOLD_BLUE
            static thistype KOBOLD_RED
            static thistype PANDARENE
            static thistype TREANT_GREEN
            static thistype TREANT_PURPLE
            static thistype TUSKAR
            static thistype WOLF_MOTHER

        //Act2
        static thistype ASSASSIN
        static thistype AXE_FIGHTER
        static thistype BALDUIR
        static thistype CATAPULT
        static thistype DEMOLISHER
        static thistype DRUMMER
        static thistype LEADER
        static thistype NAGAROSH
        static thistype PEON
        static thistype RAIDER
        static thistype SPEAR_SCOUT
        static thistype TAROG
        static thistype TRUE_LEADER

    // Summons
    static thistype ARCTIC_WOLF
    static thistype ARCTIC_WOLF2
    static thistype ARCTIC_WOLF3
    static thistype BARRIER
    static thistype BARRIER2
    static thistype BARRIER3
    static thistype BARRIER4
    static thistype BARRIER5
    static thistype COBRA_LILY
    static thistype COBRA_LILY2
    static thistype COBRA_LILY3
    static thistype COBRA_LILY4
    static thistype COBRA_LILY5
    static thistype DESCENDANT
    static thistype DESCENDANT2
    static thistype DESCENDANT3
    static thistype DESCENDANT4
    static thistype DESCENDANT5
    static thistype EYE_OF_THE_FLAME
    static thistype GHOST_SWORD
    static thistype GHOST_SWORD2
    static thistype GHOST_SWORD3
    static thistype GHOST_SWORD4
    static thistype GHOST_SWORD5
    static thistype POLAR_BEAR
    static thistype POLAR_BEAR2
    static thistype POLAR_BEAR3
    static thistype POLAR_BEAR4
    static thistype POLAR_BEAR5
    static thistype SERPENT_WARD
    static thistype SPIRIT_WOLF
    static thistype TRAP_MINE

    // Other
    static thistype BASE_TOWER
    static thistype DARK_TOWER
    static thistype DARK_TOWER2
    static thistype FOUNTAIN
    static thistype FROST_TOWER
    static thistype FROST_TOWER2
    static thistype GARBAGE_COLLECTOR
    static thistype LIBRARY
    static thistype LIGHTNING_TOWER
    static thistype LIGHTNING_TOWER2
    static thistype METEORITE
    static thistype PENGUIN
    static thistype PENGUIN_LYING
    static thistype PHARMACY
    static thistype RESERVOIR
    static thistype RIDE_SHOP
    static thistype ROSA
    static thistype SNOWMAN
    static thistype TAVERN
    static thistype TOWER
    static thistype VICTOR

        //DefenderSpawns
        static thistype SWORDSMAN
        static thistype VICAR

    string combatFlags
    integer self

    //! runtextmacro LinkToStruct("UnitType", "Abilities")
    //! runtextmacro LinkToStruct("UnitType", "Armor")
    //! runtextmacro LinkToStruct("UnitType", "Attachments")
    //! runtextmacro LinkToStruct("UnitType", "Attack")
    //! runtextmacro LinkToStruct("UnitType", "Blood")
    //! runtextmacro LinkToStruct("UnitType", "BloodExplosion")
    //! runtextmacro LinkToStruct("UnitType", "Classes")
    //! runtextmacro LinkToStruct("UnitType", "CollisionSize")
    //! runtextmacro LinkToStruct("UnitType", "Damage")
    //! runtextmacro LinkToStruct("UnitType", "Data")
    //! runtextmacro LinkToStruct("UnitType", "Decay")
    //! runtextmacro LinkToStruct("UnitType", "Drop")
    //! runtextmacro LinkToStruct("UnitType", "Event")
    //! runtextmacro LinkToStruct("UnitType", "Hero")
    //! runtextmacro LinkToStruct("UnitType", "Id")
    //! runtextmacro LinkToStruct("UnitType", "Impact")
    //! runtextmacro LinkToStruct("UnitType", "Life")
    //! runtextmacro LinkToStruct("UnitType", "LifeRegeneration")
    //! runtextmacro LinkToStruct("UnitType", "Mana")
    //! runtextmacro LinkToStruct("UnitType", "ManaRegeneration")
    //! runtextmacro LinkToStruct("UnitType", "Outpact")
    //! runtextmacro LinkToStruct("UnitType", "Preload")
    //! runtextmacro LinkToStruct("UnitType", "Revivalable")
    //! runtextmacro LinkToStruct("UnitType", "Scale")
    //! runtextmacro LinkToStruct("UnitType", "SightRange")
    //! runtextmacro LinkToStruct("UnitType", "Speed")
    //! runtextmacro LinkToStruct("UnitType", "SpellPower")
    //! runtextmacro LinkToStruct("UnitType", "VertexColor")

    static method GetFromSelf takes integer self returns thistype
        return Memory.IntegerKeys.GetInteger(self, KEY)
    endmethod

    method GetName takes nothing returns string
        return GetObjectName(this.self)
    endmethod

    method GetSelf takes nothing returns integer
        return this.self
    endmethod

    static method Finalize takes nothing returns nothing
        local integer iteration = thistype.ALL_COUNT
        local thistype this

        loop
            set this = thistype.ALL[iteration]

            if (String.Find(this.combatFlags, "air", 0) > -1) then
                call this.Classes.Add(UnitClass.AIR)
            endif
            if (String.Find(this.combatFlags, "ground", 0) > -1) then
                call this.Classes.Add(UnitClass.GROUND)
            endif

            set iteration = iteration - 1
            exitwhen (iteration < ARRAY_MIN)
        endloop
    endmethod

    static method Create takes integer self returns thistype
        local thistype this = thistype.allocate()

        set this.combatFlags = null
        set this.self = self
        call Memory.IntegerKeys.SetInteger(self, KEY, this)

        call this.Abilities.Event_Create()
        call this.Armor.Event_Create()
        call this.Attack.Event_Create()
        call this.Blood.Event_Create()
        call this.BloodExplosion.Event_Create()
        call this.CollisionSize.Event_Create()
        call this.Damage.Event_Create()
        call this.Decay.Event_Create()
        call this.Drop.Event_Create()
        call this.Hero.Event_Create()
        call this.Id.Event_Create()
        call this.Impact.Event_Create()
        call this.Life.Event_Create()
        call this.LifeRegeneration.Event_Create()
        call this.Mana.Event_Create()
        call this.ManaRegeneration.Event_Create()
        call this.Preload.Event_Create()
        call this.Outpact.Event_Create()
        call this.Revivalable.Event_Create()
        call this.Scale.Event_Create()
        call this.Speed.Event_Create()
        call this.SpellPower.Event_Create()
        call this.VertexColor.Event_Create()

        call this.AddToList()

        return this
    endmethod

    static method Event_Start takes nothing returns nothing
        //Heroes
        call thistype.ARURUW.Abilities.Hero.Add4(Zodiac.THIS_SPELL, HopNDrop.THIS_SPELL, ArcticWolf.THIS_SPELL, Susanoo.THIS_SPELL)
        call thistype.DRAKUL.Abilities.Hero.Add4(EmphaticBite.THIS_SPELL, Infection.THIS_SPELL, RigorMortis.THIS_SPELL, Amaterasu.THIS_SPELL)
        call thistype.JOTA.Abilities.Hero.Add4(WaterBindings.THIS_SPELL, GarmentsOfTheSalamander.THIS_SPELL, NegationWave.THIS_SPELL, Tsukuyomi.THIS_SPELL)
        call thistype.KERA.Abilities.Hero.Add4(RazorBlade.THIS_SPELL, WanShroud.THIS_SPELL, Doppelganger.THIS_SPELL, Susanoo.THIS_SPELL)
        call thistype.LIZZY.Abilities.Hero.Add4(ManaLaser.THIS_SPELL, Crippling.THIS_SPELL, FairysTears.THIS_SPELL, Tsukuyomi.THIS_SPELL)
        call thistype.ROCKETEYE.Abilities.Hero.Add4(BattleRage.THIS_SPELL, SummonPolarBear.THIS_SPELL, Avatar.THIS_SPELL, Amaterasu.THIS_SPELL)
        call thistype.SMOKEALOT.Abilities.Hero.Add4(TempestStrike.THIS_SPELL, DeprivingShock.THIS_SPELL, RelentlessShiver.THIS_SPELL, Susanoo.THIS_SPELL)
        call thistype.STORMY.Abilities.Hero.Add4(SleepingDraft.THIS_SPELL, SakeBomb.THIS_SPELL, PandaPaw.THIS_SPELL, Amaterasu.THIS_SPELL)
        call thistype.TAJRAN.Abilities.Hero.Add4(KhakiRecovery.THIS_SPELL, HandOfNature.THIS_SPELL, Bubble.THIS_SPELL, Tsukuyomi.THIS_SPELL)

        //Spawns
            //Act1
            call thistype.FURBOLG_ORACLE.Abilities.Add(FuzzyAttack.THIS_SPELL)
            call thistype.FURBOLG_ORACLE.Abilities.Add(GreenNova.THIS_SPELL)
            call thistype.FURBOLG_ORACLE.Abilities.Add(LightningShield.THIS_SPELL)
            call thistype.GNOLL_MAGE.Abilities.Add(BurningSpirit.THIS_SPELL)
            call thistype.SNOW_FALCON.Abilities.Add(IceArrows.THIS_SPELL)
            call thistype.TROLL_PRIEST.Abilities.Add(Heal.THIS_SPELL)
            call thistype.TROLL_PRIEST.Abilities.Add(HealExplosion.THIS_SPELL)
            call thistype.WOLF.Abilities.Add(LunarRestoration.THIS_SPELL)

            //Act2
            call thistype.ASSASSIN.Abilities.Add(ColdResistance.THIS_SPELL)
            call thistype.BALDUIR.Abilities.Add(Barrage.THIS_SPELL)
            call thistype.BALDUIR.Abilities.Add(Spell.METEORITE_PROTECTION)
            call thistype.DEMOLISHER.Abilities.Add(Invulnerability.THIS_SPELL)
            call thistype.DRUMMER.Abilities.Add(DrumRoll.THIS_SPELL)
            call thistype.LEADER.Abilities.Add(SummonMinions.THIS_SPELL)
            call thistype.NAGAROSH.Abilities.Add(ChainLightning.THIS_SPELL)
            call thistype.NAGAROSH.Abilities.Add(SpiritWolves.THIS_SPELL)
            call thistype.SPEAR_SCOUT.Abilities.Add(EnvenomedSpears.THIS_SPELL)
            call thistype.TAROG.Abilities.Add(SerpentWard.THIS_SPELL)
            call thistype.TAROG.Abilities.Add(Severance.THIS_SPELL)
            call thistype.TRUE_LEADER.Abilities.Add(Realplex.THIS_SPELL)
            call thistype.TRUE_LEADER.Abilities.Add(Stormbolt.THIS_SPELL)

        //Summons
        call thistype.EYE_OF_THE_FLAME.Abilities.Add(RevealAura.THIS_SPELL)
        call thistype.EYE_OF_THE_FLAME.Abilities.Add(TorchLight.THIS_SPELL)
        call thistype.POLAR_BEAR3.Abilities.AddWithLevel(ArcticBlink.THIS_SPELL, 1)
        call thistype.POLAR_BEAR4.Abilities.AddWithLevel(ArcticBlink.THIS_SPELL, 2)
        call thistype.POLAR_BEAR5.Abilities.AddWithLevel(ArcticBlink.THIS_SPELL, 3)

        //Other
        call thistype.BASE_TOWER.Abilities.Add(Invulnerability.THIS_SPELL)
        call thistype.DARK_TOWER.Abilities.Add(Invulnerability.THIS_SPELL)
        call thistype.DARK_TOWER.Abilities.Add(DarkAttack.THIS_SPELL)
        call thistype.DARK_TOWER2.Abilities.Add(Invulnerability.THIS_SPELL)
        call thistype.DARK_TOWER2.Abilities.AddWithLevel(DarkAttack.THIS_SPELL, 2)
        call thistype.FOUNTAIN.Abilities.Add(FountainAura.THIS_SPELL)
        call thistype.FOUNTAIN.Abilities.Add(Invulnerability.THIS_SPELL)
        call thistype.FROST_TOWER.Abilities.Add(Invulnerability.THIS_SPELL)
        call thistype.FROST_TOWER.Abilities.Add(FrostAttack.THIS_SPELL)
        call thistype.FROST_TOWER2.Abilities.Add(Invulnerability.THIS_SPELL)
        call thistype.FROST_TOWER2.Abilities.AddWithLevel(FrostAttack.THIS_SPELL, 2)
        call thistype.GARBAGE_COLLECTOR.Abilities.Add(Invulnerability.THIS_SPELL)
        call thistype.LIBRARY.Abilities.Add(Invulnerability.THIS_SPELL)
        call thistype.LIGHTNING_TOWER.Abilities.Add(Invulnerability.THIS_SPELL)
        call thistype.LIGHTNING_TOWER.Abilities.Add(LightningAttack.THIS_SPELL)
        call thistype.LIGHTNING_TOWER2.Abilities.Add(Invulnerability.THIS_SPELL)
        call thistype.LIGHTNING_TOWER2.Abilities.AddWithLevel(LightningAttack.THIS_SPELL, 2)
        call thistype.METEORITE.Abilities.Add(BigHealingWave.THIS_SPELL)
        call thistype.METEORITE.Abilities.Add(BurnLumber.THIS_SPELL)
        call thistype.METEORITE.Abilities.Add(BurningSpirit2.THIS_SPELL)
        call thistype.METEORITE.Abilities.Add(CoreFusion.THIS_SPELL)
        call thistype.METEORITE.Abilities.Add(Lapidation.THIS_SPELL)
        call thistype.METEORITE.Abilities.Add(RefreshMana.THIS_SPELL)
        call thistype.PHARMACY.Abilities.Add(Invulnerability.THIS_SPELL)
        call thistype.RESERVOIR.Abilities.Add(FountainHeal.THIS_SPELL)
        call thistype.RESERVOIR.Abilities.Add(Invulnerability.THIS_SPELL)
        call thistype.RIDE_SHOP.Abilities.Add(Invulnerability.THIS_SPELL)
        call thistype.ROSA.Abilities.Add(Invulnerability.THIS_SPELL)
        call thistype.TOWER.Abilities.Add(Invulnerability.THIS_SPELL)

        call GarmentsOfTheSalamander.THIS_UNIT_TYPE.Abilities.Hero.Add4(WaterBindings.THIS_SPELL, GarmentsOfTheSalamander.THIS_SPELL, NULL, Tsukuyomi.THIS_SPELL)
        call Sebastian.THIS_UNIT_TYPE.Abilities.Add(Invulnerability.THIS_SPELL)
    endmethod

    static method Init_Executed takes nothing returns nothing
        local UnitType this

        //call Event.Create(EventType.START, EventPriority.HEADER, function thistype.Event_Start).AddToStatics()

        // Heroes
            //Aruruw
            //! runtextmacro Unit_Create("/", "ARURUW", "Aru", "Aruruw", "true", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "HERO", "2.", "Flesh")
            //! runtextmacro Unit_SetAttack("/", "MISSILE", "1.55", "600.", "250.", "ground,structure,debris,air,item,ward", "0.", "")
            //! runtextmacro Unit_SetAttackMissile("/", "Abilities\\Weapons\\MoonPriestessMissile\\MoonPriestessMissile.mdl", "900.", "0.05")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.3", "0.83")
            //! runtextmacro Unit_SetCollisionSize("/", "32.")
            //! runtextmacro Unit_SetCombatFlags("/", "ground", "650.")
            //! runtextmacro Unit_SetDamage("/", "PIERCE", "12", "3", "3", "0.3")
            //! runtextmacro Unit_SetDeathTime("/", "3.")
            //! runtextmacro Unit_SetElevation("/", "0", "30.", "10.", "45.")
            //! runtextmacro Unit_SetHeroAttributes("/", "AGILITY", "0.75", "12.", "3.75", "11.", "4.", "8.5", "3.5")
            //! runtextmacro Unit_SetHeroNames("/", "Lady Aruruw de Sarafin")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNPriestessOfTheMoon.blp")
            //! runtextmacro Unit_SetLife("/", "100.", "0.")
            //! runtextmacro Unit_SetMana("/", "100.", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "100.")
            //! runtextmacro Unit_SetModel("/", "units\\nightelf\\HeroMoonPriestess\\HeroMoonPriestess.mdx", "", "", "medium", "")
            //! runtextmacro Unit_SetMovement("/", "HORSE", "320.", "0.4", "4", "300.", "300.")
            //! runtextmacro Unit_SetScale("/", "1.25", "2.25")
            //! runtextmacro Unit_SetShadow("/", "NORMAL", "200.", "200.", "85.", "85.")
            //! runtextmacro Unit_SetSight("/", "800.", "1800.")
            //! runtextmacro Unit_SetSoundset("/", "HeroMoonPriestess")

            //! runtextmacro Unit_Finalize("/")

            //Drakul
            //! runtextmacro Unit_Create("/", "DRAKUL", "Dra", "Drakul", "true", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "HERO", "1.", "Flesh")
            //! runtextmacro Unit_SetAttack("/", "NORMAL", "1.6", "100.", "250.", "ground,structure,debris,item,ward", "0.", "WoodHeavyBash")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.4", "1.53")
            //! runtextmacro Unit_SetCollisionSize("/", "32.")
            //! runtextmacro Unit_SetCombatFlags("/", "ground", "500.")
            //! runtextmacro Unit_SetDamage("/", "NORMAL", "14", "2", "7", "0.55")
            //! runtextmacro Unit_SetDeathTime("/", "3.")
            //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "10.")
            //! runtextmacro Unit_SetHeroAttributes("/", "STRENGTH", "0.65", "9.", "3.7", "9.", "3.7", "11.", "4.")
            //! runtextmacro Unit_SetHeroNames("/", "Ct. Weynard Dreadmoore")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNHeroDreadLord.blp")
            //! runtextmacro Unit_SetLife("/", "100.", "0.")
            //! runtextmacro Unit_SetMana("/", "100.", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "100.", "0.", "0.", "60.")
            //! runtextmacro Unit_SetModel("/", "units\\undead\\HeroDreadLord\\HeroDreadLord.mdx", "", "", "medium", "")
            //! runtextmacro Unit_SetMovement("/", "FOOT", "330.", "0.5", "4", "240.", "240.")
            //! runtextmacro Unit_SetScale("/", "1.25", "1.5")
            //! runtextmacro Unit_SetShadow("/", "NORMAL", "160.", "160.", "60.", "60.")
            //! runtextmacro Unit_SetSight("/", "800.", "1800.")
            //! runtextmacro Unit_SetSoundset("/", "HeroDreadLord")

            //! runtextmacro Unit_Finalize("/")

            //Jota
            //! runtextmacro Unit_Create("/", "JOTA", "Jot", "Jota Temoinas", "true", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "HERO", "0.", "Flesh")
            //! runtextmacro Unit_SetAttack("/", "HOMING_MISSILE", "2.", "600.", "250.", "ground,structure,debris,air,item,ward", "0.", "")
            //! runtextmacro Unit_SetAttackMissile("/", "Abilities\\Weapons\\SpiritOfVengeanceMissile\\SpiritOfVengeanceMissile.mdl", "900.", "0.15")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.3", "2.4")
            //! runtextmacro Unit_SetCollisionSize("/", "32.")
            //! runtextmacro Unit_SetCombatFlags("/", "ground", "600.")
            //! runtextmacro Unit_SetDamage("/", "MAGIC", "13", "2", "4", "0.55")
            //! runtextmacro Unit_SetDeathTime("/", "3.")
            //! runtextmacro Unit_SetElevation("/", "0", "30.", "10.", "10.")
            //! runtextmacro Unit_SetHeroAttributes("/", "INTELLIGENCE", "0.8", "6.", "2.5", "16.", "4.5", "9.", "3.5")
            //! runtextmacro Unit_SetHeroNames("/", "Jota Temoinas")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNHeroBloodElfPrince.blp")
            //! runtextmacro Unit_SetLife("/", "100.", "0.")
            //! runtextmacro Unit_SetMana("/", "100.", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "60.", "15.", "0.", "66.")
            //! runtextmacro Unit_SetModel("/", "units\\human\\HeroBloodElf\\HeroBloodElf.mdx", "", "", "", "")
            //! runtextmacro Unit_SetMovement("/", "FOOT", "280.", "0.5", "4", "250.", "250.")
            //! runtextmacro Unit_SetScale("/", "1.15", "1.5")
            //! runtextmacro Unit_SetShadow("/", "NORMAL", "170.", "170.", "65.", "65.")
            //! runtextmacro Unit_SetSight("/", "800.", "1800.")
            //! runtextmacro Unit_SetSoundset("/", "BloodElfSorceror")

            //! runtextmacro Unit_Finalize("/")

            //Kera
            //! runtextmacro Unit_Create("/", "KERA", "Ker", "Kera", "true", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "HERO", "3.", "Metal")
            //! runtextmacro Unit_SetAttack("/", "NORMAL", "1.3", "100.", "250.", "ground,structure,debris,item,ward", "0.", "MetalHeavySlice")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.5", "0.83")
            //! runtextmacro Unit_SetCollisionSize("/", "32.")
            //! runtextmacro Unit_SetCombatFlags("/", "ground", "650.")
            //! runtextmacro Unit_SetDamage("/", "NORMAL", "10", "4", "4", "0.3")
            //! runtextmacro Unit_SetDeathTime("/", "1.")
            //! runtextmacro Unit_SetElevation("/", "0", "30.", "10.", "10.")
            //! runtextmacro Unit_SetHeroAttributes("/", "AGILITY", "1.", "12.", "3.75", "10.", "3.5", "9.5", "4.")
            //! runtextmacro Unit_SetHeroNames("/", "Keralda Zeron")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNHeroWarden.blp")
            //! runtextmacro Unit_SetLife("/", "100.", "0.")
            //! runtextmacro Unit_SetMana("/", "100.", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "80.", "25.", "0.", "80.")
            //! runtextmacro Unit_SetModel("/", "units\\nightelf\\herowarden\\herowarden.mdx", "", "", "medium", "")
            //! runtextmacro Unit_SetMovement("/", "FOOT", "320.", "0.4", "5", "300.", "300.")
            //! runtextmacro Unit_SetScale("/", "1.25", "1.5")
            //! runtextmacro Unit_SetShadow("/", "NORMAL", "200.", "200.", "85.", "85.")
            //! runtextmacro Unit_SetSight("/", "800.", "1800.")
            //! runtextmacro Unit_SetSoundset("/", "HeroWarden")

            //! runtextmacro Unit_Finalize("/")

            //Lizzy
            //! runtextmacro Unit_Create("/", "LIZZY", "Man", "Lizzy", "true", "DEFENDER", "0.85")

            //! runtextmacro Unit_SetArmor("/", "HERO", "0.", "Flesh")
            //! runtextmacro Unit_SetAttack("/", "HOMING_MISSILE", "1.7", "600.", "250.", "ground,structure,debris,air,item,ward", "0.", "")
            //! runtextmacro Unit_SetAttackMissile("/", "Units\\Heroes\\Lizzy\\Missile.mdx", "900.", "0.15")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.3", "2.4")
            //! runtextmacro Unit_SetCollisionSize("/", "27.2")
            //! runtextmacro Unit_SetCombatFlags("/", "ground", "600.")
            //! runtextmacro Unit_SetDamage("/", "MAGIC", "9", "1", "10", "0.55")
            //! runtextmacro Unit_SetDeathTime("/", "2.8")
            //! runtextmacro Unit_SetElevation("/", "0", "20.", "5.", "5.")
            //! runtextmacro Unit_SetHeroAttributes("/", "INTELLIGENCE", "0.4", "7.5", "3.", "17.5", "4.5", "5.", "2.5")
            //! runtextmacro Unit_SetHeroNames("/", "Lizzy Liz")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNJaina.blp")
            //! runtextmacro Unit_SetLife("/", "100.", "0.")
            //! runtextmacro Unit_SetMana("/", "100.", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "60.", "15.", "0.", "66.")
            //! runtextmacro Unit_SetModel("/", "units\\human\\Jaina\\Jaina.mdx", "", "", "", "")
            //! runtextmacro Unit_SetMovement("/", "FOOT", "305.", "0.5", "0", "400.", "400.")
            //! runtextmacro Unit_SetScale("/", "1.25", "1.05")
            //! runtextmacro Unit_SetShadow("/", "NORMAL", "140.", "140.", "70.", "70.")
            //! runtextmacro Unit_SetSight("/", "800.", "1800.")
            //! runtextmacro Unit_SetSoundset("/", "Jaina")

            //! runtextmacro Unit_Finalize("/")

            //Rocketeye
            //! runtextmacro Unit_Create("/", "ROCKETEYE", "Roc", "Rocketeye", "true", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "HERO", "3.", "Metal")
            //! runtextmacro Unit_SetAttack("/", "NORMAL", "1.55", "100.", "250.", "ground,structure,debris,item,ward", "0.", "MetalHeavyBash")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.4", "0.5")
            //! runtextmacro Unit_SetCollisionSize("/", "32.")
            //! runtextmacro Unit_SetCombatFlags("/", "ground", "500.")
            //! runtextmacro Unit_SetDamage("/", "NORMAL", "12", "2", "12", "0.35")
            //! runtextmacro Unit_SetDeathTime("/", "2.5")
            //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "10.")
            //! runtextmacro Unit_SetHeroAttributes("/", "STRENGTH", "0.85", "7.5", "3.5", "6.", "3.25", "16.", "5.")
            //! runtextmacro Unit_SetHeroNames("/", "Gen. Reginald Grylls")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNHeroMountainKing.blp")
            //! runtextmacro Unit_SetLife("/", "100.", "0.")
            //! runtextmacro Unit_SetMana("/", "100.", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
            //! runtextmacro Unit_SetModel("/", "units\\human\\HeroMountainKing\\HeroMountainKing.mdx", "", "", "", "")
            //! runtextmacro Unit_SetMovement("/", "FOOT", "280.", "0.6", "5", "250.", "250.")
            //! runtextmacro Unit_SetScale("/", "1.25", "1.25")
            //! runtextmacro Unit_SetShadow("/", "NORMAL", "150.", "150.", "60.", "60.")
            //! runtextmacro Unit_SetSight("/", "800.", "1800.")
            //! runtextmacro Unit_SetSoundset("/", "HeroMountainKing")

            //! runtextmacro Unit_Finalize("/")

            //Smokealot
            //! runtextmacro Unit_Create("/", "SMOKEALOT", "Smo", "Smokealot", "true", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "HERO", "3.", "Metal")
            //! runtextmacro Unit_SetAttack("/", "NORMAL", "1.4", "100.", "250.", "ground,structure,debris,item,ward", "0.", "MetalHeavySlice")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.2", "1.008")
            //! runtextmacro Unit_SetCollisionSize("/", "32.")
            //! runtextmacro Unit_SetCombatFlags("/", "ground", "500.")
            //! runtextmacro Unit_SetDamage("/", "NORMAL", "13", "4", "4", "0.56")
            //! runtextmacro Unit_SetDeathTime("/", "3.")
            //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "45.")
            //! runtextmacro Unit_SetHeroAttributes("/", "AGILITY", "1.", "13.5", "4.65", "7.5", "3.5", "10.", "3.85")
            //! runtextmacro Unit_SetHeroNames("/", "Sir Kimrad Eyestroke")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNHeroDeathKnight.blp")
            //! runtextmacro Unit_SetLife("/", "100.", "0.")
            //! runtextmacro Unit_SetMana("/", "100.", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "100.", "-20.", "60.", "76.")
            //! runtextmacro Unit_SetModel("/", "units\\undead\\HeroDeathKnight\\HeroDeathKnight.mdx", "", "", "medium", "")
            //! runtextmacro Unit_SetMovement("/", "FOOT", "360.", "0.5", "4", "380.", "380.")
            //! runtextmacro Unit_SetScale("/", "1.25", "1.85")
            //! runtextmacro Unit_SetShadow("/", "NORMAL", "200.", "200.", "75.", "75.")
            //! runtextmacro Unit_SetSight("/", "800.", "1800.")
            //! runtextmacro Unit_SetSoundset("/", "HeroDeathKnight")

            //! runtextmacro Unit_Finalize("/")

            //Stormy
            //! runtextmacro Unit_Create("/", "STORMY", "Sto", "Stormy", "true", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "HERO", "1.5", "Metal")
            //! runtextmacro Unit_SetAttack("/", "NORMAL", "1.7", "100.", "250.", "ground,structure,debris,item,ward", "0.", "WoodHeavyBash")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.35", "0.5")
            //! runtextmacro Unit_SetCollisionSize("/", "32.")
            //! runtextmacro Unit_SetCombatFlags("/", "ground", "500.")
            //! runtextmacro Unit_SetDamage("/", "NORMAL", "12", "1", "10", "0.35")
            //! runtextmacro Unit_SetDeathTime("/", "2.5")
            //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "10.")
            //! runtextmacro Unit_SetHeroAttributes("/", "STRENGTH", "0.7", "10.", "3.75", "10.", "3.75", "10.5", "3.75")
            //! runtextmacro Unit_SetHeroNames("/", "Pakon Stormbrewer")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNPandarenBrewmaster.blp")
            //! runtextmacro Unit_SetLife("/", "100.", "0.")
            //! runtextmacro Unit_SetMana("/", "100.", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
            //! runtextmacro Unit_SetModel("/", "Units\\Creeps\\PandarenBrewmaster\\PandarenBrewmaster.mdx", "", "", "large", "")
            //! runtextmacro Unit_SetMovement("/", "FOOT", "290.", "0.6", "5", "250.", "250.")
            //! runtextmacro Unit_SetScale("/", "1.25", "2.")
            //! runtextmacro Unit_SetShadow("/", "NORMAL", "140.", "140.", "50.", "50.")
            //! runtextmacro Unit_SetSight("/", "800.", "1800.")
            //! runtextmacro Unit_SetSoundset("/", "PandarenBrewmaster")

            //! runtextmacro Unit_Finalize("/")

            //Tajran
            //! runtextmacro Unit_Create("/", "TAJRAN", "Thr", "Tajran", "true", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "HERO", "0.5", "Flesh")
            //! runtextmacro Unit_SetAttack("/", "HOMING_MISSILE", "1.7", "600.", "250.", "ground,structure,debris,air,item,ward", "0.", "")
            //! runtextmacro Unit_SetAttackMissile("/", "Abilities\\Weapons\\KeeperGroveMissile\\KeeperGroveMissile.mdl", "1200.", "0.15")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.5", "1.")
            //! runtextmacro Unit_SetCollisionSize("/", "32.")
            //! runtextmacro Unit_SetCombatFlags("/", "ground", "600.")
            //! runtextmacro Unit_SetDamage("/", "MAGIC", "7", "1", "10", "0.3")
            //! runtextmacro Unit_SetDeathTime("/", "2.1")
            //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "10.")
            //! runtextmacro Unit_SetHeroAttributes("/", "INTELLIGENCE", "0.5", "9.", "3.5", "14.5", "4.", "7.5", "3.")
            //! runtextmacro Unit_SetHeroNames("/", "Than'duin Leaog")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNThrall.blp")
            //! runtextmacro Unit_SetLife("/", "100.", "0.")
            //! runtextmacro Unit_SetMana("/", "100.", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
            //! runtextmacro Unit_SetModel("/", "units\\orc\\Thrall\\Thrall.mdx", "", "", "medium", "")
            //! runtextmacro Unit_SetMovement("/", "HORSE", "330.", "0.4", "5", "260.", "260.")
            //! runtextmacro Unit_SetScale("/", "1.25", "2.")
            //! runtextmacro Unit_SetShadow("/", "NORMAL", "160.", "160.", "80.", "80.")
            //! runtextmacro Unit_SetSight("/", "800.", "1800.")
            //! runtextmacro Unit_SetSoundset("/", "Thrall")

            //! runtextmacro Unit_Finalize("/")

        // Spawns
            //Bonus
                //Flying Penguin
                //! runtextmacro Unit_Create("/", "FLYING_PENGUIN_BONUS", "FlP", "Flying Penguin", "false", "ATTACKER", "1.")

                //! runtextmacro Unit_SetArmor("/", "LIGHT", "0.", "Flesh")
                //! runtextmacro Unit_SetAttack("/", "MISSILE", "1.5", "100.", "250.", "ground,structure,debris,item,ward", "0.", "")
                //! runtextmacro Unit_SetAttackMissile("/", "Abilities\\Weapons\\GyroCopter\\GyroCopterMissile.mdl", "600.", "0.")
                //! runtextmacro Unit_SetBlend("/", "0.15")
                //! runtextmacro Unit_SetCasting("/", "0.4", "0.5")
                //! runtextmacro Unit_SetCollisionSize("/", "20.8")
                //! runtextmacro Unit_SetCombatFlags("/", "air", "500.")
                //! runtextmacro Unit_SetDamage("/", "SIEGE", "5", "1", "1", "1.")
                //! runtextmacro Unit_SetDeathTime("/", "2.33")
                //! runtextmacro Unit_SetElevation("/", "0", "20.", "0.", "0.")
                //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNPenguin.blp")
                //! runtextmacro Unit_SetLife("/", "40.", "1.")
                //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
                //! runtextmacro Unit_SetModel("/", "units\\critters\\Penguin\\Penguin.mdx", "", "", "", "")
                //! runtextmacro Unit_SetMovement("/", "FLY", "340.", "0.5", "0", "200.", "200.")
                //! runtextmacro Unit_SetMovementHeight("/", "300.", "0.")
                //! runtextmacro Unit_SetScale("/", "1.3", "0.9")
                //! runtextmacro Unit_SetShadow("/", "FLY", "70.", "70.", "35.", "35.")
                //! runtextmacro Unit_SetSight("/", "350.", "350.")
                //! runtextmacro Unit_SetSoundset("/", "Penguin")
                //! runtextmacro Unit_SetSpellPower("/", "10.")
                //! runtextmacro Unit_SetVertexColor("/", "255", "0", "255", "255")

                //! runtextmacro Unit_Finalize("/")

                //Penguin
                //! runtextmacro Unit_Create("/", "PENGUIN_BONUS", "PeB", "Penguin", "false", "ATTACKER", "1.")

                //! runtextmacro Unit_SetArmor("/", "LARGE", "0.", "Flesh")
                //! runtextmacro Unit_SetAttack("/", "NORMAL", "1.5", "100.", "250.", "ground,structure,debris,item,ward", "0.", "")
                //! runtextmacro Unit_SetBlend("/", "0.15")
                //! runtextmacro Unit_SetCasting("/", "0.4", "0.5")
                //! runtextmacro Unit_SetCollisionSize("/", "16.")
                //! runtextmacro Unit_SetCombatFlags("/", "ground", "500.")
                //! runtextmacro Unit_SetDamage("/", "CHAOS", "5", "1", "1", "1.")
                //! runtextmacro Unit_SetDeathTime("/", "2.33")
                //! runtextmacro Unit_SetElevation("/", "0", "20.", "10.", "10.")
                //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNPenguin.blp")
                //! runtextmacro Unit_SetLife("/", "55.", "1.")
                //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
                //! runtextmacro Unit_SetModel("/", "units\\critters\\Penguin\\Penguin.mdx", "", "", "", "")
                //! runtextmacro Unit_SetMovement("/", "FOOT", "340.", "0.5", "0", "200.", "200.")
                //! runtextmacro Unit_SetScale("/", "1.725", "0.9")
                //! runtextmacro Unit_SetShadow("/", "NORMAL", "70.", "70.", "35.", "35.")
                //! runtextmacro Unit_SetSight("/", "350.", "350.")
                //! runtextmacro Unit_SetSoundset("/", "Penguin")
                //! runtextmacro Unit_SetSpellPower("/", "10.")

                //! runtextmacro Unit_Finalize("/")

                //Penguin Champ
                //! runtextmacro Unit_Create("/", "PENGUIN_CHAMP_BONUS", "PeB", "Penguin", "false", "ATTACKER", "1.")

                //! runtextmacro Unit_SetArmor("/", "FORT", "0.", "Flesh")
                //! runtextmacro Unit_SetAttack("/", "NORMAL", "1.5", "100.", "250.", "ground,structure,debris,item,ward", "0.", "")
                //! runtextmacro Unit_SetBlend("/", "0.15")
                //! runtextmacro Unit_SetCasting("/", "0.4", "0.5")
                //! runtextmacro Unit_SetCollisionSize("/", "16.")
                //! runtextmacro Unit_SetCombatFlags("/", "ground", "500.")
                //! runtextmacro Unit_SetDamage("/", "NORMAL", "5", "1", "10", "1.")
                //! runtextmacro Unit_SetDeathTime("/", "2.33")
                //! runtextmacro Unit_SetElevation("/", "0", "20.", "10.", "10.")
                //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNPenguin.blp")
                //! runtextmacro Unit_SetLife("/", "105.", "3.")
                //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
                //! runtextmacro Unit_SetModel("/", "units\\critters\\Penguin\\Penguin.mdx", "", "", "large", "")
                //! runtextmacro Unit_SetMovement("/", "FOOT", "200.", "0.3", "3", "200.", "200.")
                //! runtextmacro Unit_SetScale("/", "3.", "0.9")
                //! runtextmacro Unit_SetShadow("/", "NORMAL", "70.", "70.", "35.", "35.")
                //! runtextmacro Unit_SetSight("/", "350.", "350.")
                //! runtextmacro Unit_SetSoundset("/", "Penguin")
                //! runtextmacro Unit_SetSpellPower("/", "15.")
                //! runtextmacro Unit_SetVertexColor("/", "255", "191", "0", "255")

                //! runtextmacro Unit_Finalize("/")

            //Act1
                //Deer
                //! runtextmacro Unit_Create("/", "DEER", "Dee", "Deer", "false", "ATTACKER", "1.5")

                //! runtextmacro Unit_SetArmor("/", "MEDIUM", "0.", "Flesh")
                //! runtextmacro Unit_SetAttack("/", "NORMAL", "1.4", "90.", "250.", "ground,structure,debris,item,ward", "0.", "WoodMediumBash")
                //! runtextmacro Unit_SetBlend("/", "0.15")
                //! runtextmacro Unit_SetCasting("/", "0.4", "0.5")
                //! runtextmacro Unit_SetCollisionSize("/", "24.")
                //! runtextmacro Unit_SetCombatFlags("/", "ground", "500.")
                //! runtextmacro Unit_SetDamage("/", "NORMAL", "5", "1", "2", "0.5")
                //! runtextmacro Unit_SetDeathTime("/", "2.5")
                //! runtextmacro Unit_SetElevation("/", "0", "20.", "10.", "45.")
                //! runtextmacro Unit_SetExp("/", "20")
                //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNStag.blp")
                //! runtextmacro Unit_SetLife("/", "60.", "0.5")
                //! runtextmacro Unit_SetMana("/", "25.", "1.5")
                //! runtextmacro Unit_SetMissilePoints("/", "35.", "0.", "0.", "35.")
                //! runtextmacro Unit_SetModel("/", "units\\critters\\BlackStagMale\\BlackStagMale.mdx", "", "", "", "")
                //! runtextmacro Unit_SetMovement("/", "FOOT", "150.", "0.5", "0", "380.", "380.")
                //! runtextmacro Unit_SetScale("/", "1.7", "1.")
                //! runtextmacro Unit_SetShadow("/", "NORMAL", "140.", "140.", "50.", "50.")
                //! runtextmacro Unit_SetSight("/", "800.", "1400.")
                //! runtextmacro Unit_SetSpellPower("/", "10.")
                //! runtextmacro Unit_SetSupply("/", "5")

                //! runtextmacro Unit_Finalize("/")

                //Furbolg Oracle
                //! runtextmacro Unit_Create("/", "FURBOLG_ORACLE", "FuO", "Furbolg Oracle", "true", "ATTACKER", "1.")

                //! runtextmacro Unit_SetArmor("/", "HERO", "4.", "Flesh")
                //! runtextmacro Unit_SetAttack("/", "NORMAL", "3.", "100.", "250.", "ground,structure,debris,item,ward", "0.", "WoodHeavyBash")
                //! runtextmacro Unit_SetBlend("/", "0.15")
                //! runtextmacro Unit_SetCasting("/", "0.5", "0.51")
                //! runtextmacro Unit_SetCollisionSize("/", "32.")
                //! runtextmacro Unit_SetCombatFlags("/", "ground", "500.")
                //! runtextmacro Unit_SetDamage("/", "HERO", "44", "1", "20", "0.35")
                //! runtextmacro Unit_SetDeathTime("/", "3.")
                //! runtextmacro Unit_SetElevation("/", "0", "50.", "5.", "5.")
                //! runtextmacro Unit_SetExp("/", "50")
                //! runtextmacro Unit_SetHeroNames("/", "White Eyes Fursa")
                //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNFurbolgTracker.blp")
                //! runtextmacro Unit_SetLife("/", "6500.", "15.")
                //! runtextmacro Unit_SetMana("/", "1500.", "25.")
                //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
                //! runtextmacro Unit_SetModel("/", "units\\creeps\\FurbolgTracker\\FurbolgTracker.mdx", "", "", "large", "")
                //! runtextmacro Unit_SetMovement("/", "FOOT", "180.", "0.15", "4", "320.", "320.")
                //! runtextmacro Unit_SetScale("/", "3.6", "1.25")
                //! runtextmacro Unit_SetShadow("/", "NORMAL", "150.", "150.", "60.", "60.")
                //! runtextmacro Unit_SetSight("/", "800.", "1800.")
                //! runtextmacro Unit_SetSoundset("/", "Furbolg")
                //! runtextmacro Unit_SetSpellPower("/", "100.")
                //! runtextmacro Unit_SetSupply("/", "50")

                //! runtextmacro Unit_Finalize("/")

                //Gnoll Mage
                //! runtextmacro Unit_Create("/", "GNOLL_MAGE", "GnM", "Gnoll Mage", "false", "ATTACKER", "1.5")

                //! runtextmacro Unit_SetArmor("/", "LIGHT", "0.", "Flesh")
                //! runtextmacro Unit_SetAttack("/", "MISSILE", "1.6", "500.", "250.", "ground,structure,debris,air,item,ward", "0.", "")
                //! runtextmacro Unit_SetAttackMissile("/", "Abilities\\Weapons\\FarseerMissile\\FarseerMissile.mdx", "1200.", "0.15")
                //! runtextmacro Unit_SetBlend("/", "0.15")
                //! runtextmacro Unit_SetCasting("/", "0.6", "1.23")
                //! runtextmacro Unit_SetCollisionSize("/", "32.")
                //! runtextmacro Unit_SetCombatFlags("/", "ground", "500.")
                //! runtextmacro Unit_SetDamage("/", "MAGIC", "7", "1", "5", "0.3")
                //! runtextmacro Unit_SetDeathTime("/", "3.")
                //! runtextmacro Unit_SetElevation("/", "0", "30.", "10.", "10.")
                //! runtextmacro Unit_SetExp("/", "35")
                //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNGnollWarden.blp")
                //! runtextmacro Unit_SetLife("/", "85.", "1.5")
                //! runtextmacro Unit_SetMana("/", "90.", "1.")
                //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
                //! runtextmacro Unit_SetModel("/", "units\\creeps\\GnollWarden\\GnollWarden.mdx", "", "", "", "")
                //! runtextmacro Unit_SetMovement("/", "FOOT", "135.", "0.5", "5", "200.", "200.")
                //! runtextmacro Unit_SetScale("/", "1.25", "1.")
                //! runtextmacro Unit_SetShadow("/", "NORMAL", "140.", "140.", "50.", "50.")
                //! runtextmacro Unit_SetSight("/", "800.", "1400.")
                //! runtextmacro Unit_SetSoundset("/", "Gnoll")
                //! runtextmacro Unit_SetSpellPower("/", "40.")
                //! runtextmacro Unit_SetSupply("/", "7")

                //! runtextmacro Unit_Finalize("/")

                //Moonkin
                //! runtextmacro Unit_Create("/", "MOONKIN", "Moo", "Moonkin", "false", "ATTACKER", "1.2")

                //! runtextmacro Unit_SetArmor("/", "LARGE", "3.", "Flesh")
                //! runtextmacro Unit_SetAttack("/", "NORMAL", "1.7", "128.", "250.", "ground,structure,debris,item,ward", "0.", "WoodHeavyBash")
                //! runtextmacro Unit_SetBlend("/", "0.15")
                //! runtextmacro Unit_SetBlood("/", "Objects\\Spawnmodels\\NightElf\\NightElfBlood\\NightElfBloodDruidoftheClaw.mdx")
                //! runtextmacro Unit_SetCasting("/", "0.", "0.51")
                //! runtextmacro Unit_SetCollisionSize("/", "48.")
                //! runtextmacro Unit_SetCombatFlags("/", "ground", "500.")
                //! runtextmacro Unit_SetDamage("/", "NORMAL", "13", "2", "4", "0.3")
                //! runtextmacro Unit_SetDeathTime("/", "3.")
                //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "10.")
                //! runtextmacro Unit_SetExp("/", "60")
                //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNOwlBear.blp")
                //! runtextmacro Unit_SetLife("/", "160.", "4.")
                //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
                //! runtextmacro Unit_SetModel("/", "units\\creeps\\Owlbear\\Owlbear.mdx", "", "", "medium", "")
                //! runtextmacro Unit_SetMovement("/", "FOOT", "135.", "0.3", "3", "200.", "200.")
                //! runtextmacro Unit_SetScale("/", "1.25", "1.6")
                //! runtextmacro Unit_SetShadow("/", "NORMAL", "140.", "140.", "50.", "50.")
                //! runtextmacro Unit_SetSight("/", "800.", "1400.")
                //! runtextmacro Unit_SetSoundset("/", "Owlbear")
                //! runtextmacro Unit_SetSpellPower("/", "27.5")
                //! runtextmacro Unit_SetSupply("/", "9")

                //! runtextmacro Unit_Finalize("/")

                //Satyr
                //! runtextmacro Unit_Create("/", "SATYR", "Sat", "Satyr", "false", "ATTACKER", "1.15")

                //! runtextmacro Unit_SetArmor("/", "LARGE", "1.", "Flesh")
                //! runtextmacro Unit_SetAttack("/", "NORMAL", "1.35", "100.", "250.", "ground,structure,debris,item,ward", "0.", "MetalMediumSlice")
                //! runtextmacro Unit_SetBlend("/", "0.15")
                //! runtextmacro Unit_SetCasting("/", "0.5", "1.2")
                //! runtextmacro Unit_SetCollisionSize("/", "32.")
                //! runtextmacro Unit_SetCombatFlags("/", "ground", "500.")
                //! runtextmacro Unit_SetDamage("/", "NORMAL", "14", "1", "4", "0.3")
                //! runtextmacro Unit_SetDeathTime("/", "3.")
                //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "10.")
                //! runtextmacro Unit_SetExp("/", "35")
                //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNSatyr.blp")
                //! runtextmacro Unit_SetLife("/", "80.", "2.")
                //! runtextmacro Unit_SetMana("/", "120.", "3.5")
                //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
                //! runtextmacro Unit_SetModel("/", "units\\creeps\\Satyr\\Satyr.mdx", "", "", "", "")
                //! runtextmacro Unit_SetMovement("/", "FOOT", "230.", "0.5", "5", "250.", "250.")
                //! runtextmacro Unit_SetScale("/", "1.4", "1.")
                //! runtextmacro Unit_SetShadow("/", "NORMAL", "120.", "120.", "50.", "50.")
                //! runtextmacro Unit_SetSight("/", "800.", "1400.")
                //! runtextmacro Unit_SetSoundset("/", "Satyr")
                //! runtextmacro Unit_SetSpellPower("/", "35.")
                //! runtextmacro Unit_SetSupply("/", "15")

                //! runtextmacro Unit_Finalize("/")

                //Snow Falcon
                //! runtextmacro Unit_Create("/", "SNOW_FALCON", "SnF", "Snow Falcon", "false", "ATTACKER", "1.")

                //! runtextmacro Unit_SetArmor("/", "LIGHT", "0.", "Flesh")
                //! runtextmacro Unit_SetAttack("/", "MISSILE", "1.5", "500.", "0.", "ground,structure,debris,air,item,ward", "0.", "")
                //! runtextmacro Unit_SetAttackMissile("/", "Abilities\\Weapons\\ColdArrow\\ColdArrowMissile.mdx", "1500.", "0.")
                //! runtextmacro Unit_SetBlend("/", "0.15")
                //! runtextmacro Unit_SetCasting("/", "0.3", "0.51")
                //! runtextmacro Unit_SetCollisionSize("/", "8.")
                //! runtextmacro Unit_SetCombatFlags("/", "air", "500.")
                //! runtextmacro Unit_SetDamage("/", "MAGIC", "7", "1", "4", "0.5")
                //! runtextmacro Unit_SetDeathTime("/", "1.")
                //! runtextmacro Unit_SetElevation("/", "2", "20.", "25.", "33.")
                //! runtextmacro Unit_SetExp("/", "50")
                //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNWarEagle.blp")
                //! runtextmacro Unit_SetLife("/", "110.", "1.5")
                //! runtextmacro Unit_SetMana("/", "30.", "0.5")
                //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
                //! runtextmacro Unit_SetModel("/", "units\\creeps\\WarEagle\\WarEagle.mdx", "", "", "", "")
                //! runtextmacro Unit_SetMovement("/", "FLY", "135.", "0.6", "1", "200.", "200.")
                //! runtextmacro Unit_SetMovementHeight("/", "200.", "100.")
                //! runtextmacro Unit_SetScale("/", "0.9", "1.25")
                //! runtextmacro Unit_SetShadow("/", "FLY", "120.", "120.", "60.", "60.")
                //! runtextmacro Unit_SetSight("/", "1200.", "1600.")
                //! runtextmacro Unit_SetSoundset("/", "WarEagle")
                //! runtextmacro Unit_SetSpellPower("/", "20.")
                //! runtextmacro Unit_SetSupply("/", "25")

                //! runtextmacro Unit_Finalize("/")

                //Troll
                //! runtextmacro Unit_Create("/", "TROLL", "IcT", "Ice Troll", "false", "ATTACKER", "1.")

                //! runtextmacro Unit_SetArmor("/", "MEDIUM", "1.", "Flesh")
                //! runtextmacro Unit_SetAttack("/", "MISSILE", "1.6", "500.", "250.", "ground,structure,debris,air,item,ward", "0.", "")
                //! runtextmacro Unit_SetAttackMissile("/", "Abilities\\Weapons\\Axe\\AxeMissile.mdl", "1200.", "0.15")
                //! runtextmacro Unit_SetBlend("/", "0.15")
                //! runtextmacro Unit_SetCasting("/", "0.5", "0.51")
                //! runtextmacro Unit_SetCollisionSize("/", "32.")
                //! runtextmacro Unit_SetCombatFlags("/", "ground", "600.")
                //! runtextmacro Unit_SetDamage("/", "PIERCE", "8", "2", "2", "0.3")
                //! runtextmacro Unit_SetDeathTime("/", "3.")
                //! runtextmacro Unit_SetElevation("/", "0", "30.", "10.", "10.")
                //! runtextmacro Unit_SetExp("/", "30")
                //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNIceTroll.blp")
                //! runtextmacro Unit_SetLife("/", "70.", "0.75")
                //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
                //! runtextmacro Unit_SetModel("/", "units\\creeps\\IceTroll\\IceTroll.mdx", "", "", "", "")
                //! runtextmacro Unit_SetMovement("/", "FOOT", "145.", "0.5", "5", "270.", "270.")
                //! runtextmacro Unit_SetScale("/", "1.25", "1.")
                //! runtextmacro Unit_SetShadow("/", "FLY", "100.", "100.", "45.", "45.")
                //! runtextmacro Unit_SetSight("/", "800.", "1400.")
                //! runtextmacro Unit_SetSoundset("/", "IceTroll")
                //! runtextmacro Unit_SetSpellPower("/", "20.")
                //! runtextmacro Unit_SetSupply("/", "6")
                //! runtextmacro Unit_SetVertexColor("/", "190", "255", "255", "255")

                //! runtextmacro Unit_Finalize("/")

                //Troll Priest
                //! runtextmacro Unit_Create("/", "TROLL_PRIEST", "ITP", "Ice Troll Priest", "false", "ATTACKER", "1.25")

                //! runtextmacro Unit_SetArmor("/", "MEDIUM", "0.", "Flesh")
                //! runtextmacro Unit_SetAttack("/", "HOMING_MISSILE", "1.8", "600.", "250.", "ground,structure,debris,air,item,ward", "0.", "")
                //! runtextmacro Unit_SetAttackMissile("/", "Abilities\\Weapons\\LichMissile\\LichMissile.mdx", "900.", "0.15")
                //! runtextmacro Unit_SetBlend("/", "0.15")
                //! runtextmacro Unit_SetCasting("/", "0.5", "0.5")
                //! runtextmacro Unit_SetCollisionSize("/", "40.")
                //! runtextmacro Unit_SetCombatFlags("/", "ground", "600.")
                //! runtextmacro Unit_SetDamage("/", "MAGIC", "8", "1", "8", "0.3")
                //! runtextmacro Unit_SetDeathTime("/", "3.")
                //! runtextmacro Unit_SetElevation("/", "0", "30.", "10.", "10.")
                //! runtextmacro Unit_SetExp("/", "25")
                //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNIceTrollShaman.blp")
                //! runtextmacro Unit_SetLife("/", "115.", "2.")
                //! runtextmacro Unit_SetMana("/", "80.", "2.")
                //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
                //! runtextmacro Unit_SetModel("/", "units\\creeps\\IceTrollShadowPriest\\IceTrollShadowPriest.mdx", "", "", "", "")
                //! runtextmacro Unit_SetMovement("/", "FOOT", "145.", "0.5", "4", "270.", "270.")
                //! runtextmacro Unit_SetScale("/", "1.5", "1.")
                //! runtextmacro Unit_SetShadow("/", "FLY", "140.", "140.", "50.", "50.")
                //! runtextmacro Unit_SetSight("/", "800.", "1400.")
                //! runtextmacro Unit_SetSoundset("/", "IceTrollShadowPriest")
                //! runtextmacro Unit_SetSpellPower("/", "35.")
                //! runtextmacro Unit_SetSupply("/", "9")
                //! runtextmacro Unit_SetVertexColor("/", "170", "130", "255", "255")

                //! runtextmacro Unit_Finalize("/")

                //Wolf
                //! runtextmacro Unit_Create("/", "WOLF", "Wol", "Tundra Wolf", "false", "ATTACKER", "1.")

                //! runtextmacro Unit_SetArmor("/", "LARGE", "2.", "Flesh")
                //! runtextmacro Unit_SetAttack("/", "NORMAL", "1.35", "110.", "250.", "ground,structure,debris,item,ward", "0.", "WoodMediumBash")
                //! runtextmacro Unit_SetBlend("/", "0.15")
                //! runtextmacro Unit_SetCasting("/", "0.3", "0.51")
                //! runtextmacro Unit_SetCollisionSize("/", "32.")
                //! runtextmacro Unit_SetCombatFlags("/", "ground", "500.")
                //! runtextmacro Unit_SetDamage("/", "NORMAL", "8", "2", "3", "0.33")
                //! runtextmacro Unit_SetDeathTime("/", "1.75")
                //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "45.")
                //! runtextmacro Unit_SetExp("/", "40")
                //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNTimberWolf.blp")
                //! runtextmacro Unit_SetLife("/", "120.", "2.")
                //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
                //! runtextmacro Unit_SetModel("/", "units\\creeps\\WhiteWolf\\WhiteWolf.mdx", "", "", "", "")
                //! runtextmacro Unit_SetMovement("/", "FOOT", "165.", "0.6", "5", "240.", "240.")
                //! runtextmacro Unit_SetScale("/", "1.", "1.25")
                //! runtextmacro Unit_SetShadow("/", "NORMAL", "140.", "140.", "60.", "60.")
                //! runtextmacro Unit_SetSight("/", "800.", "1400.")
                //! runtextmacro Unit_SetSoundset("/", "SpiritWolf")
                //! runtextmacro Unit_SetSpellPower("/", "22.5")
                //! runtextmacro Unit_SetSupply("/", "8")

                //! runtextmacro Unit_Finalize("/")

                //Creeps
                    //Blue Dragon Spawn
                    //! runtextmacro Unit_Create("/", "BLUE_DRAGON_SPAWN", "BDS", "Blue Dragon Spawn", "false", "ATTACKER", "0.7")

                    //! runtextmacro Unit_SetArmor("/", "LARGE", "0.", "Flesh")
                    //! runtextmacro Unit_SetAttack("/", "HOMING_MISSILE", "1.8", "600.", "250.", "ground,structure,debris,air,item,ward", "0.", "")
                    //! runtextmacro Unit_SetAttackMissile("/", "Abilities\\Weapons\\FrostWyrmMissile\\FrostWyrmMissile.mdx", "800.", "0.1")
                    //! runtextmacro Unit_SetBlend("/", "0.15")
                    //! runtextmacro Unit_SetCasting("/", "0.47", "0.51")
                    //! runtextmacro Unit_SetCollisionSize("/", "48.")
                    //! runtextmacro Unit_SetCombatFlags("/", "air", "600.")
                    //! runtextmacro Unit_SetDamage("/", "PIERCE", "12", "1", "2", "0.94")
                    //! runtextmacro Unit_SetDeathTime("/", "3.")
                    //! runtextmacro Unit_SetElevation("/", "2", "100.", "25.", "33.")
                    //! runtextmacro Unit_SetExp("/", "35")
                    //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNAzureDragon.blp")
                    //! runtextmacro Unit_SetLife("/", "300.", "1.")
                    //! runtextmacro Unit_SetMissilePoints("/", "0.", "0.", "60.", "-10.")
                    //! runtextmacro Unit_SetModel("/", "units\\creeps\\AzureDragonWelp\\AzureDragonWelp.mdx", "", "", "medium", "")
                    //! runtextmacro Unit_SetMovement("/", "FLY", "300.", "0.1", "1", "200.", "200.")
                    //! runtextmacro Unit_SetScale("/", "0.7", "1.75")
                    //! runtextmacro Unit_SetShadow("/", "FLY", "140.", "140.", "70.", "70.")
                    //! runtextmacro Unit_SetSight("/", "800.", "1400.")
                    //! runtextmacro Unit_SetSoundset("/", "AzureDragon")
                    //! runtextmacro Unit_SetSpellPower("/", "25.")
                    //! runtextmacro Unit_SetSupply("/", "14")
                    //! runtextmacro Unit_SetVertexColor("/", "150", "150", "255", "255")

                    //! runtextmacro Unit_Finalize("/")

                    //Furbolg Mother
                    //! runtextmacro Unit_Create("/", "FURBOLG_MOTHER", "FuM", "Furbolg Mother", "false", "ATTACKER", "1.3")

                    //! runtextmacro Unit_SetArmor("/", "LARGE", "4.", "Flesh")
                    //! runtextmacro Unit_SetAttack("/", "NORMAL", "2.", "140.", "250.", "ground,ward", "0.", "WoodHeavyBash")
                    //! runtextmacro Unit_SetBlend("/", "0.15")
                    //! runtextmacro Unit_SetCasting("/", "0.5", "0.51")
                    //! runtextmacro Unit_SetCollisionSize("/", "48.")
                    //! runtextmacro Unit_SetCombatFlags("/", "ground", "300.")
                    //! runtextmacro Unit_SetDamage("/", "CHAOS", "24", "3", "4", "0.3")
                    //! runtextmacro Unit_SetDeathTime("/", "3.")
                    //! runtextmacro Unit_SetElevation("/", "0", "30.", "10.", "10.")
                    //! runtextmacro Unit_SetExp("/", "80")
                    //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNFurbolg.blp")
                    //! runtextmacro Unit_SetLife("/", "1000.", "5.")
                    //! runtextmacro Unit_SetMissilePoints("/", "100.", "0.", "0.", "60.")
                    //! runtextmacro Unit_SetModel("/", "units\\creeps\\Furbolg\\Furbolg.mdx", "", "", "medium", "")
                    //! runtextmacro Unit_SetMovement("/", "FOOT", "190.", "0.5", "4", "250.", "250.")
                    //! runtextmacro Unit_SetScale("/", "2.", "1.5")
                    //! runtextmacro Unit_SetShadow("/", "NORMAL", "140.", "140.", "50.", "50.")
                    //! runtextmacro Unit_SetSight("/", "800.", "1400.")
                    //! runtextmacro Unit_SetSoundset("/", "Furbolg")
                    //! runtextmacro Unit_SetSpellPower("/", "40.")
                    //! runtextmacro Unit_SetSupply("/", "150")
                    //! runtextmacro Unit_SetVertexColor("/", "255", "120", "150", "255")

                    //! runtextmacro Unit_Finalize("/")

                    //Kobold Blue
                    //! runtextmacro Unit_Create("/", "KOBOLD_BLUE", "KoB", "Blue Kobold", "false", "ATTACKER", "1.4")

                    //! runtextmacro Unit_SetArmor("/", "UNARMORED", "0.", "Flesh")
                    //! runtextmacro Unit_SetAttack("/", "HOMING_MISSILE", "1.8", "600.", "250.", "ground,air,ward", "0.", "")
                    //! runtextmacro Unit_SetAttackMissile("/", "Abilities\\Weapons\\FireBallMissile\\FireBallMissile.mdx", "900.", "0.15")
                    //! runtextmacro Unit_SetBlend("/", "0.15")
                    //! runtextmacro Unit_SetCasting("/", "0.5", "0.5")
                    //! runtextmacro Unit_SetCollisionSize("/", "31.")
                    //! runtextmacro Unit_SetCombatFlags("/", "ground", "600.")
                    //! runtextmacro Unit_SetDamage("/", "MAGIC", "4", "2", "2", "0.38")
                    //! runtextmacro Unit_SetDeathTime("/", "3.")
                    //! runtextmacro Unit_SetElevation("/", "0", "30.", "10.", "10.")
                    //! runtextmacro Unit_SetExp("/", "10")
                    //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNKoboldGeomancer.blp")
                    //! runtextmacro Unit_SetLife("/", "90.", "1.")
                    //! runtextmacro Unit_SetMana("/", "50.", "2.")
                    //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
                    //! runtextmacro Unit_SetModel("/", "units\\creeps\\KoboldGeomancer\\KoboldGeomancer.mdx", "", "", "", "")
                    //! runtextmacro Unit_SetMovement("/", "FOOT", "270.", "0.5", "0", "150.", "150.")
                    //! runtextmacro Unit_SetScale("/", "1.4", "1.")
                    //! runtextmacro Unit_SetShadow("/", "NORMAL", "140.", "140.", "50.", "50.")
                    //! runtextmacro Unit_SetSight("/", "800.", "1400.")
                    //! runtextmacro Unit_SetSoundset("/", "Kobold")
                    //! runtextmacro Unit_SetSpellPower("/", "25.")
                    //! runtextmacro Unit_SetSupply("/", "15")
                    //! runtextmacro Unit_SetVertexColor("/", "255", "255", "255", "255")

                    //! runtextmacro Unit_Finalize("/")

                    //Kobold Brown
                    //! runtextmacro Unit_Create("/", "KOBOLD_BROWN", "KoM", "Brown Kobold", "false", "ATTACKER", "0.85")

                    //! runtextmacro Unit_SetArmor("/", "LARGE", "1.", "Flesh")
                    //! runtextmacro Unit_SetAttack("/", "NORMAL", "1.35", "100.", "250.", "ground,ward", "0.", "MetalMediumChop")
                    //! runtextmacro Unit_SetBlend("/", "0.15")
                    //! runtextmacro Unit_SetCasting("/", "0.5", "0.51")
                    //! runtextmacro Unit_SetCollisionSize("/", "31.")
                    //! runtextmacro Unit_SetCombatFlags("/", "ground", "300.")
                    //! runtextmacro Unit_SetDamage("/", "NORMAL", "4", "1", "3", "0.38")
                    //! runtextmacro Unit_SetDeathTime("/", "3.")
                    //! runtextmacro Unit_SetElevation("/", "0", "30.", "10.", "10.")
                    //! runtextmacro Unit_SetExp("/", "10")
                    //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNKobold.blp")
                    //! runtextmacro Unit_SetLife("/", "175.", "1.")
                    //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
                    //! runtextmacro Unit_SetModel("/", "units\\creeps\\Kobold\\Kobold.mdx", "", "", "", "")
                    //! runtextmacro Unit_SetMovement("/", "FOOT", "270.", "0.5", "0", "150.", "150.")
                    //! runtextmacro Unit_SetScale("/", "0.85", "1.")
                    //! runtextmacro Unit_SetShadow("/", "NORMAL", "100.", "100.", "45.", "45.")
                    //! runtextmacro Unit_SetSight("/", "800.", "1400.")
                    //! runtextmacro Unit_SetSoundset("/", "Kobold")
                    //! runtextmacro Unit_SetSpellPower("/", "10.")
                    //! runtextmacro Unit_SetSupply("/", "20")
                    //! runtextmacro Unit_SetVertexColor("/", "255", "255", "165", "255")

                    //! runtextmacro Unit_Finalize("/")

                    //Kobold Red
                    //! runtextmacro Unit_Create("/", "KOBOLD_RED", "KoR", "Red Kobold", "false", "ATTACKER", "1.25")

                    //! runtextmacro Unit_SetArmor("/", "LARGE", "1.", "Flesh")
                    //! runtextmacro Unit_SetAttack("/", "NORMAL", "1.4", "100.", "250.", "ground,ward", "0.", "MetalMediumChop")
                    //! runtextmacro Unit_SetBlend("/", "0.15")
                    //! runtextmacro Unit_SetCasting("/", "0.5", "0.51")
                    //! runtextmacro Unit_SetCollisionSize("/", "31.")
                    //! runtextmacro Unit_SetCombatFlags("/", "ground", "300.")
                    //! runtextmacro Unit_SetDamage("/", "NORMAL", "7", "1", "3", "0.38")
                    //! runtextmacro Unit_SetDeathTime("/", "3.")
                    //! runtextmacro Unit_SetElevation("/", "0", "30.", "10.", "10.")
                    //! runtextmacro Unit_SetExp("/", "15")
                    //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNKobold.blp")
                    //! runtextmacro Unit_SetLife("/", "140.", "1.")
                    //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
                    //! runtextmacro Unit_SetModel("/", "units\\creeps\\Kobold\\Kobold.mdx", "", "", "", "")
                    //! runtextmacro Unit_SetMovement("/", "FOOT", "270.", "0.5", "0", "150.", "150.")
                    //! runtextmacro Unit_SetScale("/", "1.25", "1.")
                    //! runtextmacro Unit_SetShadow("/", "NORMAL", "140.", "140.", "50.", "50.")
                    //! runtextmacro Unit_SetSight("/", "800.", "1400.")
                    //! runtextmacro Unit_SetSoundset("/", "Kobold")
                    //! runtextmacro Unit_SetSpellPower("/", "12.")
                    //! runtextmacro Unit_SetSupply("/", "20")
                    //! runtextmacro Unit_SetVertexColor("/", "255", "150", "180", "255")

                    //! runtextmacro Unit_Finalize("/")

                    //Pandarene
                    //! runtextmacro Unit_Create("/", "PANDARENE", "Pan", "Pandarene", "false", "ATTACKER", "1.")

                    //! runtextmacro Unit_SetArmor("/", "LARGE", "2.", "Flesh")
                    //! runtextmacro Unit_SetAttack("/", "NORMAL", "1.6", "100.", "250.", "ground,ward", "0.", "WoodHeavyBash")
                    //! runtextmacro Unit_SetBlend("/", "0.15")
                    //! runtextmacro Unit_SetCasting("/", "0.5", "0.51")
                    //! runtextmacro Unit_SetCollisionSize("/", "48.")
                    //! runtextmacro Unit_SetCombatFlags("/", "ground", "300.")
                    //! runtextmacro Unit_SetDamage("/", "NORMAL", "12", "2", "3", "0.3")
                    //! runtextmacro Unit_SetDeathTime("/", "3.")
                    //! runtextmacro Unit_SetElevation("/", "0", "30.", "10.", "10.")
                    //! runtextmacro Unit_SetExp("/", "30")
                    //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNFurbolgPanda.blp")
                    //! runtextmacro Unit_SetLife("/", "200.", "2.")
                    //! runtextmacro Unit_SetMissilePoints("/", "100.", "0.", "0.", "60.")
                    //! runtextmacro Unit_SetModel("/", "units\\creeps\\FurbolgPanda\\FurbolgPanda.mdx", "", "", "medium", "")
                    //! runtextmacro Unit_SetMovement("/", "FOOT", "300.", "0.5", "4", "250.", "250.")
                    //! runtextmacro Unit_SetScale("/", "1.", "1.")
                    //! runtextmacro Unit_SetShadow("/", "NORMAL", "140.", "140.", "50.", "50.")
                    //! runtextmacro Unit_SetSight("/", "800.", "1400.")
                    //! runtextmacro Unit_SetSoundset("/", "Furbolg")
                    //! runtextmacro Unit_SetSpellPower("/", "14.")
                    //! runtextmacro Unit_SetSupply("/", "25")
                    //! runtextmacro Unit_SetVertexColor("/", "255", "255", "255", "255")

                    //! runtextmacro Unit_Finalize("/")

                    //Treant Green
                    //! runtextmacro Unit_Create("/", "TREANT_GREEN", "TrG", "Green Treant", "false", "ATTACKER", "1.25")

                    //! runtextmacro Unit_SetArmor("/", "LARGE", "0.", "Wood")
                    //! runtextmacro Unit_SetAttack("/", "NORMAL", "1.35", "100.", "250.", "ground,structure,debris,item,ward", "0.", "WoodMediumBash")
                    //! runtextmacro Unit_SetBlend("/", "0.15")
                    //! runtextmacro Unit_SetCasting("/", "0.5", "0.51")
                    //! runtextmacro Unit_SetCollisionSize("/", "32.")
                    //! runtextmacro Unit_SetCombatFlags("/", "ground", "500.")
                    //! runtextmacro Unit_SetDamage("/", "CHAOS", "22", "1", "4", "0.467")
                    //! runtextmacro Unit_SetDeathTime("/", "3.")
                    //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "10.")
                    //! runtextmacro Unit_SetExp("/", "70")
                    //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNCorruptedEnt.blp")
                    //! runtextmacro Unit_SetLife("/", "600.", "1.5")
                    //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
                    //! runtextmacro Unit_SetModel("/", "units\\creeps\\CorruptedEnt\\CorruptedEnt.mdx", "", "", "medium", "")
                    //! runtextmacro Unit_SetMovement("/", "FOOT", "280.", "0.5", "1", "200.", "200.")
                    //! runtextmacro Unit_SetScale("/", "1.", "1.35")
                    //! runtextmacro Unit_SetShadow("/", "NORMAL", "140.", "140.", "50.", "50.")
                    //! runtextmacro Unit_SetSight("/", "800.", "1400.")
                    //! runtextmacro Unit_SetSoundset("/", "CorruptedEnt")
                    //! runtextmacro Unit_SetSpellPower("/", "20.")
                    //! runtextmacro Unit_SetSupply("/", "20")
                    //! runtextmacro Unit_SetVertexColor("/", "170", "255", "60", "255")

                    //! runtextmacro Unit_Finalize("/")

                    //Treant Purple
                    //! runtextmacro Unit_Create("/", "TREANT_PURPLE", "TrP", "Purple Treant", "false", "ATTACKER", "0.9")

                    //! runtextmacro Unit_SetArmor("/", "LARGE", "0.", "Wood")
                    //! runtextmacro Unit_SetAttack("/", "NORMAL", "1.35", "100.", "250.", "ground,structure,debris,item,ward", "0.", "WoodMediumBash")
                    //! runtextmacro Unit_SetBlend("/", "0.15")
                    //! runtextmacro Unit_SetCasting("/", "0.5", "0.51")
                    //! runtextmacro Unit_SetCollisionSize("/", "32.")
                    //! runtextmacro Unit_SetCombatFlags("/", "ground", "500.")
                    //! runtextmacro Unit_SetDamage("/", "NORMAL", "15", "1", "2", "0.467")
                    //! runtextmacro Unit_SetDeathTime("/", "3.")
                    //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "10.")
                    //! runtextmacro Unit_SetExp("/", "55")
                    //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNCorruptedEnt.blp")
                    //! runtextmacro Unit_SetLife("/", "400.", "1.5")
                    //! runtextmacro Unit_SetMissilePoints("/", "100.", "0.", "0.", "60.")
                    //! runtextmacro Unit_SetModel("/", "units\\creeps\\CorruptedEnt\\CorruptedEnt.mdx", "", "", "medium", "")
                    //! runtextmacro Unit_SetMovement("/", "FOOT", "280.", "0.5", "1", "110.", "110.")
                    //! runtextmacro Unit_SetScale("/", "1.", "1.")
                    //! runtextmacro Unit_SetShadow("/", "NORMAL", "140.", "140.", "50.", "50.")
                    //! runtextmacro Unit_SetSight("/", "800.", "1400.")
                    //! runtextmacro Unit_SetSoundset("/", "CorruptedEnt")
                    //! runtextmacro Unit_SetSpellPower("/", "30.")
                    //! runtextmacro Unit_SetSupply("/", "21")
                    //! runtextmacro Unit_SetVertexColor("/", "255", "140", "255", "255")

                    //! runtextmacro Unit_Finalize("/")

                    //Tuskar
                    //! runtextmacro Unit_Create("/", "TUSKAR", "Tus", "Tuskar", "false", "ATTACKER", "0.75")

                    //! runtextmacro Unit_SetArmor("/", "MEDIUM", "0.", "Flesh")
                    //! runtextmacro Unit_SetAttack("/", "MISSILE", "1.8", "500.", "250.", "ground,air,ward", "0.", "")
                    //! runtextmacro Unit_SetAttackMissile("/", "abilities\\weapons\\TuskarSpear\\TuskarSpear.mdx", "1200.", "0.15")
                    //! runtextmacro Unit_SetBlend("/", "0.15")
                    //! runtextmacro Unit_SetCasting("/", "0.3", "0.51")
                    //! runtextmacro Unit_SetCollisionSize("/", "31.")
                    //! runtextmacro Unit_SetCombatFlags("/", "ground", "500.")
                    //! runtextmacro Unit_SetDamage("/", "PIERCE", "7", "3", "2", "0.3")
                    //! runtextmacro Unit_SetDeathTime("/", "2.")
                    //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "10.")
                    //! runtextmacro Unit_SetExp("/", "15")
                    //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNTuskaarGold.blp")
                    //! runtextmacro Unit_SetLife("/", "110.", "1.25")
                    //! runtextmacro Unit_SetMissilePoints("/", "60.", "11.", "62.", "71.")
                    //! runtextmacro Unit_SetModel("/", "Units\\Creeps\\tuskarRanged\\tuskarRanged.mdx", "", "", "", "")
                    //! runtextmacro Unit_SetMovement("/", "FOOT", "270.", "0.6", "0", "250.", "250.")
                    //! runtextmacro Unit_SetScale("/", "0.75", "1.25")
                    //! runtextmacro Unit_SetShadow("/", "NORMAL", "140.", "140.", "50.", "50.")
                    //! runtextmacro Unit_SetSight("/", "800.", "1400.")
                    //! runtextmacro Unit_SetSoundset("/", "Tuskarr")
                    //! runtextmacro Unit_SetSpellPower("/", "13.")
                    //! runtextmacro Unit_SetSupply("/", "15")
                    //! runtextmacro Unit_SetVertexColor("/", "255", "255", "255", "255")

                    //! runtextmacro Unit_Finalize("/")

                    //Wolf Mother
                    //! runtextmacro Unit_Create("/", "WOLF_MOTHER", "WoM", "Wolf Mother", "false", "ATTACKER", "1.45")

                    //! runtextmacro Unit_SetArmor("/", "LARGE", "2.", "Flesh")
                    //! runtextmacro Unit_SetAttack("/", "NORMAL", "1.4", "90.", "250.", "ground,ward", "0.", "WoodMediumBash")
                    //! runtextmacro Unit_SetBlend("/", "0.15")
                    //! runtextmacro Unit_SetCasting("/", "0.3", "0.51")
                    //! runtextmacro Unit_SetCollisionSize("/", "48.")
                    //! runtextmacro Unit_SetCombatFlags("/", "ground", "300.")
                    //! runtextmacro Unit_SetDamage("/", "NORMAL", "18", "3", "4", "0.33")
                    //! runtextmacro Unit_SetDeathTime("/", "1.75")
                    //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "45.")
                    //! runtextmacro Unit_SetExp("/", "60")
                    //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNTimberWolf.blp")
                    //! runtextmacro Unit_SetLife("/", "350.", "2.")
                    //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
                    //! runtextmacro Unit_SetModel("/", "units\\creeps\\WhiteWolf\\WhiteWolf.mdx", "", "", "", "")
                    //! runtextmacro Unit_SetMovement("/", "FOOT", "320.", "0.6", "5", "240.", "240.")
                    //! runtextmacro Unit_SetScale("/", "1.45", "2.")
                    //! runtextmacro Unit_SetShadow("/", "NORMAL", "180.", "180.", "70.", "70.")
                    //! runtextmacro Unit_SetSight("/", "800.", "1400.")
                    //! runtextmacro Unit_SetSoundset("/", "SpiritWolf")
                    //! runtextmacro Unit_SetSpellPower("/", "20.")
                    //! runtextmacro Unit_SetSupply("/", "50")
                    //! runtextmacro Unit_SetVertexColor("/", "150", "120", "255", "255")

                    //! runtextmacro Unit_Finalize("/")
            //Act2
                //Assassin
                //! runtextmacro Unit_Create("/", "ASSASSIN", "Ass", "Assassin", "false", "ATTACKER", "1.25")

                //! runtextmacro Unit_SetArmor("/", "UNARMORED", "1.", "Flesh")
                //! runtextmacro Unit_SetAttack("/", "NORMAL", "1.4", "100.", "250.", "ground,structure,debris,item,ward", "0.", "WoodHeavyBash")
                //! runtextmacro Unit_SetBlend("/", "0.15")
                //! runtextmacro Unit_SetCasting("/", "0.4", "0.5")
                //! runtextmacro Unit_SetCollisionSize("/", "32.")
                //! runtextmacro Unit_SetCombatFlags("/", "ground", "500.")
                //! runtextmacro Unit_SetDamage("/", "NORMAL", "10", "2", "6", "0.35")
                //! runtextmacro Unit_SetDeathTime("/", "2.5")
                //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "10.")
                //! runtextmacro Unit_SetExp("/", "100")
                //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNHellScream.blp")
                //! runtextmacro Unit_SetLife("/", "240.", "1.")
                //! runtextmacro Unit_SetMana("/", "200.", "3.")
                //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
                //! runtextmacro Unit_SetModel("/", "Units\\Spawns\\Act2\\Assassin\\Assassin.mdx", "", "", "large", "")
                //! runtextmacro Unit_SetMovement("/", "FOOT", "135.", "0.6", "5", "250.", "250.")
                //! runtextmacro Unit_SetScale("/", "1.1", "1.3")
                //! runtextmacro Unit_SetShadow("/", "NORMAL", "140.", "140.", "50.", "50.")
                //! runtextmacro Unit_SetSight("/", "800.", "1800.")
                //! runtextmacro Unit_SetSoundset("/", "PandarenBrewmaster")
                //! runtextmacro Unit_SetSpellPower("/", "60.")
                //! runtextmacro Unit_SetSupply("/", "30")

                //! runtextmacro Unit_Finalize("/")

                //Axe Fighter
                //! runtextmacro Unit_Create("/", "AXE_FIGHTER", "Axe", "Axe Fighter", "false", "ATTACKER", "1.2")

                //! runtextmacro Unit_SetArmor("/", "LARGE", "2.", "Flesh")
                //! runtextmacro Unit_SetAttack("/", "NORMAL", "1.6", "100.", "250.", "ground,structure,debris,item,ward", "0.", "MetalMediumChop")
                //! runtextmacro Unit_SetBlend("/", "0.15")
                //! runtextmacro Unit_SetCasting("/", "0.3", "0.51")
                //! runtextmacro Unit_SetCollisionSize("/", "32.")
                //! runtextmacro Unit_SetCombatFlags("/", "ground", "500.")
                //! runtextmacro Unit_SetDamage("/", "NORMAL", "16", "3", "3", "0.35")
                //! runtextmacro Unit_SetDeathTime("/", "1.75")
                //! runtextmacro Unit_SetElevation("/", "0", "30.", "10.", "10.")
                //! runtextmacro Unit_SetExp("/", "90")
                //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNGrunt.blp")
                //! runtextmacro Unit_SetLife("/", "400.", "2.")
                //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
                //! runtextmacro Unit_SetModel("/", "units\\orc\\Grunt\\Grunt.mdx", "", "", "", "")
                //! runtextmacro Unit_SetMovement("/", "FOOT", "125.", "0.5", "4", "240.", "240.")
                //! runtextmacro Unit_SetScale("/", "1.2", "1.")
                //! runtextmacro Unit_SetShadow("/", "NORMAL", "140.", "140.", "60.", "60.")
                //! runtextmacro Unit_SetSight("/", "800.", "1400.")
                //! runtextmacro Unit_SetSoundset("/", "Grunt")
                //! runtextmacro Unit_SetSpellPower("/", "40.")
                //! runtextmacro Unit_SetSupply("/", "20")

                //! runtextmacro Unit_Finalize("/")

                //Balduir
                //! runtextmacro Unit_Create("/", "BALDUIR", "Bal", "Balduir", "false", "ATTACKER", "1.75")

                //! runtextmacro Unit_SetArmor("/", "HERO", "12.", "Stone")
                //! runtextmacro Unit_SetAttack("/", "NORMAL", "2.2", "170.", "250.", "ground,structure,debris,item,ward", "0.", "MetalHeavySlice")
                //! runtextmacro Unit_SetBlend("/", "0.15")
                //! runtextmacro Unit_SetCasting("/", "0.5", "0.5")
                //! runtextmacro Unit_SetCollisionSize("/", "84.")
                //! runtextmacro Unit_SetCombatFlags("/", "ground", "500.")
                //! runtextmacro Unit_SetDamage("/", "NORMAL", "40", "2", "6", "0.33")
                //! runtextmacro Unit_SetDeathTime("/", "3.67")
                //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "10.")
                //! runtextmacro Unit_SetExp("/", "250")
                //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNBeastMaster.blp")
                //! runtextmacro Unit_SetLife("/", "1300.", "5.")
                //! runtextmacro Unit_SetMissilePoints("/", "90.", "0.", "0.", "60.")
                //! runtextmacro Unit_SetModel("/", "Units\\Spawns\\Act2\\Balduir\\Balduir.mdx", "", "", "large", "")
                //! runtextmacro Unit_SetMovement("/", "FOOT", "135.", "0.4", "1", "250.", "250.")
                //! runtextmacro Unit_SetScale("/", "1.75", "2.")
                //! runtextmacro Unit_SetShadow("/", "NORMAL", "230.", "230.", "75.", "75.")
                //! runtextmacro Unit_SetSight("/", "800.", "1800.")
                //! runtextmacro Unit_SetSoundset("/", "Beastmaster")
                //! runtextmacro Unit_SetSpellPower("/", "70.")
                //! runtextmacro Unit_SetSupply("/", "120")

                //! runtextmacro Unit_Finalize("/")

                //Catapult
                //! runtextmacro Unit_Create("/", "CATAPULT", "Cat", "Catapult", "false", "ATTACKER", "1.")

                //! runtextmacro Unit_SetArmor("/", "LARGE", "2.", "Wood")
                //! runtextmacro Unit_SetAttack("/", "ARTILLERY", "4.5", "1150.", "250.", "ground,structure,debris,item,ward", "0.", "")
                //! runtextmacro Unit_SetAttackMissile("/", "abilities\\weapons\\catapult\\catapultmissile.mdx", "900.", "0.35")
                //! runtextmacro Unit_AddAttackSplash("/", "40.", "1.")
                //! runtextmacro Unit_AddAttackSplash("/", "75.", "0.4")
                //! runtextmacro Unit_AddAttackSplash("/", "110.", "0.2")
                //! runtextmacro Unit_AddAttackSplashTargets("/", "ALLY")
                //! runtextmacro Unit_SetBlend("/", "0.15")
                //! runtextmacro Unit_SetCasting("/", "0.", "0.51")
                //! runtextmacro Unit_SetCollisionSize("/", "48.")
                //! runtextmacro Unit_SetCombatFlags("/", "ground", "1150.")
                //! runtextmacro Unit_SetDamage("/", "SIEGE", "20", "1", "15", "0.1")
                //! runtextmacro Unit_SetDeathTime("/", "3.34")
                //! runtextmacro Unit_SetElevation("/", "4", "50.", "45.", "45.")
                //! runtextmacro Unit_SetExp("/", "50")
                //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNCatapult.blp")
                //! runtextmacro Unit_SetLife("/", "300.", "0.")
                //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
                //! runtextmacro Unit_SetModel("/", "units\\orc\\catapult\\catapult.mdx", "", "", "", "")
                //! runtextmacro Unit_SetMovement("/", "FOOT", "110.", "0.4", "1", "185.", "185.")
                //! runtextmacro Unit_SetScale("/", "1.", "2.75")
                //! runtextmacro Unit_SetShadow("/", "NORMAL", "280.", "280.", "110.", "110.")
                //! runtextmacro Unit_SetSight("/", "1200.", "1400.")
                //! runtextmacro Unit_SetSoundset("/", "Catapult")
                //! runtextmacro Unit_SetSpellPower("/", "50.")
                //! runtextmacro Unit_SetSupply("/", "25")

                //! runtextmacro Unit_Finalize("/")

                //Demolisher
                //! runtextmacro Unit_Create("/", "DEMOLISHER", "Dem", "Demolisher", "false", "ATTACKER", "1.5")

                //! runtextmacro Unit_SetArmor("/", "FORT", "10.", "Wood")
                //! runtextmacro Unit_SetAttack("/", "ARTILLERY", "4.5", "1450.", "250.", "ground,structure,debris,item,ward", "0.", "")
                //! runtextmacro Unit_SetAttackMissile("/", "abilities\\weapons\\DemolisherMissile\\DemolisherMissile.mdx", "900.", "0.35")
                //! runtextmacro Unit_AddAttackSplash("/", "80.", "1.")
                //! runtextmacro Unit_AddAttackSplash("/", "150.", "0.4")
                //! runtextmacro Unit_AddAttackSplash("/", "220.", "0.2")
                //! runtextmacro Unit_AddAttackSplashTargets("/", "ALLY")
                //! runtextmacro Unit_SetBlend("/", "0.15")
                //! runtextmacro Unit_SetCasting("/", "0.", "0.51")
                //! runtextmacro Unit_SetCollisionSize("/", "72.")
                //! runtextmacro Unit_SetCombatFlags("/", "ground", "1450.")
                //! runtextmacro Unit_SetDamage("/", "SIEGE", "70", "1", "30", "0.1")
                //! runtextmacro Unit_SetDeathTime("/", "3.34")
                //! runtextmacro Unit_SetElevation("/", "4", "50.", "45.", "45.")
                //! runtextmacro Unit_SetExp("/", "150")
                //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNDemolisher.blp")
                //! runtextmacro Unit_SetLife("/", "300.", "0.")
                //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
                //! runtextmacro Unit_SetModel("/", "units\\orc\\catapult\\catapult_V1.mdx", "", "", "", "")
                //! runtextmacro Unit_SetMovement("/", "FOOT", "135.", "0.4", "1", "185.", "185.")
                //! runtextmacro Unit_SetScale("/", "1.", "2.75")
                //! runtextmacro Unit_SetShadow("/", "NORMAL", "280.", "280.", "110.", "110.")
                //! runtextmacro Unit_SetSight("/", "1200.", "1400.")
                //! runtextmacro Unit_SetSoundset("/", "Catapult")
                //! runtextmacro Unit_SetSpellPower("/", "75.")
                //! runtextmacro Unit_SetSupply("/", "50")

                //! runtextmacro Unit_Finalize("/")

                //Drummer
                //! runtextmacro Unit_Create("/", "DRUMMER", "Dru", "Drummer", "false", "ATTACKER", "1.5")

                //! runtextmacro Unit_SetArmor("/", "FORT", "1.", "Flesh")
                //! runtextmacro Unit_SetAttack("/", "MISSILE", "1.44", "500.", "250.", "ground,structure,debris,air,item,ward", "0.", "")
                //! runtextmacro Unit_SetAttackMissile("/", "Abilities\\Weapons\\Axe\\AxeMissile.mdx", "1200.", "0.15")
                //! runtextmacro Unit_SetBlend("/", "0.15")
                //! runtextmacro Unit_SetCasting("/", "0.5", "0.5")
                //! runtextmacro Unit_SetCollisionSize("/", "48.")
                //! runtextmacro Unit_SetCombatFlags("/", "ground", "500.")
                //! runtextmacro Unit_SetDamage("/", "PIERCE", "4", "1", "3", "0.85")
                //! runtextmacro Unit_SetDeathTime("/", "3.")
                //! runtextmacro Unit_SetElevation("/", "2", "50.", "10.", "45.")
                //! runtextmacro Unit_SetExp("/", "80")
                //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNKotoBeast.blp")
                //! runtextmacro Unit_SetLife("/", "300.", "10.")
                //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
                //! runtextmacro Unit_SetModel("/", "units\\orc\\KotoBeast\\KotoBeast.mdx", "", "", "large", "")
                //! runtextmacro Unit_SetMovement("/", "HORSE", "110.", "0.5", "1", "100.", "240.")
                //! runtextmacro Unit_SetScale("/", "1.", "2.25")
                //! runtextmacro Unit_SetShadow("/", "NORMAL", "310.", "280.", "120.", "120.")
                //! runtextmacro Unit_SetSight("/", "800.", "1400.")
                //! runtextmacro Unit_SetSoundset("/", "KotoBeast")
                //! runtextmacro Unit_SetSpellPower("/", "50.")
                //! runtextmacro Unit_SetSupply("/", "35")

                //! runtextmacro Unit_Finalize("/")

                //Leader
                //! runtextmacro Unit_Create("/", "LEADER", "Lea", "Leader", "true", "ATTACKER", "1.")

                //! runtextmacro Unit_SetArmor("/", "HERO", "5.", "Flesh")
                //! runtextmacro Unit_SetAttack("/", "NORMAL", "1.5", "100.", "250.", "ground,structure,debris,item,ward", "0.", "MetalMediumChop")
                //! runtextmacro Unit_SetBlend("/", "0.15")
                //! runtextmacro Unit_SetCasting("/", "0.3", "0.51")
                //! runtextmacro Unit_SetCollisionSize("/", "32.")
                //! runtextmacro Unit_SetCombatFlags("/", "ground", "500.")
                //! runtextmacro Unit_SetDamage("/", "HERO", "20", "2", "8", "0.5")
                //! runtextmacro Unit_SetDeathTime("/", "1.75")
                //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "10.")
                //! runtextmacro Unit_SetExp("/", "200")
                //! runtextmacro Unit_SetHeroNames("/", "Tokkan")
                //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNChaosWarlord.blp")
                //! runtextmacro Unit_SetLife("/", "4000.", "5.")
                //! runtextmacro Unit_SetMana("/", "200.", "2.5")
                //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
                //! runtextmacro Unit_SetModel("/", "units\\demon\\ChaosWarlord\\ChaosWarlord.mdx", "", "", "medium", "")
                //! runtextmacro Unit_SetMovement("/", "FOOT", "150.", "0.6", "4", "240.", "240.")
                //! runtextmacro Unit_SetScale("/", "1.25", "1.")
                //! runtextmacro Unit_SetShadow("/", "NORMAL", "120.", "120.", "60.", "60.")
                //! runtextmacro Unit_SetSight("/", "800.", "1400.")
                //! runtextmacro Unit_SetSoundset("/", "ChaosWarlord")
                //! runtextmacro Unit_SetSpellPower("/", "90.")
                //! runtextmacro Unit_SetSupply("/", "100")

                //! runtextmacro Unit_Finalize("/")

                //Nagarosh
                //! runtextmacro Unit_Create("/", "NAGAROSH", "Nag", "Nagarosh", "false", "ATTACKER", "1.")

                //! runtextmacro Unit_SetArmor("/", "LIGHT", "0.", "Ethereal")
                //! runtextmacro Unit_SetAttack("/", "NORMAL", "2.28", "100.", "250.", "ground,structure,debris,item,ward", "0.", "")
                //! runtextmacro Unit_SetBlend("/", "0.15")
                //! runtextmacro Unit_SetCasting("/", "0.3", "0.51")
                //! runtextmacro Unit_SetCollisionSize("/", "32.")
                //! runtextmacro Unit_SetCombatFlags("/", "ground", "500.")
                //! runtextmacro Unit_SetDamage("/", "MAGIC", "10", "2", "3", "0.5")
                //! runtextmacro Unit_SetDeathTime("/", "1.75")
                //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "10.")
                //! runtextmacro Unit_SetExp("/", "100")
                //! runtextmacro Unit_SetHeroNames("/", "Tokkan")
                //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNHeroFarseer.blp")
                //! runtextmacro Unit_SetLife("/", "825.", "2.75")
                //! runtextmacro Unit_SetMana("/", "400.", "2.5")
                //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
                //! runtextmacro Unit_SetModel("/", "units\\orc\\HeroFarSeer\\HeroFarSeer.mdx", "", "", "medium", "")
                //! runtextmacro Unit_SetMovement("/", "FOOT", "150.", "0.6", "4", "240.", "240.")
                //! runtextmacro Unit_SetScale("/", "1.", "1.")
                //! runtextmacro Unit_SetShadow("/", "NORMAL", "120.", "120.", "60.", "60.")
                //! runtextmacro Unit_SetSight("/", "800.", "1400.")
                //! runtextmacro Unit_SetSoundset("/", "ChaosWarlord")
                //! runtextmacro Unit_SetSpellPower("/", "70.")
                //! runtextmacro Unit_SetSupply("/", "50")
                //! runtextmacro Unit_SetVertexColor("/", "255", "255", "255", "190")

                //! runtextmacro Unit_Finalize("/")

                //Peon
                //! runtextmacro Unit_Create("/", "PEON", "Peo", "Peon", "false", "ATTACKER", "1.")

                //! runtextmacro Unit_SetArmor("/", "MEDIUM", "0.", "Flesh")
                //! runtextmacro Unit_SetAttack("/", "NORMAL", "3.", "90.", "250.", "ground,structure,debris,item,ward", "0.", "MetalLightChop")
                //! runtextmacro Unit_SetBlend("/", "0.15")
                //! runtextmacro Unit_SetCasting("/", "0.3", "0.51")
                //! runtextmacro Unit_SetCollisionSize("/", "16.")
                //! runtextmacro Unit_SetCombatFlags("/", "ground", "500.")
                //! runtextmacro Unit_SetDamage("/", "NORMAL", "5", "1", "2", "0.5")
                //! runtextmacro Unit_SetDeathTime("/", "2.")
                //! runtextmacro Unit_SetElevation("/", "0", "20.", "10.", "10.")
                //! runtextmacro Unit_SetExp("/", "20")
                //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNPeon.blp")
                //! runtextmacro Unit_SetLife("/", "120.", "0.5")
                //! runtextmacro Unit_SetMissilePoints("/", "45.", "0.", "0.", "60.")
                //! runtextmacro Unit_SetModel("/", "units\\orc\\Peon\\Peon.mdx", "", "", "", "")
                //! runtextmacro Unit_SetMovement("/", "FOOT", "170.", "0.6", "0", "180.", "180.")
                //! runtextmacro Unit_SetScale("/", "0.85", "1.")
                //! runtextmacro Unit_SetShadow("/", "NORMAL", "120.", "120.", "50.", "50.")
                //! runtextmacro Unit_SetSight("/", "600.", "800.")
                //! runtextmacro Unit_SetSoundset("/", "Peon")
                //! runtextmacro Unit_SetSpellPower("/", "35.")
                //! runtextmacro Unit_SetSupply("/", "15")

                //! runtextmacro Unit_Finalize("/")

                //Raider
                //! runtextmacro Unit_Create("/", "RAIDER", "Rai", "Raider", "false", "ATTACKER", "1.")

                //! runtextmacro Unit_SetArmor("/", "MEDIUM", "0.", "Flesh")
                //! runtextmacro Unit_SetAttack("/", "NORMAL", "1.85", "135.", "400.", "ground,structure,debris,item,ward", "0.", "MetalMediumSlice")
                //! runtextmacro Unit_SetBlend("/", "0.15")
                //! runtextmacro Unit_SetCasting("/", "0.6", "0.2")
                //! runtextmacro Unit_SetCollisionSize("/", "32.")
                //! runtextmacro Unit_SetCombatFlags("/", "ground", "500.")
                //! runtextmacro Unit_SetDamage("/", "SIEGE", "10", "1", "5", "0.5")
                //! runtextmacro Unit_SetDeathTime("/", "1.87")
                //! runtextmacro Unit_SetElevation("/", "0", "30.", "10.", "45.")
                //! runtextmacro Unit_SetExp("/", "40")
                //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNRaider.blp")
                //! runtextmacro Unit_SetLife("/", "200.", "0.5")
                //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
                //! runtextmacro Unit_SetModel("/", "units\\orc\\WolfRider\\WolfRider.mdx", "", "", "medium", "")
                //! runtextmacro Unit_SetMovement("/", "HORSE", "150.", "0.5", "4", "360.", "360.")
                //! runtextmacro Unit_SetScale("/", "1.", "1.6")
                //! runtextmacro Unit_SetShadow("/", "NORMAL", "190.", "190.", "75.", "75.")
                //! runtextmacro Unit_SetSight("/", "800.", "1400.")
                //! runtextmacro Unit_SetSoundset("/", "Wolfrider")
                //! runtextmacro Unit_SetSpellPower("/", "30.")
                //! runtextmacro Unit_SetSupply("/", "35")

                //! runtextmacro Unit_Finalize("/")

                //Spear Scout
                //! runtextmacro Unit_Create("/", "SPEAR_SCOUT", "Spe", "Spear Scout", "false", "ATTACKER", "1.")

                //! runtextmacro Unit_SetArmor("/", "MEDIUM", "0.", "Flesh")
                //! runtextmacro Unit_SetAttack("/", "MISSILE", "2.31", "135.", "250.", "ground,structure,debris,item,ward", "0.", "")
                //! runtextmacro Unit_SetAttackMissile("/", "abilities\\weapons\\huntermissile\\huntermissile.mdx", "1200.", "0.15")
                //! runtextmacro Unit_SetBlend("/", "0.15")
                //! runtextmacro Unit_SetCasting("/", "0.", "0.51")
                //! runtextmacro Unit_SetCollisionSize("/", "32.")
                //! runtextmacro Unit_SetCombatFlags("/", "ground", "500.")
                //! runtextmacro Unit_SetDamage("/", "PIERCE", "14", "1", "5", "0.31")
                //! runtextmacro Unit_SetDeathTime("/", "2.1")
                //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "10.")
                //! runtextmacro Unit_SetExp("/", "25")
                //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNWyvernRider.blp")
                //! runtextmacro Unit_SetLife("/", "225.", "0.75")
                //! runtextmacro Unit_SetMana("/", "75.", "1.")
                //! runtextmacro Unit_SetMissilePoints("/", "60.", "-5.", "-34.", "113.")
                //! runtextmacro Unit_SetModel("/", "Units\\Spawns\\Act2\\SpearScout\\SpearScout.mdx", "", "", "", "")
                //! runtextmacro Unit_SetMovement("/", "FOOT", "125.", "0.6", "5", "240.", "240.")
                //! runtextmacro Unit_SetScale("/", "1.35", "1.1")
                //! runtextmacro Unit_SetShadow("/", "NORMAL", "140.", "140.", "60.", "60.")
                //! runtextmacro Unit_SetSight("/", "800.", "1400.")
                //! runtextmacro Unit_SetSoundset("/", "HeadHunter")
                //! runtextmacro Unit_SetSpellPower("/", "35.")
                //! runtextmacro Unit_SetSupply("/", "20")

                //! runtextmacro Unit_Finalize("/")

                //Tarog
                //! runtextmacro Unit_Create("/", "TAROG", "Tar", "Tarog", "false", "ATTACKER", "1.")

                //! runtextmacro Unit_SetArmor("/", "MEDIUM", "0.", "Ethereal")
                //! runtextmacro Unit_SetAttack("/", "HOMING_MISSILE", "1.75", "600.", "250.", "ground,structure,debris,air,item,ward", "0.", "")
                //! runtextmacro Unit_SetAttackMissile("/", "Abilities\\Weapons\\FireBallMissile\\FireBallMissile.mdx", "1200.", "0.1")
                //! runtextmacro Unit_SetBlend("/", "0.15")
                //! runtextmacro Unit_SetCasting("/", "0.3", "0.51")
                //! runtextmacro Unit_SetCollisionSize("/", "31.")
                //! runtextmacro Unit_SetCombatFlags("/", "ground", "600.")
                //! runtextmacro Unit_SetDamage("/", "CHAOS", "10", "2", "3", "0.43")
                //! runtextmacro Unit_SetDeathTime("/", "1.33")
                //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "10.")
                //! runtextmacro Unit_SetExp("/", "120")
                //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNChaosWarlockGreen.blp")
                //! runtextmacro Unit_SetLife("/", "825.", "2.75")
                //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
                //! runtextmacro Unit_SetModel("/", "Units\\Spawns\\Act2\\Tarog\\Tarog.mdx", "", "", "", "")
                //! runtextmacro Unit_SetMovement("/", "FOOT", "135.", "0.6", "0", "250.", "250.")
                //! runtextmacro Unit_SetScale("/", "1.35", "1.15")
                //! runtextmacro Unit_SetShadow("/", "NORMAL", "150.", "150.", "60.", "60.")
                //! runtextmacro Unit_SetSight("/", "800.", "1400.")
                //! runtextmacro Unit_SetSoundset("/", "Shaman")
                //! runtextmacro Unit_SetSpellPower("/", "85.")
                //! runtextmacro Unit_SetSupply("/", "60")
                //! runtextmacro Unit_SetVertexColor("/", "255", "255", "255", "190")

                //! runtextmacro Unit_Finalize("/")

                //True Leader
                //! runtextmacro Unit_Create("/", "TRUE_LEADER", "TrL", "True Leader", "true", "ATTACKER", "1.25")

                //! runtextmacro Unit_SetArmor("/", "HERO", "7.", "Metal")
                //! runtextmacro Unit_SetAttack("/", "NORMAL", "2.2", "100.", "250.", "ground,structure,debris,item,ward", "0.", "MetalHeavySlice")
                //! runtextmacro Unit_SetBlend("/", "0.15")
                //! runtextmacro Unit_SetCasting("/", "0.5", "1.67")
                //! runtextmacro Unit_SetCollisionSize("/", "32.")
                //! runtextmacro Unit_SetCombatFlags("/", "ground", "500.")
                //! runtextmacro Unit_SetDamage("/", "HERO", "30", "2", "6", "0.433")
                //! runtextmacro Unit_SetDeathTime("/", "1.5")
                //! runtextmacro Unit_SetElevation("/", "0", "30.", "10.", "10.")
                //! runtextmacro Unit_SetExp("/", "200")
                //! runtextmacro Unit_SetHeroNames("/", "Crook")
                //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNHeroPaladin.blp")
                //! runtextmacro Unit_SetLife("/", "2500.", "5.")
                //! runtextmacro Unit_SetMana("/", "200.", "2.5")
                //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
                //! runtextmacro Unit_SetModel("/", "units\\other\\Proudmoore\\Proudmoore.mdx", "", "", "", "")
                //! runtextmacro Unit_SetMovement("/", "FOOT", "180.", "1.", "5", "200.", "200.")
                //! runtextmacro Unit_SetScale("/", "1.25", "1.1")
                //! runtextmacro Unit_SetShadow("/", "NORMAL", "100.", "100.", "50.", "50.")
                //! runtextmacro Unit_SetSight("/", "800.", "1800.")
                //! runtextmacro Unit_SetSoundset("/", "Proudmoore")
                //! runtextmacro Unit_SetSpellPower("/", "120.")
                //! runtextmacro Unit_SetSupply("/", "100")

                //! runtextmacro Unit_Finalize("/")

        // Summons
            //Arctic Wolf
            //! runtextmacro Unit_Create("/", "ARCTIC_WOLF", "ArW", "Arctic Wolf (Level 1)", "false", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "LARGE", "2.", "Flesh")
            //! runtextmacro Unit_AddAttachment("/", "Abilities\\Weapons\\SpiritOfVengeanceMissile\\SpiritOfVengeanceMissile.mdl", "HAND_LEFT", "NORMAL")
            //! runtextmacro Unit_AddAttachment("/", "Abilities\\Weapons\\SpiritOfVengeanceMissile\\SpiritOfVengeanceMissile.mdl", "HAND_RIGHT", "NORMAL")
            //! runtextmacro Unit_AddAttachment("/", "Abilities\\Weapons\\SpiritOfVengeanceMissile\\SpiritOfVengeanceMissile.mdl", "FOOT_LEFT", "NORMAL")
            //! runtextmacro Unit_AddAttachment("/", "Abilities\\Weapons\\SpiritOfVengeanceMissile\\SpiritOfVengeanceMissile.mdl", "FOOT_RIGHT", "NORMAL")
            //! runtextmacro Unit_SetAttack("/", "NORMAL", "1.35", "90.", "250.", "ground,structure,debris,item,ward", "0.", "WoodMediumBash")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.3", "0.51")
            //! runtextmacro Unit_SetCollisionSize("/", "33.")
            //! runtextmacro Unit_SetCombatFlags("/", "ground", "500.")
            //! runtextmacro Unit_SetDamage("/", "NORMAL", "30", "2", "9", "0.33")
            //! runtextmacro Unit_SetDeathTime("/", "1.75")
            //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "45.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNTimberWolf.blp")
            //! runtextmacro Unit_SetLife("/", "750.", "0.")
            //! runtextmacro Unit_SetMana("/", "300.", "0")
            //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
            //! runtextmacro Unit_SetModel("/", "units\\creeps\\WhiteWolf\\WhiteWolf.mdx", "", "", "", "")
            //! runtextmacro Unit_SetMovement("/", "FOOT", "320.", "0.6", "5", "240.", "240.")
            //! runtextmacro Unit_SetScale("/", "1.25", "2.")
            //! runtextmacro Unit_SetShadow("/", "NORMAL", "180.", "180.", "70.", "70.")
            //! runtextmacro Unit_SetSight("/", "800.", "1400.")
            //! runtextmacro Unit_SetSoundset("/", "SpiritWolf")
            //! runtextmacro Unit_SetSpellPower("/", "50.")
            //! runtextmacro Unit_SetVertexColor("/", "150", "120", "255", "200")

            //! runtextmacro Unit_Finalize("/")

            //Arctic Wolf2
            //! runtextmacro Unit_Create("/", "ARCTIC_WOLF2", "AW2", "Arctic Wolf (Level 2)", "false", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "LARGE", "2.", "Flesh")
            //! runtextmacro Unit_AddAttachment("/", "Abilities\\Weapons\\SpiritOfVengeanceMissile\\SpiritOfVengeanceMissile.mdl", "HAND_LEFT", "NORMAL")
            //! runtextmacro Unit_AddAttachment("/", "Abilities\\Weapons\\SpiritOfVengeanceMissile\\SpiritOfVengeanceMissile.mdl", "HAND_RIGHT", "NORMAL")
            //! runtextmacro Unit_AddAttachment("/", "Abilities\\Weapons\\SpiritOfVengeanceMissile\\SpiritOfVengeanceMissile.mdl", "FOOT_LEFT", "NORMAL")
            //! runtextmacro Unit_AddAttachment("/", "Abilities\\Weapons\\SpiritOfVengeanceMissile\\SpiritOfVengeanceMissile.mdl", "FOOT_RIGHT", "NORMAL")
            //! runtextmacro Unit_SetAttack("/", "NORMAL", "1.35", "90.", "250.", "ground,structure,debris,item,ward", "0.", "WoodMediumBash")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.3", "0.51")
            //! runtextmacro Unit_SetCollisionSize("/", "33.")
            //! runtextmacro Unit_SetCombatFlags("/", "ground", "500.")
            //! runtextmacro Unit_SetDamage("/", "NORMAL", "48", "2", "11", "0.33")
            //! runtextmacro Unit_SetDeathTime("/", "1.75")
            //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "45.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNTimberWolf.blp")
            //! runtextmacro Unit_SetLife("/", "750.", "0.")
            //! runtextmacro Unit_SetMana("/", "300.", "0")
            //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
            //! runtextmacro Unit_SetModel("/", "units\\creeps\\WhiteWolf\\WhiteWolf.mdx", "", "", "", "")
            //! runtextmacro Unit_SetMovement("/", "FOOT", "320.", "0.6", "5", "240.", "240.")
            //! runtextmacro Unit_SetScale("/", "1.375", "2.")
            //! runtextmacro Unit_SetShadow("/", "NORMAL", "180.", "180.", "70.", "70.")
            //! runtextmacro Unit_SetSight("/", "800.", "1400.")
            //! runtextmacro Unit_SetSoundset("/", "SpiritWolf")
            //! runtextmacro Unit_SetSpellPower("/", "80.")
            //! runtextmacro Unit_SetVertexColor("/", "150", "120", "255", "255")

            //! runtextmacro Unit_Finalize("/")

            //Arctic Wolf3
            //! runtextmacro Unit_Create("/", "ARCTIC_WOLF3", "AW3", "Arctic Wolf (Level 3)", "false", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "LARGE", "2.", "Flesh")
            //! runtextmacro Unit_AddAttachment("/", "Abilities\\Weapons\\SpiritOfVengeanceMissile\\SpiritOfVengeanceMissile.mdl", "HAND_LEFT", "NORMAL")
            //! runtextmacro Unit_AddAttachment("/", "Abilities\\Weapons\\SpiritOfVengeanceMissile\\SpiritOfVengeanceMissile.mdl", "HAND_RIGHT", "NORMAL")
            //! runtextmacro Unit_AddAttachment("/", "Abilities\\Weapons\\SpiritOfVengeanceMissile\\SpiritOfVengeanceMissile.mdl", "FOOT_LEFT", "NORMAL")
            //! runtextmacro Unit_AddAttachment("/", "Abilities\\Weapons\\SpiritOfVengeanceMissile\\SpiritOfVengeanceMissile.mdl", "FOOT_RIGHT", "NORMAL")
            //! runtextmacro Unit_SetAttack("/", "NORMAL", "1.35", "90.", "250.", "ground,structure,debris,item,ward", "0.", "WoodMediumBash")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.3", "0.51")
            //! runtextmacro Unit_SetCollisionSize("/", "33.")
            //! runtextmacro Unit_SetCombatFlags("/", "ground", "500.")
            //! runtextmacro Unit_SetDamage("/", "NORMAL", "70", "2", "22", "0.33")
            //! runtextmacro Unit_SetDeathTime("/", "1.75")
            //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "45.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNTimberWolf.blp")
            //! runtextmacro Unit_SetLife("/", "750.", "0.")
            //! runtextmacro Unit_SetMana("/", "300.", "0")
            //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
            //! runtextmacro Unit_SetModel("/", "units\\creeps\\WhiteWolf\\WhiteWolf.mdx", "", "", "", "")
            //! runtextmacro Unit_SetMovement("/", "FOOT", "320.", "0.6", "5", "240.", "240.")
            //! runtextmacro Unit_SetScale("/", "1.5", "2.")
            //! runtextmacro Unit_SetShadow("/", "NORMAL", "180.", "180.", "70.", "70.")
            //! runtextmacro Unit_SetSight("/", "800.", "1400.")
            //! runtextmacro Unit_SetSoundset("/", "SpiritWolf")
            //! runtextmacro Unit_SetSpellPower("/", "110.")
            //! runtextmacro Unit_SetVertexColor("/", "150", "120", "255", "255")

            //! runtextmacro Unit_Finalize("/")

            //Barrier
            //! runtextmacro Unit_Create("/", "BARRIER", "Bar", "Barrier (Level 1)", "false", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "FORT", "5.", "Stone")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.", "0.51")
            //! runtextmacro Unit_AddClass("/", "WARD")
            //! runtextmacro Unit_SetCollisionSize("/", "40.")
            //! runtextmacro Unit_SetCombatFlags("/", "structure", "0.")
            //! runtextmacro Unit_SetDeathTime("/", "3.")
            //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "10.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNFreezingBreath.blp")
            //! runtextmacro Unit_SetLife("/", "125.", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
            //! runtextmacro Unit_SetModel("/", "Units\\Summons\\Barrier\\Barrier.mdx", "", "", "medium", "")
            //! runtextmacro Unit_SetMovement("/", "NONE", "1.", "0.", "0", "0.", "0.")
            //! runtextmacro Unit_SetScale("/", "1.", "1.45")
            //! runtextmacro Unit_SetSpellPower("/", "60.")

            //! runtextmacro Unit_Finalize("/")

            //Barrier2
            //! runtextmacro Unit_Create("/", "BARRIER2", "Ba2", "Barrier (Level 2)", "false", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "FORT", "6.", "Stone")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.", "0.51")
            //! runtextmacro Unit_AddClass("/", "STRUCTURE")
            //! runtextmacro Unit_SetCollisionSize("/", "40.")
            //! runtextmacro Unit_SetCombatFlags("/", "structure", "0.")
            //! runtextmacro Unit_SetDeathTime("/", "3.")
            //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "10.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNFreezingBreath.blp")
            //! runtextmacro Unit_SetLife("/", "180.", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
            //! runtextmacro Unit_SetModel("/", "Units\\Summons\\Barrier\\Barrier.mdx", "", "", "medium", "")
            //! runtextmacro Unit_SetScale("/", "1.", "1.45")
            //! runtextmacro Unit_SetSpellPower("/", "70.")

            //! runtextmacro Unit_Finalize("/")

            //Barrier3
            //! runtextmacro Unit_Create("/", "BARRIER3", "Ba3", "Barrier (Level 3)", "false", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "FORT", "7.", "Stone")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.", "0.51")
            //! runtextmacro Unit_AddClass("/", "STRUCTURE")
            //! runtextmacro Unit_SetCollisionSize("/", "40.")
            //! runtextmacro Unit_SetCombatFlags("/", "structure", "0.")
            //! runtextmacro Unit_SetDeathTime("/", "3.")
            //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "10.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNFreezingBreath.blp")
            //! runtextmacro Unit_SetLife("/", "240.", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
            //! runtextmacro Unit_SetModel("/", "Units\\Summons\\Barrier\\Barrier.mdx", "", "", "medium", "")
            //! runtextmacro Unit_SetScale("/", "1.", "1.45")
            //! runtextmacro Unit_SetSpellPower("/", "80.")

            //! runtextmacro Unit_Finalize("/")

            //Barrier4
            //! runtextmacro Unit_Create("/", "BARRIER4", "Ba4", "Barrier (Level 4)", "false", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "FORT", "8.", "Stone")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.", "0.51")
            //! runtextmacro Unit_AddClass("/", "STRUCTURE")
            //! runtextmacro Unit_SetCollisionSize("/", "40.")
            //! runtextmacro Unit_SetCombatFlags("/", "structure", "0.")
            //! runtextmacro Unit_SetDeathTime("/", "3.")
            //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "10.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNFreezingBreath.blp")
            //! runtextmacro Unit_SetLife("/", "310.", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
            //! runtextmacro Unit_SetModel("/", "Units\\Summons\\Barrier\\Barrier.mdx", "", "", "medium", "")
            //! runtextmacro Unit_SetScale("/", "1.", "1.45")
            //! runtextmacro Unit_SetSpellPower("/", "90.")

            //! runtextmacro Unit_Finalize("/")

            //Barrier5
            //! runtextmacro Unit_Create("/", "BARRIER5", "Ba5", "Barrier (Level 5)", "false", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "FORT", "9.", "Stone")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.", "0.51")
            //! runtextmacro Unit_AddClass("/", "STRUCTURE")
            //! runtextmacro Unit_SetCollisionSize("/", "40.")
            //! runtextmacro Unit_SetCombatFlags("/", "structure", "0.")
            //! runtextmacro Unit_SetDeathTime("/", "3.")
            //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "10.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNFreezingBreath.blp")
            //! runtextmacro Unit_SetLife("/", "400.", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
            //! runtextmacro Unit_SetModel("/", "Units\\Summons\\Barrier\\Barrier.mdx", "", "", "medium", "")
            //! runtextmacro Unit_SetScale("/", "1.", "1.45")
            //! runtextmacro Unit_SetSpellPower("/", "100.")

            //! runtextmacro Unit_Finalize("/")

            //Cobra Lily
            //! runtextmacro Unit_Create("/", "COBRA_LILY", "CoL", "Cobra Lily (Level 1)", "false", "ATTACKER", "1.")

            //! runtextmacro Unit_SetArmor("/", "LARGE", "0.", "Flesh")
            //! runtextmacro Unit_AddAttachment("/", "Units\\CobraLily\\LightingOrb.mdx", "HEAD", "NORMAL")
            //! runtextmacro Unit_SetAttack("/", "HOMING_MISSILE", "1.25", "500.", "250.", "ground,structure,debris,air,item,ward", "0.", "")
            //! runtextmacro Unit_SetAttackMissile("/", "Abilities\\Weapons\\snapMissile\\snapMissile.mdl", "600.", "0.1")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.3", "0.51")
            //! runtextmacro Unit_AddClass("/", "WARD")
            //! runtextmacro Unit_SetCollisionSize("/", "16.")
            //! runtextmacro Unit_SetCombatFlags("/", "ground", "600.")
            //! runtextmacro Unit_SetDamage("/", "PIERCE", "12", "1", "3", "0.4")
            //! runtextmacro Unit_SetDeathTime("/", "1.07")
            //! runtextmacro Unit_SetElevation("/", "0", "50.", "25.", "25.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNDeathAndDecay.blp")
            //! runtextmacro Unit_SetLife("/", "150.", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "100.", "30.", "30.", "225.")
            //! runtextmacro Unit_SetModel("/", "Units\\CobraLily\\CobraLily.mdx", "", "", "", "")
            //! runtextmacro Unit_SetScale("/", "0.7", "0.75")
            //! runtextmacro Unit_SetShadow("/", "NORMAL", "90.", "90.", "35.", "35.")
            //! runtextmacro Unit_SetSight("/", "800.", "1200.")
            //! runtextmacro Unit_SetSpellPower("/", "15.")
            //! runtextmacro Unit_SetVertexColor("/", "0", "255", "0", "255")

            //! runtextmacro Unit_Finalize("/")

            //Cobra Lily2
            //! runtextmacro Unit_Create("/", "COBRA_LILY2", "CL2", "Cobra Lily (Level 2)", "false", "ATTACKER", "1.")

            //! runtextmacro Unit_SetArmor("/", "LARGE", "1.", "Flesh")
            //! runtextmacro Unit_AddAttachment("/", "Units\\CobraLily\\LightingOrb.mdx", "HEAD", "NORMAL")
            //! runtextmacro Unit_SetAttack("/", "HOMING_MISSILE", "1.25", "500.", "250.", "ground,structure,debris,air,item,ward", "0.", "")
            //! runtextmacro Unit_SetAttackMissile("/", "Abilities\\Weapons\\snapMissile\\snapMissile.mdl", "600.", "0.1")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.3", "0.51")
            //! runtextmacro Unit_AddClass("/", "WARD")
            //! runtextmacro Unit_SetCollisionSize("/", "16.")
            //! runtextmacro Unit_SetCombatFlags("/", "ground", "600.")
            //! runtextmacro Unit_SetDamage("/", "PIERCE", "16", "2", "2", "0.4")
            //! runtextmacro Unit_SetDeathTime("/", "1.07")
            //! runtextmacro Unit_SetElevation("/", "0", "50.", "25.", "25.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNDeathAndDecay.blp")
            //! runtextmacro Unit_SetLife("/", "225.", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "100.", "30.", "30.", "225.")
            //! runtextmacro Unit_SetModel("/", "Units\\CobraLily\\CobraLily.mdx", "", "", "", "")
            //! runtextmacro Unit_SetScale("/", "0.75", "0.75")
            //! runtextmacro Unit_SetShadow("/", "NORMAL", "90.", "90.", "35.", "35.")
            //! runtextmacro Unit_SetSight("/", "800.", "1200.")
            //! runtextmacro Unit_SetSpellPower("/", "15.")
            //! runtextmacro Unit_SetVertexColor("/", "0", "255", "0", "255")

            //! runtextmacro Unit_Finalize("/")

            //Cobra Lily3
            //! runtextmacro Unit_Create("/", "COBRA_LILY3", "CL3", "Cobra Lily (Level 3)", "false", "ATTACKER", "1.")

            //! runtextmacro Unit_SetArmor("/", "LARGE", "1.", "Flesh")
            //! runtextmacro Unit_AddAttachment("/", "Units\\CobraLily\\LightingOrb.mdx", "HEAD", "NORMAL")
            //! runtextmacro Unit_SetAttack("/", "HOMING_MISSILE", "1.25", "500.", "250.", "ground,structure,debris,air,item,ward", "0.", "")
            //! runtextmacro Unit_SetAttackMissile("/", "Abilities\\Weapons\\snapMissile\\snapMissile.mdl", "600.", "0.1")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.3", "0.51")
            //! runtextmacro Unit_AddClass("/", "WARD")
            //! runtextmacro Unit_SetCollisionSize("/", "16.")
            //! runtextmacro Unit_SetCombatFlags("/", "ground", "600.")
            //! runtextmacro Unit_SetDamage("/", "PIERCE", "21", "2", "3", "0.4")
            //! runtextmacro Unit_SetDeathTime("/", "1.07")
            //! runtextmacro Unit_SetElevation("/", "0", "50.", "25.", "25.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNDeathAndDecay.blp")
            //! runtextmacro Unit_SetLife("/", "300.", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "100.", "30.", "30.", "225.")
            //! runtextmacro Unit_SetModel("/", "Units\\CobraLily\\CobraLily.mdx", "", "", "", "")
            //! runtextmacro Unit_SetScale("/", "0.8", "0.75")
            //! runtextmacro Unit_SetShadow("/", "NORMAL", "90.", "90.", "35.", "35.")
            //! runtextmacro Unit_SetSight("/", "800.", "1200.")
            //! runtextmacro Unit_SetSpellPower("/", "15.")
            //! runtextmacro Unit_SetVertexColor("/", "0", "255", "0", "255")

            //! runtextmacro Unit_Finalize("/")

            //Cobra Lily4
            //! runtextmacro Unit_Create("/", "COBRA_LILY4", "CL4", "Cobra Lily (Level 4)", "false", "ATTACKER", "1.")

            //! runtextmacro Unit_SetArmor("/", "LARGE", "2.", "Flesh")
            //! runtextmacro Unit_AddAttachment("/", "Units\\CobraLily\\LightingOrb.mdx", "HEAD", "NORMAL")
            //! runtextmacro Unit_SetAttack("/", "HOMING_MISSILE", "1.25", "500.", "250.", "ground,structure,debris,air,item,ward", "0.", "")
            //! runtextmacro Unit_SetAttackMissile("/", "Abilities\\Weapons\\snapMissile\\snapMissile.mdl", "600.", "0.1")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.3", "0.51")
            //! runtextmacro Unit_AddClass("/", "WARD")
            //! runtextmacro Unit_SetCollisionSize("/", "16.")
            //! runtextmacro Unit_SetCombatFlags("/", "ground", "600.")
            //! runtextmacro Unit_SetDamage("/", "PIERCE", "26", "3", "3", "0.4")
            //! runtextmacro Unit_SetDeathTime("/", "1.07")
            //! runtextmacro Unit_SetElevation("/", "0", "50.", "25.", "25.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNDeathAndDecay.blp")
            //! runtextmacro Unit_SetLife("/", "375.", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "100.", "30.", "30.", "225.")
            //! runtextmacro Unit_SetModel("/", "Units\\CobraLily\\CobraLily.mdx", "", "", "", "")
            //! runtextmacro Unit_SetScale("/", "0.85", "0.75")
            //! runtextmacro Unit_SetShadow("/", "NORMAL", "90.", "90.", "35.", "35.")
            //! runtextmacro Unit_SetSight("/", "800.", "1200.")
            //! runtextmacro Unit_SetSpellPower("/", "15.")
            //! runtextmacro Unit_SetVertexColor("/", "0", "255", "0", "255")

            //! runtextmacro Unit_Finalize("/")

            //Cobra Lily5
            //! runtextmacro Unit_Create("/", "COBRA_LILY5", "CL5", "Cobra Lily (Level 5)", "false", "ATTACKER", "1.")

            //! runtextmacro Unit_SetArmor("/", "LARGE", "2.", "Flesh")
            //! runtextmacro Unit_AddAttachment("/", "Units\\CobraLily\\LightingOrb.mdx", "HEAD", "NORMAL")
            //! runtextmacro Unit_SetAttack("/", "HOMING_MISSILE", "1.25", "500.", "250.", "ground,structure,debris,air,item,ward", "0.", "")
            //! runtextmacro Unit_SetAttackMissile("/", "Abilities\\Weapons\\snapMissile\\snapMissile.mdl", "600.", "0.1")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.3", "0.51")
            //! runtextmacro Unit_AddClass("/", "WARD")
            //! runtextmacro Unit_SetCollisionSize("/", "16.")
            //! runtextmacro Unit_SetCombatFlags("/", "ground", "600.")
            //! runtextmacro Unit_SetDamage("/", "PIERCE", "32", "3", "4", "0.4")
            //! runtextmacro Unit_SetDeathTime("/", "1.07")
            //! runtextmacro Unit_SetElevation("/", "0", "50.", "25.", "25.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNDeathAndDecay.blp")
            //! runtextmacro Unit_SetLife("/", "450.", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "100.", "30.", "30.", "225.")
            //! runtextmacro Unit_SetModel("/", "Units\\CobraLily\\CobraLily.mdx", "", "", "", "")
            //! runtextmacro Unit_SetScale("/", "0.9", "0.75")
            //! runtextmacro Unit_SetShadow("/", "NORMAL", "90.", "90.", "35.", "35.")
            //! runtextmacro Unit_SetSight("/", "800.", "1200.")
            //! runtextmacro Unit_SetSpellPower("/", "15.")
            //! runtextmacro Unit_SetVertexColor("/", "0", "255", "0", "255")

            //! runtextmacro Unit_Finalize("/")

            //Descendant
            //! runtextmacro Unit_Create("/", "DESCENDANT", "Des", "Descendant (Level 1)", "false", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "HERO", "0.", "Flesh")
            //! runtextmacro Unit_SetAttack("/", "HOMING_MISSILE", "1.8", "500.", "250.", "ground,structure,debris,air,item,ward", "0.", "")
            //! runtextmacro Unit_SetAttackMissile("/", "Abilities\\Weapons\\SkeletalMageMissile\\SkeletalMageMissile.mdl", "600.", "0.1")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.3", "1.53")
            //! runtextmacro Unit_SetCollisionSize("/", "16.")
            //! runtextmacro Unit_SetCombatFlags("/", "ground", "500.")
            //! runtextmacro Unit_SetDamage("/", "CHAOS", "10", "2", "7", "0.55")
            //! runtextmacro Unit_SetDeathTime("/", "3.")
            //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "10.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNHeroDreadLord.blp")
            //! runtextmacro Unit_SetLife("/", "75.", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "100.", "0.", "0.", "60.")
            //! runtextmacro Unit_SetModel("/", "units\\undead\\Tichondrius\\Tichondrius.mdx", "", "", "medium", "")
            //! runtextmacro Unit_SetMovement("/", "FOOT", "270.", "0.5", "4", "240.", "240.")
            //! runtextmacro Unit_SetScale("/", "0.6", "2.33")
            //! runtextmacro Unit_SetShadow("/", "NORMAL", "160.", "160.", "60.", "60.")
            //! runtextmacro Unit_SetSight("/", "800.", "1800.")
            //! runtextmacro Unit_SetSoundset("/", "HeroDreadLord")
            //! runtextmacro Unit_SetSpellPower("/", "15.")

            //! runtextmacro Unit_Finalize("/")

            //Descendant2
            //! runtextmacro Unit_Create("/", "DESCENDANT2", "De2", "Descendant (Level 2)", "false", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "HERO", "0.", "Flesh")
            //! runtextmacro Unit_SetAttack("/", "HOMING_MISSILE", "1.8", "500.", "250.", "ground,structure,debris,air,item,ward", "0.", "")
            //! runtextmacro Unit_SetAttackMissile("/", "Abilities\\Weapons\\SkeletalMageMissile\\SkeletalMageMissile.mdl", "600.", "0.1")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.3", "1.53")
            //! runtextmacro Unit_SetCollisionSize("/", "16.")
            //! runtextmacro Unit_SetCombatFlags("/", "ground", "500.")
            //! runtextmacro Unit_SetDamage("/", "CHAOS", "14", "2", "7", "0.55")
            //! runtextmacro Unit_SetDeathTime("/", "3.")
            //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "10.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNHeroDreadLord.blp")
            //! runtextmacro Unit_SetLife("/", "125.", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "100.", "0.", "0.", "60.")
            //! runtextmacro Unit_SetModel("/", "units\\undead\\Tichondrius\\Tichondrius.mdx", "", "", "medium", "")
            //! runtextmacro Unit_SetMovement("/", "FOOT", "270.", "0.5", "4", "240.", "240.")
            //! runtextmacro Unit_SetScale("/", "0.7", "2.33")
            //! runtextmacro Unit_SetShadow("/", "NORMAL", "160.", "160.", "60.", "60.")
            //! runtextmacro Unit_SetSight("/", "800.", "1800.")
            //! runtextmacro Unit_SetSoundset("/", "HeroDreadLord")
            //! runtextmacro Unit_SetSpellPower("/", "25.")

            //! runtextmacro Unit_Finalize("/")

            //Descendant3
            //! runtextmacro Unit_Create("/", "DESCENDANT3", "De3", "Descendant (Level 3)", "false", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "HERO", "0.", "Flesh")
            //! runtextmacro Unit_SetAttack("/", "HOMING_MISSILE", "1.8", "500.", "250.", "ground,structure,debris,air,item,ward", "0.", "")
            //! runtextmacro Unit_SetAttackMissile("/", "Abilities\\Weapons\\SkeletalMageMissile\\SkeletalMageMissile.mdl", "600.", "0.1")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.3", "1.53")
            //! runtextmacro Unit_SetCollisionSize("/", "16.")
            //! runtextmacro Unit_SetCombatFlags("/", "ground", "500.")
            //! runtextmacro Unit_SetDamage("/", "CHAOS", "20", "2", "7", "0.55")
            //! runtextmacro Unit_SetDeathTime("/", "3.")
            //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "10.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNHeroDreadLord.blp")
            //! runtextmacro Unit_SetLife("/", "185.", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "100.", "0.", "0.", "60.")
            //! runtextmacro Unit_SetModel("/", "units\\undead\\Tichondrius\\Tichondrius.mdx", "", "", "medium", "")
            //! runtextmacro Unit_SetMovement("/", "FOOT", "270.", "0.5", "4", "240.", "240.")
            //! runtextmacro Unit_SetScale("/", "0.7", "2.33")
            //! runtextmacro Unit_SetShadow("/", "NORMAL", "160.", "160.", "60.", "60.")
            //! runtextmacro Unit_SetSight("/", "800.", "1800.")
            //! runtextmacro Unit_SetSoundset("/", "HeroDreadLord")
            //! runtextmacro Unit_SetSpellPower("/", "35.")

            //! runtextmacro Unit_Finalize("/")

            //Descendant4
            //! runtextmacro Unit_Create("/", "DESCENDANT4", "De4", "Descendant (Level 4)", "false", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "HERO", "0.", "Flesh")
            //! runtextmacro Unit_SetAttack("/", "HOMING_MISSILE", "1.8", "500.", "250.", "ground,structure,debris,air,item,ward", "0.", "")
            //! runtextmacro Unit_SetAttackMissile("/", "Abilities\\Weapons\\SkeletalMageMissile\\SkeletalMageMissile.mdl", "600.", "0.1")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.3", "1.53")
            //! runtextmacro Unit_SetCollisionSize("/", "16.")
            //! runtextmacro Unit_SetCombatFlags("/", "ground", "500.")
            //! runtextmacro Unit_SetDamage("/", "CHAOS", "28", "2", "7", "0.55")
            //! runtextmacro Unit_SetDeathTime("/", "3.")
            //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "10.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNHeroDreadLord.blp")
            //! runtextmacro Unit_SetLife("/", "255.", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "100.", "0.", "0.", "60.")
            //! runtextmacro Unit_SetModel("/", "units\\undead\\Tichondrius\\Tichondrius.mdx", "", "", "medium", "")
            //! runtextmacro Unit_SetMovement("/", "FOOT", "270.", "0.5", "4", "240.", "240.")
            //! runtextmacro Unit_SetScale("/", "0.7", "2.33")
            //! runtextmacro Unit_SetShadow("/", "NORMAL", "160.", "160.", "60.", "60.")
            //! runtextmacro Unit_SetSight("/", "800.", "1800.")
            //! runtextmacro Unit_SetSoundset("/", "HeroDreadLord")
            //! runtextmacro Unit_SetSpellPower("/", "45.")

            //! runtextmacro Unit_Finalize("/")

            //Descendant5
            //! runtextmacro Unit_Create("/", "DESCENDANT5", "De5", "Descendant (Level 5)", "false", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "HERO", "0.", "Flesh")
            //! runtextmacro Unit_SetAttack("/", "HOMING_MISSILE", "1.8", "500.", "250.", "ground,structure,debris,air,item,ward", "0.", "")
            //! runtextmacro Unit_SetAttackMissile("/", "Abilities\\Weapons\\SkeletalMageMissile\\SkeletalMageMissile.mdl", "600.", "0.1")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.3", "1.53")
            //! runtextmacro Unit_SetCollisionSize("/", "16.")
            //! runtextmacro Unit_SetCombatFlags("/", "ground", "500.")
            //! runtextmacro Unit_SetDamage("/", "CHAOS", "38", "2", "7", "0.55")
            //! runtextmacro Unit_SetDeathTime("/", "3.")
            //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "10.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNHeroDreadLord.blp")
            //! runtextmacro Unit_SetLife("/", "335.", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "100.", "0.", "0.", "60.")
            //! runtextmacro Unit_SetModel("/", "units\\undead\\Tichondrius\\Tichondrius.mdx", "", "", "medium", "")
            //! runtextmacro Unit_SetMovement("/", "FOOT", "270.", "0.5", "4", "240.", "240.")
            //! runtextmacro Unit_SetScale("/", "0.7", "2.33")
            //! runtextmacro Unit_SetShadow("/", "NORMAL", "160.", "160.", "60.", "60.")
            //! runtextmacro Unit_SetSight("/", "800.", "1800.")
            //! runtextmacro Unit_SetSoundset("/", "HeroDreadLord")
            //! runtextmacro Unit_SetSpellPower("/", "55.")

            //! runtextmacro Unit_Finalize("/")

            //Eye of the Flame
            //! runtextmacro Unit_Create("/", "EYE_OF_THE_FLAME", "EoF", "Eye of the Flame", "false", "ATTACKER", "1.")

            //! runtextmacro Unit_SetArmor("/", "LARGE", "0.", "Ethereal")
            //! runtextmacro Unit_SetAttack("/", "HOMING_MISSILE", "0.5", "300.", "250.", "ground,structure,debris,air,item,ward", "0.", "")
            //! runtextmacro Unit_SetAttackMissile("/", "Abilities\\Weapons\\RedDragonBreath\\RedDragonMissile.mdx", "600.", "0.05")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.", "0.51")
            //! runtextmacro Unit_AddClass("/", "WARD")
            //! runtextmacro Unit_SetCollisionSize("/", "16.")
            //! runtextmacro Unit_SetCombatFlags("/", "ground", "300.")
            //! runtextmacro Unit_SetDamage("/", "MAGIC", "2", "1", "3", "0.1")
            //! runtextmacro Unit_SetDeathTime("/", "0.94")
            //! runtextmacro Unit_SetElevation("/", "0", "50.", "25.", "25.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNSentryWard.blp")
            //! runtextmacro Unit_SetLife("/", "65.", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "225.")
            //! runtextmacro Unit_SetModel("/", "units\\orc\\SentryWard\\SentryWard.mdx", "", "", "", "")
            //! runtextmacro Unit_SetScale("/", "1.25", "0.85")
            //! runtextmacro Unit_SetShadow("/", "NORMAL", "70.", "70.", "25.", "25.")
            //! runtextmacro Unit_SetSight("/", "800.", "1200.")
            //! runtextmacro Unit_SetSpellPower("/", "60.")

            //! runtextmacro Unit_Finalize("/")

            //Ghost Sword
            //! runtextmacro Unit_Create("/", "GHOST_SWORD", "Gho", "Ghost Sword (Level 1)", "false", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "MEDIUM", "1.", "Ethereal")
            //! runtextmacro Unit_SetAttack("/", "NORMAL", "1.7", "128.", "250.", "ground,structure,debris,item,ward", "0.", "MetalLightChop")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.", "0.51")
            //! runtextmacro Unit_SetCollisionSize("/", "20.")
            //! runtextmacro Unit_SetCombatFlags("/", "ground", "300.")
            //! runtextmacro Unit_SetDamage("/", "NORMAL", "2", "2", "2", "0.3")
            //! runtextmacro Unit_SetDeathTime("/", "3.")
            //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "10.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNThoriumMelee.blp")
            //! runtextmacro Unit_SetLife("/", "200.", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
            //! runtextmacro Unit_SetModel("/", "Units\\Summons\\GhostSword\\GhostSword.mdx", "", "", "", "")
            //! runtextmacro Unit_SetMovement("/", "FOOT", "220.", "0.5", "1", "200.", "200.")
            //! runtextmacro Unit_SetScale("/", "1.", "1.3")
            //! runtextmacro Unit_SetShadow("/", "FLY", "60.", "60.", "10.", "10.")
            //! runtextmacro Unit_SetSight("/", "800.", "1400.")
            //! runtextmacro Unit_SetSpellPower("/", "40.")

            //! runtextmacro Unit_Finalize("/")

            //Ghost Sword2
            //! runtextmacro Unit_Create("/", "GHOST_SWORD2", "Gh2", "Ghost Sword (Level 2)", "false", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "MEDIUM", "1.", "Ethereal")
            //! runtextmacro Unit_SetAttack("/", "NORMAL", "1.7", "128.", "250.", "ground,structure,debris,item,ward", "0.", "MetalLightChop")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.", "0.51")
            //! runtextmacro Unit_SetCollisionSize("/", "20.")
            //! runtextmacro Unit_SetCombatFlags("/", "ground", "300.")
            //! runtextmacro Unit_SetDamage("/", "NORMAL", "5", "2", "2", "0.3")
            //! runtextmacro Unit_SetDeathTime("/", "3.")
            //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "10.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNThoriumMelee.blp")
            //! runtextmacro Unit_SetLife("/", "275.", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
            //! runtextmacro Unit_SetModel("/", "Units\\Summons\\GhostSword\\GhostSword.mdx", "", "", "", "")
            //! runtextmacro Unit_SetMovement("/", "FOOT", "220.", "0.5", "1", "200.", "200.")
            //! runtextmacro Unit_SetScale("/", "1.", "1.3")
            //! runtextmacro Unit_SetShadow("/", "FLY", "60.", "60.", "10.", "10.")
            //! runtextmacro Unit_SetSight("/", "800.", "1400.")
            //! runtextmacro Unit_SetSpellPower("/", "40.")

            //! runtextmacro Unit_Finalize("/")

            //Ghost Sword3
            //! runtextmacro Unit_Create("/", "GHOST_SWORD3", "Gh3", "Ghost Sword (Level 3)", "false", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "MEDIUM", "1.", "Ethereal")
            //! runtextmacro Unit_SetAttack("/", "NORMAL", "1.7", "128.", "250.", "ground,structure,debris,item,ward", "0.", "MetalLightChop")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.", "0.51")
            //! runtextmacro Unit_SetCollisionSize("/", "20.")
            //! runtextmacro Unit_SetCombatFlags("/", "ground", "300.")
            //! runtextmacro Unit_SetDamage("/", "NORMAL", "5", "2", "2", "0.3")
            //! runtextmacro Unit_SetDeathTime("/", "3.")
            //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "10.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNThoriumMelee.blp")
            //! runtextmacro Unit_SetLife("/", "275.", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
            //! runtextmacro Unit_SetModel("/", "Units\\Summons\\GhostSword\\GhostSword.mdx", "", "", "", "")
            //! runtextmacro Unit_SetMovement("/", "FOOT", "220.", "0.5", "1", "200.", "200.")
            //! runtextmacro Unit_SetScale("/", "1.", "1.3")
            //! runtextmacro Unit_SetShadow("/", "FLY", "60.", "60.", "10.", "10.")
            //! runtextmacro Unit_SetSight("/", "800.", "1400.")
            //! runtextmacro Unit_SetSpellPower("/", "60.")

            //! runtextmacro Unit_Finalize("/")

            //Ghost Sword4
            //! runtextmacro Unit_Create("/", "GHOST_SWORD4", "Gh4", "Ghost Sword (Level 4)", "false", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "MEDIUM", "1.", "Ethereal")
            //! runtextmacro Unit_SetAttack("/", "NORMAL", "1.7", "128.", "250.", "ground,structure,debris,item,ward", "0.", "MetalLightChop")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.", "0.51")
            //! runtextmacro Unit_SetCollisionSize("/", "20.")
            //! runtextmacro Unit_SetCombatFlags("/", "ground", "300.")
            //! runtextmacro Unit_SetDamage("/", "NORMAL", "10", "2", "2", "0.3")
            //! runtextmacro Unit_SetDeathTime("/", "3.")
            //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "10.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNThoriumMelee.blp")
            //! runtextmacro Unit_SetLife("/", "350.", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
            //! runtextmacro Unit_SetModel("/", "Units\\Summons\\GhostSword\\GhostSword.mdx", "", "", "", "")
            //! runtextmacro Unit_SetMovement("/", "FOOT", "220.", "0.5", "1", "200.", "200.")
            //! runtextmacro Unit_SetScale("/", "1.", "1.3")
            //! runtextmacro Unit_SetShadow("/", "FLY", "60.", "60.", "10.", "10.")
            //! runtextmacro Unit_SetSight("/", "800.", "1400.")
            //! runtextmacro Unit_SetSpellPower("/", "60.")

            //! runtextmacro Unit_Finalize("/")

            //Ghost Sword5
            //! runtextmacro Unit_Create("/", "GHOST_SWORD5", "Gh5", "Ghost Sword (Level 5)", "false", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "MEDIUM", "1.", "Ethereal")
            //! runtextmacro Unit_SetAttack("/", "NORMAL", "1.7", "128.", "250.", "ground,structure,debris,item,ward", "0.", "MetalLightChop")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.", "0.51")
            //! runtextmacro Unit_SetCollisionSize("/", "20.")
            //! runtextmacro Unit_SetCombatFlags("/", "ground", "300.")
            //! runtextmacro Unit_SetDamage("/", "NORMAL", "10", "2", "2", "0.3")
            //! runtextmacro Unit_SetDeathTime("/", "3.")
            //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "10.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNThoriumMelee.blp")
            //! runtextmacro Unit_SetLife("/", "350.", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
            //! runtextmacro Unit_SetModel("/", "Units\\Summons\\GhostSword\\GhostSword.mdx", "", "", "", "")
            //! runtextmacro Unit_SetMovement("/", "FOOT", "220.", "0.5", "1", "200.", "200.")
            //! runtextmacro Unit_SetScale("/", "1.", "1.3")
            //! runtextmacro Unit_SetShadow("/", "FLY", "60.", "60.", "10.", "10.")
            //! runtextmacro Unit_SetSight("/", "800.", "1400.")
            //! runtextmacro Unit_SetSpellPower("/", "80.")

            //! runtextmacro Unit_Finalize("/")

            //Serpent Ward
            //! runtextmacro Unit_Create("/", "SERPENT_WARD", "SeW", "Serpent Ward", "false", "ATTACKER", "1.")

            //! runtextmacro Unit_SetArmor("/", "LARGE", "0.", "Ethereal")
            //! runtextmacro Unit_SetAttack("/", "HOMING_MISSILE", "1.5", "600.", "250.", "ground,structure,debris,air,item,ward", "0.", "")
            //! runtextmacro Unit_SetAttackMissile("/", "Abilities\\Weapons\\SerpentWardMissile\\SerpentWardMissile.mdx", "900.", "0.15")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.", "0.51")
            //! runtextmacro Unit_AddClass("/", "WARD")
            //! runtextmacro Unit_SetCollisionSize("/", "16.")
            //! runtextmacro Unit_SetCombatFlags("/", "ground", "600.")
            //! runtextmacro Unit_SetDamage("/", "PIERCE", "12", "1", "3", "0.3")
            //! runtextmacro Unit_SetDeathTime("/", "0.94")
            //! runtextmacro Unit_SetElevation("/", "0", "50.", "25.", "25.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNSerpentWard.blp")
            //! runtextmacro Unit_SetLife("/", "100.", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "225.")
            //! runtextmacro Unit_SetModel("/", "units\\orc\\SerpentWard\\SerpentWard.mdx", "", "", "", "")
            //! runtextmacro Unit_SetScale("/", "1.", "0.75")
            //! runtextmacro Unit_SetShadow("/", "NORMAL", "70.", "70.", "25.", "25.")
            //! runtextmacro Unit_SetSight("/", "800.", "1200.")
            //! runtextmacro Unit_SetSpellPower("/", "35.")

            //! runtextmacro Unit_Finalize("/")

            //Spirit Wolf
            //! runtextmacro Unit_Create("/", "SPIRIT_WOLF", "SpW", "Spirit Wolf", "false", "ATTACKER", "1.1")

            //! runtextmacro Unit_SetArmor("/", "LARGE", "0.", "Ethereal")
            //! runtextmacro Unit_SetAttack("/", "NORMAL", "1.", "90.", "250.", "ground,structure,debris,item,ward", "0.", "WoodMediumBash")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.3", "0.51")
            //! runtextmacro Unit_SetCollisionSize("/", "32.")
            //! runtextmacro Unit_SetCombatFlags("/", "ground", "500.")
            //! runtextmacro Unit_SetDamage("/", "NORMAL", "15", "1", "2", "0.33")
            //! runtextmacro Unit_SetDeathTime("/", "1.75")
            //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "45.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNSpiritWolf.blp")
            //! runtextmacro Unit_SetLife("/", "300.", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
            //! runtextmacro Unit_SetModel("/", "units\\orc\\Spiritwolf\\Spiritwolf.mdx", "", "", "medium", "")
            //! runtextmacro Unit_SetScale("/", "1.25", "1.5")
            //! runtextmacro Unit_SetShadow("/", "NORMAL", "140.", "140.", "60.", "60.")
            //! runtextmacro Unit_SetSight("/", "800.", "1200.")
            //! runtextmacro Unit_SetSpellPower("/", "45.")

            //! runtextmacro Unit_Finalize("/")

            //Trap Mine
            //! runtextmacro Unit_Create("/", "TRAP_MINE", "TrM", "Trap Mine", "false", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "MEDIUM", "1.", "Metal")
            //! runtextmacro Unit_AddAttachment("/", "Units\\Trap\\PointingArrow.mdx", "OVERHEAD", "LOW")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.", "0.51")
            //! runtextmacro Unit_AddClass("/", "WARD")
            //! runtextmacro Unit_SetCollisionSize("/", "16.")
            //! runtextmacro Unit_SetCombatFlags("/", "ground,mechanical", "0.")
            //! runtextmacro Unit_SetDeathTime("/", "0.94")
            //! runtextmacro Unit_SetElevation("/", "0", "50.", "25.", "25.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNGoblinLandMine.blp")
            //! runtextmacro Unit_SetLife("/", "5.", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
            //! runtextmacro Unit_SetModel("/", "Spells\\HopNDrop\\Trap.mdx", "", "", "", "")
            //! runtextmacro Unit_SetScale("/", "1.35", "0.75")
            //! runtextmacro Unit_SetShadow("/", "NORMAL", "70.", "70.", "25.", "25.")

            //! runtextmacro Unit_Finalize("/")

            //Polar Bear
            //! runtextmacro Unit_Create("/", "POLAR_BEAR", "PoB", "Knut (Level 1)", "false", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "LARGE", "2.", "Flesh")
            //! runtextmacro Unit_SetAttack("/", "NORMAL", "1.35", "128.", "250.", "ground,structure,debris,item,ward", "0.", "WoodHeavyBash")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.", "0.51")
            //! runtextmacro Unit_SetCollisionSize("/", "48.")
            //! runtextmacro Unit_SetCombatFlags("/", "ground", "500.")
            //! runtextmacro Unit_SetDamage("/", "NORMAL", "14", "1", "5", "0.63")
            //! runtextmacro Unit_SetDeathTime("/", "1.97")
            //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "45.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNFrostBear.blp")
            //! runtextmacro Unit_SetLife("/", "400.", "1.5")
            //! runtextmacro Unit_SetMana("/", "80.", "0.5")
            //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
            //! runtextmacro Unit_SetModel("/", "units\\creeps\\PolarBear\\PolarBear.mdx", "", "", "medium", "")
            //! runtextmacro Unit_SetMovement("/", "FOOT", "270.", "0.5", "1", "200.", "200.")
            //! runtextmacro Unit_SetScale("/", "0.95", "1.8")
            //! runtextmacro Unit_SetShadow("/", "NORMAL", "140.", "140.", "50.", "50.")
            //! runtextmacro Unit_SetSight("/", "800.", "1400.")
            //! runtextmacro Unit_SetSoundset("/", "GrizzlyBear")
            //! runtextmacro Unit_SetSpellPower("/", "45.")

            //! runtextmacro Unit_Finalize("/")

            //Polar Bear2
            //! runtextmacro Unit_Create("/", "POLAR_BEAR2", "PB2", "Knut (Level 2)", "false", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "LARGE", "3.", "Flesh")
            //! runtextmacro Unit_SetAttack("/", "NORMAL", "1.35", "128.", "250.", "ground,structure,debris,item,ward", "0.", "WoodHeavyBash")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.", "0.51")
            //! runtextmacro Unit_SetCollisionSize("/", "48.")
            //! runtextmacro Unit_SetCombatFlags("/", "ground", "500.")
            //! runtextmacro Unit_SetDamage("/", "NORMAL", "18", "1", "6", "0.63")
            //! runtextmacro Unit_SetDeathTime("/", "1.97")
            //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "45.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNFrostBear.blp")
            //! runtextmacro Unit_SetLife("/", "500.", "2.")
            //! runtextmacro Unit_SetMana("/", "100.", "0.75")
            //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
            //! runtextmacro Unit_SetModel("/", "units\\creeps\\PolarBear\\PolarBear.mdx", "", "", "medium", "")
            //! runtextmacro Unit_SetMovement("/", "FOOT", "270.", "0.5", "1", "200.", "200.")
            //! runtextmacro Unit_SetScale("/", "1.15", "1.8")
            //! runtextmacro Unit_SetShadow("/", "NORMAL", "140.", "140.", "50.", "50.")
            //! runtextmacro Unit_SetSight("/", "800.", "1400.")
            //! runtextmacro Unit_SetSoundset("/", "GrizzlyBear")
            //! runtextmacro Unit_SetSpellPower("/", "55.")

            //! runtextmacro Unit_Finalize("/")

            //Polar Bear3
            //! runtextmacro Unit_Create("/", "POLAR_BEAR3", "PB3", "Knut (Level 3)", "false", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "LARGE", "4.", "Flesh")
            //! runtextmacro Unit_SetAttack("/", "NORMAL", "1.35", "128.", "250.", "ground,structure,debris,item,ward", "0.", "WoodHeavyBash")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.", "0.51")
            //! runtextmacro Unit_SetCollisionSize("/", "48.")
            //! runtextmacro Unit_SetCombatFlags("/", "ground", "500.")
            //! runtextmacro Unit_SetDamage("/", "NORMAL", "24", "2", "4", "0.63")
            //! runtextmacro Unit_SetDeathTime("/", "1.97")
            //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "45.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNFrostBear.blp")
            //! runtextmacro Unit_SetLife("/", "620.", "2.5")
            //! runtextmacro Unit_SetMana("/", "120.", "1.")
            //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
            //! runtextmacro Unit_SetModel("/", "units\\creeps\\PolarBear\\PolarBear.mdx", "", "", "medium", "")
            //! runtextmacro Unit_SetMovement("/", "FOOT", "270.", "0.5", "1", "200.", "200.")
            //! runtextmacro Unit_SetScale("/", "1.25", "1.8")
            //! runtextmacro Unit_SetShadow("/", "NORMAL", "140.", "140.", "50.", "50.")
            //! runtextmacro Unit_SetSight("/", "800.", "1400.")
            //! runtextmacro Unit_SetSoundset("/", "GrizzlyBear")
            //! runtextmacro Unit_SetSpellPower("/", "65.")

            //! runtextmacro Unit_Finalize("/")

            //Polar Bear4
            //! runtextmacro Unit_Create("/", "POLAR_BEAR4", "PB4", "Knut (Level 4)", "false", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "LARGE", "5.", "Flesh")
            //! runtextmacro Unit_SetAttack("/", "NORMAL", "1.35", "128.", "250.", "ground,structure,debris,item,ward", "0.", "WoodHeavyBash")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.", "0.51")
            //! runtextmacro Unit_SetCollisionSize("/", "48.")
            //! runtextmacro Unit_SetCombatFlags("/", "ground", "500.")
            //! runtextmacro Unit_SetDamage("/", "NORMAL", "26", "3", "4", "0.63")
            //! runtextmacro Unit_SetDeathTime("/", "1.97")
            //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "45.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNFrostBear.blp")
            //! runtextmacro Unit_SetLife("/", "750.", "2.5")
            //! runtextmacro Unit_SetMana("/", "140.", "1.25")
            //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
            //! runtextmacro Unit_SetModel("/", "units\\creeps\\PolarBear\\PolarBear.mdx", "", "", "medium", "")
            //! runtextmacro Unit_SetMovement("/", "FOOT", "270.", "0.5", "1", "200.", "200.")
            //! runtextmacro Unit_SetScale("/", "1.35", "1.8")
            //! runtextmacro Unit_SetShadow("/", "NORMAL", "140.", "140.", "50.", "50.")
            //! runtextmacro Unit_SetSight("/", "800.", "1400.")
            //! runtextmacro Unit_SetSoundset("/", "GrizzlyBear")
            //! runtextmacro Unit_SetSpellPower("/", "75.")

            //! runtextmacro Unit_Finalize("/")

            //Polar Bear5
            //! runtextmacro Unit_Create("/", "POLAR_BEAR5", "PB5", "Knut (Level 5)", "false", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "LARGE", "6.", "Flesh")
            //! runtextmacro Unit_SetAttack("/", "NORMAL", "1.35", "128.", "250.", "ground,structure,debris,item,ward", "0.", "WoodHeavyBash")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.", "0.51")
            //! runtextmacro Unit_SetCollisionSize("/", "48.")
            //! runtextmacro Unit_SetCombatFlags("/", "ground", "500.")
            //! runtextmacro Unit_SetDamage("/", "NORMAL", "27", "4", "4", "0.63")
            //! runtextmacro Unit_SetDeathTime("/", "1.97")
            //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "45.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNFrostBear.blp")
            //! runtextmacro Unit_SetLife("/", "900.", "2.5")
            //! runtextmacro Unit_SetMana("/", "160.", "1.5")
            //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
            //! runtextmacro Unit_SetModel("/", "units\\creeps\\PolarBear\\PolarBear.mdx", "", "", "medium", "")
            //! runtextmacro Unit_SetMovement("/", "FOOT", "270.", "0.5", "1", "200.", "200.")
            //! runtextmacro Unit_SetScale("/", "1.45", "1.8")
            //! runtextmacro Unit_SetShadow("/", "NORMAL", "140.", "140.", "50.", "50.")
            //! runtextmacro Unit_SetSight("/", "800.", "1400.")
            //! runtextmacro Unit_SetSoundset("/", "GrizzlyBear")
            //! runtextmacro Unit_SetSpellPower("/", "85.")

            //! runtextmacro Unit_Finalize("/")

        // Other
            //Base Tower
            //! runtextmacro Unit_Create("/", "BASE_TOWER", "BTw", "Base Tower", "false", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "FORT", "0.", "Stone")
            //! runtextmacro Unit_AddAttachment("/", "buildings\\other\\CircleOfPower\\CircleOfPower.mdl", "ORIGIN", "NORMAL")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_AddClass("/", "STRUCTURE")
            //! runtextmacro Unit_SetCombatFlags("/", "structure", "0.")
            //! runtextmacro Unit_SetDeathTime("/", "2.34")
            //! runtextmacro Unit_SetElevation("/", "4", "50.", "0.", "0.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNHumanWatchTower.blp")
            //! runtextmacro Unit_SetLife("/", "UNIT_TYPE.Life.BLACK_DISPLAY", "0.")
            //! runtextmacro Unit_SetModel("/", "buildings\\human\\HumanTower\\HumanTower.mdx", "", "", "", "")
            //! runtextmacro Unit_SetPathingTexture("/", "PathTextures\\4x4Default.tga")
            //! runtextmacro Unit_SetScale("/", "1.", "2.5")
            //! runtextmacro Unit_SetShadow("/", "BuildingShadowSmall", "0.", "0.", "0.", "0.")
            //! runtextmacro Unit_SetSight("/", "800.", "1400.")
            //! runtextmacro Unit_SetSoundset("/", "ScoutTower")
            //! runtextmacro Unit_SetVertexColor("/", "200", "200", "200", "255")

            //! runtextmacro Unit_Finalize("/")

            //Fountain
            //! runtextmacro Unit_Create("/", "FOUNTAIN", "Fou", "Fountain", "false", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "FORT", "0.", "Stone")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.", "0.51")
            //! runtextmacro Unit_AddClass("/", "NEUTRAL")
            //! runtextmacro Unit_AddClass("/", "STRUCTURE")
            //! runtextmacro Unit_SetCombatFlags("/", "structure", "0.")
            //! runtextmacro Unit_SetDeathTime("/", "3.")
            //! runtextmacro Unit_SetElevation("/", "4", "50.", "0.", "0.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNFountainOfLifeBlood.blp")
            //! runtextmacro Unit_SetLife("/", "UNIT_TYPE.Life.BLACK_DISPLAY", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "120.", "0.", "0.", "60.")
            //! runtextmacro Unit_SetModel("/", "buildings\\other\\FountainOfLifeBlood\\FountainOfLifeBlood.mdx", "", "", "", "")
            //! runtextmacro Unit_SetPathingTexture("/", "PathTextures\\12x12Default.tga")
            //! runtextmacro Unit_SetScale("/", "1.5", "4.66")
            //! runtextmacro Unit_SetShadow("/", "BuildingShadowLarge", "0.", "0.", "0.", "0.")
            //! runtextmacro Unit_SetSight("/", "800.", "900.")
            //! runtextmacro Unit_SetSoundset("/", "FountainOfLifeBlood")

            //! runtextmacro Unit_Finalize("/")

            //Frost Tower
            //! runtextmacro Unit_Create("/", "FROST_TOWER", "FTw", "Frost Tower (Level 1)", "false", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "FORT", "0.", "Stone")
            //! runtextmacro Unit_AddAttachment("/", "buildings\\other\\CircleOfPower\\CircleOfPower.mdl", "ORIGIN", "NORMAL")
            //! runtextmacro Unit_SetAttack("/", "ARTILLERY", "2.5", "1000.", "0.", "ground,structure,debris,item,ward", "0.", "")
            //! runtextmacro Unit_SetAttackMissile("/", "Abilities\\Weapons\\FrostWyrmMissile\\FrostWyrmMissile.mdx", "700.", "0.1")
            //! runtextmacro Unit_AddAttackSplash("/", "80.", "1.")
            //! runtextmacro Unit_AddAttackSplash("/", "150.", "0.4")
            //! runtextmacro Unit_AddAttackSplash("/", "220.", "0.2")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_AddClass("/", "STRUCTURE")
            //! runtextmacro Unit_AddClass("/", "UPGRADED")
            //! runtextmacro Unit_SetCombatFlags("/", "structure", "1000.")
            //! runtextmacro Unit_SetDamage("/", "MAGIC", "19", "2", "3", "0.5")
            //! runtextmacro Unit_SetDeathTime("/", "3.")
            //! runtextmacro Unit_SetElevation("/", "4", "50.", "0.", "0.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNFrostTower.blp")
            //! runtextmacro Unit_SetLife("/", "UNIT_TYPE.Life.BLACK_DISPLAY", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "120.", "0.", "0.", "145.")
            //! runtextmacro Unit_SetModel("/", "buildings\\undead\\Ziggurat\\Ziggurat.mdx", "", "upgrade,second", "medium", "")
            //! runtextmacro Unit_SetPathingTexture("/", "PathTextures\\4x4Default.tga")
            //! runtextmacro Unit_SetScale("/", "1.", "4.25")
            //! runtextmacro Unit_SetShadow("/", "ShadowZiggurat", "0.", "0.", "0.", "0.")
            //! runtextmacro Unit_SetSight("/", "800.", "1400.")
            //! runtextmacro Unit_SetSoundset("/", "FrostTower")
            //! runtextmacro Unit_SetUberTooltip("/", "Has <minDmg>-<maxDmg> Damage|nApplies the Cold buff to targets|nSplash")

            //! runtextmacro Unit_Finalize("/")

            //Frost Tower2
            //! runtextmacro Unit_Create("/", "FROST_TOWER2", "FT2", "Frost Tower (Level 2)", "false", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "FORT", "0.", "Stone")
            //! runtextmacro Unit_AddAttachment("/", "buildings\\other\\CircleOfPower\\CircleOfPower.mdl", "ORIGIN", "NORMAL")
            //! runtextmacro Unit_SetAttack("/", "ARTILLERY", "2.5", "1000.", "0.", "ground,structure,debris,item,ward", "0.", "")
            //! runtextmacro Unit_SetAttackMissile("/", "Abilities\\Weapons\\FrostWyrmMissile\\FrostWyrmMissile.mdx", "700.", "0.1")
            //! runtextmacro Unit_AddAttackSplash("/", "80.", "1.")
            //! runtextmacro Unit_AddAttackSplash("/", "150.", "0.4")
            //! runtextmacro Unit_AddAttackSplash("/", "220.", "0.2")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_AddClass("/", "STRUCTURE")
            //! runtextmacro Unit_AddClass("/", "UPGRADED")
            //! runtextmacro Unit_SetCombatFlags("/", "structure", "1000.")
            //! runtextmacro Unit_SetDamage("/", "MAGIC", "27", "4", "3", "0.5")
            //! runtextmacro Unit_SetDeathTime("/", "3.")
            //! runtextmacro Unit_SetElevation("/", "4", "50.", "0.", "0.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNFrostTower.blp")
            //! runtextmacro Unit_SetLife("/", "UNIT_TYPE.Life.BLACK_DISPLAY", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "120.", "0.", "0.", "145.")
            //! runtextmacro Unit_SetModel("/", "buildings\\undead\\Ziggurat\\Ziggurat.mdx", "", "upgrade,second", "medium", "")
            //! runtextmacro Unit_SetPathingTexture("/", "PathTextures\\4x4Default.tga")
            //! runtextmacro Unit_SetScale("/", "1.25", "4.25")
            //! runtextmacro Unit_SetShadow("/", "ShadowZiggurat", "0.", "0.", "0.", "0.")
            //! runtextmacro Unit_SetSight("/", "800.", "1400.")
            //! runtextmacro Unit_SetSoundset("/", "FrostTower")
            //! runtextmacro Unit_SetUberTooltip("/", "Has <minDmg>-<maxDmg> Damage|nApplies the Cold buff to targets|nSplash")

            //! runtextmacro Unit_Finalize("/")

            //Lightning Tower
            //! runtextmacro Unit_Create("/", "LIGHTNING_TOWER", "LTw", "Lightning Tower (Level 1)", "false", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "FORT", "0.", "Stone")
            //! runtextmacro Unit_AddAttachment("/", "buildings\\other\\CircleOfPower\\CircleOfPower.mdl", "ORIGIN", "NORMAL")
            //! runtextmacro Unit_SetAttack("/", "HOMING_MISSILE", "6.", "1000.", "0.", "air,ground,structure,debris,item,ward", "0.", "")
            //! runtextmacro Unit_SetAttackMissile("/", "", "1500.", "0.")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_AddClass("/", "STRUCTURE")
            //! runtextmacro Unit_AddClass("/", "UPGRADED")
            //! runtextmacro Unit_SetCombatFlags("/", "structure", "1000.")
            //! runtextmacro Unit_SetDamage("/", "MAGIC", "1", "1", "1", "0.5")
            //! runtextmacro Unit_SetDeathTime("/", "2.34")
            //! runtextmacro Unit_SetElevation("/", "4", "50.", "0.", "0.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNAdvancedEnergyTower.blp")
            //! runtextmacro Unit_SetLife("/", "UNIT_TYPE.Life.BLACK_DISPLAY", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "120.", "0.", "0.", "255.")
            //! runtextmacro Unit_SetModel("/", "buildings\\other\\TowerDefenseTower\\TowerDefenseTower.mdx", "", "upgrade,first", "", "")
            //! runtextmacro Unit_SetPathingTexture("/", "PathTextures\\4x4Default.tga")
            //! runtextmacro Unit_SetScale("/", "1.", "2.5")
            //! runtextmacro Unit_SetShadow("/", "ShadowCannonTower", "0.", "0.", "0.", "0.")
            //! runtextmacro Unit_SetSight("/", "800.", "1400.")
            //! runtextmacro Unit_SetSoundset("/", "ElvenGuardTower")
            //! runtextmacro Unit_SetUberTooltip("/", "Has <minDmg>-<maxDmg> Damage|nFires a stunning chain lightning bouncing between multiple targets")

            //! runtextmacro Unit_Finalize("/")

            //Lightning Tower2
            //! runtextmacro Unit_Create("/", "LIGHTNING_TOWER2", "LT2", "Lightning Tower (Level 2)", "false", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "FORT", "0.", "Stone")
            //! runtextmacro Unit_AddAttachment("/", "buildings\\other\\CircleOfPower\\CircleOfPower.mdl", "ORIGIN", "NORMAL")
            //! runtextmacro Unit_SetAttack("/", "HOMING_MISSILE", "5.", "1000.", "0.", "air,ground,structure,debris,item,ward", "0.", "")
            //! runtextmacro Unit_SetAttackMissile("/", "", "1500.", "0.")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_AddClass("/", "STRUCTURE")
            //! runtextmacro Unit_AddClass("/", "UPGRADED")
            //! runtextmacro Unit_SetCombatFlags("/", "structure", "1000.")
            //! runtextmacro Unit_SetDamage("/", "MAGIC", "1", "1", "1", "0.5")
            //! runtextmacro Unit_SetDeathTime("/", "2.34")
            //! runtextmacro Unit_SetElevation("/", "4", "50.", "0.", "0.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNAdvancedEnergyTower.blp")
            //! runtextmacro Unit_SetLife("/", "UNIT_TYPE.Life.BLACK_DISPLAY", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "120.", "0.", "0.", "255.")
            //! runtextmacro Unit_SetModel("/", "buildings\\other\\TowerDefenseTower\\TowerDefenseTower.mdx", "", "upgrade,first", "", "")
            //! runtextmacro Unit_SetPathingTexture("/", "PathTextures\\4x4Default.tga")
            //! runtextmacro Unit_SetScale("/", "1.25", "2.5")
            //! runtextmacro Unit_SetShadow("/", "ShadowCannonTower", "0.", "0.", "0.", "0.")
            //! runtextmacro Unit_SetSight("/", "800.", "1400.")
            //! runtextmacro Unit_SetSoundset("/", "ElvenGuardTower")
            //! runtextmacro Unit_SetUberTooltip("/", "Has <minDmg>-<maxDmg> Damage|nFires a stunning chain lightning bouncing between multiple targets")

            //! runtextmacro Unit_Finalize("/")

            //Dark Tower
            //! runtextmacro Unit_Create("/", "DARK_TOWER", "DTw", "Dark Tower (Level 1)", "false", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "FORT", "0.", "Stone")
            //! runtextmacro Unit_AddAttachment("/", "buildings\\other\\CircleOfPower\\CircleOfPower.mdl", "ORIGIN", "NORMAL")
            //! runtextmacro Unit_SetAttack("/", "HOMING_MISSILE", "1.75", "1000.", "0.", "air,ground,structure,debris,item,ward", "0.", "")
            //! runtextmacro Unit_SetAttackMissile("/", "Abilities\\Spells\\Undead\\DeathCoil\\DeathCoilMissile.mdx", "1000.", "0.")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_AddClass("/", "STRUCTURE")
            //! runtextmacro Unit_AddClass("/", "UPGRADED")
            //! runtextmacro Unit_SetCombatFlags("/", "structure", "1000.")
            //! runtextmacro Unit_SetDamage("/", "CHAOS", "23", "3", "3", "0.5")
            //! runtextmacro Unit_SetDeathTime("/", "2.34")
            //! runtextmacro Unit_SetElevation("/", "4", "50.", "0.", "0.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNDeathTower.blp")
            //! runtextmacro Unit_SetLife("/", "UNIT_TYPE.Life.BLACK_DISPLAY", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "120.", "0.", "0.", "180.")
            //! runtextmacro Unit_SetModel("/", "buildings\\other\\TowerDefenseTower\\TowerDefenseTower.mdx", "", "fifth", "", "")
            //! runtextmacro Unit_SetPathingTexture("/", "PathTextures\\4x4Default.tga")
            //! runtextmacro Unit_SetScale("/", "1.", "2.5")
            //! runtextmacro Unit_SetShadow("/", "ShadowCannonTower", "0.", "0.", "0.", "0.")
            //! runtextmacro Unit_SetSight("/", "800.", "1400.")
            //! runtextmacro Unit_SetSoundset("/", "ElvenGuardTower")
            //! runtextmacro Unit_SetUberTooltip("/", "Has <minDmg>-<maxDmg> Damage|nApplies the Eclipse buff on attacks.|nSingle targets")

            //! runtextmacro Unit_Finalize("/")

            //Dark Tower2
            //! runtextmacro Unit_Create("/", "DARK_TOWER2", "DT2", "Dark Tower (Level 2)", "false", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "FORT", "0.", "Stone")
            //! runtextmacro Unit_AddAttachment("/", "buildings\\other\\CircleOfPower\\CircleOfPower.mdl", "ORIGIN", "NORMAL")
            //! runtextmacro Unit_SetAttack("/", "HOMING_MISSILE", "1.6", "1000.", "0.", "air,ground,structure,debris,item,ward", "0.", "")
            //! runtextmacro Unit_SetAttackMissile("/", "Abilities\\Spells\\Undead\\DeathCoil\\DeathCoilMissile.mdx", "1000.", "0.")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_AddClass("/", "STRUCTURE")
            //! runtextmacro Unit_AddClass("/", "UPGRADED")
            //! runtextmacro Unit_SetCombatFlags("/", "structure", "1000.")
            //! runtextmacro Unit_SetDamage("/", "CHAOS", "32", "3", "5", "0.5")
            //! runtextmacro Unit_SetDeathTime("/", "2.34")
            //! runtextmacro Unit_SetElevation("/", "4", "50.", "0.", "0.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNDeathTower.blp")
            //! runtextmacro Unit_SetLife("/", "UNIT_TYPE.Life.BLACK_DISPLAY", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "120.", "0.", "0.", "180.")
            //! runtextmacro Unit_SetModel("/", "buildings\\other\\TowerDefenseTower\\TowerDefenseTower.mdx", "", "fifth", "", "")
            //! runtextmacro Unit_SetPathingTexture("/", "PathTextures\\4x4Default.tga")
            //! runtextmacro Unit_SetScale("/", "1.25", "2.5")
            //! runtextmacro Unit_SetShadow("/", "ShadowCannonTower", "0.", "0.", "0.", "0.")
            //! runtextmacro Unit_SetSight("/", "800.", "1400.")
            //! runtextmacro Unit_SetSoundset("/", "ElvenGuardTower")
            //! runtextmacro Unit_SetUberTooltip("/", "Has <minDmg>-<maxDmg> Damage|nApplies the Eclipse buff on attacks.|nSingle targets")

            //! runtextmacro Unit_Finalize("/")

            //Garbage Collector
            //! runtextmacro Unit_Create("/", "GARBAGE_COLLECTOR", "GaC", "Garbage Collector", "false", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "FORT", "0.", "Wood")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.", "0.51")
            //! runtextmacro Unit_AddClass("/", "NEUTRAL")
            //! runtextmacro Unit_AddClass("/", "STRUCTURE")
            //! runtextmacro Unit_SetCombatFlags("/", "structure", "0.")
            //! runtextmacro Unit_SetDeathTime("/", "3.")
            //! runtextmacro Unit_SetElevation("/", "4", "50.", "0.", "0.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNTombOfRelics.blp")
            //! runtextmacro Unit_SetLife("/", "UNIT_TYPE.Life.BLACK_DISPLAY", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "120.", "0.", "0.", "60.")
            //! runtextmacro Unit_SetModel("/", "buildings\\undead\\TombOfRelics\\TombOfRelics.mdx", "", "", "", "")
            //! runtextmacro Unit_SetPathingTexture("/", "PathTextures\\12x12Default.tga")
            //! runtextmacro Unit_SetScale("/", "1.5", "9.")
            //! runtextmacro Unit_SetShadow("/", "ShadowTombOfRelics", "0.", "0.", "0.", "0.")
            //! runtextmacro Unit_SetSight("/", "500.", "500.")
            //! runtextmacro Unit_SetSoldItems("/", "IBoS,IRaS,IPeF,IRaF,IMeS,IMal,IGrA,IRoH")
            //! runtextmacro Unit_SetSoundset("/", "Merchant")
            //! runtextmacro Unit_SetUbersplat("/", "HMED")

            //! runtextmacro Unit_Finalize("/")

            //Library
            //! runtextmacro Unit_Create("/", "LIBRARY", "Lib", "Library", "false", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "FORT", "0.", "Stone")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.", "0.51")
            //! runtextmacro Unit_AddClass("/", "NEUTRAL")
            //! runtextmacro Unit_AddClass("/", "STRUCTURE")
            //! runtextmacro Unit_SetCombatFlags("/", "structure", "0.")
            //! runtextmacro Unit_SetDeathTime("/", "3.")
            //! runtextmacro Unit_SetElevation("/", "4", "50.", "0.", "0.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNBlackMarket.blp")
            //! runtextmacro Unit_SetLife("/", "UNIT_TYPE.Life.BLACK_DISPLAY", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "120.", "0.", "0.", "60.")
            //! runtextmacro Unit_SetModel("/", "buildings\\other\\Marketplace\\Marketplace.mdx", "", "", "", "")
            //! runtextmacro Unit_SetPathingTexture("/", "PathTextures\\12x12Default.tga")
            //! runtextmacro Unit_SetScale("/", "1.25", "5.6")
            //! runtextmacro Unit_SetShadow("/", "BuildingShadowSmall", "0.", "0.", "0.", "0.")
            //! runtextmacro Unit_SetSight("/", "500.", "500.")
            //! runtextmacro Unit_SetSoldItems("/", "IBlz,IChB,IFiB,IViM")
            //! runtextmacro Unit_SetSoundset("/", "Marketplace")
            //! runtextmacro Unit_SetUbersplat("/", "HMED")

            //! runtextmacro Unit_Finalize("/")

            //Meteorite
            //! runtextmacro Unit_Create("/", "METEORITE", "Met", "Meteorite", "false", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "FORT", "0.", "Stone")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.", "0.51")
            //! runtextmacro Unit_AddClass("/", "NEUTRAL")
            //! runtextmacro Unit_AddClass("/", "STRUCTURE")
            //! runtextmacro Unit_SetCombatFlags("/", "structure", "0.")
            //! runtextmacro Unit_SetDeathTime("/", "3.")
            //! runtextmacro Unit_SetElevation("/", "4", "50.", "0.", "0.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNUndeadShrine.blp")
            //! runtextmacro Unit_SetLife("/", "2500.", "0.")
            //! runtextmacro Unit_SetMana("/", "200.", "1.")
            //! runtextmacro Unit_SetMissilePoints("/", "120.", "0.", "0.", "60.")
            //! runtextmacro Unit_SetModel("/", "buildings\\other\\SacrificialAltar\\SacrificialAltar.mdx", "", "", "", "")
            //! runtextmacro Unit_SetPathingTexture("/", "PathTextures\\Meteorite.tga")
            //! runtextmacro Unit_SetScale("/", "3.", "3.5")
            //! runtextmacro Unit_SetShadow("/", "BuildingShadowSmall", "0.", "0.", "0.", "0.")
            //! runtextmacro Unit_SetSight("/", "1000.", "1000.")

            //! runtextmacro Unit_Finalize("/")

            //Penguin
            //! runtextmacro Unit_Create("/", "PENGUIN", "Pen", "Penguin", "false", "OTHER", "1.")

            //! runtextmacro Unit_SetArmor("/", "UNARMORED", "0.", "Flesh")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.4", "0.5")
            //! runtextmacro Unit_SetCollisionSize("/", "8.")
            //! runtextmacro Unit_AddClass("/", "NEUTRAL")
            //! runtextmacro Unit_SetCombatFlags("/", "ground", "0.")
            //! runtextmacro Unit_SetDeathTime("/", "2.33")
            //! runtextmacro Unit_SetElevation("/", "0", "20.", "10.", "10.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNPenguin.blp")
            //! runtextmacro Unit_SetLife("/", "100.", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
            //! runtextmacro Unit_SetModel("/", "units\\critters\\Penguin\\Penguin.mdx", "", "", "", "")
            //! runtextmacro Unit_SetScale("/", "1.5", "0.9")
            //! runtextmacro Unit_SetShadow("/", "NORMAL", "70.", "70.", "35.", "35.")
            //! runtextmacro Unit_SetSight("/", "350.", "350.")

            //! runtextmacro Unit_Finalize("/")

            //Penguin (Lying)
            //! runtextmacro Unit_Create("/", "PENGUIN_LYING", "PeL", "Penguin", "false", "OTHER", "1.")

            //! runtextmacro Unit_SetArmor("/", "UNARMORED", "0.", "Flesh")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.4", "0.5")
            //! runtextmacro Unit_SetCollisionSize("/", "8.")
            //! runtextmacro Unit_AddClass("/", "NEUTRAL")
            //! runtextmacro Unit_SetCombatFlags("/", "ground", "0.")
            //! runtextmacro Unit_SetDeathTime("/", "2.33")
            //! runtextmacro Unit_SetElevation("/", "0", "20.", "10.", "-300.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNPenguin.blp")
            //! runtextmacro Unit_SetLife("/", "100.", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
            //! runtextmacro Unit_SetModel("/", "units\\critters\\Penguin\\Penguin.mdx", "", "", "", "")
            //! runtextmacro Unit_SetScale("/", "1.5", "0.9")
            //! runtextmacro Unit_SetShadow("/", "NORMAL", "70.", "70.", "35.", "35.")
            //! runtextmacro Unit_SetSight("/", "350.", "350.")

            //! runtextmacro Unit_Finalize("/")

            //Pharmacy
            //! runtextmacro Unit_Create("/", "PHARMACY", "Pha", "Pharmacy", "false", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "FORT", "0.", "Stone")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.", "0.51")
            //! runtextmacro Unit_AddClass("/", "NEUTRAL")
            //! runtextmacro Unit_AddClass("/", "STRUCTURE")
            //! runtextmacro Unit_SetCombatFlags("/", "structure", "0.")
            //! runtextmacro Unit_SetDeathTime("/", "3.")
            //! runtextmacro Unit_SetElevation("/", "4", "50.", "0.", "0.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNCorruptedAncientOfWar.blp")
            //! runtextmacro Unit_SetLife("/", "UNIT_TYPE.Life.BLACK_DISPLAY", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "120.", "0.", "0.", "60.")
            //! runtextmacro Unit_SetModel("/", "buildings\\demon\\CorruptedAncientofWar\\CorruptedAncientofWar.mdx", "", "", "", "")
            //! runtextmacro Unit_SetPathingTexture("/", "PathTextures\\12x12Default.tga")
            //! runtextmacro Unit_SetScale("/", "2.", "4.5")
            //! runtextmacro Unit_SetShadow("/", "ShadowGoblinMerchant", "0.", "0.", "0.", "0.")
            //! runtextmacro Unit_SetSight("/", "500.", "500.")
            //! runtextmacro Unit_SetSoldItems("/", "IEmP,IFiW,IHeO,IIcT,IMea,IScP,ISDr,ITpS,IThQ")
            //! runtextmacro Unit_SetSoundset("/", "Merchant")
            //! runtextmacro Unit_SetUbersplat("/", "EMDA")

            //! runtextmacro Unit_Finalize("/")

            //Reservoir
            //! runtextmacro Unit_Create("/", "RESERVOIR", "Res", "Reservoir", "false", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "FORT", "0.", "Stone")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.", "0.51")
            //! runtextmacro Unit_AddClass("/", "NEUTRAL")
            //! runtextmacro Unit_AddClass("/", "STRUCTURE")
            //! runtextmacro Unit_SetCombatFlags("/", "structure", "0.")
            //! runtextmacro Unit_SetDeathTime("/", "2.34")
            //! runtextmacro Unit_SetElevation("/", "4", "50.", "0.", "0.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNMoonWell.blp")
            //! runtextmacro Unit_SetLife("/", "UNIT_TYPE.Life.BLACK_DISPLAY", "0.")
            //! runtextmacro Unit_SetMana("/", "200.", "2.")
            //! runtextmacro Unit_SetMissilePoints("/", "120.", "0.", "0.", "60.")
            //! runtextmacro Unit_SetModel("/", "buildings\\nightelf\\MoonWell\\MoonWell.mdx", "", "", "", "")
            //! runtextmacro Unit_SetPathingTexture("/", "PathTextures\\8x8Default.tga")
            //! runtextmacro Unit_SetScale("/", "1.1", "3.")
            //! runtextmacro Unit_SetShadow("/", "ShadowMoonWell", "0.", "0.", "0.", "0.")
            //! runtextmacro Unit_SetSight("/", "300.", "300.")
            //! runtextmacro Unit_SetSoundset("/", "MoonWell")
            //! runtextmacro Unit_SetUbersplat("/", "ESMB")
            //! runtextmacro Unit_SetVertexColor("/", "150", "200", "255", "255")

            //! runtextmacro Unit_Finalize("/")

            //Ride Shop
            //! runtextmacro Unit_Create("/", "RIDE_SHOP", "RiS", "Ride Shop", "false", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "LIGHT", "0.", "Flesh")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.", "0.51")
            //! runtextmacro Unit_AddClass("/", "NEUTRAL")
            //! runtextmacro Unit_AddClass("/", "STRUCTURE")
            //! runtextmacro Unit_SetCombatFlags("/", "structure", "0.")
            //! runtextmacro Unit_SetDeathTime("/", "3.")
            //! runtextmacro Unit_SetElevation("/", "4", "50.", "0.", "0.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNRiderlessHorse.blp")
            //! runtextmacro Unit_SetLife("/", "UNIT_TYPE.Life.BLACK_DISPLAY", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "120.", "0.", "0.", "60.")
            //! runtextmacro Unit_SetModel("/", "units\\human\\KnightNoRider\\KnightNoRider.mdx", "", "", "", "")
            //! runtextmacro Unit_SetScale("/", "1.3", "1.23")
            //! runtextmacro Unit_SetShadow("/", "NORMAL", "120.", "120.", "60.", "60.")
            //! runtextmacro Unit_SetSight("/", "500.", "500.")
            //! runtextmacro Unit_SetSoldItems("/", "IHoR")

            //! runtextmacro Unit_Finalize("/")

            //Rosa
            //! runtextmacro Unit_Create("/", "ROSA", "Ros", "Rosa", "false", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "UNARMORED", "0.", "Flesh")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.45", "1.08")
            //! runtextmacro Unit_AddClass("/", "NEUTRAL")
            //! runtextmacro Unit_SetCombatFlags("/", "", "0.")
            //! runtextmacro Unit_SetDeathTime("/", "1.87")
            //! runtextmacro Unit_SetElevation("/", "0", "30.", "10.", "10.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNSorceress.blp")
            //! runtextmacro Unit_SetLife("/", "100.", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "85.")
            //! runtextmacro Unit_SetModel("/", "units\\human\\Sorceress\\Sorceress.mdx", "", "", "", "")
            //! runtextmacro Unit_SetScale("/", "1.5", "1.")
            //! runtextmacro Unit_SetShadow("/", "NORMAL", "100.", "100.", "45.", "45.")
            //! runtextmacro Unit_SetSight("/", "500.", "500.")
            //! runtextmacro Unit_SetSoundset("/", "Sorceress")
            //! runtextmacro Unit_SetSpellPower("/", "500.")

            //! runtextmacro Unit_Finalize("/")

            //Tavern
            //! runtextmacro Unit_Create("/", "TAVERN", "Tav", "Tavern", "false", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "FORT", "0.", "Wood")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.", "0.51")
            //! runtextmacro Unit_AddClass("/", "NEUTRAL")
            //! runtextmacro Unit_AddClass("/", "STRUCTURE")
            //! runtextmacro Unit_SetCombatFlags("/", "structure", "0.")
            //! runtextmacro Unit_SetDeathTime("/", "3.")
            //! runtextmacro Unit_SetElevation("/", "4", "50.", "0.", "0.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNTavern.blp")
            //! runtextmacro Unit_SetLife("/", "UNIT_TYPE.Life.BLACK_DISPLAY", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "120.", "0.", "0.", "60.")
            //! runtextmacro Unit_SetModel("/", "buildings\\other\\Tavern\\Tavern.mdx", "", "", "", "")
            //! runtextmacro Unit_SetPathingTexture("/", "PathTextures\\Tavern.tga")
            //! runtextmacro Unit_SetScale("/", "2.", "8.")
            //! runtextmacro Unit_SetShadow("/", "BuildingShadowSmall", "0.", "0.", "0.", "0.")
            //! runtextmacro Unit_SetSight("/", "500.", "500.")
            //! runtextmacro Unit_SetSoldItems("/", "ITrR")
            //! runtextmacro Unit_SetUbersplat("/", "HMED")

            //! runtextmacro Unit_Finalize("/")

            //Tower
            //! runtextmacro Unit_Create("/", "TOWER", "Tow", "Tower", "false", "DEFENDER", "1.")

            //! runtextmacro Unit_SetArmor("/", "LARGE", "2.", "Wood")
            //! runtextmacro Unit_SetAttack("/", "ARTILLERY", "2.5", "2000.", "0.", "ground,structure,debris,item,ward", "0.", "")
            //! runtextmacro Unit_SetAttackMissile("/", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdx", "900.", "0.35")
            //! runtextmacro Unit_AddAttackSplash("/", "80.", "1.")
            //! runtextmacro Unit_AddAttackSplash("/", "150.", "0.4")
            //! runtextmacro Unit_AddAttackSplash("/", "220.", "0.2")
            //! runtextmacro Unit_AddAttackSplashTargets("/", "ALLY")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.", "0.51")
            //! runtextmacro Unit_AddClass("/", "STRUCTURE")
            //! runtextmacro Unit_SetCombatFlags("/", "structure", "2000.")
            //! runtextmacro Unit_SetDamage("/", "SIEGE", "10", "5", "3", "0.3")
            //! runtextmacro Unit_SetDeathTime("/", "2.34")
            //! runtextmacro Unit_SetElevation("/", "4", "50.", "0.", "0.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNRockTower.blp")
            //! runtextmacro Unit_SetLife("/", "UNIT_TYPE.Life.BLACK_DISPLAY", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
            //! runtextmacro Unit_SetModel("/", "Units\\Other\\Tower\\Tower.mdx", "", "", "second", "")
            //! runtextmacro Unit_SetScale("/", "2.25", "1.5")
            //! runtextmacro Unit_SetShadow("/", "ShadowCannonTower", "0.", "0.", "0.", "0.")
            //! runtextmacro Unit_SetSight("/", "800.", "1400.")
            //! runtextmacro Unit_SetSoundset("/", "ElvenGuardTower")

            //! runtextmacro Unit_Finalize("/")

            //Victor
            //! runtextmacro Unit_Create("/", "VICTOR", "Vic", "Victor", "false", "DEFENDER", "1.2")

            //! runtextmacro Unit_SetArmor("/", "LARGE", "0.", "Metal")
            //! runtextmacro Unit_AddAttachment("/", "Units\\Victor\\Hammer.mdx", "HAND_RIGHT", "LOW")
            //! runtextmacro Unit_SetBlend("/", "0.15")
            //! runtextmacro Unit_SetCasting("/", "0.", "0.51")
            //! runtextmacro Unit_AddClass("/", "NEUTRAL")
            //! runtextmacro Unit_SetCombatFlags("/", "", "0.")
            //! runtextmacro Unit_SetDeathTime("/", "3.")
            //! runtextmacro Unit_SetElevation("/", "0", "20.", "10.", "10.")
            //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNVillagerMan1.blp")
            //! runtextmacro Unit_SetLife("/", "200.", "0.")
            //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
            //! runtextmacro Unit_SetModel("/", "units\\critters\\VillagerMan1\\VillagerMan1.mdx", "", "", "", "")
            //! runtextmacro Unit_SetScale("/", "1.2", "1.")
            //! runtextmacro Unit_SetShadow("/", "NORMAL", "140.", "140.", "50.", "50.")
            //! runtextmacro Unit_SetSight("/", "500.", "500.")
            //! runtextmacro Unit_SetSoundset("/", "VillagerMan2")
            //! runtextmacro Unit_SetSpellPower("/", "300.")

            //! runtextmacro Unit_Finalize("/")

            //DefenderSpawns
                //Swordsman
                //! runtextmacro Unit_Create("/", "SWORDSMAN", "Swo", "Swordsman", "false", "DEFENDER", "1.2")

                //! runtextmacro Unit_SetArmor("/", "LARGE", "3.", "Metal")
                //! runtextmacro Unit_SetAttack("/", "NORMAL", "1.", "100.", "250.", "ground,structure,debris,item,ward", "0.", "MetalMediumSlice")
                //! runtextmacro Unit_SetBlend("/", "0.15")
                //! runtextmacro Unit_SetCasting("/", "0.", "0.51")
                //! runtextmacro Unit_SetCollisionSize("/", "31.")
                //! runtextmacro Unit_SetCombatFlags("/", "ground", "500.")
                //! runtextmacro Unit_SetDamage("/", "NORMAL", "2", "1", "3", "0.5")
                //! runtextmacro Unit_SetDeathTime("/", "3.04")
                //! runtextmacro Unit_SetElevation("/", "0", "20.", "10.", "10.")
                //! runtextmacro Unit_SetExp("/", "10")
                //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNTheCaptain.blp")
                //! runtextmacro Unit_SetLife("/", "400.", "1.")
                //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
                //! runtextmacro Unit_SetModel("/", "units\\human\\TheCaptain\\TheCaptain.mdl", "", "", "", "")
                //! runtextmacro Unit_SetMovement("/", "FOOT", "270.", "0.6", "5", "200.", "200.")
                //! runtextmacro Unit_SetScale("/", "1.25", "1.2")
                //! runtextmacro Unit_SetShadow("/", "NORMAL", "120.", "120.", "60.", "60.")
                //! runtextmacro Unit_SetSight("/", "800.", "1400.")
                //! runtextmacro Unit_SetSoundset("/", "Captain")
                //! runtextmacro Unit_SetSpellPower("/", "40.")
                //! runtextmacro Unit_SetSupply("/", "20")
                //! runtextmacro Unit_SetVertexColor("/", "255", "255", "255", "255")

                //! runtextmacro Unit_Finalize("/")

                //Vicar
                //! runtextmacro Unit_Create("/", "VICAR", "Via", "Vicar", "false", "DEFENDER", "1.")

                //! runtextmacro Unit_SetArmor("/", "UNARMORED", "0.", "Flesh")
                //! runtextmacro Unit_SetAttack("/", "HOMING_MISSILE", "2.", "600.", "250.", "ground,structure,debris,air,item,ward", "0.", "")
                //! runtextmacro Unit_SetAttackMissile("/", "Abilities\\Weapons\\PriestMissile\\PriestMissile.mdl", "1200.", "0.15")
                //! runtextmacro Unit_SetBlend("/", "0.15")
                //! runtextmacro Unit_SetCasting("/", "0.3", "0.51")
                //! runtextmacro Unit_SetCollisionSize("/", "16.")
                //! runtextmacro Unit_SetCombatFlags("/", "ground", "600.")
                //! runtextmacro Unit_SetDamage("/", "MAGIC", "1", "1", "2", "0.3")
                //! runtextmacro Unit_SetDeathTime("/", "3.")
                //! runtextmacro Unit_SetElevation("/", "0", "50.", "10.", "10.")
                //! runtextmacro Unit_SetExp("/", "10")
                //! runtextmacro Unit_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNBanditMage.blp")
                //! runtextmacro Unit_SetLife("/", "200.", "1.")
                //! runtextmacro Unit_SetMana("/", "150.", "1.")
                //! runtextmacro Unit_SetMissilePoints("/", "60.", "0.", "0.", "60.")
                //! runtextmacro Unit_SetModel("/", "units\\creeps\\HumanMage\\HumanMage.mdl", "", "", "", "")
                //! runtextmacro Unit_SetMovement("/", "FOOT", "270.", "0.5", "0", "185.", "185.")
                //! runtextmacro Unit_SetScale("/", "1.15", "1.")
                //! runtextmacro Unit_SetShadow("/", "NORMAL", "80.", "80.", "40.", "40.")
                //! runtextmacro Unit_SetSight("/", "800.", "1400.")
                //! runtextmacro Unit_SetSoundset("/", "Priest")
                //! runtextmacro Unit_SetSpellPower("/", "15.")
                //! runtextmacro Unit_SetSupply("/", "20")
                //! runtextmacro Unit_SetVertexColor("/", "255", "255", "255", "255")

                //! runtextmacro Unit_Finalize("/")

        call thistype.Finalize()
    endmethod

    static method Init takes nothing returns nothing
        call thistype.Init_Executed.execute()
    endmethod
endstruct