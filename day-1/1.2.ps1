[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [string]
    $InputFile
)

$input = Get-Content -Path $InputFile

$elfCalories = New-Object -TypeName 'System.Collections.ArrayList'
$counter = 0
foreach ($line in $input) {
    if ($line -eq '') {
        Write-Verbose "Found a new elf"
        $counter++
        continue
    }

    if ($elfCalories.Count -lt $counter -or $null -eq $elfCalories[$counter]) {
        Write-Verbose "Initializing elf $counter"
        $null = $elfCalories.Add([int]$line)
    } else {
        Write-Verbose "Adding to elf $counter"
        $elfCalories[$counter] += $line
    }
}

$elfCalories | Sort-Object -Descending | Select-Object -First 3 | Measure-Object -Sum | Select-Object -ExpandProperty 'Sum'