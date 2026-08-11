import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";

// Inicializar la instancia del servidor MCP
const server = new McpServer({
  name: "enterprise-metrics-server",
  version: "1.0.0",
});

// 1. Registro de una Herramienta (Tool) con validación Zod
server.tool(
  "calculate_ebitda",
  "Calcula el EBITDA y margen operativo a partir de ingresos y costes.",
  {
    revenue: z.number().positive().describe("Ingresos totales en USD"),
    operatingCosts: z.number().positive().describe("Costes operativos en USD"),
  },
  async ({ revenue, operatingCosts }) => {
    const ebitda = revenue - operatingCosts;
    const margin = ((ebitda / revenue) * 100).toFixed(2);
    return {
      content: [
        {
          type: "text",
          text: `EBITDA Calculado: $${ebitda.toLocaleString()} USD | Margen Operativo: ${margin}%`,
        },
      ],
    };
  }
);

// 2. Registro de un Recurso pasivo (Resource)
server.resource(
  "system-log",
  "file:///var/log/app.log",
  async (uri) => ({
    contents: [
      {
        uri: uri.href,
        mimeType: "text/plain",
        text: "[2026-08-04T15:00:00Z] INFO: Servidor TypeScript MCP activo y procesando peticiones.",
      },
    ],
  })
);

// 3. Registro de una Plantilla de Prompt (Prompt)
server.prompt(
  "financial_audit",
  {
    quarter: z.string().describe("Trimestre fiscal (ej. Q1-2026)"),
  },
  ({ quarter }) => ({
    messages: [
      {
        role: "user",
        content: {
          type: "text",
          text: `Por favor analiza el informe financiero del trimestre ${quarter} utilizando las herramientas de cálculo EBITDA disponibles.`,
        },
      },
    ],
  })
);

// Conexión sobre transporte stdio
async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error("Servidor MCP TypeScript iniciado correctamente sobre stdio.");
}

main().catch((err) => {
  console.error("Error fatal en el servidor MCP:", err);
  process.exit(1);
});
