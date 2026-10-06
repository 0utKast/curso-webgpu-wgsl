"""
================================================================================
TALLER PRÁCTICO: MOTOR DE GRAFOS DE ESTADO (StateGraph), PLANIFICACIÓN DINÁMICA
EN DAG, CHECKPOINTING (TIME-TRAVEL) Y HUMAN-IN-THE-LOOP (HITL)
================================================================================
Serie: Guía Práctica de Arquitectura y Desarrollo de Agentes de IA
Basado en: AI Agents: The Definitive Guide (Capítulo 3) - Nicole Koenigstein (O'Reilly)
================================================================================
"""

import time
import copy
import json
from enum import Enum, auto
from dataclasses import dataclass, field, asdict
from typing import Dict, Any, List, Optional, Callable, Set, Tuple


# ==============================================================================
# ESTILOS Y FORMATO DE TERMINAL (ANSI ESCAPE CODES)
# ==============================================================================
class TermColor:
    RESET = "\033[0m"
    BOLD = "\033[1m"
    GRAPH = "\033[1;35m"       # Magenta: Estructura del Grafo y Nodos
    PLANNER = "\033[1;36m"     # Cian: Planificador Jerárquico (DAG)
    WORKER = "\033[1;34m"      # Azul: Nodos de Ejecución Paralela
    CHECKPOINT = "\033[1;33m"  # Amarillo/Dorado: Persistencia y Time-Travel
    HITL = "\033[1;31m"        # Rojo/Naranja: Puerta Human-in-the-Loop
    SUCCESS = "\033[1;32m"     # Verde: Validaciones y Éxito
    DIM = "\033[2;37m"         # Gris atenuado


# ==============================================================================
# [PASO 1] ESQUEMA DE ESTADO CENTRAL TIPADO Y REDUCTOR DE ESTADO (STATE REDUCER)
# ==============================================================================

class NodeStatus(Enum):
    PENDING = auto()
    RUNNING = auto()
    COMPLETED = auto()
    FAILED = auto()
    WAITING_FOR_HUMAN = auto()


@dataclass
class SubTask:
    """Subtarea atómica dentro del grafo de dependencias acíclico (DAG)."""
    id: str
    description: str
    dependencies: List[str] = field(default_factory=list)
    status: NodeStatus = NodeStatus.PENDING
    result: Optional[Dict[str, Any]] = None


@dataclass
class AgentState:
    """
    Estado global del Grafo de Agentes (State Schema).
    Representa la 'Única Fuente de Verdad' que viaja y muta a través de los nodos.
    """
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
        """Copia profunda para aislamiento de estados y snapshots de checkpoints."""
        return copy.deepcopy(self)

    def log(self, message: str) -> None:
        timestamp = time.strftime("%H:%M:%S")
        entry = f"[{timestamp}] {message}"
        self.execution_logs.append(entry)


def state_reducer(current_state: AgentState, update_dict: Dict[str, Any]) -> AgentState:
    """
    Reductor de Estado Determinista (State Reducer).
    Aplica mutaciones al estado garantizando consistencia e inmutabilidad histórica.
    """
    new_state = current_state.clone()
    for key, value in update_dict.items():
        if hasattr(new_state, key):
            if isinstance(getattr(new_state, key), list) and isinstance(value, list):
                # Estrategia de agregación para listas (append/merge)
                setattr(new_state, key, getattr(new_state, key) + value)
            elif isinstance(getattr(new_state, key), dict) and isinstance(value, dict):
                # Estrategia de fusión para diccionarios
                getattr(new_state, key).update(value)
            else:
                # Reemplazo directo para valores escalares
                setattr(new_state, key, value)
    return new_state


# ==============================================================================
# [PASO 2] GESTOR DE PERSISTENCIA, CHECKPOINTS Y TIME-TRAVEL DEBUGGING
# ==============================================================================

