---
name: gimp-version-auditor
description: Habilidad obligatoria de verificación de interfaz para auditar y adaptar cualquier guión o tutorial de GIMP a la versión más reciente GIMP 3.2.4 en español.
---

# Auditor de Interfaz y Nomenclatura GIMP 3.2.4

## Descripción
Esta habilidad impone una revisión estricta de todos los términos, menús, submenús, atajos de teclado y diálogos contenidos en los tutoriales para garantizar que coincidan al 100% con la interfaz real en español de **GIMP 3.2.4**.

---

## Tabla de Mapeo Directo (Legado vs GIMP 3.2.4 Real)

| Término Legado / Antiguo | Término Real en GIMP 3.2.4 (Español) | Menú / Atajo |
| :--- | :--- | :--- |
| *Sombra proyectada / Sombra de gota* | **`Sombra paralela...`** | `Filtros` ➔ `Luz y sombra` ➔ `Sombra paralela...` |
| *Sombra larga / Long Shadow* | **`Sombra alargada...`** | `Filtros` ➔ `Luz y sombra` ➔ `Sombra alargada...` |
| *Escalar* | **`Redimensionar`** | `Shift + S` |
| *Mover capa activa* | **`Mover las capas seleccionadas`** | Herramienta `Mover` (`M`) |
| *Recortar (Eliminar recortados deshabilitado)* | **`Solo las capas seleccionadas`** | Herramienta `Recortar` (`Shift + C`) |
| *Varita mágica / Magic Wand* | **`Selección difusa`** | Herramienta `Selección difusa` (`U`) |
| *Calado / Feathering* | **`Difuminar...`** | `Selección` ➔ `Difuminar...` |
| *Alinear elementos* | **`Alinear`** | Herramienta `Alinear` (`Q`), `Relativo a: Imagen` |

---

## Lista de Comprobación para el Auditor
1. ¿El filtro de sombra suave se nombra exactamente como **`Sombra paralela...`**?
2. ¿Se indica la ruta correcta: **`Filtros ➔ Luz y sombra ➔ Sombra paralela...`**?
3. ¿Se especifican los atajos de Windows (`Ctrl`, `Shift`)?
4. ¿Se ha eliminado cualquier referencia a "Sombra proyectada"?
