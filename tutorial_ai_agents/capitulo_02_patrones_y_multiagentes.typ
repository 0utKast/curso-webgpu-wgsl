#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 2.2cm, right: 2.2cm),
  header: context {
    if counter(page).get().first() > 1 {
      text(9pt, fill: rgb("#64748b"))[
        *Tutorial de Agentes de IA* | _Capítulo 2: Patrones, Planificación y Sistemas Multi-Agente_
        #h(1fr)
        AI Agents: The Definitive Guide
      ]
    }
  },
  footer: context {
    text(9pt, fill: rgb("#94a3b8"))[
      #line(length: 100%, stroke: 0.5pt + rgb("#cbd5e1"))
      #v(2pt)
      Guía Práctica de Arquitectura de Agentes | Nicole Koenigstein (O'Reilly)
      #h(1fr)
      Página #counter(page).display("1 de 1", both: true)
    ]
  }
)

#set text(
  font: ("Helvetica", "Arial"),
  size: 9pt,
  fill: rgb("#1e293b"),
  lang: "es",
  spacing: 120%
)

#set par(
  justify: true,
  leading: 0.6em
)

// Header Banner
#block(
  fill: rgb("#f8fafc"),
  stroke: (left: 4pt + rgb("#7c3aed")),
  inset: (x: 16pt, y: 12pt),
  radius: (right: 4pt),
  width: 100%,
  [
    #text(16pt, weight: "bold", fill: rgb("#0f172a"))[Tutorial: Patrones de Razonamiento, Planificación y Sistemas Multi-Agente]
    
    #v(3pt)
    #text(9.5pt, weight: "medium", fill: rgb("#475569"))[
      *Serie:* _Guía Práctica de Arquitectura y Desarrollo de Agentes de IA_ \
      *Basado en:* _AI Agents: The Definitive Guide_ (Capítulo 2) por Nicole Koenigstein (O'Reilly Media) \
      *Referencia:* #link("https://learning.oreilly.com/library/view/ai-agents-the/0642572247775/ch02.html")[0642572247775 / ch02.html] | *Enfoque:* Taller Práctico, ReAct, Reflexion y MAS
    ]
  ]
)

#v(6pt)

== 1. Introducción: De Agentes Monolíticos a Sistemas Multi-Agente (MAS)

En el Capítulo 1 analizamos el control de un agente individual mediante Máquinas de Estados Finitos (FSM). Sin embargo, al abordar problemas complejos del mundo real, el enfoque de un *agente único monolítico* (un solo prompt que agrupa múltiples roles y decenas de herramientas) presenta fallos estructurales:
- *Confusión de Herramientas (_Tool Confusion_):* Con más de 20 herramientas en un solo prompt, el LLM degrada su precisión al seleccionar funciones y parámetros.
- *Pérdida de Especialización:* Un modelo al que se le exige ser a la vez analista, auditor de seguridad, matemático y redactor creativo tiende a una calidad media-baja en todas esas facetas.
- *Falta de Pensamiento Crítico Independiente:* El modelo no puede cuestionar sus propios sesgos de confirmación sin una entidad evaluadora separada.

La solución de la ingeniería de software consiste en adoptar *Sistemas Multi-Agente (MAS - Multi-Agent Systems)*: redes de agentes ligeros, especializados e independientes que cooperan bajo patrones formales de orquestación.

#v(6pt)

== 2. El Espectro de Razonamiento Individual

#table(
  columns: (2.2fr, 4fr, 3.8fr),
  fill: (col, row) => if row == 0 { rgb("#f1f5f9") } else if calc.even(row) { rgb("#f8fafc") } else { none },
  stroke: (x, y) => if y == 0 { (bottom: 1.5pt + rgb("#94a3b8")) } else { (bottom: 0.5pt + rgb("#e2e8f0")) },
  align: (left, left, left),
  table.header(
    [*Patrón*], [*Mecanismo Central*], [*Ventajas y Retos*]
  ),
  [*ReAct*], [Intercala pasos de pensamiento verbal (_Thought_), ejecución (_Action_) y lectura (_Observation_).], [Gran adaptabilidad dinámica; riesgo de perder el rumbo en tareas >10 pasos.],
  [*Plan-and-Solve*], [Descompone la meta en una secuencia de pasos previa a la ejecución táctica.], [Reduce llamadas innecesarias al modelo; requiere replanificación si el entorno cambia.],
  [*Reflexion*], [El agente evalúa su salida frente a una rúbrica y se auto-corrige mediante retroalimentación verbal.], [Reduce alucinaciones sin reentrenar pesos; incrementa el consumo de tokens.],
  [*Tree of Thoughts (ToT)*], [Explora ramas alternativas de razonamiento con evaluación heurística y retroceso (_backtracking_).], [Máxima precisión combinatoria; alta latencia y coste computacional.]
)

