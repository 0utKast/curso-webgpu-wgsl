#import "../../templates/estilos.typ" as estilos

// =============================================================================
// PÁGINA 1: EL DESPERTAR DE LA MÁQUINA UNIVERSAL
// =============================================================================

#metadata("Introducción")<chapter>

#v(0.1cm)
#text(font: estilos.fuente-titulo, size: 1.65em, weight: "bold", fill: estilos.color-azul-pizarra, "La Máquina Universal: Objetivos y Horizonte")
#v(-3pt)
#line(length: 28%, stroke: 1.8pt + estilos.color-acento)
#v(4pt)

#grid(
  columns: (1fr, 1fr),
  gutter: 12pt,
  [
    #estilos.capitular("D", [
      urante casi tres décadas, el navegador web fue concebido como un visor estructurado de documentos y un entorno para interfaces declarativas livianas. Sin embargo, la convergencia contemporánea entre WebAssembly y WebGPU ha pulverizado esa concepción histórica. La pestaña del navegador ya no es un simple cliente gráfico remoto: se ha transformado en una máquina universal de cómputo, un entorno de ejecución de alto rendimiento con acceso directo, seguro y sin fricción a la circuitería física de los chips más potentes del planeta.
    ])
    #v(4pt)
    #par[
      El objetivo primordial de este libro es proporcionar a ingenieros de software, científicos de datos y diseñadores de sistemas el modelo mental riguroso necesario para dominar WebGPU y su lenguaje de sombreado WGSL (*WebGPU Shading Language*). Lejos de limitarse a una enumeración de APIs o tutoriales superficiales de renderizado, esta obra desciende a las profundidades de la microarquitectura para desvelar cómo se mapean los algoritmos matemáticos en los miles de núcleos de procesamiento vectorial que componen las tarjetas gráficas contemporáneas.
    ]
  ],
  [
    #par[
      En este escenario, el paradigma *Local-First* emerge como una necesidad económica y civilizatoria ineludible. Ejecutar modelos de inteligencia artificial en la nube para cientos de millones de usuarios acarrea un coste operativo infinito, latencias de red impredecibles y una pérdida crítica de privacidad.
    ]
    #v(3pt)
    #par[
      Al aprovechar la GPU local mediante estándares abiertos del W3C, WebGPU desmantela el monopolio de las arquitecturas cautivas y permite compilar shaders que corren de manera nativa e indistinta sobre Apple Silicon, tarjetas NVIDIA o procesadores AMD e Intel, devolviendo la soberanía del cómputo al usuario final.
    ]
    #v(4pt)
    #estilos.nota-tecnica(
      titulo: "El Paradigma Local-First y el Silicio",
      [
        La inferencia en el borde (*edge compute*) elimina la factura de servidores remotos. Al descargar pesos y ejecutar kernels WGSL en local, el navegador se transforma en una estación de trabajo de cálculo tensorial con latencia cero y total privacidad.
      ]
    )
  ]
)

#v(3pt)

#estilos.cita(
  "Los estándares abiertos siempre terminan devorando a las soluciones propietarias cuando la tecnología pasa de los laboratorios al consumo masivo.",
  autor: "David A. Patterson & John L. Hennessy (Premio Turing)"
)

#v(2pt)

#estilos.fotograma-tecnico(
  "../../tutorial_webgpu_wgsl/fotogramas 2/fotograma_00030.png",
  "Figura 0.1: Arquitectura profunda de un sistema operativo dentro de la pestaña. WebAssembly gestiona la memoria contigua y la lógica de kernel, mientras WebGPU/WGSL asume el cálculo matricial masivo sobre el silicio gráfico.",
  alto: 5.6cm
)

#pagebreak()

// =============================================================================
// PÁGINA 2: LA TRÍADA PEDAGÓGICA (VÍDEO, LIBRO Y TALLERES HTML)
// =============================================================================

#v(0.1cm)
#text(font: estilos.fuente-titulo, size: 1.65em, weight: "bold", fill: estilos.color-azul-pizarra, "La Tríada Formativa: Vídeo, Texto y Silicio Vivo")
#v(-3pt)
#line(length: 28%, stroke: 1.8pt + estilos.color-acento)
#v(4pt)

