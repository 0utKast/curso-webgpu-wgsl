// ============================================================================
// COMPUTE SHADER OPTIMIZADO: Convolución 2D de Sobel con Región de Halo en SRAM
// Archivo: sobel_convolucion_halo_workgroup.wgsl
// Serie: BrowserOS — Computación Nativa en la Web con Wasm, WebGPU y WGSL
// Capítulo 4 • Apartado 5: Optimización con Memoria Compartida (var<workgroup>)
// ============================================================================

// Entrada: Textura 2D muestreable (Solo Lectura)
@group(0) @binding(0) var textura_entrada: texture_2d<f32>;

// Salida: Textura de Almacenamiento (Escritura directa de Píxeles)
@group(0) @binding(1) var textura_salida: texture_storage_2d<rgba8unorm, write>;

// ============================================================================
// CONSTANTES DE GEOMETRÍA DEL WORKGROUP Y EL HALO DE FRONTERA
// ============================================================================
const TILE_ANCHO: u32 = 16u;
const TILE_ALTO: u32 = 16u;
const RADIO_HALO: u32 = 1u;                       // Radio de la máscara 3x3 (R = 1)
const HALO_ANCHO: u32 = 18u;                      // 16 + 2 * 1
const HALO_ALTO: u32 = 18u;                       // 16 + 2 * 1
const TOTAL_PIXELES_HALO: u32 = 324u;             // 18 * 18 = 324 elementos
const TOTAL_HILOS_WORKGROUP: u32 = 256u;          // 16 * 16 = 256 hilos

// Memoria Compartida On-Chip (SRAM L1):
// 324 elementos f32 (luminancia) = 1.296 bytes (apenas 1.3 KB del límite de 16 KB)
var<workgroup> baldosa_halo: array<array<f32, 18>, 18>;

// Función auxiliar para extraer luminancia ITU-R BT.601 con clamping seguro de bordes
fn leer_luminancia_global(coords: vec2<i32>, dims: vec2<i32>) -> f32 {
    let coords_seguras = vec2<u32>(
        clamp(coords, vec2<i32>(0, 0), dims - vec2<i32>(1, 1))
    );
    let color: vec4<f32> = textureLoad(textura_entrada, coords_seguras, 0u);
    return 0.299 * color.r + 0.587 * color.g + 0.114 * color.b;
}

// ============================================================================
// KERNEL DE CÓMPUTO COOPERATIVO
// ============================================================================
@compute @workgroup_size(16, 16)
fn cs_sobel_halo(
    @builtin(global_invocation_id) global_id: vec3<u32>,
    @builtin(local_invocation_id) local_id: vec3<u32>,
    @builtin(workgroup_id) group_id: vec3<u32>
) {
    let dims_u: vec2<u32> = textureDimensions(textura_entrada);
    let dims: vec2<i32> = vec2<i32>(dims_u);

    // 1. Origen global del bloque interior en la imagen
    let base_bloque: vec2<i32> = vec2<i32>(group_id.xy) * vec2<i32>(16, 16);

    // 2. Índice lineal del hilo dentro del bloque (de 0 a 255)
    let hilo_lineal: u32 = local_id.y * 16u + local_id.x;

    // 3. CARGA COOPERATIVA EN SRAM (Strided Loop):
    // Hay 324 píxeles que cargar entre 256 hilos. Los primeros 68 hilos cargan 2 píxeles,
    // garantizando cobertura del 100% de la baldosa y el delantal exterior de 1 píxel.
    for (var i: u32 = hilo_lineal; i < TOTAL_PIXELES_HALO; i += TOTAL_HILOS_WORKGROUP) {
        let halo_y: u32 = i / HALO_ANCHO;  // Fila local en la baldosa (0 a 17)
        let halo_x: u32 = i % HALO_ANCHO;  // Columna local en la baldosa (0 a 17)

        // Coordenada global en la imagen con desplazamiento de -1 por el radio del halo
        let coords_globales: vec2<i32> = base_bloque + vec2<i32>(i32(halo_x) - 1, i32(halo_y) - 1);

        // Escritura en memoria compartida (SRAM)
        baldosa_halo[halo_y][halo_x] = leer_luminancia_global(coords_globales, dims);
    }

    // 4. BARRERA DE SINCRONIZACIÓN OBLIGATORIA:
    // Detiene la ejecución hasta que los 256 hilos hayan terminado de poblar la baldosa en SRAM.
    workgroupBarrier();

    // 5. GUARDA DE LÍMITES PARA LA ESCRITURA EN MEMORIA GLOBAL
    let x_global: i32 = i32(global_id.x);
    let y_global: i32 = i32(global_id.y);
    if (x_global >= dims.x || y_global >= dims.y) {
        return;
    }

    // 6. LECTURA DE LA VECINDAD 3x3 DESDE LA BALDOSA DE HALO EN SRAM (1 A 2 CICLOS)
    // El píxel central del hilo (local_id) se mapea a (local_id + 1) dentro de baldosa_halo.
    let lx: u32 = local_id.x + 1u;
    let ly: u32 = local_id.y + 1u;

    let l00: f32 = baldosa_halo[ly - 1u][lx - 1u];
    let l10: f32 = baldosa_halo[ly - 1u][lx];
    let l20: f32 = baldosa_halo[ly - 1u][lx + 1u];

    let l01: f32 = baldosa_halo[ly][lx - 1u];
    let l21: f32 = baldosa_halo[ly][lx + 1u];

    let l02: f32 = baldosa_halo[ly + 1u][lx - 1u];
    let l12: f32 = baldosa_halo[ly + 1u][lx];
    let l22: f32 = baldosa_halo[ly + 1u][lx + 1u];

    // 7. CONVOLUCIÓN CON LAS MÁSCARAS DE SOBEL (Gx y Gy)
    // Kernel horizontal Kx
    let gx: f32 = (-1.0 * l00) + (1.0 * l20) +
                  (-2.0 * l01) + (2.0 * l21) +
                  (-1.0 * l02) + (1.0 * l22);

    // Kernel vertical Ky
    let gy: f32 = (-1.0 * l00) + (-2.0 * l10) + (-1.0 * l20) +
                  ( 1.0 * l02) + ( 2.0 * l12) + ( 1.0 * l22);

    // 8. MAGNITUD EUCLÍDEA DEL GRADIENTE: sqrt(Gx² + Gy²)
    let magnitud: f32 = sqrt(gx * gx + gy * gy);

    // 9. ESCRITURA DIRECTA DEL PÍXEL EN LA STORAGE TEXTURE
    let color_borde: vec4<f32> = vec4<f32>(magnitud, magnitud, magnitud, 1.0);
    textureStore(textura_salida, vec2<u32>(global_id.xy), color_borde);
}
