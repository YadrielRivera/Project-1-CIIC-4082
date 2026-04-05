[![Video explicativo del proyecto](https://img.youtube.com/vi/d1WwMVcVp9s/0.jpg)](https://www.youtube.com/watch?v=d1WwMVcVp9s)


# Actividad 1: Programación en RISC-V ASM utilizando Emojis
Para esta actividad aprenderemos la programación en ASM para el RISC-V utilizando la plataforma Ripes y la interfaz de usuario de LED Matrix y los botones de dirección. Las instrucciones de instalación de Ripes se encuentran en el tópico "Actividades" del curso. Además, pueden utilizar la version online de Ripes en Ripes.me.

La actividad se trabajará en grupos de 2 estudiantes.

Objetivo: Cada grupo deberá generar un juego de laberinto y manipular un pixel para salir de él. Para ésto, utilizarán y manipularán la matriz de LED y los botones direccionales de Ripes.

<img width="550" height="281" alt="image" src="https://github.com/user-attachments/assets/4391c8eb-e3fe-4934-acae-398d4aa756f6" />

### Resultados educativos: Al finalizar este mini-proyecto, los estudiantes podrán:

- Programar operaciones básicas aritméticas en ASM RV32I
- Programar subrutinas y comprender el modo de acceso y retorno
- Comprender la dinámica de acceso y traslado de memoria para elementos de entrada/salida

# Instrucciones
### 1. Selección de grupos (5%)

Deberán trabajar el mini proyecto en grupos de 2 estudiantes. Se els habilitará un elemento en Moodle para que ambos miembros se ubiquen en su grupo. Esta parte tendrá una fecha límite del viernes 13 de marzo de 2026 a media noche. Además, no se permitirán grupos de 1 estudiante salvo en casos MUY especiales y con autorización del profesor.

Diseñar y dibujar el laberinto (45%)
Deberán diseñar un laberinto de 25 pixeles de alto por 35 pixeles de ancho (25x35). Este laberinto tendrá paredes simbolizadas en el color de su elección y pasillos en otro color de su elección. Es importante que el laberinto debe poderse navegar libremente. Es decir, que no contenga regiones inalcanzables o cerradas.

Una vez diseñado, deberán dibujarlo en pantalla usando la matriz de LED de Ripes. Dicha matriz pueden accederla usando los punteros de memoria mostrados a continuación:


<img width="347" height="95" alt="image" src="https://github.com/user-attachments/assets/74146402-6577-4cab-b6f3-eb6b7c4a7664" />

En este caso, LED_MATRIX_0_BASE es una constante o un tag cuyo valor real es 0xF0000004 y representa la posición en memoria del primer pixel (superior izquierdo) de la pantalla. Por lo tanto, si quisiera escribir en dicho pixel, debería primero cargar el valor inmediato LED_MATRIX_0_BASE a un registro y luego escribir el color del pixel en formato 0x00RRGGBB a esa posición.

 A continuación encontrarán un código base que les permite dibujar tres pixeles verticales en pantalla. Les recomiento que traten de cambiar el color de los pixeles y su posición para tener una mejor idea de cómo funciona.


 ```
.data

emoji:

.word 0x00FFFF00,0x00FF00FF,0x0000FFFF

.text

li a0 LED_MATRIX_0_BASE #Base address of the LED matrix

li a1 LED_MATRIX_0_WIDTH #35*4=140

li a2 LED_MATRIX_0_HEIGHT #25

la a3, emoji

#slli t1,a1,2 #multiply by 4

lw t0, 0(a3) #yellow

sw t0,144(a0) #pixel 36 and is multiplied by 4 = 144, or the pixel 1,1 indexing from 0,0

lw t0,4(a3) #magenta

sw t0,284(a0) #144+35*4

lw t0,8(a3) #cyan

sw t0,424(a0) #144+35*4*2
```

#### Resultado: Deberán graficar en la pantalla el laberinto diseñado por ustedes mismos.

### 2. Control y dinámica del juego (40%)

En esta parte usarán el elemento D-pad que corresponde a las flechas direccionales de las I/O de Ripes.

Primero, deberán ubicar un pixel de un color que resalte (nosotros usamos el color verde en la imagen de muestra) que simbolizará el jugador. Este pixel irá ubicado en la esquina superior izquierda del laberinto como se muestra en la imagen previa. Segundo, deberán ubicar un pixel rojo en alguna parte del laberinto que simbolice la salida.

Luego de esto, deberán poder mover el pixel del jugador con el elemento D-Pad, cuyo mapeo funciona muy similar a la de la matriz de LED en las siquientes direcciones:

<img width="293" height="209" alt="image" src="https://github.com/user-attachments/assets/05064948-fdcf-41a9-bc80-1260345030bf" />

Es importante que el pixel del jugador no debe pasar a través de las paredes. Es decir, no debe colisionar con los pixeles de pared y sólo puede caminar sobre los pixeles de pasillo. 

Una vez tengan esto, el juego deberá detectar cuando el pixel del jugador llegue a la salida y poner toda la pantalla en verde simbolizando que el jugador ganó.

### Resultado: Dinámica del juego con un pixel de jugador y uno de salida. El jugador se debe poder mover a través del laberinto sin colisionar con las paredes. Además, deberá detectar cuando llegue al pixel de la salida.


### 2. Documentación (10%)

Deberán grabar un video de no más de 5 minutos en el que ambos miembros del equipo hablen y expliquen cómo funciona cada parte del mini-proyecto. Este video deberá ir subido a youtube como "unlisted" de manera que sólo usted y quien tenga el enlace puedan verlo.

# Entregables

Seleccionar grupo antes de la fecha límite (5%)

Deberán subir el archivo "laberinto.s" que genera Ripes con el código que usaron. Se evaluará de la siguiente manera: 

Laberinto (45%): [i]Tamaño correcto 25x35 (10%). [ii] Que no hayan sectores cerrados inaccesibles (10%). [iii] Dibujo sin errores de colores o posicionamiento (25%)
Control y Dinámica del juego (40%):  [i] Dibujar correctamente los pixeles de jugador y salida (5%). [ii] Movimiento del jugador sin colisionar con las paredes (25%). [iii] Detección de que el pixel del jugador llegue a la salida y muestre pantalla verde (10%).

Deberán subir un archivo pdf con el link al video de la explicación (10%)

# Entregas tardías

Se descontarán 20% de los puntos totales luego de 1 hora tarde. A partir de ahí, 20% por día adicional hasta un máximo de 3 días tarde (72 horas luego de la fecha de entrega. A partir de eso, el grupo tendrá una nota de cero.


# Evaluación de Pares

Al finalizar esta actividad se hará una evaluación de pares. La nota de su compañero(a) se afectará de la siquiente forma con respecto a la calificación obtenida. si su usted le otorga a su compañero(a):

De 90% a 100%, se multiplicará la nota por 1
De 75% a 89.999%, se multiplicará la nota por ese mismo porcentaje
De 0 a 75%, se multiplicará la nota por 0.75 y se le consultará al grupo si desea separarse
Si usted no realiza la evaluación de pares, su nota automáticamente se multiplicará por 0.5 y la de su compañero(a) por 0.75. No es negociable.

# Política de plagio

Se revisará minuciosamente los códigos de los grupos. Si se descubre plagio, el grupo llevará una nota automática de cero. Dependiendo de la falta, podrían tener una nota de cero en el curso y ser el caso remitido al decanato de asuntos académicos.

#### SEAN INTELIGENTES, USEN ESTA EXPERIENCIA PARA APRENDER Y DAR VALOR A SU PERFIL PROFESIONAL. HAGAN PLAGIO O USEN LA INTELIGENCIA ARTIFICIAL Y VERÁN QUE SU PERFIL SERÁ POBRE A NIVEL PROFESIONAL.
