// =========================================================================
// WebGPU / WGSL: Recorrido Iterativo de Árbol / BVH con Pila en Memoria Privada
// Evita recursividad garantizando asignación fija de registros y cero desbordamiento.
// =========================================================================

// Estructura representativa de un nodo en el árbol jerárquico (BVH)
struct Nodo {
    hijo_izq: u32,       // Índice al hijo izquierdo (0 si no tiene)
    hijo_der: u32,       // Índice al hijo derecho (0 si no tiene)
    es_hoja: u32,        // 1 si es hoja, 0 si es nodo interno
    valor: f32,          // Dato o métrica calculada
};

// Buffers de entrada y salida en memoria de almacenamiento (VRAM global)
@group(0) @binding(0) var<storage, read> arbol_nodos: array<Nodo>;
@group(0) @binding(1) var<storage, read_write> resultados: array<f32>;

// Límite estático rígido: 16 niveles permiten indexar hasta 2^16 = 65.536 nodos
const CAPACIDAD_PILA: u32 = 16u;

// Función de recorrido que emula recursividad de forma iterativa y segura
fn recorrer_arbol_iterativo(nodo_raiz: u32) -> f32 {
    // 1. Array local en memoria privada del hilo (mapeado a registros físicos)
    var pila: array<u32, 16>;
    
    // 2. Puntero entero para apilar y desapilar
    var ptr_pila: u32 = 0u;

    // 3. APILAR el nodo raíz inicial (Push)
    pila[ptr_pila] = nodo_raiz;
    ptr_pila += 1u;

    var acumulador: f32 = 0.0;

    // 4. Bucle tradicional: se ejecuta mientras haya nodos pendientes en la pila
    while (ptr_pila > 0u) {
        // DESAPILAR el nodo superior (Pop)
        ptr_pila -= 1u;
        let id_actual: u32 = pila[ptr_pila];

        // Lectura del nodo desde memoria global
        let nodo: Nodo = arbol_nodos[id_actual];

        if (nodo.es_hoja == 1u) {
            // Caso base: procesamos los datos de la hoja
            acumulador += nodo.valor;
        } else {
            // Caso recursivo: apilamos los hijos verificando el límite rígido
            // para evitar cualquier desbordamiento en tiempo de ejecución.
            if (nodo.hijo_der != 0u && ptr_pila < CAPACIDAD_PILA) {
                pila[ptr_pila] = nodo.hijo_der;
                ptr_pila += 1u;
            }
            if (nodo.hijo_izq != 0u && ptr_pila < CAPACIDAD_PILA) {
                pila[ptr_pila] = nodo.hijo_izq;
                ptr_pila += 1u;
            }
        }
    }

    return acumulador;
}

// Punto de entrada de cómputo (Compute Shader)
@compute @workgroup_size(64)
fn main(@builtin(global_invocation_id) global_id: vec3<u32>) {
    let indice = global_id.x;
    if (indice < arrayLength(&resultados)) {
        // Cada hilo de la GPU recorre el árbol de forma independiente y paralela
        resultados[indice] = recorrer_arbol_iterativo(0u);
    }
}
