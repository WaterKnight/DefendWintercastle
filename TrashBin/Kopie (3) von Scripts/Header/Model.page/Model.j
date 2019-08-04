function Preload_Wrapped takes string path returns nothing
    call Preload(path)
endfunction

//! runtextmacro BaseStruct("BloodSplat", "BLOOD_SPLAT")
    static thistype HUMAN_BLOOD_LARGE_1
    static thistype HUMAN_BLOOD_LARGE_2
    static thistype HUMAN_BLOOD_SMALL_0
    static thistype HUMAN_BLOOD_SMALL_1
    static thistype HUMAN_BLOOD_SMALL_3
    static thistype NIGHT_ELF_BLOOD_LARGE_0
    static thistype NIGHT_ELF_BLOOD_LARGE_2
    static thistype NIGHT_ELF_BLOOD_SMALL_0
    static thistype NIGHT_ELF_BLOOD_SMALL_2
    static thistype ORC_BLOOD_LARGE_1
    static thistype ORC_BLOOD_LARGE_2
    static thistype ORC_BLOOD_LARGE_3
    static thistype ORC_BLOOD_SMALL_0
    static thistype ORC_BLOOD_SMALL_2

    string self

    method Preload takes nothing returns nothing
        call Preload_Wrapped(this.self)
    endmethod

    static method Create takes string self returns thistype
        local thistype this = thistype.allocate()

        set this.self = self

        call this.Preload()

        return this
    endmethod

    static method Init_Executed takes nothing returns nothing
        set thistype.HUMAN_BLOOD_LARGE_1 = thistype.Create("ReplaceableTextures\\Splats\\Splat01Mature.blp")
        set thistype.HUMAN_BLOOD_LARGE_2 = thistype.Create("ReplaceableTextures\\Splats\\Splat01Mature.blp")
        set thistype.HUMAN_BLOOD_SMALL_0 = thistype.Create("ReplaceableTextures\\Splats\\Splat01Mature.blp")
        set thistype.HUMAN_BLOOD_SMALL_1 = thistype.Create("ReplaceableTextures\\Splats\\Splat01Mature.blp")
        set thistype.HUMAN_BLOOD_SMALL_3 = thistype.Create("ReplaceableTextures\\Splats\\Splat01Mature.blp")
        set thistype.NIGHT_ELF_BLOOD_LARGE_0 = thistype.Create("ReplaceableTextures\\Splats\\Splat01Mature.blp")
        set thistype.NIGHT_ELF_BLOOD_LARGE_2 = thistype.Create("ReplaceableTextures\\Splats\\Splat01Mature.blp")
        set thistype.NIGHT_ELF_BLOOD_SMALL_0 = thistype.Create("ReplaceableTextures\\Splats\\Splat01Mature.blp")
        set thistype.NIGHT_ELF_BLOOD_SMALL_2 = thistype.Create("ReplaceableTextures\\Splats\\Splat01Mature.blp")
        set thistype.ORC_BLOOD_LARGE_1 = thistype.Create("ReplaceableTextures\\Splats\\Splat01Mature.blp")
        set thistype.ORC_BLOOD_LARGE_2 = thistype.Create("ReplaceableTextures\\Splats\\Splat01Mature.blp")
        set thistype.ORC_BLOOD_LARGE_3 = thistype.Create("ReplaceableTextures\\Splats\\Splat01Mature.blp")
        set thistype.ORC_BLOOD_SMALL_0 = thistype.Create("ReplaceableTextures\\Splats\\Splat01Mature.blp")
        set thistype.ORC_BLOOD_SMALL_2 = thistype.Create("ReplaceableTextures\\Splats\\Splat01Mature.blp")

        call Game.DebugMsg("bloodsplat")
    endmethod

    static method Init takes nothing returns nothing
        call Code.Run(function thistype.Init_Executed)
    endmethod
endstruct

//! runtextmacro BaseStruct("FootPrint", "FOOT_PRINT")
    static thistype BOOT_LARGE_LEFT_0
    static thistype BOOT_LARGE_RIGHT_0
    static thistype BOOT_SMALL_LEFT_0
    static thistype BOOT_SMALL_RIGHT_0
    static thistype CLOVEN_REALLY_SMALL_LEFT
    static thistype CLOVEN_REALLY_SMALL_RIGHT
    static thistype HORSE_SMALL_LEFT
    static thistype HORSE_SMALL_RIGHT
    static thistype PAW_BEAR_LEFT
    static thistype PAW_BEAR_RIGHT
    static thistype PAW_LARGE_LEFT
    static thistype PAW_LARGE_RIGHT
    static thistype PAW_LEFT_0
    static thistype PAW_RIGHT_0

    string self

    method Preload takes nothing returns nothing
        call Preload_Wrapped(this.self)
    endmethod

    static method Create takes string self returns thistype
        local thistype this = thistype.allocate()

        set this.self = self

        call this.Preload()

        return this
    endmethod

    static method Init_Executed takes nothing returns nothing
        set thistype.BOOT_LARGE_LEFT_0 = thistype.Create("ReplaceableTextures\\Splats\\Splat01Mature.blp")
        set thistype.BOOT_LARGE_RIGHT_0 = thistype.Create("ReplaceableTextures\\Splats\\Splat01Mature.blp")
        set thistype.BOOT_SMALL_LEFT_0 = thistype.Create("ReplaceableTextures\\Splats\\Splat01Mature.blp")
        set thistype.BOOT_SMALL_RIGHT_0 = thistype.Create("ReplaceableTextures\\Splats\\Splat01Mature.blp")
        set thistype.CLOVEN_REALLY_SMALL_LEFT = thistype.Create("ReplaceableTextures\\Splats\\Splat01Mature.blp")
        set thistype.CLOVEN_REALLY_SMALL_RIGHT = thistype.Create("ReplaceableTextures\\Splats\\Splat01Mature.blp")
        set thistype.HORSE_SMALL_LEFT = thistype.Create("ReplaceableTextures\\Splats\\Splat01Mature.blp")
        set thistype.HORSE_SMALL_RIGHT = thistype.Create("ReplaceableTextures\\Splats\\Splat01Mature.blp")
        set thistype.PAW_BEAR_LEFT = thistype.Create("ReplaceableTextures\\Splats\\Splat01Mature.blp")
        set thistype.PAW_BEAR_RIGHT = thistype.Create("ReplaceableTextures\\Splats\\Splat01Mature.blp")
        set thistype.PAW_LARGE_LEFT = thistype.Create("ReplaceableTextures\\Splats\\Splat01Mature.blp")
        set thistype.PAW_LARGE_RIGHT = thistype.Create("ReplaceableTextures\\Splats\\Splat01Mature.blp")
        set thistype.PAW_LEFT_0 = thistype.Create("ReplaceableTextures\\Splats\\Splat01Mature.blp")
        set thistype.PAW_RIGHT_0 = thistype.Create("ReplaceableTextures\\Splats\\Splat01Mature.blp")

        call Game.DebugMsg("footprint")
    endmethod

    static method Init takes nothing returns nothing
        call Code.Run(function thistype.Init_Executed)
    endmethod
endstruct

//! runtextmacro BaseStruct("SoundSet", "SOUND_SET")
    //! runtextmacro GetKeyArray("PARENT_KEY_ARRAY")
    //! runtextmacro GetKeyArray("SOUND_PATHS_KEY_ARRAY")

    static thistype ANCESTRAL_GUARDIAN_MISSILE_HIT
    static thistype ANCESTRAL_GUARDIAN_MISSILE_LAUNCH
    static thistype ANTI_MAGIC_SHELL
    static thistype ARROW_LAUNCH
    static thistype AXE_MISSILE_HIT
    static thistype AXE_MISSILE_LAUNCH
    static thistype BREWMASTER_ATTACK_1
    static thistype BREWMASTER_ATTACK_2
    static thistype BREWMASTER_DEATH
    static thistype CATAPULT
    static thistype CANNON_TOWER_ATTACK
    static thistype CRUSHING_WAVE
    static thistype DEATH_KNIGHT_ATTACK_1
    static thistype DEATH_KNIGHT_DEATH
    static thistype DEATH_HUMAN_LARGE_BUILDING
    static thistype DREAD_LORD_DEATH
    static thistype DRUID_OF_THE_TALON_MISSILE_HIT
    static thistype DRUID_OF_THE_TALON_MISSILE_LAUNCH
    static thistype FARSEER_ATTACK_1
    static thistype FARSEER_DEATH
    static thistype FARSEER_MISSILE
    static thistype FIREBALL
    static thistype FIREBALL_LAUNCH
    static thistype FROST_NOVA
    static thistype GATHER_SHADOWS_MORPH
    static thistype GATHER_SHADOWS_MORPH_ALTERNATE
    static thistype HUMAN_DISSIPATE
    static thistype HUNTER_MISSILE_HIT
    static thistype HUNTER_MISSILE_LAUNCH
    static thistype JAINA_DEATH
    static thistype LICH_ATTACK_1
    static thistype LICH_MISSILE
    static thistype LIGHTNING_BOLT
    static thistype MOON_PRIESTESS_DEATH
    static thistype MORTAR
    static thistype MOUNTAIN_KING_ATTACK_1
    static thistype MOUNTAIN_KING_DEATH
    static thistype NECROMANCER_MISSILE_HIT
    static thistype NECROMANCER_MISSILE_LAUNCH
    static thistype NIGHT_ELF_DISSIPATE
    static thistype ORC_DISSIPATE
    static thistype PANDAREN_BREWMASTER_DEATH
    static thistype PENGUIN_DEATH
    static thistype PHOENIX_MISSILE_LAUNCH
    static thistype POSSESSION_MISSILE_HIT
    static thistype POSSESSION_MISSILE_LAUNCH
    static thistype RANGER_MISSILE
    static thistype STORMBOLT
    static thistype STRONG_DRINK_MISSILE
    static thistype TOME
    static thistype UNDEAD_DISSIPATE
    static thistype ZIGGURAT_MISSILE_HIT

    method Add takes string path returns nothing
        call Memory.IntegerKeys.Table.AddString(PARENT_KEY_ARRAY + this, SOUND_PATHS_KEY_ARRAY, path)
    endmethod

    static method Create takes nothing returns thistype
        local thistype this = thistype.allocate()

        return this
    endmethod

    static method Init_Executed takes nothing returns nothing
        local thistype this

        set this = thistype.Create()
        set thistype.ANCESTRAL_GUARDIAN_MISSILE_HIT = this
        call this.Add("Abilities\\Weapons\\AncestralGuardianMissile\\AncestralGuardianHit1.wav")

        set this = thistype.Create()
        set thistype.ANCESTRAL_GUARDIAN_MISSILE_LAUNCH = this
        call this.Add("Abilities\\Weapons\\AncestralGuardianMissile\\AncestralGuardianMissileLaunch.wav")

        set this = thistype.Create()
        set thistype.ANTI_MAGIC_SHELL = this
        call this.Add("Abilities\\Spells\\Undead\\AntiMagicShell\\AntiMagicShellBirth1.wav")

        set this = thistype.Create()
        set thistype.ARROW_LAUNCH = this
        call this.Add("Abilities\\Weapons\\Arrow\\ArrowAttack1.wav")

        set this = thistype.Create()
        set thistype.AXE_MISSILE_HIT = this
        call this.Add("Abilities\\Weapons\\Axe\\AxeMissile1.wav")
        call this.Add("Abilities\\Weapons\\Axe\\AxeMissile2.wav")

        set this = thistype.Create()
        set thistype.AXE_MISSILE_LAUNCH = this
        call this.Add("Abilities\\Weapons\\Axe\\AxeMissileLaunch1.wav")

        set this = thistype.Create()
        set thistype.BREWMASTER_ATTACK_1 = this
        call this.Add("Units\\Creeps\\PandarenBrewmaster\\PandarenBrewmasterAttackEffort1.wav")

        set this = thistype.Create()
        set thistype.BREWMASTER_ATTACK_2 = this
        call this.Add("Units\\Creeps\\PandarenBrewmaster\\PandarenBrewmasterAttackEffort2.wav")

        set this = thistype.Create()
        set thistype.BREWMASTER_DEATH = this
        call this.Add("Units\\Creeps\\PandarenBrewmaster\\BrewMasterDeath1.wav")

        set this = thistype.Create()
        set thistype.CANNON_TOWER_ATTACK = this
        call this.Add("Abilities\\Weapons\\CannonTowerMissile\\CannonTowerMissileLaunch1.wav")
        call this.Add("Abilities\\Weapons\\CannonTowerMissile\\CannonTowerMissileLaunch2.wav")
        call this.Add("Abilities\\Weapons\\CannonTowerMissile\\CannonTowerMissileLaunch3.wav")

        set this = thistype.Create()
        set thistype.CATAPULT = this
        call this.Add("Abilities\\Weapons\\Catapult\\CatapultMissile1.wav")
        call this.Add("Abilities\\Weapons\\Catapult\\CatapultMissile2.wav")
        call this.Add("Abilities\\Weapons\\Catapult\\CatapultMissile3.wav")
        call this.Add("Abilities\\Weapons\\Catapult\\CatapultMissile4.wav")

        set this = thistype.Create()
        set thistype.CRUSHING_WAVE = this
        call this.Add("Abilities\\Spells\\Orc\\Shockwave\\Shockwave.wav")

        set this = thistype.Create()
        set thistype.DEATH_KNIGHT_ATTACK_1 = this
        call this.Add("Units\\Undead\\HeroDeathKnight\\HeroDeathKnightAttack1.wav")

        set this = thistype.Create()
        set thistype.DEATH_KNIGHT_DEATH = this
        call this.Add("Units\\Undead\\HeroDeathKnight\\HeroDeathKnightDeath.wav")

        set this = thistype.Create()
        set thistype.DEATH_HUMAN_LARGE_BUILDING = this
        call this.Add("Sound\\Buildings\\Death\\BuildingDeathLargeHuman.wav")

        set this = thistype.Create()
        set thistype.DREAD_LORD_DEATH = this
        call this.Add("Units\\Undead\\HeroDreadLord\\HeroDreadLordDeath.wav")

        set this = thistype.Create()
        set thistype.DRUID_OF_THE_TALON_MISSILE_HIT = this
        call this.Add("DruidOfTheTalonMissileHit1.wav")
        call this.Add("DruidOfTheTalonMissileHit2.wav")
        call this.Add("DruidOfTheTalonMissileHit3.wav")

        set this = thistype.Create()
        set thistype.DRUID_OF_THE_TALON_MISSILE_LAUNCH = this
        call this.Add("Abilities\\Weapons\\DruidoftheTalonMissile\\DruidOfTheTalonMissileLaunch1.wav")
        call this.Add("Abilities\\Weapons\\DruidoftheTalonMissile\\DruidOfTheTalonMissileLaunch2.wav")

        set this = thistype.Create()
        set thistype.FARSEER_DEATH = this
        call this.Add("Units\\Orc\\HeroFarSeer\\HeroFarSeerDeath1.wav")

        set this = thistype.Create()
        set thistype.FARSEER_ATTACK_1 = this
        call this.Add("Abilities\\Weapons\\FarseerMissile\\FarseerMissileLaunch.wav")

        set this = thistype.Create()
        set thistype.FARSEER_MISSILE = this
        call this.Add("Abilities\\Weapons\\FarseerMissile\\FarseerMissile.wav")

        set this = thistype.Create()
        set thistype.FIREBALL = this
        call this.Add("Abilities\\Weapons\\FireBallMissile\\FireBallMissileDeath.wav")

        set this = thistype.Create()
        set thistype.FIREBALL_LAUNCH = this
        call this.Add("Abilities\\Weapons\\FireBallMissile\\FireBallMissileLaunch1.wav")
        call this.Add("Abilities\\Weapons\\FireBallMissile\\FireBallMissileLaunch2.wav")
        call this.Add("Abilities\\Weapons\\FireBallMissile\\FireBallMissileLaunch3.wav")

        set this = thistype.Create()
        set thistype.FROST_NOVA = this
        call this.Add("Abilities\\Spells\\Undead\\FrostNova\\FrostNovaTarget1.wav")

        set this = thistype.Create()
        set thistype.GATHER_SHADOWS_MORPH = this
        call this.Add("Units\\Undead\\HeroDreadLord\\DreadLordMorphIn1.wav")

        set this = thistype.Create()
        set thistype.GATHER_SHADOWS_MORPH_ALTERNATE = this
        call this.Add("Units\\Undead\\HeroDreadLord\\DreadLordMorphOut1.wav")

        set this = thistype.Create()
        set thistype.HUMAN_DISSIPATE = this
        call this.Add("Sound\\Units\\Human\\HumanDissipate1.wav")

        set this = thistype.Create()
        set thistype.HUNTER_MISSILE_HIT = this
        call this.Add("Abilities\\Weapons\\huntermissile\\HeadHunterMissileHit1.wav")
        call this.Add("Abilities\\Weapons\\huntermissile\\HeadHunterMissileHit2.wav")

        set this = thistype.Create()
        set thistype.HUNTER_MISSILE_LAUNCH = this
        call this.Add("Abilities\\Weapons\\huntermissile\\HeadHunterMissileLaunch.wav")

        set this = thistype.Create()
        set thistype.JAINA_DEATH = this
        call this.Add("Units\\Human\\Jaina\\JainaOnFootDeath1.wav")

        set this = thistype.Create()
        set thistype.LICH_ATTACK_1 = this
        call this.Add("Units\\Undead\\HeroLich\\LichAttackEffort1.wav")
        call this.Add("Units\\Undead\\HeroLich\\LichAttackEffort2.wav")
        call this.Add("Units\\Undead\\HeroLich\\LichAttackEffort3.wav")

        set this = thistype.Create()
        set thistype.LICH_MISSILE = this
        call this.Add("Abilities\\Weapons\\LichMissile\\LichMissileHit1.wav")
        call this.Add("Abilities\\Weapons\\LichMissile\\LichMissileHit2.wav")
        call this.Add("Abilities\\Weapons\\LichMissile\\LichMissileHit3.wav")

        set this = thistype.Create()
        set thistype.LIGHTNING_BOLT = this
        call this.Add("Abilities\\Spells\\Orc\\LightningBolt\\LightningBolt.wav")

        set this = thistype.Create()
        set thistype.MOON_PRIESTESS_DEATH = this
        call this.Add("Units\\NightElf\\HeroMoonPriestess\\HeroMoonPriestessDeath1.wav")

        set this = thistype.Create()
        set thistype.MORTAR = this
        call this.Add("Abilities\\Weapons\\Mortar\\MortarImpact.wav")

        set this = thistype.Create()
        set thistype.MOUNTAIN_KING_ATTACK_1 = this
        call this.Add("Units\\Human\\HeroMountainKing\\HeroMountainKingAttack1.wav")

        set this = thistype.Create()
        set thistype.MOUNTAIN_KING_DEATH = this
        call this.Add("Units\\Human\\HeroMountainKing\\HeroMountainKingDeath.wav")

        set this = thistype.Create()
        set thistype.NECROMANCER_MISSILE_HIT = this
        call this.Add("Abilities\\Weapons\\NecromancerMissile\\NecromancerMissileHit1.wav")
        call this.Add("Abilities\\Weapons\\NecromancerMissile\\NecromancerMissileHit2.wav")
        call this.Add("Abilities\\Weapons\\NecromancerMissile\\NecromancerMissileHit3.wav")

        set this = thistype.Create()
        set thistype.NECROMANCER_MISSILE_LAUNCH = this
        call this.Add("Abilities\\Weapons\\NecromancerMissile\\NecromancerMissileLaunch1.wav")
        call this.Add("Abilities\\Weapons\\NecromancerMissile\\NecromancerMissileLaunch2.wav")

        set this = thistype.Create()
        set thistype.NIGHT_ELF_DISSIPATE = this
        call this.Add("Sound\\Units\\NightElf\\NightElfDissipate1.wav")

        set this = thistype.Create()
        set thistype.ORC_DISSIPATE = this
        call this.Add("Sound\\Units\\Orc\\OrcDissipate1.wav")

        set this = thistype.Create()
        set thistype.PANDAREN_BREWMASTER_DEATH = this
        call this.Add("Units\\Creeps\\PandarenBrewmaster\\BrewMasterDeath1.wav")

        set this = thistype.Create()
        set thistype.PENGUIN_DEATH = this
        call this.Add("Units\\Critters\\Penguin\\PenguinDeath1.wav")

        set this = thistype.Create()
        set thistype.PHOENIX_MISSILE_LAUNCH = this
        call this.Add("Abilities\\Weapons\\PhoenixMissile\\PhoenixAttack.wav")

        set this = thistype.Create()
        set thistype.POSSESSION_MISSILE_HIT = this
        call this.Add("Abilities\\Spells\\Undead\\Possession\\PossessionMissileHit1.wav")

        set this = thistype.Create()
        set thistype.POSSESSION_MISSILE_LAUNCH = this
        call this.Add("Abilities\\Spells\\Undead\\Possession\\PossessionMissileLaunch1.wav")

        set this = thistype.Create()
        set thistype.RANGER_MISSILE = this
        call this.Add("Abilities\\Weapons\\RangerMissile\\RangerMissile1.wav")
        call this.Add("Abilities\\Weapons\\RangerMissile\\RangerMissile2.wav")
        call this.Add("Abilities\\Weapons\\RangerMissile\\RangerMissile3.wav")

        set this = thistype.Create()
        set thistype.STORMBOLT = this
        call this.Add("Abilities\\Spells\\Human\\StormBolt\\ThunderBoltMissileDeath.wav")

        set this = thistype.Create()
        set thistype.STRONG_DRINK_MISSILE = this
        call this.Add("Abilities\\Spells\\Other\\StrongDrink\\StrongDrinkMissile1.wav")

        set this = thistype.Create()
        set thistype.TOME = this
        call this.Add("Abilities\\Spells\\Items\\AIam\\Tomes.wav")

        set this = thistype.Create()
        set thistype.UNDEAD_DISSIPATE = this
        call this.Add("Sound\\Units\\Undead\\Dissipate\\UndeadDissipate2.wav")

        set this = thistype.Create()
        set thistype.ZIGGURAT_MISSILE_HIT = this
        call this.Add("Abilities\\Weapons\\ZigguratMissile\\ZigguratMissileHit1.wav")
        call this.Add("Abilities\\Weapons\\ZigguratMissile\\ZigguratMissileHit2.wav")
        call this.Add("Abilities\\Weapons\\ZigguratMissile\\ZigguratMissileHit3.wav")

        call Game.DebugMsg("soundset")
    endmethod

    static method Init takes nothing returns nothing
        call Code.Run(function thistype.Init_Executed)
    endmethod
