<#
    From Wheat to Toast

    By Lengthybread409#
#>
######################################################
<#  Setting up Powershell for the first time.

    In an admin prompt run this command:
    Set-ExecutionPolicy RemoteSigned

    Powershell scripts will work after this.
#>
######################################################
<#  Setting up this script
    
    Move this script to the "Halo The Master Chief Collection"
    under the commons folder in steam.

    mcclauncher.exe will be in the same folder
#>
######################################################
<#  Run Powershell
    
    When viewing the folder on explorer, click at the top left where it says "File"
    Then click "Open Windows Powershell"

    A blue screen will show. Its not the blue screen of death. This one is good!
#>
######################################################
<#  Running the script 
    
    How to run the script, Type this (Pressing Tab will autocomplete)
    .\MapReName.ps1 

    A list of your maps will show with an Index number and details.
    Use the index to select the map you want like dis,
    .\MapReName 1

    You will be asked N/D/S,
    N: Change Name
    D: Change Discription
    S: Save changes

    THATS ALL FOLKS
#>

param ([int]$index=-1,[string]$preopt)

function global:Reload{
    $maps = $null
    H3
} 

function global:H3{
    try{
    if ($maps -ne $null){
        return $false
    }}catch{}
    Write-Host "Creating Map List, Please wait."
    $Global:maps = @()
    $list = (Get-ChildItem "./halo3\map_variants\*.mvar" -File) + (Get-ChildItem "$env:APPDATA\..\LocalLow\MCC\LocalFiles\*\halo3\Map\*.mvar" -File)

    $map_ls = @()

    foreach($map in 0..($list.Count-1)){
        #Name
        $type = 0
        $temp = [System.Text.Encoding]::ASCII.GetString([System.IO.File]::ReadAllBytes($list[$map]),0x49,160)
        if([int]$temp[0] -eq 0){
            try{
                $temp = [System.Text.Encoding]::ASCII.GetString([System.IO.File]::ReadAllBytes($list[$map]),0x95,160)
            }catch{
                $temp = [System.Text.Encoding]::ASCII.GetString([System.IO.File]::ReadAllBytes($list[$map]),0x95,80)
            }
            $type = 1
        }
        $name_T = 0;$aaa = 0;$aa=0;
        $name = "";$Discription="";
        0..($temp.length-2) | %{
            if(!($_ % 2) -or ($name_T -eq 1)){
                if([int]$temp[$_-1]  -eq 0 -and [int]$temp[$_] -eq 0 -and $name_T -eq 0){
                    $name_T = 1
                    $aaa = $_+1
                }
                elseif($temp[$_] -eq 0 -and $name_T -eq 1 -and $aa -eq 1){
                    $name_T = 2
                    foreach ($let in $temp[$aaa..($_-1)]) {$Discription += [char]$let}
                    if ($type -eq 1){$type = $_+0x95} 
                }
                if($name_T -eq 0){
                    $name += $temp[$_]
                }
                if($name_T -eq 1 -and $temp[$_] -ne 0 -and $aa -eq 0){
                    $aa = 1
                    $aaa = $_
                }
            }
        }
        
        #base
        $base = "UnKnown";$id = 0;
        if ($type -eq 0){
            #$id = [bitconverter]::ToInt16(([System.IO.File]::ReadAllBytes($list[$map])[0x122,0x123]),0)
        }
        else{
            #$id = [bitconverter]::ToInt16(([System.IO.File]::ReadAllBytes($list[$map])[$type+0x3d,$type+0x3e]),0)
            $temp = [System.IO.File]::ReadAllBytes($list[$map])[$type..($type+0x50)]
            1..($temp.Count-5) |  %{
                #Write-Host $($temp[$_+2]) $($temp[$_+3]) $($temp[$_+4])
                if([int]$temp[$_+2]  -eq 0x07 -and [int]$temp[$_+3] -eq 0xff -and [int]$temp[$_+4] -eq 0xf8){
                    $id = [bitconverter]::ToInt16(($temp[$_],$temp[$_+1]),0)
                }
            }
        }
        switch($id){
    -0001{$base="Assembly"}
    -0001{$base="Assembly"}

    -10751{$base="Avalanche"}
    -0001{$base="Avalanche"}
    
    -0001{$base="Blackout"}
    -0001{$base="Blackout"}
    
    -0001{$base="Citadel."}
    -0001{$base="Citadel."}

    22530{$base="Cold Storage"}
    -0001{$base="Cold Storage"}
    
    -20476{$base="Construct"}
    -0001{$base="Construct"}
    
    30725{$base="Epitaph"}
    30725{$base="Epitaph"}

    -8191 {$base="Foundry"}
    -32761{$base="Foundry"}
    
    -0001{$base="Ghost Town"}
    -0001{$base="Ghost Town"}

    16385{$base="Guardian"}
    5{$base="Guardian"}
    
    16395{$base="Heretic"}
    16395{$base="Heretic"}

    13825{$base="High Ground"}
    -0001{$base="High Ground"}
    
    -0001{$base="Isolation"}
    -0001{$base="Isolation"}

    7680{$base="Last Resort"}
    -0001{$base="Last Resort"}
    
    -0001{$base="Longshore"}
    -0001{$base="Longshore"}
    
    -4091{$base="Narrows"}
    -4091{$base="Narrows"}
    
    -0001{$base="Orbital"}
    -0001{$base="Orbital"}
    
    -0001{$base="Rat's Nest"}
    -0001{$base="Rat's Nest"}
    
    -9726{$base="Sandbox"}
    26635{$base="Sandbox"}

    -28671{$base="Sandtrap"}
    16390{$base="Sandtrap"}

    26625{$base="Snowbound"}
    -24571{$base="Snowbound"}

    -26111{$base="Standoff"}
    26630{$base="Standoff"}

    -31231{$base="The Pit"}
    6150{$base="The Pit"}
    
    -0001{$base="Valhalla"}
    -0001{$base="Valhalla"}
    default{$base = $id}
        }
        if($name[0] -ne '?' -or $name[0] -ne '$' -or $Discription[0] -eq '?' -or $Discription[0] -ne '?' -or $Discription[0] -ne '$'){
            $map_ls += [PSCustomObject]@{
                Name = $name.trim()
                File = $list[$map]
                Discription = $Discription.trim()
                NameOG = $name.trim()
                DiscriptionOG = $Discription.trim()
                Edit = $false
                Type = $type
                Index =$map
                Base = $base
            }
        }
    }
    $Global:maps = $map_ls
    return $true
}


