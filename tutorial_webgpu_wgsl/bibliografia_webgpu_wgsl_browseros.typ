#set page(
  paper: "a4",
  margin: (top: 1.8cm, bottom: 1.8cm, left: 2.0cm, right: 2.0cm),
  header: context {
    if counter(page).get().first() > 1 {
      text(8pt, fill: rgb("#64748b"))[
        *BrowserOS: WebGPU & WGSL* | _Compendio Bibliográfico Canónico y Fuentes de Conocimiento_
        #h(1fr)
        Antigravity Engineering Lab
      ]
    }
  },
  footer: context {
    text(8pt, fill: rgb("#94a3b8"))[
      #line(length: 100%, stroke: 0.5pt + rgb("#cbd5e1"))
      #v(2pt)
      Serie: Arquitectura de Sistemas en el Navegador (BrowserOS)
      #h(1fr)
      Página #counter(page).display("1 de 1", both: true)
    ]
  }
)

#set text(
  font: ("Helvetica", "Arial"),
  size: 8.5pt,
  fill: rgb("#1e293b"),
  lang: "es",
  spacing: 110%
)

#set par(
  justify: true,
  leading: 0.52em
)

// ==========================================
// PÁGINA 1: CABECERA, EPISTEMOLOGÍA MCP Y AUDITORÍA O'REILLY
// ==========================================

#block(
  fill: rgb("#f8fafc"),
  stroke: (left: 4pt + rgb("#0284c7")),
  inset: (x: 14pt, y: 10pt),
  radius: (right: 4pt),
  width: 100%,
  [
    #text(15pt, weight: "bold", fill: rgb("#0f172a"))[Compendio Bibliográfico Canónico y Fuentes Oficiales] \
    #v(2pt)
    #text(10pt, weight: "medium", fill: rgb("#0369a1"))[
      Fundamentos de Silicio, Computación Masiva en GPU, Pipeline 3D y la Arquitectura Local-First de BrowserOS
    ] \
    #v(3pt)
    #text(8pt, fill: rgb("#475569"))[
      *Serie:* _BrowserOS: Computación Nativa en la Web con Wasm, WebGPU y WGSL_ | *Revisión Técnica:* Antigravity Lab \
      *Repositorio Oficial y Talleres:* Disponibles a través de los enlaces en la descripción del vídeo publicado
    ]
  ]
)

#v(6pt)

#text(11pt, weight: "bold", fill: rgb("#0f172a"))[1. Epistemología y Uso del Protocolo de Contexto de Modelo (MCP)]

A lo largo del curso, la interacción entre la inteligencia artificial asistida y los cimientos de la ingeniería ha estado gobernada por el *Model Context Protocol* (MCP), un estándar abierto para conectar modelos de lenguaje con bibliotecas estructuradas y repositorios contrastados por pares como *O'Reilly Learning*.

#v(2pt)
#block(
  fill: rgb("#f0fdf4"),
  stroke: 0.75pt + rgb("#bbf7d0"),
  inset: 7pt,
  radius: 3pt,
  width: 100%,
  [
    #text(8.5pt, weight: "bold", fill: rgb("#166534"))[Llamamiento a Repositorios y Servicios Públicos] —
    #text(8pt, fill: rgb("#14532d"))[
      La integración pionera de O'Reilly Learning traza el camino ineludible para las instituciones públicas: bibliotecas nacionales, archivos históricos, organismos de normalización (W3C, ISO, INE, BOE) y repositorios científicos abiertos (PubMed, arXiv, bioRxiv). Exponer el saber público mediante servidores MCP estandarizados permitirá que los agentes inteligentes razonen sobre conocimiento riguroso y verificado, erradicando alucinaciones del raspado web superficial.
    ]
  ]
)

