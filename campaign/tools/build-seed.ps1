# Convierte el Word de importación en data/seed.js (datos iniciales de la app).
# Uso: powershell -ExecutionPolicy Bypass -File tools\build-seed.ps1
param([string]$Docx = "$PSScriptRoot\..\docs\Othran_Vel_Campana_Importacion.docx")

Add-Type -AssemblyName System.IO.Compression.FileSystem
$root = Resolve-Path "$PSScriptRoot\.."

# --- Leer párrafos del docx ---
$zip = [IO.Compression.ZipFile]::OpenRead((Resolve-Path $Docx))
$entry = $zip.GetEntry("word/document.xml")
$sr = New-Object IO.StreamReader($entry.Open(), [Text.Encoding]::UTF8)
$x = [xml]$sr.ReadToEnd(); $sr.Close(); $zip.Dispose()
$ns = New-Object Xml.XmlNamespaceManager($x.NameTable)
$ns.AddNamespace("w", "http://schemas.openxmlformats.org/wordprocessingml/2006/main")
$lines = foreach ($p in $x.SelectNodes("//w:body//w:p", $ns)) {
  $t = (($p.SelectNodes(".//w:t", $ns) | ForEach-Object { $_.InnerText }) -join "").Trim()
  if ($t) { $t }
}

function Slug([string]$s) {
  $s = ($s -replace '«[^»]*»', '').Normalize([Text.NormalizationForm]::FormD)
  $s = -join ($s.ToCharArray() | Where-Object { [Globalization.CharUnicodeInfo]::GetUnicodeCategory($_) -ne 'NonSpacingMark' })
  (($s.ToLower() -replace '[^a-z0-9]+', '-').Trim('-'))
}

# Etiqueta del Word -> clave interna (se compara por prefijo)
$locKeys = [ordered]@{
  'Tipo' = 'type'; 'Dentro de' = 'parent'; 'Ubicación aproximada' = 'where'
  'Descripción para leer' = 'read'; 'Descripción general para leer' = 'read'
  'Notas del máster' = 'dm'; 'Facción o gobierno' = 'faction'
  'NPCs importantes' = 'npcs'; 'NPCs que se encuentran aquí' = 'npcs'
  'Objetos, precios o servicios' = 'items'; 'Ganchos' = 'hooks'
  '¿Visitado por los jugadores?' = 'visited'; 'Ambiente' = 'ambience'
}
$npcKeys = [ordered]@{
  'Raza' = 'race'; 'Rol / ocupación' = 'role'; 'Dónde se encuentra' = 'location'; 'Facción' = 'faction'
  'Aspecto físico' = 'look'; 'Personalidad' = 'personality'; 'Voz y gestos' = 'voice'
  'Qué quiere' = 'wants'; 'Qué sabe' = 'knows'; 'Secretos' = 'secrets'
  'Relación con los jugadores' = 'pcRel'; 'Relación con otros NPCs' = 'npcRel'
  'Estado' = 'status'; '¿Lo conocen' = 'known'; 'Frase típica' = 'quote'
}
$facKeys = [ordered]@{
  'Descripción' = 'desc'; 'Objetivos' = 'goals'; 'Líder' = 'leader'
  'Miembros conocidos' = 'members'; 'Relación con los jugadores' = 'pcRel'
}
$questKeys = [ordered]@{
  'Quién la da' = 'giver'; 'Dónde' = 'where'; 'Estado' = 'status'; 'Resumen' = 'summary'; 'Notas del máster' = 'dm'
}
$worldKeys = [ordered]@{
  'Nombre del mundo' = 'name'; 'Resumen general' = 'dm'; 'Tono' = 'tone'; 'Situación actual' = 'situation'
}

function KeyOf($line, $keys) {
  if ($line -notmatch '^([^:]{2,80}):\s*(.*)$') { return $null }
  $label = $Matches[1]; $val = $Matches[2]
  foreach ($k in $keys.Keys) { if ($label.StartsWith($k)) { return @($keys[$k], $val) } }
  return $null
}

# Parte un bloque de sección en entradas: una línea sin clave seguida de una con clave = título
function ParseBlocks($ls, $keys) {
  $items = @(); $cur = $null; $last = $null
  for ($i = 0; $i -lt $ls.Count; $i++) {
    $kv = KeyOf $ls[$i] $keys
    $nextKv = if ($i + 1 -lt $ls.Count) { KeyOf $ls[$i + 1] $keys } else { $null }
    if (-not $kv -and $nextKv) {
      $cur = [ordered]@{ name = $ls[$i] }; $items += $cur; $last = $null
    } elseif ($kv -and $cur) {
      if ($cur.Contains($kv[0])) { $cur[$kv[0]] += "`n" + $kv[1] } else { $cur[$kv[0]] = $kv[1] }
      $last = $kv[0]
    } elseif ($cur -and $last) {
      $cur[$last] += "`n" + $ls[$i]
    }
  }
  $items
}

