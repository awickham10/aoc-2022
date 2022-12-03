[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [string]
    $InputFile
)

$content = Get-Content -Path $InputFile

# build priorities
$priorities = @{}
for ($i = 97; $i -le 123; $i++) {
    $priorities.Add(([char]$i), $i - 96)
}
for ($i = 65; $i -le 91; $i++) {
    $priorities.Add(([char]$i), $i - 38)
}

$out = for ($i = 0; $i -lt $content.Length; $i += 3) {
    $sticker = $content[$i].ToCharArray() | Where-Object { $content[$i + 1].ToCharArray() -ccontains $_ -and $content[$i + 2].ToCharArray() -ccontains $_ } | Select-Object -Unique
    $priorities[$sticker]
}

$out | Measure-Object -Sum | Select-Object -ExpandProperty 'Sum'