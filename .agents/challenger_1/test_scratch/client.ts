import { Client } from "@modelcontextprotocol/sdk/client/index.js";
import { StdioClientTransport } from "@modelcontextprotocol/sdk/client/stdio.js";

async function runClient() {
  // Configurar el transporte para lanzar el subproceso del servidor
  const transport = new StdioClientTransport({
    command: "node",
    args: ["dist/server.js"],
  });

  // Instanciar el cliente MCP
  const client = new Client(
    { name: "enterprise-audit-client", version: "1.0.0" },
    { capabilities: {} }
  );

  // Iniciar conexión y efectuar el handshake
  await client.connect(transport);
  console.log("Cliente conectado con éxito al servidor MCP.");

  // Descubrir herramientas expuestas
  const toolsList = await client.listTools();
  console.log("Herramientas detectadas:", toolsList.tools.map((t) => t.name));

  // Ejecutar herramienta de cálculo EBITDA
  const result = await client.callTool({
    name: "calculate_ebitda",
    arguments: { revenue: 5000000, operatingCosts: 3200000 },
  });
  console.log("Resultado de la herramienta:", result.content);

  // Desconectar cliente
  await client.close();
}

runClient().catch(console.error);
