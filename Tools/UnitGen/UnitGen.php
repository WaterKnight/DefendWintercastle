
    	<?php
    		function leftSub($val, $i){
    			return substr($val, 0, $i + 1);
    		}

    		function rightSub($val, $i){
    			return substr($val, $i, strlen($val) - $i);
    		}

            function writeLine($val){
            	if ($val == ""){
            		echo "<br>";

            		return;
            	}

                $i = 0;
                $replace = 0;
                $searchEnd = 0;

                while ($i < strlen($val)){
                    if ($searchEnd == 1){
                        if (substr($val, $i, 1) == ")"){
	                        $replace = 1;
                            $searchEnd = 0;
                            $val = leftSub($val, $i - 1)."\"".rightSub($val, $i + 1);
                        }
                    }
                    else{
                        if (substr($val, $i, 6) == "quote("){
                        	$replace = 1;
                            $searchEnd = 1;
                            $val = leftSub($val, $i - 1)."\"".rightSub($val, $i + 6);
                        }
                    }

					if ($replace){
						$replace = 0;
					}
					else{
                    	$i = $i + 1;
                	}
                }

				$i = 0;
				$replace = 0;

                while ($i < strlen($val)){
                    if (substr($val, $i, 1) == "%"){
                    	$i2 = $i + 1;
                    	$replace = 1;

                    	while (substr($val, $i2, 1) <> "\""){
							$i2 = $i2 + 1;
                        }

						$val = leftSub($val, $i - 1).$_POST[substr($val, $i + 1, $i2 - $i - 1)].rightSub($val, $i2);
                    }

					if ($replace){
						$replace = 0;
					}
					else{
                    	$i = $i + 1;
                	}
                }

				$i = 0;
				$replace = 0;

				while ($i < strlen($val)){
                	if (substr($val, $i, 4) == "\\\\\\\\"){
	                	$replace = 1;
	                	$val = leftSub($val, $i - 1)."\\\\".rightSub($val, $i + 4);
                	}

					if ($replace){
						$replace = 0;
					}
					else{
                    	$i = $i + 1;
                	}
                }
                echo "//! runtextmacro ".$val."<br>";
            }

            writeLine("Unit_Create(quote(/), quote(%varName), quote(%id), quote(%objectName), quote(false), quote(%cl), quote(%standardScale))");
            writeLine("");
            writeLine("Unit_SetArmor(quote(/), quote(%defType), quote(%armorAmount), quote(%armorSound))");
            writeLine("Unit_SetAttack(quote(/), quote(%atkType), quote(%atkCooldown), quote(%atkRange), quote(%atkBuffer), quote(%atkTargets), quote(%atkWaitAfter), quote(%atkSound))");
            if (($_POST["atkType"] == "MISSILE") || ($_POST["atkType"] == "HOMING_MISSILE") || ($_POST["atkType"] == "ARTILLERY")){
	            writeLine("Unit_SetAttackMissile(quote(/), quote(%misModel), quote(%misSpeed), quote(%misArc))");
            }
            writeLine("Unit_SetBlend(quote(/), quote(%blend))");
            writeLine("Unit_SetCasting(quote(/), quote(%castPt), quote(%castBack))");
            writeLine("Unit_SetCollisionSize(quote(/), quote(%collision))");
            writeLine("Unit_SetCombatFlags(quote(/), quote(%combatFlags), quote(%acqRange))");
            writeLine("Unit_SetDamage(quote(/), quote(%dmgType), quote(%dmgAmount), quote(%dmgDice), quote(%dmgSide), quote(%dmgWaitBefore))");
            writeLine("Unit_SetDeathTime(quote(/), quote(%deathTime))");
            writeLine("Unit_SetElevation(quote(/), quote(%elevPts), quote(%elevRad), quote(%roll), quote(%pitch))");
            writeLine("Unit_SetExp(quote(/), quote(%exp))");
            writeLine("Unit_SetIcon(quote(/), quote(%icon))");
            writeLine("Unit_SetLife(quote(/), quote(%life), quote(%lifeRegen))");
            if ($_POST["mana"] > 0){
            	writeLine("Unit_SetMana(quote(/), quote(%mana), quote(%manaRegen))");
            }
            writeLine("Unit_SetMissilePoints(quote(/), quote(%impactZ), quote(%outpactX), quote(%outpactY), quote(%outpactZ))");
            writeLine("Unit_SetModel(quote(/), quote(%model), quote(%attachPts), quote(%anims), quote(%attachMods), quote(%bones))");
            writeLine("Unit_SetMovement(quote(/), quote(%moveType), quote(%moveSpeed), quote(%turnRate), quote(%moveInterpolation), quote(%walk), quote(%run))");
            writeLine("Unit_SetScale(quote(/), quote(%scale), quote(%selScale))");
            writeLine("Unit_SetShadow(quote(/), quote(%shadPath), quote(%shadWidth), quote(%shadHeight), quote(%shadOffsetX), quote(%shadOffsetY))");
            writeLine("Unit_SetSight(quote(/), quote(%sightN), quote(%sight))");
            writeLine("Unit_SetSoundset(quote(/), quote(%soundset))");
            writeLine("Unit_SetSpellPower(quote(/), quote(%spellPower))");
            writeLine("Unit_SetSupply(quote(/), quote(%gold))");
            writeLine("Unit_SetVertexColor(quote(/), quote(%colorRed), quote(%colorGreen), quote(%colorBlue), quote(%colorAlpha))");
            writeLine("");
            writeLine("Unit_Finalize(quote(/))");
     	?>

