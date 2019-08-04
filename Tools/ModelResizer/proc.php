<?php
	function belongsToNumber($c){
		return (($c == "-") || ($c == ".") || ($c == "0") || ($c == "1") || ($c == "2") || ($c == "3") || ($c == "4") || ($c == "5") || ($c == "6") || ($c == "7") || ($c == "8") || ($c == "9"));
	}

	function replaceNumbers($line){
		$i = 0;

		while ($i < strlen($line)){
			if (belongsToNumber(substr($line, $i, 1))){
				$c = 0;
				$s = $i;

				while (belongsToNumber(substr($line, $i, 1))){
					$c = $c + 1;
					$i = $i + 1;
				}

				$num = substr($line, $s, $c)*$_POST["factor"];

				$i = $s + strlen($num);
				$line = substr($line, 0, $s).$num.substr($line, $s + $c);
			}
			else {
				$i = $i + 1;
			}
		}

		return $line;
	}

	$file = $_FILES["inputFile"];

	if (!$file){
		echo "No file";

		return;
	}

	if ($_FILES["inputFile"]["error"] > 0){
		echo "Error: ".$_FILES["inputFile"]["error"]."<br>";

		return;
	}

	move_uploaded_file($_FILES["inputFile"]["tmp_name"], "input.txt");

	$file = fopen("input.txt", "r");

	if (!$file){
		echo "Could not open ".$_FILES["inputFile"]["name"];

		return;
	}

	$textfile = fopen("output.txt", "w+");

	$w = array();

	$w[0] = "PivotPoints";
	$w[1] = "Translation";

    while (!feof($file)){
	    $found = 0;
        $line = fgets($file);
        $wi = 1;

        while (!$found && !($wi < 0)){
            $c = 0;
            $i = 0;

            while ((substr($line, $i, strlen($w[$wi])) <> $w[$wi]) && ($i < strlen($line))){
                $c = $c + 1;
                $i = $i + 1;
            }

            if ($i < strlen($line)){
                $found = 1;
            }
            else{
                $wi = $wi - 1;
            }
        }

        if ($found){
            fwrite($textfile, $line);

            $c = 0;
            $i = 0;

            while (!belongsToNumber(substr($line, $i, 1))){
                $i = $i + 1;
            }

            $start = $i;

            while (belongsToNumber(substr($line, $i, 1))){
                $c = $c + 1;
                $i = $i + 1;
            }

            $i = $i - 1;

            $c = substr($line, $start, $c);

            if ($wi == 1){
            	$i = 0;
            	$line = fgets($file);

                fwrite($textfile, $line);

				while ((substr($line, $i, strlen("Bezier")) <> "Bezier") && (substr($line, $i, strlen("Hermite")) <> "Hermite") && ($i < strlen($line))){
					$i = $i + 1;
				}

				if ($i < strlen($line)){
                    $c = $c * 3;
				}
            }

            while ($c > 0){
                $i = 0;
                $c2 = 0;
                $line = fgets($file);

                while ((substr($line, $i, 1) <> "{") && ($i < strlen($line))){
                    $c2 = $c2 + 1;
                    $i = $i + 1;
                }

				if ($i < strlen($line)){
                    fwrite($textfile, substr($line, 0, $c2));

                    fwrite($textfile, replaceNumbers(substr($line, $i)));

                    $c = $c - 1;
                }
                else{
                	fwrite($textfile, $line);
                }
            }
        }
        else{
            fwrite($textfile, $line);
        }
    }

	fclose($file);
	fclose($textfile);

	$textfile = fopen("output.txt", "r");
	echo "<hr noshade size='1'>";

	while (!feof($textfile)){
		echo fgets($textfile)."<br>";
	}
?>