endstruct

//! runtextmacro BaseStruct("Texture", "TEXTURE")
        //Destructables
        static thistype EXPLOSIVE

        //Doodads
        static thistype ARCHWAY_STONE
        static thistype BONES
        static thistype BOULDER
        static thistype BROKEN_COLUMN
        static thistype CHAIR
        static thistype CITY
        static thistype COLD_AIR
        static thistype CRYSTAL
        static thistype DEAD_TREE
        static thistype DUNGEON_0
        static thistype ENERGY_BARRIER
        static thistype FENCE
        static thistype FIRE_PIT
        static thistype GENERAL_DOODADS_0
        static thistype GENERAL_DOODADS_1
        static thistype GHOST_1
        static thistype GLACIER
        static thistype ICE_CROWN_0
        static thistype ICE_CROWN_1
        static thistype ICE_CROWN_WALLS
        static thistype ICE_FLOE
        static thistype IGLOO
        static thistype MONK_STATUE
        static thistype OBSTACLE
        static thistype RUBBLE
        static thistype RUBBLE_ASHEN
        static thistype RUINS_TRASH
        static thistype TAVERN_SIGN
        static thistype TOWER_SCORCHED
        static thistype TREE
        static thistype TREE11
        static thistype WALL
        static thistype WATERFALL

        //Items
        static thistype GENERAL_ITEM
        static thistype SPELL_ITEM

        //Spells
        static thistype LAPIDATION
        static thistype MANA_LASER
        static thistype SEVERANCE

        //Units
            static thistype PENGUIN

            //Heroes
            static thistype ARURUW
            static thistype DRAKUL
            static thistype LIZZY
            static thistype ROCKETEYE
            static thistype ROCKETEYE_AVATAR
            static thistype SMOKEALOT
            static thistype STORMY
            static thistype TAJRAN

            //Missiles
            static thistype ARROW_MISSILE
            static thistype AXE_MISSILE
            static thistype FLYING_PENGUIN_MISSILE

            //Spawns
                //Act1
                static thistype DEER
                static thistype FURBOLG_ORACLE
                static thistype MOONKIN
                static thistype SATYR
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
                static thistype DRUMMER
                static thistype LEADER
                static thistype NAGAROSH
                static thistype PEON
                static thistype RAIDER
                static thistype SPEAR_SCOUT
                static thistype TAROG
                static thistype TRUE_LEADER

            //Summons
            static thistype POLAR_BEAR
            static thistype SERPENT_WARD
            static thistype SPIRIT_WOLF
            static thistype TRAP_MINE

            //Other
            static thistype FOUNTAIN
            static thistype FOUNTAIN_BLOOD
            static thistype MARKET
            static thistype METEORITE
            static thistype ROSA
            static thistype SEBASTIAN
            static thistype STUFF
            static thistype STUFF2
            static thistype TAVERN
            static thistype TOWER

        //Other
        static thistype ACOLYTE
        static thistype ALCHEMIST_BLUE
        static thistype ARCANE_VAULT
        static thistype ARTHAS
        static thistype ARTHAS_CLOAK_CREDITS
        static thistype ARTHAS2
        static thistype AXE_BLADE_BLUE_STEEL
        static thistype BACKGROUND
        static thistype BLADE_MASTER
        static thistype BLOOD_PRIEST
        static thistype BLOOD_SPLASH
        static thistype BLOOD_SPLUT
        static thistype BLOOD_WHITE_SMALL
        static thistype BLUE_GLOW2
        static thistype BLUE_SQ_GLOW
        static thistype CARTOON_CLOUD
        static thistype CHAOS_RAIDER
        static thistype CLIFF_0
        static thistype CLOUD_SINGLE
        static thistype CLOUDS_8X8
        static thistype CLOUDS_8X8_FADE
        static thistype CLOUDS_8X8_FIRE
        static thistype CLOUDS_8X8_GREY
        static thistype CLOUDS_8X8_MOD_FIRE
        static thistype DEATH_SCREAM
        static thistype DEATH_SMUG
        static thistype DUST_A
        static thistype DUST3
        static thistype DUST_3X
        static thistype DUST_5A
        static thistype DUST_5A_BLACK
        static thistype DUST_6_COLOR
        static thistype DUST_6_COLOR_RED
        static thistype DUST6
        static thistype E_SMOKE_ANIM256
        static thistype ENERGY
        static thistype ENSNARE
        static thistype FACELESS_ONE
        static thistype FIRE_RING_1A
        static thistype FIRE_RING4
        static thistype FLAME_4
        static thistype FLARE
        static thistype FLARE_BLOOD
        static thistype FROST2
        static thistype FROST3
        static thistype FUR_BOOTS2
        static thistype GENERIC_CLOUD_FADED
        static thistype GENERIC_GLOW
        static thistype GENERIC_GLOW_2B
        static thistype GENERIC_GLOW_64
        static thistype GOBLIN
        static thistype GRAD3
        static thistype GREEN_GLOW2
        static thistype GUTZ
        static thistype HAIR_02_09
        static thistype HANDLE_RED_WRAPPED
        static thistype HEAD_HUNTER
        static thistype ICE
        static thistype ICE_3B
        static thistype LAVA_LUMP
        static thistype LAVA_LUMP2
        static thistype LENS_FLARE_1A
        static thistype LICH
        static thistype LIGHTNING_BALL
        static thistype MAIL_C_PADS
        static thistype ORC_BARRACKS
        static thistype PURPLE_GLOW
        static thistype PURPLE_GLOW_DIM
        static thistype RAIN_TAIL
        static thistype RED_GLOW2
        static thistype RED_GLOW3
        static thistype RED_STAR3
        static thistype RIBBON_BLUR
        static thistype RIBBON_MAGIC
        static thistype RIBBON_NE_RED2
        static thistype ROCK_PARTICLE
        static thistype ROCK64
        static thistype SACRIFICIAL_ALTAR_SKULL
        static thistype SHADOW
        static thistype SHIELD_ROUND_A_01_BLACK
        static thistype SHOCKWAVE
        static thistype SHOCKWAVE_4_WHITE
        static thistype SHOCKWAVE_B
        static thistype SHOCKWAVE_WATER
        static thistype SHOCKWAVE_ICE
        static thistype SHOCKWAVE10
        static thistype SHOULDER_PLATE_D2_ARTHAS
        static thistype SMOKE
        static thistype SNOWFLAKE
        static thistype SNOWFLAKE2
        static thistype SPINNING_BOARD
        static thistype STAR_8B
        static thistype STAR2_32
        static thistype STAR32
        static thistype STAR4
        static thistype STAR4_32
        static thistype TAUREN
        static thistype TEAM_COLOR_00
        static thistype TEAM_GLOW_00
        static thistype TOON_SMOKE_X
        static thistype WARDS
        static thistype WATER_BLOBS
        static thistype WATER_WAKE2
        static thistype WATER_WAKE3
        static thistype WHITE_64_FOAM
        static thistype YELLOW_GLOW
        static thistype YELLOW_GLOW_DIM
        static thistype YELLOW_GLOW2
        static thistype YELLOW_GLOW3
        static thistype YELLOW_STAR
        static thistype YELLOW_STAR_DIM
        static thistype ZAP
        static thistype ZAP_RED

    string self

    method Preload takes nothing returns nothing
        call Preload_Wrapped(this.self)
    endmethod

    static method Create takes string self returns thistype
        local thistype this = thistype.allocate()

        set this.self = self

        call this.Preload()

        return this
    endmethod

    static method Init_Executed takes nothing returns nothing
        //Destructables
        set thistype.EXPLOSIVE = thistype.Create("units\\Other\\TNTBarrel\\TNTbarrel.blp")

        //Doodads
        set thistype.ARCHWAY_STONE = thistype.Create("Textures\\UndergroundDoodad1.blp")
        set thistype.BONES = thistype.Create("doodads\\Northrend\\Props\\North_Bones\\NorthrendNatural01.blp")
        set thistype.BOULDER = thistype.Create("doodads\\LordaeronSummer\\Terrain\\LoardaeronRockChunks\\LordaeronRockChunks.blp")
        set thistype.BROKEN_COLUMN = thistype.Create("Textures\\FelwoodStructures.blp")
        set thistype.CHAIR = thistype.Create("Textures\\IcecrownThroneRoom.blp")
        set thistype.CITY = thistype.Create("Textures\\CityStructures.blp")
        set thistype.COLD_AIR = thistype.Create("Textures\\CloudSingle.blp")
        set thistype.CRYSTAL = thistype.Create("doodads\\Icecrown\\Rocks\\Icecrown_Crystal\\crystal.blp")
        set thistype.DEAD_TREE = thistype.Create("ReplaceableTextures\\NorthrendTree\\NorthTree.blp")
        set thistype.DUNGEON_0 = thistype.Create("Textures\\DungeonDoodad0.blp")
        set thistype.ENERGY_BARRIER = thistype.Create("doodads\\Cinematic\\EnergyFieldWall\\PurpleEnergy.blp")
        set thistype.FENCE = thistype.Create("Textures\\NorthrendStructures.blp")
        set thistype.FIRE_PIT = thistype.Create("doodads\\Northrend\\Props\\FirePitTrashed\\FirePit.blp")
        set thistype.GENERAL_DOODADS_0 = thistype.Create("Textures\\Doodads0.blp")
        set thistype.GENERAL_DOODADS_1 = thistype.Create("Textures\\Doodads1.blp")
        set thistype.GLACIER = thistype.Create("Textures\\Ice_Natural01.blp")
        set thistype.ICE_CROWN_0 = thistype.Create("Textures\\IceCrownDoodads0.blp")
        set thistype.ICE_CROWN_1 = thistype.Create("Textures\\IceCrownDoodads1.blp")
        set thistype.ICE_CROWN_WALLS = thistype.Create("Textures\\IceCrownWalls.blp")
        set thistype.ICE_FLOE = thistype.Create("Textures\\NorthrendNatural03.blp")
        set thistype.IGLOO = thistype.Create("Textures\\IceCrownDoodads1.blp")
        set thistype.MONK_STATUE = thistype.Create("Textures\\DarkPortal03.blp")
        set thistype.OBSTACLE = thistype.Create("Textures\\OutlandDoodads.blp")
        set thistype.RUBBLE = thistype.Create("doodads\\Icecrown\\Structures\\Icecrown_Rubble\\Ice_Strucures.blp")
        set thistype.RUBBLE_ASHEN = thistype.Create("Textures\\AshenStructures.blp")
        set thistype.RUINS_TRASH = thistype.Create("Textures\\RuinsDoodads1.blp")
        set thistype.TAVERN_SIGN = thistype.Create("Textures\\CityBuildingsNew.blp")
        set thistype.TOWER_SCORCHED = thistype.Create("Textures\\VillageDoodad1.blp")
        set thistype.TREE = thistype.Create("ReplaceableTextures\\AshenvaleTree\\AshenTree.blp")
        set thistype.TREE11 = thistype.Create("ReplaceableTextures\\LordaeronTree\\LordaeronSnowTree.blp")
        set thistype.WALL = thistype.Create("Doodads\\Wall\\Wall.blp")
        set thistype.WATERFALL = thistype.Create("Doodads\\Waterfall\\Waterfall.blp")

        //Items
        set thistype.GENERAL_ITEM = thistype.Create("objects\\InventoryItems\\treasurechest\\treasurechest.blp")
        set thistype.SPELL_ITEM = thistype.Create("objects\\InventoryItems\\tome\\tome.blp")

        //Spells
        set thistype.LAPIDATION = thistype.Create("abilities\\Weapons\\RockBoltMissile\\rocktile.blp")
        set thistype.MANA_LASER = thistype.Create("Textures\\banshee.blp")
        set thistype.SEVERANCE = thistype.Create("Textures\\Ghost2.blp")

        //Units
            set thistype.PENGUIN = thistype.Create("units\\Critters\\Penguin\\Pengo.blp")

            //Heroes
            set thistype.ARURUW = thistype.Create("units\\NightElf\\HeroMoonPriestess\\PriestessOfTheMoon.blp")
            set thistype.DRAKUL = thistype.Create("units\\Undead\\HeroDreadLord\\HeroDreadlord.blp")
            set thistype.LIZZY = thistype.Create("units\\Human\\Jaina\\Jaina.blp")
            set thistype.ROCKETEYE = thistype.Create("ReplaceableTextures\\HeroMountainKing\\heromountainking.blp")
            set thistype.ROCKETEYE_AVATAR = thistype.Create("ReplaceableTextures\\HeroMountainKing\\heromountainkingAvatar.blp")
            set thistype.SMOKEALOT = thistype.Create("units\\Undead\\HeroDeathKnight\\HeroDeathknight.blp")
            set thistype.STORMY = thistype.Create("units\\Creeps\\PandarenBrewmaster\\PandarenBrewMaster.blp")
            set thistype.TAJRAN = thistype.Create("units\\Orc\\Thrall\\Thrall.blp")

            //Missiles
            set thistype.ARROW_MISSILE = thistype.Create("Textures\\ArrowMissile.blp")
            set thistype.AXE_MISSILE = thistype.Create("abilities\\Weapons\\Axe\\TrollPink.blp")
            set thistype.FLYING_PENGUIN_MISSILE = thistype.Create("Textures\\gyrocopter.blp")

            //Spawns
                //Act1
                set thistype.DEER = thistype.Create("units\\Critters\\BlackStagMale\\BlackStag.blp")
                set thistype.FURBOLG_ORACLE = thistype.Create("units\\Creeps\\FurbolgTracker\\FurbolgTracker.blp")
                set thistype.MOONKIN = thistype.Create("units\\Creeps\\Owlbear\\HeroForceOfNature.blp")
                set thistype.SATYR = thistype.Create("units\\Creeps\\SatyrTrickster\\SatyrTrickster.blp")
                set thistype.SNOW_FALCON = thistype.Create("units\\Creeps\\WarEagle\\WarEagle.blp")
                set thistype.TROLL = thistype.Create("units\\Creeps\\IceTroll\\IceTroll.blp")
                set thistype.TROLL_PRIEST = thistype.Create("units\\Creeps\\IceTrollShadowPriest\\IceTrollShadowPriest.blp")
                set thistype.WOLF = thistype.Create("units\\Creeps\\WhiteWolf\\WhiteWolf.blp")

                //Act2
                set thistype.ASSASSIN = thistype.Create("Units\\Spawns\\Act2\\Assassin\\Assassin.blp")
                set thistype.AXE_FIGHTER = thistype.Create("units\\Orc\\Grunt\\Grunt.blp")
                set thistype.BALDUIR = thistype.Create("Textures\\BeastMaster.blp")
                set thistype.CATAPULT = thistype.Create("Textures\\Catapult.blp")
                set thistype.DEMOLISHER = thistype.Create("Textures\\Demolisher.blp")
                set thistype.DRUMMER = thistype.Create("Textures\\KotoBeast.blp")
                set thistype.LEADER = thistype.Create("units\\Demon\\ChaosWarlord\\ChaosWarlord.blp")
                set thistype.NAGAROSH = thistype.Create("units\\Orc\\HeroFarseer\\HeroFarseer.blp")
                set thistype.PEON = thistype.Create("units\\Orc\\Peon\\peon.blp")
                set thistype.RAIDER = thistype.Create("units\\Orc\\Wolfrider\\Wolfrider.blp")
                set thistype.SPEAR_SCOUT = thistype.Create("Textures\\WyvernRider.blp")
                set thistype.TAROG = thistype.Create("units\\Creeps\\ChaosWarlockGreen\\ChaosGreenWarlock.blp")
                set thistype.TRUE_LEADER = thistype.Create("units\\Other\\Proudmoore\\Proudmoore.blp")

            //Summons
            set thistype.POLAR_BEAR = thistype.Create("units\\Creeps\\PolarBear\\PolarBear.blp")
            set thistype.SERPENT_WARD = thistype.Create("units\\Orc\\SerpentWard\\SnakeWard_Red.blp")
            set thistype.SPIRIT_WOLF = thistype.Create("units\\Orc\\Spiritwolf\\FeralSpirit.blp")
            set thistype.TRAP_MINE = thistype.Create("Textures\\GoblinAmmoDump.blp")

            //Other
            set thistype.FOUNTAIN = thistype.Create("Textures\\FountainOfLife.blp")
            set thistype.FOUNTAIN_BLOOD = thistype.Create("buildings\\Other\\FountainOfLifeBlood\\FountainOfLifeBlood.blp")
            set thistype.MARKET = thistype.Create("buildings\\Other\\MarketPlace\\MarketPlace.blp")
            set thistype.METEORITE = thistype.Create("buildings\\Other\\SacrificialAltar\\SacrificialAltar.blp")
            set thistype.ROSA = thistype.Create("units\\Human\\Sorceress\\Sorceress.blp")
            set thistype.SEBASTIAN = thistype.Create("Textures\\Priest.blp")
            set thistype.STUFF = thistype.Create("Textures\\Goblinmerchant.blp")
            set thistype.STUFF2 = thistype.Create("Textures\\Goblinmerchant1.blp")
            set thistype.TAVERN = thistype.Create("buildings\\Other\\Tavern\\Tavern.blp")
            set thistype.TOWER = thistype.Create("Units\\Other\\Tower\\Tower.blp")

        //Other
        set thistype.ACOLYTE = thistype.Create("Textures\\Acolyte.blp")
        set thistype.ALCHEMIST_BLUE = thistype.Create("Textures\\HeroGoblinAlchemistBLUE.blp")
        set thistype.ARCANE_VAULT = thistype.Create("buildings\\Human\\ArcaneVault\\ArcaneVault.blp")
        set thistype.ARTHAS = thistype.Create("Textures\\Arthas.blp")
        set thistype.ARTHAS_CLOAK_CREDITS = thistype.Create("doodads\\Cinematic\\RockinArthas\\ArthasCloakCredits.blp")
        set thistype.ARTHAS2 = thistype.Create("Textures\\Arthas1.blp")
        set thistype.AXE_BLADE_BLUE_STEEL = thistype.Create("Textures\\AxeBladeBlueSteel.blp")
        set thistype.BACKGROUND = thistype.Create("Textures\\BackGround.blp")
        set thistype.BLADE_MASTER = thistype.Create("Textures\\HeroBladeMaster.blp")
        set thistype.BLOOD_PRIEST = thistype.Create("Textures\\BloodPriest.blp")
        set thistype.BLOOD_SPLASH = thistype.Create("Textures\\BloodSplash.blp")
        set thistype.BLOOD_SPLUT = thistype.Create("Textures\\BloodSplut.blp")
        set thistype.BLOOD_WHITE_SMALL = thistype.Create("Textures\\BloodWhiteSmall.blp")
        set thistype.BLUE_GLOW2 = thistype.Create("Textures\\Blue_Glow2.blp")
        set thistype.BLUE_SQ_GLOW = thistype.Create("Textures\\BlueSqGlow.blp")
        set thistype.CARTOON_CLOUD = thistype.Create("Textures\\CartoonCloud.blp")
        set thistype.CHAOS_RAIDER = thistype.Create("Units\\Demon\\ChaosWolfrider\\ChaosWolfrider.blp")
        set thistype.CLIFF_0 = thistype.Create("ReplaceableTextures\\Cliff\\Cliff0.blp")
        set thistype.CLOUD_SINGLE = thistype.Create("Textures\\CloudSingle.blp")
        set thistype.CLOUDS_8X8 = thistype.Create("Textures\\Clouds8x8.blp")
        set thistype.CLOUDS_8X8_FADE = thistype.Create("Textures\\Clouds8x8Fade.blp")
        set thistype.CLOUDS_8X8_FIRE = thistype.Create("Textures\\Clouds8x8Fire.blp")
        set thistype.CLOUDS_8X8_GREY = thistype.Create("Textures\\Clouds8x8Grey.blp")
        set thistype.CLOUDS_8X8_MOD_FIRE = thistype.Create("Textures\\Clouds8x8ModFire.blp")
        set thistype.DEATH_SCREAM = thistype.Create("Textures\\DeathScream.blp")
        set thistype.DEATH_SMUG = thistype.Create("Textures\\DeathSmug.blp")
        set thistype.DUST_A = thistype.Create("units\\Demon\\ChaosWarlord\\Dust1_A.blp")
        set thistype.DUST3 = thistype.Create("Textures\\Dust3.blp")
        set thistype.DUST_3X = thistype.Create("Textures\\Dust3x.blp")
        set thistype.DUST_5A = thistype.Create("Textures\\Dust5A.blp")
        set thistype.DUST_5A_BLACK = thistype.Create("Textures\\Dust5ABlack.blp")
        set thistype.DUST_6_COLOR = thistype.Create("abilities\\Weapons\\FireBallMissile\\Dust6Color.blp")
        set thistype.DUST_6_COLOR_RED = thistype.Create("abilities\\Weapons\\FireBallMissile\\Dust6ColorRed.blp")
        set thistype.DUST6 = thistype.Create("Textures\\Dust6.blp")
        set thistype.E_SMOKE_ANIM256 = thistype.Create("Textures\\E_Smoke_Anim256.blp")
        set thistype.ENERGY = thistype.Create("Textures\\Energy1.blp")
        set thistype.ENSNARE = thistype.Create("Textures\\ensnare.blp")
        set thistype.FACELESS_ONE = thistype.Create("Units\\Creeps\\FacelessOne\\FacelessOne.blp")
        set thistype.FIRE_RING_1A = thistype.Create("Textures\\firering1A.blp")
        set thistype.FIRE_RING4 = thistype.Create("Textures\\firering4.blp")
        set thistype.FLAME_4 = thistype.Create("Textures\\Flame4.blp")
        set thistype.FLARE = thistype.Create("Textures\\Flare.blp")
        set thistype.FLARE_BLOOD = thistype.Create("buildings\\Other\\FountainOfLifeBlood\\FlareBlood.blp")
        set thistype.FROST2 = thistype.Create("Textures\\Frost2.blp")
        set thistype.FROST3 = thistype.Create("Textures\\Frost3.blp")
        set thistype.FUR_BOOTS2 = thistype.Create("Textures\\furboots2.blp")
        set thistype.GENERIC_CLOUD_FADED = thistype.Create("Textures\\GenericGlowFaded.blp")
        set thistype.GENERIC_GLOW = thistype.Create("Textures\\GenericGlow1.blp")
        set thistype.GENERIC_GLOW_2B = thistype.Create("Textures\\GenericGlow2b.blp")
        set thistype.GENERIC_GLOW_64 = thistype.Create("Textures\\GenericGlow64.blp")
        set thistype.GHOST_1 = thistype.Create("Textures\\Ghost1.blp")
        set thistype.GOBLIN = thistype.Create("buildings\\Other\\Merchant\\Goblin.blp")
        set thistype.GRAD3 = thistype.Create("Textures\\grad3.blp")
        set thistype.GREEN_GLOW2 = thistype.Create("Textures\\Green_Glow2.blp")
        set thistype.GUTZ = thistype.Create("Textures\\gutz.blp")
        set thistype.HAIR_02_09 = thistype.Create("Textures\\Hair02_09.blp")
        set thistype.HANDLE_RED_WRAPPED = thistype.Create("Textures\\AnyHandleRedWrapped.blp")
        set thistype.HEAD_HUNTER = thistype.Create("Textures\\Headhunter.blp")
        set thistype.ICE = thistype.Create("Textures\\Ice.blp")
        set thistype.ICE_3B = thistype.Create("Textures\\Ice3b.blp")
        set thistype.LAVA_LUMP = thistype.Create("Textures\\LavaLump.blp")
        set thistype.LAVA_LUMP2 = thistype.Create("Textures\\LavaLump2.blp")
        set thistype.LENS_FLARE_1A = thistype.Create("Textures\\lensflare1A.blp")
        set thistype.LICH = thistype.Create("Textures\\HeroLich.blp")
        set thistype.LIGHTNING_BALL = thistype.Create("Textures\\LightningBall.blp")
        set thistype.MAIL_C_PADS = thistype.Create("Textures\\Mail_CPads.blp")
        set thistype.ORC_BARRACKS = thistype.Create("Textures\\OrcBarraks.blp")
        set thistype.PURPLE_GLOW = thistype.Create("Textures\\Purple_Glow.blp")
        set thistype.PURPLE_GLOW_DIM = thistype.Create("Textures\\Purple_Glow_Dim.blp")
        set thistype.RAIN_TAIL = thistype.Create("Textures\\rainTail.blp")
        set thistype.RED_GLOW2 = thistype.Create("Textures\\Red_Glow2.blp")
        set thistype.RED_GLOW3 = thistype.Create("Textures\\Red_Glow3.blp")
        set thistype.RED_STAR3 = thistype.Create("Textures\\Red_star3.blp")
        set thistype.RIBBON_BLUR = thistype.Create("Textures\\RibbonBlur1.blp")
        set thistype.RIBBON_MAGIC = thistype.Create("abilities\\Weapons\\PhoenixMissile\\RibbonMagic1.blp")
        set thistype.RIBBON_NE_RED2 = thistype.Create("Textures\\RibbonNE1_Red2.blp")
        set thistype.ROCK_PARTICLE = thistype.Create("Textures\\RockParticle.blp")
        set thistype.ROCK64 = thistype.Create("Textures\\rock64.blp")
        set thistype.SACRIFICIAL_ALTAR_SKULL = thistype.Create("Textures\\SacrificialAltarskull1.blp")
        set thistype.SHADOW = thistype.Create("Textures\\Shadow.blp")
        set thistype.SHIELD_ROUND_A_01_BLACK = thistype.Create("Textures\\Shield_Round_A_01Black.blp")
        set thistype.SHOCKWAVE = thistype.Create("Textures\\Shockwave1.blp")
        set thistype.SHOCKWAVE_4_WHITE = thistype.Create("Textures\\Shockwave4white.blp")
        set thistype.SHOCKWAVE_B = thistype.Create("Textures\\Shockwave1b.blp")
        set thistype.SHOCKWAVE_WATER = thistype.Create("Textures\\ShockwaveWater1.blp")
        set thistype.SHOCKWAVE_ICE = thistype.Create("Textures\\Shockwave_Ice1.blp")
        set thistype.SHOCKWAVE10 = thistype.Create("Textures\\Shockwave10.blp")
        set thistype.SHOULDER_PLATE_D2_ARTHAS = thistype.Create("Textures\\Shoulder_Plate_D2Arthas1.blp")
        set thistype.SMOKE = thistype.Create("Textures\\Smoke.blp")
        set thistype.SNOWFLAKE = thistype.Create("Textures\\snowflake.blp")
        set thistype.SNOWFLAKE2 = thistype.Create("Textures\\snowflake2.blp")
        set thistype.SPINNING_BOARD = thistype.Create("Textures\\SpinningBoard.blp")
        set thistype.STAR_8B = thistype.Create("Textures\\Star8b.blp")
        set thistype.STAR2_32 = thistype.Create("Textures\\star2_32.blp")
        set thistype.STAR32 = thistype.Create("Textures\\star32.blp")
        set thistype.STAR4 = thistype.Create("Textures\\star4.blp")
        set thistype.STAR4_32 = thistype.Create("Textures\\star4_32.blp")
        set thistype.TAUREN = thistype.Create("units\\Orc\\Tauren\\Minotaur.blp")
        set thistype.TEAM_COLOR_00 = thistype.Create("ReplaceableTextures\\TeamColor\\TeamColor00.blp")
        set thistype.TEAM_GLOW_00 = thistype.Create("ReplaceableTextures\\TeamGlow\\TeamGlow00.blp")
        set thistype.TOON_SMOKE_X = thistype.Create("Objects\\Spawnmodels\\Other\\ToonBoom\\ToonSmokeX.blp")
        set thistype.WARDS = thistype.Create("Textures\\Wards1.blp")
        set thistype.WATER_BLOBS = thistype.Create("Textures\\WaterBlobs1.blp")
        set thistype.WATER_WAKE2 = thistype.Create("Textures\\WaterWake2.blp")
        set thistype.WATER_WAKE3 = thistype.Create("Textures\\WaterWake3.blp")
        set thistype.WHITE_64_FOAM = thistype.Create("Textures\\White_64_Foam1.blp")
        set thistype.YELLOW_GLOW = thistype.Create("Textures\\Yellow_Glow.blp")
        set thistype.YELLOW_GLOW_DIM = thistype.Create("Textures\\Yellow_Glow_Dim.blp")
        set thistype.YELLOW_GLOW2 = thistype.Create("Textures\\Yellow_Glow2.blp")
        set thistype.YELLOW_GLOW3 = thistype.Create("Textures\\Yellow_Glow3.blp")
        set thistype.YELLOW_STAR = thistype.Create("Textures\\Yellow_Star.blp")
        set thistype.YELLOW_STAR_DIM = thistype.Create("Textures\\Yellow_Star_Dim.blp")
        set thistype.ZAP = thistype.Create("Textures\\Zap1.blp")
        set thistype.ZAP_RED = thistype.Create("Textures\\Zap1_Red.blp")

        call Game.DebugMsg("texture")
    endmethod

    static method Init takes nothing returns nothing
        call Code.Run(function thistype.Init_Executed)
    endmethod
