#import "estilos.typ" as estilos

// 1. Portada Principal del Libro
#let portada-libro(
  titulo: [ARQUITECTURA DE\ WEBGPU Y WGSL],
  subtitulo: "Computación Gráfica, Compute Shaders y la Revolución Local-First en el Silicio Moderno",
  autor: "Jesús Conde",
  imagen-fondo: "../../tutorial_webgpu_wgsl/fotogramas 2/fotograma_00001.png",
  ano: "2026",
  dx-imagen: -34cm,
  dy-imagen: -0.5cm,
  alto-imagen: 31cm
) = {
  page(
    paper: "a4",
    margin: 0cm,
    fill: estilos.color-principal,
    header: none,
    footer: none,
    [
      // Imagen de fondo con encuadre centrado en el silicio isométrico (sin texto original)
      #if imagen-fondo != none {
        let w-img = alto-imagen * (16 / 9)
        place(
          top + left,
          block(
            width: 100%,
            height: 100%,
            clip: true,
            place(
              top + left,
              dx: dx-imagen,
              dy: dy-imagen,
              image(imagen-fondo, width: w-img, height: alto-imagen)
            )
          )
        )
        // Capa de velado oscuro para contraste y legibilidad impecable
        place(
          top + left,
          rect(
            width: 100%,
            height: 100%,
            fill: rgb(15, 23, 42, 215) // Slate 900 oscuro con ~84% opacidad
          )
        )
      }

      // Marco tecnológico perimetral
      #place(
        top + left,
        dx: 1.2cm,
        dy: 1.2cm,
        rect(
          width: 100% - 2.4cm,
          height: 100% - 2.4cm,
          stroke: 1.5pt + estilos.color-acento
        )
      )

      // Detalle de esquinas tecnológicas
      #place(
        top + left,
        dx: 1.0cm,
        dy: 1.0cm,
        rect(
          width: 100% - 2.0cm,
          height: 100% - 2.0cm,
          stroke: 0.5pt + estilos.color-acento-secundario.lighten(30%)
        )
      )

      // Bloque del Título y Subtítulo
      #place(
        center + horizon,
        dy: -35pt,
        block(
          width: 82%,
          align(center, [
            // Etiqueta superior
            #rect(
              fill: estilos.color-acento,
              radius: 3pt,
              inset: (x: 10pt, y: 5pt),
              text(font: estilos.fuente-sans, size: 8.5pt, tracking: 3pt, weight: "bold", fill: estilos.color-blanco, "INGENIERÍA Y ARQUITECTURA DE COMPUTACIÓN")
            )
            #v(18pt)

            // Título Principal
            #text(font: estilos.fuente-titulo, size: 2.85em, weight: "bold", fill: estilos.color-blanco, tracking: 1.5pt, hyphenate: false)[
              #titulo
            ]
            #v(10pt)

            // Línea divisoria bicolor
            #grid(
              columns: (1fr, auto, 1fr),
              align(horizon, line(length: 100%, stroke: 1.5pt + estilos.color-acento)),
              pad(x: 10pt, text(font: estilos.fuente-sans, size: 10pt, fill: estilos.color-acento-secundario, "❖")),
              align(horizon, line(length: 100%, stroke: 1.5pt + estilos.color-acento-secundario))
            )
            #v(14pt)

            // Subtítulo
            #par(leading: 0.85em)[
              #text(font: estilos.fuente-sans, size: 1.2em, fill: estilos.color-blanco.lighten(20%), subtitulo)
            ]
          ])
        )
      )

      // Bloque del Autor y Fecha (Parte inferior)
      #place(
        bottom + center,
        dy: -3.0cm,
        block(
          width: 80%,
          align(center, [
            #text(font: estilos.fuente-sans, size: 1.15em, weight: "bold", tracking: 3pt, fill: estilos.color-blanco, upper(autor))
            #v(6pt)
            #text(font: estilos.fuente-sans, size: 8.5pt, tracking: 1.5pt, fill: estilos.color-acento-secundario.lighten(30%), [EDICIÓN TÉCNICA ILUSTRADA · CURSO DE VÍDEO Y TALLERES INTERACTIVOS · #ano])
          ])
        )
      )
    ]
  )
}

// 2. Portada de Entrada de Capítulo
#let portada-capitulo(
  numero: "1",
  titulo: "Arquitectura de la Web Moderna",
  subtitulo: "El modelo mental de WebGPU y WebAssembly",
  imagen: none,
  cuerpo-intro: none
) = {
  page(
    paper: "a4",
    margin: (x: 2.5cm, top: 3cm, bottom: 2.5cm),
    header: none,
    footer: none,
    [
      #align(center, [
        #rect(
          fill: estilos.color-acento,
          radius: 3pt,
          inset: (x: 8pt, y: 4pt),
          text(font: estilos.fuente-sans, size: 8.5pt, tracking: 3pt, weight: "bold", fill: estilos.color-blanco, [CAPÍTULO #numero])
        )
        #v(10pt)
        #text(font: estilos.fuente-titulo, size: 2.2em, weight: "bold", fill: estilos.color-azul-pizarra, titulo)
        #v(6pt)
        #text(font: estilos.fuente-sans, size: 1.1em, style: "italic", fill: estilos.color-cuerpo.lighten(30%), subtitulo)
        #v(12pt)
        #line(length: 40%, stroke: 1.5pt + estilos.color-acento)
      ])

      #if imagen != none {
        v(12pt)
        rect(
          width: 100%,
          height: 9.5cm,
          stroke: 0.5pt + estilos.color-borde-nota,
          radius: 3pt,
          image(imagen, width: 100%, height: 100%, fit: "cover")
        )
      }

      #if cuerpo-intro != none {
        v(14pt)
        block(
          width: 90%,
          align(center, par(leading: 0.8em)[
            #text(font: estilos.fuente-cuerpo, size: 10.5pt, style: "italic", fill: estilos.color-cuerpo.lighten(10%), cuerpo-intro)
          ])
        )
      }
    ]
  )
}
