$TractDict = @{
    "Tiny Arena"    = "arena2"
    "Hot Air Skyway" = "blimp1"
    "Cortex Castle" = "castle1"
    "Mystery Caves" = "cave1"
    "Coco Park" = "coco1"
    "Blizzard Bluff" = "desert2"
    "Polar Pass" = "ice1"
    "Crash Cove" = "island1"
    "N. Gin Labs" = "labs1"
    "Dingo Canyon" = "proto8"
    "Dragon Mines" = "proto9"
    "Slide Coliseum" = "secret1"
    "Turbo Track" = "secret2"
    "Sewer Speedway" = "sewer1"
    "Oxide Station" = "space"
    "Tiger Temple" = "temple1"
    "Papu's Pyramid" = "temple2"
    "Roo's Tubes" = "tube1"
}

$VersionDict = @{
    "NTSC-U" = "ctr_-_crash_team_racing(NTSC_U).cue"
    "NTSC-J" = "Crash Bandicoot Racing (CTR) NTSC-J] [SCPS-10118].cue"
    "PAL"    = "CTR - Crash Team Racing (Europe) (En,Fr,De,Es,It,Nl) (No EDC).cue"
    "J-TRAINING" = "CTRTrainingJ.cue"
    "PAL-TRAINING" = "CTRTrainingPAL.cue"
}



Function Start-CtrPC {
    Param(
    [ValidateSet(
    "Blizzard Bluff",
    "Coco Park",
    "Cortex Castle",
    "Crash Cove",
    "Dingo Canyon",
    "Dragon Mines",
    "Hot Air Skyway",
    "Mystery Caves",
    "N. Gin Labs",
    "Oxide Station",
    "Papu's Pyramid",
    "Polar Pass",
    "Roo's Tubes",
    "Sewer Speedway",
    "Slide Coliseum",
    "Tiger Temple",
    "Tiny Arena",
    "Turbo Track"
)]
    $Track,
    [ValidateSet("NTSC", "PAL")]
    $Version
    )
    End {
        if ($Track) {
            $path = "D:\Files\Other\CTR\Modding\ctr-viewer-r10\"
            switch ($version){
                "NTSC" {$path += "levelbank_NTSC\"}
                "PAL" {$path += "levelbank_PAL\"}
                Default {$path += "levelbank\"}
            }
            $loadpath = "D:\Files\Other\CTR\Modding\ctr-viewer-r10\levels"
            $pathChildItem = get-childitem $loadpath
            if ($pathChildItem) {
                $pathChildItem | remove-item -recurse -force
            }
            copy-item "$path$($TractDict[$Track])\*" $loadpath -force
            write-host "$path$($TractDict[$Track])"
        }
        #Start-Mednafen -Version $Version -Record
        Start-Viewer
    }
}

Function Start-CtrConsole {
    [Alias("ctrcon")]
    Param()
    $path = Get-ChildItem "D:\Programs\obs-studio\bin\64bit\obs64.exe"
    Start-Process -FilePath $path -ArgumentList "--startrecording" -WorkingDirectory $path.DirectoryName

}

Function Start-Viewer {
    [Alias("CTRView")]
    Param()
    $path = Get-ChildItem "D:\Files\Other\CTR\Modding\ctr-viewer-r10\ctrviewer.exe"
    Start-Process -FilePath $path -WorkingDirectory $path.DirectoryName
}

Function Start-Mednafen {
    [Alias("ctremu")]
    Param(
        [ValidateSet("NTSC-U", "NTSC-J", "PAL", "PAL-TRAINING", "J-TRAINING")]
        $Version,
        [switch]$Record

    )
    if ($Record) {
        $path = Get-ChildItem "D:\Programs\obs-studio\bin\64bit\obs64.exe"
        Start-Process -FilePath $path -ArgumentList "--startrecording" -WorkingDirectory $path.DirectoryName
    }
    if ($Version -notlike "*TRAIN*") {
        Start-Process -Filepath "D:\Games\Emulation\JoyToKey\JoyToKey.exe"
    }
    Start-Process -Filepath "D:\Games\Emulation\ViGEm\XOutput\XOutput.exe"
    $Arguments = "D:\Games\Emulation\ROMs\PS1\$($VersionDict[$Version])"
    $Arguments = '"{0}"' -f $Arguments
    Start-Process -FilePath "D:\Games\Emulation\Emulators\PS1\mednafen\mednafen.exe" -ArgumentList $Arguments
}

Function Open-Video{
    [Alias("playlast")]
    Param()
    Push-Location
    cd $CtrVids
    $vids = Get-ChildItem | Where-Object {$_.Name -match "^\d.*"}
    mpv $vids[-1].Name
    Pop-Location
}

Function Get-YTVideo {
    Param(
        [Parameter(Mandatory=$true)]$Tag
    )
    youtube-dl --recode-video mp4 -o "youtubevideo.%(ext)s" "https://www.youtube.com/watch?v=$Tag"
}
