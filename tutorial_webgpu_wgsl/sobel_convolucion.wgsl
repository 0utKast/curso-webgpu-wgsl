// ============================================================================
// COMPUTE SHADER: Filtro de Convolución 2D de Sobel en WGSL
// Archivo: sobel_convolucion.wgsl
// Serie: BrowserOS — Computación Nativa en la Web con Wasm, WebGPU y WGSL
// Capítulo 4 • Apartado 4: Convolución Bidimensional y Procesamiento de Imagen
// ============================================================================

// Entrada: Textura 2D muestreable (Solo Lectura)
@group(0) @binding(0) var textura_entrada: texture_2d<f32>;

// Salida: Textura de Almacenamiento (Escritura directa de píxeles)
@group(0) @binding(1) var textura_salida: texture_storage_2d<rgba8unorm, write>;

// ============================================================================
// FUNCIÓN AUXILIAR: Extrae la luminancia perceptual de un píxel con clamping seguro
// ============================================================================
fn obtener_luminancia(coords_enteras: vec2<i32>, dimensiones: vec2<i32>) -> f32 {
    // Tratamiento de bordes: Clamping manual para evitar lecturas ilegales de memoria.
    // Si coords_enteras < 0 se fija a 0; si >= dimensiones se fija a (dimensiones - 1).
    let coords_seguras: vec2<u32> = vec2<u32>(
        clamp(coords_enteras, vec2<i32>(0, 0), dimensiones - vec2<i32>(1, 1))
    );
    
    // Lectura de texel mediante coordenadas enteras directas (mip level 0)
    let color: vec4<f32> = textureLoad(textura_entrada, coords_seguras, 0u);

    // Conversión a escala de grises mediante el estándar internacional ITU-R BT.601
    return 0.299 * color.r + 0.587 * color.g + 0.114 * color.b;
}

// ============================================================================
// KERNEL PRINCIPAL DE CÓMPUTO: Convolución Espacial de Sobel 3x3
// ============================================================================
// Configuración del Workgroup: Bloque 2D de 16x16 = 256 hilos simultáneos
@compute @workgroup_size(16, 16)
fn cs_sobel(
    @builtin(global_invocation_id) global_id: vec3<u32>
) {
    let dims_u: vec2<u32> = textureDimensions(textura_entrada);
    let dims: vec2<i32> = vec2<i32>(dims_u);
    let x: i32 = i32(global_id.x);
    let y: i32 = i32(global_id.y);

    // Guarda de límites: Evita que hilos en los márgenes de relleno escriban fuera
    if (x >= dims.x || y >= dims.y) {
        return;
    }

    // 1. Muestreo de la vecindad 3x3 de luminancia (9 lecturas independientes a VRAM)
    // Fila superior (y - 1)
    let l00 = obtener_luminancia(vec2<i32>(x - 1, y - 1), dims);
    let l10 = obtener_luminancia(vec2<i32>(x,     y - 1), dims);
    let l20 = obtener_luminancia(vec2<i32>(x + 1, y - 1), dims);

    // Fila intermedia (y): el píxel central (x, y) no interviene en Sobel (coeficiente 0)
    let l01 = obtener_luminancia(vec2<i32>(x - 1, y),     dims);
    let l21 = obtener_luminancia(vec2<i32>(x + 1, y),     dims);

    // Fila inferior (y + 1)
    let l02 = obtener_luminancia(vec2<i32>(x - 1, y + 1), dims);
    let l12 = obtener_luminancia(vec2<i32>(x,     y + 1), dims);
    let l22 = obtener_luminancia(vec2<i32>(x + 1, y + 1), dims);

    // 2. Convolución con el Kernel Horizontal (Kx -> Gradiente Gx)
    // Matriz Kx:
    // [ -1,  0, +1 ]
    // [ -2,  0, +2 ]
    // [ -1,  0, +1 ]
    let gx: f32 = (-1.0 * l00) + (1.0 * l20) +
                  (-2.0 * l01) + (2.0 * l21) +
                  (-1.0 * l02) + (1.0 * l22);

    // 3. Convolución con el Kernel Vertical (Ky -> Gradiente Gy)
    // Matriz Ky:
    // [ -1, -2, -1 ]
    // [  0,  0,  0 ]
    // [ +1, +2, +1 ]
    let gy: f32 = (-1.0 * l00) + (-2.0 * l10) + (-1.0 * l20) +
                  ( 1.0 * l02) + ( 2.0 * l12) + ( 1.0 * l22);

    // 4. Magnitud Euclídea del Gradiente Total: sqrt(Gx² + Gy²)
    let magnitud: f32 = sqrt(gx * gx + gy * gy);

    // 5. Empaquetado visual del color: Aristas blancas sobre fondo negro
    let color_borde = vec4<f32>(magnitud, magnitud, magnitud, 1.0);

    // 6. Escritura directa en la textura de almacenamiento (Storage Texture)
    textureStore(textura_salida, vec2<u32>(global_id.xy), color_borde);
}
