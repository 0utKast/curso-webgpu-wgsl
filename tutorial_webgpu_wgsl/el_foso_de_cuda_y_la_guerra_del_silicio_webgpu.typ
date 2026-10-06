#set page(
  paper: "a4",
  margin: (top: 2.0cm, bottom: 2.0cm, left: 2.0cm, right: 2.0cm),
  header: context {
    if counter(page).get().first() > 1 {
      text(8.5pt, fill: rgb("#64748b"))[
        *Arquitectura de Sistemas en el Navegador* | _El Foso de CUDA y la Guerra del Silicio_
        #h(1fr)
        WebGPU & Open Standards
      ]
    }
  },
  footer: context {
    text(8.5pt, fill: rgb("#94a3b8"))[
      #line(length: 100%, stroke: 0.5pt + rgb("#cbd5e1"))
      #v(2pt)
      Arquitectura de Sistemas en el Navegador: De WebAssembly a WebGPU y WGSL
      #h(1fr)
      Página #counter(page).display("1 de 1", both: true)
    ]
  }
)

#set text(
  font: ("Helvetica", "Arial"),
  size: 8.8pt,
  fill: rgb("#1e293b"),
  lang: "es",
  spacing: 115%
)

#set par(
  justify: true,
  leading: 0.55em
)

// Header Banner
#block(
  fill: rgb("#f8fafc"),
  stroke: (left: 4pt + rgb("#0284c7")),
  inset: (x: 16pt, y: 12pt),
  radius: (right: 4pt),
  width: 100%,
  [
    #text(16pt, weight: "bold", fill: rgb("#0f172a"))[El Foso de CUDA y la Guerra del Silicio]
    
    #v(3pt)
    #text(11pt, weight: "medium", fill: rgb("#0369a1"))[
      La Batalla Geopolítica y Económica que WebGPU Está Redibujando
    ]
    
    #v(5pt)
    #text(8.5pt, fill: rgb("#475569"))[
      *Serie:* _Arquitectura de Sistemas en el Navegador (BrowserOS)_ | *Autoría:* Antigravity Engineering Lab \
      *Referencias en O'Reilly:* #link("https://learning.oreilly.com/library/view/-/9780323984638/?orm_source=mcp")[Programming Massively Parallel Processors (Kirk & Hwu)], #link("https://learning.oreilly.com/library/view/-/9781098166298/?orm_source=mcp")[AI Engineering (Chip Huyen)] y #link("https://learning.oreilly.com/library/view/-/9780128226742/?orm_source=mcp")[Computer Organization and Design (Patterson & Hennessy)]
    ]
  ]
)

#v(10pt)

== 1. Introducción: La Trampa de la Mitología Apocalíptica frente a la Realidad del Silicio

En el debate público contemporáneo sobre la inteligencia artificial conviven dos mundos irreconciliables. Por un lado, las redes sociales y el sensacionalismo mediático permanecen atrapados en un relato cuasi-religioso: especulaciones sobre la superinteligencia artificial general (AGI), agentes rebeldes y proclamas apocalípticas sobre el fin de la civilización. Es un ruido ensordecedor que apela al miedo primitivo, pero que carece de rigor ingenieril.

Por otro lado, en los laboratorios de arquitectura de computadores, en las fábricas de semiconductores de Taiwán y en los comités de estandarización web, se libra una batalla mucho más prosaica, brutal y determinante: *una guerra económica y geopolítica de billones de dólares por el control de la infraestructura de cómputo y el monopolio del silicio*.

Los balances financieros de los gigantes tecnológicos, los márgenes operativos de las aplicaciones de IA y la soberanía digital de los países no se deciden por el "alma" de una red neuronal, sino por una pregunta técnica aplastante: *¿quién controla la capa de abstracción entre el modelo matemático y los transistores del procesador?*

Durante casi dos décadas, la respuesta a esa pregunta ha tenido un único nombre: *NVIDIA* y su ecosistema de software cerrado *CUDA*. Sin embargo, la irrupción de *WebGPU* y el paradigma *Local-First* están abriendo la primera grieta estructural en este foso defensivo, transformando la distribución del poder computacional en todo el planeta.

