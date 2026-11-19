# Recorta las láminas 2×2 de img/laminas/ en imágenes sueltas y regenera data/images.js.
# Uso: powershell -ExecutionPolicy Bypass -File tools\split-laminas.ps1 [-Force]
param(
  [string]$In = "$PSScriptRoot\..\img\laminas",
  [string]$Out = "$PSScriptRoot\..\img",
  [switch]$Force   # volver a recortar aunque ya existan las imágenes
)
Add-Type -AssemblyName System.Drawing
$root = (Resolve-Path "$PSScriptRoot\..").Path
$manifest = Get-Content "$root\data\laminas.json" -Raw -Encoding UTF8 | ConvertFrom-Json

# Busca la franja más uniforme (el borde entre retratos) en el tercio central
function FindGutter($bmp, [bool]$vertical) {
  $len = if ($vertical) { $bmp.Width } else { $bmp.Height }
  $other = if ($vertical) { $bmp.Height } else { $bmp.Width }
  $scores = @{}
  for ($p = [int]($len * 0.38); $p -le [int]($len * 0.62); $p++) {
    $vals = for ($q = 0; $q -lt 64; $q++) {
      $o = [int](($q + 0.5) * $other / 64)
      $c = if ($vertical) { $bmp.GetPixel($p, $o) } else { $bmp.GetPixel($o, $p) }
      0.3 * $c.R + 0.59 * $c.G + 0.11 * $c.B
    }
    $m = ($vals | Measure-Object -Average).Average
    $scores[$p] = (($vals | ForEach-Object { ($_ - $m) * ($_ - $m) }) | Measure-Object -Average).Average
  }
  $best = ($scores.GetEnumerator() | Sort-Object Value | Select-Object -First 1)
  if ($best.Value -gt 400) { $h = [int]($len / 2); return @($h, $h) }   # sin borde claro: mitad exacta
  $lim = [Math]::Max($best.Value * 3, 60)
  $a = $best.Key; while ($scores.ContainsKey($a - 1) -and $scores[$a - 1] -le $lim) { $a-- }
  $b = $best.Key; while ($scores.ContainsKey($b + 1) -and $scores[$b + 1] -le $lim) { $b++ }
  @($a, $b)
}

# ¿La línea (fila o columna) es casi de un solo color? => es borde
function IsFlat($bmp, [bool]$col, [int]$p, [int]$from, [int]$to) {
  $vals = for ($q = 0; $q -lt 32; $q++) {
    $o = $from + [int](($q + 0.5) * ($to - $from) / 32)
    $c = if ($col) { $bmp.GetPixel($p, $o) } else { $bmp.GetPixel($o, $p) }
    0.3 * $c.R + 0.59 * $c.G + 0.11 * $c.B
  }
  $m = ($vals | Measure-Object -Average).Average
  ((($vals | ForEach-Object { ($_ - $m) * ($_ - $m) }) | Measure-Object -Average).Average) -lt 60
}

function SaveCrop($bmp, $rect, $path) {
  # quita bordes uniformes por cada lado (máx. 8%) y luego un 1% extra
  $x0 = $rect.X; $x1 = $rect.Right - 1; $y0 = $rect.Y; $y1 = $rect.Bottom - 1
  $mx = [int]($rect.Width * 0.08); $my = [int]($rect.Height * 0.08)
  for ($k = 0; $k -lt $mx -and (IsFlat $bmp $true $x0 $y0 $y1); $k++) { $x0++ }
  for ($k = 0; $k -lt $mx -and (IsFlat $bmp $true $x1 $y0 $y1); $k++) { $x1-- }
  for ($k = 0; $k -lt $my -and (IsFlat $bmp $false $y0 $x0 $x1); $k++) { $y0++ }
  for ($k = 0; $k -lt $my -and (IsFlat $bmp $false $y1 $x0 $x1); $k++) { $y1-- }
  $ix = [int](($x1 - $x0) * 0.01); $iy = [int](($y1 - $y0) * 0.01)
  $r = New-Object Drawing.Rectangle(($x0 + $ix), ($y0 + $iy), ($x1 - $x0 + 1 - 2 * $ix), ($y1 - $y0 + 1 - 2 * $iy))
  $crop = $bmp.Clone($r, $bmp.PixelFormat)
  $enc = [Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object MimeType -eq 'image/jpeg'
  $ps = New-Object Drawing.Imaging.EncoderParameters(1)
  $ps.Param[0] = New-Object Drawing.Imaging.EncoderParameter([Drawing.Imaging.Encoder]::Quality, [long]90)
  $crop.Save($path, $enc, $ps); $crop.Dispose()
}

New-Item -ItemType Directory -Force "$Out\npcs", "$Out\lugares" | Out-Null
foreach ($f in Get-ChildItem $In -File -ErrorAction SilentlyContinue | Where-Object Extension -match '^\.(png|jpe?g|webp)$') {
  $entry = $manifest.($f.BaseName)
  if (-not $entry) { Write-Warning "$($f.Name): no está en data/laminas.json, la salto"; continue }
  $dir = if ($entry.kind -eq 'loc') { "$Out\lugares" } else { "$Out\npcs" }
  # un id null es una casilla de relleno que no se guarda
  $targets = $entry.ids | ForEach-Object { if ($_) { "$dir\$_.jpg" } else { $null } }
  if (-not $Force -and -not ($targets | Where-Object { $_ -and -not (Test-Path $_) })) { "$($f.Name): ya recortada"; continue }
  $bmp = New-Object Drawing.Bitmap($f.FullName)
  $gx = FindGutter $bmp $true; $gy = FindGutter $bmp $false
  $W = $bmp.Width; $H = $bmp.Height
  $rects = @(
    (New-Object Drawing.Rectangle(0, 0, $gx[0], $gy[0])),
    (New-Object Drawing.Rectangle(($gx[1] + 1), 0, ($W - $gx[1] - 1), $gy[0])),
    (New-Object Drawing.Rectangle(0, ($gy[1] + 1), $gx[0], ($H - $gy[1] - 1))),
    (New-Object Drawing.Rectangle(($gx[1] + 1), ($gy[1] + 1), ($W - $gx[1] - 1), ($H - $gy[1] - 1))))
  for ($i = 0; $i -lt 4; $i++) { if ($targets[$i]) { SaveCrop $bmp $rects[$i] $targets[$i] } }
  $bmp.Dispose()
  "$($f.Name): recortada en $(($entry.ids | Where-Object { $_ }) -join ', ')  (bordes x=$($gx -join '-') y=$($gy -join '-'))"
}

# Índice de imágenes por id (también recoge las que se guarden sueltas con el nombre del id)
$idx = [ordered]@{ npcs = [ordered]@{}; locations = [ordered]@{} }
foreach ($pair in @(@('npcs', 'npcs'), @('lugares', 'locations'))) {
  Get-ChildItem "$Out\$($pair[0])" -File | Where-Object Extension -match '^\.(png|jpe?g|webp)$' | Sort-Object Name | ForEach-Object {
    $idx[$pair[1]][$_.BaseName] = "img/$($pair[0])/$($_.Name)"
  }
}
$json = $idx | ConvertTo-Json -Depth 4 -Compress
[IO.File]::WriteAllText("$root\data\images.js", "window.IMAGES = $json;`n", (New-Object Text.UTF8Encoding($false)))
"Índice: $($idx.npcs.Count) retratos, $($idx.locations.Count) lugares"