endstruct

//! runtextmacro BaseStruct("UberSplat", "UBER_SPLAT")
    static thistype DEATH_HUMAN_LARGE_BUILDING
    static thistype HUMAN_CRATER

    string self

    method Preload takes nothing returns nothing
        call Preload_Wrapped(this.self)
    endmethod

    static method Create takes string self returns thistype
        local thistype this = thistype.allocate()

        set this.self = self

        call this.Preload()

        return this
    endmethod

    static method Init_Executed takes nothing returns nothing
        set thistype.DEATH_HUMAN_LARGE_BUILDING = thistype.Create("ReplaceableTextures\\Splats\\ScorchedUberSplat.blp")
        set thistype.HUMAN_CRATER = thistype.Create("ReplaceableTextures\\Splats\\CraterUberSplat.blp")
    endmethod

    static method Init takes nothing returns nothing
        call Code.Run(function thistype.Init_Executed)
    endmethod
endstruct

//! runtextmacro BaseStruct("SpawnModel", "SPAWN_MODEL")
    //! runtextmacro GetKeyArray("BLOOD_SPLATS_KEY_ARRAY")
    //! runtextmacro GetKeyArray("FOOT_PRINTS_KEY_ARRAY")
    //! runtextmacro GetKeyArray("MODELS_KEY_ARRAY")
    //! runtextmacro GetKeyArray("PARENT_KEY_ARRAY")
    //! runtextmacro GetKeyArray("SOUNDS_KEY_ARRAY")
    //! runtextmacro GetKeyArray("TEXTURES_KEY_ARRAY")
    //! runtextmacro GetKeyArray("UBER_SPLATS_KEY_ARRAY")

    static thistype NEUTRAL_BUILDING_EXPLOSION
    static thistype NIGHT_ELF_BLOOD_PRIESTESS
    static thistype ORC_BLOOD_FARSEER
    static thistype PANDAREN_BREWMASTER_EXPLOSION
    static thistype TOON_BOOM
    static thistype UNDEAD_DISSIPATE

    string self

    method AddBloodSplat takes BloodSplat whichBloodSplat returns nothing
        call Memory.IntegerKeys.Table.AddInteger(PARENT_KEY_ARRAY + this, BLOOD_SPLATS_KEY_ARRAY, whichBloodSplat)
    endmethod

    method AddFootPrint takes FootPrint whichFootPrint returns nothing
        call Memory.IntegerKeys.Table.AddInteger(PARENT_KEY_ARRAY + this, FOOT_PRINTS_KEY_ARRAY, whichFootPrint)
    endmethod

    method AddSound takes SoundSet whichSound returns nothing
        call Memory.IntegerKeys.Table.AddInteger(PARENT_KEY_ARRAY + this, SOUNDS_KEY_ARRAY, whichSound)
    endmethod

    method AddSpawnModel takes SpawnModel whichModel returns nothing
        call Memory.IntegerKeys.Table.AddInteger(PARENT_KEY_ARRAY + this, MODELS_KEY_ARRAY, whichModel)
    endmethod

    method AddTexture takes Texture whichTexture returns nothing
        call Memory.IntegerKeys.Table.AddInteger(PARENT_KEY_ARRAY + this, TEXTURES_KEY_ARRAY, whichTexture)
    endmethod

    method AddUberSplat takes UberSplat whichUberSplat returns nothing
        call Memory.IntegerKeys.Table.AddInteger(PARENT_KEY_ARRAY + this, UBER_SPLATS_KEY_ARRAY, whichUberSplat)
    endmethod

    method Preload takes nothing returns nothing
        call Preload_Wrapped(this.self)
    endmethod

    static method Create takes string self returns thistype
        local thistype this = thistype.allocate()

        set this.self = self

        call this.Preload()

        return this
    endmethod

    static method Init_Executed takes nothing returns nothing
        local thistype this

        set this = thistype.Create("Objects\\Spawnmodels\\Other\\NeutralBuildingExplosion\\NeutralBuildingExplosion.mdl")
        set thistype.NEUTRAL_BUILDING_EXPLOSION = this
        call this.AddSound(SoundSet.DEATH_HUMAN_LARGE_BUILDING)
        call this.AddUberSplat(UberSplat.DEATH_HUMAN_LARGE_BUILDING)
        call this.AddTexture(Texture.CARTOON_CLOUD)
        call this.AddTexture(Texture.CLOUDS_8X8)
        call this.AddTexture(Texture.DUST_3X)
        call this.AddTexture(Texture.DUST_5A)

        set this = thistype.Create("Objects\\Spawnmodels\\NightElf\\NightElfBlood\\NightElfBloodHeroMoonPriestess.mdl")
        set thistype.NIGHT_ELF_BLOOD_PRIESTESS = this
        call this.AddTexture(Texture.BLOOD_WHITE_SMALL)

        set this = thistype.Create("Objects\\Spawnmodels\\Orc\\Orcblood\\OrcBloodHeroFarSeer.mdl")
        set thistype.ORC_BLOOD_FARSEER = this
        call this.AddTexture(Texture.BLOOD_WHITE_SMALL)

        set this = thistype.Create("Objects\\Spawnmodels\\Other\\PandarenBrewmasterExplosionUltimate\\PandarenBrewmasterExplosionUltimate.mdl")
        set thistype.PANDAREN_BREWMASTER_EXPLOSION = this
        call this.AddTexture(Texture.CLOUDS_8X8)
        call this.AddTexture(Texture.YELLOW_STAR)

        set this = thistype.Create("Objects\\Spawnmodels\\Other\\ToonBoom\\ToonBoom.mdl")
        set thistype.TOON_BOOM = this
        call this.AddTexture(Texture.STAR4_32)
        call this.AddTexture(Texture.TOON_SMOKE_X)

        set this = thistype.Create("Objects\\Spawnmodels\\Undead\\UndeadDissipate\\UndeadDissipate.mdl")
        set thistype.UNDEAD_DISSIPATE = this
        call this.AddSound(SoundSet.UNDEAD_DISSIPATE)
        call this.AddTexture(Texture.CLOUDS_8X8_FADE)
        call this.AddTexture(Texture.DUST3)
        call this.AddTexture(Texture.GHOST_1)
    endmethod

    static method Init takes nothing returns nothing
        call Code.Run(function thistype.Init_Executed)
    endmethod