#v(3pt)
#text(8.5pt, weight: "bold")[El Principio Cardinal: Rigor Epistemológico frente a la Falacia del "Copiar y Pegar"] \
Es imperativo deslindar el uso de MCP de cualquier intento de regurgitación o plagio de contenidos protegidos. En esta obra, MCP ha operado como un *puente intelectual de verificación de primer orden*:
- *Validación de Límites Físicos*: Contrastar la microarquitectura de la GPU con las leyes termodinámicas y el muro de memoria (*The Memory Wall*).
- *Rigor Matemático*: Cotejar las formulaciones de iluminación Blinn-Phong, el vector bisector $bold(H)$, la interpolación baricéntrica con corrección de perspectiva y las ecuaciones de mezcla alfa con los tratados canónicos.
- *Disciplina de Silicio*: Comprobar que los patrones de paso de datos entre CPU y GPU respetan la inmutabilidad de los pipelines modernos para lograr 60 y 120 FPS sin sobrecarga del bus PCIe.

#v(6pt)

#text(11pt, weight: "bold", fill: rgb("#0f172a"))[2. Auditoría Empírica en O'Reilly: La Frontera Emergente de WebGPU]

*O'Reilly Learning* es una de las bibliotecas técnicas más completas del planeta, con miles de obras de sellos canónicos (*O'Reilly Media, Morgan Kaufmann, Addison-Wesley, Packt, Apress, CRC Press*). Ha sido el pilar para consolidar la arquitectura de computadores, el paralelismo masivo y los gráficos 3D.

Sin embargo, al auditar empíricamente la plataforma mediante la herramienta MCP `search_oreilly_content` buscando el núcleo central del curso (*WebGPU* y *WGSL*), se constata una realidad pedagógica elocuente:

#v(2pt)
#table(
  columns: (1.4fr, 2.8fr, 2.8fr),
  fill: (x, y) => if y == 0 { rgb("#0284c7") } else if calc.even(y) { rgb("#f8fafc") } else { none },
  stroke: 0.5pt + rgb("#cbd5e1"),
  inset: 4.5pt,
  align: (left, left, left),
  [#text(weight: "bold", fill: white, size: 7.8pt)[Consulta MCP]],
  [#text(weight: "bold", fill: white, size: 7.8pt)[Resultados Devueltos en Catálogo]],
  [#text(weight: "bold", fill: white, size: 7.8pt)[Diagnóstico Editorial]],
  
  [`"WebGPU"`],
  [Libros de CUDA/Python, Vision Language Models y rendimiento web general (Addy Osmani).],
  [Cero libros dedicados monográficamente a la API. Menciones solo prospectivas.],

  [`"WGSL"`],
  [Un único resultado marginal sobre el metaverso (_The Evolune Metaverse_, Apress).],
  [Relevancia ínfima ($0.076$). Cero textos de referencia sobre el lenguaje.],

  [`"WebGPU Shading Language"`],
  [Textos generales de PyTorch, WebAssembly (Brian Sletten) o Rust/Wasm.],
  [Cero manuales técnicos de sombreado o recetarios del estándar W3C.]
)

#v(2pt)
#text(8pt, style: "italic", fill: rgb("#475569"))[
  *Conclusión Pedagógica:* Esta ausencia no es un defecto de la plataforma, sino la prueba de que nos encontramos en la vanguardia absoluta de la industria. Mientras la edición tradicional requiere entre 18 y 24 meses de ciclo de imprenta, WebGPU y WGSL son estándares vivos que se están forjando y adoptando en este preciso instante.
]

#pagebreak()

// ==========================================
// PÁGINA 2: ESPECIFICACIONES NORMATIVAS Y RECURSOS DEL W3C
// ==========================================

#text(12pt, weight: "bold", fill: rgb("#0f172a"))[3. Fuentes Oficiales, Especificaciones Normativas y Repositorios Vivos]

#v(2pt)
#text(8.5pt)[
  Ante la ausencia de bibliografía impresa monográfica, el rigor de grado de producción exige acudir a las especificaciones formales y a los repositorios de código abierto donde los ingenieros de los motores web definen la tecnología en tiempo real:
]

#v(4pt)

