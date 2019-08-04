//! runtextmacro BaseStruct("Animation", "ANIMATION")
    static constant string ATTACK = "attack"
    static constant string BIRTH = "birth"
    static constant string CHANNEL = "channel"
    static constant string DEATH = "death"
    static constant string STAND = "stand"
    static constant string STAND_READY = "stand ready"
    static constant string SPELL = "spell"
    static constant string SPELL_SLAM = "spell slam"
    static constant string VICTORY = "victory"
endstruct

//! runtextmacro BaseStruct("AttachPoint", "ATTACH_POINT")
    static constant string CHEST = "chest"
    static constant string CHEST_MOUNT_LEFT = "chest mount left"
    static constant string CHEST_MOUNT_RIGHT = "chest mount right"
    static constant string FOOT = "foot"
    static constant string FOOT_LEFT = "foot left"
    static constant string FOOT_RIGHT = "foot right"
    static constant string HAND = "hand"
    static constant string HAND_LEFT = "hand left"
    static constant string HAND_RIGHT = "hand right"
    static constant string HEAD = "head"
    static constant string MOUNT = "mount"
    static constant string MOUNT_LEFT = "mount left"
    static constant string MOUNT_RIGHT = "mount right"
    static constant string ORIGIN = "origin"
    static constant string OVERHEAD = "overhead"
    static constant string WEAPON = "weapon"
    static constant string WEAPON_LEFT = "weapon left"
    static constant string WEAPON_RIGHT = "weapon right"
endstruct

