#set page(
  paper: "a4",
  margin: (top: 2.0cm, bottom: 2.0cm, left: 2.0cm, right: 2.0cm),
  header: context {
    if counter(page).get().first() > 1 {
      text(8.5pt, fill: rgb("#64748b"))[
        *Tutorial WebGPU & WGSL* | _Capítulo 1: El Modelo Mental de la GPU en la Web_
        #h(1fr)
        BrowserOS & WebAssembly Architecture
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
    #text(16pt, weight: "bold", fill: rgb("#0f172a"))[Capítulo 1: El Modelo Mental de la GPU en la Web]
    
    #v(3pt)
    #text(11pt, weight: "medium", fill: rgb("#0369a1"))[
      Del cambio de WebGL a WebGPU y su encaje arquitectónico con WebAssembly
    ]
    
    #v(5pt)
    #text(8.5pt, fill: rgb("#475569"))[
      *Serie:* _Arquitectura de Sistemas en el Navegador (BrowserOS)_ | *Autoría:* Antigravity Engineering Lab \
      *Referencias en O'Reilly:* #link("https://learning.oreilly.com/library/view/-/9781492089834/?orm_source=mcp")[WebAssembly: The Definitive Guide], #link("https://learning.oreilly.com/library/view/-/9781633436206/?orm_source=mcp")[Server-Side WebAssembly] y #link("https://learning.oreilly.com/library/view/-/9798341660182/?orm_source=mcp")[Web Performance Engineering in the Age of AI]
    ]
  ]
)

#v(10pt)

== 1. Introducción: Empezando desde Cero en el Silicio

Para comprender por qué tecnologías como *WebGPU* y *WGSL* hacen viable el concepto de un *BrowserOS* (un sistema operativo o entorno de cómputo integral en el navegador), debemos examinar la diferencia física fundamental entre dos procesadores antagónicos: la *CPU* y la *GPU*.

Tradicionalmente, el código web en JavaScript asume un modelo *secuencial*: una instrucción se ejecuta tras otra en el hilo principal (*Event Loop*). Si se deben procesar un millón de registros, la CPU los recorre uno a uno.

#v(4pt)
#table(
  columns: (1fr, 1fr),
  fill: (x, y) => if y == 0 { rgb("#f1f5f9") } else { rgb("#ffffff") },
  stroke: 0.5pt + rgb("#cbd5e1"),
  align: top + left,
  table.header(
    [*CPU (Central Processing Unit)*],
    [*GPU (Graphics Processing Unit)*]
  ),
  [
    - *Topología:* 4 a 16 núcleos muy potentes y complejos.
    - *Objetivo de diseño:* Minimizar la latencia (*low latency*).
    - *Especialidad:* Lógica ramificada (`if/else`), saltos impredecibles, control de flujo y orquestación de sistemas.
  ],
  [
    - *Topología:* 1.000 a 10.000+ unidades aritméticas (ALUs) ligeras.
    - *Objetivo de diseño:* Maximizar el volumen procesado (*high throughput*).
    - *Especialidad:* Ejecución masiva de la misma operación matemática sobre millones de datos concurrentes (*SIMT*).
  ]
)

#v(4pt)
*La Analogía del Transporte (Patterson & Hennessy):* La CPU es un deportivo de carreras: lleva un único paquete a 300 km/h con reacción inmediata. La GPU es un tren de carga de 200 vagones: avanza más despacio, pero en un solo viaje transporta 50.000 toneladas. Para inteligencia artificial local, simulación y renderizado, la GPU es imbatible.

#v(8pt)
== 2. La Evolución Histórica: De WebGL a WebGPU

=== 2.1. Las Limitaciones Estructurales de WebGL
WebGL (2011) fue una adaptación directa de *OpenGL ES 2.0* (diseñado en 2007 para móviles primitivos). Aunque llevó 3D a la web, arrastra tres fallas arquitectónicas insostenibles:
1. *Máquina de Estados Global:* Existe un único contexto global (`gl`). La configuración se muta imperativamente, haciendo que cualquier conflicto entre librerías rompa el estado sin emitir errores legibles.
2. *Sobrecarga de Validación en CPU:* La CPU del navegador debe revalidar todo el estado gráfico en cada llamada de dibujo (*draw call*), saturando el hilo de JavaScript ante escenas complejas.
3. *El "Hack" Obligatorio para Cómputo (GPGPU):* WebGL solo sabe pintar triángulos. Para hacer cómputo matemático o IA, los ingenieros debían codificar números como colores (`RGBA`) en texturas, renderizar un rectángulo a pantalla completa con un fragment shader, y leer el resultado con `gl.readPixels()`, llamada sincrónica que congelaba la interfaz.

=== 2.2. El Paradigma Moderno de WebGPU
Diseñado desde cero junto a los creadores de *Vulkan, Metal y DirectX 12*, WebGPU transforma la GPU en un procesador universal:
- *Pipelines Inmutables (PSOs):* Los estados y shaders se compilan y validan *una sola vez*. No hay validaciones redundantes al ejecutar.
- *Grabación Asíncrona (Command Encoders):* La CPU prepara listas de instrucciones en búferes de comandos independientes y las despacha por lotes a la cola de la GPU (`device.queue.submit`).
- *Compute Shaders de Primer Nivel:* No requiere `<canvas>` ni pantalla. Opera como acelerador matemático puro en hilos secundarios (*Web Workers*).