# --- Secciones ---
$sec = @{}; $curSec = $null
foreach ($l in $lines) {
  if ($l -match '^(\d)\. ') { $curSec = [int]$Matches[1]; $sec[$curSec] = New-Object Collections.ArrayList; continue }
  if ($curSec) { [void]$sec[$curSec].Add($l) }
}

# Sección 1: mundo
$world = [ordered]@{}; $last = $null
foreach ($l in $sec[1]) {
  $kv = KeyOf $l $worldKeys
  if ($kv) { $world[$kv[0]] = $kv[1]; $last = $kv[0] } elseif ($last) { $world[$last] += "`n" + $l }
}

$locs = @(ParseBlocks $sec[2] $locKeys) + @(ParseBlocks $sec[4] $locKeys)

# Sección 3: se fusiona en Ethar
$etharExtra = [ordered]@{}; $last = $null
foreach ($l in $sec[3]) {
  $kv = KeyOf $l $locKeys
  if ($kv) { $etharExtra[$kv[0]] = $kv[1]; $last = $kv[0] } elseif ($last) { $etharExtra[$last] += "`n" + $l }
}

$npcs = ParseBlocks $sec[5] $npcKeys
$facs = ParseBlocks $sec[6] $facKeys
$quests = ParseBlocks $sec[7] $questKeys

# --- Árbol de lugares ---
$out = [ordered]@{}
$out['mundo'] = [ordered]@{ id = 'mundo'; name = 'Mundo'; type = 'mundo'; parent = $null
  dm = $world.dm; tone = $world.tone; situation = $world.situation }

foreach ($l in $locs) {
  $id = Slug $l.name
  $o = [ordered]@{ id = $id }
  foreach ($k in $l.Keys) { $o[$k] = $l[$k] }
  $o.parent = if ($l.parent -eq 'Mundo') { 'mundo' } else { Slug $l.parent }
  $o.visited = ($l.visited -match '^s')
  $o.secret = ($l.where -match 'SECRETO')
  $out[$id] = $o
}
foreach ($k in $etharExtra.Keys) {
  if ($k -eq 'dm') { $out['ethar'].dm = $etharExtra.dm + "`n`n" + $out['ethar'].dm }
  else { $out['ethar'][$k] = $etharExtra[$k] }
}

# Lugares que aparecen en el mapa de Ethar pero no en el Word
$out['la-atalaya'] = [ordered]@{ id = 'la-atalaya'; name = 'La Atalaya'; type = 'otro (torre de vigía)'; parent = 'ethar'
  read = '[POR DEFINIR]'; dm = '[POR DEFINIR] (aparece en el mapa de Ethar, no en el documento)'; visited = $false; secret = $false }

# Mapas y fotos
$out['othran-vel'].map = 'maps/mundo.png'
$out['ethar'].map = 'maps/Mapa fantástico de Ethar y su puerto.png'
$out['ethar'].image = 'img/ethar visual.png'
$out['timon-escarlata'].image = 'img/solo en su taberna.png'
$out['mazmorra-bajo-el-almacen-sur'].map = 'maps/almacen sur sotano.jpg'

# Salas de la mazmorra (R1-R12) como sublugares con su pin
$dm = $out['mazmorra-bajo-el-almacen-sur'].dm
$roomNotes = @{
  R2 = '4 Matones del Rojo.'; R4 = '3-4 goblins «prestados» por Rellan Voss (ya fallecido).'
  R6 = 'Armería con las armas robadas del Retén (misión de Ordell Maskan).'
  R8 = 'Aquí desemboca el túnel secreto de Bonnie.'
  R9 = '2 bugbears fijos + 2 de ronda como refuerzo solo si hay ruido.'; R10 = '4 Matones del Rojo.'
  R12 = 'Aposentos de Corvan (vacíos si escapó), con escritorio y correspondencia (lo que pide Reva Sonn). Escalera secreta hacia la Casa Consistorial.'
}
$roomPos = @{ R1 = 1490, 1010; R2 = 1060, 885; R3 = 1615, 700; R4 = 1120, 580; R5 = 1300, 390; R6 = 1090, 270
  R7 = 750, 270; R8 = 570, 765; R9 = 265, 1070; R10 = 265, 640; R11 = 260, 335; R12 = 445, 270 }
