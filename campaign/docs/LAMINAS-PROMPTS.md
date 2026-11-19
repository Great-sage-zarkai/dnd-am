# Láminas de imágenes para la app · Othran Vel

Cada lámina = **1 imagen de ChatGPT con 4 retratos** (cuadrícula 2×2). El script las recorta en 4 y la app las coloca sola.

## Cómo usarlo

1. Copia el prompt de la lámina que toque y pégalo en ChatGPT (o Gemini, Bing Image Creator…).
2. Descarga la imagen y guárdala **con el nombre exacto** que pone (p. ej. `lamina-01.png`) en:
   `campaign/img/laminas/`
3. Avísame (o ejecuta el script tú):
   ```
   powershell -ExecutionPolicy Bypass -File campaign/tools/split-laminas.ps1
   ```
4. Recarga la app (F5). Listo.

**Importante:** el orden de los 4 personajes es siempre
**1 arriba-izquierda · 2 arriba-derecha · 3 abajo-izquierda · 4 abajo-derecha**.
Si ChatGPT los coloca en otro orden, dímelo y lo corrijo.

**Si sale una imagen suelta de un solo personaje** (porque te gusta más hacerla aparte), guárdala directamente en `campaign/img/npcs/` con el nombre del personaje en minúsculas y guiones: `dory.png`, `travis-donovan.png`… Para lugares, en `campaign/img/lugares/` (`muelle-de-ethar.png`). El script también las detecta.

**Si ves aspectos inventados** (marcados con *), es porque en tu Word estaban [POR DEFINIR]. Cámbialos a tu gusto antes de pegar.

---

## Orden recomendado (3 al día)

| Día | Láminas |
|---|---|
| 1 | lamina-01 · lamina-02 · lugares-01 (todo lo de la próxima sesión en Ethar) |
| 2 | lamina-03 · lamina-04 · lugares-02 |
| 3 | lamina-05 · lamina-06 · lugares-03 |
| 4 | lamina-07 · lamina-08 · lamina-09 (los PJ: igual tus jugadores prefieren su propia imagen) |
| 5 | lamina-10 · lugares-04 · lugares-05 |

---

## PERSONAJES

### lamina-01 · Ethar, próxima sesión

```
Crea una lámina de retratos de personajes de fantasía medieval para una campaña de D&D. Formato vertical 2:3. Cuadrícula de 2×2 con exactamente 4 retratos del mismo tamaño, separados por un borde fino y uniforme de color pergamino claro. Cada retrato es de busto, mirando a cámara o en tres cuartos, con un fondo sencillo y desenfocado acorde al personaje. Estilo: ilustración pintada digital semirrealista, colores cálidos y terrosos, iluminación suave, mismo estilo en los 4. Sin texto, sin nombres, sin marcos decorativos.

1 (arriba izquierda): Travis Donovan, humano de unos 40 años, enjuto y seco, cara curtida por el sol y la sal, ropa de trabajo de estibador con cuerdas al hombro, expresión desconfiada. Fondo: muelle de un puerto pesquero.
2 (arriba derecha): Brac Donovan, humano joven, complexión normal, ropa de mensajero de viaje maltrecha y sucia tras un cautiverio, con algún moratón, sonrisa nerviosa. Fondo: camino costero.
3 (abajo izquierda): Corvan Athel, humano de unos 35 años, aspecto tranquilo y casi aburrido pero con ojeras de desesperación, ropa de capataz de almacén, un pañuelo rojo en el brazo, alza una mano como pidiendo calma. Fondo: almacén oscuro con cajas.
4 (abajo derecha): Dory «el Rojo», alcalde humano de mediana edad, carismático y peligroso, barba cuidada, pañuelo rojo anudado al cuello, casaca oscura de buena calidad, sonrisa amable que no llega a los ojos. Fondo: despacho de piedra con ventana al puerto al atardecer.
```

### lamina-02 · Ethar