#v(8pt)
== 2. Génesis y Anatomía del «Foso de CUDA» (*The CUDA Moat*)

Para comprender la posición dominante de NVIDIA, es necesario desarmar una creencia errónea muy extendida: *el liderazgo de NVIDIA no se basa en que fabriquen chips inalcanzables para otros ingenieros.* Equipos de diseño de silicio de clase mundial en AMD, Intel, Google, Apple o Qualcomm tienen la capacidad técnica de diseñar aceleradores con un número equivalente o superior de transistores. Lo que convirtió a NVIDIA en una de las compañías más valiosas del planeta fue una *jugada maestra de estrategia de software iniciada hace exactamente dos décadas (veinte años)*.

=== 2.1. La Apuesta de 2006: Silicio Subsidiado y Captura Universitaria
En 2006, Jensen Huang forzó a que cada tarjeta gráfica de consumo vendida por NVIDIA incluyera la circuitería necesaria para ejecutar cómputo de propósito general mediante su nueva plataforma propietaria: *CUDA (Compute Unified Device Architecture)*.

Esta decisión encareció los costes de fabricación y redujo los márgenes a corto plazo, pero vino acompañada de una estrategia de penetración implacable: *NVIDIA regaló el software, las librerías y las placas de desarrollo a todas las universidades, facultades de ingeniería y centros de investigación del mundo*.

Como explican *David B. Kirk* (antiguo director científico de NVIDIA) y *Wen-mei W. Hwu* en *Programming Massively Parallel Processors*:
#block(
  fill: rgb("#f1f5f9"),
  inset: 8pt,
  radius: 3pt,
  stroke: (left: 3pt + rgb("#0284c7")),
  [
    _«La verdadera revolución de CUDA no consistió en inventar un lenguaje nuevo, sino en proporcionar un modelo de abstracción estructurado que permitía a los científicos programar miles de hilos paralelos sin tener que fingir que sus matrices eran píxeles ni lidiar con los horrores de las APIs gráficas de la época»._
  ]
)

Cuando en 2012 estalló la revolución del *Deep Learning* con la red *AlexNet* (Alex Krizhevsky, Ilya Sutskever y Geoffrey Hinton), sus creadores la entrenaron en dos tarjetas para videojuegos NVIDIA GeForce GTX 580 domésticas utilizando CUDA. Toda la generación de investigadores que hoy lidera la industria aprendió a programar sobre primitivas de CUDA.

=== 2.2. Las Cuatro Murallas del Foso
El foso defensivo (*moat*) no es el lenguaje CUDA en sí, sino las *librerías matemáticas de bajísimo nivel* optimizadas artesanalmente durante dos décadas:
1. *`cuBLAS` (Álgebra Lineal Básica):* Millones de líneas de código ensamblador hiper-optimizado para exprimir hasta el último ciclo de reloj en multiplicaciones de matrices (*GEMM*).
2. *`cuDNN` (Redes Neuronales Profundas):* Rutinas especializadas para atención escalada (*FlashAttention*), convoluciones y funciones de activación adaptadas a la microarquitectura de cada silicio.
3. *`NCCL` (*NVIDIA Collective Communications Library*):* El software que orquesta el intercambio de gradientes y pesos entre miles de GPUs en paralelo a través de redes InfiniBand.
4. *`TensorRT`:* El compilador de inferencia que fusiona capas, cuantiza parámetros a 8 o 4 bits y descarta cálculos redundantes.

#v(8pt)
== 3. La Paradoja de los Competidores: Por Qué Intentar Vender Silicio Fracasó