#grid(
  columns: (1fr, 1fr),
  gutter: 12pt,
  [
    #estilos.capitular("A", [
      prender programación de sistemas y arquitectura de tarjetas gráficas exige trascender la bidimensionalidad del código estático. No basta con memorizar la sintaxis de un shader ni contemplar diagramas pasivos: es imperativo comprender la dinámica temporal del silicio, sentir el impacto de la divergencia de ramas y experimentar cómo un desalineamiento de memoria en un buffer destruye el ancho de banda efectivo. Por esta razón, este proyecto pedagógico se ha estructurado en torno a una tríada sinérgica deliberada y complementaria.
    ])
    #v(4pt)
    #par[
      En primer lugar, *las lecciones en vídeo* aportan el hilo narrativo, la intuición espacial y el despliegue dinámico de conceptos que sólo la animación y la palabra hablada pueden transmitir con calidez pedagógica. En segundo lugar, *este libro editorial en PDF* proporciona el rigor formal, la referencia de ingeniería pausada, las tablas de especificaciones de hardware y el análisis minucioso de cada estructura de datos.
    ]
  ],
  [
    #par[
      El tercer pilar, fundamental e insustituible, lo constituyen *los talleres interactivos en HTML*. Estos laboratorios autónomos, accesibles de inmediato sin necesidad de compilar paquetes pesados ni configurar controladores locales, permiten al estudiante inspeccionar en vivo el comportamiento de los shaders en su propio navegador.
    ]
    #v(3pt)
    #par[
      A través de estos talleres, es posible modificar en tiempo real el tamaño de los bloques de hilos (*workgroups*), visualizar el fenómeno del *Memory Wall*, auditar el relleno (*padding*) de 16 bytes impuesto por las normas de alineamiento uniforme y comparar la aceleración exponencial de la GPU frente al hilo secuencial de la CPU.
    ]
    #v(3pt)
    #estilos.taller-interactivo(
      "01 a 06",
      "Laboratorios Autónomos en el Navegador",
      "Talleres prácticos ejecutables creados como material complementario del curso: simulación de FLOPS, alineamiento de memoria en structs, divergencia de warps y multiplicación matricial (Tiled GEMM).",
      archivo-html: "workshop_01_webgpu_vs_cpu.html a workshop_06_tiled_gemm.html"
    )
  ]
)

#v(3pt)

#estilos.cita(
  "WebAssembly y WebGPU no son añadidos periféricos a la web; son la plataforma de sistemas más distribuida y universal jamás construida por la ingeniería humana.",
  autor: "Brian Sletten (Autor de WebAssembly: The Definitive Guide)"
)

#v(2pt)

#estilos.fotograma-tecnico(
  "../../tutorial_webgpu_wgsl/fotogramas 2/fotograma_00055.png",
  "Figura 0.2: La Tríada del Ecosistema de Silicio. WebGPU actúa como el entorno organizador de memoria y comandos, WGSL provee la sintaxis tipada humana y el sombreador compilado ejecuta el cómputo masivamente paralelo.",
  alto: 5.0cm
)

#pagebreak()

// =============================================================================
// PÁGINA 3: FILOSOFÍA DEL APRENDIZAJE Y HOJA DE RUTA
// =============================================================================

#v(0.1cm)
#text(font: estilos.fuente-titulo, size: 1.65em, weight: "bold", fill: estilos.color-azul-pizarra, "El Placer de Aprender y el Mapa del Silicio")
#v(-3pt)
#line(length: 28%, stroke: 1.8pt + estilos.color-acento)
#v(4pt)

#grid(
  columns: (1fr, 1fr),
  gutter: 12pt,
  [
    #estilos.capitular("F", [
      rente al ruido contemporáneo que proclama que la automatización o la inteligencia artificial harán innecesario el estudio profundo, este libro reivindica una postura radicalmente humanista: el inmenso gozo de aprender. Como he defendido a lo largo de décadas de labor docente, la auténtica filosofía consiste en amar el proceso de descubrimiento constante, recorrer el camino de la comprensión y no el vano espejismo de creerse en posesión de una verdad estática.
    ])
    #v(4pt)
    #par[
      Contar en 2026 con asistentes de inteligencia artificial agénticos como Antigravity y la capacidad de interrogar en tiempo real a la inmensa biblioteca técnica de O'Reilly Learning mediante servidores de protocolo MCP no sustituye nuestro entendimiento. Al contrario: nos otorga el telescopio conceptual más potente jamás concebido para explorar la microarquitectura de los procesadores y redactar código con un rigor que antes requería años de aislamiento.
    ]
  ],
  [
    #par[
      La estructura de este libro avanzará de manera progresiva, capítulo a capítulo, acompañando el temario audiovisual del curso:
    ]
    #v(2pt)
    #list(
      [*Capítulo 1:* Arquitectura de la Web Moderna y el modelo mental de WebGPU con WebAssembly.],
      [*Capítulo 2:* Anatomía de WGSL, sistema de tipos escalares, vectores y seguridad de memoria.],
      [*Capítulo 3:* Compute Shaders y la jerarquía de memoria: del silicio al algoritmo matricial.],
      [*Capítulo 4:* Divergencia de hilos, SIMD, subgroups y optimización de warps.],
      [*Capítulo 5:* Algoritmos matriciales avanzados (Tiled GEMM) y reducción paralela en árbol.]
    )
    #v(3pt)
    #estilos.nota-tecnica(
      titulo: "Bibliografía de O'Reilly Learning al Cierre",
      [
        Cada entrega técnica culminará en la sección final de bibliografía con referencias directas a obras seminales sobre aceleración gráfica, compiladores y procesadores masivos.
      ]
    )
  ]
)

#v(3pt)

#estilos.cita(
  "La verdadera revolución de la computación masivamente paralela radica en proporcionar un modelo de abstracción estructurado que permita gobernar miles de hilos sin perder el control de la memoria.",
  autor: "David B. Kirk & Wen-mei W. Hwu (Programming Massively Parallel Processors)"
)

#v(2pt)

#estilos.fotograma-tecnico(
  "../../tutorial_webgpu_wgsl/fotogramas 2/fotograma_00001.png",
  "Figura 0.3: Esquema isométrico del navegador contemporáneo desplegándose en capas de abstracción física: desde el motor JIT y WebAssembly hasta las unidades de procesamiento tensorial (TPU/GPU) y el cómputo paralelo masivo.",
  alto: 5.6cm
)