```
Crea una lámina de retratos de personajes de fantasía medieval para una campaña de D&D. Formato vertical 2:3. Cuadrícula de 2×2 con exactamente 4 retratos del mismo tamaño, separados por un borde fino y uniforme de color pergamino claro. Cada retrato es de busto, mirando a cámara o en tres cuartos, con un fondo sencillo y desenfocado acorde al personaje. Estilo: ilustración pintada digital semirrealista, colores cálidos y terrosos, iluminación suave, mismo estilo en los 4. Sin texto, sin nombres, sin marcos decorativos.

1 (arriba izquierda): Reva Sonn, mercader humana de unos 40 años, porte cuidado y elegante, cuaderno de cuentas bajo el brazo, mirada calculadora y sonrisa sutil. Fondo: mercado de una plaza.
2 (arriba derecha): El pregonero, hombre menudo y mayor, boca abierta proclamando con voz potente, sujeta un pergamino arrugado, insignia descolorida de un gremio mercante en la solapa. Fondo: plaza de pueblo costero.
3 (abajo izquierda): El viejo, anciano humano amable y paciente, mirada triste y perdida, sentado con una jarra en una taberna. Fondo: taberna cálida con vigas bajas.
4 (abajo derecha): El erudito, estudioso de unos 30 años con ropajes de lino sin teñir, con una espiral bordada en el pecho que no llega a cerrarse, aspecto discreto e inquieto. Fondo: taberna en penumbra.
```

### lamina-03 · Ethar

```
Crea una lámina de retratos de personajes de fantasía medieval para una campaña de D&D. Formato vertical 2:3. Cuadrícula de 2×2 con exactamente 4 retratos del mismo tamaño, separados por un borde fino y uniforme de color pergamino claro. Cada retrato es de busto, mirando a cámara o en tres cuartos, con un fondo sencillo y desenfocado acorde al personaje. Estilo: ilustración pintada digital semirrealista, colores cálidos y terrosos, iluminación suave, mismo estilo en los 4. Sin texto, sin nombres, sin marcos decorativos.

1 (arriba izquierda): Dess Marrow, pescadora humana de unos 40 años, fuerte, manos encallecidas, ropa de faena con escamas y barro, gesto franco. Fondo: muelle con redes.
2 (arriba derecha): Bonnie, niña humana de unos 10 años, pícara y curiosa, pelo revuelto, ropa sencilla de pueblo pesquero. Fondo: cajas apiladas en un muelle. *
3 (abajo izquierda): Herenna, mujer humana delgada, pelo corto y gris prematuro, manos manchadas de tinta, ropajes de lino sin teñir con una espiral bordada incompleta. Fondo: pequeña capilla con velas.
4 (abajo derecha): Ordell Maskan, capitán de la guardia humano de cincuenta y tantos, corpulento pero venido a menos, cicatriz en la ceja izquierda, barba entrecana, gambesón gastado. Fondo: cuartel de piedra.
```

### lamina-04 · Ethar

```
Crea una lámina de retratos de personajes de fantasía medieval para una campaña de D&D. Formato vertical 2:3. Cuadrícula de 2×2 con exactamente 4 retratos del mismo tamaño, separados por un borde fino y uniforme de color pergamino claro. Cada retrato es de busto, mirando a cámara o en tres cuartos, con un fondo sencillo y desenfocado acorde al personaje. Estilo: ilustración pintada digital semirrealista, colores cálidos y terrosos, iluminación suave, mismo estilo en los 4. Sin texto, sin nombres, sin marcos decorativos.

1 (arriba izquierda): Kessil Thorn, veterano humano de unos 60 años, postura firme y militar, le falta un brazo y la manga vacía va prendida al hombro, mirada dura. Fondo: casa rural al final de un camino.
2 (arriba derecha): Doran, elfo oscuro (drow) anciano y retirado, piel gris oscura, pelo blanco recogido, ropa sencilla de hortelano, mirada serena y atenta. Fondo: huerto al atardecer. *
3 (abajo izquierda): Greha, orca tabernera, robusta, colmillos pequeños, delantal sucio, gesto hosco y desganado. Fondo: taberna cutre del puerto. *
4 (abajo derecha): Francis, humano de unos 30 años, ropajes de lino sin teñir con una espiral bordada incompleta, sostiene un cuaderno y una pluma, gesto observador. Fondo: camino al aire libre.
```

### lamina-05 · Goblins de La Cala del Ahorcado

