# Directrices del Proyecto SearchMCP

## Uso Obligatorio del Servidor MCP de O'Reilly
Este espacio de trabajo está configurado para consultar la biblioteca y los recursos técnicos de **O'Reilly Learning** mediante su servidor MCP oficial (`oreilly`).

### Instrucciones para el Agente:
- **Herramienta Obligatoria:** Ante cualquier petición de investigación, aprendizaje, libros, conferencias o tutoriales sobre tecnologías (como WGSL, WebGPU, WebAssembly, Inteligencia Artificial, Sistemas Operativos en el Navegador, etc.), debes invocar la herramienta lazy `search_oreilly_content` del servidor MCP `oreilly` mediante `call_mcp_tool`.
- **Habilidad de Proyecto Asociada:** Consulta y aplica estrictamente la habilidad `.agents/skills/oreilly-mcp-search/SKILL.md`.
- **Autorización:** La conexión remota MCP (`mcp-remote`) gestiona la autenticación del usuario mediante ventana del navegador. Si la sesión requiere refresco, el agente debe invocar la herramienta y procesar los resultados directamente.
- **Enlaces Clicables:** Siempre proporciona enlaces Markdown clicables con los `url` oficiales devueltos por el MCP (manteniendo `?orm_source=mcp`).
- **Citas de Autoridad en el Texto:** En cada capítulo o entrega técnica, es obligatorio enriquecer las explicaciones con citas, analogías y principios de diseño formulados por autores canónicos y expertos reconocidos en la industria (ej. Patterson & Hennessy, Brian Sletten, Addy Osmani, Danilo Chiarlone, etc.).
- **Sección Final de Bibliografía para Profundizar:** Todo capítulo debe culminar con un apartado formal de *Bibliografía y Lecturas Recomendadas para Profundizar*, listando las obras consultadas en O'Reilly con su ficha bibliográfica completa, justificación de lectura y enlace directo.

## Adaptación Fonética Obligatoria para Locuciones de ElevenLabs

Al redactar, generar o modificar cualquier guion narrativo, texto de locución o versión de solo texto para voz en off destinada a **ElevenLabs** (archivos como `locucion_elevenlabs_...`, `guion_narrativo_...` o entregas de texto para lectura):

1. **Aplicación Obligatoria del Diccionario de Términos:**
   Es preceptivo sustituir en el texto de lectura aquellas siglas, acrónimos o términos técnicos que ElevenLabs no pronuncia adecuadamente por defecto en español, de acuerdo con el diccionario del proyecto:
   - **`WGSL` / `wgsl`** $\rightarrow$ sustituir siempre por **`uve doble ge ese ele`**
   - **`C++` / `c++`** $\rightarrow$ sustituir siempre por **`C plus plus`**
   - **`W3C` / `w3c`** $\rightarrow$ sustituir siempre por **`uve doble tres ce`**
   - **`Y` / `y` (variable matemática, eje o coordenada espacial)** $\rightarrow$ sustituir siempre por **`ye`** (ej. "eje ye", "coordenada ye", "ye más uno", "ye multiplicado por el ancho", "equis y ye", "bits de ye", para evitar que ElevenLabs lo pronuncie como conjunción "i" y garantizar la pronunciación canónica aceptada por la RAE).
   - **Conjunción copulativa previa obligatoria (`y ye`, NUNCA `e ye`):** Cuando la letra o coordenada `ye` vaya precedida por la conjunción copulativa, esta debe ser SIEMPRE **`y`** (con su sonido vocálico /i/) y **NUNCA `e`**. De acuerdo con la norma canónica de la Real Academia Española (RAE), al tener la palabra un sonido inicial consonántico (/ʝe/), no se produce cacofonía y la conjunción copulativa no transmuta en *e*: debe escribirse y pronunciarse siempre **`equis y ye`** o **`y ye`** (sonando /i/ /ʝe/). Queda **terminantemente prohibido** escribir *"equis e ye"*, *"e ye"* o *"e Ye"*. Asimismo, la conjunción copulativa previa conserva siempre su fonética vocálica /i/ y jamás se transforma en *ye* (evitando incorrecciones como *"ye ye"*).
   - **Pronunciación Decimal en Programación (`punto`, NUNCA `coma`):** Los valores y literales numéricos decimales en contextos técnicos, matemáticos de computación y de programación (como `0.5`, `1.0`, `0.25`, `0.75`, offsets de muestreo o flotantes de sombreado) se transcriben y pronuncian siempre con la palabra **`punto`** (ej. *"cero punto cinco"*, *"uno punto cero"*), y **NUNCA** con *"coma"*. En programación y en lenguajes de sombreado (WGSL, GLSL, C++, JS), la coma es estrictamente el separador de parámetros y de elementos de vectores (`vec2(x, y)`), mientras que el punto es el único separador decimal válido. Emplear *"cero punto cinco"* evoca directamente el literal de código flotante `0.5`, previene confusiones sintácticas al oído y coincide con la convención natural de los ingenieros de software en español.

2. **Formato y Limpieza del Texto de Lectura:**
   - Debe ser texto continuo de lectura fluida y natural en español, sin artefactos markdown que la voz sintetice erróneamente (sin viñetas `*` o `-`, sin encabezados `#`, sin comillas invertidas de código ``, y sin corchetes de tiempo en la versión de solo locución).
   - Los términos de código se adaptan a su lectura hablada (ej. `var workgroup`, `efe treinta y dos` para `f32`, `vec cuatro` para `vec4`, `S-RAM`, `D-RAM`, `V-RAM`, etc.).
   - Se debe mantener sincronizado `tutorial_webgpu_wgsl/diccionario_elevenlabs.pls` con cualquier nuevo término incorporado.

## Directrices de Estilo Narrativo y Redacción Técnica

### Erradicación de la Muletilla "El Famoso..." y Variedad Léxica
- **Prohibición de Repetición:** Queda prohibido recurrir de forma sistemática, refleja o automática a la muletilla *"el famoso / la famosa"* al introducir conceptos, errores, algoritmos, leyes o hitos técnicos (ej. *"el famoso baile de texturas"*, *"el famoso Tiled GEMM"*, *"la famosa ley de Amdahl"*). Aunque en ocasiones muy aisladas pueda ser admisible, su uso reiterado empobrece la prosa y genera una sensación mecánica y repetitiva.
- **Opción Preferente (Mención Directa sin Definidor):** En la inmensa mayoría de los casos, la redacción resulta mucho más sobria, elegante y rigurosa suprimiendo cualquier definidor innecesario y nombrando directamente el concepto:
  - *Evitar:* *"El resultado fue el famoso baile de texturas"* $\rightarrow$ *Preferir:* *"El resultado fue el baile de texturas"* o *"El resultado fue el error del baile de texturas"*.
  - *Evitar:* *"Llegamos al famoso algoritmo Tiled GEMM"* $\rightarrow$ *Preferir:* *"Llegamos a la técnica de Tiled GEMM"* o simplemente *"Llegamos a Tiled GEMM"*.
- **Alternativas Variadas (cuando sea oportuno introducir o cualificar el término):** Si por motivos narrativos o didácticos conviene enfatizar o introducir un concepto conocido, alternar de forma equilibrada y natural entre:
  - *"el llamado..."*
  - *"el conocido como..."*
  - *"el conocido..."*
  - *"el denominado..."*
  - *"aquel fenómeno conocido como..."*
  - *"la técnica denominada..."*
- **Revisión Obligatoria:** En cada entrega de guion, texto didáctico, locución o capítulo técnico, auditar el texto para asegurar que no se concentren muletillas definitorias y que impere la variedad léxica y la precisión expositiva.