#grid(
  columns: (1fr, 1fr),
  gutter: 7pt,
  [
    #block(
      fill: rgb("#f8fafc"),
      stroke: 0.5pt + rgb("#cbd5e1"),
      inset: 6.5pt,
      radius: 3pt,
      
      [
        #text(8.8pt, weight: "bold", fill: rgb("#0369a1"))[1. W3C WebGPU Specification] \
        #text(7.5pt, fill: rgb("#64748b"))[World Wide Web Consortium | Candidate Recommendation] \
        #v(1pt)
        *Enlace:* #link("https://www.w3.org/TR/webgpu/")[w3.org/TR/webgpu/] \
        #v(1pt)
        *Descripción:* El estándar normativo oficial que define `GPUDevice`, `GPUBuffer`, `GPURenderPipeline`, el modelo de seguridad en memoria y las reglas de validación en tiempo de ejecución.
      ]
    )
  ],
  [
    #block(
      fill: rgb("#f8fafc"),
      stroke: 0.5pt + rgb("#cbd5e1"),
      inset: 6.5pt,
      radius: 3pt,
      
      [
        #text(8.8pt, weight: "bold", fill: rgb("#0369a1"))[2. W3C WGSL Specification] \
        #text(7.5pt, fill: rgb("#64748b"))[World Wide Web Consortium | Shading Language Spec] \
        #v(1pt)
        *Enlace:* #link("https://www.w3.org/TR/WGSL/")[w3.org/TR/WGSL/] \
        #v(1pt)
        *Descripción:* Especificación sintáctica formal de WGSL: sistema de tipos de silicio, alineaciones a 16 bytes, atributos (`@builtin`, `@location`), funciones intrínsecas y primitivas atómicas.
      ]
    )
  ],
  [
    #block(
      fill: rgb("#f8fafc"),
      stroke: 0.5pt + rgb("#cbd5e1"),
      inset: 6.5pt,
      radius: 3pt,
      
      [
        #text(8.8pt, weight: "bold", fill: rgb("#0369a1"))[3. WebGPU Explainer & Rationale] \
        #text(7.5pt, fill: rgb("#64748b"))[GPU for the Web Community Group (Apple, Google, Mozilla)] \
        #v(1pt)
        *Enlace:* #link("https://gpuweb.github.io/gpuweb/explainer/")[gpuweb.github.io/gpuweb/explainer/] \
        #v(1pt)
        *Descripción:* Justificación arquitectónica de WebGPU frente a WebGL, inmutabilidad de pipelines, grupos de enlace explícitos y codificación determinista de comandos.
      ]
    )
  ],
  [
    #block(
      fill: rgb("#f8fafc"),
      stroke: 0.5pt + rgb("#cbd5e1"),
      inset: 6.5pt,
      radius: 3pt,
      
      [
        #text(8.8pt, weight: "bold", fill: rgb("#0369a1"))[4. Repositorio GPUWeb & CTS] \
        #text(7.5pt, fill: rgb("#64748b"))[Comité W3C / Khronos Group en GitHub] \
        #v(1pt)
        *Enlace:* #link("https://github.com/gpuweb/gpuweb")[github.com/gpuweb/gpuweb] \
        #v(1pt)
        *Descripción:* El centro neurálgico donde se debaten extensiones (subgrupos, float16) y la suite de pruebas de conformidad automatizada (CTS) multi-proveedor.
      ]
    )
  ],
  [
    #block(
      fill: rgb("#f8fafc"),
      stroke: 0.5pt + rgb("#cbd5e1"),
      inset: 6.5pt,
      radius: 3pt,
      
      [
        #text(8.8pt, weight: "bold", fill: rgb("#0369a1"))[5. WebGPU Samples Oficiales] \
        #text(7.5pt, fill: rgb("#64748b"))[Galería de Referencia W3C / Khronos] \
        #v(1pt)
        *Enlace:* #link("https://webgpu.github.io/webgpu-samples/")[webgpu.github.io/webgpu-samples/] \
        #v(1pt)
        *Descripción:* Implementaciones canónicas interactivas: partículas Compute-to-Render, Reverse-Z, renderizado diferido, mapas de sombras y postprocesamiento en tiempo real.
      ]
    )
  ],
  [
    #block(
      fill: rgb("#f8fafc"),
      stroke: 0.5pt + rgb("#cbd5e1"),
      inset: 6.5pt,
      radius: 3pt,
      
      [
        #text(8.8pt, weight: "bold", fill: rgb("#0369a1"))[6. Tour of WGSL (Google Team)] \
        #text(7.5pt, fill: rgb("#64748b"))[Google Chrome Graphics Team] \
        #v(1pt)
        *Enlace:* #link("https://google.github.io/tour-of-wgsl/")[google.github.io/tour-of-wgsl/] \
        #v(1pt)
        *Descripción:* Guía interactiva paso a paso con editor en vivo en el navegador para dominar la gramática, estructuras, punteros y espacios de memoria en WGSL.
      ]
    )
  ],
  [
    #block(
      fill: rgb("#f8fafc"),
      stroke: 0.5pt + rgb("#cbd5e1"),
      inset: 6.5pt,
      radius: 3pt,
      
      [
        #text(8.8pt, weight: "bold", fill: rgb("#0369a1"))[7. MDN Web Docs: WebGPU API] \
        #text(7.5pt, fill: rgb("#64748b"))[Mozilla Developer Network] \
        #v(1pt)
        *Enlace:* #link("https://developer.mozilla.org/en-US/docs/Web/API/WebGPU_API")[developer.mozilla.org] \
        #v(1pt)
        *Descripción:* Referencia enciclopédica de todas las interfaces, métodos y propiedades de WebGPU en JavaScript, con tablas de compatibilidad y soporte de navegadores.
      ]
    )
  ],
  [
    #block(
      fill: rgb("#f8fafc"),
      stroke: 0.5pt + rgb("#cbd5e1"),
      inset: 6.5pt,
      radius: 3pt,
      
      [
        #text(8.8pt, weight: "bold", fill: rgb("#0369a1"))[8. WebGPU Fundamentals] \
        #text(7.5pt, fill: rgb("#64748b"))[Iniciativa Comunitaria por Gregg Tavares] \
        #v(1pt)
        *Enlace:* #link("https://webgpufundamentals.org/")[webgpufundamentals.org] \
        #v(1pt)
        *Descripción:* Explicaciones visuales y matemáticas de matrices ortográficas y de perspectiva, trasposiciones, cadenas MIP de texturas y arquitectura de uniformes.
      ]
    )
  ]
)

