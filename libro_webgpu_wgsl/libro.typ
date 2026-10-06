#import "templates/estilos.typ" as estilos

#show: estilos.configurar-documento

// --- PORTADA PRINCIPAL DEL LIBRO ---
#include "contenido/00_introduccion/portada.typ"

// --- ÍNDICE GENERAL Y HOJA DE RUTA EDITORIAL ---
#include "contenido/00_introduccion/indice.typ"

#pagebreak()

// --- INTRODUCCIÓN GENERAL: LA MÁQUINA UNIVERSAL ---
#include "contenido/00_introduccion/introduccion.typ"