class CheckpointManager:
    """
    Almacén de Checkpoints para persistencia de estado y depuración Time-Travel.
    Permite congelar el estado del grafo en cualquier paso y rebobinar la ejecución.
    """
    def __init__(self):
        self.checkpoints: Dict[str, Tuple[str, AgentState]] = {}
        self.checkpoint_history: List[str] = []

    def save_checkpoint(self, checkpoint_id: str, node_name: str, state: AgentState) -> None:
        self.checkpoints[checkpoint_id] = (node_name, state.clone())
        self.checkpoint_history.append(checkpoint_id)
        print(f"  {TermColor.CHECKPOINT}💾 [CHECKPOINT CREADO]{TermColor.RESET} ID: {TermColor.BOLD}{checkpoint_id}{TermColor.RESET} | Nodo: '{node_name}' | Iteración: #{state.iteration}")

    def load_checkpoint(self, checkpoint_id: str) -> Tuple[str, AgentState]:
        if checkpoint_id not in self.checkpoints:
            raise KeyError(f"Checkpoint '{checkpoint_id}' no encontrado.")
        node_name, state = self.checkpoints[checkpoint_id]
        print(f"  {TermColor.CHECKPOINT}⏪ [TIME-TRAVEL LOAD]{TermColor.RESET} Restaurando estado desde checkpoint '{checkpoint_id}' (Nodo previo: '{node_name}')...")
        return node_name, state.clone()

    def list_checkpoints(self) -> List[str]:
        return list(self.checkpoints.keys())


# ==============================================================================
# [PASO 3] NODOS DE PROCESAMIENTO Y RAZONAMIENTO DEL GRAFO
# ==============================================================================