#v(8pt)
#block(
  fill: rgb("#eff6ff"),
  stroke: (left: 3pt + rgb("#2563eb")),
  inset: (x: 10pt, y: 7pt),
  radius: (right: 3pt),
  width: 100%,
  [
    #text(8.5pt, weight: "bold", fill: rgb("#1e40af"))[Metodología de Estudio Recomendada] \
    #text(8pt, fill: rgb("#1e3a8a"))[
      Se recomienda contrastar la especificación sintáctica formal de WGSL (W3C) con las demostraciones vivas de los WebGPU Samples. Para la arquitectura de llamadas y la sincronización con el bucle de presentación del host, la referencia de MDN y el Tour of WGSL proporcionan el marco práctico inmediato.
    ]
  ]
)

#pagebreak()

// ==========================================
// PÁGINA 3: BIBLIOGRAFÍA CANÓNICA O'REILLY
// ==========================================

#text(12pt, weight: "bold", fill: rgb("#0f172a"))[4. Bibliografía Canónica O'Reilly para Fundamentos de Hardware y Gráficos]

#v(2pt)
#text(8.5pt)[
  Las siguientes obras maestras disponibles en *O'Reilly Learning* constituyen la base teórica universal para cualquier ingeniero que diseñe software de alto rendimiento en GPU:
]

#v(4pt)