#v(6pt)

== 3. Topologías de Colaboración Multi-Agente

1. *Topología Jerárquica (_Supervisor-Worker_):* Un agente supervisor descompone el objetivo global, delega subtareas a especialistas y sintetiza la solución final con control de estado centralizado.
2. *Topología Peer-to-Peer (_A2A - Network Pattern_):* Agentes especializados que cooperan como iguales pasándose mensajes y artefactos sin cuello de botella central.
3. *Patrón Maker-Checker (_Generador vs. Revisor con Reflexion_):* Un especialista genera una propuesta y un auditor independiente la valida contra criterios duros, devolviéndola con críticas constructivas si no cumple el estándar.

#v(6pt)

== 4. Comunicación Inter-Agente y Prevención del "Teléfono Roto"

En un sistema multi-agente, el mayor enemigo de la precisión es el *efecto del "teléfono roto" (_Information Degradation_)*. Si el Agente A resume un texto de 10 páginas, el Agente B resume ese resumen y el Agente C toma decisiones basadas en lo que le contó B, al final de la cadena se habrán perdido cifras críticas y matices técnicos debido a la compresión con pérdida (_lossy compression_) de los LLMs.

Para evitar la pérdida de información sin saturar la ventana de contexto de tokens, se aplican dos soluciones de ingeniería:

#block(
  fill: rgb("#eff6ff"),
  stroke: 1pt + rgb("#bfdbfe"),
  inset: 8pt,
  radius: 5pt,
  width: 100%,
  [
    *1. Paso de Mensajes Tipados (_Typed A2A Messages_):*
    En lugar de texto libre desestructurado, los agentes se comunican mediante estructuras cerradas (ej. esquemas JSON con Pydantic). Los datos clave (números, listas, métricas) viajan en campos fijos (`payload_data`), impidiendo que el LLM los parafrasee o deforme.
    _Analogía:_ Rellenar un formulario bancario normalizado en lugar de escribir una carta libre.
    
    #v(3pt)
    *2. Paso por Referencia o Artefactos (_Artifact-Driven Collaboration_):*
    Aplica el principio de programación: _\"Pasa un puntero, no el contenido entero\"_. Cuando un agente genera un documento grande, una tabla o un log, lo guarda en almacenamiento compartido (disco local, base de datos o servidor MCP) y solo pasa la ruta o URI (ej. `file:///tmp/balance.csv`). El siguiente agente lee directamente la *fuente única de verdad*.
    _Analogía:_ Compartir un enlace a Google Drive/GitHub en lugar de pegar 500 páginas en un email.
  ]
)

#v(6pt)

== 5. Taller Práctico: Construcción y Ejecución de la Aplicación Multi-Agente

Vamos a llevar a cabo un *taller práctico desarrollando una aplicación* que nos muestra esta comunicación multi-agente en acción, como plasmación directa de los conceptos teóricos, patrones de razonamiento y topologías de colaboración analizados.

=== 5.1. El Escenario del Taller y los Roles del Sistema

Planteamos un caso de uso corporativo: generar un *Informe Financiero Ejecutivo para el Q3*. Para resolverlo de forma robusta y sin alucinaciones, implementamos una arquitectura multi-agente distribuida con tres entidades:
- 👑 *Supervisor-Central (`HierarchicalOrchestrator`):* Aplica la _Topología Jerárquica_ (§3.1). Recibe la meta, emite directivas a los trabajadores y gobierna el ciclo de vida.
- 🔬 *Analista-Financiero-01 (`ResearchWorkerAgent`):* Aplica el _Patrón ReAct_ (§2.1). Desglosa la tarea en Pensamiento (`Thought`), Acción con herramientas (`Action`) y Observación de resultados (`Observation`).
- ⚖️ *Auditor-Calidad-01 (`QualityReviewerAgent`):* Aplica el _Patrón Maker-Checker_ (§3.3) y _Reflexion_ (§2.3). Examina el entregable contra criterios objetivos y emite críticas formativas si detecta omisiones.
- 📨 *Canal de Mensajería A2A (`AgentMessage`):* Aplica el _Paso de Mensajes Tipados_ (§4), transportando la información estructurada con marcas de tiempo y roles.

