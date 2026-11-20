# Pasa al Word de campaña lo añadido en la app (vecinos, interiores, rutinas, sitios nuevos).
# Se puede ejecutar varias veces: las secciones 8-10 se regeneran y lo demás no se duplica.
# Uso: powershell -ExecutionPolicy Bypass -File tools\sync-word.ps1
param(
  [string]$Docx = "$PSScriptRoot\..\docs\Othran_Vel_Campana_Importacion.docx",
  [string]$Copy = "$PSScriptRoot\..\..\OTRAN VEL CAMPAÑA\Othran_Vel_Campana_Importacion.docx"
)
Add-Type -AssemblyName System.IO.Compression.FileSystem
$root = (Resolve-Path "$PSScriptRoot\..").Path
$Docx = (Resolve-Path $Docx).Path
$utf8 = New-Object Text.UTF8Encoding($false)

# --- Datos ---
$seedTxt = [IO.File]::ReadAllText("$root\data\seed.js", [Text.Encoding]::UTF8)
$seed = $seedTxt.Substring($seedTxt.IndexOf('{')).TrimEnd(";`r`n ") | ConvertFrom-Json
$int = Get-Content "$root\data\interiores.json" -Raw -Encoding UTF8 | ConvertFrom-Json
$vec = Get-Content "$root\data\vecinos.json" -Raw -Encoding UTF8 | ConvertFrom-Json
function LocName($id) { $l = $seed.locations.$id; if ($l) { $l.name } else { $id } }
function PlaceOf($zone) {
  $z = $seed.locations.$zone
  if (-not $z) { return '' }
  if ($z.type -eq 'estancia') { "$($z.name) · $(LocName $z.parent)" } else { $z.name }
}