#block(
  fill: rgb("#fafafa"),
  stroke: 0.5pt + rgb("#e2e8f0"),
  inset: 6pt,
  radius: 3pt,
  width: 100%,
  [
    #text(9pt, weight: "bold", fill: rgb("#0f172a"))[1. Real-Time Rendering, Fourth Edition] \
    #text(7.8pt, fill: rgb("#64748b"))[Tomas Akenine-Möller, Eric Haines, Naty Hoffman et al. | A K Peters / CRC Press, 2018 (1.198 págs.)] \
    *Enlace O'Reilly:* #link("https://learning.oreilly.com/library/view/-/9781351816144/?orm_source=mcp")[Real-Time Rendering, 4th Edition en O'Reilly Learning] \
    *Relevancia Arquitectónica:* El tratado universal de gráficos en tiempo real. Indispensable para comprender la física del rasterizador de silicio, funciones de arista, interpolación baricéntrica con corrección de perspectiva, mitigación de Z-fighting con Early-Z y ecuaciones de microfaceta (PBR).
  ]
)

#v(3pt)

#block(
  fill: rgb("#fafafa"),
  stroke: 0.5pt + rgb("#e2e8f0"),
  inset: 6pt,
  radius: 3pt,
  width: 100%,
  [
    #text(9pt, weight: "bold", fill: rgb("#0f172a"))[2. Programming Massively Parallel Processors: A Hands-on Approach, 4th Edition] \
    #text(7.8pt, fill: rgb("#64748b"))[Wen-mei W. Hwu, David B. Kirk, Izzat El Hajj | Morgan Kaufmann, 2022 (580 págs.)] \
    *Enlace O'Reilly:* #link("https://learning.oreilly.com/library/view/-/9780323984638/?orm_source=mcp")[Programming Massively Parallel Processors, 4th Edition en O'Reilly] \
    *Relevancia Arquitectónica:* La biblia del paralelismo masivo. Detalla el modelo SIMT, memoria compartida SRAM (`var<workgroup>`), barreras de sincronización, prevención de conflictos de bancos y optimización de convoluciones 2D mediante bloques con halo (*tiling*).
  ]
)

#v(3pt)

#block(
  fill: rgb("#fafafa"),
  stroke: 0.5pt + rgb("#e2e8f0"),
  inset: 6pt,
  radius: 3pt,
  width: 100%,
  [
    #text(9pt, weight: "bold", fill: rgb("#0f172a"))[3. Computer Organization and Design RISC-V Edition, 2nd Edition] \
    #text(7.8pt, fill: rgb("#64748b"))[David A. Patterson, John L. Hennessy (Premios Turing) | Morgan Kaufmann, 2020 (672 págs.)] \
    *Enlace O'Reilly:* #link("https://learning.oreilly.com/library/view/-/9780128226742/?orm_source=mcp")[Computer Organization and Design RISC-V Edition en O'Reilly] \
    *Relevancia Arquitectónica:* Expone el principio rector del silicio moderno: la especialización de dominio (*Domain-Specific Hardware*) como única vía para superar los límites energéticos. Analiza cuantitativamente la pared de memoria y el coste del tráfico entre CPU y memoria externa.
  ]
)

#v(3pt)

#block(
  fill: rgb("#fafafa"),
  stroke: 0.5pt + rgb("#e2e8f0"),
  inset: 6pt,
  radius: 3pt,
  width: 100%,
  [
    #text(9pt, weight: "bold", fill: rgb("#0f172a"))[4. Vulkan™ Programming Guide: The Official Guide to Learning Vulkan] \
    #text(7.8pt, fill: rgb("#64748b"))[Graham Sellers, John Kessenich | Addison-Wesley Professional, 2016 (496 págs.)] \
    *Enlace O'Reilly:* #link("https://learning.oreilly.com/library/view/-/9780134464701/?orm_source=mcp")[Vulkan™ Programming Guide en O'Reilly Learning] \
    *Relevancia Arquitectónica:* WebGPU es la traslación idiomática y segura de Vulkan a la web. Esta obra es vital para asimilar la inmutabilidad de los objetos de pipeline, la codificación determinista de comandos y la eliminación de la sobrecarga de validación en tiempo de ejecución.
  ]
)

