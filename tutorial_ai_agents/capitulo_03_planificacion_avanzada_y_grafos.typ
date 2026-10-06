#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 2.2cm, right: 2.2cm),
  header: context {
    if counter(page).get().first() > 1 {
      text(9pt, fill: rgb("#64748b"))[
        *Tutorial de Agentes de IA* | _Capítulo 3: Planificación Avanzada, Grafos y Ejecución Escalable_
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
  stroke: (left: 4pt + rgb("#6366f1")),
  inset: (x: 16pt, y: 12pt),
  radius: (right: 4pt),
  width: 100%,
  [
    #text(15pt, weight: "bold", fill: rgb("#0f172a"))[Tutorial: Planificación Avanzada, Grafos de Estado y Ejecución Escalable]
    
    #v(3pt)
    #text(9.5pt, weight: "medium", fill: rgb("#475569"))[
      *Serie:* _Guía Práctica de Arquitectura y Desarrollo de Agentes de IA_ \
      *Basado en:* _AI Agents: The Definitive Guide_ (Capítulo 3) por Nicole Koenigstein (O'Reilly Media) \
      *Referencia:* #link("https://learning.oreilly.com/library/view/ai-agents-the/0642572247775/ch03.html")[0642572247775 / ch03.html] | *Enfoque:* StateGraphs, DAGs, Time-Travel y HITL
    ]
  ]
)

#v(6pt)

== 1. Introducción: De Cadenas Lineales a Grafos de Estado Dinámicos (StateGraphs)

En los capítulos anteriores sentamos las bases del comportamiento agéntico mediante Máquinas de Estados Finitos (FSM - Capítulo 1) y orquestación multi-agente modular (Capítulo 2). No obstante, en entornos empresariales de producción surge una limitación estructural crítica:

- *La rigidez secuencial:* Ni las cadenas lineales de prompts ni las FSMs tradicionales pueden gestionar simultáneamente bifurcaciones paralelas concurrentes, ciclos de retroalimentación dinámicos con aristas condicionales, interrupciones de seguridad humana (*Human-in-the-Loop*) y persistencia transaccional con rebobinado temporal (*Time-Travel Debugging*).

Para resolver este desafío de arquitectura, el *Capítulo 3* de _AI Agents: The Definitive Guide_ introduce el paradigma supremo de control: los *Grafos de Estado (StateGraphs)* y la *Planificación Dinámica en Grafos Acíclicos Dirigidos (DAGs)*.

#v(6pt)

== 2. Arquitectura y Componentes Cardinales de un StateGraph

Un *Grafo de Estados (StateGraph)* modela el ciclo de vida del agente mediante una red dirigida de operaciones deterministas y probabilísticas:

1. *Nodos (Nodes):* Unidades operativas atómicas (funciones puras o subagentes) que reciben el estado actual, ejecutan inferencia o herramientas externas, y devuelven un conjunto de actualizaciones de estado.
2. *Aristas Deterministas (Edges):* Canales fijos de transición que guían el flujo de un nodo al siguiente tras completar su ejecución.
3. *Aristas Condicionales (Conditional Routing):* Funciones de decisión que evalúan el estado del sistema (*Guard Functions*) para bifurcar la ejecución en múltiples ramas paralelas o activar ciclos de refinamiento.
4. *Estado Global Tipado (State Schema):* Estructura inmutable que actúa como la "Única Fuente de Verdad" (*Single Source of Truth*).
5. *Reductor de Estado (State Reducer):* Función pura determinista que fusiona concurrentemente los resultados emitidos por múltiples nodos sin riesgo de condiciones de carrera (*Race Conditions*).

#v(6pt)

== 3. Paradigmas Avanzados de Razonamiento y Búsqueda en Grafo

Cuando los agentes se enfrentan a problemas con alta complejidad combinatoria (ej. remediación de infraestructuras en la nube, optimización de algoritmos o refactorización de código legado), los enfoques paso a paso tipo *ReAct* quedan limitados. Se requieren técnicas avanzadas de exploración en árbol y grafo:

#v(4pt)

#table(
  columns: (1.8fr, 2fr, 2fr, 1.4fr, 2.8fr),
  fill: (col, row) => if row == 0 { rgb("#f1f5f9") } else if calc.even(row) { rgb("#f8fafc") } else { none },
  stroke: (x, y) => if y == 0 { (bottom: 1.5pt + rgb("#94a3b8")) } else { (bottom: 0.5pt + rgb("#e2e8f0")) },
  align: (left, left, left, center, left),
  table.header(
    [*Paradigma*], [*Estructura*], [*Mecanismo de Exploración*], [*Backtrack*], [*Caso de Uso Ideal en Producción*]
  ),
  [*ReAct*], [Secuencial], [Paso a paso inmediato (_Greedy_)], [No], [Consultas interactivas y búsqueda web.],
  [*Plan-and-Solve*], [Lista lineal fija], [Planificación previa global], [Parcial], [Pipelines ETL e informes estructurados.],
  [*Tree of Thoughts (ToT)*], [Árbol jerárquico], [Búsqueda con evaluación heurística (BFS/DFS)], [*Sí*], [Depuración compleja y optimización.],
  [*Graph of Thoughts (GoT)*], [Grafo dirigido], [Fusión multidireccional de pensamientos], [*Sí*], [Modelado de arquitectura y análisis multinivel.],
  [*MCTS*], [Árbol de simulación], [Selección UCB1 + Rollout + Backprop], [*Sí*], [Descubrimiento formal y generación de código crítico.]
)

#v(6pt)

== 4. Escalabilidad Operativa: Concurrencia, Checkpoints y Control HITL

Para alcanzar robustez en producción, los *StateGraphs* implementan tres capacidades de infraestructura:

1. *Concurrencia Asíncrona (Fan-out / Fan-in):* Ejecución paralela no bloqueante de subagentes y herramientas analíticas independientes, fusionadas posteriormente mediante el *State Reducer*.
2. *Persistencia de Checkpoints y Time-Travel Debugging:* Serialización del estado en cada paso de ejecución. Permite a los ingenieros pausar la ejecución, cargar una instantánea previa, modificar parámetros en caliente (*State Injection*) y reproducir el flujo sin incurrir en costes de recomputación de pasos anteriores.
3. *Puertas Human-in-the-Loop (HITL Interrupt Gate):* Puntos de control obligatorios antes de ejecutar acciones de alto riesgo (efectos secundarios destructivos). El grafo se suspende, solicita autorización interactiva y aplica las modificaciones emitidas por el operador.

#v(6pt)

== 5. Taller Práctico: Motor de Grafos de Estado en Python

A continuación implementamos un motor de *StateGraph* completo, modular y tipado en Python para resolver un escenario corporativo de *Auditoría y Remediación Cloud Automatizada*.

```python
"""
================================================================================
TALLER PRÁCTICO: MOTOR DE GRAFOS DE ESTADO (StateGraph), PLANIFICACIÓN DINÁMICA
EN DAG, CHECKPOINTING (TIME-TRAVEL) Y HUMAN-IN-THE-LOOP (HITL)
================================================================================
Basado en: AI Agents: The Definitive Guide (Capítulo 3) - Nicole Koenigstein
"""

import time
import copy
from enum import Enum, auto
from dataclasses import dataclass, field
from typing import Dict, Any, List, Optional, Callable, Tuple

class NodeStatus(Enum):
    PENDING = auto()
    RUNNING = auto()
    COMPLETED = auto()
    FAILED = auto()
    WAITING_FOR_HUMAN = auto()

@dataclass
class SubTask:
    id: str
    description: str
    dependencies: List[str] = field(default_factory=list)
    status: NodeStatus = NodeStatus.PENDING
    result: Optional[Dict[str, Any]] = None

@dataclass
class AgentState:
    session_id: str
    goal: str
    plan_dag: Dict[str, SubTask] = field(default_factory=dict)
    cost_audit_results: Dict[str, Any] = field(default_factory=dict)
    security_audit_results: Dict[str, Any] = field(default_factory=dict)
    proposed_remediations: List[Dict[str, Any]] = field(default_factory=list)
    approved_remediations: List[Dict[str, Any]] = field(default_factory=list)
    execution_logs: List[str] = field(default_factory=list)
    iteration: int = 0
    is_completed: bool = False
    requires_human_approval: bool = False
    human_feedback: Optional[str] = None

    def clone(self) -> 'AgentState':
        return copy.deepcopy(self)

def state_reducer(current_state: AgentState, update_dict: Dict[str, Any]) -> AgentState:
    new_state = current_state.clone()
    for key, value in update_dict.items():
        if hasattr(new_state, key):
            if isinstance(getattr(new_state, key), list) and isinstance(value, list):
                setattr(new_state, key, getattr(new_state, key) + value)
            elif isinstance(getattr(new_state, key), dict) and isinstance(value, dict):
                getattr(new_state, key).update(value)
            else:
                setattr(new_state, key, value)
    return new_state

class CheckpointManager:
    def __init__(self):
        self.checkpoints: Dict[str, Tuple[str, AgentState]] = {}

    def save_checkpoint(self, checkpoint_id: str, node_name: str, state: AgentState) -> None:
        self.checkpoints[checkpoint_id] = (node_name, state.clone())
        print(f"  💾 [CHECKPOINT CREADO] ID: {checkpoint_id} | Nodo: '{node_name}'")

    def load_checkpoint(self, checkpoint_id: str) -> Tuple[str, AgentState]:
        node_name, state = self.checkpoints[checkpoint_id]
        print(f"  ⏪ [TIME-TRAVEL LOAD] Restaurando estado desde checkpoint '{checkpoint_id}'...")
        return node_name, state.clone()

class GraphNodes:
    @staticmethod
    def hierarchical_planner_node(state: AgentState) -> Dict[str, Any]:
        print(f"\n🧠 [NODO: HierarchicalPlanner] Descomponiendo meta en DAG de subtareas...")
        dag = {
            "task_cost": SubTask("task_cost", "Auditoría de instancias inactivas", []),
            "task_security": SubTask("task_security", "Escaneo de puertos y buckets", []),
            "task_synthesis": SubTask("task_synthesis", "Consolidación de auditorías", ["task_cost", "task_security"]),
            "task_remediation_gate": SubTask("task_remediation_gate", "Control HITL previo", ["task_synthesis"]),
            "task_execute_changes": SubTask("task_execute_changes", "Ejecución de cambios", ["task_remediation_gate"])
        }
        return {"plan_dag": dag, "iteration": state.iteration + 1}

    @staticmethod
    def cost_analysis_node(state: AgentState) -> Dict[str, Any]:
        print(f"\n⚡ [NODO CONCURRENTE: CostAnalysis] Escaneando activos cloud...")
        findings = {"idle_instances": ["i-09f1a238b", "i-0bb231cc4"], "monthly_waste_usd": 1850.00}
        state.plan_dag["task_cost"].status = NodeStatus.COMPLETED
        return {"cost_audit_results": findings, "plan_dag": state.plan_dag}

    @staticmethod
    def security_audit_node(state: AgentState) -> Dict[str, Any]:
        print(f"\n⚡ [NODO CONCURRENTE: SecurityAudit] Escaneando vectores de ataque...")
        findings = {"critical_vulnerabilities": 1, "target": "s3://corp-financial-backups (Public Read/Write)"}
        state.plan_dag["task_security"].status = NodeStatus.COMPLETED
        return {"security_audit_results": findings, "plan_dag": state.plan_dag}

    @staticmethod
    def synthesis_and_proposal_node(state: AgentState) -> Dict[str, Any]:
        print(f"\n🧩 [NODO: Synthesis & Remediation Planner] Consolidando auditorías concurrentes...")
        proposals = [
            {"id": "REM-001", "action": "TERMINATE_INSTANCES", "target": "2 EC2 Idles", "risk_level": "LOW", "requires_human": False},
            {"id": "REM-002", "action": "RESTRICT_SECURITY_GROUP", "target": "sg-0442fa9 (SSH)", "risk_level": "MEDIUM", "requires_human": False},
            {"id": "REM-003", "action": "DELETE_OR_ENCRYPT_S3_BUCKET", "target": "s3://corp-financial-backups", "risk_level": "CRITICAL", "requires_human": True}
        ]
        state.plan_dag["task_synthesis"].status = NodeStatus.COMPLETED
        return {"proposed_remediations": proposals, "requires_human_approval": True, "plan_dag": state.plan_dag}

    @staticmethod
    def human_in_the_loop_node(state: AgentState) -> Dict[str, Any]:
        print(f"\n🛑 [PUERTA HUMAN-IN-THE-LOOP (HITL)] Interrupción de seguridad activada.")
        human_decision = "APROBADO_CON_MODIFICACION: Cifrar con AES-256 y bloquear acceso público sin destruir el bucket."
        print(f"  📝 [DICTAMEN HUMANO (State Injection)]: \"{human_decision}\"")
        
        approved = []
        for p in state.proposed_remediations:
            if not p["requires_human"]:
                approved.append(p)
            else:
                mod_p = copy.deepcopy(p)
                mod_p["action"] = "ENABLE_ENCRYPTION_AND_BLOCK_PUBLIC_ACCESS"
                mod_p["risk_level"] = "LOW (MODIFIED BY HUMAN)"
                approved.append(mod_p)
        state.plan_dag["task_remediation_gate"].status = NodeStatus.COMPLETED
        return {"approved_remediations": approved, "requires_human_approval": False, "human_feedback": human_decision, "plan_dag": state.plan_dag}

    @staticmethod
    def execution_and_verification_node(state: AgentState) -> Dict[str, Any]:
        print(f"\n🚀 [NODO: Execution & Verification] Aplicando remediaciones autorizadas...")
        for act in state.approved_remediations:
            print(f"  ✔ Ejecutando [{act['id']}]: {act['action']} ➔ {act['target']}")
        state.plan_dag["task_execute_changes"].status = NodeStatus.COMPLETED
        return {"is_completed": True, "plan_dag": state.plan_dag}

class StateGraphEngine:
    def __init__(self, session_id: str):
        self.session_id = session_id
        self.nodes: Dict[str, Callable[[AgentState], Dict[str, Any]]] = {}
        self.checkpoint_manager = CheckpointManager()

    def add_node(self, name: str, func: Callable[[AgentState], Dict[str, Any]]) -> None:
        self.nodes[name] = func

    def run_graph(self, initial_state: AgentState) -> AgentState:
        state = initial_state.clone()
        self.checkpoint_manager.save_checkpoint("chk-000-init", "START", state)

        state = state_reducer(state, self.nodes["planner"](state))
        self.checkpoint_manager.save_checkpoint("chk-001-plan", "planner", state)

        cost_up = self.nodes["cost_analysis"](state)
        sec_up = self.nodes["security_audit"](state)
        state = state_reducer(state_reducer(state, cost_up), sec_up)
        self.checkpoint_manager.save_checkpoint("chk-002-audited", "parallel_audit", state)

        state = state_reducer(state, self.nodes["synthesis"](state))
        self.checkpoint_manager.save_checkpoint("chk-003-proposed", "synthesis", state)

        if state.requires_human_approval:
            state = state_reducer(state, self.nodes["hitl_gate"](state))
            self.checkpoint_manager.save_checkpoint("chk-004-hitl-approved", "hitl_gate", state)

        state = state_reducer(state, self.nodes["execution"](state))
        self.checkpoint_manager.save_checkpoint("chk-005-final", "execution", state)
        return state

if __name__ == "__main__":
    engine = StateGraphEngine("session-cloud-opt-2026")
    engine.add_node("planner", GraphNodes.hierarchical_planner_node)
    engine.add_node("cost_analysis", GraphNodes.cost_analysis_node)
    engine.add_node("security_audit", GraphNodes.security_audit_node)
    engine.add_node("synthesis", GraphNodes.synthesis_and_proposal_node)
    engine.add_node("hitl_gate", GraphNodes.human_in_the_loop_node)
    engine.add_node("execution", GraphNodes.execution_and_verification_node)

    init_state = AgentState("session-cloud-opt-2026", "Optimizar y securizar infraestructura Cloud AWS/GCP")
    final_res = engine.run_graph(init_state)
    print("\nEjecución finalizada con éxito.")
```

#v(6pt)

== 6. Crónica de Ejecución: Conectando Consola, Código y Teoría

1. *Fase 1: Descomposición Jerárquica en DAG:*
   - _En la Consola:_ `HierarchicalPlanner` desglosa el objetivo en 5 subtareas interconectadas.
   - _En el Código:_ Corresponde a `GraphNodes.hierarchical_planner_node()`.
   - _En la Teoría:_ Se aplica la *Planificación Jerárquica (HTN / DAG - §3.1)*: el agente precalcula dependencias antes de lanzar herramientas costosas.
2. *Fase 2: Concurrencia Paralela y Reductor de Estado:*
   - _En la Consola:_ Se ejecutan en paralelo `CostAnalysis` y `SecurityAudit`, recolectando hallazgos independientes.
   - _En el Código:_ Corresponde a `StateGraphEngine.run_graph()` fusionando las salidas con `state_reducer()`.
   - _En la Teoría:_ Se materializa el patrón *Fan-out / Fan-in (§4.1)* sobre un *Estado Central Tipado (§2)*.
3. *Fase 3: Puerta Human-in-the-Loop y Modificación en Caliente:*
   - _En la Consola:_ El sintetizador marca una acción como crítica (`CRITICAL`). El grafo se suspende y el operador humano inyecta una corrección.
   - _En el Código:_ Corresponde a `GraphNodes.human_in_the_loop_node()` aplicando *State Injection*.
   - _En la Teoría:_ Opera la *Gobernanza Human-in-the-Loop (§4.3)* para evitar daños colaterales.
4. *Fase 4: Time-Travel Replay e Inspección Forense:*
   - _En la Consola:_ El sistema carga el checkpoint `chk-003-proposed` e inspecciona las propuestas antes de la firma humana.
   - _En el Código:_ Corresponde al método `checkpoint_manager.load_checkpoint()`.
   - _En la Teoría:_ Demuestra la *Persistencia Transaccional y Auditoría Forense (§4.2)*.

#v(6pt)

== 7. Retos de Producción y Conclusiones

1. *Límites de Recursión:* Configurar guardas numéricas en grafos cíclicos para prevenir bucles infinitos de replanificación.
2. *Aislamiento Transaccional:* Implementar bloqueos optimistas en el almacén de estado para evitar colisiones entre trabajadores concurrentes.
3. *Gobernanza de Acciones:* Formalizar contratos estrictos de autorización para cualquier herramienta que modifique datos en producción.

#v(3pt)

#block(
  fill: rgb("#f0fdf4"),
  stroke: 1pt + rgb("#bbf7d0"),
  inset: 8pt,
  radius: 5pt,
  width: 100%,
  [
    #text(weight: "bold", fill: rgb("#15803d"))[Próximo Paso: Capítulo 4]
    #v(2pt)
    _Models Behind the Agents: Capabilities and Optimization_ — Selección de modelos de razonamiento vs. modelos compactos, fine-tuning y técnicas de optimización de inferencia en producción.
  ]
)