foreach ($n in 1..12) {
  $r = "R$n"; $id = "mazmorra-r$n"
  $out[$id] = [ordered]@{ id = $id; name = "Sala $r"; type = 'sala'; parent = 'mazmorra-bajo-el-almacen-sur'
    read = '[POR DEFINIR]'; dm = $(if ($roomNotes[$r]) { $roomNotes[$r] } else { '[POR DEFINIR]' }); visited = $false; secret = $false
    pin = @([math]::Round($roomPos[$r][0] / 1800, 4), [math]::Round($roomPos[$r][1] / 1282, 4)) }
}

# --- Pins (píxeles sobre cada mapa) ---
$worldPins = @{
  'sol-veleth' = 228, 695; 'aldea-de-tessval' = 237, 737; 'playa-del-naufragio' = 157, 618; 'fanghol' = 358, 415
  'cumbres-nethrim' = 500, 140; 'bosque-de-vharn' = 610, 480; 'colinas-estelares' = 985, 470
  'circulo-de-la-corriente' = 798, 622; 'greypost' = 465, 668; 'refugio-del-halcon' = 625, 695
  'casona-de-vharn' = 792, 705; 'guarida-de-vessa' = 888, 713; 'aramark' = 808, 748; 'rancho-ceniza' = 975, 735
  'santuario-del-pulso' = 975, 805; 'el-pozo-del-alma' = 948, 860; 'deeprock-neigh' = 948, 925
  'aserradero-de-vharn' = 497, 768; 'tumulo-quetrado' = 408, 825; 'castillo-de-azorak' = 575, 875
  'la-cala-del-ahorcado' = 557, 945; 'camino-de-sal' = 720, 880; 'el-recodo-de-las-zarzas' = 640, 925
  'ethar' = 462, 995; 'torre-de-las-mareas' = 340, 1078; 'la-veta-gris' = 760, 1012; 'picos-cuernoazul' = 855, 975
  'la-caverna-del-eco' = 728, 1052; 'colina-umbria' = 660, 1090; 'forjaeterna' = 963, 1080; 'kharngrim' = 610, 1222
  'colonia-gnoma' = 800, 1222; 'bosque-cthajun' = 920, 1270; 'sal-menor' = 445, 1290; 'cienaga-muda' = 560, 1430
  'camino-velan' = 420, 1200; 'sierra-de-theran' = 820, 880; 'picos-de-ethalun' = 790, 1140
}
$etharPins = @{
  'casa-consistorial' = 850, 180; 'capilla-de-la-espiral-incompleta' = 605, 330; 'la-atalaya' = 120, 395
  'el-reten' = 1120, 360; 'timon-escarlata' = 490, 455; 'plaza-del-pregon' = 790, 545; 'tienda-de-gungar' = 530, 600
  'almacen-sur' = 350, 740; 'muelle-de-ethar' = 720, 750; 'el-ancla-rota' = 255, 640
  'camino-de-los-huertos' = 1000, 140; 'mazmorra-bajo-el-almacen-sur' = 395, 800
}
foreach ($k in $worldPins.Keys) { if ($out[$k]) { $out[$k].pin = @([math]::Round($worldPins[$k][0] / 1062, 4), [math]::Round($worldPins[$k][1] / 1482, 4)) } else { Write-Warning "Pin sin lugar: $k" } }
foreach ($k in $etharPins.Keys) { if ($out[$k]) { $out[$k].pin = @([math]::Round($etharPins[$k][0] / 1262, 4), [math]::Round($etharPins[$k][1] / 1246, 4)) } else { Write-Warning "Pin sin lugar: $k" } }

