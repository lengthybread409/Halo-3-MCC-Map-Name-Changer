<#
    From Wheat to Toast

    By Lengthybread409#
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
<#  Setting up Powershell for the first time for this script.

    Use the example above to run powershell as an admin in the folder where you place the script.
    Set-ExecutionPolicy Bypass -file ./MapSelect.ps1

    The Powershell scripts will work after this.
#>
######################################################
<#  Running the script 
    
    How to run the script, Type this (Pressing Tab will autocomplete) or run the file.
    .\MapReName.ps1
#>

param($answ1,$answ2)

#functions

function MoveMaps{
    try{
        mkdir -Path "./Master_List" -Force -ErrorAction Stop | Out-Null
    }catch{
        Write-Host "Unable to create the master folder. please ensure I can make folders"
        return -1
    }

    Write-Host "`nDo you want me to dig into your saved content?" -ForegroundColor Green
    $a = (Read-Host "(yes/no/y/n)").ToLower()
    $a = ($a -eq "yes" -or $a -eq "y")

    # Halo Reach
    try{
        mkdir -Path "./Master_List/R" -Force -ErrorAction Stop | Out-Null
        mkdir -Path "./Master_List/R/map_variants" -Force -ErrorAction Stop | Out-Null
        mkdir -Path "./Master_List/R/game_variants" -Force -ErrorAction Stop | Out-Null
    }catch{
        Write-Host "Unable to create the Reach folder. please ensure I can make folders"
        return -1
    }
    try{
        Get-Item -Path "./haloreach/map_variants/*" -Exclude @("*beaver_creek_cl_031.mvar","*damnation_cl_031.mvar","*hang_em_high_cl_031.mvar","*headlong_cl_031.mvar","*hr_forgeWorld_asylum.mvar","*hr_forgeWorld_hemorrhage.mvar","*hr_forgeWorld_paradiso.mvar","*hr_forgeWorld_pinnacle.mvar","*hr_forgeWorld_theCage.mvar","*prisoner_cl_031.mvar","*timberland_cl_031.mvar") | %{
            Move-item -LiteralPath "$_" -Destination "./Master_List/R/map_variants" -Force -ErrorAction Ignore
        }
        Get-Item -Path "./haloreach/game_variants/*" -Exclude @("*00_basic_editing_054.bin","*2nvasion_slayer_054.bin","*3nvasion_054.bin","*3nvasion_boneyard_054.bin","*3nvasion_dlc_054.bin","*3nvasion_spire_054.bin","*assault_054.bin","*assault_neutral_bomb_054.bin","*assault_one_bomb_054.bin","*ctf_054.bin","*ctf_1flag_054.bin","*ctf_multiteam_054.bin","*ctf_neutralflag_054.bin","*headhunter_054.bin","*headhunter_pro_054.bin","*hr_4v4_team_3plots_dmr_ar_500points_tu.bin","*hr_4v4_team_assault_dmr_ar_3points_tu.bin","*hr_4v4_team_crazyKing_dmr_ar_150points_tu.bin","*hr_4v4_team_headhunter_dmr_ar_50points_tu.bin","*hr_4v4_team_multiFlag_dmr_ar_3points_tu.bin","*hr_4v4_team_oddball_dmr_ar_150points_tu.bin","*hr_4v4_team_oneBomb_dmr_ar_3points_tu.bin","*hr_4v4_team_oneFlag_dmr_ar_4rounds_tu.bin","*hr_4v4_team_slayer_dmr_ar_50points_tu.bin","*hr_4v4_team_stockpile_dmr_ar_10points_tu.bin","*hr_4v4_team_territories_dmr_ar_4rounds_3min_tu.bin","*hr_ffa_juggernaut_ar_mag_150points_tu.bin","*hr_ff_classic_1set.bin","*hr_ff_generatorDefense_1set.bin","*hr_ff_gruntpocalypse_1round.bin","*hr_ff_rocketfight_1set.bin","*hr_ff_scoreAttack_1round.bin","*hr_ff_standard_1set.bin","*hr_ff_versus_2turns.bin","*infection_054.bin","*infection_safehavens_054.bin","*juggernaut_054.bin","*koth_054.bin","*koth_crazyking_054.bin","*oddball_054.bin","*race_054.bin","*rally_054.bin","*skeeball_default_054.bin","*slayer_054.bin","*slayer_classic_054.bin","*slayer_covy_054.bin","*slayer_pro_054.bin","*stockpile_054.bin","*SWAT_054.bin","*territories-3plot_054.bin","*territories-landgrab_054.bin","*territories_054.bin") | %{
            Move-item -LiteralPath "$_" -Destination "./Master_List/R/game_variants" -Force -ErrorAction Ignore
        }
        if($a){

            # Halo Reach local Maps
            $list = (Get-ChildItem "$env:APPDATA\..\LocalLow\MCC\LocalFiles\*\HaloReach\Map\*.mvar" -File)
            foreach($map in $list){
                #Name
                $name = ""
                $temp = [System.Text.Encoding]::ASCII.GetString([System.IO.File]::ReadAllBytes($map),0xc0,64)
                $ended = $true
                0..($temp.length-2) | %{
                    if(!($_ % 2) -and $ended){
                        if($temp[$_] -eq 0){$ended = $false}
                        else{$Name += [char]$temp[$_]}
                    }
                }
                $re = "[{0}]" -f [RegEx]::Escape( [IO.Path]::GetInvalidFileNameChars() -join '')
                Move-Item -LiteralPath "$($map.FullName)" -Destination "./Master_List/R/map_variants/$($Name -replace $re).mvar" -Force
            }

            # Halo Reach local game modes
            $list = (Get-ChildItem "$env:APPDATA\..\LocalLow\MCC\LocalFiles\*\HaloReach\GameType\*.bin" -File)
            foreach($game in $list){
                #Name
                $name = ""
                $temp = [System.Text.Encoding]::ASCII.GetString([System.IO.File]::ReadAllBytes($game),0xc0,64)
                $ended = $true
                0..($temp.length-2) | %{
                    if(!($_ % 2) -and $ended){
                        if($temp[$_] -eq 0){$ended = $false}
                        else{$Name += [char]$temp[$_]}
                    }
                }
                $re = "[{0}]" -f [RegEx]::Escape( [IO.Path]::GetInvalidFileNameChars() -join '')
                Move-Item -LiteralPath "$($game.FullName)" -Destination "./Master_List/R/game_variants/$($Name -replace $re).bin" -Force
            }
        }
    }catch{
        Write-Host "Unable to move maps to './Master_List/R'. please ensure I can move files"
        return -1
    }
    
    #<# Halo 2 A
    try{
        mkdir -Path "./Master_List/2" -Force -ErrorAction Stop | Out-Null
        mkdir -Path "./Master_List/2/map_variants" -Force -ErrorAction Stop | Out-Null
        mkdir -Path "./Master_List/2/game_variants" -Force -ErrorAction Stop | Out-Null
    }catch{
        Write-Host "Unable to create the Reach folder. please ensure I can make folders"
        return -1
    }
    try{
        Get-Item -Path "./groundhog/map_variants/*"  -Exclude @("*bloodline_classic.mvar","*lockdown_classic.mvar","*remnant_classic.mvar","*shrine_classic.mvar","*stonetown_classic.mvar","*warlord_classic.mvar","*zenith_classic.mvar") | %{
            Move-item -LiteralPath "$_" -Destination "./Master_List/2/map_variants" -Force -ErrorAction Ignore
        }
        Get-Item -Path "./groundhog/game_variants/*"  -Exclude @("*H2A_001_001_basic_editing_137.bin","*H2A_100_100_Slayer_BASE_TeamSlayer_137.bin","*H2A_100_150_Slayer_Pro_137.bin","*H2A_100_200_Slayer_FFA_137.bin","*H2A_100_250_Slayer_BR_137.bin","*H2A_100_300_Slayer_BR_FFA_137.bin","*H2A_100_350_Slayer_Elimination_137.bin","*H2A_100_400_Slayer_Phantom_Elimination_137.bin","*H2A_100_450_Slayer_Phantoms_137.bin","*H2A_100_500_Slayer_Team_Phantoms_137.bin","*H2A_100_550_Slayer_Rockets_137.bin","*H2A_100_600_Slayer_Snipers_137.bin","*H2A_100_650_Slayer_Team_Snipers_137.bin","*H2A_100_700_Slayer_Swords_137.bin","*H2A_100_750_Slayer_SWAT_137.bin","*H2A_100_800_Slayer_SWAT_Arsenal_137.bin","*H2A_200_100_CTF_BASE_MultiFlag_137.bin","*H2A_200_200_CTF_Classic_Flag_137.bin","*H2A_200_300_CTF_Classic_One_Flag_137.bin","*H2A_200_400_CTF_Classic_Tiny_137.bin","*H2A_200_500_CTF_One_Flag_137.bin","*H2A_200_600_CTF_Neutral_137.bin","*H2A_200_700_CTF_Gungoose_137.bin","*H2A_300_100_KOTH_Team_Crazy_King_137.bin","*H2A_300_200_KOTH_Crazy_King_137.bin","*H2A_300_300_KOTH_Team_King_137.bin","*H2A_300_400_KOTH_BASE_King_137.bin","*H2A_300_500_KOTH_Phantom_King_137.bin","*H2A_300_600_KOTH_Kill_From_The_Hill_137.bin","*H2A_400_100_ODDBALL_BASE_137.bin","*H2A_400_200_ODDBALL_Team_Ball_137.bin","*H2A_400_300_ODDBALL_Low_Ball_137.bin","*H2A_400_400_ODDBALL_Fiesta_137.bin","*H2A_400_500_ODDBALL_Swords_137.bin","*H2A_400_600_ODDBALL_Team_Swords_137.bin","*H2A_400_700_ODDBALL_Rockets_137.bin","*H2A_500_100_JUGGERNAUT_BASE_137.bin","*H2A_500_200_JUGGERNAUT_Ninjanaut_137.bin","*H2A_500_300_JUGGERNAUT_Phantom_Fodder_137.bin","*H2A_500_400_JUGGERNAUT_Dreadnaut_137.bin","*H2A_500_500_JUGGERNAUT_Multinaut_137.bin","*H2A_500_600_JUGGERNAUT_Nautacular_137.bin","*H2A_500_700_JUGGERNAUT_Juggernaut_Hunt_137.bin","*H2A_500_800_JUGGERNAUT_Nauticide_137.bin","*H2A_600_100_ASSAULT_BASE_MultiBomb_137.bin","*H2A_600_200_ASSAULT_Half_Time_137.bin","*H2A_600_300_ASSAULT_One_Bomb_137.bin","*H2A_600_400_ASSAULT_One_Bomb_Fast_137.bin","*H2A_600_500_ASSAULT_Blast_Resort_137.bin","*H2A_600_600_ASSAULT_Neutral_Bomb_137.bin","*H2A_700_100_TERRITORIES_BASE_3Plots_137.bin","*H2A_700_200_TERRITORIES_Incursion_137.bin","*H2A_700_300_TERRITORIES_Land_Grab_137.bin","*H2A_700_400_TERRITORIES_Gold_Rush_137.bin","*H2A_700_500_TERRITORIES_Control_Issues_137.bin","*H2A_700_600_TERRITORIES_Contention_137.bin","*H2A_700_700_TERRITORIES_Lockdown_137.bin","*H2A_800_100_INFECTION_BASE_137.bin","*H2A_800_200_INFECTION_Cadre_137.bin","*H2A_800_300_INFECTION_Flight_137.bin","*H2A_800_400_INFECTION_Hunted_137.bin","*H2A_900_100_RACE_BASE_137.bin","*H2A_900_200_RACE_Hornet_137.bin","*H2A_900_300_RACE_Rally_137.bin","*H2A_900_400_RACE_Gungoose_Gauntlet_137.bin","*H2A_900_500_RACE_Velocity_137.bin","*H2A_950_100_RICOCHET_BASE_137.bin","*H2A_950_200_RICOCHET_Half_Time_137.bin","*H2A_950_300_RICOCHET_Quickochet_137.bin","*H2A_950_400_RICOCHET_Multi_Team_137.bin") | %{
            Move-item -LiteralPath "$_" -Destination "./Master_List/2/game_variants" -Force -ErrorAction Ignore
        }
        if($a){

            # Halo 2 local Maps
            $list = (Get-ChildItem "$env:APPDATA\..\LocalLow\MCC\LocalFiles\*\Halo2A\Map\*.mvar" -File)
            foreach($map in $list){
                $temp = [bitconverter]::ToInt16(([System.IO.File]::ReadAllBytes($map)[0x7c,0x7d]),0)
                switch($temp){
                    -28754{$base="Skyward";$start=0xa1}
                    -20564{$base="Lockdown";$start=0xbd}
                    -12374{$base="Zenith";$start=0xbd}
                    -12369{$base="Awash";$start=0xa1}
                    -4179{$base="Bloodline";$start=0xbd}
                    4012{$base="Stonetown";$start=0xbd}
                    12207{$base="Nebula";$start=0xa1}
                    20397{$base="Warlord";$start=0xbd}
                    28587{$base="Shrine";$start=0xbd}
                    28592{$base="Remnant";$start=0xbd}
                    default{$base = $temp}
                }
                $temp = [System.IO.File]::ReadAllBytes($map)[$start..($start + 327)]
                $name_T = 0;$aaa = 0;$aa=@{}
                0..($temp.Count-3) | %{
                    if(($_ % 2)){
                        if([int]$temp[$_+1]  -eq 0 -and [int]$temp[$_+2] -eq 0 -and $name_T -eq 0){
                            $name_T = 1
                            $aa['a'] = $temp[0..($_)]
                            $aaa=$_+3
                        }
                        elseif([int]$temp[$_-1] -eq 0xd3 -and [int]$temp[$_] -eq 0xff -and $name_T -eq 1){
                            $name_T = 2
                            $aa['b'] = $temp[$aaa..($_-4)]
                        }
                    }
                }
                #Name
                $name = ""
                0..($aa['a'].Length-1) | %{
                    if(($_ % 2)){
                        #Write-Host "$_ $($aa['a'][$_]),$($aa['a'][$_-1]) $([bitconverter]::ToInt16(($($aa['a'][$_]),$($aa['a'][$_-1])),0)) $(H2Encode(($aa['a'][$_],$aa['a'][$_-1])))"
                        $name +=  "$(H2Encode(($aa['a'][$_],$aa['a'][$_-1])))"
                    }
                }
                $re = "[{0}]" -f [RegEx]::Escape( [IO.Path]::GetInvalidFileNameChars() -join '')
                Move-Item -LiteralPath "$($map.FullName))" -Destination "./Master_List/2/map_variants/$($Name -replace $re).mvar" -Force
            }

            # Halo 2 local game modes
            $list = (Get-ChildItem "$env:APPDATA\..\LocalLow\MCC\LocalFiles\*\Halo2A\GameType\*.bin" -File)
            foreach($game in $list){
                #Name
                $name = ""
                $temp = [System.Text.Encoding]::ASCII.GetString([System.IO.File]::ReadAllBytes($game),0xc0,64)
                $ended = $true
                0..($temp.length-2) | %{
                    if(!($_ % 2) -and $ended){
                        if($temp[$_] -eq 0){$ended = $false}
                        else{$Name += [char]$temp[$_]}
                    }
                }
                $re = "[{0}]" -f [RegEx]::Escape( [IO.Path]::GetInvalidFileNameChars() -join '')
                Move-Item -LiteralPath "$($game.FullName))" -Destination "./Master_List/2/game_variants/$($Name -replace $re).bin" -Force
            }
        }
    }catch{
        Write-Host "Unable to move maps to './Master_List/2'. please ensure I can move files"
        return -1
    }
    #>#
    
    #<# Halo 3
    try{
        mkdir -Path "./Master_List/2" -Force -ErrorAction Stop | Out-Null
        mkdir -Path "./Master_List/3/map_variants" -Force -ErrorAction Stop | Out-Null
        mkdir -Path "./Master_List/3/game_variants" -Force -ErrorAction Stop | Out-Null
    }catch{
        Write-Host "Unable to create the Reach folder. please ensure I can make folders"
        return -1
    }
    try{
        Get-Item -Path "./halo3/map_variants/*" -Exclude @("*h3_epitaph_epilogue_bruteshotFix.mvar","*h3_hardcoreConstruct.mvar","*h3_hardcoreConstruct_ts.mvar","*h3_hardcoreFoundry_amplified.mvar","*h3_hardcoreFoundry_onslaught.mvar","*h3_hardcoreGuardian.mvar","*h3_hardcoreHeretic.mvar","*h3_hardcoreHeretic_ffa.mvar","*h3_hardcoreNarrows.mvar","*h3_hardcorePit.mvar","*year2_sandtrap_sandtarp_012.mvar","*year2_snowbound_boundless_012.mvar","*year2_the_pit_pitstop_012.mvar") | %{
            Move-item -LiteralPath "$_" -Destination "./Master_List/3/map_variants" -Force -ErrorAction Ignore
        }
        Get-Item -Path "./halo3/game_variants/*" -Exclude @("00_sandbox-0_010.bin","*assault-0_010.bin","*assault-1_010.bin","*assault-2_010.bin","*assault-3_010.bin","*ctf-0_010.bin","*ctf-1_010.bin","*ctf-2_010.bin","*ctf-3_010.bin","*h3_2v2_team_hardcoreSlayer_25kills.bin","*h3_4v4_hardcoreBall_250points.bin","*h3_4v4_hardcoreFlag_heretic_5points.bin","*h3_4v4_hardcoreFlag_narrows_3points.bin","*h3_4v4_hardcoreFlag_pit_3points.bin","*h3_4v4_hardcoreKing_250points.bin","*h3_4v4_hardcoreSlayer_50kills.bin","*h3_4v4_hardcoreSlayer_construct_50kills.bin","*h3_ffa_hardcoreSlayer_12min.bin","*infection-0_010.bin","*infection-1_010.bin","*infection-2_010.bin","*infection-3_010.bin","*juggernaut-0_010.bin","*juggernaut-1_010.bin","*juggernaut-2_010.bin","*king of the hill-0_010.bin","*king of the hill-1_010.bin","*king of the hill-2_010.bin","*oddball-0_010.bin","*oddball-1_010.bin","*oddball-2_010.bin","*oddball-3_010.bin","*oddball-4_010.bin","*slayer-0_010.bin","*slayer-1_010.bin","*slayer-2_010.bin","*slayer-3_010.bin","*slayer-4_010.bin","*territories-0_010.bin","*territories-1_010.bin","*territories-2_010.bin","*vip-0_010.bin","*vip-1_010.bin","*vip-2_010.bin","*vip-3_010.bin") | %{
            Move-item -LiteralPath "$_" -Destination "./Master_List/3/game_variants" -Force -ErrorAction Ignore
        }
        if($a){

            # Halo 3 local Maps
            $list = (Get-ChildItem "$env:APPDATA\..\LocalLow\MCC\LocalFiles\*\Halo3\Map\*.mvar" -File)
            foreach($map in $list){
                $temp = [System.Text.Encoding]::ASCII.GetString([System.IO.File]::ReadAllBytes($map),0x49,160)
                if([int]$temp[0] -eq 0){
                    $temp = [System.Text.Encoding]::ASCII.GetString([System.IO.File]::ReadAllBytes($map),0x95,160)
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
                $re = "[{0}]" -f [RegEx]::Escape( [IO.Path]::GetInvalidFileNameChars() -join '')
                Move-Item -LiteralPath "$($map.FullName))" -Destination "./Master_List/3/map_variants/$($Name -replace $re).mvar" -Force
            }

            # Halo 3 local game modes
            $list = (Get-ChildItem "$env:APPDATA\..\LocalLow\MCC\LocalFiles\*\Halo3\GameType\*.bin" -File)
            foreach($game in $list){
                #Name
                $name = ""
                $temp = [System.Text.Encoding]::ASCII.GetString([System.IO.File]::ReadAllBytes($game),0x48,31)
                $ended = $true
                0..($temp.length-2) | %{
                    if(($temp[$_]) -and $ended){
                        if($temp[$_] -eq 0){$ended = $false}
                        else{$Name += [char]$temp[$_]}
                    }
                }
                $re = "[{0}]" -f [RegEx]::Escape( [IO.Path]::GetInvalidFileNameChars() -join '')
                Move-Item -LiteralPath "$($game.FullName))" -Destination "./Master_List/3/game_variants/$($Name -replace $re).bin" -Force
            }
        }
    }catch{
        Write-Host "Unable to move maps to './Master_List/3'. please ensure I can move files"
        return -1
    }
    #>#

    $master_list_exist = $true

    return 0
}

function HReach{
    Write-Host "Creating Map List, Please wait."
    $Global:maps = @()
    if($master_list_exist){
        $list = (Get-ChildItem "./Master_List\R\map_variants\*.mvar" -File)
    }else{
        $list = (Get-ChildItem ".\haloreach\map_variants\*.mvar" -File) + (Get-ChildItem "$env:APPDATA\..\LocalLow\MCC\LocalFiles\*\HaloReach\Map\*.mvar" -File)
    }

    $map_ls = @()

    foreach($map in 0..($list.Count-1)){try{

        #Name
        $name = ""
        $temp = [System.Text.Encoding]::ASCII.GetString([System.IO.File]::ReadAllBytes($list[$map]),0xc0,64)
        $ended = $true
        0..($temp.length-2) | %{
            if(!($_ % 2) -and $ended){
                if($temp[$_] -eq 0){$ended = $false}
                else{$Name += [char]$temp[$_]}
            }
        }

        #discription
        $Discription = ""
        $temp = [System.Text.Encoding]::ASCII.GetString([System.IO.File]::ReadAllBytes($list[$map]),448,256)
        $ended = $true
        0..($temp.length-2) | %{
            if(!($_ % 2) -and $ended){
                if($temp[$_] -eq 0){$ended = $false}
                else{$Discription += [char]$temp[$_]}
            }
        }
        
        #base
        $base = "UnKnown"
        $temp = [bitconverter]::ToInt16(([System.IO.File]::ReadAllBytes($list[$map])[0x6C,0x6d]),0)
        switch($temp){
    3006{$base = "Forge World"}
    1000{$base="Sword Base"}
    1020{$base="Countdown"}
    1035{$base="Boardwalk"}
    1040{$base="Zealot"}
    1055{$base="Powerhouse"}
    1080{$base="Boneyard"}
    1150{$base="Reflection"}
    1200{$base="Spire"}
    1500{$base="Condemned"}
    1510{$base="Highlands"}
    2001{$base="Anchor 9"}
    2002{$base="Breakpoint"}
    2004{$base="Tempest"}

    -32437{$base="Penance"}
    10010{$base="Penance"}
    -18610{$base="Battle Canyon"}
    10020{$base="Battle Canyon"}
    -27397{$base="Ridgeline"}
    10030{$base="Ridgeline"}
    -12478{$base="Breakneck"}
    10050{$base="Breakneck"}
    10060{$base="High Noon"}
    20473{$base="High Noon"}
    -18379{$base="Solitary"}
    10070{$base="Solitary"}

    default{$base = $temp}
        }
        
        if($name[0] -ne '?' -or $name[0] -ne '$' -or $Discription[0] -eq '?' -or $Discription[0] -ne '?' -or $Discription[0] -ne '$'){
            $map_ls += [PSCustomObject]@{
                Name = $name.trim()
                File = $list[$map].Name
                Discription = $Discription.trim()
                Base = $base
            }
        }
        }catch{
        Write-Host -ForegroundColor Red "ERROR with $($list[$map].name)"
        }
    }
    $Global:maps = $map_ls
    return $true
}

function H2{
    Write-Host "Creating Map List, Please wait."
    $Global:maps = @()
    
    if($master_list_exist){
        $list = (Get-ChildItem "./Master_List\2\map_variants\*.mvar" -File)
    }else{
        $list = (Get-ChildItem "./groundhog\map_variants\*.mvar" -File) + (Get-ChildItem "$env:APPDATA\..\LocalLow\MCC\LocalFiles\*\Halo2A\Map\*.mvar" -File)
    }

    $map_ls = @()

    foreach($map in 0..($list.Count-1)){try{

        #base
        $temp = [bitconverter]::ToInt16(([System.IO.File]::ReadAllBytes($list[$map])[0x7c,0x7d]),0)
        switch($temp){
    -28754{$base="Skyward";$start=0xa1}
    -20564{$base="Lockdown";$start=0xbd}
    -12374{$base="Zenith";$start=0xbd}
    -12369{$base="Awash";$start=0xa1}
    -4179{$base="Bloodline";$start=0xbd}
    4012{$base="Stonetown";$start=0xbd}
    12207{$base="Nebula";$start=0xa1}
    20397{$base="Warlord";$start=0xbd}
    28587{$base="Shrine";$start=0xbd}
    28592{$base="Remnant";$start=0xbd}
    default{$base = $temp}
        }

        $temp = [System.IO.File]::ReadAllBytes($list[$map])[$start..($start + 327)]
        $name_T = 0;$aaa = 0;$aa=@{}
        0..($temp.Count-3) | %{
            if(($_ % 2)){
                if([int]$temp[$_+1]  -eq 0 -and [int]$temp[$_+2] -eq 0 -and $name_T -eq 0){
                    $name_T = 1
                    $aa['a'] = $temp[0..($_)]
                    $aaa=$_+3
                }
                elseif([int]$temp[$_-1] -eq 0xd3 -and [int]$temp[$_] -eq 0xff -and $name_T -eq 1){
                    $name_T = 2
                    $aa['b'] = $temp[$aaa..($_-4)]
                }
            }
        }

        $name = ""
        0..($aa['a'].Length-1) | %{
            if(($_ % 2)){
                #Write-Host "$_ $($aa['a'][$_]),$($aa['a'][$_-1]) $([bitconverter]::ToInt16(($($aa['a'][$_]),$($aa['a'][$_-1])),0)) $(H2Encode(($aa['a'][$_],$aa['a'][$_-1])))"
                $name +=  "$(H2Encode(($aa['a'][$_],$aa['a'][$_-1])))"
            }
        }

        $Discription = ""
        0..($aa['b'].Length-1) | %{
            if(($_ % 2)){
                #Write-Host "$_ $($aa['b'][$_]),$($aa['b'][$_-1]) $([bitconverter]::ToInt16(($($aa['b'][$_]),$($aa['b'][$_-1])),0)) $(H2Encode(($aa['b'][$_],$aa['b'][$_-1])))"
                $Discription +=  "$(H2Encode(($aa['b'][$_],$aa['b'][$_-1])))"
            }
        }
        
        
        if($name[0] -ne '?' -or $name[0] -ne '$' -or $Discription[0] -eq '?' -or $Discription[0] -ne '?' -or $Discription[0] -ne '$'){
            $map_ls += [PSCustomObject]@{
                Name = $name.trim()
                File = $list[$map].Name
                Discription = $Discription.trim()
                Base = $base
            }
        }
        }catch{
        Write-Host -ForegroundColor Red "ERROR with $($list[$map].name)"
        }
    }
    $Global:maps = $map_ls
    return $true
}
function H2Encode($num){
    $x = [bitconverter]::ToInt16(($num[0],$num[1]),0)
    if ($x -lt 127){
        if($num[1] -eq 1){
            return [char]($x -shr 2)
        }
        else{
            return [char]($x)
        }
    }
    else{
        return [char]($x -shr 2)
    }
    <#
    $char = [bitconverter]::ToInt16(($num[0],$num[1]),0)
    switch($char){
        176{return ','}$
        384{return ' '}
        232{return 'z'}
        default{return [char]([bitconverter]::ToInt16(($num[0],$num[1]),0) -shr 2)}
    }
    #>
}

function H3{
    Write-Host "Creating Map List, Please wait."
    $Global:maps = @()
    
    if($master_list_exist){
        $list = (Get-ChildItem "./Master_List\3\map_variants\*.mvar" -File)
    }else{
        $list = (Get-ChildItem "./halo3\map_variants\*.mvar" -File) + (Get-ChildItem "$env:APPDATA\..\LocalLow\MCC\LocalFiles\*\halo3\Map\*.mvar" -File)
    }

    $map_ls = @()

    foreach($map in 0..($list.Count-1)){try{
        #Name
        $type = 0
        $temp = [System.Text.Encoding]::ASCII.GetString([System.IO.File]::ReadAllBytes($list[$map]),0x49,160)
        if([int]$temp[0] -eq 0){
            $temp = [System.Text.Encoding]::ASCII.GetString([System.IO.File]::ReadAllBytes($list[$map]),0x95,160)
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
            $id = [bitconverter]::ToInt16(([System.IO.File]::ReadAllBytes($list[$map])[0x122,0x123]),0)
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
    -22521{$base="Assembly"}
    -5631{$base="Assembly"}

    -10751{$base="Avalanche"}
    22535{$base="Avalanche"}
    
    8200{$base="Blackout"}
    2050{$base="Blackout"}
    
    -0001{$base="Citadel"}
    -7166{$base="Citadel"}

    22530{$base="Cold Storage"}
    24585{$base="Cold Storage"}
    
    -20476{$base="Construct"}
    11265{$base="Construct"}
    
    30725{$base="Epitaph"}
    24065{$base="Epitaph"}

    -8191 {$base="Foundry"}
    -32761{$base="Foundry"}
    
    19970{$base="Ghost Town"}
    14345{$base="Ghost Town"}

    16385{$base="Guardian"}
    5{$base="Guardian"}
    
    -0001{$base="Heretic"}
    16395{$base="Heretic"}

    13825{$base="High Ground"}
    -10236{$base="High Ground"}
    
    18945{$base="Isolation"}
    10245{$base="Isolation"}

    7680{$base="Last Resort"}
    30720{$base="Last Resort"}
    
    -18431{$base="Longshore"}
    -8186{$base="Longshore"}
    
    -4091{$base="Narrows"}
    31745{$base="Narrows"}
    
    -3071{$base="Orbital"}
    -12281{$base="Orbital"}
    
    17410{$base="Rat's Nest"}
    4105{$base="Rat's Nest"}
    
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
    
    20485{$base="Valhalla"}
    21505{$base="Valhalla"}
    default{$base = $id}
        }
        
        if($name[0] -ne '?' -or $name[0] -ne '$' -or $Discription[0] -eq '?' -or $Discription[0] -ne '?' -or $Discription[0] -ne '$'){
            $map_ls += [PSCustomObject]@{
                Name = $name.trim()
                File = $list[$map].Name
                Discription = $Discription.trim()
                Base = $base
            }
        }
        }catch{
        Write-Host -ForegroundColor Red "ERROR with $($list[$map].name)"
        }
    }
    $Global:maps = $map_ls
    return $true
}

function SelectMapRandom{
    $good_select = $false
    $select = $null
    while(!$good_select){
        if($filter -ne ""){
            $pick = $maps | Where-Object -FilterScript {$_.name -like "*$filter*"}
            if($pick.count -gt 1){
                $select = $pick[(Get-Random -Maximum $pick.Count)]
            }
            else {
                Write-Host "`nNo Maps found! Check Filter" -BackgroundColor Red
                return
            }
        }
        else{
            $select = $maps[(Get-Random -Maximum $maps.Count)]
        }

        write-Host ""
        write-Host "What about this:"
        Write-Host "`t$($select.name)" -ForegroundColor Green
        write-Host "`t$($select.Discription)" -ForegroundColor Cyan
        Write-Host "`tBase map: " -NoNewline;Write-Host "$($select.base)    " -ForegroundColor Magenta -NoNewline; Write-Host "$($select.file)" -ForegroundColor DarkRed
        write-Host ""
        
        $a = (Read-Host "(yes/no/y/n/q)").ToLower()
        $good_select = ($a -eq "yes" -or $a -eq "y")
        if($a -eq "q"){
            Write-Host "canceled"
            return
        }
        if($good_select){
            Switch ($game){
                'Halo Reach'{
                    $Last_Map.Enqueue("R $($select.name)")
                    if($master_list_exist){
                        Copy-Item -LiteralPath "./Master_List\R\map_variants\$($select.File)" ".\haloreach\map_variants\$($select.File)" -Force
                    }
                }
                'Halo 2A'{
                    $Last_Map.Enqueue("2 $($select.name)")
                    if($master_list_exist){
                        Copy-Item -LiteralPath "./Master_List\2\map_variants\$($select.File)" ".\groundhog\map_variants\$($lselect.File)" -Force
                    }
                }
                'Halo 3'{
                    $Last_Map.Enqueue("3 $($select.name)")
                    if($master_list_exist){
                        Copy-Item -LiteralPath "./Master_List\3\map_variants\$($select.File)" ".\halo3\map_variants\$($select.File)" -Force
                    }
                }
            }
            $aaa = $false
            $no_select = $false
            write-host "Map added to queue" -ForegroundColor Cyan
            if($Last_Map.Count -gt $queue_size){
                $last = $Last_Map.Dequeue()
                if($master_list_exist){
                    Switch ($last[0]){
                        'R'{
                            Remove-Item -LiteralPath ".\haloreach\map_variants\$($last.substring(2)).bin"
                        }
                        '2'{
                            Remove-Item -LiteralPath ".\groundhog\map_variants\$($last.substring(2)).bin"
                        }
                        '3'{
                            Remove-Item -LiteralPath ".\halo3\map_variants\$($last.substring(2)).bin"
                        }
                    }
                }
            }
        }
    }

    SearchGM
}

function SearchMap{
    write-Host "`nEnter a search term for the map you want" -ForegroundColor Cyan
    $no_select = $true
    $list = $null
    while($no_select){
        Write-Host "Search for maps or press enter to skip" -ForegroundColor Green
        $inmput = Read-Host "Search"
        if($inmput -eq ""){
            return
        }
        else{
            Switch ($game){
                'Halo Reach'{
                    $list = $maps | Where-Object {$_.name -like "*$inmput*"}
                }
                'Halo 2A'{
                    $list = $maps | Where-Object {$_.name -like "*$inmput*"}
                }
                'Halo 3'{
                    $list = $maps | Where-Object {$_.name -like "*$inmput*"}
                }
            }
        }
        if($list.Count -ne 0){
            Write-Host "`tIndex `tMap Name" -ForegroundColor Cyan
            0..($list.Count-1) | %{
                Write-Host "`t$($_+1)`t$($list[$_].name)"
            }
            $aaa = $true
            while($aaa){
                write-Host "`nEnter the Index Number or press enter for a new search" -ForegroundColor Green

                $sel = Read-Host ">"
                if($sel -ne ""){
                    try{
                        if(0 -lt [int]$sel -and [int]$sel -le $list.Count){
                            Switch ($game){
                                'Halo Reach'{
                                    $Last_Map.Enqueue("R $($list[$sel-1].name)")
                                    if($master_list_exist){
                                        Copy-Item  -LiteralPath "./Master_List\R\map_variants\$($list[$sel-1].file)" ".\haloreach\map_variants\$($list[$sel-1].file)" -Force
                                    }
                                }
                                'Halo 2A'{
                                    $Last_Map.Enqueue("2 $($list[$sel-1].name)")
                                    if($master_list_exist){
                                        Copy-Item -LiteralPath "./Master_List\2\map_variants\$($list[$sel-1].file)" ".\groundhog\map_variants\$($list[$sel-1].file)" -Force
                                    }
                                }
                                'Halo 3'{
                                    $Last_Map.Enqueue("3 $($list[$sel-1].name)")
                                    if($master_list_exist){
                                        Copy-Item -LiteralPath "./Master_List\3\map_variants\$($list[$sel-1].file)" ".\halo3\map_variants\$($list[$sel-1].file)" -Force
                                    }
                                }
                            }
                            $aaa = $false
                            $no_select = $false
                            
                            write-Host ""
                            write-Host "What about this:"
                            Write-Host "`t$($list[$sel-1].name)" -ForegroundColor Green
                            write-Host "`t$($list[$sel-1].Discription)" -ForegroundColor Cyan
                            Write-Host "`tBase map: " -NoNewline;Write-Host "$($list[$sel-1].base)    " -ForegroundColor Magenta -NoNewline; Write-Host "$($list[$sel-1].file)" -ForegroundColor DarkRed
                            write-Host ""

                            write-host "Map added to queue" -ForegroundColor Cyan
                            if($Last_Map.Count -gt $queue_size){
                                $last = $Last_Map.Dequeue()
                                if($master_list_exist){
                                    Switch ($last[0]){
                                        'R'{
                                            Remove-Item -LiteralPath ".\haloreach\map_variants\$($last.substring(2)).bin"
                                        }
                                        '2'{
                                            Remove-Item -LiteralPath ".\groundhog\map_variants\$($last.substring(2)).bin"
                                        }
                                        '3'{
                                            Remove-Item -LiteralPath ".\halo3\map_variants\$($last.substring(2)).bin"
                                        }
                                    }
                                }
                            }
                        }
                    }catch{}
                }else{
                    $aaa = $false
                }
            }
        }
        else{
            Write-Host "No maps found" -ForegroundColor Red
        }
    }

    SearchGM
}

function SearchGM{
    write-Host "`nThe odds are that this map has a specific Gametype. Lets search for it" -ForegroundColor Cyan
    $no_select = $true
    $list = $null
    while($no_select){
        Write-Host "Search for Gamemodes or press enter to skip" -ForegroundColor Green
        $inmput = Read-Host "Search"
        if($inmput -eq ""){
            return
        }
        else{
            if($master_list_exist){
                Switch ($game){
                    'Halo Reach'{
                        $list = Get-Item -Path ".\Master_List\R\game_variants\*" -Filter "*$inmput*"
                    }
                    'Halo 2A'{
                        $list = Get-Item -Path ".\Master_List\2\game_variants\*" -Filter "*$inmput*"
                    }
                    'Halo 3'{
                        $list = Get-Item -Path ".\Master_List\3\game_variants\*" -Filter "*$inmput*"
                    }
                }
            }else{
                Switch ($game){
                    'Halo Reach'{
                        $list = Get-Item -Path ".\haloreach\game_variants\*" -Filter "*$inmput*"
                    }
                    'Halo 2A'{
                        $list = Get-Item -Path ".\groundhog\game_variants\*" -Filter "*$inmput*"
                    }
                    'Halo 3'{
                        $list = Get-Item -Path ".\halo3\game_variants\*" -Filter "*$inmput*"
                    }
                }
            }
        }
        if($list.Count -ne 0){
            Write-Host "`tIndex `tGame Name" -ForegroundColor Cyan
            0..($list.Count-1) | %{
                Write-Host "`t$($_+1)`t$($list[$_].name.substring(0,$list[$_].name.Length-4))"
            }
            $aaa = $true
            while($aaa){
                write-Host "`nEnter the Index Number or press enter for a new search" -ForegroundColor Green

                $sel = Read-Host ">"
                if($sel -ne ""){
                    #try{
                        if(0 -lt [int]$sel -and [int]$sel -le $list.Count){
                            Switch ($game){
                                'Halo Reach'{
                                    $Last_Game.Enqueue("R $($list[$sel-1].name.substring(0,$list[$sel-1].name.Length-4))")
                                    if($master_list_exist){
                                        Copy-Item  -LiteralPath $list[$sel-1].FullName ".\haloreach\game_variants\$($list[$sel-1].name)" -Force
                                    }
                                }
                                'Halo 2A'{
                                    $Last_Game.Enqueue("2 $($list[$sel-1].name.substring(0,$list[$sel-1].name.Length-4))")
                                    if($master_list_exist){
                                        Copy-Item  -LiteralPath $list[$sel-1].FullName ".\groundhog\game_variants\$($list[$sel-1].name)" -Force
                                    }
                                }
                                'Halo 3'{
                                    $Last_Game.Enqueue("3 $($list[$sel-1].name.substring(0,$list[$sel-1].name.Length-4))")
                                    if($master_list_exist){
                                        Copy-Item  -LiteralPath $list[$sel-1].FullName ".\halo3\game_variants\$($list[$sel-1].name)" -Force
                                    }
                                }
                            }
                            $aaa = $false
                            $no_select = $false
                            write-host "Map added to queue" -ForegroundColor Cyan
                            if($Last_Game.Count -gt $queue_size){
                                $last = $Last_Game.Dequeue()
                                if($master_list_exist){
                                    Switch ($last[0]){
                                        'R'{
                                            Remove-Item ".\haloreach\game_variants\$($last.substring(2)).bin"
                                        }
                                        '2'{
                                            Remove-Item ".\groundhog\game_variants\$($last.substring(2)).bin"
                                        }
                                        '3'{
                                            Remove-Item ".\halo3\game_variants\$($last.substring(2)).bin"
                                        }
                                    }
                                }
                            }
                        }
                    #}catch{}
                }else{
                    $aaa = $false
                }
            }
        }
        else{
            Write-Host "No Game modes found" -ForegroundColor Red
        }
    }
}

# variables

$Last_Map = New-Object System.Collections.Queue
$Last_Game = New-Object System.Collections.Queue
$queue_size = 3

$good_game = $true
$not_done = $true
$master_list_exist = Test-Path ./Master_List
$filter = ""

#init
#cls

if(Test-Path "./Master_List/last_maps.txt" -ErrorAction Ignore){
    $a = Get-Content "./Master_List/last_maps.txt"
    $a | %{
        $Last_Map.Enqueue($_)
    }
}
if(Test-Path "./Master_List/last_game.txt" -ErrorAction Ignore){
    $a = Get-Content "./Master_List/last_game.txt"
    $a | %{
        $Last_Game.Enqueue($_)
    }
}

#main
if($answ1 -eq $null){
    Write-Host "
    Do you want me move your maps and GM out of halo?
    THis will remove the clutter so MCC can load faster and you dont need to to dig through your files to find what you need.
    Unfortunatly you will need to trick your game to reload the maps and gamemodes by playing a different map.
    It is best to queue up games.
    Your content can be found in the Master_List folder" -ForegroundColor Green
    $a = (Read-Host "(yes/no/y/n)").ToLower()
}else{
    $a = $answ1
    $ret = 0
}
$a = ($a -eq "yes" -or $a -eq "y")
if ($a) {
    $ret = MoveMaps
}
if ($ret -ne 0){
    write-host "Error in moving files" -ForegroundColor Red
}

while ($not_done){
    if($good_game){
        if($answ2 -eq $null){
            Write-Host "`nWhat game are you playing?" -ForegroundColor Green
            $game = (Read-Host "(R/2/3)").ToLower()
        }else{
            $game = $answ2
        }
        Switch ($game){
            'r'{
                $ret = HReach
                $game = "Halo Reach"
                $good_game = $false
            }
            '2'{
                $ret = H2
                $game = "Halo 2A"
                $good_game = $false
            }
            '3'{
                $ret = H3
                $game = "Halo 3"
                $good_game = $false
            }
            default{
                $good_game = $true
            }
        }
    }
    else{
        #cls
        Write-Host "
whats your next command?" -ForegroundColor Green
        write-host "
    show - show the last map selected
    ran - Select a random map
    sel - select a specific map
    filter - Change the filter for the randome map
    gm - search a gamemode, if you skiped it from the prior setup
    game - Change game
    move - Move maps from the game files to master
    clear - cleans the screen
    quit - Exit the app
"
        write-host "Game: $game"  -ForegroundColor Cyan
        write-host "Filter: $filter"  -ForegroundColor Cyan
        write-host "Map queue: $($Last_Map.Count)/$queue_size"  -ForegroundColor Cyan
        write-host "GM queue: $($Last_Game.Count)/$queue_size"  -ForegroundColor Cyan
        $input = (Read-Host ">").ToLower()
        Switch ($input){
            'show'{
                try{
                    $ind = $maps[$maps.name.IndexOf($Last_Map.peek().substring(2))]
                    
                    write-Host ""
                    write-Host ""
                    write-Host "What about this:"
                    Write-Host "`t$($ind.name)" -ForegroundColor Green
                    write-Host "`t$($ind.Discription)" -ForegroundColor Cyan
                    Write-Host "`tBase map: " -NoNewline;Write-Host "$($ind.base)    " -ForegroundColor Magenta -NoNewline; Write-Host "$($ind.file)" -ForegroundColor DarkRed
                    write-Host ""
                }catch{Write-Host "No Map"}
                try{
                    write-Host "GameMode:" -NoNewline;Write-Host "$($Last_Game.Peek().substring(2))" -ForegroundColor Yellow
                    write-Host ""
                    write-Host ""
                }catch{Write-Host "No GM"}

                $Last_Map
            }
            'ran'{
                SelectMapRandom
            }
            'sel'{
                SearchMap
            }
            'filter'{
                $filter = Read-Host "Filter"
            }
            'gm'{
                SearchGM
            }
            'game'{
                $good = $true
            }
            'move'{
                MoveMaps
                $master_list_exist = Test-Path ./Master_List
                Switch ($game){
                    'Halo Reach'{
                        $ret = HReach
                    }
                    'Halo 2A'{
                        $ret = H2
                    }
                    'Halo 3'{
                        $ret = H3
                    }
                }
            }
            'clear'{
                cls
            }
            'quit'{
                $not_done = $false
            }
            default{
                Write-Host "Unknown command"
            }
        }
    }
}
