<?php
	function moveFile($slk, $i){
        while (!feof($slk) && ($i > 0)){
            $i = $i - 1;
            $line = fgets($slk);
        }

		return $line;
	}

	function getVal($path, $entry){
		$slk = $GLOBALS["slk".$path];

		$c = 0;
		fseek($slk, 0);

		moveFile($slk, 2);

		while (!$x && ($c < $GLOBALS["blockSize".$slk])){
			$i = 0;
			$line = moveFile($slk, 1);

			while (substr($line, $i, 1) <> "X"){
				$i = $i + 1;
			}

			$i2 = 1;

			while (substr($line, $i + $i2, 1) <> ";"){
				$i2 = $i2 + 1;
			}

			$x = substr($line, $i + 1, $i2 - 1);

			$i = $i + $i2 + 1;

			while (substr($line, $i, 1) <> "K"){
				$i = $i + 1;
			}

			$i = $i + 2;

			if (substr($line, $i, strlen($line) - 3 - $i) <> $entry){
				$c = $c + 1;
				$x = "";
			}
		}

		if (!$x){
			echo "Could not find entry type \"".$entry."\" in ".$path."<br>";

			return;
		}

		fseek($slk, $GLOBALS["start".$slk]);

		$c = 0;

		while (!$found && ($c < $GLOBALS["blockSize".$slk])){
			$i = 0;
			$line = moveFile($slk, 1);

			while (substr($line, $i, 1) <> "X"){
				$i = $i + 1;
			}

			$i2 = 1;

			while (substr($line, $i + $i2, 1) <> ";"){
				$i2 = $i2 + 1;
			}

			if (substr($line, $i + 1, $i2 - 1) == $x){
                $i = $i + $i2 + 1;

                while (substr($line, $i, 1) <> "K"){
                    $i = $i + 1;
                }

				$i = $i + 1;

				if (substr($line, $i, 1) == "\""){
					$line = substr($line, $i + 1, strlen($line) - 4 - $i);
				}
				else{
					$line = substr($line, $i, strlen($line) - 1 - $i);
				}

				echo "read ".$entry." --> ".$line."<br>";

				return $line;
			}
		}

		echo "Could not find entry ".$entry." for ".$_POST["origId"];

		return;
	}

	function isFloat($val){
		while ((substr($val, $i, 1) <> ".") && ($i < strlen($val))){
			$i = $i + 1;
		}

		if ($i < strlen($val)){
			return 1;
		}

		return 0;
	}

	function getValDefault($path, $x, $def){
		if ($path == "Profile"){
			$slk = $GLOBALS["profile"];

			if ($slk){
				fseek($slk, $GLOBALS["startProfile"]);

				while (!feof($slk) && !$found && !$cancel){
					$line = fgets($slk);

					if (substr($line, 0, strlen($x)) == $x){
						$found = 1;
					}
					elseif ((substr($line, 0, 1) == "[") && (substr($line, 5, 1) == "]")){
						$cancel = 1;
					}
				}

				if ($found){
					$line = substr($line, strlen($x) + 1, strlen($line) - strlen($x) - 1);

					echo "read ".$line."<br>";

					return $line;
				}

				return $def;
			}
		}
		else{
            $path = "Slk/".$path;

            $slk = $GLOBALS["slk".$path];

            if ($slk && $GLOBALS["start".$slk]){
                $val = getVal($path, $x);

                if (isFloat($def) && !isFloat($val)){
                    return $val.".";
                }

                return $val;
            }
		}

		return $def;
	}

	function writeIf($cond, $val){
		if ($cond){
			return $val;
		}

		return "";
	}

	function getDefTypes(){
		$res = getValDefault("UnitBalance.slk", "defType", "");

		$res = "<option value='LIGHT'".writeIf($res == "small", " selected").">LIGHT</option>
               <option value='MEDIUM'".writeIf($res == "medium", " selected").">MEDIUM</option>
               <option value='LARGE'".writeIf($res == "large", " selected").">LARGE</option>
               <option value='FORT'".writeIf($res == "fort", " selected").">FORT</option>
               <option value='HERO'".writeIf($res == "hero", " selected").">HERO</option>
               <option value='UNARMORED'".writeIf($res == "none", " selected").">UNARMORED</option>
               <option value='DIVINE'".writeIf($res == "divine", " selected").">DIVINE</option>";

		return $res;
	}

	function getArmorSoundTypes(){
		$res = getValDefault("unitUI.slk", "armor", "");

		$res = "<option value='Ethereal'".writeIf($res == "Ethereal", " selected").">Ethereal</option>
		       <option value='Flesh'".writeIf($res == "Flesh", " selected").">Flesh</option>
		       <option value='Metal'".writeIf($res == "Metal", " selected").">Metal</option>
		       <option value='Stone'".writeIf($res == "Stone", " selected").">Stone</option>
		       <option value='Wood'".writeIf($res == "Wood", " selected").">Wood</option>";

		return $res;
    }

	function getAtkTypes(){
		$res = getValDefault("UnitWeapons.slk", "weapTp1", "");
		$homing = getValDefault("Profile", "MissileHoming", "");

		$res = "<option value='NORMAL'".writeIf(($res == "normal"), " selected").">NORMAL</option>
               <option value='MISSILE'".writeIf(($res == "missile") || ($res == "instant") && !$homing, " selected").">MISSILE</option>
               <option value='HOMING_MISSILE'".writeIf(($res == "missile") && $homing, " selected").">HOMING_MISSILE</option>
               <option value='ARTILLERY'".writeIf($res == "artillery", " selected").">ARTILLERY</option>";

		return $res;
	}

	function getDmgTypes(){
		$res = getValDefault("UnitWeapons.slk", "atkType1", "");

		$res = "<option value='NORMAL'".writeIf(($res == "normal"), " selected").">NORMAL</option>
               <option value='PIERCE'".writeIf(($res == "pierce"), " selected").">PIERCE</option>
               <option value='SIEGE'".writeIf(($res == "siege"), " selected").">SIEGE</option>
               <option value='MAGIC'".writeIf(($res == "magic"), " selected").">MAGIC</option>
               <option value='CHAOS'".writeIf(($res == "chaos"), " selected").">CHAOS</option>
               <option value='HERO'".writeIf(($res == "hero"), " selected").">HERO</option>
               <option value='SPELLS'".writeIf(($res == "spells"), " selected").">SPELLS</option>";

		return $res;
	}

	function getShadTypes(){
		$res = getValDefault("unitUI.slk", "buildingShadow", "");

		if ($res && ($res <> "_")){
			return $res;
		}

		$res = getValDefault("unitUI.slk", "unitShadow", "");

		if ($res){
			return $res;
		}

		return "NONE/NORMAL/FLY";
	}

	function getElevPts(){
		return (int)getValDefault("unitUI.slk", "elevPts", "0");
	}

	function getMoveTypes(){
		$res = getValDefault("UnitData.slk", "movetp", "");

		$res = "<option value='NONE'".writeIf(($res == ""), " selected").">NONE</option>
               <option value='FOOT'".writeIf(($res == "foot"), " selected").">FOOT</option>
               <option value='HORSE'".writeIf(($res == "horse"), " selected").">HORSE</option>
               <option value='FLY'".writeIf(($res == "fly"), " selected").">FLY</option>
               <option value='HOVER'".writeIf(($res == "hover"), " selected").">HOVER</option>
               <option value='FLOAT'".writeIf(($res == "float"), " selected").">FLOAT</option>
               <option value='AMPHIBIOUS'".writeIf(($res == "amph"), " selected").">AMPHIBIOUS</option>";

		return $res;
	}

	function loadSlk($path){
        $slk = fopen($path, "r");

        if (!$slk){
            echo "Could not open ".$path."<br>";

            return;
        }

        $GLOBALS["slk".$path] = $slk;

        $i = 0;
        $line = fgets($slk);
        $line = fgets($slk);

        while ((substr($line, $i, 1) <> "X") && ($i < strlen($line))){
            $i = $i + 1;
        }

        $i2 = $i + 1;
        $l = 0;

        while (substr($line, $i2, 1) <> ";"){
            $i2 = $i2 + 1;
            $l = $l + 1;
        }

		//(int)substr($line, $i + 1, $l);
        if ($path == "Slk/UnitAbilities.slk"){
            $cols = 7;
        }
        elseif ($path == "Slk/UnitBalance.slk"){
            $cols = 61;
        }
        elseif ($path == "Slk/UnitData.slk"){
            $cols = 31;
        }
        elseif ($path == "Slk/unitUI.slk"){
            $cols = 51;
        }
        elseif ($path == "Slk/UnitData.slk"){
             $cols = 31;
        }
        elseif ($path == "Slk/UnitWeapons.slk"){
            $cols = 77;
        }

        $line = fgets($slk);

        while ((substr($line, strlen($line) - 7, 4) <> $_POST["origId"]) && !feof($slk)){
            $line = moveFile($slk, 1);
        }

		if (feof($slk)){
			$GLOBALS["start".$slk] = 0;

			echo "Entry not found in ".$path."<br>";

			return;
		}
        echo "Loaded from ".$path."<br>";

		$GLOBALS["blockSize".$slk] = $cols;
        $GLOBALS["start".$slk] = ftell($slk);
	}

	function loadProfile($id){
		$i = 0;
		$profilePaths[0] = "Slk/HumanUnitFunc.txt";
		$profilePaths[1] = "Slk/NeutralUnitFunc.txt";
		$profilePaths[2] = "Slk/NightElfUnitFunc.txt";
		$profilePaths[3] = "Slk/OrcUnitFunc.txt";
		$profilePaths[4] = "Slk/UndeadUnitFunc.txt";
		$profilePaths[5] = "Slk/CampaignUnitFunc.txt";

        while (!$found && ($i < 6)){
        	$slk = fopen("$profilePaths[$i]", "r");

			if ($slk){
                while (!$found && !feof($slk)){
                    $line = fgets($slk);

                    if (substr($line, 0, 6) == "[".$id."]"){
                        $found = 1;
                    }
                }

				if (!$found){
					fclose($slk);
				}
            }
            else{
            	echo "Could not open ".$profilePaths[$i]."<br>";
            }

			$i = $i + 1;
        }

		if ($found){
			$GLOBALS["profile"] = $slk;
			$GLOBALS["startProfile"] = ftell($slk);
			echo "Loaded from Profile";
		}
		else{
			echo "Profile not found";
		}
	}

	function closePath($path){
		fclose($GLOBALS["slk".$path]);
	}

	function closeAll(){
		closePath("Slk/UnitAbilities.slk");
		closePath("Slk/UnitBalance.slk");
		closePath("Slk/UnitData.slk");
		closePath("Slk/unitUI.slk");
		closePath("Slk/UnitWeapons.slk");

		fclose($GLOBALS["profile"]);
	}

	function loadFromId($id){
		echo "Try to load ".$id."<br>"."<br>";

		loadSlk("Slk/UnitAbilities.slk");
		loadSlk("Slk/UnitBalance.slk");
		loadSlk("Slk/UnitData.slk");
		loadSlk("Slk/unitUI.slk");
		loadSlk("Slk/UnitWeapons.slk");

		loadProfile($id);
    }

	if ($_POST["origId"] <> ""){
		loadFromId($_POST["origId"]);
	}

	echo "<form action='LoadSlk.php' method='post' target='input'><input type='Submit' name='LoadFromId' value='Load from Id'><input type='Text' name='origId' value='' size='' maxlength=''></form>";

	echo "<form action='UnitGen.php' method='post' target='result'>
       <b>General</b>
       <table border='1' bordercolordark='#FFFFFF'>
                 <tr><td>Name</td><td><input type='Text' name='objectName' value='' size='' maxlength=''></td></tr>
                 <tr><td>Id</td><td><input type='Text' name='id' value='' size='' maxlength=''></td>
                 <tr><td>Var</td><td><input type='Text' name='varName' value='' size='' maxlength=''</td>
                 <tr><td>Class</td><td><select name='cl' size='1'>
                 <option value='DEFENDER'>DEFENDER</option>
                 <option value='ATTACKER'>ATTACKER</option>
                 <option value='OTHER'>OTHER</option></select></td></tr>
                 <tr><td>Standard Scale</td><td><input type='Text' name='standardScale' value='".getValDefault("unitUI.slk", "scale", "1.")."' size='' maxlength=''></td>
       </table>

       <b>Armor</b>
       <table border='1' bordercolordark='#FFFFFF'>
               <tr><td>Defense Type</td><td><select name='defType' size='1'>
               ".getDefTypes()."</td></tr>
               <tr><td>Amount</td><td><input type='Text' name='armorAmount' value='".getValDefault("UnitBalance.slk", "def", "0.")."' size='' maxlength=''></td></tr>
               <tr><td>Sound Type</td><td><select name='armorSound' size='1'>
               ".getArmorSoundTypes()."</td></tr>
       </table>

       <b>Attack</b>
       <table border='1' bordercolordark='#FFFFFF'>
                <tr><td>Type</td><td><select name='atkType' size='1'>
               ".getAtkTypes()."</td></tr>
               <tr><td>Cooldown</td><td><input type='Text' name='atkCooldown' value='".getValDefault("UnitWeapons.slk", "cool1", "0.")."' size='' maxlength=''></td></tr>
               <tr><td>Range</td><td><input type='Text' name='atkRange' value='".getValDefault("UnitWeapons.slk", "rangeN1", "0.")."' size='' maxlength=''></td></tr>

               <tr><td>Range Buffer</td><td><input type='Text' name='atkBuffer' value='".getValDefault("UnitWeapons.slk", "RngBuff1", "0.")."' size='' maxlength=''></td></tr>
               <tr><td>Targets</td><td><input type='Text' name='atkTargets' value='".getValDefault("UnitWeapons.slk", "targs1", "")."' size='' maxlength=''></td></tr>
               <tr><td>Wait after</td><td><input type='Text' name='atkWaitAfter' value='0.' size='' maxlength=''></td></tr>
               <tr><td>Sound</td><td><input type='Text' name='atkSound' value='".getValDefault("UnitWeapons.slk", "weapType1", "")."' size='' maxlength=''></td></tr>
               <tr><td>Acq Range</td><td><input type='Text' name='acqRange' value='".getValDefault("UnitWeapons.slk", "acquire", "0.")."' size='' maxlength=''></td></tr>
               <tr><td>Own Combat Flags</td><td><input type='Text' name='combatFlags' value='".getValDefault("UnitData.slk", "targType", "")."' size='' maxlength=''></td></tr>
       </table>
       <b>Attack Missile</b>
       <table border='1' bordercolordark='#FFFFFF'>
                <tr><td>Model</td><td><input type='Text' name='misModel' value='".getValDefault("Profile", "Missileart", "")."' size='' maxlength=''></td></tr>
                <tr><td>Speed</td><td><input type='Text' name='misSpeed' value='".getValDefault("Profile", "Missilespeed", "")."' size='' maxlength=''></td></tr>
                <tr><td>Arc</td><td><input type='Text' name='misArc' value='".getValDefault("Profile", "Missilearc", "")."' size='' maxlength=''></td></tr>
       </table>

       <b>Damage</b>
       <table border='1' bordercolordark='#FFFFFF'>
               <tr><td>Type</td><td><select name='dmgType' size='1'>
               ".getDmgTypes()."</td></tr>
               <tr><td>Amount + Dice x Side</td><td><input type='Text' name='dmgAmount' value='".getValDefault("UnitWeapons.slk", "dmgplus1", "0")."' size='' maxlength=''> + <input type='Text' name='dmgDice' value='".getValDefault("UnitWeapons.slk", "dice1", "0")."' size='' maxlength=''> x <input type='Text' name='dmgSide' value='".getValDefault("UnitWeapons.slk", "sides1", "0")."' size='' maxlength=''></td></tr>
               <tr><td>Wait before</td><td><input type='Text' name='dmgPt' value='".getValDefault("UnitWeapons.slk", "dmgpt1", "0.")."' size='' maxlength=''></td></tr>
       </table>

       <b>Arts</b>
       <table border='1' bordercolordark='#FFFFFF'>
                <tr><td>Model</td><td><input type='Text' name='model' value='".getValDefault("unitUI.slk", "file", "")."' size='' maxlength=''></td></tr>
                <tr><td>AttachPts</td><td><input type='Text' name='attachPts' value='".getValDefault("Profile", "Attachmentlinkprops", "")."' size='' maxlength=''></td></tr>
                <tr><td>Anims</td><td><input type='Text' name='anims' value='".getValDefault("Profile", "animProps", "")."' size='' maxlength=''></td></tr>
                <tr><td>AttachMods</td><td><input type='Text' name='attachMods' value='".getValDefault("Profile", "Attachmentanimprops", "")."' size='' maxlength=''></td></tr>
                <tr><td>Bones</td><td><input type='Text' name='bones' value='".getValDefault("Profile", "Boneprops", "")."' size='' maxlength=''></td></tr>
                <tr><td>Icon</td><td><input type='Text' name='icon' value='".getValDefault("Profile", "Art", "")."' size='' maxlength=''></td></tr>
                <tr><td>Move Interpolation</td><td><input type='Text' name='moveInterpolation' value='".getValDefault("UnitData.slk", "orientInterp", "0")."' size='' maxlength=''></td></tr>
                <tr><td>Color</td><td><input type='Text' name='colorRed' value='".getValDefault("unitUI.slk", "red", "255")."' size='' maxlength=''></td><td><input type='Text' name='colorGreen' value='".getValDefault("unitUI.slk", "green", "255")."' size='' maxlength=''></td><td><input type='Text' name='colorBlue' value='".getValDefault("unitUI.slk", "blue", "255")."' size='' maxlength=''></td><td><input type='Text' name='colorAlpha' value='255' size='' maxlength=''></td></tr>
                <tr><td>Scale</td><td><input type='Text' name='scale' value='".getValDefault("unitUI.slk", "modelScale", "1.")."' size='' maxlength=''></td></tr>
                <tr><td>Sel Scale</td><td><input type='Text' name='selScale' value='".getValDefault("unitUI.slk", "scale", "1.")."' size='' maxlength=''></td></tr>
                <tr><td>Soundset</td><td><input type='Text' name='soundset' value='".getValDefault("unitUI.slk", "unitSound", "")."' size='' maxlength=''></td></tr>
                <tr><td>ImpactZ</td><td><input type='Text' name='impactZ' value='".getValDefault("UnitWeapons.slk", "impactZ", "0.")."' size='' maxlength=''></td></tr>
                <tr><td>OutpactX</td><td><input type='Text' name='outpactX' value='".getValDefault("UnitWeapons.slk", "launchX", "0.")."' size='' maxlength=''></td></tr>
                <tr><td>OutpactY</td><td><input type='Text' name='outpactY' value='".getValDefault("UnitWeapons.slk", "launchY", "0.")."' size='' maxlength=''></td></tr>
                <tr><td>OutpactZ</td><td><input type='Text' name='outpactZ' value='".getValDefault("UnitWeapons.slk", "launchZ", "0.")."' size='' maxlength=''></td></tr>
                <tr><td><b>Shadow</b></td></tr>
                <tr><td><table border='1' bordercolordark='#FFFFFF'>
                         <tr><td>Path</td><td><input type='Text' name='shadPath' value='".getShadTypes()."' size='' maxlength=''></td></tr>
                         <tr><td>Width</td><td><input type='Text' name='shadWidth' value='".getValDefault("unitUI.slk", "shadowW", "0.")."' size='' maxlength=''></td></tr>
                         <tr><td>Height</td><td><input type='Text' name='shadHeight' value='".getValDefault("unitUI.slk", "shadowH", "0.")."' size='' maxlength=''></td></tr>
                         <tr><td>Offset X</td><td><input type='Text' name='shadOffsetX' value='".getValDefault("unitUI.slk", "shadowX", "0.")."' size='' maxlength=''></td></tr>
                         <tr><td>Offset Y</td><td><input type='Text' name='shadOffsetY' value='".getValDefault("unitUI.slk", "shadowY", "0.")."' size='' maxlength=''></td></tr>
                </table></td></tr>
       </table>

       <b>Animation</b>
       <table border='1' bordercolordark='#FFFFFF'>
                <tr><td>Blend</td><td><input type='Text' name='blend' value='".getValDefault("unitUI.slk", "blend", "0.")."' size='' maxlength=''></td></tr>
                <tr><td>Cast Pt</td><td><input type='Text' name='castPt' value='".getValDefault("UnitWeapons.slk", "castpt", "0.")."' size='' maxlength=''></td></tr>
                <tr><td>Cast Back</td><td><input type='Text' name='castBack' value='".getValDefault("UnitWeapons.slk", "castbsw", "0.")."' size='' maxlength=''></td></tr>
                <tr><td>Walk</td><td><input type='Text' name='walk' value='".getValDefault("unitUI.slk", "walk", "0.")."' size='' maxlength=''></td></tr>
                <tr><td>Run</td><td><input type='Text' name='run' value='".getValDefault("unitUI.slk", "run", "0.")."' size='' maxlength=''></td></tr>
       </table>

       <b>Stats</b>
       <table border='1' bordercolordark='#FFFFFF'>
                <tr><td>Life</td><td><input type='Text' name='life' value='100.' size='' maxlength=''></td><td>Regen</td><td><input type='Text' name='lifeRegen' value='1.' size='' maxlength=''></td></tr>
                <tr><td>Mana</td><td><input type='Text' name='mana' value='0.' size='' maxlength=''></td><td>Regen</td><td><input type='Text' name='manaRegen' value='0.' size='' maxlength=''></td></tr>
                <tr><td>SpellPower</td><td><input type='Text' name='spellPower' value='15.' size='' maxlength=''></td></tr>
                <tr><td>Sight</td><td><input type='Text' name='sight' value='1400.' size='' maxlength=''></td><td>Night</td><td><input type='Text' name='sightN' value='800.' size='' maxlength=''></td></tr>
       </table>

       <b>Misc</b>
       <table border='1' bordercolordark='#FFFFFF'>
                <tr><td>Collision</td><td><input type='Text' name='collision' value='".getValDefault("UnitBalance.slk", "collision", "0.")."' size='' maxlength=''></td></tr>
                <tr><td>Death Time</td><td><input type='Text' name='deathTime' value='".getValDefault("UnitData.slk", "death", "0.")."' size='' maxlength=''></td></tr>
                <tr><td>Exp</td><td><input type='Text' name='exp' value='10' size='' maxlength=''></td></tr>
                <tr><td>Gold</td><td><input type='Text' name='gold' value='20' size='' maxlength=''></td></tr>
                <tr><th colspan='2'><table border='1' bordercolordark='#FFFFFF'>
	                <tr><th colspan='4'><b>Elevation</b></th></tr>
                         <tr><td>Pts</td><td><input type='Text' name='elevPts' value='".getElevPts()."' size='' maxlength=''></td><td>Radius</td><td><input type='Text' name='elevRad' value='".getValDefault("unitUI.slk", "elevRad", "0.")."' size='' maxlength=''></td></tr>
                         <tr><td>Max Roll</td><td><input type='Text' name='roll' value='".getValDefault("unitUI.slk", "maxRoll", "0.")."' size='' maxlength=''></td><td>Max Pitch</td><td><input type='Text' name='pitch' value='".getValDefault("unitUI.slk", "maxPitch", "0.")."' size='' maxlength=''></td></tr>
                </table></th></tr>
       </table>

       <b>Movement</b>
       <table border='1' bordercolordark='#FFFFFF'>
               <tr><td>Type</td><td><select name='moveType' size='1'>
               ".getMoveTypes()."</td></tr>
               <tr><td>Speed</td><td><input type='Text' name='moveSpeed' value='".getValDefault("UnitBalance.slk", "spd", "0.")."' size='' maxlength=''></td></tr>
               <tr><td>Turn Rate</td><td><input type='Text' name='turnRate' value='".getValDefault("UnitData.slk", "turnRate", "0.")."' size='' maxlength=''></td></tr>
       </table>
       <input type='Submit' name='Finish' value='Finish'></td></tr>
</form>";

	closeAll();
?>
