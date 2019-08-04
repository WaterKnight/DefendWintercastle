//! runtextmacro Folder("ItemType")
    //! runtextmacro Struct("Id")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        //! runtextmacro CreateSimpleAddState("integer", "KEY_ARRAY + this")
    endstruct

    //! runtextmacro Folder("Data")
        //! runtextmacro Struct("Boolean")
            //! runtextmacro Data_Type_Implement("ItemType", "Boolean", "boolean")
        endstruct

        //! runtextmacro Folder("Integer")
            //! runtextmacro Struct("Table")
                //! runtextmacro Data_Type_Table_Implement("ItemType", "Integer", "integer")
            endstruct
        endscope

        //! runtextmacro Struct("Integer")
            //! runtextmacro LinkToStruct("Integer", "Table")

            //! runtextmacro Data_Type_Implement("ItemType", "Integer", "integer")
        endstruct
    endscope

    //! runtextmacro Struct("Data")
        //! runtextmacro LinkToStruct("Data", "Boolean")
        //! runtextmacro LinkToStruct("Data", "Integer")

        //! runtextmacro Data_Implement("ItemType")
    endstruct

    //! runtextmacro Struct("Event")
        //! runtextmacro CreateAnyStaticStateDefault("TRIGGER", "Trigger", "ItemType", "NULL")

        //! runtextmacro Event_Implement("ItemType")
    endstruct

    //! runtextmacro Struct("Abilities")
        //! runtextmacro GetKeyArray("KEY_ARRAY")
        //! runtextmacro GetKeyArray("KEY_ARRAY_DETAIL")

        method Count takes nothing returns integer
            return ItemType(this).Data.Integer.Table.Count(KEY_ARRAY)
        endmethod

        method Get takes integer index returns Spell
            return ItemType(this).Data.Integer.Table.Get(KEY_ARRAY, index)
        endmethod

        method GetLevel takes Spell whichSpell returns integer
            return ItemType(this).Data.Integer.Get(KEY_ARRAY_DETAIL + whichSpell)
        endmethod

        method AddWithLevel takes Spell whichSpell, integer level returns nothing
            call ItemType(this).Data.Integer.Table.Add(KEY_ARRAY, whichSpell)
            call ItemType(this).Data.Integer.Set(KEY_ARRAY_DETAIL + whichSpell, level)
        endmethod

        method Add takes Spell whichSpell returns nothing
            call this.AddWithLevel(whichSpell, 1)
        endmethod
    endstruct

    //! runtextmacro Struct("ChargesAmount")
        //! runtextmacro CreateSimpleAddState("integer", "0")
    endstruct

    //! runtextmacro Struct("Classes")
        //! runtextmacro GetKeyArray("KEY_ARRAY")

        method Count takes nothing returns integer
            return ItemType(this).Data.Integer.Table.Count(KEY_ARRAY)
        endmethod

        method Get takes integer index returns ItemClass
            return ItemType(this).Data.Integer.Table.Get(KEY_ARRAY, index)
        endmethod

        method Add takes ItemClass value returns nothing
            call ItemType(this).Data.Integer.Table.Add(KEY_ARRAY, value)
        endmethod
    endstruct

    //! runtextmacro Struct("Preload")
        method Event_Create takes nothing returns nothing
            call RemoveItem(CreateItem(ItemType(this).self, 0., 0.))
        endmethod
    endstruct
endscope

//! runtextmacro BaseStruct("ItemType", "ITEM_TYPE")
    //! runtextmacro GetKey("KEY")

    static thistype FIRE_WATER
    static thistype GOLD_COIN
    static thistype HORSE_RIDE
    static thistype ICE_TEA
    static thistype MEAT
    static thistype RUNE
    static thistype SCROLL_OF_PROTECTION
    static thistype SOFT_DRINK
    static thistype TELEPORT_SCROLL
    static thistype THIRST_QUENCHER
    static thistype TROPICAL_RAINBOW

    // Spell
    static thistype BARRIER
    static thistype BLIZZARD
    static thistype CHILLY_BREATH
    static thistype FIREBALL
    static thistype FLAME_TONGUE
    static thistype FROZEN_STAR
    static thistype GHOST_SWORD
    static thistype HEAT_EXPLOSION
    static thistype ICE_BLOCK
    static thistype SEVERANCE
    static thistype SNOWY_SPHERE
    static thistype VIVID_METEOR
    static thistype WARMTH_MAGNETISM

    // Act1
    static thistype BOOMERANG_STONE
    static thistype EMERGENCY_PROVISIONS
    static thistype EYE_OF_THE_FLAME
    static thistype HERBAL_OINTMENT
    static thistype MALLET
    static thistype PENGUIN_FEATHER
    static thistype RABBITS_FOOT
    static thistype RAMBLERS_STICK

    // Act2
    static thistype GRUNT_AXE
    static thistype ROBYNS_HOOD

    // Act3
    static thistype ELFIN_DAGGER
    static thistype SPEAR_OF_THE_DEFENDER

    // Act4

    // Act5

    // Act6
    static thistype METEORITE_SHARD

    integer self

    //! runtextmacro LinkToStruct("ItemType", "Abilities")
    //! runtextmacro LinkToStruct("ItemType", "ChargesAmount")
    //! runtextmacro LinkToStruct("ItemType", "Classes")
    //! runtextmacro LinkToStruct("ItemType", "Data")
    //! runtextmacro LinkToStruct("ItemType", "Event")
    //! runtextmacro LinkToStruct("ItemType", "Id")

    //! runtextmacro CreateAnyState("icon", "Icon", "string")

    static method GetFromSelf takes integer self returns thistype
        return Memory.IntegerKeys.GetInteger(self, KEY)
    endmethod

    method GetName takes nothing returns string
        return GetObjectName(this.self)
    endmethod

    method GetSelf takes nothing returns integer
        return this.self
    endmethod

    static method CreateFromSelf takes integer self returns thistype
        local thistype this = thistype.allocate()

        set this.self = self
        call Memory.IntegerKeys.SetInteger(self, KEY, this)

        call this.ChargesAmount.Event_Create()
        call this.Id.Event_Create()

        return this
    endmethod

    static method Event_Start takes nothing returns nothing
        call thistype.ICE_TEA.Abilities.AddWithLevel(IceTea.THIS_SPELL, 2)
        call thistype.FIRE_WATER.Abilities.Add(FireWater.THIS_SPELL)
        call thistype.MEAT.Abilities.Add(Meat.THIS_SPELL)
        call thistype.SOFT_DRINK.Abilities.Add(IceTea.THIS_SPELL)
        call thistype.TELEPORT_SCROLL.Abilities.Add(TeleportScroll.THIS_SPELL)
        call thistype.THIRST_QUENCHER.Abilities.AddWithLevel(IceTea.THIS_SPELL, 3)
        call thistype.TROPICAL_RAINBOW.Abilities.Add(TropicalRainbow.THIS_SPELL)

        // Act1
            call thistype.BOOMERANG_STONE.Abilities.Add(BoomerangStone.THIS_SPELL)
            call thistype.EMERGENCY_PROVISIONS.Abilities.Add(EmergencyProvisions.THIS_SPELL)
            call thistype.PENGUIN_FEATHER.Abilities.Add(PenguinFeather.THIS_SPELL)
            call thistype.SCROLL_OF_PROTECTION.Abilities.Add(ScrollOfProtection.THIS_SPELL)

        // Act2
            call thistype.EYE_OF_THE_FLAME.Abilities.Add(EyeOfTheFlame.THIS_SPELL)
    endmethod

    static method Init takes nothing returns nothing
    endmethod
endstruct