```
Crea una lámina de retratos de personajes de fantasía para una campaña de D&D. Formato vertical 2:3. Cuadrícula de 2×2 con exactamente 4 retratos del mismo tamaño, separados por un borde fino y uniforme de color pergamino claro. Cada retrato es de busto, con un fondo sencillo de cueva marina húmeda. Estilo: ilustración pintada digital semirrealista, colores terrosos, iluminación de antorcha, mismo estilo en los 4. Sin texto, sin nombres, sin marcos decorativos. Son goblins entre cómicos y trágicos, no monstruos malvados.

1 (arriba izquierda): Brak, goblin explorador, delgado, capucha de cuero, mirada nerviosa y preocupada.
2 (arriba derecha): Nilz, goblin explorador, orejas enormes, un ojo entrecerrado, cara de pillo asustado.
3 (abajo izquierda): Urra, goblin hembra, gesto protector, collar de conchas.
4 (abajo derecha): Grix, goblin jefe, más grande que los demás, cicatrices, un pañuelo rojo arrancado en la mano, gesto cansado.
```

### lamina-06 · Los Rockseeker

```
Crea una lámina de retratos de personajes de fantasía medieval para una campaña de D&D. Formato vertical 2:3. Cuadrícula de 2×2 con exactamente 4 retratos del mismo tamaño, separados por un borde fino y uniforme de color pergamino claro. Cada retrato es de busto, mirando a cámara o en tres cuartos, con un fondo sencillo y desenfocado acorde al personaje. Estilo: ilustración pintada digital semirrealista, colores cálidos y terrosos, iluminación suave, mismo estilo en los 4. Sin texto, sin nombres, sin marcos decorativos.

1 (arriba izquierda): Gundren Rockseeker, enano fornido, barba corta y descuidada, ropa de viaje gastada, sonrisa fácil pero ojos astutos. Fondo: carro en un camino.
2 (arriba derecha): Nundro Rockseeker, enano joven y bonachón, barba castaña trenzada, delantal de cocinero sobre ropa de minero. Fondo: cueva con luz tenue. *
3 (abajo izquierda): Tharden Rockseeker, enano mayor y severo, barba gris larga, ceño fruncido, gesto mandón, ropa de minero. Fondo: entrada de una mina. *
4 (abajo derecha): Mira Athel, mujer humana de unos 30 años, rasgos sencillos y sonrisa dulce, pintada como el retrato de un medallón antiguo. Fondo: tonos sepia.
```

### lamina-07 · Villanos

```
Crea una lámina de retratos de personajes de fantasía oscura para una campaña de D&D. Formato vertical 2:3. Cuadrícula de 2×2 con exactamente 4 retratos del mismo tamaño, separados por un borde fino y uniforme de color pergamino claro. Cada retrato es de busto, con un fondo sencillo y desenfocado acorde al personaje. Estilo: ilustración pintada digital semirrealista, colores terrosos y sombríos, iluminación dramática, mismo estilo en los 4. Sin texto, sin nombres, sin marcos decorativos.

1 (arriba izquierda): Karl Gribs «El Archivista», erudito humano de mediana edad, túnica de lino sin teñir con una espiral bordada incompleta ennegrecida, mirada fría e inteligente, rodeado de pergaminos. Fondo: archivo oscuro con velas. *
2 (arriba derecha): Rellan Voss, humano enorme como un armario de músculo, cresta mohicana, cadenas al cuello, pañuelo rojo atado en el brazo, sonrisa arrogante. Fondo: cueva marina.
3 (abajo izquierda): Snik, goblin de cráneo alargado y extraño, mirada calculadora e inquietante. Fondo: cueva marina.
4 (abajo derecha): Azorak, bugbear enorme y peludo, señor de un castillo en ruinas, armadura de pieles y metal, corona tosca, junto a un gran lobo terrible. Fondo: salón de castillo derruido.
```

### lamina-08 · Más allá de Ethar

```
Crea una lámina de retratos de personajes de fantasía medieval para una campaña de D&D. Formato vertical 2:3. Cuadrícula de 2×2 con exactamente 4 retratos del mismo tamaño, separados por un borde fino y uniforme de color pergamino claro. Cada retrato es de busto, mirando a cámara o en tres cuartos, con un fondo sencillo y desenfocado acorde al personaje. Estilo: ilustración pintada digital semirrealista, colores cálidos y terrosos, iluminación suave, mismo estilo en los 4. Sin texto, sin nombres, sin marcos decorativos.

1 (arriba izquierda): Flynheim, druida anciano, barba blanca larguísima con hojas y ramitas, bastón nudoso, ojos sabios. Fondo: ruinas cubiertas de vegetación.
2 (arriba derecha): Hamun Kost, nigromante humano demacrado, túnica oscura, ojos hundidos, mirada obsesiva de estudioso. Fondo: torre en ruinas al anochecer. *
3 (abajo izquierda): Eris Shars, exalcalde humano de unos 40 años, ropa de autoridad de pueblo arrugada, mirada perdida y confusa, como si no reconociera nada. Fondo: calle de un pueblo. *
4 (abajo derecha): Un matón del Rojo, humano rudo y joven, pañuelo rojo atado al cuello o al brazo, porra en la mano, gesto amenazante. Fondo: callejón de un puerto.
```

