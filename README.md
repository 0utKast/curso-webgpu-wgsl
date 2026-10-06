# Curso Completo de WebGPU y WGSL: Arquitectura de Silicio, Compute Shaders y Pipeline Gráfico

Repositorio oficial del curso en vídeo de 5 horas: **[Ver vídeo completo en YouTube](https://youtu.be/EA7YL1wF2UE)**.

Este proyecto reúne todo el código fuente, talleres prácticos interactivos, visualizadores de silicio, shaders en WGSL y libros guía en PDF desarrollados a lo largo del curso. Está concebido como una inmersión rigurosa de bajo nivel en la arquitectura de las GPUs modernas, la superación del monopolio de CUDA mediante estándares abiertos del W3C y la construcción de aplicaciones gráficas y de inteligencia artificial bajo el paradigma **Local-First** en el navegador (**BrowserOS**).

---

## 📥 Descarga Directa del Libro y Materiales en PDF

El curso incluye manuales técnicos y libros maquetados en alta resolución:

* **[Descargar Libro Completo en PDF: Arquitectura de WebGPU y WGSL](https://github.com/0utKast/curso-webgpu-wgsl/blob/main/libro_webgpu_wgsl/libro.pdf)**  
  *(Enlace directo de descarga: [Descarga RAW directa](https://raw.githubusercontent.com/0utKast/curso-webgpu-wgsl/main/libro_webgpu_wgsl/libro.pdf) | [Release oficial v1.0.0](https://github.com/0utKast/curso-webgpu-wgsl/releases/tag/v1.0.0))*
* **[Ensayo Histórico: El Foso de CUDA y la Guerra del Silicio WebGPU (PDF)](https://github.com/0utKast/curso-webgpu-wgsl/blob/main/tutorial_webgpu_wgsl/el_foso_de_cuda_y_la_guerra_del_silicio_webgpu.pdf)**
* **[Capítulo 01: Modelo Mental de WebGPU & WebAssembly (PDF)](https://github.com/0utKast/curso-webgpu-wgsl/blob/main/tutorial_webgpu_wgsl/capitulo_01_modelo_mental_webgpu_wasm.pdf)**
* **[Capítulo 02: Fundamentos del Lenguaje WGSL y Tipos en Silicio (PDF)](https://github.com/0utKast/curso-webgpu-wgsl/blob/main/tutorial_webgpu_wgsl/capitulo_02_fundamentos_wgsl.pdf)**
* **[Capítulo 03: Compute Shaders, Jerarquía de Memoria y GEMM (PDF)](https://github.com/0utKast/curso-webgpu-wgsl/blob/main/tutorial_webgpu_wgsl/capitulo_03_compute_shaders_jerarquia_memoria.pdf)**
* **[Bibliografía Técnica Canónica y Fuentes de O'Reilly Learning (PDF)](https://github.com/0utKast/curso-webgpu-wgsl/blob/main/tutorial_webgpu_wgsl/bibliografia_webgpu_wgsl_browseros.pdf)**

---

## 🛠️ Catálogo de Talleres Interactivos (Workshops)

Todos los talleres son aplicaciones web independientes en un único archivo (HTML/CSS/JavaScript + WGSL nativo), ejecutables en cualquier navegador moderno sin dependencias externas:

| Taller | Archivo | Qué Enseña y Aporta al Curso |
| :--- | :--- | :--- |
| **Workshop 01** | [`workshop_01_webgpu_vs_cpu.html`](tutorial_webgpu_wgsl/workshop_01_webgpu_vs_cpu.html) | **Benchmark Comparativo WebGPU vs. CPU Single-Thread**: Cómputo masivo paralelo sobre vectores de millones de elementos. Demuestra empíricamente la ganancia de órdenes de magnitud del silicio masivo frente a bucles secuenciales en JavaScript. |
| **Workshop 02** | [`workshop_02_memory_alignment_structs.html`](tutorial_webgpu_wgsl/workshop_02_memory_alignment_structs.html) | **Alineamiento de Memoria y Contratos de Estructuras en WGSL**: Simulador interactivo de la regla estricta de los 16 bytes. Inspecciona el empaquetamiento de structs, los offsets de memoria y cómo el padding involuntario corrompe datos en el sombreador. |
| **Workshop 03** | [`workshop_03_mutability_and_divergence.html`](tutorial_webgpu_wgsl/workshop_03_mutability_and_divergence.html) | **Mutabilidad, Punteros y Divergencia de Flujo**: Ilustra cómo los hilos de un warp/subgrupo ejecutan ramas condicionales (`if/else`) y cómo la divergencia serializa la ejecución en el hardware, penalizando el rendimiento. |
| **Workshop 04** | [`workshop_04_recursion_emulation_stack.html`](tutorial_webgpu_wgsl/workshop_04_recursion_emulation_stack.html) | **Emulación de Recursión en GPU mediante Pilas Privadas**: Como WGSL prohíbe la recursión y las GPUs carecen de call stack dinámico, este taller enseña a reescribir algoritmos jerárquicos (recorrido de árboles/fractales) mediante arrays privados y punteros de pila simulados en registros. |
| **Workshop 05** | [`workshop_05_shader_decorators_contract.html`](tutorial_webgpu_wgsl/workshop_05_shader_decorators_contract.html) | **Decoradores de Shader y Contratos de Enlace (`@group`, `@binding`, `@builtin`)**: Visualiza la conexión estricta entre la CPU (JavaScript) y la GPU. Muestra la configuración de `BindGroupLayout`, `BindGroup` y cómo enlazar buffers y variables sin errores de validación. |
| **Workshop 06** | [`workshop_06_tiled_gemm_and_reduction.html`](tutorial_webgpu_wgsl/workshop_06_tiled_gemm_and_reduction.html) | **Tiled GEMM (Multiplicación Matricial por Bloques) y Reducción en Árbol**: El algoritmo fundacional de los modelos de inteligencia artificial y redes neuronales. Implementa teselas cooperativas en memoria compartida (`var<workgroup>`) para evitar el cuello de botella de la VRAM global y reducción paralela sin colisiones de bancos (*bank conflicts*). |
| **Workshop 07** | [`workshop_07_textures_and_image_processing.html`](tutorial_webgpu_wgsl/workshop_07_textures_and_image_processing.html) | **Procesamiento de Imagen en Silicio: Filtro de Convolución Sobel 2D**: Aplica matrices de convolución 3x3 para detección de bordes en tiempo real. Compara la implementación directa en VRAM frente a la optimización de halo en `workgroup memory`, eliminando lecturas redundantes. |
| **Workshop 08** | [`workshop_08_browseros_3d_universe.html`](tutorial_webgpu_wgsl/workshop_08_browseros_3d_universe.html) | **Proyecto Culmen: Universo 3D BrowserOS**: Pipeline gráfico completo con renderizado en tiempo real, shaders de vértices y fragmentos, iluminación PBR / Blinn-Phong, Z-Buffer para profundidad, transformación de matrices MVP y navegación orbital interactiva a 60/120 FPS. |

---

## 🔬 Visualizadores Didácticos de Silicio y Memoria

Simuladores visuales desarrollados para asimilar conceptos complejos de arquitectura física:

1. **[Visualizador de Alineamiento Óptimo](tutorial_webgpu_wgsl/visualizador_caso1_alineamiento_optimo.html)**: Disposición perfecta de campos escalares y vectoriales en memoria sin desperdicio de bytes.
2. **[Visualizador de Padding Peligroso](tutorial_webgpu_wgsl/visualizador_caso2_padding_peligroso.html)**: Demostración visual de los huecos invisibles que se producen al intercalar floats y vec3/vec4 sin seguir la especificación WGSL.
3. **[Visualizador del Ciclo de Vida de GPUBuffer](tutorial_webgpu_wgsl/visualizador_javascript_buffers.html)**: Mapeo asíncrono, buffers intermedios (*staging buffers*) y transferencias entre CPU y GPU.
4. **[Visualizador del Contrato BindGroup](tutorial_webgpu_wgsl/visualizador_bindgroup_contrato.html)**: Esquema de correspondencia entre el layout de la pipeline y los recursos suministrados en tiempo de ejecución.
5. **[Visualizador de Convolución Sobel 2D](tutorial_webgpu_wgsl/visualizador_sobel_compute_shader.html)**: Animación del núcleo de convolución 3x3 recorriendo el mapa de píxeles en paralelo.
6. **[Visualizador del Halo de Workgroup](tutorial_webgpu_wgsl/visualizador_sobel_halo_workgroup.html)**: Cómo el intercambio cooperativo en memoria compartida resuelve los márgenes de convolución sin accesos repetidos a la memoria global.
7. **[Visualizador Compute-to-Render](tutorial_webgpu_wgsl/visualizador_compute_to_render_silicio.html)**: Flujo de datos directo desde un Compute Shader hasta el búfer de vértices de rasterizado sin pasar por el bus PCIe.

---

## 📖 Estructura Temática de los Capítulos

* **Capítulo 01: El Modelo Mental de WebGPU y WebAssembly**  
  La arquitectura de silicio, paralelismo SIMD/SIMT, el navegador web como sistema operativo virtual (*BrowserOS*) y la soberanía del software mediante estándares abiertos.
* **Capítulo 02: Fundamentos del Lenguaje WGSL**  
  Gramática, tipos escalares y compuestos, punteros y espacios de memoria (`uniform`, `storage`, `workgroup`, `private`, `function`), emulación de pilas de llamadas y decoradores de contrato.
* **Capítulo 03: Compute Shaders y Jerarquía de Memoria**  
  Superación del *Memory Wall*, registros por hilo, memoria compartida de grupo de trabajo, resolución de conflictos de bancos y multiplicación matricial optimizada (Tiled GEMM).
* **Capítulo 04: Texturas, Samplers y Computación Gráfica**  
  Curvas Morton (Z-order) para coherencia de caché L1/L2, unidades fijas de textura (TFUs), muestreo bilineal/trilineal y algoritmos de convolución con halo de grupo de trabajo.
* **Capítulo 05: El Pipeline Gráfico Completo, Rasterización y Universo 3D**  
  Línea de montaje de renderizado, shaders de vértices, coordenadas baricéntricas en el rasterizador por hardware, shaders de fragmentos con iluminación PBR, pases de render, Z-Buffer, SwapChain y la síntesis directa Compute-to-Render.

---

## 🚀 Cómo Ejecutar los Talleres y Visualizadores

### Requisitos
* Un navegador moderno con soporte para WebGPU activado por defecto:
  * Google Chrome 113+ (macOS, Windows, ChromeOS, Linux).
  * Microsoft Edge 113+.
  * Safari 18+ (macOS Sequoia / iOS 18).
  * Firefox Nightly (con `dom.webgpu.enabled` en `about:config`).

### Ejecución
1. Clona el repositorio en tu máquina local:
   ```bash
   git clone https://github.com/0utKast/curso-webgpu-wgsl.git
   cd curso-webgpu-wgsl
   ```
2. Dado que los navegadores bloquean ciertas operaciones de buffers y texturas locales bajo el protocolo `file://` debido a la política de orígenes de seguridad (CORS), se recomienda servir los archivos con un servidor HTTP local estático:
   ```bash
   # Opción 1: Con Python 3
   python3 -m http.server 8080

   # Opción 2: Con Node.js
   npx serve .
   ```
3. Abre tu navegador en `http://localhost:8080/tutorial_webgpu_wgsl/` y selecciona cualquiera de los talleres `workshop_01_...` a `workshop_08_...`.

---

## 📚 Bibliografía y Referencias de Autoridad

Este curso ha fundamentado cada diseño de arquitectura y cálculo físico en la literatura canónica de la informática y las especificaciones vivas del W3C:

* **Patterson, D. A. & Hennessy, J. L.** — *Computer Organization and Design: The Hardware/Software Interface*.
* **Akenine-Möller, T., Haines, E. & Hoffman, N.** — *Real-Time Rendering* (4ª edición).
* **Hwu, W. & Kirk, D.** — *Programming Massively Parallel Processors: A Hands-on Approach*.
* **Sellers, G.** — *Vulkan Programming Guide: The Official Guide to Learning Vulkan*.
* **W3C WebGPU Working Group** — *WebGPU Specification & WebGPU Shading Language (WGSL) W3C Recommendation*.

---

## 👤 Autor
* **Jesús Conde** ([@0utKast](https://github.com/0utKast))
* Vídeo en YouTube: **[Curso Completo de WebGPU y WGSL (5 Horas)](https://youtu.be/EA7YL1wF2UE)**
