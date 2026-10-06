# 🚀 INFORME TÉCNICO Y GUÍA DE EJECUCIÓN MCP PARA ANTIGRAVITY (WINDOWS)
## *Proyecto: Serie de Tutoriales GIMP 3.2.4 – Vídeo 5 (Restauración e IA)*

---

## 📌 1. ESTADO ACTUAL Y OBJETIVO DEL PROYECTO

* **Plataforma:** Windows (GIMP 3.2.4 + Antigravity).
* **Estado de la sesión del usuario:** El usuario tiene GIMP 3.2.4 abierto en Windows con la imagen `gimp_v5_restoration_portrait.jpg` lista tras haber completado la fase de retoque manual (`Saneado` `H`, `Clonar` `C`, `Niveles` y `Curvas`).
* **Objetivo de Antigravity:** 
  1. Verificar o instalar la infraestructura MCP de GIMP 3.2.4 en Windows.
  2. Ejecutar la **Restauración por IA Open Source (Inpainting)** y la **Colorización Inteligente** sobre la foto activa.
  3. Inyectar las dos capas resultantes (`"Capa Restaurada IA OpenSource"` y `"Capa Color IA OpenSource"`) directamente en la sesión activa de GIMP 3.2.4 sin destruir la capa original.

---

## 🛠️ 2. CHECKLIST DE VERIFICACIÓN DE REQUISITOS Y DEPENDENCIAS (WINDOWS)

Antigravity debe ejecutar la siguiente verificación en el terminal de Windows antes de lanzar las herramientas:

### A. Dependencias de Python en Windows
Asegurar que el entorno de Python 3 en Windows tiene instaladas las librerías necesarias:
```bash
pip install rembg opencv-python-headless pillow onnxruntime
```

### B. Ubicación del Plugin Puente de GIMP (`gimp_mcp_bridge.py`)
El plugin puente debe estar ubicado en la ruta de plugins de GIMP 3.0 en Windows:
* **Ruta de destino:** `%APPDATA%\GIMP\3.0\plug-ins\gimp_mcp_bridge\gimp_mcp_bridge.py`
* **Puerto TCP:** El plugin abre y escucha en el puerto local `9877`.

Si no existe la carpeta, se debe crear e incluir el archivo `gimp_mcp_bridge.py` con permisos de ejecución.

### C. Registro en `mcp_config.json` de Antigravity
Verificar que el archivo `mcp_config.json` de Antigravity en Windows incluye el servidor MCP de GIMP:

```json
{
  "mcpServers": {
    "gimp": {
      "command": "python",
      "args": ["C:/Ruta/A/Tu/Proyecto/Gimp/server/mcp_server.py"]
    }
  }
}
```

---

## ⚙️ 3. IMPLEMENTACIÓN TÉCNICA DE LAS HERRAMIENTAS MCP (GIMP SERVER)

El servidor MCP (`mcp_server.py`) expone las siguientes funciones clave que Antigravity utilizará:

### 1. `ai_open_source_restore(image_path)`
* **Mecanismo:** Utiliza la librería Open Source `cv2.inpaint` (OpenCV) en Python local para detectar de forma adaptativa grietas y micro-arañazos en la imagen `image_path` y generar la imagen limpia `_restored_os.png`.
* **Acción en GIMP 3.2.4:** Envía la orden Python-Fu vía el socket TCP `9877` para cargar e inyectar `_restored_os.png` como una capa no destructiva llamada **`Capa Restaurada IA OpenSource`**.

### 2. `ai_open_source_colorize(image_path)`
* **Mecanismo:** Procesa el mapa de color de la imagen en blanco y negro mediante algoritmos abiertos de colorización en Python local y genera la imagen `_colorized_os.png`.
* **Acción en GIMP 3.2.4:** Envía la orden Python-Fu vía socket TCP `9877` para cargar e inyectar la capa **`Capa Color IA OpenSource`** arriba en la lista de capas de GIMP 3.2.4.

---

## 📋 4. INSTRUCCIONES PASO A PASO PARA EL AGENTE ANTIGRAVITY EN WINDOWS

Cuando el usuario te indique en Windows: *"Antigravity, ejecuta la restauración e inpainting Open Source y el coloreado en GIMP"*, debes seguir este orden exacto:

1. **Paso 1 (Comprobación de Sockets):**  
   Verificar si GIMP 3.2.4 está abierto y respondiendo en el puerto `127.0.0.1:9877`. Si no responde, lanzar GIMP o el plugin puente.
2. **Paso 2 (Ejecución de Inpainting):**  
   Lanzar la herramienta `ai_open_source_restore` apuntando a la ruta de la imagen activa en Windows.
3. **Paso 3 (Inyección de Capa de Restauración):**  
   Confirmar que la nueva capa `"Capa Restaurada IA OpenSource"` ha sido añadida en el panel de Capas de GIMP 3.2.4.
4. **Paso 4 (Ejecución de Coloreado):**  
   Lanzar la herramienta `ai_open_source_colorize` apuntando a la imagen.
5. **Paso 5 (Inyección de Capa de Color y Modos de Fusión):**  
   Confirmar la inyección de la capa `"Capa Color IA OpenSource"`. Informar al usuario en Windows de que debe ajustar el **Modo de Fusión** de esta capa a **`Color`** (o **`Color LCH`**) y la **Opacidad** al **85%** dentro de GIMP 3.2.4.

---

## 🎨 5. NORMAS DE NOMENCLATURA Y AUDITORÍA GIMP 3.2.4 EN ESPAÑOL

Al comunicarte con el usuario en Windows durante las explicaciones del tutorial, recuerda usar **siempre** los términos auditados oficiales de GIMP 3.2.4 en español:

* **Sombra suave:** `Filtros` ➔ `Luz y sombra` ➔ **`Sombra paralela...`**
* **Herramienta Saneado:** **`Saneado`** (`H`)
* **Herramienta Clonar:** **`Clonar`** (`C`)
* **Herramienta Texto:** **`Texto`** (`T`)
* **Herramienta Alinear:** **`Alinear`** (`Q`), opción *Relativo a: Imagen*
* **Ajustes de color:** `Colores` ➔ **`Niveles...`**, `Colores` ➔ **`Curvas...`**
* **Modo de fusión:** **`Color`** o **`Color LCH`**
* **Atajos Windows:** Usar `Ctrl` y `Shift` (ej. `Ctrl + S` para guardar `.xcf`, `Shift + Ctrl + E` para exportar `.jpg`).

---

*Documento técnico preparado para la sesión de Antigravity en Windows.*
