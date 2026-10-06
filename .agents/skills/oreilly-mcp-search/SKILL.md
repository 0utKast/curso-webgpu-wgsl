---
name: oreilly-mcp-search
description: Consulta obligatoria del catálogo técnico oficial de O'Reilly Learning mediante el servidor MCP 'oreilly' (herramienta 'search_oreilly_content') para este proyecto. Usar siempre que se requiera investigar libros, vídeos, conferencias, arquitecturas o guías técnicas.
---

# Habilidad: Búsqueda de Contenidos Técnicos en O'Reilly vía MCP

## 1. Propósito y Carácter Obligatorio
Esta habilidad es de **uso obligatorio y prioritario** en el proyecto `SearchMCP` (/Volumes/MisAppsV/SearchMCP) ante cualquier solicitud de investigación, estado del arte, arquitectura técnica, bibliografía o planificación de tutoriales.

Queda terminantemente prohibido recurrir a búsquedas web genéricas o scraping externo para temas técnicos sin haber consultado previamente el servidor MCP oficial de O'Reilly configurado en el proyecto.

---

## 2. Arquitectura de Conexión MCP en el Proyecto
El proyecto cuenta con la definición formal del servidor MCP en `.agents/mcp_config.json`:

```json
{
  "mcpServers": {
    "oreilly": {
      "command": "npx",
      "args": [
        "-y",
        "mcp-remote",
        "https://api.oreilly.com/api/search/v1/mcp"
      ]
    }
  }
}
```

- **Servidor MCP:** `oreilly`
- **Herramienta principal:** `search_oreilly_content` (registrada como lazy MCP tool en Antigravity).
- **Flujo de Autorización OAuth:** Cuando se invoca esta herramienta por primera vez o tras expirar la sesión, el cliente `mcp-remote` abre automáticamente una ventana en el navegador web predeterminado del usuario para que conceda el permiso con su suscripción activa. El agente debe esperar la respuesta del tool call sin abortar ni saltar a búsquedas web.

---

## 3. Protocolo de Ejecución: `call_mcp_tool`

Para realizar consultas a la biblioteca de O'Reilly, el agente debe invocar la herramienta `call_mcp_tool` con los siguientes parámetros:

```json
{
  "ServerName": "oreilly",
  "ToolName": "search_oreilly_content",
  "Arguments": {
    "query": "palabras clave descriptivas",
    "n_items": 10,
    "content_types": ["books", "videos", "courses", "live-events"],
    "order_by": "date_published",
    "sort_order": "desc"
  }
}
```

### Reglas de Uso de Parámetros:
1. **`query`:** Utilizar términos técnicos precisos (conceptos, tecnologías, frameworks). Evitar preguntas en lenguaje natural ("¿cómo hacer X?"), usando en su lugar frases nominales o palabras clave ("WebGPU compute shaders", "WebAssembly WASI", "WGSL").
2. **`content_types`:** Filtrar por tipos de contenido si aplica:
   - `books`: Libros técnicos completos (O'Reilly, Packt, Manning, Pearson, No Starch, Wiley, Apress).
   - `videos` / `courses`: Cursos estructurados en vídeo.
   - `live-events`: Talleres y eventos en directo con fechas específicas.
   - `interactive`: Laboratorios y escenarios interactivos.
3. **`order_by` / `sort_order`:** Para novedades y material más reciente, usar `order_by: "date_published"` y `sort_order: "desc"`. Para relevancia general, omitir o usar `relevance`.
4. **`publisher_filter` / `author_filter`:** Usar cuando el usuario busque autores concretos (ej. "Addy Osmani", "Danilo Chiarlone") o editoriales específicas (ej. "Manning Publications", "O'Reilly Media, Inc.").

---

## 4. Estándar de Salida y Referenciación
En cualquier informe, tutorial o propuesta generada a partir de los resultados de O'Reilly:
1. **Enlaces Clicables Obligatorios:** Cada obra, curso o evento citado debe contener su enlace Markdown exacto (`url` devuelto por el MCP, incluyendo el parámetro `?orm_source=mcp`).
2. **Ficha Bibliográfica Completa:** Citar siempre: Título, Autores, Editorial, Formato (`display_format`) y Fecha de publicación.
3. **Identificador Canónico (URN):** Referenciar el `ourn` o ISBN cuando se documenten fuentes para trazabilidad técnica.