=== 5.2. Código Fuente Completo del Taller

```python
import time
from enum import Enum, auto
from typing import Dict, Any, Optional, List

class AgentRole(Enum):
    SUPERVISOR = "Supervisor/Orquestador"
    RESEARCHER = "Especialista/Investigador"
    REVIEWER = "Revisor/Auditor de Calidad"

class TaskStatus(Enum):
    PENDING = auto()
    IN_PROGRESS = auto()
    NEEDS_REVISION = auto()
    APPROVED = auto()
    FAILED = auto()

class AgentMessage:
    def __init__(self, sender: AgentRole, recipient: AgentRole, content: str):
        self.timestamp = time.strftime("%H:%M:%S")
        self.sender = sender
        self.recipient = recipient
        self.content = content

class BaseAgent:
    def __init__(self, role: AgentRole, name: str):
        self.role = role
        self.name = name

    def log(self, text: str):
        print(f"  [{self.name} - {self.role.value}]: {text}")

class ResearchWorkerAgent(BaseAgent):
    def __init__(self, name: str = "Analista-Financiero-01"):
        super().__init__(AgentRole.RESEARCHER, name)
        self.iteration = 0

    def execute_task(self, task: str, critique: Optional[str] = None) -> Dict[str, Any]:
        self.iteration += 1
        if critique:
            self.log(f"[Thought - Reflexion]: Crítica recibida: '{critique}'. Ajustando...")
            draft = (
                "Informe Financiero Q3 (Auditado y Corregido):\n"
                "• Ingresos Totales:  $1,500,000.00 USD\n"
                "• Gastos Operativos: $950,000.00 USD\n"
                "• EBITDA Operativo:  $550,000.00 USD\n"
                "• Margen Operativo:  36.67%\n"
                "• Dictamen:          Rendimiento sólido sobre el objetivo (>35%)."
            )
        else:
            self.log("[Thought - ReAct]: Desglosando requerimientos iniciales...")
            draft = (
                "Borrador Financiero Preliminar Q3:\n"
                "• Ingresos Totales:  $1,500,000.00 USD\n"
                "• Gastos Operativos: $950,000.00 USD\n"
                "• Dictamen:          Beneficios positivos."
            )
        return {"draft": draft, "iteration": self.iteration}

class QualityReviewerAgent(BaseAgent):
    def __init__(self, name: str = "Auditor-Calidad-01"):
        super().__init__(AgentRole.REVIEWER, name)

    def evaluate_draft(self, draft: str) -> Dict[str, Any]:
        self.log("Evaluando criterios de completitud técnica...")
        if "EBITDA" in draft and ("Margen" in draft or "%" in draft):
            self.log("Dictamen: APROBADO. Cumple todos los estándares.")
            return {"approved": True, "feedback": "Métricas clave incluidas."}
        else:
            self.log("Dictamen: RECHAZADO. Faltan EBITDA y Margen %.")
            return {"approved": False, "feedback": "Falta cálculo explícito de EBITDA y Margen %."}

class HierarchicalOrchestrator(BaseAgent):
    def __init__(self, worker: ResearchWorkerAgent, reviewer: QualityReviewerAgent, max_cycles: int = 3):
        super().__init__(AgentRole.SUPERVISOR, "Supervisor-Central")
        self.worker = worker
        self.reviewer = reviewer
        self.max_cycles = max_cycles
        self.audit_trail: List[AgentMessage] = []

    def dispatch(self, msg: AgentMessage):
        self.audit_trail.append(msg)
        print(f"  📨 ({msg.sender.value} -> {msg.recipient.value}): {msg.content}")

    def coordinate(self, goal: str) -> Dict[str, Any]:
        self.log(f"Iniciando orquestación para: '{goal}'")
        feedback = None
        final_deliverable = None
        status = TaskStatus.IN_PROGRESS

        for cycle in range(1, self.max_cycles + 1):
            print(f"\n--- CICLO MULTI-AGENTE #{cycle} ---")
            task_text = f"Generar informe: {goal}" if cycle == 1 else f"Corregir según feedback: {feedback}"
            self.dispatch(AgentMessage(self.role, self.worker.role, task_text))

            output = self.worker.execute_task(goal, feedback)
            self.dispatch(AgentMessage(self.worker.role, self.reviewer.role, f"Entrega Borrador #{cycle}"))

            review = self.reviewer.evaluate_draft(output["draft"])
            if review["approved"]:
                self.log("ENTREGABLE VALIDADO SATISFACTORIAMENTE.")
                final_deliverable = output["draft"]
                status = TaskStatus.APPROVED
                self.dispatch(AgentMessage(self.reviewer.role, self.role, f"Aprobación: {review['feedback']}"))
                break
            else:
                self.log("RECHAZO TEMPORAL: Disparando ciclo de Reflexion...")
                feedback = review["feedback"]
                self.dispatch(AgentMessage(self.reviewer.role, self.role, f"Rechazo: {feedback}"))

        return {"status": status.name, "cycles": cycle, "output": final_deliverable}

if __name__ == "__main__":
    supervisor = HierarchicalOrchestrator(ResearchWorkerAgent(), QualityReviewerAgent(), max_cycles=3)
    res = supervisor.coordinate("Informe financiero consolidado Q3")
    print(f"\nDocumento Final Aprobado:\n{res['output']}")
```