#v(3pt)

#block(
  fill: rgb("#fafafa"),
  stroke: 0.5pt + rgb("#e2e8f0"),
  inset: 6pt,
  radius: 3pt,
  width: 100%,
  [
    #text(9pt, weight: "bold", fill: rgb("#0f172a"))[5. Designing Data-Intensive Applications, 2nd Edition] \
    #text(7.8pt, fill: rgb("#64748b"))[Martin Kleppmann, Chris Riccomini | O'Reilly Media, Inc., 2026 (672 págs.)] \
    *Enlace O'Reilly:* #link("https://learning.oreilly.com/library/view/-/9781098119058/?orm_source=mcp")[Designing Data-Intensive Applications, 2nd Edition en O'Reilly] \
    *Relevancia Arquitectónica:* El tratado definitivo sobre sistemas de datos modernos. Imprescindible para diseñar la arquitectura *Local-First*: persistencia en cliente, funcionamiento sin conexión e integración de tipos de datos replicados libres de conflictos (CRDTs).
  ]
)

#v(3pt)

#block(
  fill: rgb("#fafafa"),
  stroke: 0.5pt + rgb("#e2e8f0"),
  inset: 6pt,
  radius: 3pt,
  width: 100%,
  [
    #text(9pt, weight: "bold", fill: rgb("#0f172a"))[6. WebAssembly: The Definitive Guide] \
    #text(7.8pt, fill: rgb("#64748b"))[Brian Sletten | O'Reilly Media, Inc., 2021 (332 págs.)] \
    *Enlace O'Reilly:* #link("https://learning.oreilly.com/library/view/-/9781492089834/?orm_source=mcp")[WebAssembly: The Definitive Guide en O'Reilly Learning] \
    *Relevancia Arquitectónica:* La máquina virtual de alto rendimiento de la web. Explica la memoria lineal, la compilación de C++ y Rust a binarios Wasm y su acoplamiento sinérgico con WebGPU para erigir la plataforma BrowserOS.
  ]
)

#v(3pt)

#block(
  fill: rgb("#fafafa"),
  stroke: 0.5pt + rgb("#e2e8f0"),
  inset: 6pt,
  radius: 3pt,
  width: 100%,
  [
    #text(9pt, weight: "bold", fill: rgb("#0f172a"))[7. Web Performance Engineering in the Age of AI] \
    #text(7.8pt, fill: rgb("#64748b"))[Addy Osmani | O'Reilly Media, Inc., 2026 (256 págs.)] \
    *Enlace O'Reilly:* #link("https://learning.oreilly.com/library/view/-/9798341660182/?orm_source=mcp")[Web Performance Engineering in the Age of AI en O'Reilly] \
    *Relevancia Arquitectónica:* Orquestación de hilos (Web Workers, OffscreenCanvas), amortización de la recolección de basura e inferencia de modelos en el cliente web sin degradar la capacidad de respuesta de la interfaz a 120 FPS.
  ]
)

#pagebreak()

// ==========================================
// PÁGINA 4: VISIÓN PANORÁMICA DE FUTURO Y ACCESO A RECURSOS
// ==========================================

#text(12pt, weight: "bold", fill: rgb("#0f172a"))[5. Visión Panorámica de Futuro: La Era de BrowserOS y Local-First]

#v(2pt)
#text(8.5pt)[
  El viaje técnico que concluye en esta serie desvela una transformación copernicana: *el navegador web ha dejado de ser un visor de documentos estáticos para consagrarse como un sistema operativo virtual universal (BrowserOS)*. La convergencia entre la arquitectura Local-First y el acceso de bajo nivel al silicio de la GPU redefine la informática moderna:
]

#v(6pt)

