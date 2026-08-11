import sys
from mcp.server.fastmcp import FastMCP

# Crear servidor FastMCP
mcp = FastMCP("enterprise-python-server")

# 1. Registrar Herramienta (Tool)
@mcp.tool()
def get_service_status(service_name: str) -> str:
    """Obtiene las métricas de disponibilidad y estado de un microservicio."""
    return f"Servicio '{service_name}': ESTADO OK | Latencia: 12ms | Disponibilidad: 99.99%"

# 2. Registrar Recurso (Resource)
@mcp.resource("config://production/db")
def get_db_config() -> str:
    """Devuelve la configuración de lectura de base de datos en formato JSON."""
    return '{"max_pool": 50, "ssl_mode": "require", "read_replica": "enabled"}'

# 3. Registrar Prompt (Prompt)
@mcp.prompt()
def system_diagnosis(service_name: str) -> str:
    """Genera una plantilla de diagnóstico agéntico para un microservicio."""
    return f"Ejecuta una inspección completa de logs y métricas para el servicio '{service_name}' e informa si existen anomalías."

if __name__ == "__main__":
    # Iniciar servidor sobre transporte stdio por defecto
    mcp.run(transport="stdio")