# --- XML con el mismo formato que el documento ---
function X([string]$s) { [Security.SecurityElement]::Escape($s) }
function H1([string]$t) { "<w:p><w:pPr><w:pStyle w:val=`"Heading1`"/><w:pageBreakBefore/></w:pPr><w:r><w:t xml:space=`"preserve`">$(X $t)</w:t></w:r></w:p>" }
function H2([string]$t) { "<w:p><w:pPr><w:pStyle w:val=`"Heading2`"/></w:pPr><w:r><w:t xml:space=`"preserve`">$(X $t)</w:t></w:r></w:p>" }
function H3([string]$t) { "<w:p><w:pPr><w:pStyle w:val=`"Heading3`"/></w:pPr><w:r><w:t xml:space=`"preserve`">$(X $t)</w:t></w:r></w:p>" }
function T([string]$t) { "<w:p><w:r><w:t xml:space=`"preserve`">$(X $t)</w:t></w:r></w:p>" }
function F([string]$k, [string]$v) {
  if (-not $v) { $v = '[POR DEFINIR]' }
  "<w:p><w:pPr><w:spacing w:after=`"60`"/></w:pPr><w:r><w:rPr><w:b/><w:bCs/></w:rPr><w:t xml:space=`"preserve`">$(X "$k`: ")</w:t></w:r><w:r><w:t xml:space=`"preserve`">$(X $v)</w:t></w:r></w:p>"
}

# --- Leer el documento ---
$zip = [IO.Compression.ZipFile]::Open($Docx, 'Update')
$entry = $zip.GetEntry('word/document.xml')
$sr = New-Object IO.StreamReader($entry.Open(), [Text.Encoding]::UTF8); $x = $sr.ReadToEnd(); $sr.Close()

# 1) Reva trabaja en la Casa del Gremio
$h = $x.IndexOf('<w:pStyle w:val="Heading2"/></w:pPr><w:r><w:t xml:space="preserve">Reva Sonn</w:t>')
if ($h -ge 0) {
  $k = 'Dónde se encuentra: </w:t></w:r><w:r><w:t xml:space="preserve">'
  $a = $x.IndexOf($k, $h) + $k.Length; $b = $x.IndexOf('</w:t>', $a)
  $x = $x.Substring(0, $a) + 'Casa del Gremio Mercantil' + $x.Substring($b)
}
$x = $x.Replace('El pregonero, Reva Sonn, pescador viejo, mujer con delantal de tienda', 'El pregonero, Lenn Brea (puesto del gremio), Abuelo Wender (el pescador viejo), Liss Corbel (la mujer del delantal)')
$x = $x.Replace('Aquí está el mercado donde actúa Reva Sonn (nombre del mercado: [POR DEFINIR]).', 'Aquí está el mercado (nombre: [POR DEFINIR]); el puesto del gremio lo atiende Lenn Brea y Reva Sonn trabaja en la Casa del Gremio Mercantil, junto al muelle.')

# 2) Sitios nuevos de Ethar en la sección 4 (solo si aún no están)
$newPlaces = @(
  @{ id = 'casa-del-gremio-mercantil'; where = 'Junto al muelle, en el lado este'; npcs = 'Reva Sonn, Lenn Brea (al amanecer y al anochecer)'
     hooks = 'Encargos de Reva («Cuentas claras» y captura del jefe del almacén). El archivo de fletes no cuadra con la tablilla de Rendal.' },
  @{ id = 'horno-de-ruy'; where = 'Al este de la Plaza del Pregón'; npcs = 'Ruy'; hooks = 'Ruy ve volver del Almacén Sur a los Matones del turno de noche.' },
  @{ id = 'casa-de-madre-orla'; where = 'Cerca de la Capilla de la Espiral Incompleta'; npcs = 'Madre Orla'; hooks = 'Ha curado a matones heridos sin hacer preguntas; sabe cuántos hombres tiene Dory.' },
  @{ id = 'la-atalaya'; where = 'Promontorio al oeste del puerto'; npcs = '[POR DEFINIR]'; type = 'otro (torre de vigía)'
     read = 'Una torre redonda de piedra sobre un promontorio rocoso. Desde su mirador almenado se domina toda la bahía, el puerto y el Camino de Sal.'
     dm = 'Quién la vigila: [POR DEFINIR]. Encender el brasero del mirador avisa a todo el pueblo.'; hooks = '[POR DEFINIR]' }
)
$block = ''
foreach ($p in $newPlaces) {
  $l = $vec.lugares | Where-Object id -eq $p.id
  $name = if ($l) { $l.name } else { LocName $p.id }
  if ($x.Contains("<w:t xml:space=`"preserve`">$(X $name)</w:t></w:r></w:p><w:p><w:pPr><w:spacing w:after=`"60`"/></w:pPr><w:r><w:rPr><w:b/><w:bCs/></w:rPr><w:t xml:space=`"preserve`">Tipo: ")) { continue }
  $block += (H2 $name) + (F 'Tipo' $(if ($p.type) { $p.type } else { $l.type })) + (F 'Dentro de' 'Ethar') + (F 'Ubicación aproximada en el mapa de Ethar' $p.where) +
    (F 'Descripción para leer' $(if ($p.read) { $p.read } else { $l.read })) + (F 'Notas del máster' $(if ($p.dm) { $p.dm } else { $l.dm })) +
    (F 'NPCs que se encuentran aquí' $p.npcs) + (F 'Objetos, precios o servicios de interés' $(if ($l) { $l.items } else { '[POR DEFINIR]' })) + (F 'Ganchos / pistas' $p.hooks)
}
$sec5 = '<w:p><w:pPr><w:pStyle w:val="Heading1"/><w:pageBreakBefore/></w:pPr><w:r><w:t xml:space="preserve">5. NPCs'
$x = $x.Replace($sec5, $block + $sec5)

# 3) Secciones 8-10, regeneradas cada vez
$tailMark = '<w:p><w:pPr><w:pStyle w:val="Heading1"/><w:pageBreakBefore/></w:pPr><w:r><w:t xml:space="preserve">8. VECINOS'
$t = $x.IndexOf($tailMark); $s = $x.IndexOf('<w:sectPr')
if ($t -ge 0) { $x = $x.Substring(0, $t) + $x.Substring($s); $s = $x.IndexOf('<w:sectPr') }

$tail = (H1 '8. VECINOS DE ETHAR (RELLENO)') + (T 'Personajes secundarios para dar vida al pueblo. En la app aparecen marcados como «Vecino» y se pueden ocultar. Cada uno tiene como mucho un rumor o gancho menor que no toca la trama principal.')
foreach ($v in $vec.vecinos) {
  $tail += (H2 $v.name) + (F 'Raza' $v.race) + (F 'Rol / ocupación' $v.role)
  $tail += F 'Dónde se encuentra' $(if ($v.spot) { (PlaceOf $v.spot.zone) } else { $v.location })
  $tail += (F 'Aspecto físico' $v.look) + (F 'Personalidad' $v.personality) + (F 'Voz y gestos (cómo interpretarlo en mesa)' $v.voice)
  $tail += (F 'Qué sabe (rumor o gancho)' $v.knows) + (F 'Qué está haciendo (por la tarde)' $v.doing)
}

$tail += (H1 '9. INTERIORES DE ETHAR') + (T 'Planos interiores de la app, con cuadrícula de 5 pies. Cada estancia lleva el número que aparece en su plano. La escena por defecto es media tarde.')
foreach ($b in $int.PSObject.Properties) {
  $tail += H2 (LocName $b.Name)
  foreach ($z in $b.Value.zones) {
    $tail += H3 ("Estancia $($z.num) · $($z.name)" + $(if ($z.secret) { ' (secreta)' } else { '' }))
    if ($z.read) { $tail += F 'Descripción para leer' $z.read }
    if ($z.dm) { $tail += F 'Notas del máster' $z.dm }
    if ($z.items) { $tail += F 'Objetos, precios o servicios' $z.items }
  }
  # quién está aquí por la tarde (principales y vecinos)
  $here = @($seed.npcs.PSObject.Properties | Where-Object { $_.Value.spot -and ($b.Value.zones.id -contains $_.Value.spot.at) })
  if ($here.Count) {
    $tail += H3 'Quién está aquí por la tarde'
    foreach ($n in $here) { $tail += F $n.Value.name "$($seed.locations.($n.Value.spot.at).name): $($n.Value.doing)" }
  }
}

$times = [ordered]@{ amanecer = 'Amanecer'; manana = 'Mañana'; tarde = 'Tarde'; anochecer = 'Anochecer'; noche = 'Noche' }
$tail += (H1 '10. RUTINAS DEL DÍA') + (T 'Dónde está y qué hace cada personaje de Ethar según el momento del día. Si no se indica lugar, sigue en el mismo sitio que por la tarde.')
foreach ($p in $vec.rutinas.PSObject.Properties) {
  $n = $seed.npcs.($p.Name); if (-not $n) { continue }
  $tail += H2 $n.name
  foreach ($k in $times.Keys) {
    if ($k -eq 'tarde') { $e = [pscustomobject]@{ doing = $n.doing; zone = $n.spot.at } } else { $e = $p.Value.$k }
    if (-not $e) { continue }
    $place = if ($e.away) { ' (fuera del plano)' } elseif ($e.zone) { " ($(PlaceOf $e.zone))" } else { '' }
    $tail += F $times[$k] "$($e.doing)$place"
  }
}

$tail += (H1 '11. ENEMIGOS Y PRESOS DE LAS MAZMORRAS') + (T 'Enemigos con nombre de las mazmorras, con la ficha de juego que usan. Los presos aparecen también aquí para tenerlos juntos.')
foreach ($v in $vec.enemigos) {
  $tail += (H2 $v.name) + (F 'Raza' $v.race) + (F 'Rol / ocupación' $v.role) + (F 'Ficha de juego' $v.sheet)
  $tail += F 'Dónde se encuentra' $(if ($v.spot) { PlaceOf $v.spot.zone } else { $v.location })
  $tail += (F 'Aspecto físico' $v.look) + (F 'Personalidad' $v.personality) + (F 'Voz y gestos (cómo interpretarlo en mesa)' $v.voice)
  $tail += (F 'Qué sabe' $v.knows) + (F 'Qué está haciendo' $v.doing)
}

$tail += (H1 '12. FAMILIAS Y VÍNCULOS') + (T 'Quién es familia de quién en Ethar, buenos y malos. Lo marcado con [PROPUESTA] está pendiente de tu visto bueno.')
foreach ($f in $vec.familias) {
  $de = $seed.npcs.($f.de); $a = $seed.npcs.($f.a); if (-not $de -or -not $a) { continue }
  $tail += F "$($de.name), $($f.rel) $($a.name)" $(if ($f.nota) { $f.nota } else { '—' })
}
$x = $x.Substring(0, $s) + $tail + $x.Substring($s)

# --- Guardar ---
$entry.Delete()
$new = $zip.CreateEntry('word/document.xml')
$sw = New-Object IO.StreamWriter($new.Open(), $utf8); $sw.Write($x); $sw.Close()
$zip.Dispose()
if ($Copy -and (Test-Path (Split-Path $Copy))) { Copy-Item $Docx $Copy -Force; "Copiado también a: $Copy" }
"Word actualizado: $Docx"