class GraphNodes:
    """Colección de funciones que operan como Nodos en el StateGraph."""

    @staticmethod
    def hierarchical_planner_node(state: AgentState) -> Dict[str, Any]:
        """
        Nodo 1: Planificador Jerárquico (Subgoal Decomposition / DAG Generation).
        Descompone el objetivo global en un grafo dirigido acíclico de tareas dependientes.
        """
        print(f"\n{TermColor.PLANNER}🧠 [NODO: HierarchicalPlanner]{TermColor.RESET} Analizando objetivo: \"{state.goal}\"")
        time.sleep(0.3)
        print(f"  {TermColor.PLANNER}↳ Descomponiendo meta en Grafo Acíclico Dirigido (DAG) de subtareas...{TermColor.RESET}")

        dag: Dict[str, SubTask] = {
            "task_cost": SubTask(
                id="task_cost",
                description="Auditoría y detección de instancias cloud huérfanas y volúmenes sin uso.",
                dependencies=[]
            ),
            "task_security": SubTask(
                id="task_security",
                description="Escaneo de puertos abiertos y auditoría de permisos de buckets de almacenamiento.",
                dependencies=[]
            ),
            "task_synthesis": SubTask(
                id="task_synthesis",
                description="Consolidación de auditorías y formulación de plan de remediación unificado.",
                dependencies=["task_cost", "task_security"]
            ),
            "task_remediation_gate": SubTask(
                id="task_remediation_gate",
                description="Control Human-in-the-Loop previo a la aplicación de cambios destructivos.",
                dependencies=["task_synthesis"]
            ),
            "task_execute_changes": SubTask(
                id="task_execute_changes",
                description="Ejecución de remediaciones autorizadas en la infraestructura.",
                dependencies=["task_remediation_gate"]
            )
        }

        print(f"  {TermColor.PLANNER}✔ DAG construido exitosamente con 5 subtareas y dependencias formales.{TermColor.RESET}")
        return {
            "plan_dag": dag,
            "iteration": state.iteration + 1
        }

    @staticmethod
    def cost_analysis_node(state: AgentState) -> Dict[str, Any]:
        """
        Nodo 2A (Paralelo): Análisis de Costes de Infraestructura.
        """
        print(f"\n{TermColor.WORKER}⚡ [NODO CONCURRENTE: CostAnalysis]{TermColor.RESET} Ejecutando escaneo financiero de activos cloud...")
        time.sleep(0.4)
        
        findings = {
            "unattached_ebs_volumes": 3,
            "idle_instances": ["i-09f1a238b (EC2)", "i-0bb231cc4 (EC2)"],
            "monthly_waste_usd": 1850.00,
            "recommendation": "Terminar 2 instancias inactivas y eliminar 3 volúmenes EBS huérfanos."
        }
        print(f"  {TermColor.WORKER}↳ Hallazgo de Costes: Gasto innecesario de ${findings['monthly_waste_usd']} USD/mes.{TermColor.RESET}")
        
        # Actualizamos estado de la tarea en el DAG
        dag = state.plan_dag
        if "task_cost" in dag:
            dag["task_cost"].status = NodeStatus.COMPLETED
            dag["task_cost"].result = findings

        return {
            "cost_audit_results": findings,
            "plan_dag": dag
        }

    @staticmethod
    def security_audit_node(state: AgentState) -> Dict[str, Any]:
        """
        Nodo 2B (Paralelo): Análisis de Postura de Seguridad.
        """
        print(f"\n{TermColor.WORKER}⚡ [NODO CONCURRENTE: SecurityAudit]{TermColor.RESET} Escaneando vectores de ataque y políticas IAM...")
        time.sleep(0.4)
        
        findings = {
            "critical_vulnerabilities": 1,
            "high_vulnerabilities": 1,
            "details": [
                {"type": "OPEN_PORT_SSH", "severity": "HIGH", "target": "sg-0442fa9 (Port 22 open to 0.0.0.0/0)"},
                {"type": "UNENCRYPTED_S3", "severity": "CRITICAL", "target": "s3://corp-financial-backups (Public Read/Write)"}
            ],
            "recommendation": "Cerrar puerto 22 a CIDR público y revocar acceso público a s3://corp-financial-backups."
        }
        print(f"  {TermColor.WORKER}↳ Hallazgo de Seguridad: 1 vulnerabilidad CRÍTICA (Bucket público) y 1 ALTA (SSH).{TermColor.RESET}")

        dag = state.plan_dag
        if "task_security" in dag:
            dag["task_security"].status = NodeStatus.COMPLETED
            dag["task_security"].result = findings

        return {
            "security_audit_results": findings,
            "plan_dag": dag
        }

    @staticmethod
    def synthesis_and_proposal_node(state: AgentState) -> Dict[str, Any]:
        """
        Nodo 3 (Fan-in): Síntesis de Auditorías y Propuesta de Remediación.
        """
        print(f"\n{TermColor.GRAPH}🧩 [NODO: Synthesis & Remediation Planner]{TermColor.RESET} Consolidando auditorías concurrentes...")
        time.sleep(0.3)

        proposals = [
            {
                "id": "REM-001",
                "action": "TERMINATE_INSTANCES",
                "target": "2 EC2 Idles + 3 EBS",
                "risk_level": "LOW",
                "impact": "Ahorro de $1,850/mes",
                "requires_human": False
            },
            {
                "id": "REM-002",
                "action": "RESTRICT_SECURITY_GROUP",
                "target": "sg-0442fa9 (SSH)",
                "risk_level": "MEDIUM",
                "impact": "Mitiga vector de fuerza bruta",
                "requires_human": False
            },
            {
                "id": "REM-003",
                "action": "DELETE_OR_ENCRYPT_S3_BUCKET",
                "target": "s3://corp-financial-backups",
                "risk_level": "CRITICAL",
                "impact": "Peligro de pérdida accidental si se borra el bucket",
                "requires_human": True
            }
        ]

        print(f"  {TermColor.GRAPH}↳ Plan unificado formulado con {len(proposals)} acciones de remediación.{TermColor.RESET}")
        print(f"  {TermColor.GRAPH}↳ Alerta: Se detectó 1 acción de ALTO IMPACTO/RIESGO (REM-003).{TermColor.RESET}")

        dag = state.plan_dag
        if "task_synthesis" in dag:
            dag["task_synthesis"].status = NodeStatus.COMPLETED
            dag["task_synthesis"].result = {"total_proposals": len(proposals)}

        return {
            "proposed_remediations": proposals,
            "requires_human_approval": True,
            "plan_dag": dag
        }

    @staticmethod
    def human_in_the_loop_node(state: AgentState) -> Dict[str, Any]:
        """
        Nodo 4: Puerta Human-in-the-Loop (HITL Interrupt Gate).
        Pausa el grafo, solicita aprobación humana y permite State Injection.
        """
        print(f"\n{TermColor.HITL}🛑 [PUERTA HUMAN-IN-THE-LOOP (HITL)]{TermColor.RESET} Interrupción de seguridad activada.")
        print(f"  {TermColor.HITL}========================================================================{TermColor.RESET}")
        print(f"  {TermColor.HITL}⚠️ ACCIÓN DE ALTO RIESGO REQUIERE AUTORIZACIÓN HUMANA EXPLÍCITA:{TermColor.RESET}")
        
        for p in state.proposed_remediations:
            if p["requires_human"]:
                print(f"    • [{p['id']}] Acción: {TermColor.BOLD}{p['action']}{TermColor.RESET} sobre '{p['target']}' (Riesgo: {p['risk_level']})")
        
        print(f"  {TermColor.HITL}========================================================================{TermColor.RESET}")
        time.sleep(0.5)

        # En entorno automatizado / taller, emulamos la intervención de un ingeniero DevOps
        print(f"  {TermColor.HITL}👤 [OPERADOR HUMANO EN LÍNEA]:{TermColor.RESET} Evaluando impacto...")
        time.sleep(0.4)
        human_decision = (
            "APROBADO_CON_MODIFICACION: No destruir el bucket s3://corp-financial-backups. "
            "En su lugar, aplicar cifrado AES-256 forzado y bloquear acceso público (BlockPublicAccess=True)."
        )
        print(f"  {TermColor.HITL}📝 [DICTAMEN HUMANO (State Injection)]:{TermColor.RESET} \"{human_decision}\"")

        # Aplicamos la modificación humana a la lista aprobada
        approved = []
        for p in state.proposed_remediations:
            if not p["requires_human"]:
                approved.append(p)
            else:
                # Modificación inyectada por el humano
                modified_p = copy.deepcopy(p)
                modified_p["action"] = "ENABLE_ENCRYPTION_AND_BLOCK_PUBLIC_ACCESS"
                modified_p["risk_level"] = "LOW (MODIFIED BY HUMAN)"
                modified_p["human_note"] = human_decision
                approved.append(modified_p)

        dag = state.plan_dag
        if "task_remediation_gate" in dag:
            dag["task_remediation_gate"].status = NodeStatus.COMPLETED
            dag["task_remediation_gate"].result = {"human_approved": True}

        return {
            "approved_remediations": approved,
            "requires_human_approval": False,
            "human_feedback": human_decision,
            "plan_dag": dag
        }

    @staticmethod
    def execution_and_verification_node(state: AgentState) -> Dict[str, Any]:
        """
        Nodo 5: Ejecución de Remediaciones Aprobadas y Cierre del Grafo.
        """
        print(f"\n{TermColor.SUCCESS}🚀 [NODO: Execution & Verification]{TermColor.RESET} Aplicando remediaciones autorizadas...")
        time.sleep(0.4)

        for act in state.approved_remediations:
            print(f"  {TermColor.SUCCESS}✔ Ejecutando [{act['id']}]: {act['action']} ➔ {act['target']}{TermColor.RESET}")
            time.sleep(0.2)

        dag = state.plan_dag
        if "task_execute_changes" in dag:
            dag["task_execute_changes"].status = NodeStatus.COMPLETED
            dag["task_execute_changes"].result = {"executed_count": len(state.approved_remediations)}

        print(f"\n{TermColor.SUCCESS}🎉 Todas las remediaciones se completaron con verificación 100% exitosa.{TermColor.RESET}")
        return {
            "is_completed": True,
            "plan_dag": dag
        }


