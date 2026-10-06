// --- SISTEMA DE DISEÑO EDITORIAL: ARQUITECTURA DE WEBGPU Y WGSL ---
#import "guionacion.typ"

// --- PALETA CROMÁTICA TECNOLÓGICA Y SILICIO ---
#let color-principal = rgb("0F172A")        // Pizarra muy oscura para portadas y contrastes
#let color-cuerpo = rgb("1E293B")           // Gris pizarra oscuro para texto de lectura continuo
#let color-azul-pizarra = rgb("0B3C5D")     // Azul ingeniería profundo para títulos principales
#let color-acento = rgb("EA580C")           // Naranja WebGPU para acentos principales
#let color-acento-secundario = rgb("0284C7")// Cian de silicio para acentos secundarios
#let color-fondo-nota = rgb("F8FAFC")       // Fondo neutro claro para notas técnicas
#let color-borde-nota = rgb("CBD5E1")       // Gris suave para líneas divisorias y bordes
#let color-taller-bg = rgb("F0F9FF")        // Azul celeste pálido para bloques de talleres interactivos
#let color-taller-borde = rgb("0284C7")     // Azul cian para el marco de los talleres interactivos
#let color-codigo-bg = rgb("F1F5F9")        // Fondo para fragmentos de código
#let color-codigo-borde = rgb("E2E8F0")     // Borde para bloques de código
#let color-blanco = rgb("FFFFFF")

// --- TIPOGRAFÍAS DE SISTEMA (MACOS / UNIVERSALES) ---
#let fuente-titulo = "Helvetica Neue"       // Títulos limpios, modernos y contundentes
#let fuente-cuerpo = "Charter"              // Alta legibilidad en cuerpo de texto (Serif elegante)
#let fuente-sans = "Arial"                  // Sans-serif humanista para notas, pies de foto y diagramas
#let fuente-codigo = "Courier New"          // Monospaced para WGSL, C++, Rust y JavaScript

// --- COMPONENTES EDITORIALES ---

// 1. Letra Capitular (Drop Cap) elegante al inicio de capítulos o secciones mayores
#let capitular(letra, resto) = {
  grid(
    columns: (auto, 1fr),
    gutter: 8pt,
    align(top + left, text(size: 3.8em, weight: "bold", font: fuente-titulo, fill: color-azul-pizarra, letra)),
    align(top + left, text(top-edge: "bounds", resto))
  )
}

// 2. Nota Técnica de Arquitectura o Silicio al margen / columna
#let nota-tecnica(titulo: none, cuerpo) = {
  block(
    width: 100%,
    breakable: false,
    rect(
      width: 100%,
      fill: color-fondo-nota,
      stroke: (left: 3.5pt + color-acento, rest: 0.5pt + color-borde-nota),
      inset: (x: 12pt, y: 10pt),
      radius: (right: 4pt),
      [
        #if titulo != none {
          text(font: fuente-sans, weight: "bold", size: 0.95em, fill: color-azul-pizarra, titulo)
          v(4pt)
        }
        #par(leading: 0.65em)[
          #text(font: fuente-sans, size: 8.8pt, fill: color-cuerpo, cuerpo)
        ]
      ]
    )
  )
}

// 3. Cita Destacada (Pull Quote) a ancho completo o en columna
#let cita(texto, autor: none) = {
  align(center, block(
    width: 95%,
    inset: (top: 10pt, bottom: 10pt),
    stroke: (top: 1.5pt + color-acento, bottom: 1.5pt + color-acento),
    [
      #text(font: fuente-titulo, style: "italic", weight: "medium", size: 1.12em, fill: color-azul-pizarra, [“#texto”])
      #if autor != none {
        v(4pt)
        text(font: fuente-sans, size: 8.5pt, weight: "bold", fill: color-cuerpo.lighten(25%), [— #autor])
      }
    ]
  ))
}

// 4. Bloque de Taller Interactivo HTML
#let taller-interactivo(numero, titulo, descripcion, archivo-html: none) = {
  block(
    width: 100%,
    breakable: false,
    rect(
      width: 100%,
      fill: color-taller-bg,
      stroke: (left: 4pt + color-taller-borde, rest: 0.5pt + color-taller-borde.lighten(60%)),
      inset: (x: 12pt, y: 10pt),
      radius: (right: 4pt),
      [
        #grid(
          columns: (auto, 1fr),
          gutter: 8pt,
          align(top + left)[
            #rect(
              fill: color-taller-borde,
              radius: 3pt,
              inset: (x: 6pt, y: 3pt),
              text(font: fuente-sans, size: 7.5pt, weight: "bold", fill: color-blanco, [TALLER #numero])
            )
          ],
          align(top + left)[
            #text(font: fuente-titulo, size: 0.95em, weight: "bold", fill: color-azul-pizarra, titulo)
          ]
        )
        #v(4pt)
        #par(leading: 0.65em)[
          #text(font: fuente-sans, size: 8.8pt, fill: color-cuerpo, descripcion)
        ]
        #if archivo-html != none [
          #v(3pt)
          #text(font: fuente-codigo, size: 7.8pt, weight: "bold", fill: color-acento, [Laboratorio ejecutable: #archivo-html])
        ]
      ]
    )
  )
}

// 5. Bloque de Código Formateado
#let codigo-fuente(lenguaje: "wgsl", codigo) = {
  block(
    width: 100%,
    breakable: false,
    rect(
      width: 100%,
      fill: color-codigo-bg,
      stroke: 0.5pt + color-codigo-borde,
      inset: (x: 10pt, y: 8pt),
      radius: 4pt,
      [
        #align(right, text(font: fuente-sans, size: 7pt, weight: "bold", fill: color-azul-pizarra.lighten(30%), upper(lenguaje)))
        #v(-3pt)
        #raw(codigo, block: true, lang: lenguaje)
      ]
    )
  )
}