//! runtextmacro BaseStruct("Attack", "ATTACK")
    static constant real ARMOR_REDUCTION_FACTOR = 0.06

    static thistype NORMAL = 1
    static thistype MISSILE = 2
    static thistype HOMING_MISSILE = 3
    static thistype ARTILLERY = 4

    static constant integer ARMOR_TYPE_LIGHT = 0
    static constant integer ARMOR_TYPE_MEDIUM = 1
    static constant integer ARMOR_TYPE_LARGE = 2
    static constant integer ARMOR_TYPE_FORT = 3
    static constant integer ARMOR_TYPE_HERO = 4
    static constant integer ARMOR_TYPE_UNARMORED = 5
    static constant integer ARMOR_TYPE_DIVINE = 6

    static constant integer ARMOR_TYPES_AMOUNT = 7
    static real array MULTIPLIERS

    static constant integer DMG_TYPE_NORMAL = 0
    static constant integer DMG_TYPE_PIERCE = 1
    static constant integer DMG_TYPE_SIEGE = 2
    static constant integer DMG_TYPE_MAGIC = 3
    static constant integer DMG_TYPE_CHAOS = 4
    static constant integer DMG_TYPE_HERO = 5
    static constant integer DMG_TYPE_SPELLS = 6

    static method Get takes integer whichDamageType, integer whichArmorType returns real
        return thistype.MULTIPLIERS[whichDamageType * thistype.ARMOR_TYPES_AMOUNT + whichArmorType]
    endmethod

    static method Create takes integer whichDamageType, integer whichArmorType, real amount returns nothing
        set thistype.MULTIPLIERS[whichDamageType * thistype.ARMOR_TYPES_AMOUNT + whichArmorType] = amount
    endmethod

    initMethod Init of Header
        call thistype.Create(thistype.DMG_TYPE_NORMAL, thistype.ARMOR_TYPE_LIGHT, 1.)
        call thistype.Create(thistype.DMG_TYPE_NORMAL, thistype.ARMOR_TYPE_MEDIUM, 1.35)
        call thistype.Create(thistype.DMG_TYPE_NORMAL, thistype.ARMOR_TYPE_LARGE, 1.)
        call thistype.Create(thistype.DMG_TYPE_NORMAL, thistype.ARMOR_TYPE_FORT, 0.7)
        call thistype.Create(thistype.DMG_TYPE_NORMAL, thistype.ARMOR_TYPE_HERO, 1.)
        call thistype.Create(thistype.DMG_TYPE_NORMAL, thistype.ARMOR_TYPE_UNARMORED, 1.)
        call thistype.Create(thistype.DMG_TYPE_NORMAL, thistype.ARMOR_TYPE_DIVINE, 1.)

        call thistype.Create(thistype.DMG_TYPE_PIERCE, thistype.ARMOR_TYPE_LIGHT, 1.5)
        call thistype.Create(thistype.DMG_TYPE_PIERCE, thistype.ARMOR_TYPE_MEDIUM, 0.7)
        call thistype.Create(thistype.DMG_TYPE_PIERCE, thistype.ARMOR_TYPE_LARGE, 1.)
        call thistype.Create(thistype.DMG_TYPE_PIERCE, thistype.ARMOR_TYPE_FORT, 0.35)
        call thistype.Create(thistype.DMG_TYPE_PIERCE, thistype.ARMOR_TYPE_HERO, 0.5)
        call thistype.Create(thistype.DMG_TYPE_PIERCE, thistype.ARMOR_TYPE_UNARMORED, 1.35)
        call thistype.Create(thistype.DMG_TYPE_PIERCE, thistype.ARMOR_TYPE_DIVINE, 1.)

        call thistype.Create(thistype.DMG_TYPE_SIEGE, thistype.ARMOR_TYPE_LIGHT, 1.)
        call thistype.Create(thistype.DMG_TYPE_SIEGE, thistype.ARMOR_TYPE_MEDIUM, 0.65)
        call thistype.Create(thistype.DMG_TYPE_SIEGE, thistype.ARMOR_TYPE_LARGE, 1.)
        call thistype.Create(thistype.DMG_TYPE_SIEGE, thistype.ARMOR_TYPE_FORT, 1.5)
        call thistype.Create(thistype.DMG_TYPE_SIEGE, thistype.ARMOR_TYPE_HERO, 0.35)
        call thistype.Create(thistype.DMG_TYPE_SIEGE, thistype.ARMOR_TYPE_UNARMORED, 1.)
        call thistype.Create(thistype.DMG_TYPE_SIEGE, thistype.ARMOR_TYPE_DIVINE, 1.)

        call thistype.Create(thistype.DMG_TYPE_MAGIC, thistype.ARMOR_TYPE_LIGHT, 1.25)
        call thistype.Create(thistype.DMG_TYPE_MAGIC, thistype.ARMOR_TYPE_MEDIUM, 0.75)
        call thistype.Create(thistype.DMG_TYPE_MAGIC, thistype.ARMOR_TYPE_LARGE, 1.5)
        call thistype.Create(thistype.DMG_TYPE_MAGIC, thistype.ARMOR_TYPE_FORT, 0.35)
        call thistype.Create(thistype.DMG_TYPE_MAGIC, thistype.ARMOR_TYPE_HERO, 0.5)
        call thistype.Create(thistype.DMG_TYPE_MAGIC, thistype.ARMOR_TYPE_UNARMORED, 1.)
        call thistype.Create(thistype.DMG_TYPE_MAGIC, thistype.ARMOR_TYPE_DIVINE, 1.)

        call thistype.Create(thistype.DMG_TYPE_CHAOS, thistype.ARMOR_TYPE_LIGHT, 1.)
        call thistype.Create(thistype.DMG_TYPE_CHAOS, thistype.ARMOR_TYPE_MEDIUM, 1.)
        call thistype.Create(thistype.DMG_TYPE_CHAOS, thistype.ARMOR_TYPE_LARGE, 1.)
        call thistype.Create(thistype.DMG_TYPE_CHAOS, thistype.ARMOR_TYPE_FORT, 1.)
        call thistype.Create(thistype.DMG_TYPE_CHAOS, thistype.ARMOR_TYPE_HERO, 1.)
        call thistype.Create(thistype.DMG_TYPE_CHAOS, thistype.ARMOR_TYPE_UNARMORED, 1.)
        call thistype.Create(thistype.DMG_TYPE_CHAOS, thistype.ARMOR_TYPE_DIVINE, 1.)

        call thistype.Create(thistype.DMG_TYPE_HERO, thistype.ARMOR_TYPE_LIGHT, 1.)
        call thistype.Create(thistype.DMG_TYPE_HERO, thistype.ARMOR_TYPE_MEDIUM, 1.)
        call thistype.Create(thistype.DMG_TYPE_HERO, thistype.ARMOR_TYPE_LARGE, 1.)
        call thistype.Create(thistype.DMG_TYPE_HERO, thistype.ARMOR_TYPE_FORT, 1.)
        call thistype.Create(thistype.DMG_TYPE_HERO, thistype.ARMOR_TYPE_HERO, 1.)
        call thistype.Create(thistype.DMG_TYPE_HERO, thistype.ARMOR_TYPE_UNARMORED, 1.)
        call thistype.Create(thistype.DMG_TYPE_HERO, thistype.ARMOR_TYPE_DIVINE, 1.)

        call thistype.Create(thistype.DMG_TYPE_SPELLS, thistype.ARMOR_TYPE_LIGHT, 1.)
        call thistype.Create(thistype.DMG_TYPE_SPELLS, thistype.ARMOR_TYPE_MEDIUM, 1.)
        call thistype.Create(thistype.DMG_TYPE_SPELLS, thistype.ARMOR_TYPE_LARGE, 1.)
        call thistype.Create(thistype.DMG_TYPE_SPELLS, thistype.ARMOR_TYPE_FORT, 0.5)
        call thistype.Create(thistype.DMG_TYPE_SPELLS, thistype.ARMOR_TYPE_HERO, 1.)
        call thistype.Create(thistype.DMG_TYPE_SPELLS, thistype.ARMOR_TYPE_UNARMORED, 1.)
        call thistype.Create(thistype.DMG_TYPE_SPELLS, thistype.ARMOR_TYPE_DIVINE, 1.)
    endmethod
endstruct