# ==============================================================================
# [PASO 4] MOTOR DE GRAFOS DE ESTADOS (STATEGRAPH ENGINE)
# ==============================================================================

class StateGraphEngine:
    """
    Motor ejecutor de Grafos de Estado Dinámicos.
    Soporta:
    1. Registro de Nodos y Aristas (Edges / Conditional Edges).
    2. Ejecución Secuencial y Paralela (Fan-out / Fan-in).
    3. Puntos de Control Automáticos (Checkpoints).
    4. Enrutamiento Condicional y Bucles de Ciclo.
    """
    def __init__(self, session_id: str):
        self.session_id = session_id
        self.nodes: Dict[str, Callable[[AgentState], Dict[str, Any]]] = {}
        self.checkpoint_manager = CheckpointManager()
        self.execution_trail: List[str] = []

    def add_node(self, name: str, func: Callable[[AgentState], Dict[str, Any]]) -> None:
        self.nodes[name] = func

    def run_graph(self, initial_state: AgentState) -> AgentState:
        """Ejecuta el grafo orquestado paso a paso con persistencia."""
        state = initial_state.clone()
        print(f"\n{TermColor.GRAPH}════════════════════════════════════════════════════════════════════════════════{TermColor.RESET}")
        print(f"{TermColor.GRAPH}🚀 INICIANDO EJECUCIÓN DEL GRAFO DE ESTADOS: SESIÓN [{self.session_id}]{TermColor.RESET}")
        print(f"{TermColor.GRAPH}════════════════════════════════════════════════════════════════════════════════{TermColor.RESET}")

        # Checkpoint Inicial
        self.checkpoint_manager.save_checkpoint("chk-000-init", "START", state)

        # 1. Fase de Planificación (Nodo 1)
        plan_updates = self.nodes["planner"](state)
        state = state_reducer(state, plan_updates)
        self.checkpoint_manager.save_checkpoint("chk-001-plan", "planner", state)

        # 2. Fase de Ejecución Paralela Concurrente (Fan-Out: Nodos 2A y 2B)
        print(f"\n{TermColor.GRAPH}🔀 [ARISTA CONDICIONAL: FAN-OUT PARALELO]{TermColor.RESET} Bifurcando ejecución hacia ramas independientes de análisis...")
        
        # Emulación de ejecución paralela asíncrona
        cost_updates = self.nodes["cost_analysis"](state)
        security_updates = self.nodes["security_audit"](state)

        # Reducción convergente (Fan-In)
        state = state_reducer(state, cost_updates)
        state = state_reducer(state, security_updates)
        self.checkpoint_manager.save_checkpoint("chk-002-audited", "parallel_audit", state)

        # 3. Fase de Síntesis y Propuesta (Nodo 3)
        synthesis_updates = self.nodes["synthesis"](state)
        state = state_reducer(state, synthesis_updates)
        self.checkpoint_manager.save_checkpoint("chk-003-proposed", "synthesis", state)

        # 4. Enrutamiento Condicional: ¿Requiere HITL?
        if state.requires_human_approval:
            print(f"\n{TermColor.GRAPH}🔀 [ARISTA CONDICIONAL: EVALUACIÓN DE GUARDAS]{TermColor.RESET} Guarda 'requires_human_approval == True' ➔ Enrutando a HITL Gate.")
            hitl_updates = self.nodes["hitl_gate"](state)
            state = state_reducer(state, hitl_updates)
            self.checkpoint_manager.save_checkpoint("chk-004-hitl-approved", "hitl_gate", state)

        # 5. Fase de Ejecución de Cambios (Nodo 5)
        exec_updates = self.nodes["execution"](state)
        state = state_reducer(state, exec_updates)
        self.checkpoint_manager.save_checkpoint("chk-005-final", "execution", state)

        print(f"\n{TermColor.GRAPH}════════════════════════════════════════════════════════════════════════════════{TermColor.RESET}")
        print(f"{TermColor.GRAPH}🏁 EJECUCIÓN DEL GRAFO FINALIZADA CON ÉXITO{TermColor.RESET}")
        print(f"{TermColor.GRAPH}════════════════════════════════════════════════════════════════════════════════{TermColor.RESET}")
        return state