$a = h3

if ($index -ge 0){
    write-Host ""
    Write-Host "`t$($maps[$index].name)" -ForegroundColor Green
    write-Host "`t$($maps[$index].Discription)" -ForegroundColor Cyan
    Write-Host "`tAltered: " -NoNewline;Write-Host "$($maps[$index].edit)    " -ForegroundColor Magenta -NoNewline; Write-Host "$($maps[$index].file)" -ForegroundColor DarkRed
    write-Host ""
    Write-Host $input.Length

    if($preopt -eq ""){
        $input = (Read-Host "Options N/D/S").toupper()
    }
    else{
        $input = $preopt
    }
    switch($input){
        'N'{
            $name = $maps[$index].name
            while ($true){
                $name = Read-Host "What is the new name"
                if($name.Length -lt 16){
                    $maps[$index].name = $name
                    $maps[$index].edit = $true
                    break
                }
                elseif ($name -eq ""){
                    break
                }
                else{
                    write-Host "Over by $($name.Length-15) charicters"
                }
            }
        }
        'D'{
            $Discription = $maps[$index].Discription
            while ($true){
                $discription = Read-Host "What is the new discription"
                if($discription.Length -lt 128){
                    $maps[$index].Discription = $discription
                    $maps[$index].edit = $true
                    break
                }
                elseif ($name -eq ""){
                    break
                }
                else{
                    write-Host "Over by $($discription.Length-127) charicters"
                }
            }
        }
        'S'{
            $save_list = ($maps | Where-Object -FilterScript {$_.edit})
            foreach ($emap in $save_list){
                if($emap.type -eq 0){
                    $file = [System.IO.File]::ReadAllBytes($emap.file)
                    $name = @()
                    0..14 | %{if($emap.name.ToCharArray()[$_] -ne $mull){$name += ([int]$emap.name.ToCharArray()[$_],0)}else{$name += (0,0)}}
                    $Discription = @()
                    0..126 | %{if($emap.Discription.ToCharArray()[$_] -ne $mull){$Discription += [int]$emap.Discription.ToCharArray()[$_]}else{$Discription += 0}}
                    $name += 0;$Discription += 0;
                    $filen = $file[0..0x48] + $name + $Discription + $file[0xe8..0x150] + $name + $Discription + $file[0x1f0..($file.Count-1)]

                    [io.file]::WriteAllBytes("$($emap.File.DirectoryName)\$($emap.Name)_A.mvar",$filen)
                    $maps[$maps.file.IndexOf($emap.file)].edit = $false
                }
                else{
                    $file = [System.IO.File]::ReadAllBytes($emap.file)
                    $name = @()
                    $emap.name.ToCharArray() | %{$name += ([int]$_,0)}
                    $Discription = @()
                    $emap.Discription.ToCharArray() | %{$Discription += [int]$_}
                    $name += 0;$Discription += 0;

                    $end = 0

                    ($emap.type+1)..($file.Count-1) | %{
                        if($file[$_-3] -ne 0 -and $file[$_-2] -eq 0 -and $file[$_-1] -eq 0 -and $file[$_] -eq 0){
                            $end = $_-1
                        }
                        elseif($file[$_] -ne 0){
                            $end = $_
                        }
                    }

                    $filen = $file[0..0x94] + $name + $Discription + $file[($emap.type+1)..$end]

                    $filen[0x87] = ($file[0x87]-($emap.nameOG.length*2)-$emap.DiscriptionOG.Length)+$emap.Name.Length*2+$emap.Discription.Length

                    [io.file]::WriteAllBytes("$($emap.File.DirectoryName)\$($emap.Name)_B.mvar",$filen)

                    $maps[$maps.file.name.IndexOf($emap.file.Name)].edit = $false
                }
            }

        }
        default{Write-Host "Unknown option"}
    }
    write-Host ""
    Write-Host "`t$($maps[$index].name)" -ForegroundColor Green
    write-Host "`t$($maps[$index].Discription)" -ForegroundColor Cyan
    Write-Host "`tAltered: " -NoNewline;Write-Host "$($maps[$index].edit)    " -ForegroundColor Magenta -NoNewline; Write-Host "$($maps[$index].file)" -ForegroundColor DarkRed
    write-Host ""
}
else{
    0..($maps.Count-1) | %{
        $maps[$_] | select -Property Index,Name,Discription,Edit
    }
}