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
        local thistype this

        //Fire Water
        //! runtextmacro Item_Create("/", "FIRE_WATER", "FiW", "Fire-Water")

        //! runtextmacro Item_AddAbility("/", "AFiW")
        //! runtextmacro Item_SetChargesAmount("/", "1")
        //! runtextmacro Item_SetCost("/", "400", "0")
        //! runtextmacro Item_SetDescription("/", "Replenishes mana.")
        //! runtextmacro Item_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNGreaterInvulneralbility.blp")
        //! runtextmacro Item_SetModel("/", "Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl")
        //! runtextmacro Item_SetTooltip("/", "Purchase <name>")
        //! runtextmacro Item_SetUberTooltip("/", "Grants 750 mana and a 15 second immolation.")

        //! runtextmacro Item_Finalize("/")

        //Gold Coin
        //! runtextmacro Item_Create("/", "GOLD_COIN", "Coi", "Gold Coin")

        //! runtextmacro Item_AddClass("/", "POWER_UP")
        //! runtextmacro Item_SetDescription("/", "Glitters.")
        //! runtextmacro Item_SetModel("/", "Objects\\InventoryItems\\PotofGold\\PotofGold.mdl")
        //! runtextmacro Item_SetScale("/", "1.")

        //! runtextmacro Item_Finalize("/")

        //Horse Ride
        //! runtextmacro Item_Create("/", "HORSE_RIDE", "HoR", "Horse Ride")

        //! runtextmacro Item_SetCost("/", "100", "0")
        //! runtextmacro Item_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNRiderlessHorse.blp")
        //! runtextmacro Item_SetTooltip("/", "Mount a horse")
        //! runtextmacro Item_SetUberTooltip("/", "The horse carries you to its target location. You cannot act or be attacked meanwhile.")

        //! runtextmacro Item_Finalize("/")

        //Ice Tea
        //! runtextmacro Item_Create("/", "ICE_TEA", "IcT", "Ice Tea")

        //! runtextmacro Item_AddAbility("/", "AIcT")
        //! runtextmacro Item_SetChargesAmount("/", "1")
        //! runtextmacro Item_SetCost("/", "80", "0")
        //! runtextmacro Item_SetDescription("/", "Replenishes mana.")
        //! runtextmacro Item_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNLesserRejuvPotion.blp")
        //! runtextmacro Item_SetModel("/", "Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl")
        //! runtextmacro Item_SetTooltip("/", "Purchase <name>")
        //! runtextmacro Item_SetUberTooltip("/", "Returns 350 mana.")

        //! runtextmacro Item_Finalize("/")

        //Meat
        //! runtextmacro Item_Create("/", "MEAT", "Mea", "Meat")

        //! runtextmacro Item_AddAbility("/", "AMea")
        //! runtextmacro Item_SetChargesAmount("/", "1")
        //! runtextmacro Item_SetCost("/", "100", "0")
        //! runtextmacro Item_SetDescription("/", "Restores lost hitpoints.")
        //! runtextmacro Item_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNMonsterLure.blp")
        //! runtextmacro Item_SetModel("/", "Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl")
        //! runtextmacro Item_SetTooltip("/", "Purchase <name>")
        //! runtextmacro Item_SetUberTooltip("/", "Restores 300 hitpoints over 10 seconds.")

        //! runtextmacro Item_Finalize("/")

        //Rune
        //! runtextmacro Item_Create("/", "RUNE", "Run", "Rune")

        //! runtextmacro Item_AddClass("/", "POWER_UP")
        //! runtextmacro Item_SetDescription("/", "Pick me up to regain some health.")
        //! runtextmacro Item_SetModel("/", "Objects\\InventoryItems\\runicobject\\runicobject.mdl")

        //! runtextmacro Item_Finalize("/")

        //Soft Drink
        //! runtextmacro Item_Create("/", "SOFT_DRINK", "SDr", "Soft Drink")

        //! runtextmacro Item_AddAbility("/", "AIcT")
        //! runtextmacro Item_SetChargesAmount("/", "1")
        //! runtextmacro Item_SetCost("/", "40", "0")
        //! runtextmacro Item_SetDescription("/", "Replenishes mana.")
        //! runtextmacro Item_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNMinorRejuvPotion.blp")
        //! runtextmacro Item_SetModel("/", "Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl")
        //! runtextmacro Item_SetTooltip("/", "Purchase <name>")
        //! runtextmacro Item_SetUberTooltip("/", "Gives 200 mana back.")

        //! runtextmacro Item_Finalize("/")

        //Teleport Scroll
        //! runtextmacro Item_Create("/", "TELEPORT_SCROLL", "TpS", "Teleport Scroll")

        //! runtextmacro Item_AddAbility("/", "ATpS")
        //! runtextmacro Item_SetChargesAmount("/", "1")
        //! runtextmacro Item_SetCost("/", "250", "0")
        //! runtextmacro Item_SetDescription("/", "Teleports your hero.")
        //! runtextmacro Item_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNScrollUber.blp")
        //! runtextmacro Item_SetModel("/", "Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl")
        //! runtextmacro Item_SetTooltip("/", "Purchase <name>")
        //! runtextmacro Item_SetUberTooltip("/", "Teleports you to an allied building.")

        //! runtextmacro Item_Finalize("/")

        //Thirst Quencher
        //! runtextmacro Item_Create("/", "THIRST_QUENCHER", "ThQ", "Thirst Quencher")

        //! runtextmacro Item_AddAbility("/", "AIcT")
        //! runtextmacro Item_SetChargesAmount("/", "1")
        //! runtextmacro Item_SetCost("/", "210", "0")
        //! runtextmacro Item_SetDescription("/", "Replenishes mana.")
        //! runtextmacro Item_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNRejuvPotion.blp")
        //! runtextmacro Item_SetModel("/", "Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl")
        //! runtextmacro Item_SetTooltip("/", "Purchase <name>")
        //! runtextmacro Item_SetUberTooltip("/", "Returns 500 mana.")

        //! runtextmacro Item_Finalize("/")

        //Tropical Rainbow
        //! runtextmacro Item_Create("/", "TROPICAL_RAINBOW", "TrR", "Tropical Rainbow")

        //! runtextmacro Item_AddAbility("/", "ATrR")
        //! runtextmacro Item_SetChargesAmount("/", "1")
        //! runtextmacro Item_AddClass("/", "POWER_UP")
        //! runtextmacro Item_SetDescription("/", "Healthy common drink that shimmers in different colors.")
        //! runtextmacro Item_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNSnazzyPotion.blp")
        //! runtextmacro Item_SetModel("/", "Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl")
        //! runtextmacro Item_SetTooltip("/", "Grab a <name>")
        //! runtextmacro Item_SetUberTooltip("/", "Multivitamin drink that boosts damage, movement speed and spellpower by 20%, life regeneration and mana regeneration by 50%.|nLasts 60 seconds.")

        //! runtextmacro Item_Finalize("/")

        // Spell

        //Barrier
        //! runtextmacro Item_Create("/", "BARRIER", "Bar", "Barrier")

        //! runtextmacro Item_AddClass("/", "SCROLL")
        //! runtextmacro Item_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNFrostMourne.blp")
        //! runtextmacro Item_SetModel("/", "Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl")
        //! runtextmacro Item_SetTooltip("/", "Purchase <name>")
        //! runtextmacro Item_SetUberTooltip("/", "Contains power.")

        //! runtextmacro Item_Finalize("/")

        //Blizzard
        //! runtextmacro Item_Create("/", "BLIZZARD", "Blz", "Blizzard")

        //! runtextmacro Item_AddClass("/", "SCROLL")
        //! runtextmacro Item_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNBlizzard.blp")
        //! runtextmacro Item_SetModel("/", "Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl")
        //! runtextmacro Item_SetTooltip("/", "Purchase <name>")
        //! runtextmacro Item_SetUberTooltip("/", "Contains power.")

        //! runtextmacro Item_Finalize("/")

        //Chilly Breath
        //! runtextmacro Item_Create("/", "CHILLY_BREATH", "ChB", "Chilly Breath")

        //! runtextmacro Item_AddClass("/", "SCROLL")
        //! runtextmacro Item_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNBreathOfFrost.blp")
        //! runtextmacro Item_SetModel("/", "Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl")
        //! runtextmacro Item_SetTooltip("/", "Purchase <name>")
        //! runtextmacro Item_SetUberTooltip("/", "Contains power.")

        //! runtextmacro Item_Finalize("/")

        //Fireball
        //! runtextmacro Item_Create("/", "FIREBALL", "FiB", "Fireball")

        //! runtextmacro Item_AddClass("/", "SCROLL")
        //! runtextmacro Item_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNFireForTheCannon.blp")
        //! runtextmacro Item_SetModel("/", "Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl")
        //! runtextmacro Item_SetTooltip("/", "Purchase <name>")
        //! runtextmacro Item_SetUberTooltip("/", "Contains power.")

        //! runtextmacro Item_Finalize("/")

        //Flame Tongue
        //! runtextmacro Item_Create("/", "FLAME_TONGUE", "FlT", "Flame Tongue")

        //! runtextmacro Item_AddClass("/", "SCROLL")
        //! runtextmacro Item_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNFlare.blp")
        //! runtextmacro Item_SetModel("/", "Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl")
        //! runtextmacro Item_SetTooltip("/", "Purchase <name>")
        //! runtextmacro Item_SetUberTooltip("/", "Contains power.")

        //! runtextmacro Item_Finalize("/")

        //Frozen Star
        //! runtextmacro Item_Create("/", "FROZEN_STAR", "FrS", "Frozen Star")

        //! runtextmacro Item_AddClass("/", "SCROLL")
        //! runtextmacro Item_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNStaffOfNegation.blp")
        //! runtextmacro Item_SetModel("/", "Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl")
        //! runtextmacro Item_SetTooltip("/", "Purchase <name>")
        //! runtextmacro Item_SetUberTooltip("/", "Contains power.")

        //! runtextmacro Item_Finalize("/")

        //Ghost Sword
        //! runtextmacro Item_Create("/", "GHOST_SWORD", "GhS", "Ghost Sword")

        //! runtextmacro Item_AddClass("/", "SCROLL")
        //! runtextmacro Item_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNThoriumMelee.blp")
        //! runtextmacro Item_SetModel("/", "Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl")
        //! runtextmacro Item_SetTooltip("/", "Purchase <name>")
        //! runtextmacro Item_SetUberTooltip("/", "Contains power.")

        //! runtextmacro Item_Finalize("/")

        //Heat Explosion
        //! runtextmacro Item_Create("/", "HEAT_EXPLOSION", "HeE", "Heat Explosion")

        //! runtextmacro Item_AddClass("/", "SCROLL")
        //! runtextmacro Item_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNImmolationOn.blp")
        //! runtextmacro Item_SetModel("/", "Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl")
        //! runtextmacro Item_SetTooltip("/", "Purchase <name>")
        //! runtextmacro Item_SetUberTooltip("/", "Contains power.")

        //! runtextmacro Item_Finalize("/")

        //Ice Block
        //! runtextmacro Item_Create("/", "ICE_BLOCK", "IcB", "Ice Block")

        //! runtextmacro Item_AddClass("/", "SCROLL")
        //! runtextmacro Item_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNIcyTreasureBox.blp")
        //! runtextmacro Item_SetModel("/", "Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl")
        //! runtextmacro Item_SetTooltip("/", "Purchase <name>")
        //! runtextmacro Item_SetUberTooltip("/", "Contains power.")

        //! runtextmacro Item_Finalize("/")

        //Severance
        //! runtextmacro Item_Create("/", "SEVERANCE", "Sev", "Severance")

        //! runtextmacro Item_AddClass("/", "SCROLL")
        //! runtextmacro Item_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNAcidBomb.blp")
        //! runtextmacro Item_SetModel("/", "Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl")
        //! runtextmacro Item_SetTooltip("/", "Purchase <name>")
        //! runtextmacro Item_SetUberTooltip("/", "Contains power.")

        //! runtextmacro Item_Finalize("/")

        //Snowy Sphere
        //! runtextmacro Item_Create("/", "SNOWY_SPHERE", "SnS", "Snowy Sphere")

        //! runtextmacro Item_AddClass("/", "SCROLL")
        //! runtextmacro Item_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNTornado.blp")
        //! runtextmacro Item_SetModel("/", "Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl")
        //! runtextmacro Item_SetTooltip("/", "Purchase <name>")
        //! runtextmacro Item_SetUberTooltip("/", "Contains power.")

        //! runtextmacro Item_Finalize("/")

        //Vivid Meteor
        //! runtextmacro Item_Create("/", "VIVID_METEOR", "ViM", "Vivid Meteor")

        //! runtextmacro Item_AddClass("/", "SCROLL")
        //! runtextmacro Item_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNFireRocks.blp")
        //! runtextmacro Item_SetModel("/", "Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl")
        //! runtextmacro Item_SetTooltip("/", "Purchase <name>")
        //! runtextmacro Item_SetUberTooltip("/", "Contains power.")

        //! runtextmacro Item_Finalize("/")

        //Warmth Magnetism
        //! runtextmacro Item_Create("/", "WARMTH_MAGNETISM", "WaM", "Warmth Magnetism")

        //! runtextmacro Item_AddClass("/", "SCROLL")
        //! runtextmacro Item_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNGnollCommandAura.blp")
        //! runtextmacro Item_SetModel("/", "Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl")
        //! runtextmacro Item_SetTooltip("/", "Purchase <name>")
        //! runtextmacro Item_SetUberTooltip("/", "Contains power.")

        //! runtextmacro Item_Finalize("/")

        // Act1

        //Boomerang Stone
        //! runtextmacro Item_Create("/", "BOOMERANG_STONE", "BoS", "Boomerang Stone")

        //! runtextmacro Item_AddAbility("/", "ABoS")
        //! runtextmacro Item_SetCost("/", "250", "0")
        //! runtextmacro Item_SetDescription("/", "A clingy stone that finds its way back to its owner after being thrown.")
        //! runtextmacro Item_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNGolemStormBolt.blp")
        //! runtextmacro Item_SetModel("/", "Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl")
        //! runtextmacro Item_SetTooltip("/", "Purchase <name>")
        //! runtextmacro Item_SetUberTooltip("/", "Is thrown to the target to deal 40 damage and to paralyze it but then immediately turns back at you and stuns you too.")

        //! runtextmacro Item_Finalize("/")

        //Emergency Provisions
        //! runtextmacro Item_Create("/", "EMERGENCY_PROVISIONS", "EmP", "Emergency Provisions")

        //! runtextmacro Item_AddAbility("/", "AEmP")
        //! runtextmacro Item_SetChargesAmount("/", "1")
        //! runtextmacro Item_SetCost("/", "250", "0")
        //! runtextmacro Item_SetDescription("/", "Restores lost hitpoints.")
        //! runtextmacro Item_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNDust.blp")
        //! runtextmacro Item_SetModel("/", "Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl")
        //! runtextmacro Item_SetTooltip("/", "Purchase <name>")
        //! runtextmacro Item_SetUberTooltip("/", "Restores 100 hitpoints.")

        //! runtextmacro Item_Finalize("/")

        //Eye of the Flame
        //! runtextmacro Item_Create("/", "EYE_OF_THE_FLAME", "EoF", "Eye of the Flame")

        //! runtextmacro Item_AddAbility("/", "AEoF")
        //! runtextmacro Item_SetChargesAmount("/", "1")
        //! runtextmacro Item_SetCost("/", "250", "0")
        //! runtextmacro Item_SetDescription("/", "Sets up a flame-spouting ward that can reveal hidden enemies.")
        //! runtextmacro Item_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNSentryWard.blp")
        //! runtextmacro Item_SetModel("/", "Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl")
        //! runtextmacro Item_SetTooltip("/", "Purchase <name>")
        //! runtextmacro Item_SetUberTooltip("/", "Summons a ward with 65 hitpoints. That ward attacks nearby hostile units and is able to light them up to blow their magic hoods.")

        //! runtextmacro Item_Finalize("/")

        //Herbal Ointment
        //! runtextmacro Item_Create("/", "HERBAL_OINTMENT", "HeO", "Herbal Ointment")

        //! runtextmacro Item_AddAbility("/", "AHeO")
        //! runtextmacro Item_SetChargesAmount("/", "2")
        //! runtextmacro Item_SetCost("/", "65", "0")
        //! runtextmacro Item_SetDescription("/", "Dispels negative effects and has regenerative properties.")
        //! runtextmacro Item_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNHealingSalve.blp")
        //! runtextmacro Item_SetModel("/", "Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl")
        //! runtextmacro Item_SetTooltip("/", "Purchase <name>")
        //! runtextmacro Item_SetUberTooltip("/", "Regenerates 200 life/mana over 12 seconds. The user will be purged from negative effects.|n|cffffcc00Vanishes upon being attacked|r")

        //! runtextmacro Item_Finalize("/")

        //Mallet
        //! runtextmacro Item_Create("/", "MALLET", "Mal", "Mallet")

        //! runtextmacro Item_SetCost("/", "400", "0")
        //! runtextmacro Item_SetDescription("/", "Big hammer for big damage.")
        //! runtextmacro Item_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNHammer.blp")
        //! runtextmacro Item_SetModel("/", "Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl")
        //! runtextmacro Item_SetTooltip("/", "Purchase <name>")
        //! runtextmacro Item_SetUberTooltip("/", "Increases the strength by 4 and the damage by 12 when carried.")

        //! runtextmacro Item_Finalize("/")

        //Penguin Feather
        //! runtextmacro Item_Create("/", "PENGUIN_FEATHER", "PeF", "Penguin Feather")

        //! runtextmacro Item_AddAbility("/", "APeF")
        //! runtextmacro Item_SetCost("/", "300", "0")
        //! runtextmacro Item_SetDescription("/", "Fluffy and heat-insulating.")
        //! runtextmacro Item_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNPenguin.blp")
        //! runtextmacro Item_SetModel("/", "Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl")
        //! runtextmacro Item_SetTooltip("/", "Purchase <name>")
        //! runtextmacro Item_SetUberTooltip("/", "Heightens the evasion value by 35 and the intelligence by 3.|nUsing: Heals a target by 120.")

        //! runtextmacro Item_Finalize("/")

        //Rabbits Foot
        //! runtextmacro Item_Create("/", "RABBITS_FOOT", "RaF", "Rabbit's Foot")

        //! runtextmacro Item_SetCost("/", "265", "0")
        //! runtextmacro Item_SetDescription("/", "Endows luck.")
        //! runtextmacro Item_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNAdvancedStrengthOfTheWild.blp")
        //! runtextmacro Item_SetModel("/", "Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl")
        //! runtextmacro Item_SetTooltip("/", "Purchase <name>")
        //! runtextmacro Item_SetUberTooltip("/", "Increases your critical strike value by 20 and your evasion value by 25, plus 2 to mana regeneration.")

        //! runtextmacro Item_Finalize("/")

        //Ramblers Stick
        //! runtextmacro Item_Create("/", "RAMBLERS_STICK", "RaS", "Rambler's Stick")

        //! runtextmacro Item_SetCost("/", "280", "0")
        //! runtextmacro Item_SetDescription("/", "A sticky stick, the classic epee.")
        //! runtextmacro Item_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNNatureTouchGrow.blp")
        //! runtextmacro Item_SetModel("/", "Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl")
        //! runtextmacro Item_SetTooltip("/", "Purchase <name>")
        //! runtextmacro Item_SetUberTooltip("/", "Increases damage by 5, intelligence by 4 and armor by 1.")

        //! runtextmacro Item_Finalize("/")

        //Scroll of Protection
        //! runtextmacro Item_Create("/", "SCROLL_OF_PROTECTION", "ScP", "Scroll of Protection")

        //! runtextmacro Item_AddAbility("/", "AScP")
        //! runtextmacro Item_SetChargesAmount("/", "1")
        //! runtextmacro Item_SetCost("/", "140", "0")
        //! runtextmacro Item_SetDescription("/", "Buffs the armor of nearby friends.")
        //! runtextmacro Item_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNScroll.blp")
        //! runtextmacro Item_SetModel("/", "Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl")
        //! runtextmacro Item_SetTooltip("/", "Purchase <name>")
        //! runtextmacro Item_SetUberTooltip("/", "Grants near allied units a bonus armor of 4 for 30 seconds.")

        //! runtextmacro Item_Finalize("/")

        // Act2

        //Grunt Axe
        //! runtextmacro Item_Create("/", "GRUNT_AXE", "GrA", "Grunt Axe")

        //! runtextmacro Item_SetCost("/", "280", "0")
        //! runtextmacro Item_SetDescription("/", "A rough metal axe, that is more heavy than sharp.")
        //! runtextmacro Item_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNOrcMeleeUpOne.blp")
        //! runtextmacro Item_SetModel("/", "Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl")
        //! runtextmacro Item_SetTooltip("/", "Purchase <name>")
        //! runtextmacro Item_SetUberTooltip("/", "Increases the damage by 8 and the critical value strike by 50.")

        //! runtextmacro Item_Finalize("/")

        //Robyns Hood
        //! runtextmacro Item_Create("/", "ROBYNS_HOOD", "RoH", "Robyn's Hood")

        //! runtextmacro Item_SetCost("/", "320", "0")
        //! runtextmacro Item_SetDescription("/", "Simple leather clothing.")
        //! runtextmacro Item_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNHoodOfCunning.blp")
        //! runtextmacro Item_SetModel("/", "Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl")
        //! runtextmacro Item_SetTooltip("/", "Purchase <name>")
        //! runtextmacro Item_SetUberTooltip("/", "Heightens your armor by 4 and agility by 2.")

        //! runtextmacro Item_Finalize("/")

        // Act3

        //Elfin Dagger
        //! runtextmacro Item_Create("/", "ELFIN_DAGGER", "ElD", "Elfin Dagger")

        //! runtextmacro Item_SetCost("/", "600", "0")
        //! runtextmacro Item_SetDescription("/", "Increases spell damage and intelligence.")
        //! runtextmacro Item_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNWandOfManaSteal.blp")
        //! runtextmacro Item_SetModel("/", "Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl")
        //! runtextmacro Item_SetTooltip("/", "Purchase <name>")
        //! runtextmacro Item_SetUberTooltip("/", "Grants 25% spell damage and 10 intelligence.")

        //! runtextmacro Item_Finalize("/")

        //Spear of the Defender
        //! runtextmacro Item_Create("/", "SPEAR_OF_THE_DEFENDER", "SoD", "Spear of the Defender")

        //! runtextmacro Item_SetCost("/", "1000", "0")
        //! runtextmacro Item_SetDescription("/", "A long spear with a sharp point.")
        //! runtextmacro Item_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNThoriumRanged.blp")
        //! runtextmacro Item_SetModel("/", "Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl")
        //! runtextmacro Item_SetTooltip("/", "Purchase <name>")
        //! runtextmacro Item_SetUberTooltip("/", "Adds 50 bonus damage but also lowers the attack rate by 20%. Grants 20% more armor and there is a chance to wound the target for 50 damage over 10 seconds.")

        //! runtextmacro Item_Finalize("/")

        // Act4

        // Act5

        // Act6

        //Meteorite Shard
        //! runtextmacro Item_Create("/", "METEORITE_SHARD", "MeS", "Meteorite Shard")

        //! runtextmacro Item_SetCost("/", "120", "0")
        //! runtextmacro Item_SetDescription("/", "Radiates a remarkable, soothing warmth.")
        //! runtextmacro Item_SetIcon("/", "ReplaceableTextures\\CommandButtons\\BTNGlyph.blp")
        //! runtextmacro Item_SetModel("/", "Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl")
        //! runtextmacro Item_SetTooltip("/", "Purchase <name>")
        //! runtextmacro Item_SetUberTooltip("/", "Increases life by 100 and mana by 30.")

        //! runtextmacro Item_Finalize("/")
    endmethod
endstruct