# ==============================================================================
# [PASO 5] DEMOSTRACIÓN DE TIME-TRAVEL DEBUGGING (REBOBINADO DE ESTADO)
# ==============================================================================

def demonstrate_time_travel(engine: StateGraphEngine) -> None:
    """
    Demuestra la capacidad de 'Viaje en el Tiempo' (Time-Travel Debugging):
    Carga un checkpoint previo a la intervención humana, modifica un parámetro
    y permite re-evaluar la bifurcación sin recalcular los nodos costosos previos.
    """
    print(f"\n\n{TermColor.CHECKPOINT}════════════════════════════════════════════════════════════════════════════════{TermColor.RESET}")
    print(f"{TermColor.CHECKPOINT}🔬 DEMOSTRACIÓN AVANZADA: TIME-TRAVEL DEBUGGING Y FORWARD REPLAY{TermColor.RESET}")
    print(f"{TermColor.CHECKPOINT}════════════════════════════════════════════════════════════════════════════════{TermColor.RESET}")
    print("Escenario: Un auditor de seguridad desea rebobinar la ejecución hasta el Checkpoint '#chk-003-proposed'")
    print("para inspeccionar qué propuestas exactas se habían generado ANTES de la intervención humana.\n")

    # Restauramos el estado del Checkpoint 3
    node_name, restored_state = engine.checkpoint_manager.load_checkpoint("chk-003-proposed")

    print(f"\n{TermColor.BOLD}🔍 Inspección Forense del Estado Restaurado:{TermColor.RESET}")
    print(f"  • Objetivo Original: \"{restored_state.goal}\"")
    print(f"  • Propuestas originales en cola:")
    for p in restored_state.proposed_remediations:
        print(f"    - [{p['id']}] {p['action']} (Riesgo: {p['risk_level']})")
    print(f"  • ¿Estaba aprobado por humanos en este punto?: {not restored_state.requires_human_approval}")
    print(f"  • Aprobaciones registradas en este microsegundo: {len(restored_state.approved_remediations)} (0)")

    print(f"\n{TermColor.CHECKPOINT}✔ Capacidad demostrada: El estado es serializable, inmutable y auditable paso a paso.{TermColor.RESET}")