Durante años, los competidores intentaron asaltar este trono confiando exclusivamente en el hardware:
- *El Calvario de AMD con ROCm:* AMD diseñó GPUs con especificaciones teóricas brutales en relación calidad/precio (Instinct MI200/MI300). Sin embargo, su pila de software (*ROCm*) arrastró problemas crónicos de instalación, drivers inestables y soporte fragmentado entre versiones de Linux.
- *El Laberinto Burocrático de OpenCL:* Diseñado originalmente por Apple y transferido a Khronos, OpenCL intentó ser el estándar abierto universal. Sin embargo, su diseño fue víctima de la lentitud burocrática de comités industriales: requería demasiado código repetitivo y carecía de librerías matemáticas de alto nivel.
- *El Candado en GitHub:* Cualquier repositorio puntero de IA incluía `#include <cuda_runtime.h>` o dependencias directas de cuDNN, haciendo que el código fuera literalmente inejecutable en hardware rival.

#v(8pt)
== 4. La Grieta en el Muro: El Abismo Económico entre Entrenamiento e Inferencia

¿Dónde empieza a resquebrajarse esta fortaleza aparentemente inexpugnable? En la frontera económica entre *Entrenar* un modelo y *Usar* un modelo (Inferencia).

Tal como detalla con maestría *Chip Huyen* en su obra de referencia *AI Engineering*:
#block(
  fill: rgb("#f1f5f9"),
  inset: 8pt,
  radius: 3pt,
  stroke: (left: 3pt + rgb("#0284c7")),
  [
    _«El entrenamiento es un gasto de capital (CapEx) finito: una empresa invierte 50 o 100 millones de dólares en entrenar un modelo durante dos meses y el proceso finaliza. La inferencia, en cambio, es un gasto operativo (OpEx) infinito: cada vez que un usuario realiza una consulta, pulsa una tecla o ejecuta un agente, hay que pagar cómputo»._
  ]
)

Servir inferencia de modelos complejos desde la nube a escala de cientos de millones de usuarios es *económicamente ruinoso y ecológicamente insostenible*:
- Alquilar una sola GPU de centro de datos cuesta entre 2 y 5 dólares por hora.
- Para el usuario, la inferencia en la nube implica *latencia de red*, dependencia de conexión constante y una cesión inaceptable de la privacidad de sus datos.

Para que la IA sea viable, debe descentralizarse: *los modelos deben ejecutarse en el dispositivo del usuario final (Edge / Local-First)*. Y en el borde de la red, NVIDIA *no tiene el monopolio*: la inmensa mayoría de los dispositivos del planeta son portátiles Mac con Apple Silicon, ultrabooks con procesadores Intel o AMD, o teléfonos móviles.

#v(8pt)
== 5. WebGPU y WGSL: El Gran Ecualizador Tecnológico

Es en este punto de inflexión donde *WebGPU* y su lenguaje de sombreado *WGSL* dejan de ser una mera especificación gráfica para convertirse en *la tecnología de emancipación más importante del software moderno*.

1. *Agnosticismo Radical del Silicio:* Diseñado por consenso en el W3C por Apple, Google, Microsoft, Mozilla e Intel. Un *Compute Shader* en WGSL no contiene directivas atadas a un fabricante; se compila a *Metal* en macOS, a *DirectX 12* en Windows o a *Vulkan* en Linux y Android.
2. *Cero Fricción de Despliegue:* El usuario no tiene que instalar el CUDA Toolkit ni lidiar con librerías de Python. Una simple URL en el navegador descarga los pesos, compila los shaders en la GPU local y ejecuta el modelo de inmediato de forma segura.
3. *WebGPU Fuera de la Web (`wgpu` nativo):* Con librerías de bajo nivel en Rust como `wgpu`, proyectos como *Burn* o *Llama.cpp* permiten crear aplicaciones nativas de escritorio y servidores que aprovechan la aceleración por GPU multiplataforma universal sin tocar una sola línea de CUDA.

#v(8pt)
== 6. Matriz Estratégica: El Escenario de Fuerzas Actual