### lamina-09 · Los personajes jugadores (opcional)

```
Crea una lámina de retratos de personajes de fantasía medieval para una campaña de D&D. Formato vertical 2:3. Cuadrícula de 2×2 con exactamente 4 retratos del mismo tamaño, separados por un borde fino y uniforme de color pergamino claro. Cada retrato es de busto, en pose heroica, con un fondo sencillo y desenfocado. Estilo: ilustración pintada digital semirrealista, colores cálidos y terrosos, iluminación suave, mismo estilo en los 4. Sin texto, sin nombres, sin marcos decorativos.

1 (arriba izquierda): Ferrum, goliath paladín del Juramento de Gloria, piel gris con marcas tribales, armadura pesada, porte orgulloso. Fondo: montañas.
2 (arriba derecha): Musel, guerrero humano con amnesia, mirada perdida y decidida, armadura de cuero y espada, ropas de lino sin teñir rasgadas con una espiral bordada incompleta. Fondo: playa tras un naufragio.
3 (abajo izquierda): Bram Ferragulla, mediano artificiero artillero, gafas de soldador en la frente, cinturón de herramientas, pequeño cañón arcano mecánico. Fondo: taller costero.
4 (abajo derecha): Borin, enano bárbaro, barba roja salvaje, hacha a la espalda, pieles, gesto feroz. Fondo: montañas mineras.
```

### lamina-10 · Criaturas

```
Crea una lámina de ilustraciones de criaturas de fantasía oscura para una campaña de D&D. Formato vertical 2:3. Cuadrícula de 2×2 con exactamente 4 imágenes del mismo tamaño, separadas por un borde fino y uniforme de color pergamino claro. Estilo: ilustración pintada digital semirrealista, iluminación dramática, mismo estilo en las 4. Sin texto, sin nombres, sin marcos decorativos.

1 (arriba izquierda): Vessa «la que no olvida», banshee élfica fantasmal, translúcida y pálida, pelo flotando, rostro triste y bello, sostiene un espejo de plata. Fondo: ruina en un bosque oscuro.
2 (arriba derecha): Greenhorn, un dragón verde que es solo un vestigio hueco, como una cáscara de escamas vacía y agrietada con luz débil dentro. Fondo: torre en ruinas.
3 (abajo izquierda): Mormesk, espectro sombrío y alargado, sin rasgos claros, ojos de luz fría, junto a un cofre antiguo. Fondo: caverna con ecos.
4 (abajo derecha): Cicatriz, lobo grande y sarnoso con una cicatriz muy marcada en el hocico, gruñendo. Fondo: cueva marina.
```

---

## LUGARES

### lugares-01 · Ethar (día 1)

```
Crea una lámina de 4 ilustraciones de lugares de fantasía medieval para una campaña de D&D. Formato horizontal 3:2. Cuadrícula de 2×2 con exactamente 4 escenas del mismo tamaño, separadas por un borde fino y uniforme de color pergamino claro. Estilo: ilustración pintada digital semirrealista, colores cálidos y terrosos, mismo estilo y misma hora del día en las 4 (media tarde, casi anocheciendo). Todas son del mismo pueblo pesquero costero de tejados de pizarra. Sin texto, sin nombres, sin marcos decorativos, sin personajes en primer plano.

1 (arriba izquierda): El muelle de Ethar: muelle de carga de madera con cajas apiladas, gaviotas, pescadores recogiendo redes y una goleta amarrada descargando.
2 (arriba derecha): La Plaza del Pregón: plaza empedrada con una fuente, puestos de mercado y una caja de madera desgastada en el centro donde se lee el pregón.
3 (abajo izquierda): El Almacén Sur: nave baja de madera y piedra junto al agua, puertas entornadas, ambiente silencioso e inquietante.
4 (abajo derecha): La Casa Consistorial: edificio de piedra serio y sólido en lo alto de una colina baja que domina el puerto.
```

### lugares-02 · Ethar