// 6. Fotograma Técnico / Ilustración con Pie de Foto Analítico
#let fotograma-tecnico(
  img-path,
  pie,
  ancho: 100%,
  alto: none,
  ajuste: "contain",
  posicion-y: center,
  alto-imagen: none
) = {
  block(
    width: ancho,
    spacing: 6pt,
    breakable: false,
    [
      #rect(
        width: 100%,
        stroke: 0.5pt + color-borde-nota,
        fill: color-fondo-nota.lighten(60%),
        radius: 3pt,
        inset: 0pt,
        if alto != none {
          if ajuste == "contain" {
            align(center + horizon, image(img-path, width: 100%, height: alto, fit: "contain"))
          } else {
            image(img-path, width: 100%, height: alto, fit: "cover")
          }
        } else {
          image(img-path, width: 100%)
        }
      )
      #v(-4pt)
      #rect(
        width: 100%,
        fill: color-fondo-nota,
        inset: (x: 10pt, y: 6pt),
        stroke: (left: 2.5pt + color-azul-pizarra, rest: 0.5pt + color-borde-nota),
        radius: (bottom-right: 3pt),
        align(left, text(font: fuente-sans, size: 8.2pt, style: "italic", fill: color-cuerpo, pie))
      )
    ]
  )
}

// 7. Marcador de Posición para Imágenes (cumpliendo normativa del proyecto)
#let placeholder-imagen(ancho: 100%, alto: 9.5cm, etiqueta: "FOTOGRAMA DEL VÍDEO") = {
  rect(
    width: ancho,
    height: alto,
    fill: color-fondo-nota,
    stroke: (paint: color-acento, dash: "dashed", thickness: 1pt),
    radius: 4pt,
    align(center + horizon)[
      #text(font: fuente-sans, size: 1.1em, weight: "bold", fill: color-azul-pizarra, etiqueta)
      #v(4pt)
      #text(font: fuente-sans, size: 8pt, fill: color-cuerpo.lighten(30%), [Espacio reservado para fotograma 4K / diagrama de arquitectura])
    ]
  )
}

// 8. Configuración Base del Documento
#let configurar-documento(lang: "es", cuerpo) = {
  // Aplicar diccionario de excepciones y pauta de guionización en español
  show: if lang == "es" { guionacion.aplicar-excepciones } else { it => it }

  // Configuración de márgenes, cabeceras y pies de página
  set page(
    paper: "a4",
    margin: (x: 2.0cm, top: 2.0cm, bottom: 2.0cm),
    header: context {
      let page-num = counter(page).get().first()
      if page-num <= 2 { return } // No mostrar en portada ni en índice
      
      let header-content = if calc.odd(page-num) {
        align(right, text(font: fuente-sans, size: 8pt, tracking: 1.2pt, fill: color-azul-pizarra.lighten(20%), "ARQUITECTURA DE WEBGPU Y WGSL"))
      } else {
        align(left, text(font: fuente-sans, size: 8pt, tracking: 1.2pt, fill: color-azul-pizarra.lighten(20%), "COMPUTACIÓN GRÁFICA Y PARALELA EN EL SILICIO"))
      }
      
      stack(
        header-content,
        v(4pt),
        line(length: 100%, stroke: 0.5pt + color-acento)
      )
    },
    footer: context {
      let page-num = counter(page).get().first()
      if page-num <= 2 { return }
      
      let chapters = query(selector(<chapter>).before(here()))
      let cap-titulo = if chapters.len() > 0 {
        chapters.last().value
      } else {
        "Introducción: La Máquina Universal"
      }
      
      let num-str = str(page-num)
      let footer-content = if calc.odd(page-num) {
        grid(
          columns: (1fr, auto),
          align(left, text(font: fuente-sans, size: 8.5pt, fill: color-cuerpo.lighten(35%), cap-titulo)),
          align(right, text(font: fuente-sans, size: 9pt, weight: "bold", fill: color-azul-pizarra, num-str))
        )
      } else {
        grid(
          columns: (auto, 1fr),
          align(left, text(font: fuente-sans, size: 9pt, weight: "bold", fill: color-azul-pizarra, num-str)),
          align(right, text(font: fuente-sans, size: 8.5pt, fill: color-cuerpo.lighten(35%), cap-titulo))
        )
      }
      
      stack(
        line(length: 100%, stroke: 0.5pt + color-borde-nota),
        v(4pt),
        footer-content
      )
    }
  )

  // Configuración de párrafos y textos
  set par(justify: true, leading: 0.72em)
  set text(font: fuente-cuerpo, size: 10.2pt, fill: color-cuerpo, lang: lang, hyphenate: true)

  // Reglas de diseño para títulos
  show heading: it => {
    set text(fill: color-azul-pizarra)
    if it.level == 1 {
      block(width: 100%, below: 14pt, above: 22pt, breakable: false)[
        #text(font: fuente-titulo, size: 1.7em, weight: "bold", it.body)
        #v(3pt)
        #line(length: 35%, stroke: 2pt + color-acento)
      ]
    } else if it.level == 2 {
      block(below: 10pt, above: 16pt, breakable: false)[
        #text(font: fuente-titulo, size: 1.25em, weight: "bold", it.body)
      ]
    } else {
      block(below: 6pt, above: 10pt, breakable: false)[
        #text(font: fuente-sans, size: 1.0em, weight: "bold", it.body)
      ]
    }
  }

  cuerpo
}
