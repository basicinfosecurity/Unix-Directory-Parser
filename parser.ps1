$directory_list = gc $($args[0])

$extensions = @(".png", ".gif",".bmp", ".jpeg", ".jpg", ".ttf", ".woff",".woff2",".mov",".avi",".mp4",".wmv",".mp3",".svg")

$parsed = @()
$base = $null

foreach($item in $directory_list){
	$stripped = $item.Trim()
	if($stripped.startswith("/")){
		$base = $stripped -replace ':$',''
		if($base[-1] -ne "/"){
			$base = $base + "/"
		}
		if(!($parsed -contains $base)){
			$parsed+=($base)
		}
	}
	elseif($stripped.startswith("total")){
		continue
	}
	else{
		$filename = $stripped.split(" ")[-1]
		$extension = [IO.Path]::GetExtension($filename)
		if($filename -eq "." -or $filename -eq ".."){
			continue
		}
		if(!($extensions -contains $extension)){
			$tmp = $base + $filename
			if(!($parsed -contains $tmp)){
				$parsed+=($tmp)
			}
		}
	}
}
$outfile = "parsed.txt"
if($args[1]){
	$outfile = $args[1]
}

$parsed | out-file $outfile
