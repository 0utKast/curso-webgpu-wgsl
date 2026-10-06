# Guía Completa y Programa Detallado del Curso: WebGPU & WGSL

Este documento contiene la descripción enciclopédica, el desglose conceptual y todos los recursos complementarios del curso en vídeo de 5 horas: **[Ver Curso en YouTube](https://youtu.be/EA7YL1wF2UE)**.

---

## 📦 Repositorio y Descarga de Materiales

* **Repositorio Principal:** [https://github.com/0utKast/curso-webgpu-wgsl](https://github.com/0utKast/curso-webgpu-wgsl)
* **Descarga Directa del Compendio Bibliográfico y Recursos de WGSL (PDF):** [Descargar bibliografia_webgpu_wgsl_browseros.pdf](https://github.com/0utKast/curso-webgpu-wgsl/releases/download/v1.0.0/bibliografia_webgpu_wgsl_browseros.pdf)
* **Visor del PDF en GitHub:** [`tutorial_webgpu_wgsl/bibliografia_webgpu_wgsl_browseros.pdf`](tutorial_webgpu_wgsl/bibliografia_webgpu_wgsl_browseros.pdf)
* **Release Oficial:** [GitHub Release v1.0.0](https://github.com/0utKast/curso-webgpu-wgsl/releases/tag/v1.0.0)

> *Nota:* El PDF proporcionado corresponde a la bibliografía canónica, auditoría de O'Reilly y directorio exhaustivo de recursos online de WebGPU/WGSL. El libro monográfico del curso en PDF es una meta editorial futura.

---

## 🛠️ Catálogo de Talleres Interactivos (Workshops)

Todos los talleres son aplicaciones autónomas de un solo archivo HTML, ejecutables con doble clic sin necesidad de servidores locales ni dependencias:

1. **[Workshop 01: Benchmark Comparativo WebGPU vs. CPU Single-Thread](tutorial_webgpu_wgsl/workshop_01_webgpu_vs_cpu.html)**  
   *Cómputo masivo paralelo sobre vectores de millones de elementos demostrando la aceleración por hardware frente al bucle secuencial en JavaScript.*
2. **[Workshop 02: Alineamiento de Memoria y Contratos de Estructuras en WGSL](tutorial_webgpu_wgsl/workshop_02_memory_alignment_structs.html)**  
   *Simulador interactivo de la regla estricta de los 16 bytes y los riesgos de padding involuntario que corrompen datos en el shader.*
3. **[Workshop 03: Mutabilidad, Punteros y Divergencia de Flujo](tutorial_webgpu_wgsl/workshop_03_mutability_and_divergence.html)**  
   *Ilustración de cómo los hilos de un subgrupo (warp) ejecutan ramas condicionales y cómo la divergencia serializa la ejecución física.*
4. **[Workshop 04: Emulación de Recursión en GPU mediante Pilas Privadas](tutorial_webgpu_wgsl/workshop_04_recursion_emulation_stack.html)**  
   *Técnica para ejecutar algoritmos jerárquicos y fractales en registros sin soporte dinámico de pila (call stack).*
5. **[Workshop 05: Decoradores de Shader y Contratos de Enlace (@group, @binding)](tutorial_webgpu_wgsl/workshop_05_shader_decorators_contract.html)**  
   *El cableado estricto entre CPU (JavaScript) y GPU mediante BindGroupLayout y BindGroups.*
6. **[Workshop 06: Tiled GEMM y Reducción en Árbol en Memoria Compartida](tutorial_webgpu_wgsl/workshop_06_tiled_gemm_and_reduction.html)**  
   *Multiplicación matricial por bloques para redes neuronales y reducción paralela sin colisiones de bancos (bank conflicts).*
7. **[Workshop 07: Texturas, Samplers y Filtro de Convolución Sobel 2D](tutorial_webgpu_wgsl/workshop_07_textures_and_image_processing.html)**  
   *Procesamiento de imagen en silicio: convolución directa en VRAM frente a halo optimizado en memoria de grupo de trabajo.*
8. **[Workshop 08: Universo 3D BrowserOS (Pipeline Gráfico Completo)](tutorial_webgpu_wgsl/workshop_08_browseros_3d_universe.html)**  
   *Renderizado 3D en tiempo real, shaders de vértices y fragmentos, iluminación PBR, Z-Buffer y navegación orbital a 60/120 FPS.*

---

## 🔬 Visualizadores Didácticos de Silicio

* **[Alineamiento Óptimo](tutorial_webgpu_wgsl/visualizador_caso1_alineamiento_optimo.html):** Disposición de campos en memoria sin desperdicio de bytes.
* **[Padding Peligroso](tutorial_webgpu_wgsl/visualizador_caso2_padding_peligroso.html):** Demostración de huecos invisibles en memoria.
* **[Ciclo de Vida de GPUBuffer](tutorial_webgpu_wgsl/visualizador_javascript_buffers.html):** Mapeo asíncrono y staging buffers.
* **[Contrato BindGroup](tutorial_webgpu_wgsl/visualizador_bindgroup_contrato.html):** Correspondencia entre pipeline layout y recursos.
* **[Convolución Sobel 2D](tutorial_webgpu_wgsl/visualizador_sobel_compute_shader.html):** Animación del núcleo 3x3 en paralelo.
* **[Halo de Workgroup](tutorial_webgpu_wgsl/visualizador_sobel_halo_workgroup.html):** Cooperación en memoria compartida sin accesos redundantes a VRAM.
* **[Síntesis Compute-to-Render](tutorial_webgpu_wgsl/visualizador_compute_to_render_silicio.html):** Bypass directo del bus PCIe.

---

## 📑 Manuales y Ensayos Técnicos en PDF

* **[El Foso de CUDA y la Guerra del Silicio WebGPU (PDF)](tutorial_webgpu_wgsl/el_foso_de_cuda_y_la_guerra_del_silicio_webgpu.pdf)**
* **[Capítulo 01: Modelo Mental de WebGPU & WASM (PDF)](tutorial_webgpu_wgsl/capitulo_01_modelo_mental_webgpu_wasm.pdf)**
* **[Capítulo 02: Fundamentos de WGSL y Tipos en Silicio (PDF)](tutorial_webgpu_wgsl/capitulo_02_fundamentos_wgsl.pdf)**
* **[Capítulo 03: Compute Shaders, Jerarquía de Memoria y GEMM (PDF)](tutorial_webgpu_wgsl/capitulo_03_compute_shaders_jerarquia_memoria.pdf)**
* **[Bibliografía Técnica y Fuentes de O'Reilly Learning (PDF)](tutorial_webgpu_wgsl/bibliografia_webgpu_wgsl_browseros.pdf)**

---

## ⏱️ Temario Analítico del Curso

### Bloque 01: El Foso de CUDA, la Guerra del Silicio y el Modelo Mental WebGPU & WASM
- La batalla entre ecosistemas cerrados y estándares abiertos del W3C.
- El navegador como sistema operativo virtual y entorno de computación de alto rendimiento.
- La arquitectura Local-First y la soberanía del cómputo en el cliente.

### Bloque 02: Fundamentos del Lenguaje WGSL y Tipos en Silicio
- Gramática formal, inferencia y tipado estricto.
- Espacios de memoria y direcciones: `uniform`, `storage`, `workgroup`, `private` y `function`.
- La regla estricta de alineamiento a 16 bytes y cómo evitar la corrupción por padding.
- Emulación de recursión en GPU mediante pilas privadas en registros.
- El contrato de enlace: decoradores `@group`, `@binding` y variables integradas (`@builtin`).

### Bloque 03: Compute Shaders y Jerarquía de Memoria
- Superación de la barrera de la memoria (Memory Wall).
- Jerarquía física: registros, memoria compartida de grupo de trabajo y VRAM global.
- Arquitectura de bancos de memoria y eliminación de bank conflicts.
- Algoritmos paralelos canónicos: reducción en árbol cooperativa.
- Tiled GEMM: multiplicación matricial por bloques para inferencia de modelos de IA.

### Bloque 04: Texturas, Samplers y Computación Gráfica
- Localidad espacial 2D y la curva de Morton (Z-order curve) en caches L1/L2.
- Unidades de función fija (TFUs) y modos de muestreo (linear, nearest, clamp-to-edge).
- Tipos de texturas en WGSL y formatos de color estandarizados.
- Convolución 2D: implementación del operador Sobel para detección de bordes.
- Optimización de convolución mediante halo de celda en memoria compartida.
- Orquestación asíncrona desde el hilo principal de JavaScript.

### Bloque 05: El Pipeline Gráfico Completo y el Universo 3D
- La dualidad en el chip: Compute Shaders frente a la línea de ensamblaje de rasterización.
- Shaders de vértices y transformaciones proyectivas (Model-View-Projection).
- El rasterizador de función fija y la interpolación por coordenadas baricéntricas.
- Shaders de fragmentos y modelos de iluminación física (PBR / Blinn-Phong).
- Pases de renderizado, búfer de profundidad (Z-Buffer) y pruebas de mezcla (Alpha Blending).
- Orquestación de la SwapChain, refresco a 60/120 FPS y sujeción de delta time.
- Síntesis directa Compute-to-Render sin congestión en el bus PCIe.
- Perspectivas de futuro: Model Context Protocol (MCP), inferencia local de IA y la era de BrowserOS.

---

## 📚 Bibliografía de Referencia

* **Patterson, D. A. & Hennessy, J. L.** — *Computer Organization and Design: The Hardware/Software Interface*.
* **Akenine-Möller, T., Haines, E. & Hoffman, N.** — *Real-Time Rendering* (4th Ed.).
* **Hwu, W. & Kirk, D.** — *Programming Massively Parallel Processors*.
* **Sellers, G.** — *Vulkan Programming Guide*.
* **W3C Working Group** — *WebGPU and WGSL Specifications*.
