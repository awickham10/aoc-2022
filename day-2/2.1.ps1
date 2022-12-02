[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [string]
    $InputFile
)

$input = Get-Content -Path $InputFile

# Device = Beats Device
$outcomes = @{
    'Rock' = 'Scissors'
    'Paper' = 'Rock'
    'Scissors' = 'Paper'
}

# Letter = Device
$map = @{
    'A' = 'Rock'
    'B' = 'Paper'
    'C' = 'Scissors'
    'X' = 'Rock'
    'Y' = 'Paper'
    'Z' = 'Scissors'
}

$deviceScore = @{
    'Rock' = 1
    'Paper' = 2
    'Scissors' = 3
}

$score = 0
foreach ($round in $input) {
    $selections = $round.Split(' ')

    $theirDevice = $map[$selections[0]]
    $myDevice = $map[$selections[1]]

    $score += if ($myDevice -eq $theirDevice) {
        3 + $deviceScore[$myDevice]
    } elseif ($outcomes[$myDevice] -eq $theirDevice) {
        6 + $deviceScore[$myDevice]
    } elseif ($outcomes[$theirDevice] -eq $myDevice) {
        0 + $deviceScore[$myDevice]
    } else {
        Write-Error "Unknown device matchup for round $round!"
    }
}

$score