endstruct

//! runtextmacro BaseStruct("Model", "MODEL")
    //! runtextmacro GetKeyArray("BLOOD_SPLATS_KEY_ARRAY")
    //! runtextmacro GetKeyArray("FOOT_PRINTS_KEY_ARRAY")
    //! runtextmacro GetKeyArray("MODELS_KEY_ARRAY")
    //! runtextmacro GetKeyArray("PARENT_KEY_ARRAY")
    //! runtextmacro GetKeyArray("SOUNDS_KEY_ARRAY")
    //! runtextmacro GetKeyArray("TEXTURES_KEY_ARRAY")
    //! runtextmacro GetKeyArray("UBER_SPLATS_KEY_ARRAY")

    //Destructables
    static thistype EXPLOSIVE
    static thistype KEG

    //Doodads
    static thistype ARCHWAY
    static thistype ARCHWAY_STONE
    static thistype BARREL
    static thistype BARRICADE
    static thistype BARRICADE2
    static thistype BONES
    static thistype BOULDER
    static thistype BOULDER2
    static thistype BOULDER3
    static thistype BOULDER4
    static thistype BOULDER5
    static thistype BOULDER6
    static thistype BRAZIER
    static thistype BROKEN_COLUMN
    static thistype BROKEN_COLUMN2
    static thistype CHAIR
    static thistype COLD_AIR
    static thistype CRATES
    static thistype CRATES2
    static thistype CRATES3
    static thistype CRYSTAL
    static thistype CRYSTAL2
    static thistype CRYSTAL3
    static thistype CRYSTAL4
    static thistype CRYSTAL5
    static thistype CRYSTAL6
    static thistype CRYSTAL7
    static thistype CRYSTAL8
    static thistype CRYSTAL9
    static thistype DARKNESS
    static thistype DEAD_TREE
    static thistype DEAD_TREE2
    static thistype DEAD_TREE3
    static thistype DEAD_TREE4
    static thistype DEAD_TREE5
    static thistype DEAD_TREE6
    static thistype DEAD_TREE7
    static thistype DEAD_TREE8
    static thistype DEAD_TREE9
    static thistype DEAD_TREE10
    static thistype ENERGY_BARRIER
    static thistype FENCE
    static thistype FIRE_PIT_OFF
    static thistype FIRE_PIT_ON
    static thistype GLACIER
    static thistype GLACIER2
    static thistype GLACIER3
    static thistype GLACIER4
    static thistype GLACIER5
    static thistype GLACIER6
    static thistype GLACIER7
    static thistype GLACIER8
    static thistype GLACIER9
    static thistype GLACIER10
    static thistype ICE_EDGE
    static thistype ICE_EDGE2
    static thistype ICE_EDGE3
    static thistype ICE_EDGE4
    static thistype ICE_FLOE
    static thistype ICE_LINE_VERTICAL
    static thistype IGLOO
    static thistype JUNK_PILE
    static thistype JUNK_PILE2
    static thistype KNIGHT_STATUE
    static thistype MONK_STATUE
    static thistype OBELISK
    static thistype OBELISK2
    static thistype OBELISK3
    static thistype OBSTACLE
    static thistype OBSTACLE2
    static thistype OBSTACLE3
    static thistype OBSTACLE4
    static thistype OBSTACLE5
    static thistype PILLAR
    static thistype PILLAR_TRANSPARENT
    static thistype PILLAR2
    static thistype PILLAR3
    static thistype ROCK
    static thistype ROCK2
    static thistype ROCK3
    static thistype ROCK4
    static thistype ROCK5
    static thistype ROCK6
    static thistype ROCK7
    static thistype ROCK8
    static thistype ROCKIN_ARTHAS
    static thistype RUBBLE
    static thistype RUBBLE2
    static thistype RUBBLE3
    static thistype RUBBLE_ASHEN
    static thistype RUBBLE_ASHEN2
    static thistype RUBBLE_ASHEN3
    static thistype RUINS_TRASH
    static thistype RUINS_TRASH2
    static thistype SIGN_POST
    static thistype SKULL_TORCH
    static thistype SNOW_ROCK
    static thistype SNOW_ROCK2
    static thistype SNOW_ROCK3
    static thistype SNOW_ROCK4
    static thistype SNOW_ROCK5
    static thistype SNOW_ROCK6
    static thistype SNOW_ROCK7
    static thistype SNOW_ROCK8
    static thistype SNOW_ROCK9
    static thistype SNOW_ROCK10
    static thistype SPIDER_STATUE
    static thistype SPIDER_STATUE2
    static thistype STAIR_STEP
    static thistype TAVERN_SIGN
    static thistype TOWER_SCORCHED
    static thistype TREASURE_PILE
    static thistype TREASURE_PILE2
    static thistype TREE
    static thistype TREE2
    static thistype TREE3
    static thistype TREE4
    static thistype TREE5
    static thistype TREE6
    static thistype TREE7
    static thistype TREE8
    static thistype TREE9
    static thistype TREE10
    static thistype TREE11
    static thistype WALL
    static thistype WALL_END
    static thistype WALL_TRANSPARENT
    static thistype WATERFALL

    //Items
    static thistype GENERAL_ITEM
    static thistype SPELL_ITEM

    //Spells
    static thistype CHILLY_BREATH
    static thistype CLEAVAGE
    static thistype CREATE_MANA_POTION
    static thistype FIREBALL
    static thistype FROZEN_STAR
    static thistype LAPIDATION
    static thistype MANA_LASER
    static thistype SEVERANCE
    static thistype SLEEPING_DRAFT
    static thistype SNOWY_SPHERE
    static thistype SNOWY_SPHERE_PARTICLE
    static thistype STORMBOLT

    //Units
        //Heroes
        static thistype ARURUW
        static thistype DRAKUL
        static thistype DRUMMER
        static thistype LIZZY
        static thistype ROCKETEYE
        static thistype SMOKEALOT
        static thistype STORMY
        static thistype TAJRAN

        //Missiles
            static thistype ARURUW_MISSILE
            static thistype AXE_MISSILE
            static thistype CATAPULT_MISSILE
            static thistype DEMOLISHER_MISSILE
            static thistype FIREBALL_MISSILE
            static thistype FLYING_PENGUIN_MISSILE
            static thistype LIGHTING_BOLT_MISSILE
            static thistype SATYR_MISSILE
            static thistype SERPENT_WARD_MISSILE
            static thistype SNOW_FALCON_MISSILE
            static thistype SPEAR_SCOUT_MISSILE
            static thistype TROLL_PRIEST_MISSILE

        //Spawns
            static thistype PENGUIN

            //Act1
            static thistype DEER
            static thistype FURBOLG_ORACLE
            static thistype MOONKIN
            static thistype SATYR
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
            static thistype LEADER
            static thistype NAGAROSH
            static thistype PEON
            static thistype RAIDER
            static thistype SPEAR_SCOUT
            static thistype TAROG
            static thistype TRUE_LEADER

        //Summons
        static thistype BARRIER
        static thistype GHOST_SWORD
        static thistype POLAR_BEAR
        static thistype SERPENT_WARD
        static thistype SPIRIT_WOLF
        static thistype TRAP_MINE

        //Other
        static thistype FOUNTAIN
        static thistype MARKET
        static thistype METEORITE
        static thistype ROSA
        static thistype SEBASTIAN
        static thistype SNOWMAN
        static thistype STUFF
        static thistype TAVERN
        static thistype TOWER

    //Other
    static thistype EFFECT_SIZER
    static thistype FIRE_TAIL
    static thistype HERO_REVIVAL
    static thistype LARGE_FIRE
    static thistype LARGE_FIRE2
    static thistype LARGE_FIRE3
    static thistype SMALL_FIRE
    static thistype SMALL_FIRE2
    static thistype SMALL_FIRE3

    string self

    method AddBloodSplat takes BloodSplat whichBloodSplat returns nothing
        call Memory.IntegerKeys.Table.AddInteger(PARENT_KEY_ARRAY + this, BLOOD_SPLATS_KEY_ARRAY, whichBloodSplat)
    endmethod

    method AddFootPrint takes FootPrint whichFootPrint returns nothing
        call Memory.IntegerKeys.Table.AddInteger(PARENT_KEY_ARRAY + this, FOOT_PRINTS_KEY_ARRAY, whichFootPrint)
    endmethod

    method AddSound takes SoundSet whichSound returns nothing
        call Memory.IntegerKeys.Table.AddInteger(PARENT_KEY_ARRAY + this, SOUNDS_KEY_ARRAY, whichSound)
    endmethod

    method AddSpawnModel takes SpawnModel whichModel returns nothing
        call Memory.IntegerKeys.Table.AddInteger(PARENT_KEY_ARRAY + this, MODELS_KEY_ARRAY, whichModel)
    endmethod

    method AddTexture takes Texture whichTexture returns nothing
        call Memory.IntegerKeys.Table.AddInteger(PARENT_KEY_ARRAY + this, TEXTURES_KEY_ARRAY, whichTexture)
    endmethod

    method AddUberSplat takes UberSplat whichUberSplat returns nothing
        call Memory.IntegerKeys.Table.AddInteger(PARENT_KEY_ARRAY + this, UBER_SPLATS_KEY_ARRAY, whichUberSplat)
    endmethod

    method Preload takes nothing returns nothing
        call Preload_Wrapped(this.self)
    endmethod

    static method Create takes string self returns thistype
        local thistype this = thistype.allocate()

        set this.self = self

        call this.Preload()

        return this
    endmethod

    static method Init_Executed takes nothing returns nothing
        local thistype this

        call BloodSplat.Init()
        call FootPrint.Init()
        call SoundSet.Init()
        call Texture.Init()
        call UberSplat.Init()

        call SpawnModel.Init()

        //Destructables
        set this = thistype.Create("Units\\Other\\TNTBarrel\\TNTBarrel.mdx")
        set thistype.EXPLOSIVE = this
        call this.AddSpawnModel(SpawnModel.NEUTRAL_BUILDING_EXPLOSION)
        call this.AddTexture(Texture.CLOUDS_8X8)
        call this.AddTexture(Texture.DEATH_SMUG)
        call this.AddTexture(Texture.EXPLOSIVE)
        call this.AddTexture(Texture.GENERAL_DOODADS_0)
        call this.AddTexture(Texture.SPINNING_BOARD)

        set this = thistype.Create("Units\\Other\\Keg\\Keg.mdx")
        set thistype.KEG = this
        call this.AddSpawnModel(SpawnModel.NEUTRAL_BUILDING_EXPLOSION)
        call this.AddTexture(Texture.CLOUDS_8X8)
        call this.AddTexture(Texture.DEATH_SMUG)
        call this.AddTexture(Texture.EXPLOSIVE)
        call this.AddTexture(Texture.GENERAL_DOODADS_0)
        call this.AddTexture(Texture.SPINNING_BOARD)

        //Doodads
        set this = thistype.Create("Doodads\\Archway\\Archway.mdx")
        set thistype.ARCHWAY = this
        call this.AddTexture(Texture.ICE_CROWN_0)

        set this = thistype.Create("Doodads\\Underground\\Structures\\UndergroundArchway1\\UndergroundArchway1.mdx")
        set thistype.ARCHWAY_STONE = this
        call this.AddTexture(Texture.ARCHWAY_STONE)

        set this = thistype.Create("Buildings\\Other\\BarrelsUnit1\\BarrelsUnit1.mdx")
        set thistype.BARREL = this
        call this.AddTexture(Texture.CLOUDS_8X8)
        call this.AddTexture(Texture.DEATH_SMUG)
        call this.AddTexture(Texture.GENERAL_DOODADS_0)
        call this.AddTexture(Texture.SPINNING_BOARD)

        set this = thistype.Create("Doodads\\LordaeronSummer\\Terrain\\Barricade\\Barricade0.mdx")
        set thistype.BARRICADE = this
        call this.AddTexture(Texture.CLOUDS_8X8)
        call this.AddTexture(Texture.GENERAL_DOODADS_0)
        call this.AddTexture(Texture.SPINNING_BOARD)

        set thistype.BARRICADE2 = thistype.Create("Doodads\\LordaeronSummer\\Terrain\\Barricade\\Barricade1.mdx")
        call this.AddTexture(Texture.CLOUDS_8X8)
        call this.AddTexture(Texture.GENERAL_DOODADS_0)
        call this.AddTexture(Texture.SPINNING_BOARD)

        set this = thistype.Create("Doodads\\Northrend\\Props\\North_Bones\\North_Bones7.mdx")
        set thistype.BONES = this
        call this.AddTexture(Texture.BONES)

        set this = thistype.Create("Doodads\\LordaeronSummer\\Terrain\\LoardaeronRockChunks\\LoardaeronRockChunks0.mdx")
        set thistype.BOULDER = this
        call this.AddTexture(Texture.BOULDER)
        call this.AddTexture(Texture.CLOUDS_8X8)
        call this.AddTexture(Texture.ROCK_PARTICLE)

        set this = thistype.Create("Doodads\\LordaeronSummer\\Terrain\\LoardaeronRockChunks\\LoardaeronRockChunks1.mdx")
        set thistype.BOULDER2 = this
        call this.AddTexture(Texture.BOULDER)
        call this.AddTexture(Texture.CLOUDS_8X8)
        call this.AddTexture(Texture.ROCK_PARTICLE)

        set this = thistype.Create("Doodads\\LordaeronSummer\\Terrain\\LoardaeronRockChunks\\LoardaeronRockChunks2.mdx")
        set thistype.BOULDER3 = this
        call this.AddTexture(Texture.BOULDER)
        call this.AddTexture(Texture.CLOUDS_8X8)
        call this.AddTexture(Texture.ROCK_PARTICLE)

        set this = thistype.Create("Doodads\\LordaeronSummer\\Terrain\\LoardaeronRockChunks\\LoardaeronRockChunks3.mdx")
        set thistype.BOULDER4 = this
        call this.AddTexture(Texture.BOULDER)
        call this.AddTexture(Texture.CLOUDS_8X8)
        call this.AddTexture(Texture.ROCK_PARTICLE)

        set this = thistype.Create("Doodads\\LordaeronSummer\\Terrain\\LoardaeronRockChunks\\LoardaeronRockChunks4.mdx")
        set thistype.BOULDER5 = this
        call this.AddTexture(Texture.BOULDER)
        call this.AddTexture(Texture.CLOUDS_8X8)
        call this.AddTexture(Texture.ROCK_PARTICLE)

        set this = thistype.Create("Doodads\\LordaeronSummer\\Terrain\\LoardaeronRockChunks\\LoardaeronRockChunks5.mdx")
        set thistype.BOULDER6 = this
        call this.AddTexture(Texture.BOULDER)
        call this.AddTexture(Texture.CLOUDS_8X8)
        call this.AddTexture(Texture.ROCK_PARTICLE)

        set this = thistype.Create("Doodads\\LordaeronSummer\\Props\\brazieromni\\brazieromni.mdx")
        set thistype.BRAZIER = this
        call this.AddTexture(Texture.CLOUDS_8X8)
        call this.AddTexture(Texture.GENERAL_DOODADS_0)
        call this.AddTexture(Texture.SMOKE)

        set this = thistype.Create("Doodads\\Felwood\\Structures\\FelwoodBrokenColumn\\FelwoodBrokenColumn0.mdx")
        set thistype.BROKEN_COLUMN = this
        call this.AddTexture(Texture.BROKEN_COLUMN)

        set this = thistype.Create("Doodads\\Felwood\\Structures\\FelwoodBrokenColumn\\FelwoodBrokenColumn1.mdx")
        set thistype.BROKEN_COLUMN2 = this
        call this.AddTexture(Texture.BROKEN_COLUMN)

        set this = thistype.Create("Doodads\\Icecrown\\Props\\IcecrownChair\\IcecrownChair.mdx")
        set thistype.CHAIR = this
        call this.AddTexture(Texture.CHAIR)

        set this = thistype.Create("Doodads\\ColdAir\\ColdAir.mdx")
        set thistype.COLD_AIR = this
        call this.AddTexture(Texture.COLD_AIR)

        set this = thistype.Create("Doodads\\Cityscape\\Props\\EmptyCrates\\EmptyCrates0.mdx")
        set thistype.CRATES = this
        call this.AddTexture(Texture.GENERAL_DOODADS_0)

        set this = thistype.Create("Doodads\\Cityscape\\Props\\EmptyCrates\\EmptyCrates1.mdx")
        set thistype.CRATES2 = this
        call this.AddTexture(Texture.GENERAL_DOODADS_0)

        set this = thistype.Create("Doodads\\Cityscape\\Props\\EmptyCrates\\EmptyCrates3.mdx")
        set thistype.CRATES3 = this
        call this.AddTexture(Texture.GENERAL_DOODADS_0)

        set this = thistype.Create("Doodads\\Icecrown\\Rocks\\Icecrown_Crystal\\Icecrown_Crystal0.mdx")
        set thistype.CRYSTAL = this
        call this.AddTexture(Texture.CRYSTAL)

        set this = thistype.Create("Doodads\\Icecrown\\Rocks\\Icecrown_Crystal\\Icecrown_Crystal1.mdx")
        set thistype.CRYSTAL2 = this
        call this.AddTexture(Texture.CRYSTAL)

        set this = thistype.Create("Doodads\\Icecrown\\Rocks\\Icecrown_Crystal\\Icecrown_Crystal2.mdx")
        set thistype.CRYSTAL3 = this
        call this.AddTexture(Texture.CRYSTAL)

        set this = thistype.Create("Doodads\\Icecrown\\Rocks\\Icecrown_Crystal\\Icecrown_Crystal3.mdx")
        set thistype.CRYSTAL4 = this
        call this.AddTexture(Texture.CRYSTAL)

        set this = thistype.Create("Doodads\\Icecrown\\Rocks\\Icecrown_Crystal\\Icecrown_Crystal4.mdx")
        set thistype.CRYSTAL5 = this
        call this.AddTexture(Texture.CRYSTAL)

        set this = thistype.Create("Doodads\\Icecrown\\Rocks\\Icecrown_Crystal\\Icecrown_Crystal5.mdx")
        set thistype.CRYSTAL6 = this
        call this.AddTexture(Texture.CRYSTAL)

        set this = thistype.Create("Doodads\\Icecrown\\Rocks\\Icecrown_Crystal\\Icecrown_Crystal6.mdx")
        set thistype.CRYSTAL7 = this
        call this.AddTexture(Texture.CRYSTAL)

        set this = thistype.Create("Doodads\\Icecrown\\Rocks\\Icecrown_Crystal\\Icecrown_Crystal7.mdx")
        set thistype.CRYSTAL8 = this
        call this.AddTexture(Texture.CRYSTAL)

        set this = thistype.Create("Doodads\\Icecrown\\Rocks\\Icecrown_Crystal\\Icecrown_Crystal8.mdx")
        set thistype.CRYSTAL9 = this
        call this.AddTexture(Texture.CRYSTAL)

        set this = thistype.Create("Doodads\\Cinematic\\FootSwitch\\FootSwitch.mdx")
        set thistype.DARKNESS = this
        call this.AddTexture(Texture.CLIFF_0)
        call this.AddTexture(Texture.BLUE_SQ_GLOW)
        call this.AddTexture(Texture.LIGHTNING_BALL)

        set this = thistype.Create("Doodads\\Terrain\\NorthrendTree\\NorthrendTree0.mdx")
        set thistype.DEAD_TREE = this
        call this.AddTexture(Texture.DEAD_TREE)

        set this = thistype.Create("Doodads\\Terrain\\NorthrendTree\\NorthrendTree1.mdx")
        set thistype.DEAD_TREE2 = this
        call this.AddTexture(Texture.DEAD_TREE)

        set this = thistype.Create("Doodads\\Terrain\\NorthrendTree\\NorthrendTree2.mdx")
        set thistype.DEAD_TREE3 = this
        call this.AddTexture(Texture.DEAD_TREE)

        set this = thistype.Create("Doodads\\Terrain\\NorthrendTree\\NorthrendTree3.mdx")
        set thistype.DEAD_TREE4 = this
        call this.AddTexture(Texture.DEAD_TREE)

        set this = thistype.Create("Doodads\\Terrain\\NorthrendTree\\NorthrendTree4.mdx")
        set thistype.DEAD_TREE5 = this
        call this.AddTexture(Texture.DEAD_TREE)

        set this = thistype.Create("Doodads\\Terrain\\NorthrendTree\\NorthrendTree5.mdx")
        set thistype.DEAD_TREE6 = this
        call this.AddTexture(Texture.DEAD_TREE)

        set this = thistype.Create("Doodads\\Terrain\\NorthrendTree\\NorthrendTree6.mdx")
        set thistype.DEAD_TREE7 = this
        call this.AddTexture(Texture.DEAD_TREE)

        set this = thistype.Create("Doodads\\Terrain\\NorthrendTree\\NorthrendTree7.mdx")
        set thistype.DEAD_TREE8 = this
        call this.AddTexture(Texture.DEAD_TREE)

        set this = thistype.Create("Doodads\\Terrain\\NorthrendTree\\NorthrendTree8.mdx")
        set thistype.DEAD_TREE9 = this
        call this.AddTexture(Texture.DEAD_TREE)

        set this = thistype.Create("Doodads\\Terrain\\NorthrendTree\\NorthrendTree9.mdx")
        set thistype.DEAD_TREE10 = this
        call this.AddTexture(Texture.DEAD_TREE)

        set this = thistype.Create("Doodads\\Cinematic\\EnergyFieldWall\\EnergyFieldWall.mdx")
        set thistype.ENERGY_BARRIER = this
        call this.AddTexture(Texture.ENERGY_BARRIER)
        call this.AddTexture(Texture.FLAME_4)

        set this = thistype.Create("Doodads\\Northrend\\Props\\NorthrendFenceStraight\\NorthrendFenceStraight.mdx")
        set thistype.FENCE = this
        call this.AddTexture(Texture.FENCE)

        set this = thistype.Create("Doodads\\Northrend\\Props\\FirePitTrashed\\FirePitTrashed.mdx")
        set thistype.FIRE_PIT_OFF = this
        call this.AddTexture(Texture.FIRE_PIT)

        set this = thistype.Create("Doodads\\Northrend\\Props\\FirePit\\FirePit.mdx")
        set thistype.FIRE_PIT_ON = this
        call this.AddTexture(Texture.CLOUDS_8X8)
        call this.AddTexture(Texture.DUST_5A)
        call this.AddTexture(Texture.GENERAL_DOODADS_1)

        set this = thistype.Create("Doodads\\Icecrown\\Rocks\\Glacier\\Glacier0.mdx")
        set thistype.GLACIER = this
        call this.AddTexture(Texture.GLACIER)

        set this = thistype.Create("Doodads\\Icecrown\\Rocks\\Glacier\\Glacier1.mdx")
        set thistype.GLACIER2 = this
        call this.AddTexture(Texture.GLACIER)

        set this = thistype.Create("Doodads\\Icecrown\\Rocks\\Glacier\\Glacier2.mdx")
        set thistype.GLACIER3 = this
        call this.AddTexture(Texture.GLACIER)

        set this = thistype.Create("Doodads\\Icecrown\\Rocks\\Glacier\\Glacier3.mdx")
        set thistype.GLACIER4 = this
        call this.AddTexture(Texture.GLACIER)

        set this = thistype.Create("Doodads\\Icecrown\\Rocks\\Glacier\\Glacier4.mdx")
        set thistype.GLACIER5 = this
        call this.AddTexture(Texture.GLACIER)

        set this = thistype.Create("Doodads\\Icecrown\\Rocks\\Glacier\\Glacier5.mdx")
        set thistype.GLACIER6 = this
        call this.AddTexture(Texture.GLACIER)

        set this = thistype.Create("Doodads\\Icecrown\\Rocks\\Glacier\\Glacier6.mdx")
        set thistype.GLACIER7 = this
        call this.AddTexture(Texture.GLACIER)

        set this = thistype.Create("Doodads\\Icecrown\\Rocks\\Glacier\\Glacier7.mdx")
        set thistype.GLACIER8 = this
        call this.AddTexture(Texture.GLACIER)

        set this = thistype.Create("Doodads\\Icecrown\\Rocks\\Glacier\\Glacier8.mdx")
        set thistype.GLACIER9 = this
        call this.AddTexture(Texture.GLACIER)

        set this = thistype.Create("Doodads\\Icecrown\\Rocks\\Glacier\\Glacier9.mdx")
        set thistype.GLACIER10 = this
        call this.AddTexture(Texture.GLACIER)

        set this = thistype.Create("Doodads\\Icecrown\\Water\\IceEdge\\IceEdge0.mdx")
        set thistype.ICE_EDGE = this
        call this.AddTexture(Texture.ICE_CROWN_WALLS)

        set this = thistype.Create("Doodads\\Icecrown\\Water\\IceEdge\\IceEdge1.mdx")
        set thistype.ICE_EDGE2 = this
        call this.AddTexture(Texture.ICE_CROWN_WALLS)

        set this = thistype.Create("Doodads\\Icecrown\\Water\\IceEdge\\IceEdge2.mdx")
        set thistype.ICE_EDGE3 = this
        call this.AddTexture(Texture.ICE_CROWN_WALLS)

        set this = thistype.Create("Doodads\\Icecrown\\Water\\IceEdge\\IceEdge3.mdx")
        set thistype.ICE_EDGE4 = this
        call this.AddTexture(Texture.ICE_CROWN_WALLS)

        set this = thistype.Create("Doodads\\Northrend\\Water\\North_IceFloe3\\North_IceFloe3.mdx")
        set thistype.ICE_FLOE = this
        call this.AddTexture(Texture.ICE_FLOE)

        set this = thistype.Create("Doodads\\Icecrown\\Terrain\\IceGate\\IceGate.mdx")
        set thistype.ICE_LINE_VERTICAL = this
        call this.AddTexture(Texture.CLOUDS_8X8)
        call this.AddTexture(Texture.ICE_CROWN_WALLS)

        set this = thistype.Create("Doodads\\Icecrown\\Structures\\Igloo\\Igloo.mdx")
        set thistype.IGLOO = this
        call this.AddTexture(Texture.CARTOON_CLOUD)
        call this.AddTexture(Texture.CLOUDS_8X8_FIRE)
        call this.AddTexture(Texture.DUST_3X)
        call this.AddTexture(Texture.DUST_5A)
        call this.AddTexture(Texture.ROCK_PARTICLE)
        call this.AddTexture(Texture.TEAM_GLOW_00)

        set this = thistype.Create("Doodads\\Dungeon\\Props\\JunkPile\\JunkPile0.mdx")
        set thistype.JUNK_PILE = this
        call this.AddTexture(Texture.DUNGEON_0)

        set this = thistype.Create("Doodads\\Dungeon\\Props\\JunkPile\\JunkPile1.mdx")
        set thistype.JUNK_PILE2 = this
        call this.AddTexture(Texture.DUNGEON_0)

        set this = thistype.Create("Doodads\\Cityscape\\Props\\City_Statue\\City_Statue.mdx")
        set thistype.KNIGHT_STATUE = this
        call this.AddTexture(Texture.CITY)

        set this = thistype.Create("Doodads\\BlackCitadel\\Props\\BlackCitadelStatue\\BlackCitadelStatue.mdx")
        set thistype.MONK_STATUE = this
        call this.AddTexture(Texture.MONK_STATUE)

        set this = thistype.Create("Doodads\\Icecrown\\Props\\IceCrownObelisk\\IceCrownObelisk0.mdx")
        set thistype.OBELISK = this
        call this.AddTexture(Texture.ICE_CROWN_0)

        set this = thistype.Create("Doodads\\Icecrown\\Props\\IceCrownObelisk\\IceCrownObelisk1.mdx")
        set thistype.OBELISK2 = this
        call this.AddTexture(Texture.ICE_CROWN_1)

        set this = thistype.Create("Doodads\\Icecrown\\Props\\IceCrownObelisk\\IceCrownObelisk2.mdx")
        set thistype.OBELISK3 = this
        call this.AddTexture(Texture.ICE_CROWN_0)

        set this = thistype.Create("Doodads\\Outland\\Props\\Obstacle\\Obstacle0.mdx")
        set thistype.OBSTACLE = this
        call this.AddTexture(Texture.OBSTACLE)

        set this = thistype.Create("Doodads\\Outland\\Props\\Obstacle\\Obstacle1.mdx")
        set thistype.OBSTACLE2 = this
        call this.AddTexture(Texture.OBSTACLE)

        set this = thistype.Create("Doodads\\Outland\\Props\\Obstacle\\Obstacle2.mdx")
        set thistype.OBSTACLE3 = this
        call this.AddTexture(Texture.OBSTACLE)

        set this = thistype.Create("Doodads\\Outland\\Props\\Obstacle\\Obstacle3.mdx")
        set thistype.OBSTACLE4 = this
        call this.AddTexture(Texture.OBSTACLE)

        set this = thistype.Create("Doodads\\Outland\\Props\\Obstacle\\Obstacle4.mdx")
        set thistype.OBSTACLE5 = this
        call this.AddTexture(Texture.OBSTACLE)

        set this = thistype.Create("Doodads\\Icecrown\\Props\\IceCrownPillar\\IceCrownPillar0.mdx")
        set thistype.PILLAR = this
        call this.AddTexture(Texture.ICE_CROWN_1)

        set this = thistype.Create("Doodads\\PillarTransparent\\PillarTransparent.mdx")
        set thistype.PILLAR_TRANSPARENT = this
        call this.AddTexture(Texture.ICE_CROWN_1)

        set this = thistype.Create("Doodads\\Icecrown\\Props\\IceCrownPillar\\IceCrownPillar1.mdx")
        set thistype.PILLAR2 = this
        call this.AddTexture(Texture.ICE_CROWN_1)

        set this = thistype.Create("Doodads\\Icecrown\\Props\\IceCrownPillar\\IceCrownPillar2.mdx")
        set thistype.PILLAR3 = this
        call this.AddTexture(Texture.ICE_CROWN_1)

        set this = thistype.Create("Doodads\\Icecrown\\Rocks\\Ice_Rock\\Ice_Rock0.mdx")
        set thistype.ROCK = this
        call this.AddTexture(Texture.GLACIER)

        set this = thistype.Create("Doodads\\Icecrown\\Rocks\\Ice_Rock\\Ice_Rock1.mdx")
        set thistype.ROCK2 = this
        call this.AddTexture(Texture.GLACIER)

        set this = thistype.Create("Doodads\\Icecrown\\Rocks\\Ice_Rock\\Ice_Rock2.mdx")
        set thistype.ROCK3 = this
        call this.AddTexture(Texture.GLACIER)

        set this = thistype.Create("Doodads\\Icecrown\\Rocks\\Ice_Rock\\Ice_Rock3.mdx")
        set thistype.ROCK4 = this
        call this.AddTexture(Texture.GLACIER)

        set this = thistype.Create("Doodads\\Icecrown\\Rocks\\Ice_Rock\\Ice_Rock4.mdx")
        set thistype.ROCK5 = this
        call this.AddTexture(Texture.GLACIER)

        set this = thistype.Create("Doodads\\Icecrown\\Rocks\\Ice_Rock\\Ice_Rock5.mdx")
        set thistype.ROCK6 = this
        call this.AddTexture(Texture.GLACIER)

        set this = thistype.Create("Doodads\\Icecrown\\Rocks\\Ice_Rock\\Ice_Rock6.mdx")
        set thistype.ROCK7 = this
        call this.AddTexture(Texture.GLACIER)

        set this = thistype.Create("Doodads\\Icecrown\\Rocks\\Ice_Rock\\Ice_Rock7.mdx")
        set thistype.ROCK8 = this
        call this.AddTexture(Texture.GLACIER)

        set this = thistype.Create("Doodads\\Cinematic\\RockinArthas\\RockinArthas.mdx")
        set thistype.ROCKIN_ARTHAS = this
        call this.AddTexture(Texture.ARTHAS_CLOAK_CREDITS)
        call this.AddTexture(Texture.ARTHAS2)
        call this.AddTexture(Texture.BLUE_GLOW2)
        call this.AddTexture(Texture.FUR_BOOTS2)
        call this.AddTexture(Texture.HAIR_02_09)
        call this.AddTexture(Texture.ICE_3B)
        call this.AddTexture(Texture.LIGHTNING_BALL)
        call this.AddTexture(Texture.MAIL_C_PADS)
        call this.AddTexture(Texture.SACRIFICIAL_ALTAR_SKULL)
        call this.AddTexture(Texture.SHIELD_ROUND_A_01_BLACK)
        call this.AddTexture(Texture.SHOCKWAVE_4_WHITE)
        call this.AddTexture(Texture.SHOULDER_PLATE_D2_ARTHAS)

        set this = thistype.Create("Doodads\\Icecrown\\Structures\\Icecrown_Rubble\\Icecrown_Rubble0.mdx")
        set thistype.RUBBLE = this
        call this.AddTexture(Texture.RUBBLE)

        set this = thistype.Create("Doodads\\Icecrown\\Structures\\Icecrown_Rubble\\Icecrown_Rubble1.mdx")
        set thistype.RUBBLE2 = this
        call this.AddTexture(Texture.RUBBLE)

        set this = thistype.Create("Doodads\\Icecrown\\Structures\\Icecrown_Rubble\\Icecrown_Rubble2.mdx")
        set thistype.RUBBLE3 = this
        call this.AddTexture(Texture.RUBBLE)

        set this = thistype.Create("Doodads\\Ashenvale\\Structures\\AshenRubble\\AshenRubble0.mdx")
        set thistype.RUBBLE_ASHEN = this
        call this.AddTexture(Texture.RUBBLE_ASHEN)

        set this = thistype.Create("Doodads\\Ashenvale\\Structures\\AshenRubble\\AshenRubble1.mdx")
        set thistype.RUBBLE_ASHEN2 = this
        call this.AddTexture(Texture.RUBBLE_ASHEN)

        set this = thistype.Create("Doodads\\Ashenvale\\Structures\\AshenRubble\\AshenRubble2.mdx")
        set thistype.RUBBLE_ASHEN3 = this
        call this.AddTexture(Texture.RUBBLE_ASHEN)

        set this = thistype.Create("Doodads\\Ruins\\Props\\RuinsTrash\\RuinsTrash0.mdx")
        set thistype.RUINS_TRASH = this
        call this.AddTexture(Texture.RUINS_TRASH)

        set this = thistype.Create("Doodads\\Ruins\\Props\\RuinsTrash\\RuinsTrash1.mdx")
        set thistype.RUINS_TRASH2 = this
        call this.AddTexture(Texture.RUINS_TRASH)

        set this = thistype.Create("Doodads\\LordaeronSummer\\Props\\SignPost\\SignPost.mdx")
        set thistype.SIGN_POST = this
        call this.AddTexture(Texture.GENERAL_DOODADS_0)

        set this = thistype.Create("Doodads\\Icecrown\\Props\\IceTorch\\IceTorch.mdx")
        set thistype.SKULL_TORCH = this
        call this.AddTexture(Texture.CLOUDS_8X8)
        call this.AddTexture(Texture.GENERIC_GLOW)
        call this.AddTexture(Texture.ICE_CROWN_0)
        call this.AddTexture(Texture.SMOKE)

        set this = thistype.Create("Doodads\\Icecrown\\Rocks\\Ice_SnowRock\\Ice_SnowRock0.mdx")
        set thistype.SNOW_ROCK = this
        call this.AddTexture(Texture.GLACIER)

        set this = thistype.Create("Doodads\\Icecrown\\Rocks\\Ice_SnowRock\\Ice_SnowRock1.mdx")
        set thistype.SNOW_ROCK2 = this
        call this.AddTexture(Texture.GLACIER)

        set this = thistype.Create("Doodads\\Icecrown\\Rocks\\Ice_SnowRock\\Ice_SnowRock2.mdx")
        set thistype.SNOW_ROCK3 = this
        call this.AddTexture(Texture.GLACIER)

        set this = thistype.Create("Doodads\\Icecrown\\Rocks\\Ice_SnowRock\\Ice_SnowRock3.mdx")
        set thistype.SNOW_ROCK4 = this
        call this.AddTexture(Texture.GLACIER)

        set this = thistype.Create("Doodads\\Icecrown\\Rocks\\Ice_SnowRock\\Ice_SnowRock4.mdx")
        set thistype.SNOW_ROCK5 = this
        call this.AddTexture(Texture.GLACIER)

        set this = thistype.Create("Doodads\\Icecrown\\Rocks\\Ice_SnowRock\\Ice_SnowRock5.mdx")
        set thistype.SNOW_ROCK6 = this
        call this.AddTexture(Texture.GLACIER)

        set this = thistype.Create("Doodads\\Icecrown\\Rocks\\Ice_SnowRock\\Ice_SnowRock6.mdx")
        set thistype.SNOW_ROCK7 = this
        call this.AddTexture(Texture.GLACIER)

        set this = thistype.Create("Doodads\\Icecrown\\Rocks\\Ice_SnowRock\\Ice_SnowRock7.mdx")
        set thistype.SNOW_ROCK8 = this
        call this.AddTexture(Texture.GLACIER)

        set this = thistype.Create("Doodads\\Icecrown\\Rocks\\Ice_SnowRock\\Ice_SnowRock8.mdx")
        set thistype.SNOW_ROCK9 = this
        call this.AddTexture(Texture.GLACIER)

        set this = thistype.Create("Doodads\\Icecrown\\Rocks\\Ice_SnowRock\\Ice_SnowRock9.mdx")
        set thistype.SNOW_ROCK10 = this
        call this.AddTexture(Texture.GLACIER)

        set this = thistype.Create("Doodads\\Icecrown\\Props\\SpiderStatue1\\SpiderStatue1.mdx")
        set thistype.SPIDER_STATUE = this
        call this.AddTexture(Texture.ICE_CROWN_1)

        set this = thistype.Create("Doodads\\Icecrown\\Props\\SpiderStatue0\\SpiderStatue0.mdx")
        set thistype.SPIDER_STATUE2 = this
        call this.AddTexture(Texture.ICE_CROWN_1)

        set this = thistype.Create("Doodads\\Cityscape\\Structures\\CityLowWall90\\CityLowWall90.mdx")
        set thistype.STAIR_STEP = this
        call this.AddTexture(Texture.CITY)

        set this = thistype.Create("Doodads\\Cityscape\\Props\\TavernSign\\TavernSign.mdx")
        set thistype.TAVERN_SIGN = this
        call this.AddTexture(Texture.TAVERN_SIGN)

        set this = thistype.Create("Doodads\\LordaeronSummer\\Structures\\TowerScorched\\TowerScorched.mdx")
        set thistype.TOWER_SCORCHED = this
        call this.AddTexture(Texture.TOWER_SCORCHED)

        set this = thistype.Create("Doodads\\Dungeon\\Props\\TreasurePile\\TreasurePile0.mdx")
        set thistype.TREASURE_PILE = this
        call this.AddTexture(Texture.DUNGEON_0)

        set this = thistype.Create("Doodads\\Dungeon\\Props\\TreasurePile\\TreasurePile1.mdx")
        set thistype.TREASURE_PILE2 = this
        call this.AddTexture(Texture.DUNGEON_0)

        set this = thistype.Create("Doodads\\Terrain\\AshenTree\\AshenTree0.mdx")
        set thistype.TREE = this
        call this.AddTexture(Texture.TREE)

        set this = thistype.Create("Doodads\\Terrain\\AshenTree\\AshenTree1.mdx")
        set thistype.TREE2 = this
        call this.AddTexture(Texture.TREE)

        set this = thistype.Create("Doodads\\Terrain\\AshenTree\\AshenTree2.mdx")
        set thistype.TREE3 = this
        call this.AddTexture(Texture.TREE)

        set this = thistype.Create("Doodads\\Terrain\\AshenTree\\AshenTree3.mdx")
        set thistype.TREE4 = this
        call this.AddTexture(Texture.TREE)

        set this = thistype.Create("Doodads\\Terrain\\AshenTree\\AshenTree4.mdx")
        set thistype.TREE5 = this
        call this.AddTexture(Texture.TREE)

        set this = thistype.Create("Doodads\\Terrain\\AshenTree\\AshenTree5.mdx")
        set thistype.TREE6 = this
        call this.AddTexture(Texture.TREE)

        set this = thistype.Create("Doodads\\Terrain\\AshenTree\\AshenTree6.mdx")
        set thistype.TREE7 = this
        call this.AddTexture(Texture.TREE)

        set this = thistype.Create("Doodads\\Terrain\\AshenTree\\AshenTree7.mdx")
        set thistype.TREE8 = this
        call this.AddTexture(Texture.TREE)

        set this = thistype.Create("Doodads\\Terrain\\AshenTree\\AshenTree8.mdx")
        set thistype.TREE9 = this
        call this.AddTexture(Texture.TREE)

        set this = thistype.Create("Doodads\\Terrain\\AshenTree\\AshenTree9.mdx")
        set thistype.TREE10 = this
        call this.AddTexture(Texture.TREE)

        set this = thistype.Create("Doodads\\Tree11\\Tree11.mdx")
        set thistype.TREE11 = this
        call this.AddTexture(Texture.TREE11)

        set this = thistype.Create("Doodads\\Wall\\Wall.mdx")
        set thistype.WALL = this
        call this.AddTexture(Texture.WALL)

        set this = thistype.Create("Doodads\\Wall\\WallEnd.mdx")
        set thistype.WALL_END = this
        call this.AddTexture(Texture.WALL)

        set this = thistype.Create("Doodads\\WallTransparent\\WallTransparent.mdx")
        set thistype.WALL_TRANSPARENT = this
        call this.AddTexture(Texture.WALL)

        set this = thistype.Create("Doodads\\Waterfall\\Waterfall.mdx")
        set thistype.WATERFALL = this
        call this.AddTexture(Texture.ICE_CROWN_WALLS)
        call this.AddTexture(Texture.WATERFALL)

        //Items
        set this = thistype.Create("Objects\\InventoryItems\\TreasureChest\\treasurechest.mdx")
        set thistype.GENERAL_ITEM = this
        call this.AddTexture(Texture.GENERAL_ITEM)
        call this.AddTexture(Texture.YELLOW_STAR)

        set this = thistype.Create("Objects\\InventoryItems\\tome\\tome.mdx")
        set thistype.SPELL_ITEM = this
        call this.AddSpawnModel(SpawnModel.TOON_BOOM)
        call this.AddTexture(Texture.GENERIC_GLOW_64)
        call this.AddTexture(Texture.SPELL_ITEM)
        call this.AddTexture(Texture.YELLOW_STAR)
        call this.AddTexture(Texture.YELLOW_STAR_DIM)

        //Spells
        set this = thistype.Create("Abilities\\Spells\\Other\\CrushingWave\\CrushingWaveMissile.mdx")
        set thistype.CHILLY_BREATH = this
        call this.AddTexture(Texture.BLUE_GLOW2)
        call this.AddTexture(Texture.FIRE_RING_1A)
        call this.AddTexture(Texture.GENERIC_GLOW)
        call this.AddTexture(Texture.WHITE_64_FOAM)

        set this = thistype.Create("Abilities\\Spells\\Orc\\Shockwave\\ShockwaveMissile.mdx")
        set thistype.CLEAVAGE = this
        call this.AddSound(SoundSet.CRUSHING_WAVE)
        call this.AddTexture(Texture.CLOUDS_8X8_GREY)
        call this.AddTexture(Texture.FIRE_RING_1A)
        call this.AddTexture(Texture.STAR2_32)
        call this.AddTexture(Texture.YELLOW_GLOW)

        set this = thistype.Create("Abilities\\Weapons\\DruidoftheTalonMissile\\DruidoftheTalonMissile.mdx")
        set thistype.CREATE_MANA_POTION = this
        call this.AddSound(SoundSet.DRUID_OF_THE_TALON_MISSILE_HIT)
        call this.AddSound(SoundSet.DRUID_OF_THE_TALON_MISSILE_LAUNCH)
        call this.AddTexture(Texture.DUST6)
        call this.AddTexture(Texture.ENERGY)
        call this.AddTexture(Texture.LENS_FLARE_1A)
        call this.AddTexture(Texture.STAR4)

        set this = thistype.Create("Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile.mdx")
        set thistype.FIREBALL = this
        call this.AddSound(SoundSet.PHOENIX_MISSILE_LAUNCH)
        call this.AddSound(SoundSet.ZIGGURAT_MISSILE_HIT)
        call this.AddTexture(Texture.LAVA_LUMP2)
        call this.AddTexture(Texture.RED_GLOW3)
        call this.AddTexture(Texture.RIBBON_MAGIC)
        call this.AddTexture(Texture.RIBBON_NE_RED2)

        set this = thistype.Create("Abilities\\Spells\\Undead\\FrostNova\\FrostNovaTarget.mdx")
        set thistype.FROZEN_STAR = this
        call this.AddSound(SoundSet.FROST_NOVA)
        call this.AddTexture(Texture.FROST2)
        call this.AddTexture(Texture.ICE_3B)
        call this.AddTexture(Texture.LIGHTNING_BALL)
        call this.AddTexture(Texture.SHOCKWAVE10)
        call this.AddTexture(Texture.SHOCKWAVE_WATER)
        call this.AddTexture(Texture.SNOWFLAKE2)

        set this = thistype.Create("Abilities\\Weapons\\RockBoltMissile\\RockBoltMissile.mdx")
        set thistype.LAPIDATION = this
        call this.AddSound(SoundSet.STORMBOLT)
        call this.AddTexture(Texture.BLUE_GLOW2)
        call this.AddTexture(Texture.DUST3)
        call this.AddTexture(Texture.E_SMOKE_ANIM256)
        call this.AddTexture(Texture.FIRE_RING4)
        call this.AddTexture(Texture.LAPIDATION)
        call this.AddTexture(Texture.LENS_FLARE_1A)
        call this.AddTexture(Texture.PURPLE_GLOW_DIM)
        call this.AddTexture(Texture.STAR32)
        call this.AddTexture(Texture.ZAP)

        set this = thistype.Create("Abilities\\Spells\\Undead\\Possession\\PossessionMissile.mdx")
        set thistype.MANA_LASER = this
        call this.AddSound(SoundSet.POSSESSION_MISSILE_HIT)
        call this.AddSound(SoundSet.POSSESSION_MISSILE_LAUNCH)
        call this.AddTexture(Texture.GENERIC_GLOW_64)
        call this.AddTexture(Texture.MANA_LASER)
        call this.AddTexture(Texture.STAR4)

        set this = thistype.Create("Abilities\\Weapons\\SkeletalMageMissile\\SkeletalMageMissile.mdx")
        set thistype.SEVERANCE = this
        call this.AddSound(SoundSet.NECROMANCER_MISSILE_HIT)
        call this.AddSound(SoundSet.NECROMANCER_MISSILE_LAUNCH)
        call this.AddTexture(Texture.GREEN_GLOW2)
        call this.AddTexture(Texture.SEVERANCE)

        set this = thistype.Create("Abilities\\Spells\\Other\\AcidBomb\\BottleMissile.mdx")
        set thistype.SLEEPING_DRAFT = this
        call this.AddSound(SoundSet.ANTI_MAGIC_SHELL)
        call this.AddSound(SoundSet.STRONG_DRINK_MISSILE)
        call this.AddTexture(Texture.ALCHEMIST_BLUE)
        call this.AddTexture(Texture.BLOOD_WHITE_SMALL)
        call this.AddTexture(Texture.DUST_3X)
        call this.AddTexture(Texture.SHOCKWAVE10)
        call this.AddTexture(Texture.STAR2_32)
        call this.AddTexture(Texture.WATER_BLOBS)

        set this = thistype.Create("Abilities\\Weapons\\FrostWyrmMissile\\FrostWyrmMissile.mdx")
        set thistype.SNOWY_SPHERE = this
        call this.AddSound(SoundSet.FIREBALL)
        call this.AddTexture(Texture.CLOUDS_8X8)
        call this.AddTexture(Texture.RAIN_TAIL)
        call this.AddTexture(Texture.SNOWFLAKE)

        set this = thistype.Create("Abilities\\Weapons\\LichMissile\\LichMissile.mdx")
        set thistype.SNOWY_SPHERE_PARTICLE = this
        call this.AddSound(SoundSet.LICH_ATTACK_1)
        call this.AddSound(SoundSet.LICH_MISSILE)
        call this.AddTexture(Texture.BLUE_GLOW2)
        call this.AddTexture(Texture.DUST_5A)
        call this.AddTexture(Texture.FROST3)
        call this.AddTexture(Texture.ICE)

        set this = thistype.Create("Abilities\\Spells\\Human\\StormBolt\\StormBoltMissile.mdx")
        set thistype.STORMBOLT = this
        call this.AddSound(SoundSet.STORMBOLT)
        call this.AddSound(SoundSet.TOME)
        call this.AddTexture(Texture.BLUE_GLOW2)
        call this.AddTexture(Texture.DUST3)
        call this.AddTexture(Texture.E_SMOKE_ANIM256)
        call this.AddTexture(Texture.FIRE_RING4)
        call this.AddTexture(Texture.LENS_FLARE_1A)
        call this.AddTexture(Texture.PURPLE_GLOW_DIM)
        call this.AddTexture(Texture.ROCKETEYE)
        call this.AddTexture(Texture.STAR32)
        call this.AddTexture(Texture.TEAM_COLOR_00)
        call this.AddTexture(Texture.ZAP)

        //Units
            set this = thistype.Create("units\\critters\\Penguin\\Penguin.mdx")
            set thistype.PENGUIN = this
            call this.AddFootPrint(FootPrint.CLOVEN_REALLY_SMALL_LEFT)
            call this.AddFootPrint(FootPrint.CLOVEN_REALLY_SMALL_RIGHT)
            call this.AddSound(SoundSet.PENGUIN_DEATH)
            call this.AddTexture(Texture.GUTZ)
            call this.AddTexture(Texture.PENGUIN)
            call this.AddTexture(Texture.WATER_WAKE2)
            call this.AddTexture(Texture.WATER_WAKE3)

            //Heroes
            set this = thistype.Create("units\\nightelf\\HeroMoonPriestess\\HeroMoonPriestess.mdx")
            set thistype.ARURUW = this
            call this.AddBloodSplat(BloodSplat.NIGHT_ELF_BLOOD_LARGE_0)
            call this.AddBloodSplat(BloodSplat.NIGHT_ELF_BLOOD_LARGE_2)
            call this.AddFootPrint(FootPrint.PAW_LARGE_LEFT)
            call this.AddFootPrint(FootPrint.PAW_LARGE_RIGHT)
            call this.AddFootPrint(FootPrint.PAW_LEFT_0)
            call this.AddFootPrint(FootPrint.PAW_RIGHT_0)
            call this.AddSound(SoundSet.MOON_PRIESTESS_DEATH)
            call this.AddSound(SoundSet.NIGHT_ELF_DISSIPATE)
            call this.AddSpawnModel(SpawnModel.NIGHT_ELF_BLOOD_PRIESTESS)
            call this.AddTexture(Texture.ARURUW)

            set this = thistype.Create("units\\undead\\HeroDreadLord\\HeroDreadLord.mdx")
            set thistype.DRAKUL = this
            call this.AddFootPrint(FootPrint.BOOT_LARGE_LEFT_0)
            call this.AddFootPrint(FootPrint.BOOT_LARGE_RIGHT_0)
            call this.AddSound(SoundSet.GATHER_SHADOWS_MORPH)
            call this.AddSound(SoundSet.GATHER_SHADOWS_MORPH_ALTERNATE)
            call this.AddSound(SoundSet.DREAD_LORD_DEATH)
            call this.AddSpawnModel(SpawnModel.UNDEAD_DISSIPATE)
            call this.AddTexture(Texture.DRAKUL)
            call this.AddTexture(Texture.DUST_5A_BLACK)
            call this.AddTexture(Texture.FLARE)

            set this = thistype.Create("units\\human\\Jaina\\Jaina.mdx")
            set thistype.LIZZY = this
            call this.AddBloodSplat(BloodSplat.HUMAN_BLOOD_LARGE_1)
            call this.AddBloodSplat(BloodSplat.HUMAN_BLOOD_LARGE_2)
            call this.AddBloodSplat(BloodSplat.HUMAN_BLOOD_SMALL_0)
            call this.AddBloodSplat(BloodSplat.HUMAN_BLOOD_SMALL_1)
            call this.AddBloodSplat(BloodSplat.HUMAN_BLOOD_SMALL_3)
            call this.AddFootPrint(FootPrint.BOOT_LARGE_LEFT_0)
            call this.AddFootPrint(FootPrint.BOOT_LARGE_RIGHT_0)
            call this.AddSound(SoundSet.HUMAN_DISSIPATE)
            call this.AddSound(SoundSet.JAINA_DEATH)
            call this.AddTexture(Texture.CLOUDS_8X8)
            call this.AddTexture(Texture.LIZZY)

            set this = thistype.Create("units\\human\\HeroMountainKing\\HeroMountainKing.mdx")
            set thistype.ROCKETEYE = this
            call this.AddBloodSplat(BloodSplat.HUMAN_BLOOD_LARGE_1)
            call this.AddBloodSplat(BloodSplat.HUMAN_BLOOD_LARGE_2)
            call this.AddBloodSplat(BloodSplat.HUMAN_BLOOD_SMALL_0)
            call this.AddBloodSplat(BloodSplat.HUMAN_BLOOD_SMALL_1)
            call this.AddBloodSplat(BloodSplat.HUMAN_BLOOD_SMALL_3)
            call this.AddFootPrint(FootPrint.BOOT_SMALL_LEFT_0)
            call this.AddFootPrint(FootPrint.BOOT_SMALL_RIGHT_0)
            call this.AddSound(SoundSet.HUMAN_DISSIPATE)
            call this.AddSound(SoundSet.MOUNTAIN_KING_ATTACK_1)
            call this.AddSound(SoundSet.MOUNTAIN_KING_DEATH)
            call this.AddTexture(Texture.CLOUD_SINGLE)
            call this.AddTexture(Texture.GENERIC_CLOUD_FADED)
            call this.AddTexture(Texture.ROCKETEYE)
            call this.AddTexture(Texture.ROCKETEYE_AVATAR)
            call this.AddTexture(Texture.STAR2_32)

            set this = thistype.Create("units\\undead\\HeroDeathKnight\\HeroDeathKnight.mdx")
            set thistype.SMOKEALOT = this
            call this.AddFootPrint(FootPrint.HORSE_SMALL_LEFT)
            call this.AddFootPrint(FootPrint.HORSE_SMALL_RIGHT)
            call this.AddSound(SoundSet.DEATH_KNIGHT_ATTACK_1)
            call this.AddSound(SoundSet.DEATH_KNIGHT_DEATH)
            call this.AddSpawnModel(SpawnModel.UNDEAD_DISSIPATE)
            call this.AddTexture(Texture.DUST_3X)
            call this.AddTexture(Texture.LIGHTNING_BALL)
            call this.AddTexture(Texture.SMOKEALOT)

            set this = thistype.Create("Units\\Creeps\\PandarenBrewmaster\\PandarenBrewmaster.mdx")
            set thistype.STORMY = this
            call this.AddBloodSplat(BloodSplat.NIGHT_ELF_BLOOD_LARGE_2)
            call this.AddBloodSplat(BloodSplat.NIGHT_ELF_BLOOD_SMALL_0)
            call this.AddBloodSplat(BloodSplat.NIGHT_ELF_BLOOD_SMALL_2)
            call this.AddFootPrint(FootPrint.PAW_BEAR_LEFT)
            call this.AddFootPrint(FootPrint.PAW_BEAR_RIGHT)
            call this.AddSound(SoundSet.BREWMASTER_ATTACK_1)
            call this.AddSound(SoundSet.BREWMASTER_ATTACK_2)
            call this.AddSound(SoundSet.HUMAN_DISSIPATE)
            call this.AddSound(SoundSet.PANDAREN_BREWMASTER_DEATH)
            call this.AddSpawnModel(SpawnModel.PANDAREN_BREWMASTER_EXPLOSION)
            call this.AddTexture(Texture.RIBBON_BLUR)
            call this.AddTexture(Texture.STORMY)

            set this = thistype.Create("units\\orc\\Thrall\\Thrall.mdx")
            set thistype.TAJRAN = this
            call this.AddBloodSplat(BloodSplat.ORC_BLOOD_LARGE_1)
            call this.AddBloodSplat(BloodSplat.ORC_BLOOD_LARGE_2)
            call this.AddBloodSplat(BloodSplat.ORC_BLOOD_LARGE_3)
            call this.AddBloodSplat(BloodSplat.ORC_BLOOD_SMALL_0)
            call this.AddBloodSplat(BloodSplat.ORC_BLOOD_SMALL_2)
            call this.AddFootPrint(FootPrint.PAW_LEFT_0)
            call this.AddFootPrint(FootPrint.PAW_RIGHT_0)
            call this.AddSpawnModel(SpawnModel.ORC_BLOOD_FARSEER)
            call this.AddSound(SoundSet.FARSEER_DEATH)
            call this.AddSound(SoundSet.ORC_DISSIPATE)
            call this.AddTexture(Texture.TAJRAN)

            //Missiles
            set this = thistype.Create("Abilities\\Weapons\\MoonPriestessMissile\\MoonPriestessMissile.mdx")
            set thistype.ARURUW_MISSILE = this
            call this.AddSound(SoundSet.ARROW_LAUNCH)
            call this.AddSound(SoundSet.RANGER_MISSILE)
            call this.AddTexture(Texture.ARROW_MISSILE)
            call this.AddTexture(Texture.GRAD3)
            call this.AddTexture(Texture.TEAM_GLOW_00)

            set this = thistype.Create("Abilities\\Weapons\\Axe\\AxeMissile.mdx")
            set thistype.AXE_MISSILE = this
            call this.AddSound(SoundSet.AXE_MISSILE_HIT)
            call this.AddSound(SoundSet.AXE_MISSILE_LAUNCH)
            call this.AddTexture(Texture.AXE_MISSILE)

            set this = thistype.Create("Abilities\\Weapons\\Catapult\\CatapultMissile.mdx")
            set thistype.CATAPULT_MISSILE = this
            call this.AddSound(SoundSet.CATAPULT)
            call this.AddTexture(Texture.CATAPULT)
            call this.AddTexture(Texture.CLOUDS_8X8)
            call this.AddTexture(Texture.DUST_5A)
            call this.AddTexture(Texture.ROCK64)
            call this.AddTexture(Texture.SHOCKWAVE)
            call this.AddTexture(Texture.SHOCKWAVE_B)
            call this.AddUberSplat(UberSplat.HUMAN_CRATER)

            set this = thistype.Create("Abilities\\Weapons\\Catapult\\CatapultMissile.mdx")
            set thistype.DEMOLISHER_MISSILE = this
            call this.AddSound(SoundSet.CATAPULT)
            call this.AddTexture(Texture.DEMOLISHER)
            call this.AddTexture(Texture.CLOUDS_8X8)
            call this.AddTexture(Texture.DUST_5A)
            call this.AddTexture(Texture.ROCK64)
            call this.AddTexture(Texture.SHOCKWAVE)
            call this.AddTexture(Texture.SHOCKWAVE_B)
            call this.AddUberSplat(UberSplat.HUMAN_CRATER)

            set this = thistype.Create("Abilities\\Weapons\\FireBallMissile\\FireBallMissile.mdx")
            set thistype.FIREBALL_MISSILE = this
            call this.AddSound(SoundSet.FIREBALL)
            call this.AddSound(SoundSet.FIREBALL_LAUNCH)
            call this.AddTexture(Texture.CLOUDS_8X8)
            call this.AddTexture(Texture.DUST_5A_BLACK)
            call this.AddTexture(Texture.DUST_6_COLOR)
            call this.AddTexture(Texture.DUST_6_COLOR_RED)
            call this.AddTexture(Texture.LENS_FLARE_1A)

            set this = thistype.Create("Abilities\\Weapons\\GyroCopter\\GyroCopterMissile.mdx")
            set thistype.FLYING_PENGUIN_MISSILE = this
            call this.AddSound(SoundSet.CANNON_TOWER_ATTACK)
            call this.AddSound(SoundSet.MORTAR)
            call this.AddTexture(Texture.CLOUDS_8X8)
            call this.AddTexture(Texture.DUST_5A)
            call this.AddTexture(Texture.FLYING_PENGUIN_MISSILE)
            call this.AddTexture(Texture.GENERIC_GLOW_64)
            call this.AddTexture(Texture.LAVA_LUMP)
            call this.AddTexture(Texture.SHOCKWAVE10)

            set this = thistype.Create("Abilities\\Weapons\\FarseerMissile\\FarseerMissile.mdx")
            set thistype.LIGHTING_BOLT_MISSILE = this
            call this.AddSound(SoundSet.FARSEER_ATTACK_1)
            call this.AddSound(SoundSet.FARSEER_MISSILE)
            call this.AddTexture(Texture.BLUE_GLOW2)
            call this.AddTexture(Texture.GENERIC_GLOW)
            call this.AddTexture(Texture.LENS_FLARE_1A)
            call this.AddTexture(Texture.SHOCKWAVE10)
            call this.AddTexture(Texture.STAR32)
            call this.AddTexture(Texture.ZAP)

            set this = thistype.Create("Abilities\\Weapons\\NecromancerMissile\\NecromancerMissile.mdx")
            set thistype.SATYR_MISSILE = this
            call this.AddSound(SoundSet.NECROMANCER_MISSILE_HIT)
            call this.AddSound(SoundSet.NECROMANCER_MISSILE_LAUNCH)
            call this.AddTexture(Texture.LICH)
            call this.AddTexture(Texture.STAR_8B)
            call this.AddTexture(Texture.YELLOW_GLOW)

            set this = thistype.Create("Abilities\\Weapons\\SerpentWardMissile\\SerpentWardMissile.mdx")
            set thistype.SERPENT_WARD_MISSILE = this
            call this.AddSound(SoundSet.ANCESTRAL_GUARDIAN_MISSILE_HIT)
            call this.AddSound(SoundSet.ANCESTRAL_GUARDIAN_MISSILE_LAUNCH)
            call this.AddTexture(Texture.LENS_FLARE_1A)
            call this.AddTexture(Texture.RED_GLOW3)
            call this.AddTexture(Texture.RED_STAR3)
            call this.AddTexture(Texture.ZAP_RED)

            set this = thistype.Create("Abilities\\Weapons\\ChimaeraLightningMissile\\ChimaeraLightningMissile.mdx")
            set thistype.SNOW_FALCON_MISSILE = this
            call this.AddSound(SoundSet.FARSEER_ATTACK_1)
            call this.AddSound(SoundSet.LIGHTNING_BOLT)
            call this.AddTexture(Texture.BLUE_GLOW2)
            call this.AddTexture(Texture.SHOCKWAVE10)
            call this.AddTexture(Texture.ZAP)

            set this = thistype.Create("abilities\\weapons\\huntermissile\\huntermissile.mdx")
            set thistype.SPEAR_SCOUT_MISSILE = this
            call this.AddSound(SoundSet.HUNTER_MISSILE_HIT)
            call this.AddSound(SoundSet.HUNTER_MISSILE_LAUNCH)
            call this.AddTexture(Texture.HEAD_HUNTER)

            set this = thistype.Create("Abilities\\Weapons\\LichMissile\\LichMissile.mdx")
            set thistype.TROLL_PRIEST_MISSILE = this
            call this.AddSound(SoundSet.LICH_ATTACK_1)
            call this.AddSound(SoundSet.LICH_MISSILE)
            call this.AddTexture(Texture.BLUE_GLOW2)
            call this.AddTexture(Texture.DUST_5A)
            call this.AddTexture(Texture.FROST3)
            call this.AddTexture(Texture.ICE)

            //Spawns
                //Act1
                set this = thistype.Create("units\\critters\\BlackStagMale\\BlackStagMale.mdx")
                set thistype.DEER = this
                call this.AddTexture(Texture.DEER)
                call this.AddTexture(Texture.GUTZ)

                set this = thistype.Create("units\\creeps\\FurbolgTracker\\FurbolgTracker.mdx")
                set thistype.FURBOLG_ORACLE = this
                call this.AddTexture(Texture.FURBOLG_ORACLE)
                call this.AddTexture(Texture.GUTZ)

                set this = thistype.Create("units\\creeps\\Owlbear\\Owlbear.mdx")
                set thistype.MOONKIN = this
                call this.AddTexture(Texture.GUTZ)
                call this.AddTexture(Texture.MOONKIN)

                set this = thistype.Create("units\\creeps\\SatyrTrickster\\SatyrTrickster.mdx")
                set thistype.SATYR = this
                call this.AddTexture(Texture.GUTZ)
                call this.AddTexture(Texture.SATYR)

                set this = thistype.Create("units\\creeps\\WarEagle\\WarEagle.mdx")
                set thistype.SNOW_FALCON = this
                call this.AddTexture(Texture.CLOUDS_8X8)
                call this.AddTexture(Texture.SNOW_FALCON)

                set this = thistype.Create("units\\creeps\\IceTroll\\IceTroll.mdx")
                set thistype.TROLL = this
                call this.AddTexture(Texture.ENSNARE)
                call this.AddTexture(Texture.GUTZ)
                call this.AddTexture(Texture.TROLL)

                set this = thistype.Create("units\\creeps\\IceTrollShadowPriest\\IceTrollShadowPriest.mdx")
                set thistype.TROLL_PRIEST = this
                call this.AddTexture(Texture.GUTZ)
                call this.AddTexture(Texture.TROLL_PRIEST)

                set this = thistype.Create("units\\creeps\\WhiteWolf\\WhiteWolf.mdx")
                set thistype.WOLF = this
                call this.AddTexture(Texture.GUTZ)
                call this.AddTexture(Texture.RIBBON_BLUR)
                call this.AddTexture(Texture.WOLF)

                //Act2
                set this = thistype.Create("Units\\Spawns\\Act2\\Assassin\\Assassin.mdx")
                set thistype.ASSASSIN = this
                call this.AddTexture(Texture.ACOLYTE)
                call this.AddTexture(Texture.ASSASSIN)
                call this.AddTexture(Texture.BLADE_MASTER)
                call this.AddTexture(Texture.GUTZ)

                set this = thistype.Create("units\\orc\\Grunt\\Grunt.mdx")
                set thistype.AXE_FIGHTER = this
                call this.AddTexture(Texture.AXE_FIGHTER)
                call this.AddTexture(Texture.GUTZ)
                call this.AddTexture(Texture.SHOCKWAVE_ICE)

                set this = thistype.Create("Units\\Spawns\\Act2\\Balduir\\Balduir.mdx")
                set thistype.BALDUIR = this
                call this.AddTexture(Texture.ARTHAS)
                call this.AddTexture(Texture.AXE_BLADE_BLUE_STEEL)
                call this.AddTexture(Texture.AXE_FIGHTER)
                call this.AddTexture(Texture.BALDUIR)
                call this.AddTexture(Texture.BLADE_MASTER)
                call this.AddTexture(Texture.BLOOD_SPLASH)
                call this.AddTexture(Texture.BLOOD_SPLUT)
                call this.AddTexture(Texture.CATAPULT)
                call this.AddTexture(Texture.CLOUDS_8X8)
                call this.AddTexture(Texture.GUTZ)
                call this.AddTexture(Texture.HANDLE_RED_WRAPPED)
                call this.AddTexture(Texture.RIBBON_BLUR)
                call this.AddTexture(Texture.TAUREN)
                call this.AddTexture(Texture.TAJRAN)
                call this.AddTexture(Texture.YELLOW_GLOW_DIM)
                call this.AddTexture(Texture.YELLOW_GLOW3)
                call this.AddTexture(Texture.YELLOW_STAR)

                set this = thistype.Create("units\\orc\\catapult\\catapult.mdx")
                set thistype.CATAPULT = this
                call this.AddTexture(Texture.CATAPULT)
                call this.AddTexture(Texture.CLOUD_SINGLE)

                set this = thistype.Create("units\\orc\\catapult\\catapult_V1.mdl")
                set thistype.DEMOLISHER = this
                call this.AddTexture(Texture.CLOUD_SINGLE)
                call this.AddTexture(Texture.CLOUDS_8X8)
                call this.AddTexture(Texture.DEMOLISHER)

                set this = thistype.Create("units\\orc\\KotoBeast\\KotoBeast.mdx")
                set thistype.DRUMMER = this
                call this.AddTexture(Texture.DRUMMER)
                call this.AddTexture(Texture.GUTZ)

                set this = thistype.Create("units\\demon\\ChaosWarlord\\ChaosWarlord.mdx")
                set thistype.LEADER = this
                call this.AddTexture(Texture.LEADER)

                set this = thistype.Create("units\\orc\\HeroFarSeer\\HeroFarSeer.mdx")
                set thistype.NAGAROSH = this
                call this.AddTexture(Texture.DUST_3X)
                call this.AddTexture(Texture.LIGHTNING_BALL)
                call this.AddTexture(Texture.NAGAROSH)

                set this = thistype.Create("units\\orc\\Peon\\Peon.mdx")
                set thistype.PEON = this
                call this.AddTexture(Texture.GUTZ)
                call this.AddTexture(Texture.PEON)

                set this = thistype.Create("units\\orc\\WolfRider\\WolfRider.mdx")
                set thistype.RAIDER = this
                call this.AddTexture(Texture.DUST_3X)
                call this.AddTexture(Texture.GUTZ)
                call this.AddTexture(Texture.RAIDER)

                set this = thistype.Create("Units\\Spawns\\Act2\\SpearScout\\SpearScout.mdx")
                set thistype.SPEAR_SCOUT = this
                call this.AddTexture(Texture.BLADE_MASTER)
                call this.AddTexture(Texture.FACELESS_ONE)
                call this.AddTexture(Texture.GUTZ)
                call this.AddTexture(Texture.ORC_BARRACKS)
                call this.AddTexture(Texture.SPEAR_SCOUT)

                set this = thistype.Create("Units\\Spawns\\Act2\\Tarog\\Tarog.mdx")
                set thistype.TAROG = this
                call this.AddTexture(Texture.BLOOD_PRIEST)
                call this.AddTexture(Texture.CHAOS_RAIDER)
                call this.AddTexture(Texture.GUTZ)
                call this.AddTexture(Texture.LIGHTNING_BALL)
                call this.AddTexture(Texture.PURPLE_GLOW)
                call this.AddTexture(Texture.RAIDER)
                call this.AddTexture(Texture.TAROG)

                set this = thistype.Create("units\\other\\Proudmoore\\Proudmoore.mdx")
                set thistype.TRUE_LEADER = this
                call this.AddTexture(Texture.RIBBON_BLUR)
                call this.AddTexture(Texture.TRUE_LEADER)

            //Summons
            set this = thistype.Create("Units\\Other\\Barrier\\Barrier.mdx")
            set thistype.BARRIER = this
            call this.AddTexture(Texture.CLOUDS_8X8)
            call this.AddTexture(Texture.ICE_CROWN_WALLS)

            set this = thistype.Create("Units\\Summons\\GhostSword\\GhostSword.mdx")
            set thistype.GHOST_SWORD = this
            call this.AddTexture(Texture.BLADE_MASTER)

            set this = thistype.Create("units\\creeps\\PolarBear\\PolarBear.mdx")
            set thistype.POLAR_BEAR = this
            call this.AddTexture(Texture.GUTZ)
            call this.AddTexture(Texture.POLAR_BEAR)

            set this = thistype.Create("units\\orc\\SerpentWard\\SerpentWard.mdx")
            set thistype.SERPENT_WARD = this
            call this.AddTexture(Texture.DUST_5A)
            call this.AddTexture(Texture.RED_GLOW2)
            call this.AddTexture(Texture.SERPENT_WARD)
            call this.AddTexture(Texture.WARDS)

            set this = thistype.Create("units\\orc\\Spiritwolf\\Spiritwolf.mdx")
            set thistype.SPIRIT_WOLF = this
            call this.AddTexture(Texture.DEATH_SCREAM)
            call this.AddTexture(Texture.GENERIC_GLOW_2B)
            call this.AddTexture(Texture.GUTZ)
            call this.AddTexture(Texture.SPIRIT_WOLF)
            call this.AddTexture(Texture.STAR2_32)
            call this.AddTexture(Texture.ZAP_RED)

            set this = thistype.Create("units\\creeps\\GoblinLandMine\\GoblinLandMine.mdx")
            set thistype.TRAP_MINE = this
            call this.AddTexture(Texture.CARTOON_CLOUD)
            call this.AddTexture(Texture.CLOUDS_8X8)
            call this.AddTexture(Texture.DUST_3X)
            call this.AddTexture(Texture.DUST_5A)
            call this.AddTexture(Texture.ROCK_PARTICLE)
            call this.AddTexture(Texture.TRAP_MINE)

            //Other
            set this = thistype.Create("buildings\\other\\FountainOfLifeBlood\\FountainOfLifeBlood.mdx")
            set thistype.FOUNTAIN = this
            call this.AddTexture(Texture.BACKGROUND)
            call this.AddTexture(Texture.CLOUD_SINGLE)
            call this.AddTexture(Texture.FLARE_BLOOD)
            call this.AddTexture(Texture.FOUNTAIN)
            call this.AddTexture(Texture.FOUNTAIN_BLOOD)

            set this = thistype.Create("buildings\\other\\Marketplace\\Marketplace.mdx")
            set thistype.MARKET = this
            call this.AddTexture(Texture.CARTOON_CLOUD)
            call this.AddTexture(Texture.CLOUDS_8X8_FIRE)
            call this.AddTexture(Texture.DUST_5A)
            call this.AddTexture(Texture.MARKET)
            call this.AddTexture(Texture.ROCK_PARTICLE)
            call this.AddTexture(Texture.SPINNING_BOARD)

            set this = thistype.Create("buildings\\other\\SacrificialAltar\\SacrificialAltar.mdx")
            set thistype.METEORITE = this
            call this.AddTexture(Texture.BACKGROUND)
            call this.AddTexture(Texture.CLOUDS_8X8)
            call this.AddTexture(Texture.METEORITE)
            call this.AddTexture(Texture.RED_GLOW3)

            set this = thistype.Create("units\\human\\Sorceress\\Sorceress.mdx")
            set thistype.ROSA = this
            call this.AddTexture(Texture.GUTZ)
            call this.AddTexture(Texture.ROSA)

            set this = thistype.Create("units\\human\\Priest\\Priest.mdx")
            set thistype.SEBASTIAN = this
            call this.AddTexture(Texture.GUTZ)
            call this.AddTexture(Texture.SEBASTIAN)
            call this.AddTexture(Texture.YELLOW_STAR_DIM)

            set this = thistype.Create("Doodads\\Icecrown\\Props\\SnowMan\\SnowMan.mdx")
            set thistype.SNOWMAN = this
            call this.AddTexture(Texture.ICE_CROWN_1)

            set this = thistype.Create("buildings\\other\\Merchant\\Merchant.mdx")
            set thistype.STUFF = this
            call this.AddTexture(Texture.BACKGROUND)
            call this.AddTexture(Texture.GOBLIN)
            call this.AddTexture(Texture.SHADOW)
            call this.AddTexture(Texture.STUFF)
            call this.AddTexture(Texture.STUFF2)

            set this = thistype.Create("buildings\\other\\Tavern\\Tavern.mdx")
            set thistype.TAVERN = this
            call this.AddTexture(Texture.BACKGROUND)
            call this.AddTexture(Texture.TAVERN)

            set this = thistype.Create("Units\\Other\\Tower\\Tower.mdx")
            set thistype.TOWER = this
            call this.AddTexture(Texture.ARCANE_VAULT)
            call this.AddTexture(Texture.TOWER)

        //Other
        set this = thistype.Create("Other\\EffectSizer\\EffectSizer.mdx")
        set thistype.EFFECT_SIZER = this

        set this = thistype.Create("Other\\FireTail\\FireTail.mdx")
        set thistype.FIRE_TAIL = this
        call this.AddTexture(Texture.RED_GLOW3)
        call this.AddTexture(Texture.RIBBON_NE_RED2)

        set this = thistype.Create("Other\\HeroRevival\\HeroRevival.mdx")
        set thistype.HERO_REVIVAL = this
        call this.AddTexture(Texture.YELLOW_GLOW2)
        call this.AddTexture(Texture.YELLOW_STAR_DIM)

        set this = thistype.Create("Environment\\LargeBuildingFire\\LargeBuildingFire0.mdx")
        set thistype.LARGE_FIRE = this
        call this.AddTexture(Texture.CLOUD_SINGLE)
        call this.AddTexture(Texture.CLOUDS_8X8)
        call this.AddTexture(Texture.CLOUDS_8X8_MOD_FIRE)

        set this = thistype.Create("Environment\\LargeBuildingFire\\LargeBuildingFire1.mdx")
        set thistype.LARGE_FIRE2 = this
        call this.AddTexture(Texture.CLOUD_SINGLE)
        call this.AddTexture(Texture.CLOUDS_8X8)
        call this.AddTexture(Texture.CLOUDS_8X8_MOD_FIRE)

        set this = thistype.Create("Environment\\LargeBuildingFire\\LargeBuildingFire2.mdx")
        set thistype.LARGE_FIRE3 = this
        call this.AddTexture(Texture.CLOUD_SINGLE)
        call this.AddTexture(Texture.CLOUDS_8X8)

        set this = thistype.Create("Environment\\SmallBuildingFire\\SmallBuildingFire0.mdx")
        set thistype.SMALL_FIRE = this
        call this.AddTexture(Texture.CLOUD_SINGLE)
        call this.AddTexture(Texture.CLOUDS_8X8)
        call this.AddTexture(Texture.CLOUDS_8X8_MOD_FIRE)

        set this = thistype.Create("Environment\\SmallBuildingFire\\SmallBuildingFire1.mdx")
        set thistype.SMALL_FIRE2 = this
        call this.AddTexture(Texture.CLOUD_SINGLE)
        call this.AddTexture(Texture.CLOUDS_8X8)
        call this.AddTexture(Texture.CLOUDS_8X8_MOD_FIRE)

        set this = thistype.Create("Environment\\SmallBuildingFire\\SmallBuildingFire2.mdx")
        set thistype.SMALL_FIRE3 = this
        call this.AddTexture(Texture.CLOUD_SINGLE)
        call this.AddTexture(Texture.CLOUDS_8X8)

        call Game.DebugMsg("model")
    endmethod

    static method Init takes nothing returns nothing
        call Code.Run(function thistype.Init_Executed)

        call PreloadEnd(99999.)
    endmethod
endstruct