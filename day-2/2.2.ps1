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
    'X' = 'Loss'
    'Y' = 'Draw'
    'Z' = 'Win'
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
    $outcome = $map[$selections[1]]

    if ($outcome -eq 'Draw') {
        Write-Verbose -Message 'Need a draw'
        $myDevice = $theirDevice
    } elseif ($outcome -eq 'Win') {
        Write-Verbose -Message 'Need a win'
        $myDevice = foreach ($possibleOutcome in $outcomes.GetEnumerator()) {
            if ($possibleOutcome.Value -eq $theirDevice) {
                $possibleOutcome.Key
            }
        }
    } elseif ($outcome -eq 'Loss') {
        Write-Verbose -Message 'Need a loss'
        $myDevice = $outcomes[$theirDevice]
    }

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