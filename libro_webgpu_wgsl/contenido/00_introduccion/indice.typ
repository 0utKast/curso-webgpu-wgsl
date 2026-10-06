#import "../../templates/estilos.typ" as estilos

#page(
  paper: "a4",
  margin: (x: 2.2cm, top: 1.8cm, bottom: 1.8cm),
  fill: estilos.color-fondo-nota,
  header: none,
  footer: none,
  [
    #v(0.1cm)
    #align(center)[
      #rect(
        fill: estilos.color-acento,
        radius: 3pt,
        inset: (x: 8pt, y: 3pt),
        text(font: estilos.fuente-sans, size: 7.5pt, tracking: 3pt, weight: "bold", fill: estilos.color-blanco, "SUMARIO GENERAL")
      )
      #v(6pt)
      #text(font: estilos.fuente-titulo, size: 2.1em, weight: "bold", fill: estilos.color-azul-pizarra, "Arquitectura del Ecosistema")
      #v(3pt)
      #line(length: 22%, stroke: 1.5pt + estilos.color-acento)
    ]
    #v(0.4cm)

    #grid(
      columns: (1.15fr, 0.05fr, 1.8fr),
      gutter: 12pt,
      [
        // Columna Izquierda: Filosofía Editorial y Sinergia Formativa
        #v(4pt)
        #align(left)[
          #text(font: estilos.fuente-sans, size: 0.95em, weight: "bold", fill: estilos.color-azul-pizarra, "La Emancipación del Silicio")
          #v(4pt)
          #par(leading: 0.62em)[
            #text(font: estilos.fuente-cuerpo, size: 8.5pt, fill: estilos.color-principal.lighten(15%))[
              La llegada de WebGPU no es una simple evolución incremental de WebGL. Representa una fractura tectónica: la transformación del navegador web en una máquina universal capaz de ejecutar inteligencia artificial y computación gráfica masiva en el propio dispositivo del usuario final.
            ]
          ]
          #v(5pt)
          #par(leading: 0.62em)[
            #text(font: estilos.fuente-cuerpo, size: 8.5pt, fill: estilos.color-principal.lighten(15%))[
              Este libro está diseñado como la columna vertebral teórica y arquitectónica de un ecosistema formativo tridimensional: el rigor conceptual de estas páginas, la fluidez narrativa de las lecciones en vídeo y la experimentación táctil e inmediata de los talleres interactivos en HTML.
            ]
          ]
          #v(14pt)
          #estilos.cita(
            "Los estándares abiertos siempre terminan devorando a las soluciones propietarias cuando la tecnología pasa de los laboratorios al consumo masivo.",
            autor: "David A. Patterson & John L. Hennessy"
          )
          #v(12pt)
          #rect(
            width: 100%,
            fill: estilos.color-taller-bg,
            stroke: 0.5pt + estilos.color-taller-borde.lighten(50%),
            inset: 8pt,
            radius: 3pt,
            [
              #text(font: estilos.fuente-sans, size: 7.8pt, weight: "bold", fill: estilos.color-azul-pizarra, "TALLERES INTERACTIVOS HTML")
              #v(2pt)
              #text(font: estilos.fuente-sans, size: 7.4pt, fill: estilos.color-cuerpo, [
                Cada capítulo enlaza a talleres autónomos en el navegador para visualizar colisiones de memoria, divergencia de hilos y multiplicación matricial en tiempo real.
              ])
            ]
          )
          #v(8pt)
          #rect(
            width: 100%,
            fill: estilos.color-fondo-nota.darken(3%),
            stroke: 0.5pt + estilos.color-borde-nota,
            inset: 7pt,
            radius: 3pt,
            [
              #text(font: estilos.fuente-sans, size: 7.6pt, weight: "bold", fill: estilos.color-azul-pizarra, "COMPILACIÓN NATIVA MULTIPLATAFORMA")
              #v(2pt)
              #text(font: estilos.fuente-sans, size: 7.1pt, fill: estilos.color-cuerpo, [
                Un único shader en WGSL se traduce en tiempo de ejecución a Metal en macOS, DirectX 12 en Windows y Vulkan en Linux y Android.
              ])
            ]
          )
        ]
      ],
      [
        // Columna Central: Línea divisoria vertical
        #align(center)[
          #v(4pt)
          #line(start: (0pt, 0pt), end: (0pt, 590pt), stroke: 0.5pt + estilos.color-borde-nota.darken(10%))
        ]
      ],
      [
        // Columna Derecha: Índice Estructurado con Títulos y Subtítulos
        #v(4pt)
        #context {
          let chapters = query(selector(<chapter>))
          let ch-map = (:)
          for ch in chapters {
            ch-map.insert(ch.value, ch.location())
          }

          let render-item(titulo, desc, tag, pg-fallback) = {
            let loc = ch-map.at(tag, default: none)
            let pg = if loc != none { str(loc.page()) } else { pg-fallback }
            
            let item-content = grid(
              columns: (1fr, auto),
              gutter: 4pt,
              align(left + bottom)[
                #text(font: estilos.fuente-sans, size: 8.3pt, weight: "bold", fill: estilos.color-principal, titulo)
                #box(width: 1fr, repeat(text(fill: estilos.color-borde-nota.darken(10%), ".")))
                #if desc != "" [ \ #text(font: estilos.fuente-sans, size: 7.1pt, style: "italic", fill: estilos.color-cuerpo.lighten(30%), desc) ]
              ],
              align(right + bottom)[
                #text(font: estilos.fuente-sans, size: 8.5pt, weight: "bold", fill: estilos.color-acento, pg)
              ]
            )

            if loc != none {
              link(loc)[#item-content]
            } else {
              item-content
            }
            v(4pt)
          }

          // SECCIÓN 1: INTRODUCCIÓN Y CONTEXTO ESTRATÉGICO
          text(font: estilos.fuente-sans, size: 8.8pt, weight: "bold", fill: estilos.color-azul-pizarra, "I. INTRODUCCIÓN Y MARCO CONCEPTUAL")
          v(2pt)
          line(length: 100%, stroke: 0.5pt + estilos.color-acento.lighten(40%))
          v(3pt)

          render-item(
            "La Máquina Universal",
            "Objetivos, metodología y la tríada formativa del curso",
            "Introducción",
            "3"
          )

          render-item(
            "El Foso de CUDA y la Guerra del Silicio",
            "Por qué WebGPU es el Caballo de Troya del cómputo universal",
            "Guerra del Silicio",
            "6"
          )

          v(6pt)

          // SECCIÓN 2: ARQUITECTURA DEL SILICIO Y MODELO MENTAL
          text(font: estilos.fuente-sans, size: 8.8pt, weight: "bold", fill: estilos.color-azul-pizarra, "II. ARQUITECTURA Y FUNDAMENTOS")
          v(2pt)
          line(length: 100%, stroke: 0.5pt + estilos.color-acento.lighten(40%))
          v(3pt)

          render-item(
            "Capítulo 1: Arquitectura de la Web Moderna",
            "El modelo mental de WebGPU, pipelines y sincronización con WebAssembly",
            "Capitulo 1",
            "9"
          )

          render-item(
            "Capítulo 2: Anatomía de WGSL",
            "Sintaxis, sistema de tipos escalares, vectores y seguridad de memoria",
            "Capitulo 2",
            "18"
          )

          v(6pt)

          // SECCIÓN 3: COMPUTE SHADERS Y PARALELISMO MASIVO
          text(font: estilos.fuente-sans, size: 8.8pt, weight: "bold", fill: estilos.color-azul-pizarra, "III. COMPUTE SHADERS Y SILICIO")
          v(2pt)
          line(length: 100%, stroke: 0.5pt + estilos.color-acento.lighten(40%))
          v(3pt)

          render-item(
            "Capítulo 3: Jerarquía de Memoria en GPU",
            "Workgroups, memoria compartida, bank conflicts y el muro de la memoria",
            "Capitulo 3",
            "28"
          )

          render-item(
            "Capítulo 4: Divergencia y Optimización de Warps",
            "Ejecución SIMD, control de saltos y penalizaciones en silicio",
            "Capitulo 4",
            "38"
          )

          render-item(
            "Capítulo 5: Reducción Paralela y GEMM",
            "Multiplicación de matrices por bloques y algoritmos de reducción en árbol",
            "Capitulo 5",
            "46"
          )

          v(6pt)

          // SECCIÓN 4: LABORATORIOS Y REFERENCIA
          text(font: estilos.fuente-sans, size: 8.8pt, weight: "bold", fill: estilos.color-azul-pizarra, "IV. LABORATORIOS Y BIBLIOGRAFÍA")
          v(2pt)
          line(length: 100%, stroke: 0.5pt + estilos.color-acento.lighten(40%))
          v(3pt)

          render-item(
            "Catálogo de Talleres Interactivos HTML",
            "Guía de laboratorios ejecutables autónomos del Workshop 01 al 06",
            "Talleres HTML",
            "54"
          )

          render-item(
            "Bibliografía y Lecturas para Profundizar",
            "Catálogo canónico de O'Reilly Learning y textos clásicos de silicio",
            "Bibliografía",
            "58"
          )
        }
      ]
    )
  ]
)
