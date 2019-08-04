//! runtextmacro BaseStruct("Infocard", "INFOCARD")
    static string INTRODUCTION_DESCRIPTION = "About month ago, two peculiarly luminescent comets draught across the sky. While one featured a blue color and immediately vanished again behind the horizont, the red one bolted right into the capital of the united species of this planet. The shock wave tore apart buildings and roads and devastated most of the town. Many lost their lives."
    static string INTRODUCTION_DESCRIPTION2 = "As if this was not enough already, the sky darkened the day after and it became bitterly cold. Only the of a strange material consisting meteorite seemed to spend some even weirder soothing warmth. Though, the sky cleared a bit within time, the cold persisted and drove us to leave this place since a reconstruction appeared impossible before we would freeze to death. We fleed to the adjacent shire of count Dracula who there possesses a big castle which is directly worked into the Crystal Mountains. We also brought the meteorite with us whose still thermal energies emitting nature easily mesmerized us."
    static string INTRODUCTION_DESCRIPTION3 = "Since that time we try to get along with the small rations here and hope that the sun will return to us someday. Yet, the problems pile up: Besides the lack of food and the ongoing frost which we call the " + Char.QUOTE + "Big Winter" + Char.QUOTE + ", the surrounding forest's inhabitants are becoming very anxious, too. The last three weeks, there were twenty attacks and break-ins by wolves and other confused animals. Most of us refugees do not dare to leave the castle anymore. And how long will the strange stone keep on giving us strength and hope?"

    quest self

    static method Create takes boolean required, string title, string description, string iconPath returns thistype
        local thistype this = thistype.allocate()

		local quest self = CreateQuest()

        set this.self = self
        call QuestSetDescription(self, description)
        call QuestSetIconPath(self, iconPath)
        call QuestSetRequired(self, required)
        call QuestSetTitle(self, title)

        return this
    endmethod

    static string CREDITS_STRING

    static method EncolorName takes string value returns string
        return String.Color.Gradient(value, String.Color.DWC, String.Color.WHITE)
    endmethod

    static method AddLine takes string value returns nothing
        set thistype.CREDITS_STRING = thistype.CREDITS_STRING + value + Char.BREAK
    endmethod

    static method GetCreditsPart1 takes nothing returns string
        set thistype.CREDITS_STRING = ""

        call thistype.AddLine(String.Color.Do("Development:", String.Color.GOLD))
        call thistype.AddLine(thistype.EncolorName("WaterKnight"))
        call thistype.AddLine("")

        call thistype.AddLine(String.Color.Do("Imports:", String.Color.GOLD))
        call thistype.AddLine("Balduir: " + thistype.EncolorName("supertoinkz"))
        call thistype.AddLine("Bgm main: " + thistype.EncolorName("Aaron Krogh"))
        call thistype.AddLine("Bleeding: " + thistype.EncolorName("cotd333"))
        call thistype.AddLine("Console: " + thistype.EncolorName("Kwaliti"))
        call thistype.AddLine("Cityscape Set: " + thistype.EncolorName("xXm0RpH3usXx"))
        call thistype.AddLine("EnchantedArrowBlueEffect: " + thistype.EncolorName("nGy"))
        call thistype.AddLine("EnchantedArrowFlash: " + thistype.EncolorName("epsilon"))
        call thistype.AddLine("EnchantedArrowSkeleton: " + thistype.EncolorName("Wrathion"))
        call thistype.AddLine("GhostSword: " + thistype.EncolorName("jatter2"))
        call thistype.AddLine("Immortality: " + thistype.EncolorName("Daelin"))
        call thistype.AddLine("KhakiRecoveryVortex: " + thistype.EncolorName("Power"))
        call thistype.AddLine("Loadscreen Background: " + thistype.EncolorName("www.dreamscene.org"))
        call thistype.AddLine("OrcAssassin: " + thistype.EncolorName("Linaze"))
        call thistype.AddLine("")

        call thistype.AddLine("Everything may be modified in order to fit the map. Rather than exporting stuff you are interested in, refer to the credits.txt enclosed in the map archive.")

        return thistype.CREDITS_STRING
    endmethod

    static method GetCreditsPart2 takes nothing returns string
        set thistype.CREDITS_STRING = ""

        call thistype.AddLine(String.Color.Do("Imports:", String.Color.GOLD))
        call thistype.AddLine("Preview: " + thistype.EncolorName("www.albabackgrounds.com"))
        call thistype.AddLine("SakeBombBarrel: " + thistype.EncolorName("Dojo"))
        call thistype.AddLine("SakeBombMissile: " + thistype.EncolorName("RetroSexual"))
        call thistype.AddLine("SnowPine: " + thistype.EncolorName("Gottfrei"))
        call thistype.AddLine("SpearScout: " + thistype.EncolorName("Dojo"))
        call thistype.AddLine("TaintedLeafHeal: " + thistype.EncolorName("WILL_THE_ALMIGHTY"))
        call thistype.AddLine("Tarog: " + thistype.EncolorName("Dojo"))
        call thistype.AddLine("ThunderstrikeBolt: " + thistype.EncolorName("Tranquil"))
        call thistype.AddLine("ThunderstrikeCharge: " + thistype.EncolorName("marcus158"))
        call thistype.AddLine("ThunderstrikeNova: " + thistype.EncolorName("dhguardianes"))
        call thistype.AddLine("Tower: " + thistype.EncolorName("unknownczar"))
        call thistype.AddLine("VictorHammer: " + thistype.EncolorName("Thrikodius"))
        call thistype.AddLine("VioletEarringMissile: " + thistype.EncolorName("EdwardSwolenToe"))
        call thistype.AddLine("VioletEarringWeaponAttach: " + thistype.EncolorName("marcus158"))
        call thistype.AddLine("Wall: " + thistype.EncolorName("Rondo"))
        call thistype.AddLine("WallEnd: " + thistype.EncolorName("Rondo"))
        call thistype.AddLine("")

        call thistype.AddLine("Everything may be modified in order to fit the map. Rather than exporting stuff you are interested in, refer to the credits.txt enclosed in the map archive.")

        return thistype.CREDITS_STRING
    endmethod

    initMethod Init of Misc
        call thistype.Create(false, "Commands", CharacterSpeech.INPUT + " + any string: character speech" + Char.BREAK, "ReplaceableTextures\\CommandButtons\\BTNCommand.blp")
        call thistype.Create(false, "Credits Part 1", thistype.GetCreditsPart1(), "ReplaceableTextures\\CommandButtons\\BTNStormEarth&Fire.blp")
        call thistype.Create(false, "Credits Part 2", thistype.GetCreditsPart2(), "ReplaceableTextures\\CommandButtons\\BTNStormEarth&Fire.blp")
        call thistype.Create(true, "Introduction", thistype.INTRODUCTION_DESCRIPTION + Char.BREAK + thistype.INTRODUCTION_DESCRIPTION2 + Char.BREAK + thistype.INTRODUCTION_DESCRIPTION3, "ReplaceableTextures\\CommandButtons\\BTNPenguin.blp")
        call thistype.Create(true, "Objective", "Defend the meteorite at all costs!", "ReplaceableTextures\\CommandButtons\\BTNArcaneObservatory.blp")
        call thistype.Create(false, "Mechanics: Dying", "When you die, your hero is transformed into a ghost and teleported to the graveyard. There, you will regenerate mana to a maximum of 100 that you can then use to execute your ascension. You can freely move your spirit around but mana is only refreshed while staying at the graveyard. However, it might be useful to leave the area after being filled up to gain a better spot for reviving. The meteorite also has a spell to replenish mana that even works on ghosts.", "ReplaceableTextures\\CommandButtons\\BTNSacrifice.blp")
        call thistype.Create(false, "Mechanics: Meteorite", "Failing at protecting the meteorite above the center of the castle will result in your team's defeat." + Char.BREAK + "The highest player spot does have control of the meteorite and can thereby make use of it to cast some valuable spells.", "ReplaceableTextures\\CommandButtons\\BTNUndeadShrine.blp")
        call thistype.Create(false, "Mechanics: Flowers of Hope", "There is one sleeping seed in front of each of the castle's entries. A gentle touch wakes them up, granting you their sight, which detects even invisible entities and increases the loot you gain from killing foes. The flower will revert to its dormant mode after " + Real.ToIntString(Snowmen.DURATION) + " seconds.", "ReplaceableTextures\\CommandButtons\\BTNNatureTouchGrow.blp")
        call thistype.Create(false, "Mechanics: Special spawns' attributes", "The infoboard in the upper right corner of your screen shows, among other things, whether the current or next round's attacker spawns are of special behavior/have special abilities. These are, from left to right:" + Char.BREAK + "Melee: wave contains melee attackers" + Char.BREAK + "Ranged: wave contains ranged attackers" + Char.BREAK + "Magician: wave contains casters with magical abilities (this does not include physical abilities)" + Char.BREAK + Char.BREAK + "Runner: wave contains spawns that avoid aggressions and instead of this directly storm to the meteorite, they get easily dazed when being attacked from behind" + Char.BREAK + "Invis: wave contains invisible units" + Char.BREAK + "Magic immune: wave contains enemies that are immune to magical abilities" + Char.BREAK + "Kamikaze: wave contains suicidal spawns that detonate themselves to get rid of you!" + Char.BREAK + "Boss: boss wave, every sixth (last) wave of an chapter", "ReplaceableTextures\\CommandButtons\\BTNDarkSummoning.blp")
        call thistype.Create(false, "Mechanics: Spell purchase", "Your hero can only learn four characteristic spells plus the innate ability but further magical item scrolls can be purchased from the " + Library.SHOP.GetName() + ". In contrast to other charged items, one scroll's ability is displayed in the unit's command card (can be switched by pressing the item buttons) and these skills can be leveled up like other hero abilities.", "ReplaceableTextures\\CommandButtons\\BTNBansheeAdept.blp")

        call FlashQuestDialogButton()
    endmethod
endstruct