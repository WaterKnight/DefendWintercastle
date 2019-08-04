//! import "D:\Warcraft III\Maps\DWC\Scripts\root.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\AI\Boost.page\Boost.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\AI\BouncyBomb.page\BouncyBomb.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\AI\BurningSpirit.page\BurningSpirit.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\AI\ChaosBall.page\ChaosBall.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\AI\Header.page\CastSpell.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\AI\Heal.page\Heal.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\AI\HealExplosion.page\HealExplosion.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\AI\Knockout.page\Knockout.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\AI\Medipack.page\Medipack.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\AI\Purge.page\Purge.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Commands\CharacterSpeech.page\CharacterSpeech.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Debug\herospell.page\herospell.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Debug\loadmem.page\loadmem.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Debug\memtabletest.page\memtabletest.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Debug\say.page\say.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Debug\sethp.page\sethp.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Debug\setid.page\setid.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Debug\setlvl.page\setlvl.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Header\Basic.page\Basic.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Header\BoolExpr.page\BoolExpr.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Header\Buff.page\Buff.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Header\Camera.page\Camera.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Header\Constants.page\Constants.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Header\Destructable.page\Destructable.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Header\Dialog.page\Dialog.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Header\Effect.page\Effect.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Header\Event.page\Event.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Header\EventCombination.page\EventCombination.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Header\Game.page\Game.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Header\Group.page\Group.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Header\Item.page\Item.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Header\ItemObjectCreation.page\ItemObjectCreation.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Header\ItemType.page\ItemType.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Header\Lightning.page\Lightning.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Header\LimitOp.page\LimitOp.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Header\Loading.page\Loading.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Header\Math.page\Math.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Header\Memory.page\Memory.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Header\Misc.page\Misc.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Header\Missile.page\Missile.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Header\Model.page\Model.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Header\Multiboard.page\Multiboard.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Header\Order.page\Order.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Header\Preload.page\Preload.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Header\Primitive.page\Primitive.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Header\Region.page\Region.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Header\Sound.page\Sound.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Header\Spell.page\Spell.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Header\SpellObjectCreation.page\SpellObjectCreation.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Header\Spot.page\Spot.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Header\StringData.page\StringData.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Header\TextTag.page\TextTag.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Header\Timer.page\Timer.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Header\Trigger.page\Trigger.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Header\Unit.page\Unit.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Header\UnitObjectCreation.page\UnitObjectCreation.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Header\UnitType.page\UnitType.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Header\User.page\User.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Header\WeatherEffect.page\WeatherEffect.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Init\AI.page\AI.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Init\Commands.page\Commands.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Init\Header.page\Header.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Init\Items.page\Items.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Init\Main.page\Main.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Init\Misc.page\Misc.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Init\Other.page\Other.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Init\Speeches.page\Speeches.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Init\Spells.page\Spells.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Init\Units.page\Units.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Items\Act1\Mallet.page\Mallet.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Items\Act1\PenguinFeather.page\PenguinFeather.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Items\Act1\RabbitsFoot.page\RabbitsFoot.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Items\Act1\RamblersStick.page\RamblersStick.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Items\Act2\GruntAxe.page\GruntAxe.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Items\Act2\RobynsHood.page\RobynsHood.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Items\Act3\ElfinDagger.page\ElfinDagger.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Items\Act3\SpearsOfTheDefender.page\SpearOfTheDefender.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Items\MeteoriteShard.page\MeteoriteShard.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\ItemTypes\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\ItemTypes\Act1\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\ItemTypes\Act2\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\ItemTypes\Act3\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\ItemTypes\Spell\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Misc\Act.page\Act.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Misc\ActUpgrades.page\ActUpgrades.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Misc\AfterIntro.page\AfterIntro.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Misc\Artifact.page\Artifact.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Misc\BrazierOracle.page\BrazierOracle.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Misc\CameraQuickPosition.page\CameraQuickPosition.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Misc\CreepBuffs\MarkOfThePaw.page\MarkOfThePaw.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Misc\CreepSet.page\CreepSet.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Misc\DefenderSpawn.page\DefenderSpawn.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Misc\Difficulty.page\Difficulty.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Misc\Drop.page\Drop.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Misc\Explosive.page\Explosive.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Misc\GoldCoin.page\GoldCoin.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Misc\HeroRevival.page\HeroRevival.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Misc\HeroSelection.page\HeroSelection.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Misc\Hint.page\Hint.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Misc\HorseRide.page\HorseRide.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Misc\Infoboard.page\Infoboard.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Misc\Infocard.page\Infocard.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Misc\Intro.page\Intro.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Misc\Level.page\Level.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Misc\Lumber.page\Lumber.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Misc\Nullboard.page\Nullboard.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Misc\OptionsBoard.page\OptionsBoard.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Misc\rpgcam.page\rpgcam.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Misc\Rune.page\Rune.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Misc\Snowmen.page\Snowmen.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Misc\Spawn.page\Spawn.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Misc\SpellPurchase.page\SpellPurchase.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Misc\UnitNameTag.page\UnitNameTag.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Misc\UnitStatus.page\UnitStatus.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Misc\VictoryRush.page\VictoryRush.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Misc\Waypoint.page\Waypoint.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Misc\Zoom.page\Zoom.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Speeches\AxeFighter.page\AxeFighter.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Speeches\Balduir.page\Balduir.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\Boost.page\Boost.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\Boost.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\ChaosBall.page\ChaosBall.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\ChaosBall.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\EnergyCharge.page\EnergyCharge.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\EnergyCharge.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\EnergyCharge.page\EnergyCharge.struct\Target.struct\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\FuzzyAttack.page\FuzzyAttack.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\FuzzyAttack.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\GreenNova.page\GreenNova.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\GreenNova.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\GreenNova.page\GreenNova\Buff.struct\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\Heal.page\Heal.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\Heal.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\HealExplosion.page\HealExplosion.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\HealExplosion.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\IceArrows.page\IceArrows.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\IceArrows.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\LightningShield.page\LightningShield.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\LightningShield.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\LunarRestoration.page\LunarRestoration.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\LunarRestoration.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\LunarRestoration.page\LunarRestoration.struct\Revival.struct\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\Purge.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\Purge.page\Purge.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\SoakingPoison.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\SoakingPoison.page\SoakingPoison.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\SoakingPoison.page\SoakingPoison.struct\Target.struct\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\Stampede.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act1\Stampede.page\Stampede.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\Barrage.page\Barrage.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\Barrage.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\BouncyBomb.page\BouncyBomb.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\BouncyBomb.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\BurningOil.page\BurningOil.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\BurningOil.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\ChainLightning.page\ChainLightning.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\ChainLightning.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\Cleavage.page\Cleavage.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\Cleavage.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\Cleavage.page\Cleavage.struct\Wave.struct\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\ColdResistance.page\ColdResistance.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\ColdResistance.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\DeathAxe.page\DeathAxe.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\DeathAxe.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\DrumRoll.page\DrumRoll.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\DrumRoll.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\DrumRoll.page\DrumRoll.struct\Target.struct\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\EnvenomedSpears.page\EnvenomedSpears.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\EnvenomedSpears.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\EnvenomedSpears.page\EnvenomedSpears.struct\Target.struct\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\Knockout.page\Knockout.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\Knockout.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\Knockout.page\Knockout.struct\Target.struct\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\Medipack.page\Medipack.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\Medipack.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\MutingShout.page\MutingShout.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\MutingShout.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\Realplex.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\Realplex.page\Realplex.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\SerpentWard.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\SerpentWard.page\SerpentWard.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\SpiritWolves.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\SpiritWolves.page\SpiritWolves.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\Stormbolt.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\Stormbolt.page\Stormbolt.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\SummonMinions.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Act2\SummonMinions.page\SummonMinions.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Artifacts\BatSwarm.page\BatSwarm.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Artifacts\BatSwarm.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Artifacts\BatSwarm.page\orig\BatSwarm.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Artifacts\MagicBottle.page\MagicBottle.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Artifacts\MagicBottle.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Artifacts\MagicBottle.page\MagicBottle.struct\Buff.struct\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Artifacts\RedwoodValkyrie.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Artifacts\RedwoodValkyrie.page\RedwoodValkyrie.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Artifacts\SapphireblueDagger.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Artifacts\SapphireblueDagger.page\SapphireblueDagger.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Artifacts\SilentBoots.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Artifacts\SilentBoots.page\SilentBoots.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Artifacts\TaintedLeaf.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Artifacts\TaintedLeaf.page\TaintedLeaf.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Artifacts\Thunderbringer.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Artifacts\Thunderbringer.page\Thunderbringer.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Artifacts\VioletEarring.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Artifacts\VioletEarring.page\VioletEarring.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Artifacts\Vomit.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Artifacts\Vomit.page\Vomit.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Artifacts\WhiteStaff.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Artifacts\WhiteStaff.page\WhiteStaff.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Artifacts\WhiteStaff.page\WhiteStaff.struct\Target.struct\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Amaterasu.page\Amaterasu.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Amaterasu.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Amaterasu.page\Amaterasu.struct\Target.struct\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\ArcticWolf.page\ArcticWolf.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\ArcticWolf.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Avatar.page\Avatar.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Avatar.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\BattleRage.page\BattleRage.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\BattleRage.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\BattleRage.page\BattleRage.struct\Target.struct\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Bubble.page\Bubble.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Bubble.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Conflagration.page\Conflagration.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Conflagration.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Crippling.page\Crippling.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Crippling.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Crippling.page\Crippling.struct\Target.struct\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\DeprivingShock.page\DeprivingShock.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\DeprivingShock.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\DeprivingShock.page\DeprivingShock.struct\Buff.struct\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Doppelganger.page\Doppelganger.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Doppelganger.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Doppelganger.page\Doppelganger.struct\BigBoom.struct\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Doppelganger.page\Doppelganger.struct\FireBuff.struct\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Doppelganger.page\Doppelganger.struct\IceBuff.struct\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\EmphaticBite.page\EmphaticBite.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\EmphaticBite.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\EmphaticBite.page\EmphaticBite.struct\Buff.struct\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\FairysTears.page\FairysTears.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\FairysTears.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\FairysTears.page\FairysTears.struct\Target.struct\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\GarmentsOfTheSalamander.page\GarmentsOfTheSalamander.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\GarmentsOfTheSalamander.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\HandOfNature.page\HandOfNature.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\HandOfNature.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\HandOfNature.page\HandOfNature.struct\Buff.struct\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\HandOfNature.page\HandOfNature.struct\Heal.struct\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\HopNDrop.page\HopNDrop.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\HopNDrop.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\HopNDrop.page\HopNDrop.struct\SetMines.struct\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\HopNDrop.page\HopNDrop.struct\SetMines.struct\Mine.struct\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Infection.page\Infection.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Infection.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Infection.page\Infection.struct\Cone.struct\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Infection.page\Infection.struct\Summon.struct\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Infection.page\Infection.struct\Summon.struct\FuniculusUmbilicalis.struct\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Infection.page\Infection.struct\Target.struct\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\KhakiRecovery.page\KhakiRecovery.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\KhakiRecovery.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\ManaLaser.page\ManaLaser.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\ManaLaser.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\ManaLaser.page\ManaLaser.struct\Revert.struct\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\NegationWave.page\NegationWave.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\NegationWave.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\PandaPaw.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\PandaPaw.page\PandaPaw.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\PandaPaw.page\PandaPaw.struct\Arrival.struct\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\PandaPaw.page\PandaPaw.struct\Arrival.struct\Target.struct\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\RazorBlade.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\RazorBlade.page\RazorBlade.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\RazorBlade.page\RazorBlade.struct\Drawback.struct\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\RelentlessShiver.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\RelentlessShiver.page\RelentlessShiver.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\RelentlessShiver.page\RelentlessShiver.struct\Buff.struct\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\RelentlessShiver.page\RelentlessShiver.struct\Missile.struct\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\RigorMortis.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\RigorMortis.page\RigorMortis.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\SakeBomb.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\SakeBomb.page\SakeBomb.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\SleepingDraft.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\SleepingDraft.page\SleepingDraft.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\SummonPolarBear.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\SummonPolarBear.page\SummonPolarBear.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\SummonPolarBear.page\SummonPolarBear.struct\Summon.struct\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Susanoo.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Susanoo.page\Susanoo.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\TempestStrike.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\TempestStrike.page\TempestStrike.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\TempestStrike.page\TempestStrike.struct\CriticalAttacks.struct\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Tsukuyomi.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Tsukuyomi.page\Tsukuyomi.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Tsukuyomi.page\Tsukuyomi.struct\Relocate.struct\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Tsukuyomi.page\Tsukuyomi.struct\Target.struct\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\WanShroud.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\WanShroud.page\WanShroud.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\WanShroud.page\WanShroud.struct\Target.struct\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\WaterBindings.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\WaterBindings.page\WaterBindings.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\WaterBindings.page\WaterBindings.struct\Summon.struct\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\WaterBindings.page\WaterBindings.struct\Summon.struct\Lariat.struct\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Zodiac.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Zodiac.page\Zodiac.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Hero\Zodiac.page\Zodiac.struct\SpeedBuff.struct\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Item\Act1\BoomerangStone.page\BoomerangStone.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Item\Act1\BoomerangStone.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Item\Act1\EyeOfTheFlame.page\EyeOfTheFlame.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Item\Act1\EyeOfTheFlame.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Item\Act1\ScrollOfProtection.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Item\Act1\ScrollOfProtection.page\ScrollOfProtection.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Item\Act1\ScrollOfProtection.page\ScrollOfProtection.struct\Target.struct\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Item\Act1\TeleportScroll.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Item\Act1\TeleportScroll.page\TeleportScroll.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Item\EmergencyProvisions.page\EmergencyProvisions.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Item\EmergencyProvisions.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Item\FireWater.page\FireWater.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Item\FireWater.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Item\HerbalOintment.page\HerbalOintment.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Item\HerbalOintment.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Item\IceTea.page\IceTea.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Item\IceTea.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Item\Meat.page\Meat.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Item\Meat.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Item\TropicalRainbow.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Item\TropicalRainbow.page\TropicalRainbow.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\ArcticBlink.page\ArcticBlink.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\ArcticBlink.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\BigHealingWave.page\BigHealingWave.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\BigHealingWave.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\BurningSpirit.page\BurningSpirit.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\BurningSpirit.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\BurningSpiritMeteorite.page\BurningSpiritMeteorite.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\BurningSpiritMeteorite.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\BurnLumber.page\BurnLumber.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\BurnLumber.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\CoreFusion.page\CoreFusion.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\CoreFusion.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\DarkAttack.page\DarkAttack.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\DarkAttack.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\FountainAura.page\FountainAura.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\FountainAura.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\FountainHeal.page\FountainHeal.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\FountainHeal.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\FrostAttack.page\FrostAttack.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\FrostAttack.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\Invisibility.page\Invisibility.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\Invisibility.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\Invulnerability.page\Invulnerability.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\Invulnerability.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\Lapidation.page\Lapidation.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\Lapidation.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\LightningAttack.page\LightningAttack.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\LightningAttack.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\RefreshMana.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\RefreshMana.page\RefreshMana.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\RevealAura.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\RevealAura.page\RevealAura.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\TorchLight.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Misc\TorchLight.page\TorchLight.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\Barrier.page\Barrier.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\Barrier.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\Blizzard.page\Blizzard.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\Blizzard.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\ChillyBreath.page\ChillyBreath.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\ChillyBreath.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\Fireball.page\Fireball.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\Fireball.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\FlameTongue.page\FlameTongue.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\FlameTongue.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\FrozenStar.page\FrozenStar.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\FrozenStar.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\GhostSword.page\GhostSword.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\GhostSword.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\HeatExplosion.page\HeatExplosion.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\HeatExplosion.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\IceBlock.page\IceBlock.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\IceBlock.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\Severance.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\Severance.page\Severance.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\SnowySphere.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\SnowySphere.page\SnowySphere.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\VividMeteor.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\VividMeteor.page\VividMeteor.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\WarmthMagnetism.page\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Spells\Purchasable\WarmthMagnetism.page\WarmthMagnetism.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\System\Meteorite.page\Meteorite.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\TrashBin\A.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\TrashBin\B.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\TrashBin\C.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\TrashBin\CameraSmoothing.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\TrashBin\ChangeZoom.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\TrashBin\CriticalAttacks.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\TrashBin\EbonyBow.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\TrashBin\HeroRevival2.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\TrashBin\IceLance.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\TrashBin\Missile Kopieren Kopieren.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\TrashBin\MissileOld.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\TrashBin\Multiplex.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\TrashBin\PlaceKeg.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\TrashBin\RaiseDead.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\TrashBin\Ride.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\TrashBin\Score.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\TrashBin\Severance2.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\TrashBin\Stampede2.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\TrashBin\UnholyEgg.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\TrashBin\UnitList.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\TrashBin\Zodiac2.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Units\FlyingPenguin.page\FlyingPenguin.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Units\Library.page\Library.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\Units\Sebastian.page\Sebastian.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\UnitTypes\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\UnitTypes\Heroes\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\UnitTypes\Other\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\UnitTypes\Other\DefenderSpawns\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\UnitTypes\Spawns\Act1\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\UnitTypes\Spawns\Act1\Creeps\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\UnitTypes\Spawns\Act2\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\UnitTypes\Spawns\Bonus\obj.j"
//! import "D:\Warcraft III\Maps\DWC\Scripts\UnitTypes\Summons\obj.j"