#grid(
  columns: (1fr, 1fr),
  gutter: 10pt,
  [
    #block(
      fill: rgb("#eff6ff"),
      stroke: 1pt + rgb("#bfdbfe"),
      inset: 8pt,
      radius: 4pt,
      
      [
        #text(9.5pt, weight: "bold", fill: rgb("#1d4ed8"))[1. La Revolución Local-First] \
        #v(2pt)
        - *Soberanía de Datos:* Los datos residen en el almacenamiento privado del cliente (OPFS e IndexedDB).
        - *Inmunidad de Conexión:* Cero dependencia del servidor central; funcionamiento 100% offline.
        - *Sincronización Silenciosa:* Algoritmos matemáticos CRDT fusionan cambios asíncronamente con la red.
        - *Cero Latencia y Coste Cero:* Eliminación radical de cuotas millonarias de inferencia en la nube.
      ]
    )
  ],
  [
    #block(
      fill: rgb("#f5f3ff"),
      stroke: 1pt + rgb("#ddd6fe"),
      inset: 8pt,
      radius: 4pt,
      
      [
        #text(9.5pt, weight: "bold", fill: rgb("#6d28d9"))[2. La GPU como Coprocesador Universal] \
        #v(2pt)
        - *Inferencia de IA Local y Confidencial:* Modelos SLM (Gemma, LLaMA), Whisper y difusión en silicio local.
        - *Creatividad Profesional Web:* GIMP, Blender, DAWs y CAD compilados a Wasm con aceleración WebGPU.
        - *Renderizado Neural 3D:* Gaussian Splatting, NeRFs y simulaciones multifísicas masivas sin instaladores.
      ]
    )
  ]
)

#v(10pt)

#block(
  fill: rgb("#f8fafc"),
  stroke: (left: 4.5pt + rgb("#0f172a")),
  inset: (x: 12pt, y: 9pt),
  radius: (right: 4pt),
  width: 100%,
  [
    #text(9.5pt, weight: "bold", fill: rgb("#0f172a"))[Acceso a Recursos, Código y Talleres en GitHub] \
    #v(2pt)
    #text(8.2pt, fill: rgb("#334155"))[
      Todo el código fuente desarrollado en esta serie —incluyendo los talleres interactivos de silicio (`workshop_07_orquestacion_host.html` y `workshop_08_browseros_3d_universe.html`), los sombreadores en WGSL y las plantillas de arquitectura— se encuentra ordenado y catalogado en el repositorio oficial de GitHub.
      
      Los enlaces directos y actualizados al repositorio y a los recursos adicionales se encuentran disponibles en la *caja de descripción del vídeo* en el momento de su publicación.
    ]
  ]
)

#v(8pt)

#text(10pt, weight: "bold", fill: rgb("#0f172a"))[Retrospectiva del Viaje Completo de BrowserOS]

#v(2pt)
#text(8pt)[
  1. *Capítulo 1:* El modelo mental de la GPU en la web, superación de WebGL y la máquina virtual WebAssembly. \
  2. *Capítulo 2:* Fundamentos de WGSL, sistema de tipos escalares y matriciales, y leyes de empaquetado a 16 bytes. \
  3. *Capítulo 3:* Compute Shaders, jerarquías de memoria, SRAM compartida (`var<workgroup>`), barreras y Tiled GEMM. \
  4. *Capítulo 4:* Memoria espacial bidimensional (Curvas de Morton), unidades fijas de filtrado (TFUs) y convolución con halo. \
  5. *Capítulo 5:* Pipeline gráfico 3D completo, matrices MVP, rasterizador de función fija, Z-Buffer y síntesis Compute-to-Render.
]

#v(12pt)
#align(center)[
  #text(8pt, fill: rgb("#94a3b8"))[
    *Antigravity Engineering Lab* — Publicación Técnica de Arquitectura de Sistemas en el Navegador \
    Generado mediante compilación nativa Typst 0.14.2 | Edición Monográfica A4
  ]
]