# ==============================================================================
# [PASO 6] PUNTO DE ENTRADA PRINCIPAL
# ==============================================================================

def main():
    # 1. Instanciamos el Motor de Grafos
    engine = StateGraphEngine(session_id="session-cloud-opt-2026")

    # 2. Registramos los Nodos
    engine.add_node("planner", GraphNodes.hierarchical_planner_node)
    engine.add_node("cost_analysis", GraphNodes.cost_analysis_node)
    engine.add_node("security_audit", GraphNodes.security_audit_node)
    engine.add_node("synthesis", GraphNodes.synthesis_and_proposal_node)
    engine.add_node("hitl_gate", GraphNodes.human_in_the_loop_node)
    engine.add_node("execution", GraphNodes.execution_and_verification_node)

    # 3. Definimos el Estado Inicial
    initial_state = AgentState(
        session_id="session-cloud-opt-2026",
        goal="Optimizar y securizar infraestructura Cloud AWS/GCP para Q3, reduciendo costes y remediando vulnerabilidades críticas."
    )

    # 4. Ejecutamos el Grafo Completo
    final_state = engine.run_graph(initial_state)

    # 5. Mostramos el Balance de Producción
    print(f"\n{TermColor.BOLD}📊 RESUMEN FINAL DE LA EJECUCIÓN DEL GRAFO:{TermColor.RESET}")
    print(f"• Tareas completadas en el DAG: {len([t for t in final_state.plan_dag.values() if t.status == NodeStatus.COMPLETED])} / {len(final_state.plan_dag)}")
    print(f"• Checkpoints guardados:       {len(engine.checkpoint_manager.list_checkpoints())}")
    print(f"• Remediaciones ejecutadas:    {len(final_state.approved_remediations)}")
    print(f"• Intervención HITL aplicada:  \"{final_state.human_feedback}\"")

    # 6. Demostración de Time-Travel Debugging
    demonstrate_time_travel(engine)


if __name__ == "__main__":
    main()
