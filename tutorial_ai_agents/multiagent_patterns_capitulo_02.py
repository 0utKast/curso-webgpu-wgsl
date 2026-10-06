#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
================================================================================
GUÍA PRÁCTICA DE AGENTES DE IA (CAPÍTULO 2): PATRONES Y SISTEMAS MULTI-AGENTE
================================================================================
Basado en la obra:
    "AI Agents: The Definitive Guide: Design, Deployment, and Evaluation for Production"
    Capítulo 2: Architectures and Patterns: Planning, Reactivity, and Multi-Agent Systems
    Autora: Nicole Koenigstein (O'Reilly Media)

Propósito del Script:
    Implementar y VISUALIZAR en tiempo real una arquitectura Multi-Agente Jerárquica
    con patrones de Razonamiento (ReAct), Revisión (Maker-Checker) y Auto-corrección (Reflexion).
    
    Características visuales de ejecución:
      - Código de colores ANSI por rol de agente.
      - Trazabilidad de mensajes del bus A2A (Agent-to-Agent).
      - Desglose explícito de Pensamiento (Thought), Acción (Action) y Crítica (Feedback).
      - Menú interactivo para ejecutar diferentes escenarios en pantalla.
================================================================================
"""

import time
import sys
from enum import Enum, auto
from typing import Dict, Any, Optional, List


# ==============================================================================
# ESTILOS Y COLORES PARA VISUALIZACIÓN EN PANTALLA (ANSI ESCAPE CODES)
# ==============================================================================
class TermColor:
    RESET = "\033[0m"
    BOLD = "\033[1m"
    DIM = "\033[2m"
    
    # Colores por rol
    SUPERVISOR = "\033[1;35m"  # Magenta / Púrpura brillante
    RESEARCHER = "\033[1;36m"  # Cian brillante
    REVIEWER = "\033[1;33m"    # Amarillo / Dorado brillante
    BUS = "\033[1;32m"         # Verde brillante (Canal A2A)
    ERROR = "\033[1;31m"       # Rojo brillante
    BOX = "\033[0;37m"         # Gris claro para bordes


# ==============================================================================
# [PASO 1] MODELADO DE MENSAJES, ESTADOS Y ROLES INTER-AGENTE (A2A PROTOCOL)
# ==============================================================================
class AgentRole(Enum):
    SUPERVISOR = ("Supervisor/Orquestador", TermColor.SUPERVISOR, "👑")
    RESEARCHER = ("Especialista/Investigador", TermColor.RESEARCHER, "🔬")
    REVIEWER = ("Revisor/Auditor de Calidad", TermColor.REVIEWER, "⚖️")

    def __init__(self, label: str, color: str, icon: str):
        self.label = label
        self.color = color
        self.icon = icon


class TaskStatus(Enum):
    PENDING = auto()
    IN_PROGRESS = auto()
    NEEDS_REVISION = auto()
    APPROVED = auto()
    FAILED = auto()


class AgentMessage:
    """Mensaje estructurado que fluye a través del canal de comunicación A2A."""
    def __init__(self, sender: AgentRole, recipient: AgentRole, content: str, metadata: Optional[Dict[str, Any]] = None):
        self.timestamp = time.strftime("%H:%M:%S")
        self.sender = sender
        self.recipient = recipient
        self.content = content
        self.metadata = metadata or {}

    def format_box(self) -> str:
        s_col = self.sender.color
        r_col = self.recipient.color
        b_col = TermColor.BUS
        rst = TermColor.RESET
        
        header = f"{b_col}📨 [CANAL A2A @ {self.timestamp}]{rst} {s_col}{self.sender.icon} {self.sender.label}{rst} ➔ {r_col}{self.recipient.icon} {self.recipient.label}{rst}"
        lines = self.content.split("\n")
        formatted_content = "\n".join([f"    │ {line}" for line in lines])
        return f"{header}\n{formatted_content}"


# ==============================================================================
# [PASO 2] CLASE BASE PARA AGENTES ESPECIALIZADOS
# ==============================================================================
class BaseAgent:
    """Clase base que dota a cada agente de identidad, rol y memoria de trabajo."""
    def __init__(self, role: AgentRole, name: str):
        self.role = role
        self.name = name
        self.inbox: List[AgentMessage] = []
        self.outbox: List[AgentMessage] = []

    def log(self, text: str, delay: float = 0.2) -> None:
        col = self.role.color
        rst = TermColor.RESET
        print(f"  {self.role.icon} {col}[{self.name} - {self.role.label}]:{rst} {text}")
        if delay > 0:
            time.sleep(delay)


# ==============================================================================
# [PASO 3] AGENTE ESPECIALISTA (WORKER) CON PATRÓN ReAct (Reason + Act)
# ==============================================================================
class ResearchWorkerAgent(BaseAgent):
    def __init__(self, name: str = "Analista-Financiero-01"):
        super().__init__(AgentRole.RESEARCHER, name)
        self.iteration_count = 0

    def execute_task(self, task_description: str, critique_feedback: Optional[str] = None, perfect_mode: bool = False) -> Dict[str, Any]:
        self.iteration_count += 1
        self.log(f"Iniciando ciclo de trabajo ReAct (Iteración #{self.iteration_count})...")

        # 1. Fase ReAct: Pensamiento (Thought)
        if critique_feedback:
            self.log(f"🧠 {TermColor.BOLD}[Thought - Reflexion]:{TermColor.RESET} Crítica recibida del auditor: \"{critique_feedback}\". Re-analizando métricas...")
        else:
            self.log(f"🧠 {TermColor.BOLD}[Thought - ReAct]:{TermColor.RESET} Desglosando requerimientos de la tarea: \"{task_description}\"...")

        # 2. Fase ReAct: Acción (Action / Simulación de ejecución de herramientas)
        if perfect_mode or self.iteration_count > 1:
            self.log("⚡ [Action - Tool]: Invocando herramienta 'calculate_advanced_metrics' con desglose de EBITDA y márgenes...")
            draft = (
                "Informe Financiero Q3 (Auditado y Corregido):\n"
                "• Ingresos Totales:    $1,500,000.00 USD\n"
                "• Gastos Operativos:   $950,000.00 USD\n"
                "• EBITDA Operativo:    $550,000.00 USD\n"
                "• Margen Operativo:    36.67%\n"
                "• Dictamen:            Rendimiento sólido; ratio de eficiencia superior al objetivo (>35%)."
            )
        else:
            self.log("⚡ [Action - Tool]: Invocando herramienta 'fetch_raw_balance' (Borrador inicial básico)...")
            draft = (
                "Borrador Financiero Preliminar Q3:\n"
                "• Ingresos Totales:    $1,500,000.00 USD\n"
                "• Gastos Operativos:   $950,000.00 USD\n"
                "• Dictamen:            La empresa presenta beneficios positivos."
            )

        # 3. Fase ReAct: Observación (Observation)
        self.log("📋 [Observation]: Datos recolectados y borrador sintetizado listo para auditoría.")
        return {
            "draft": draft,
            "iteration": self.iteration_count
        }


# ==============================================================================
# [PASO 4] AGENTE REVISOR / CRÍTICO (CHECKER) CON PATRÓN REFLEXION
# ==============================================================================
class QualityReviewerAgent(BaseAgent):
    def __init__(self, name: str = "Auditor-Calidad-01"):
        super().__init__(AgentRole.REVIEWER, name)

    def evaluate_draft(self, draft_content: str) -> Dict[str, Any]:
        self.log("Iniciando auditoría de calidad: Verificando criterios de completitud técnica...")

        # Criterios de Aceptación: Debe contener EBITDA y Margen porcentual explícito
        has_ebitda = "EBITDA" in draft_content
        has_margin = "Margen" in draft_content or "%" in draft_content

        if has_ebitda and has_margin:
            self.log(f"✅ {TermColor.BOLD}[Dictamen: APROBADO]{TermColor.RESET} Cumple todos los estándares contables y de reporte.", delay=0.3)
            return {
                "approved": True,
                "feedback": "Aprobado sin objeciones. Incluye métricas clave (EBITDA) y margen operativo explícito."
            }
        else:
            self.log(f"⚠️ {TermColor.BOLD}[Dictamen: RECHAZADO]{TermColor.RESET} Faltan métricas esenciales requeridas por la directiva.", delay=0.3)
            return {
                "approved": False,
                "feedback": "El informe omite el cálculo explícito del EBITDA y el porcentaje del margen operativo sobre ingresos."
            }


# ==============================================================================
# [PASO 5] ORQUESTADOR SUPERVISOR (HIERARCHICAL MANAGER)
# ==============================================================================
class HierarchicalOrchestrator(BaseAgent):
    def __init__(self, worker: ResearchWorkerAgent, reviewer: QualityReviewerAgent, max_cycles: int = 3):
        super().__init__(AgentRole.SUPERVISOR, "Supervisor-Central")
        self.worker = worker
        self.reviewer = reviewer
        self.max_cycles = max_cycles
        self.audit_trail: List[AgentMessage] = []

    def dispatch(self, message: AgentMessage) -> None:
        self.audit_trail.append(message)
        print(f"\n{message.format_box()}\n")
        time.sleep(0.4)

    def coordinate(self, global_goal: str, force_perfect: bool = False) -> Dict[str, Any]:
        banner = "=" * 80
        self.log(f"\n{TermColor.BOLD}{banner}\n🎯 OBJETIVO GLOBAL: \"{global_goal}\"\n{banner}{TermColor.RESET}", delay=0.2)

        current_feedback: Optional[str] = None
        final_deliverable: Optional[str] = None
        status = TaskStatus.IN_PROGRESS

        for cycle in range(1, self.max_cycles + 1):
            print(f"{TermColor.BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━{TermColor.RESET}")
            print(f"{TermColor.BOLD}🔄 CICLO MULTI-AGENTE #{cycle} DE {self.max_cycles}{TermColor.RESET}")
            print(f"{TermColor.BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━{TermColor.RESET}")
            
            # 1. Supervisor envía directiva al Especialista
            task_msg = f"Generar informe para: {global_goal}" if cycle == 1 else f"Subsanar borrador aplicando feedback: {current_feedback}"
            self.dispatch(AgentMessage(
                sender=self.role,
                recipient=self.worker.role,
                content=task_msg
            ))

            # 2. Especialista genera o refina el entregable mediante ReAct
            worker_output = self.worker.execute_task(global_goal, current_feedback, perfect_mode=force_perfect)
            draft = worker_output["draft"]

            self.dispatch(AgentMessage(
                sender=self.worker.role,
                recipient=self.reviewer.role,
                content=f"Entrega de Borrador (Iteración #{cycle}):\n{draft}"
            ))

            # 3. Revisor audita el borrador
            review_result = self.reviewer.evaluate_draft(draft)
            
            # 4. Supervisor procesa el dictamen
            if review_result["approved"]:
                self.log(f"🎉 {TermColor.BOLD}ENTREGABLE VALIDADO SATISFACTORIAMENTE POR EL AUDITOR.{TermColor.RESET}")
                final_deliverable = draft
                status = TaskStatus.APPROVED
                
                self.dispatch(AgentMessage(
                    sender=self.reviewer.role,
                    recipient=self.role,
                    content=f"Aprobación formal de calidad: {review_result['feedback']}"
                ))
                break
            else:
                self.log(f"🔁 {TermColor.BOLD}RECHAZO TEMPORAL: Disparando ciclo de Reflexión y Re-trabajo...{TermColor.RESET}")
                current_feedback = review_result["feedback"]
                status = TaskStatus.NEEDS_REVISION
                
                self.dispatch(AgentMessage(
                    sender=self.reviewer.role,
                    recipient=self.role,
                    content=f"Rechazo con crítica formativa: {current_feedback}"
                ))

        if status != TaskStatus.APPROVED:
            self.log(f"❌ {TermColor.ERROR}Límite de ciclos alcanzado sin alcanzar el estándar.{TermColor.RESET}")
            status = TaskStatus.FAILED

        return {
            "status": status.name,
            "cycles_completed": cycle,
            "final_deliverable": final_deliverable,
            "total_messages": len(self.audit_trail)
        }


# ==============================================================================
# [PASO 6] PUNTO DE ENTRADA INTERACTIVO Y MENÚ DE ESCENARIOS
# ==============================================================================
def main():
    print(f"\n{TermColor.BOLD}{'=' * 80}")
    print("DEMOSTRACIÓN INTERACTIVA: SISTEMA MULTI-AGENTE JERÁRQUICO (CAPÍTULO 2)")
    print(f"{'=' * 80}{TermColor.RESET}")
    print("Patrones demostrados en vivo:")
    print("  1. Supervisor-Worker (Orquestación jerárquica)")
    print("  2. ReAct (Thought ➔ Action ➔ Observation en el Especialista)")
    print("  3. Maker-Checker + Reflexion (Auto-corrección guiada por crítica)")
    print(f"{TermColor.BOLD}{'=' * 80}{TermColor.RESET}")

    # Ejecución por defecto con ciclo de corrección (Escenario estándar)
    worker = ResearchWorkerAgent(name="Analista-Financiero-01")
    reviewer = QualityReviewerAgent(name="Auditor-Calidad-01")
    supervisor = HierarchicalOrchestrator(worker=worker, reviewer=reviewer, max_cycles=3)

    meta = "Generar informe financiero ejecutivo consolidado para el Q3"
    resultado = supervisor.coordinate(meta)

    # Balance y resumen final en consola
    print(f"\n{TermColor.BOLD}{'=' * 80}")
    print("📊 BALANCE FINAL DEL SISTEMA MULTI-AGENTE")
    print(f"{'=' * 80}{TermColor.RESET}")
    print(f"• Estado Final:           {TermColor.BOLD}{resultado['status']}{TermColor.RESET}")
    print(f"• Ciclos de Coordinación: {resultado['cycles_completed']}")
    print(f"• Mensajes A2A Emitidos:  {resultado['total_messages']}")
    print(f"\n{TermColor.BOLD}📄 DOCUMENTO FINAL APROBADO EN PRODUCCIÓN:{TermColor.RESET}")
    print(f"{TermColor.BOX}{resultado['final_deliverable']}{TermColor.RESET}")
    print(f"{TermColor.BOLD}{'=' * 80}\n{TermColor.RESET}")


if __name__ == "__main__":
    main()