#v(4pt)
#table(
  columns: (1fr, 1.2fr, 1.2fr),
  fill: (x, y) => if y == 0 { rgb("#f1f5f9") } else { rgb("#ffffff") },
  stroke: 0.5pt + rgb("#cbd5e1"),
  align: top + left,
  table.header(
    [*Eje de Comparación*],
    [*El Ecosistema CUDA (NVIDIA)*],
    [*El Ecosistema WebGPU (W3C / Abierto)*]
  ),
  [*Modelo de Propiedad*], [Propietario, cerrado y controlado por una empresa privada.], [Estándar abierto gobernado por el consorcio W3C.],
  [*Compatibilidad*], [Exclusivo para tarjetas NVIDIA.], [Universal: Metal, DirectX 12 y Vulkan sin cambios de código.],
  [*Despliegue*], [Requiere SDKs pesados, compilers C++ y drivers nativos.], [*Cero instalación*: funciona en navegadores y apps nativas.],
  [*Entrenamiento Masivo*], [*Imbatible* (apoyado en NCCL e InfiniBand en la nube).], [No aplicable (diseñado para cómputo en nodo local/cliente).],
  [*Inferencia Local (Edge)*], [Excelente, pero atado a hardware caro y alto consumo.], [*Extraordinario*, clave para el paradigma _Local-First_.]
)

#v(8pt)
== 7. La Gran Analogía Histórica: 3dfx Glide frente a DirectX y OpenGL

Quien no conoce la historia de la computación cree que los monopolios tecnológicos son eternos. Lo que vive NVIDIA con CUDA es idéntico a lo ocurrido a finales de los años 90 con *3dfx Interactive* y su API propietaria *Glide*:
- En 1996, 3dfx dominaba los videojuegos 3D con Glide; parecía indestructible.
- La industria del software no tolera estar cautiva eternamente: Microsoft lanzó *Direct3D (DirectX)* y la industria estandarizó *OpenGL*.
- En cuanto los desarrolladores comprobaron que podían programar una sola vez para cualquier hardware, abandonaron Glide en masa, y 3dfx terminó quebrando en el año 2000 (siendo absorbida por la propia NVIDIA).

Como formulan *Patterson y Hennessy* en *Computer Organization and Design*: *los estándares abiertos siempre terminan devorando a los estándares propietarios cuando la tecnología pasa de los laboratorios al consumo masivo*.

#v(8pt)
== 8. Bibliografía y Lecturas Recomendadas para Profundizar

1. *#link("https://learning.oreilly.com/library/view/-/9780323984638/?orm_source=mcp")[Programming Massively Parallel Processors: A Hands-on Approach (4th Edition)]* \
   _David B. Kirk y Wen-mei W. Hwu (Morgan Kaufmann)_ \
   *Justificación:* El texto canónico para entender cómo se diseñó CUDA por dentro y por qué las librerías matemáticas son la clave del rendimiento masivo.

2. *#link("https://learning.oreilly.com/library/view/-/9781098166298/?orm_source=mcp")[AI Engineering: Building Applications with Foundation Models]* \
   _Chip Huyen (O'Reilly Media, Inc.)_ \
   *Justificación:* Análisis pragmático de la economía de la IA: costes de entrenamiento frente a inferencia y la urgencia de migrar al borde (*edge*).

3. *#link("https://learning.oreilly.com/library/view/-/9780128226742/?orm_source=mcp")[Computer Organization and Design: The Hardware/Software Interface (MIPS Edition)]* \
   _David A. Patterson y John L. Hennessy (Morgan Kaufmann)_ \
   *Justificación:* Obra fundamental para comprender la barrera de la memoria (*Memory Wall*), el modelo Roofline y la estandarización de interfaces.

4. *#link("https://learning.oreilly.com/library/view/-/9781492034858/?orm_source=mcp")[Practical Deep Learning for Cloud, Mobile, and Edge]* \
   _Anirudh Koul, Siddha Ganju y Meher Kasam (O'Reilly Media, Inc.)_ \
   *Justificación:* Guía centrada en los retos de portar y ejecutar redes neuronales en navegadores y dispositivos de consumo sin depender de la nube.