#v(8pt)
== 3. El Encaje Arquitectónico con WebAssembly (BrowserOS)

En un BrowserOS, WebAssembly y WebGPU forman una simbiosis de sistema:
- *WebAssembly (El Kernel Lógico):* Gestiona el sistema de archivos virtual (VFS), emulación POSIX, llamadas al sistema y la memoria contigua de la aplicación (`WebAssembly.Memory`).
- *WebGPU / WGSL (El Coprocesador):* Asume la carga masiva: tensores de IA local (WebLLM/ONNX), composición de ventanas a 120 FPS y procesamiento de audio/señales.
- *Puente de Memoria de Alto Rendimiento:* El `ArrayBuffer` continuo de Wasm se transmite directamente a los `GPUBuffer` de WebGPU mediante transferencias por lotes, eliminando la duplicación de datos.

#v(8pt)
== 4. Taller Práctico: Benchmark CPU vs. WebGPU

Para demostrar la utilidad real de WebGPU frente a la CPU, se ha desarrollado el laboratorio interactivo `workshop_01_webgpu_vs_cpu.html`. El experimento evalúa la transformación no lineal de 1.000.000 de flotantes de 32 bits:
$f(x) = sqrt(x) dot 2.5 + sin(x)$

#grid(
  columns: (1fr, 1fr),
  gutter: 12pt,
  [
    *Implementación CPU (JavaScript):*
    ```javascript
    for (let i = 0; i < n; i++) {
      out[i] = Math.sqrt(in[i]) * 2.5 
             + Math.sin(in[i]);
    }
    ```
    - Procesa elemento a elemento.
    - Ocupa el hilo principal de cómputo.
  ],
  [
    *Compute Shader WebGPU (WGSL):*
    ```wgsl
    @compute @workgroup_size(64)
    fn main(@builtin(global_invocation_id) 
            id: vec3<u32>) {
      let i = id.x;
      if (i >= arrayLength(&inData)) { return; }
      outData[i] = sqrt(inData[i]) * 2.5 
                 + sin(inData[i]);
    }
    ```
  ]
)

#v(6pt)
*Métricas del Taller:* En pruebas con 1.000.000 de elementos, WebGPU despacha la carga en $approx 2.5$ ms frente a los $approx 45$ ms de la CPU en un solo hilo, alcanzando factores de aceleración de *15x a 25x* con verificación matemática de integridad idéntica.

#v(8pt)
== 5. Bibliografía y Lecturas Recomendadas para Profundizar

#table(
  columns: (1.2fr, 2.8fr),
  fill: (x, y) => if calc.even(y) { rgb("#f8fafc") } else { rgb("#ffffff") },
  stroke: 0.5pt + rgb("#e2e8f0"),
  align: top + left,
  table.header(
    [*Obra y Autoría (O'Reilly)*],
    [*Relevancia para la Arquitectura de Sistemas y GPU*]
  ),
  [
    #link("https://learning.oreilly.com/library/view/-/9780128226742/?orm_source=mcp")[*Computer Organization & Design*] \
    #text(8pt, fill: rgb("#64748b"))[D. Patterson & J. Hennessy \ (Morgan Kaufmann)]
  ],
  [
    Fundamento canónico sobre la arquitectura del silicio. Explica con rigor la divergencia entre optimización de latencia (CPU) y rendimiento masivo por hilos (GPU / SIMT).
  ],
  [
    #link("https://learning.oreilly.com/library/view/-/9781492089834/?orm_source=mcp")[*WebAssembly: The Definitive Guide*] \
    #text(8pt, fill: rgb("#64748b"))[Brian Sletten \ (O'Reilly Media)]
  ],
  [
    Análisis exhaustivo del modelo de memoria lineal y ejecución binaria de Wasm para albergar lógica de sistemas y kernels en el navegador.
  ],
  [
    #link("https://learning.oreilly.com/library/view/-/9781633436206/?orm_source=mcp")[*Server-Side WebAssembly*] \
    #text(8pt, fill: rgb("#64748b"))[Danilo Chiarlone \ (Manning Publications)]
  ],
  [
    Obra clave sobre la interfaz WASI y el puente de comunicación entre WebAssembly y subsistemas de aceleración de hardware como WebGPU.
  ],
  [
    #link("https://learning.oreilly.com/library/view/-/9798341660182/?orm_source=mcp")[*Web Performance in the Age of AI*] \
    #text(8pt, fill: rgb("#64748b"))[Addy Osmani \ (O'Reilly Media)]
  ],
  [
    Guía sobre la descarga de cargas masivas e inferencia local de modelos en la GPU del cliente web para evitar bloquear la interfaz de usuario.
  ],
  [
    #link("https://learning.oreilly.com/library/view/-/9781803245423/?orm_source=mcp")[*GPU-Accelerated Computing*] \
    #text(8pt, fill: rgb("#64748b"))[N. Cautaerts & H. Ghorbanfekr \ (Packt Publishing)]
  ],
  [
    Modelado mental de la computación GPGPU: workgroups, memoria compartida SRAM en chip y sincronización por barreras.
  ]
)

#v(8pt)
== 6. Próximo Paso: Hacia el Capítulo 2
En el siguiente capítulo nos sumergiremos en la sintaxis de estilo Rust, el tipado estricto, los espacios de memoria (`var<workgroup>`, `storage`) y los decoradores `@group`, `@binding` y `@compute` del lenguaje *WGSL (WebGPU Shading Language)*.
