function Get-ParsedDirectory{
<#
.SYNOPSIS

Parses UNIX-style directory lists

.DESCRIPTION

Parses UNIX-style directory lists for directory listing. Removes media files (e.g. jpg, gif) to reduce wordlist size.

.PARAMETER Listfile

File name of the directory to be parsed.

.PARAMETER Outfile

File name of the parsed directory output. Defaults to "parsed.txt"
#>
	[CmdletBinding()] Param(
		[Parameter(Mandatory=$True)]
		[String]$Listfile,
		[String]$Outfile = "parsed.txt"
	)
	
	if(!(Test-Path($Listfile))){
		Write-Error "[!] Unable to resolve location of target file"
	}
	$directory_list = gc $Listfile

	$extensions = @(".png", ".gif",".bmp", ".jpeg", ".jpg", ".ttf", ".woff",".woff2",".mov",".avi",".mp4",".wmv",".mp3",".svg")

	$parsed = @()
	$base = $null
	
	Write-Host "[*] Parsing $Listfile"

	foreach($item in $directory_list){
		$stripped = $item.Trim()
		#~ if($stripped.startswith("/") -or $stripped.startswith("./")){
		if($stripped.startswith("/")){
			$base = $stripped -replace ':$',''
			if($base[-1] -ne "/"){
				$base = $base + "/"
			}
			if(!($parsed -contains $base)){
				Write-Host "[*] Found $base"
				$parsed+=($base)
			}
		}
		elseif($stripped.startswith("total")){
			continue
		}
		else{
			$filename =  Parse-FileName $stripped
			$extension = [IO.Path]::GetExtension($filename)
			if(!($extensions -contains $extension)){
				$tmp = $base + $filename
				if(!($parsed -contains $tmp)){
					$parsed+=($tmp)
				}
			}
		}
	}
	Write-Host "[*] Writing parsed items to $Outfile"
	Out-File -InputObject $parsed -FilePath $Outfile -Encoding "UTF8"
}

function Parse-FileName($filename){
	$fname = $filename.split(" ")[-1]
	if($fname -eq "." -or $fname -eq ".."){
		continue
	}
	return $fname
}
