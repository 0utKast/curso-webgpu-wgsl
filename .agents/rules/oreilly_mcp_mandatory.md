# Regla de Proyecto: Uso Obligatorio del Servidor MCP de O'Reilly

## Preámbulo de Obligado Cumplimiento en el Proyecto SearchMCP
Este repositorio (`/Volumes/MisAppsV/SearchMCP`) fue concebido e implementado específicamente para interactuar de forma nativa con el catálogo y los recursos de **O'Reilly Learning** mediante el protocolo **Model Context Protocol (MCP)**.

### Directrices Obligatorias para el Agente:
1. **Prioridad Absoluta de MCP O'Reilly:** Ante cualquier consulta técnica, solicitud de investigación bibliográfica, arquitectura de software, aprendizaje de lenguajes (como WGSL, Rust, C++, Python) o desarrollo de tutoriales, el agente **DEBE recurrir en primera instancia y sin excepción** a la herramienta `search_oreilly_content` del servidor MCP `oreilly`.
2. **Prohibición de Omisión de MCP:** Está estrictamente prohibido responder alegando falta de acceso, recurrir a scraping de páginas web públicas de O'Reilly o sustituir la biblioteca de O'Reilly por búsquedas web genéricas sin haber ejecutado antes `search_oreilly_content`.
3. **Flujo de Autorización:** El agente comprende que la conexión se realiza a través del endpoint remoto `https://api.oreilly.com/api/content-discovery/v1/mcp/` mediante `mcp-remote`. Si la sesión requiere autorización, el cliente MCP despliega una ventana de navegador para que el usuario valide el acceso con su suscripción activa. El agente debe ejecutar el comando y esperar la respuesta con normalidad.
4. **Citas y Enlaces Clicables:** Siempre que se presenten resultados de O'Reilly, deben incluirse los enlaces clicables en formato Markdown (`[Título](url)`), conservando el parámetro de trazabilidad `?orm_source=mcp`.
5. **Citas de Autoridad en el Cuerpo del Texto:** Cada capítulo debe fundamentarse en axiomas, analogías y citas directas de autores reconocidos de O'Reilly para anclar los conceptos técnicos en la literatura canónica.
6. **Sección Final Obligatoria de Bibliografía:** Al final de cada capítulo, se debe incluir una sección titulada `## Bibliografía y Lecturas Recomendadas para Profundizar`, detallando título, autor, editorial, año, relevancia práctica y enlace a la plataforma O'Reilly.
