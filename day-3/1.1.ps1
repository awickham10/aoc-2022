[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [string]
    $InputFile
)

$input = Get-Content -Path $InputFile

# build priorities
$priorities = @{}
for ($i = 97; $i -le 123; $i++) {
    $priorities.Add(([char]$i), $i - 96)
}
for ($i = 65; $i -le 91; $i++) {
    $priorities.Add(([char]$i), $i - 38)
}

$inBoth = @()
foreach ($sack in $input) {
    $comp1 = $sack[0..($sack.Length / 2 - 1)]
    $comp2 = $sack[($sack.Length / 2)..($sack.Length - 1)]

    $inBoth += Compare-Object -ReferenceObject $comp1 -DifferenceObject $comp2 -ExcludeDifferent -IncludeEqual | Select-Object -ExpandProperty 'InputObject' -Unique
}

$inBoth | ForEach-Object {
    $priorities[$_]
} | Measure-Object -Sum | Select-Object -ExpandProperty 'Sum'