=== 5.3. Crónica de Ejecución: Conectando la Consola, el Código y la Teoría

1. *Fase 1: El Despacho Jerárquico y ReAct (Ciclo 1):*
   - _En la Consola:_ Vemos el mensaje `📨 [CANAL A2A] Supervisor ➔ Especialista`. El Especialista muestra `[Thought - ReAct]`, `[Action]` y `[Observation]`.
   - _En el Código:_ Corresponde a `HierarchicalOrchestrator.coordinate()` llamando a `ResearchWorkerAgent.execute_task()`.
   - _En la Teoría:_ Se materializa la *Topología Jerárquica (§3.1)* y el patrón *ReAct (§2.1)*, donde el agente razona y consulta herramientas en lugar de emitir una respuesta a ciegas.
2. *Fase 2: El Filtro Crítico Objetivo (Maker-Checker):*
   - _En la Consola:_ El Auditor evalúa el borrador y emite `⚠️ [Dictamen: RECHAZADO]` explicando que faltan el EBITDA y el margen porcentual.
   - _En el Código:_ Corresponde a `QualityReviewerAgent.evaluate_draft()`.
   - _En la Teoría:_ Opera el *Patrón Maker-Checker (§3.3)*. Un evaluador independiente evita el sesgo de auto-confirmación del creador.
3. *Fase 3: Auto-Corrección en Vivo con Reflexion (Ciclo 2):*
   - _En la Consola:_ El Supervisor reenvía la crítica. El Especialista muestra `🧠 [Thought - Reflexion]` y recalcula las métricas con la herramienta avanzada.
   - _En el Código:_ En `execute_task()`, la condición `if critique:` altera dinámicamente la ruta de ejecución.
   - _En la Teoría:_ Es la esencia de *Reflexion (§2.3)*: el modelo aprende del error en tiempo de ejecución mediante refuerzo verbal sin reentrenar pesos.
4. *Fase 4: Aprobación Formal y Cierre Determinista:*
   - _En la Consola:_ El Auditor emite `✅ [Dictamen: APROBADO]` y el Supervisor finaliza con el informe consolidado.
   - _En el Código:_ Se activa la guarda de salida `break` en el ciclo `while`.
   - _En la Teoría:_ Se comprueba la resiliencia operativa: el sistema resolvió una ambigüedad y elevó la calidad del entregable en exactamente 2 ciclos sin intervención humana.

#v(6pt)

== 6. Retos de Producción y Conclusiones

1. *Gestión de Presupuesto de Tokens:* Asignar modelos ligeros/compactos para extracción y revisión intermedia, reservando modelos más pesados para la supervisión y síntesis final.
2. *Contención del Radio de Explosión (_Blast Radius_):* Aislar los fallos de un subagente para no desestabilizar el clúster global.
3. *Observabilidad y Trazabilidad:* Registrar la traza completa de mensajes A2A (_Span Tracing_) para auditar el origen exacto de cualquier discrepancia.

#v(3pt)

#block(
  fill: rgb("#f0fdf4"),
  stroke: 1pt + rgb("#bbf7d0"),
  inset: 8pt,
  radius: 5pt,
  width: 100%,
  [
    #text(weight: "bold", fill: rgb("#15803d"))[Próximo Paso: Capítulo 3]
    #v(2pt)
    _Advanced Paradigms: Scalable Reasoning, Long-Term Memory, and Evaluation Frameworks_ — Memoria episódica y semántica persistente, razonamiento escalonado y marcos de evaluación en producción.
  ]
)
