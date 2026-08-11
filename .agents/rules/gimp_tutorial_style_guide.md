# Reglas de Estilo y Generación de Recursos para Tutoriales de GIMP

## 🎯 Propósito y Alcance
Estas reglas aplican exclusivamente al proyecto de desarrollo de contenidos y tutoriales de GIMP en este espacio de trabajo. Garantizan que todo el material de prácticas, ejemplos e imágenes de apoyo sea 100% original, coherente en estética, y **estrictamente verificado con la interfaz en español de GIMP 3.2.4**.

---

## ⚡ REGLA OBLIGATORIA DE AUDITORÍA: Interfaz GIMP 3.2.4 (Subagente `gimp_version_auditor`)

1. **Protocolo Estricto de Verificación Previos a la Entrega**:
   - Antes de entregar cualquier guión, tabla de tiempos o texto de locución al usuario, **ES OBLIGATORIO** auditar cada nombre de menú, submenú, herramienta y opción contra la interfaz real de **GIMP 3.2.4 en español**.
   - Queda estrictamente prohibido utilizar traducciones o nomenclaturas legadas de GIMP 2.8/2.10 procedentes de libros antiguos de O'Reilly.

2. **Diccionario Oficial de Términos GIMP 3.2.4 en Español**:
   - **Filtro de Sombra Suave (Drop Shadow)**: `Filtros` ➔ `Luz y sombra` ➔ **`Sombra paralela...`** *(Jamás usar 'Sombra proyectada' ni 'Sombra de gota')*.
   - **Filtro de Sombra Plana (Long Shadow)**: `Filtros` ➔ `Luz y sombra` ➔ **`Sombra alargada...`**.
   - **Herramienta de Escalar**: **`Redimensionar`** (`Shift + S`).
   - **Herramienta de Mover**: **`Mover`** (`M`), opción **`Mover las capas seleccionadas`**.
   - **Herramienta de Recortar**: **`Recortar`** (`Shift + C`), opción **`Solo las capas seleccionadas`**.
   - **Herramienta de Texto**: **`Texto`** (`T`).
   - **Herramienta de Alinear**: **`Alinear`** (`Q`), opción **`Relativo a: Imagen`**.
   - **Ajustes de Capa**: Clic derecho en Capa ➔ **`Capa a tamaño de imagen`**, **`Añadir canal alfa`**.
   - **Archivos**: `Archivo` ➔ `Abrir como capas...` (`Ctrl + Alt + O`), `Archivo` ➔ `Guardar como...` (`Ctrl + S`), `Archivo` ➔ `Exportar como...` (`Shift + Ctrl + E`).

---

## 📐 Nomenclatura Única de Archivos
- `gimp_v<numero_video>_<tipo_recurso>_<descripcion_corta>.<ext>`
- Ejemplo: `gimp_v1_banner_background.jpg`, `gimp_v2_product_subject.jpg`, `gimp_v2_camera_clean_neutral.png`.

---

## 🤖 Subagentes Especializados del Proyecto
1. **`gimp_asset_designer`**: Generación de recursos visuales fotorrealistas.
2. **`gimp_version_auditor`**: Verificación obligatoria e incondicional de los términos exactos de GIMP 3.2.4 en español antes de responder.
