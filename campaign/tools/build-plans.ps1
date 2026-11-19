# Monta los planos interiores: maps/interiores/src/<id>.part.svg -> maps/interiores/<id>.svg
# Cada .part.svg empieza con: <!--plan w=900 h=640 tx=450 ty=560 title="..." sub="..."-->
# y contiene el dibujo; aquí se le añaden los símbolos comunes (_defs.svg), el pergamino,
# la cartela con el título, la escala y la rosa de los vientos.
$dir = (Resolve-Path "$PSScriptRoot\..\maps\interiores").Path
$defs = [IO.File]::ReadAllText("$dir\src\_defs.svg", [Text.Encoding]::UTF8)
$utf8 = New-Object Text.UTF8Encoding($false)
foreach ($f in Get-ChildItem "$dir\src\*.part.svg") {
  $body = [IO.File]::ReadAllText($f.FullName, [Text.Encoding]::UTF8)
  if ($body -notmatch '<!--plan ([^>]*)-->') { Write-Warning "$($f.Name): falta la cabecera <!--plan ...-->"; continue }
  $m = @{}; [regex]::Matches($Matches[1], '(\w+)=("([^"]*)"|\S+)') | ForEach-Object { $m[$_.Groups[1].Value] = if ($_.Groups[3].Success) { $_.Groups[3].Value } else { $_.Groups[2].Value } }
  $w = [int]$m.w; $h = [int]$m.h; $tx = [int]$m.tx; $ty = [int]$m.ty
  $svg = @"
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 $w $h" width="$w" height="$h">
  <defs>
$defs
  </defs>
  <rect width="$w" height="$h" fill="#e8dcbf"/>
  <rect x="8" y="8" width="$($w - 16)" height="$($h - 16)" fill="none" stroke="#7a5f3a" stroke-width="3"/>
$body
  <g font-family="Georgia, serif" fill="#3b2a1a">
    <text x="$tx" y="$ty" font-size="30" font-weight="bold" text-anchor="middle">$($m.title)</text>
    <text x="$tx" y="$($ty + 26)" font-size="15" font-style="italic" text-anchor="middle">$($m.sub)</text>
    <path d="M$($tx - 100) $($ty + 56)H$($tx + 100)" stroke="#3b2a1a" stroke-width="2"/>
    <path d="M$($tx - 100) $($ty + 50)V$($ty + 62)M$($tx - 60) $($ty + 50)V$($ty + 62)M$($tx - 20) $($ty + 50)V$($ty + 62)M$($tx + 20) $($ty + 50)V$($ty + 62)M$($tx + 60) $($ty + 50)V$($ty + 62)M$($tx + 100) $($ty + 50)V$($ty + 62)" stroke="#3b2a1a" stroke-width="2"/>
    <text x="$tx" y="$($ty + 82)" font-size="13" text-anchor="middle">1 cuadro = 5 pies (1,5 m)</text>
  </g>
  <g transform="translate($($w - 60) $($h - 60))" stroke="#3b2a1a" stroke-width="1.5">
    <path d="M0 -30L7 0L0 30L-7 0Z" fill="#e8dcbf"/><path d="M0 -30L7 0H-7Z" fill="#3b2a1a"/>
    <text y="-36" font-family="Georgia, serif" font-size="14" text-anchor="middle" fill="#3b2a1a" stroke="none">N</text>
  </g>
</svg>
"@
  $out = Join-Path $dir ($f.Name -replace '\.part\.svg$', '.svg')
  [IO.File]::WriteAllText($out, $svg, $utf8)
  "$($f.Name) -> $([IO.Path]::GetFileName($out)) ($w x $h)"
}
