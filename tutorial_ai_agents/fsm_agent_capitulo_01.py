#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
================================================================================
GUÍA PRÁCTICA DE AGENTES DE IA: MÁQUINA DE ESTADOS FINITOS (FSM)
================================================================================

Propósito del Script:
    Implementar un Agente Autónomo determinista y resiliente utilizando el patrón
    formal de Máquina de Estados Finitos (FSM). Este diseño elimina los riesgos
    comunes de los bucles abiertos de LLMs (deriva de contexto, bucles infinitos
    y alucinaciones de herramientas), proporcionando:
      - Transiciones explícitas y auditables.
      - Guardas de seguridad deterministas.
      - Auto-recuperación ante fallos transitorios de red/APIs con retroceso exponencial.
      - Desacoplamiento total entre la memoria (Estado) y la lógica de control.
================================================================================
"""

import time
import json
from enum import Enum, auto
from typing import Dict, Any, Optional, List


# ==============================================================================
# [PASO 1] DECLARACIÓN DE ESTADOS Y EVENTOS FORMALES (ENUMS)
# ==============================================================================
# Definimos el conjunto cerrado de modos posibles (Estados) y señales (Eventos).
# El uso de Enums garantiza seguridad de tipos y previene "strings mágicos".

class AgentState(Enum):
    """Conjunto cerrado de estados finitos (S) que puede adoptar el agente."""
    IDLE = auto()               # Reposo: Esperando asignación de objetivo
    PLANNING = auto()           # Planificación: LLM genera o revisa el plan de acción
    EXECUTING_TOOL = auto()     # Ejecución: Invocación de herramientas, APIs o código
    VALIDATING = auto()         # Validación: Verificación de calidad y consistencia
    ERROR_RECOVERY = auto()     # Recuperación: Manejo controlado de excepciones
    DONE = auto()               # Terminal Exitoso: Tarea completada y verificada
    TERMINATED_FAILED = auto()  # Terminal Fallido: Límite de reintentos agotado


class AgentEvent(Enum):
    """Conjunto de eventos (E) que disparan transiciones entre estados."""
    START = auto()
    PLAN_READY = auto()
    TOOL_SUCCESS = auto()
    TOOL_FAILED = auto()
    VALIDATION_PASSED = auto()
    NEED_MORE_STEPS = auto()
    RETRY_AUTHORIZED = auto()
    MAX_RETRIES_REACHED = auto()


# ==============================================================================
# [PASO 2] ESTRUCTURA DE CONTEXTO Y PERSISTENCIA DE MEMORIA (AgentContext)
# ==============================================================================
# Este objeto encapsula todo el estado mutable (memoria a corto plazo, plan,
# datos recolectados y logs). Permite serializar el estado en checkpoints.

class AgentContext:
    """
    Contenedor de estado desacoplado de la lógica de control (State Container).
    Permite serializar todo el contexto para auditoría o puntos de control (checkpoints).
    """
    def __init__(self, task: str, max_retries: int = 3):
        self.task: str = task                       # Meta global asignada al agente
        self.max_retries: int = max_retries         # Guarda: Límite máximo de fallos tolerados
        self.retry_count: int = 0                   # Contador de intentos fallidos
        self.plan: List[str] = []                   # Lista ordenada de subtareas
        self.current_step_index: int = 0            # Índice del paso en ejecución
        self.execution_results: Dict[str, Any] = {} # Almacén de salidas intermedias
        self.last_error: Optional[str] = None       # Registro del último fallo capturado
        self.final_output: Optional[str] = None     # Resultado final sintetizado
        self.history_log: List[str] = []            # Bitácora cronológica de auditoría

    def log(self, message: str) -> None:
        """Registra eventos con marca temporal para auditoría y depuración en consola."""
        timestamp = time.strftime("%H:%M:%S")
        entry = f"[{timestamp}] {message}"
        self.history_log.append(entry)
        print(f"  📌 {entry}")


# ==============================================================================
# [PASO 3] CLASE PRINCIPAL DE LA FSM Y AUDITORÍA DE TRANSICIONES (FSMAgent)
# ==============================================================================

class FSMAgent:
    """
    Motor de la Máquina de Estados Finitos que gobierna el ciclo de vida del agente.
    """
    def __init__(self, context: AgentContext):
        self.context = context
        self.state = AgentState.IDLE
        self.context.log(f"Agente inicializado en estado: {self.state.name}")

    def transition_to(self, new_state: AgentState, reason: str = "") -> None:
        """Ejecuta y registra una transición formal de estado con su justificación."""
        self.context.log(f"TRANSICIÓN: {self.state.name} ➡️ {new_state.name} | Motivo: {reason}")
        self.state = new_state


    # ==========================================================================
    # [PASO 4] CONTROLADORES DE ESTADO ESPECIALIZADOS (STATE HANDLERS)
    # ==========================================================================

    # --- 4.1. Handler de Reposo (IDLE) ---
    def handle_idle(self) -> None:
        """Evalúa la tarea de entrada y dispara la transición a planificación."""
        self.context.log(f"Tarea asignada recibida: \"{self.context.task}\"")
        self.transition_to(
            AgentState.PLANNING, 
            "Iniciando análisis y descomposición de la meta"
        )

    # --- 4.2. Handler de Planificación (PLANNING) ---
    def handle_planning(self) -> None:
        """Simula la invocación del LLM para descomponer el objetivo en subtareas."""
        self.context.log("Cerebro (LLM) analizando el objetivo y formulando el plan de acción...")
        
        # En producción real, aquí se envía el prompt al modelo con técnicas como Few-Shot o CoT
        if "financiero" in self.context.task.lower():
            self.context.plan = [
                "fetch_financial_data",      # Paso 1: Consultar API de datos de la empresa
                "calculate_ebitda_margins",   # Paso 2: Calcular métricas operativas clave
                "generate_executive_report"  # Paso 3: Redactar la síntesis ejecutiva final
            ]
            self.context.current_step_index = 0
            self.context.log(f"Plan generado con éxito: {self.context.plan}")
            self.transition_to(
                AgentState.EXECUTING_TOOL, 
                "Plan validado; procediendo a ejecutar el primer paso"
            )
        else:
            self.context.last_error = "El LLM no pudo reconocer el dominio de la tarea solicitada."
            self.transition_to(
                AgentState.ERROR_RECOVERY, 
                "Fallo en generación de plan"
            )

    # --- 4.3. Handler de Ejecución de Herramientas (EXECUTING_TOOL) ---
    def handle_executing_tool(self) -> None:
        """Invoca la herramienta correspondiente al paso actual con control de excepciones."""
        step = self.context.plan[self.context.current_step_index]
        total_steps = len(self.context.plan)
        current_num = self.context.current_step_index + 1
        
        self.context.log(f"Ejecutando herramienta ({current_num}/{total_steps}): [{step}]")

        try:
            if step == "fetch_financial_data":
                # Simulación de fallo transitorio en el primer intento para verificar la auto-recuperación
                if self.context.retry_count == 0 and "forzar_fallo" in self.context.task:
                    raise ConnectionError("Timeout 504: El servidor remoto de datos financieros no respondió.")
                
                # Datos simulados recibidos de la API financiera
                self.context.execution_results["raw_data"] = {
                    "ingresos": 1500000.0, 
                    "gastos": 950000.0
                }
                self.context.log("Herramienta [fetch_financial_data] completada con éxito.")
                self.transition_to(
                    AgentState.VALIDATING, 
                    "Datos obtenidos; enviando a validación"
                )

            elif step == "calculate_ebitda_margins":
                raw = self.context.execution_results["raw_data"]
                ebitda = raw["ingresos"] - raw["gastos"]
                margen = (ebitda / raw["ingresos"]) * 100
                self.context.execution_results["metrics"] = {
                    "ebitda": ebitda, 
                    "margen": margen
                }
                self.context.log(f"Cálculo realizado: EBITDA=${ebitda:,.2f} USD | Margen={margen:.2f}%")
                self.transition_to(
                    AgentState.VALIDATING, 
                    "Cálculos completados; verificando integridad"
                )

            elif step == "generate_executive_report":
                metrics = self.context.execution_results["metrics"]
                self.context.final_output = (
                    f"INFORME EJECUTIVO Q3: EBITDA registrado de ${metrics['ebitda']:,.2f} USD "
                    f"con un margen operativo del {metrics['margen']:.2f}%."
                )
                self.context.log("Síntesis del informe generada correctamente por el LLM.")
                self.transition_to(
                    AgentState.VALIDATING, 
                    "Documento redactado; validando salida final"
                )

        except Exception as e:
            # Captura de cualquier excepción en runtime para aislar el fallo y evitar caídas
            self.context.last_error = str(e)
            self.context.log(f"❌ Excepción en ejecución de herramienta: {e}")
            self.transition_to(
                AgentState.ERROR_RECOVERY, 
                "Fallo en tiempo de ejecución capturado"
            )

    # --- 4.4. Handler de Validación (VALIDATING) ---
    def handle_validating(self) -> None:
        """Verifica que las salidas cumplan los criterios de calidad y decide el avance."""
        self.context.log("Validando consistencia y completitud del paso actual...")
        step = self.context.plan[self.context.current_step_index]

        if step in ["fetch_financial_data", "calculate_ebitda_margins"]:
            # Guarda: Si el resultado intermedio es válido, avanzamos el cursor del plan
            self.context.current_step_index += 1
            if self.context.current_step_index < len(self.context.plan):
                self.transition_to(
                    AgentState.EXECUTING_TOOL, 
                    "Paso validado; pasando a la siguiente herramienta"
                )
            else:
                self.transition_to(
                    AgentState.DONE, 
                    "Todos los pasos del plan han sido completados"
                )

        elif step == "generate_executive_report":
            # Guarda de calidad: Verificación de que la salida final no esté vacía ni corrupta
            if self.context.final_output and len(self.context.final_output) > 20:
                self.transition_to(
                    AgentState.DONE, 
                    "Validación final satisfactoria; objetivo cumplido"
                )
            else:
                self.context.last_error = "El informe final no cumple los estándares de calidad mínimos."
                self.transition_to(
                    AgentState.ERROR_RECOVERY, 
                    "Fallo en la validación de calidad final"
                )

    # --- 4.5. Handler de Recuperación de Errores (ERROR_RECOVERY) ---
    def handle_error_recovery(self) -> None:
        """Aplica la política de reintentos y retroceso exponencial antes de abortar."""
        self.context.retry_count += 1
        self.context.log(
            f"Evaluando recuperación ante desastres (Intento {self.context.retry_count}/{self.context.max_retries})..."
        )

        # GUARDA DETERMINISTA: ¿Quedan reintentos disponibles?
        if self.context.retry_count <= self.context.max_retries:
            # Retroceso exponencial (Exponential Backoff): 0.5s, 1.0s, 2.0s...
            backoff_delay = 0.5 * (2 ** (self.context.retry_count - 1))
            self.context.log(f"Aplicando pausa de mitigación de {backoff_delay:.1f}s. Causa: {self.context.last_error}")
            time.sleep(backoff_delay)
            self.transition_to(
                AgentState.EXECUTING_TOOL, 
                "Reintento de la herramienta autorizado por la guarda"
            )
        else:
            # Si se supera el umbral, pasamos a estado terminal fallido sin bucles infinitos
            self.context.log("❌ Límite de reintentos alcanzado. Abortando para evitar gasto innecesario de tokens.")
            self.transition_to(
                AgentState.TERMINATED_FAILED, 
                "Umbral máximo de fallos superado sin resolución"
            )


    # ==========================================================================
    # [PASO 5] BUCLE PRINCIPAL DE DESPACHO Y CONTROL (RUN LOOP)
    # ==========================================================================
    def run(self) -> Dict[str, Any]:
        """Ejecuta el bucle de despacho determinista hasta alcanzar un estado terminal."""
        self.context.log("🚀 Iniciando bucle de control del agente...")
        
        while self.state not in [AgentState.DONE, AgentState.TERMINATED_FAILED]:
            if self.state == AgentState.IDLE:
                self.handle_idle()
            elif self.state == AgentState.PLANNING:
                self.handle_planning()
            elif self.state == AgentState.EXECUTING_TOOL:
                self.handle_executing_tool()
            elif self.state == AgentState.VALIDATING:
                self.handle_validating()
            elif self.state == AgentState.ERROR_RECOVERY:
                self.handle_error_recovery()

        # Determinación del resultado final
        is_success = (self.state == AgentState.DONE)
        self.context.log(f"🏁 FIN DE EJECUCIÓN. Estado: {self.state.name} | Éxito: {is_success}")
        
        return {
            "success": is_success,
            "final_state": self.state.name,
            "final_output": self.context.final_output,
            "retries_used": self.context.retry_count,
            "history_log": self.context.history_log
        }


# ==============================================================================
# [PASO 6] PUNTO DE ENTRADA Y DEMOSTRACIÓN DE RESILIENCIA OPERATIVA
# ==============================================================================
if __name__ == "__main__":
    print("=" * 80)
    print("DEMOSTRACIÓN: Ejecución con Fallo Transitorio de Red y Auto-Recuperación")
    print("=" * 80)

    # Creamos el contexto solicitando forzar un fallo inicial para verificar la FSM
    contexto = AgentContext(
        task="Generar balance financiero Q3 (forzar_fallo_red_inicial)",
        max_retries=3
    )

    # Instanciamos y ejecutamos el agente FSM
    agente = FSMAgent(contexto)
    resultado = agente.run()

    # Presentamos el balance final del ciclo de vida
    print("\n" + "=" * 80)
    print("RESUMEN DE SALIDA:")
    print(f"• Estado Final:  {resultado['final_state']}")
    print(f"• Éxito Global:  {resultado['success']}")
    print(f"• Reintentos:    {resultado['retries_used']}")
    print(f"• Informe Final: {resultado['final_output']}")
    print("=" * 80)