```
Crea una lámina de 4 ilustraciones de lugares de fantasía medieval para una campaña de D&D. Formato horizontal 3:2. Cuadrícula de 2×2 con exactamente 4 escenas del mismo tamaño, separadas por un borde fino y uniforme de color pergamino claro. Estilo: ilustración pintada digital semirrealista, colores cálidos y terrosos, mismo estilo en las 4. Todas son del mismo pueblo pesquero costero. Sin texto, sin nombres, sin marcos decorativos, sin personajes en primer plano.

1 (arriba izquierda): La Capilla de la Espiral Incompleta: pequeña capilla de piedra sencilla, con una espiral tallada sobre la puerta que no llega a cerrarse, velas en el interior.
2 (arriba derecha): El Retén: cuartel de la guardia de piedra, pequeño y algo descuidado, armero medio vacío.
3 (abajo izquierda): El Ancla Rota: taberna mala y destartalada del puerto, cartel con un ancla partida, ambiente sórdido. *
4 (abajo derecha): Mazmorra bajo el almacén: sótano y túneles de piedra antigua bajo un almacén, con una grieta por la que corre agua, antorchas y cajas de contrabando.
```

### lugares-03 · Ethar y alrededores

```
Crea una lámina de 4 ilustraciones de lugares de fantasía medieval para una campaña de D&D. Formato horizontal 3:2. Cuadrícula de 2×2 con exactamente 4 escenas del mismo tamaño, separadas por un borde fino y uniforme de color pergamino claro. Estilo: ilustración pintada digital semirrealista, colores cálidos y terrosos, mismo estilo en las 4. Sin texto, sin nombres, sin marcos decorativos, sin personajes en primer plano.

1 (arriba izquierda): Interior de la tienda de un enano: estanterías de suelo a techo con cuerdas, clavos, sacos de provisiones y hachas, olor a cuero y madera de pino.
2 (arriba derecha): La Atalaya: torre de vigía de piedra sobre un promontorio rocoso junto al mar. *
3 (abajo izquierda): Camino de los Huertos: camino de tierra entre huertos y cercas a las afueras de un pueblo costero, con una casa al fondo. *
4 (abajo derecha): El Recodo de las Zarzas: curva de un camino donde el bosque se cierra, terraplén empinado y matorral denso, un caballo suelto y alforjas saqueadas en el suelo.
```

### lugares-04 · El mundo

```
Crea una lámina de 4 ilustraciones de lugares de fantasía medieval para una campaña de D&D. Formato horizontal 3:2. Cuadrícula de 2×2 con exactamente 4 escenas del mismo tamaño, separadas por un borde fino y uniforme de color pergamino claro. Estilo: ilustración pintada digital semirrealista, mismo estilo en las 4. Sin texto, sin nombres, sin marcos decorativos.

1 (arriba izquierda): Sol Veleth: gran ciudad portuaria de calles empedradas y gremios, de noche y en fiesta, con farolillos y mercados abiertos.
2 (arriba derecha): El Camino de Sal: camino que bordea la costa entre el mar y un bosque de terraplenes y matorral denso.
3 (abajo izquierda): Greypost: pueblo en ruinas cubierto de vegetación junto a un río que baja de un bosque, con una torre derruida. *
4 (abajo derecha): El Castillo de Azorak: castillo en ruinas oculto en un bosque denso, murallas derrumbadas, humo de hogueras goblinoides. *
```

### lugares-05 · La Sierra de Theran

```
Crea una lámina de 4 ilustraciones de lugares de fantasía medieval para una campaña de D&D. Formato horizontal 3:2. Cuadrícula de 2×2 con exactamente 4 escenas del mismo tamaño, separadas por un borde fino y uniforme de color pergamino claro. Estilo: ilustración pintada digital semirrealista, mismo estilo en las 4, ambiente misterioso. Sin texto, sin nombres, sin marcos decorativos.

1 (arriba izquierda): Aramark: pueblo en ruinas abandonado en colinas, casas de piedra sin techo, niebla. *
2 (arriba derecha): El Pozo del Alma: torre de vigía en ruinas en un páramo, con un pozo antiguo y luz verdosa, figuras de zombis a lo lejos.
3 (abajo izquierda): Deeprock Neigh: peñasco rocoso enorme que se ve desde lejos, con un campamento de merodeadores en lo alto. *
4 (abajo derecha): La Caverna del Eco: entrada a una mina enana antigua y olvidada en la ladera de una montaña, con runas en el dintel. *
```
