---
name: code-spotlight-visualizer
description: Generación de visualizadores de código interactivos en documentos HTML independientes, con estética de editor moderno (estilo Visual Studio Code Dark+), resaltado sintáctico y controles de foco/spotlight para destacar secciones clave. Opción recomendada para material de apoyo en cursos, vídeos y presentaciones técnicas.
---

# Habilidad: Visualizador de Código Interactivo con Foco Dinámico (Code Spotlight Visualizer)

## 1. Naturaleza y Carácter de la Habilidad
Esta habilidad **no es imperativa**, sino una **opción de alto valor pedagógico y visual** dentro del conjunto de herramientas de desarrollo de contenidos. 

Debe considerarse de forma prioritaria siempre que:
- Se redacte código complejo destinado a ser explicado en vídeo o tutoriales en pantalla.
- El código en texto plano o monocromo resulte árido o insuficiente para la audiencia del curso.
- Se desee proporcionar material interactivo de apoyo para que el alumno pueda explorar y comprender el flujo de ejecución paso a paso en su navegador.

---

## 2. Propósito y Ventajas Técnicas
Un documento HTML independiente con visualizador de código ofrece ventajas inmediatas frente a capturas estáticas o bloques de texto plano:

1. **Autonomía Total (Zero Dependencies):** No requiere Node.js, servidores locales, conexiones a CDNs ni compiladores en tiempo de ejecución. Funciona abriéndolo directamente en cualquier navegador moderno (Safari, Chrome, Firefox).
2. **Estética de Editor Profesional (VS Code Dark+):** Reproduce con fidelidad los marcos de ventana de macOS, pestañas activas con iconos de lenguaje, migas de pan (*breadcrumbs*), números de línea alineados y barra de estado inferior.
3. **Resaltado de Sintaxis por Tokens:** Utiliza la paleta cromática exacta del tema *Dark+* de VS Code:
   - Palabras clave de control (`if`, `while`, `return`): `#c586c0`
   - Declaraciones de almacenamiento (`var`, `let`, `struct`): `#569cd6`
   - Tipos de datos (`u32`, `f32`, `i32`, clases/structs): `#4ec9b0`
   - Variables e identificadores: `#9cdcfe`
   - Funciones y llamadas: `#dcdcaa`
   - Literales numéricos: `#b5cea8`
   - Comentarios explicativos: `#6a9955` (en cursiva)
4. **Foco Dinámico (*Spotlight* Interactivo):** Permite al instructor o al estudiante pulsar botones de control temáticos para iluminar intensamente un bloque de líneas con borde acentuado (`#38bdf8`) mientras atenúa suavemente el resto del código (`opacity: 0.35`).
5. **Banner Explicativo Sincronizado:** Cada foco visual actualiza simultáneamente un panel informativo con el argumento técnico o locución correspondiente a esa sección.

---

## 3. Patrón de Implementación Estándar

Al generar un archivo de taller o demostración visual (ej. `workshop_XX_...html`), se recomienda seguir esta arquitectura:

### A. Estructura del Encabezado
```html
<header>
  <div class="badge">Taller Práctico X • [Tecnología]</div>
  <h1>[Título de la Lección / Patrón de Diseño]</h1>
  <p class="subtitle">[Descripción concisa del problema técnico y la solución]</p>
</header>
```

### B. Barra de Herramientas de Exposición
```html
<div class="interactive-toolbar">
  <div class="toolbar-label">Fases de la Explicación</div>
  <div class="btn-group">
    <button class="btn active" onclick="setSpotlight('all', this)">Código Completo</button>
    <button class="btn" onclick="setSpotlight('fase1', this)">1. Declaración Clave</button>
    <button class="btn" onclick="setSpotlight('fase2', this)">2. Bucle de Control</button>
    <!-- Botones según los hitos pedagógicos -->
  </div>
</div>
<div class="explanation-banner" id="explanation-text">...</div>
```

### C. Ventana de Código con Atributos `data-section`
Cada línea de código se encapsula en un `div.code-line` asociado a su sección lógica mediante `data-section`:

```html
<div class="code-line" data-section="fase1">
  <span class="line-number">1</span>
  <span class="line-content"><span class="st">var</span> <span class="vr">pila</span><span class="op">:</span> <span class="tp">array</span><span class="op">&lt;</span><span class="tp">u32</span><span class="op">,</span> <span class="nm">16</span><span class="op">&gt;;</span></span>
</div>
```

### D. Lógica JavaScript Ligera (Sin Frameworks)
```javascript
const descriptions = {
  'all': 'Mostrando el código completo...',
  'fase1': 'Explicación del bloque 1...',
  'fase2': 'Explicación del bloque 2...'
};

function setSpotlight(section, buttonEl) {
  const lines = document.querySelectorAll('.code-line');
  document.querySelectorAll('.btn').forEach(b => b.classList.remove('active'));
  buttonEl.classList.add('active');

  document.getElementById('explanation-text').innerHTML = descriptions[section] || descriptions['all'];

  lines.forEach(line => {
    if (section === 'all') {
      line.classList.remove('spotlight', 'dimmed');
    } else if (line.getAttribute('data-section') === section) {
      line.classList.add('spotlight');
      line.classList.remove('dimmed');
    } else {
      line.classList.remove('spotlight');
      line.classList.add('dimmed');
    }
  });
}
```

---

## 4. Ámbitos de Aplicación
- **Cursos y Videotutoriales:** Ideal para capturas de pantalla 16:9 y 4K con tipografía de alto contraste (*JetBrains Mono*, *Fira Code*).
- **Material de Prácticas y Talleres:** Como complemento autónomo junto a los archivos fuente reales (`.wgsl`, `.cpp`, `.rs`, `.py`).
- **Explicación de Anti-patrones vs. Soluciones Óptimas:** Permite contrastar visualmente el coste de hardware de diferentes arquitecturas de cómputo.