# --- NPCs: personajes jugadores + NPCs del Word ---
$npcOut = [ordered]@{}
$pcs = @(
  @{ name = 'Ferrum'; race = 'Goliath'; role = 'Paladín (Juramento de Gloria)'; origin = 'Forjaeterna (Clan Durhammer)' },
  @{ name = 'Thal'; race = 'Gnomo'; role = 'Pícaro Mastermind, con un pseudodragón'; origin = 'Rocapistón (Othran Sol)'; image = 'img/PJs/thal.png'; aka = 'Lord Thales Cronosfera' },
  @{ name = 'Musel'; race = 'Humano'; role = 'Guerrero. Amnesia, ex-Custodio del Pulso (nombre puesto por Bram)' },
  @{ name = 'Bram Ferragulla'; race = 'Mediano'; role = 'Artificiero Artillerista'; origin = 'Aldea de Tessval' },
  @{ name = 'Borin'; race = 'Enano'; role = 'Bárbaro. Desaparecido desde la mañana tras el campamento'; origin = 'Kharngrim' }
)
foreach ($p in $pcs) {
  $id = Slug $p.name
  $npcOut[$id] = [ordered]@{ id = $id; name = $p.name; pc = $true; race = $p.race; role = $p.role; status = 'vivo'; known = 'sí'
    look = $(if ($p.aka) { "Nombre completo: $($p.aka)" } else { '' }); npcRel = $(if ($p.origin) { "Origen: $($p.origin)" } else { '' }) }
  if ($p.image) { $npcOut[$id].image = $p.image }
}
foreach ($n in $npcs) {
  $id = Slug $n.name
  if ($npcOut.Contains($id)) { $id = "$id-npc" }
  $o = [ordered]@{ id = $id }
  foreach ($k in $n.Keys) { $o[$k] = $n[$k] }
  $o.pc = $false
  $npcOut[$id] = $o
}
$npcOut['matones-del-rojo'] = [ordered]@{ id = 'matones-del-rojo'; name = 'Matones del Rojo'; pc = $false; race = 'Humanos (varios)'
  role = 'Matones de la Sal Negra (grupo genérico)'; location = 'Almacén Sur'; faction = 'La Sal Negra'
  look = 'Pañuelo rojo como distintivo. Cambian de turno al anochecer.'; status = 'vivos'; known = 'sí (de oídas)' }
$img = @{ 'gungar' = 'img/npcs/gungar.png'; 'maestro-kharzun' = 'img/npcs/kharzun.png'; 'skirx' = 'img/PJs/skrix.png'; 'solo' = 'img/solo en su taberna.png' }
foreach ($k in $img.Keys) { if ($npcOut[$k]) { $npcOut[$k].image = $img[$k] } else { Write-Warning "Imagen sin NPC: $k" } }

# --- Interiores (data/interiores.json): plano, estancias y NPCs situados ---
$intFile = "$root\data\interiores.json"
if (Test-Path $intFile) {
  $int = Get-Content $intFile -Raw -Encoding UTF8 | ConvertFrom-Json
  foreach ($p in $int.PSObject.Properties) {
    $b = $p.Value; $bid = $p.Name
    if (-not $out[$bid]) { Write-Warning "Interior sin lugar: $bid"; continue }
    $out[$bid].map = $b.map
    $w = $b.size[0]; $h = $b.size[1]
    foreach ($z in $b.zones) {
      $out[$z.id] = [ordered]@{ id = $z.id; name = $z.name; type = 'estancia'; parent = $bid; num = $z.num
        read = $z.read; dm = $z.dm; items = $z.items; visited = $false; secret = [bool]$z.secret
        pin = @([math]::Round($z.pin[0] / $w, 4), [math]::Round($z.pin[1] / $h, 4)) }
    }
    foreach ($n in $b.npcs) {
      if (-not $npcOut[$n.id]) { Write-Warning "NPC situado que no existe: $($n.id)"; continue }
      $npcOut[$n.id].spot = [ordered]@{ at = $n.zone; pin = @([math]::Round($n.pin[0] / $w, 4), [math]::Round($n.pin[1] / $h, 4)) }
      $npcOut[$n.id].doing = $n.doing
    }
  }
}

$facOut = [ordered]@{}; foreach ($f in $facs) { $id = Slug $f.name; $o = [ordered]@{ id = $id }; foreach ($k in $f.Keys) { $o[$k] = $f[$k] }; $facOut[$id] = $o }
$qOut = [ordered]@{}; foreach ($q in $quests) { $id = Slug $q.name; $o = [ordered]@{ id = $id }; foreach ($k in $q.Keys) { $o[$k] = $q[$k] }; $qOut[$id] = $o }

$seed = [ordered]@{
  version = 1; title = 'Othran Vel'; group = "Ecos d'Othalun"; logo = 'img/othran vel logo.png'; start = 'othran-vel'
  locations = $out; npcs = $npcOut; factions = $facOut; quests = $qOut
}
$json = $seed | ConvertTo-Json -Depth 8 -Compress
[IO.File]::WriteAllText("$root\data\seed.js", "window.SEED = $json;`n", (New-Object Text.UTF8Encoding($false)))
"Lugares: $($out.Count)  NPCs: $($npcOut.Count)  Facciones: $($facOut.Count)  Misiones: $($qOut.Count)"
