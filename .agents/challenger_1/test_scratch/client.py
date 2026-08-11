import asyncio
import sys
from mcp import ClientSession, StdioServerParameters
from mcp.client.stdio import stdio_client

async def main():
    # Parámetros para invocar el proceso servidor en Python
    server_params = StdioServerParameters(
        command=sys.executable,
        args=["server.py"],
        env=None
    )

    # Iniciar flujo de transporte stdio y sesión del cliente
    async with stdio_client(server_params) as (read, write):
        async with ClientSession(read, write) as session:
            # Fase 1: Realizar Handshake de inicialización
            await session.initialize()
            print("Cliente Python MCP inicializado correctamente.")

            # Fase 2: Descubrir e invocar herramientas
            tools = await session.list_tools()
            print("Herramientas disponibles:", [t.name for t in tools.tools])

            tool_response = await session.call_tool(
                "get_service_status",
                arguments={"service_name": "payments-api"}
            )
            print("Respuesta de la herramienta:", tool_response.content)

            # Fase 3: Leer recursos pasivos
            resource_data = await session.read_resource("config://production/db")
            print("Recurso obtenido:", resource_data)

if __name__ == "__main__":
    asyncio.run(main())
