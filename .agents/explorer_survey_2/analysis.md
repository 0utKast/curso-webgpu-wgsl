# Technical Specification & Protocol Architecture Report: Model Context Protocol (MCP)

**Author:** Explorer 2 (MCP Protocol Architect Explorer)  
**Date:** 2026-08-04  
**Target Audience:** Orchestrator & Technical Authors  
**Working Directory:** `/Volumes/MisAppsV/SearchMCP/.agents/explorer_survey_2`

---

## Executive Summary

The **Model Context Protocol (MCP)** is an open, standardized, stateful client-server protocol designed to decouple Large Language Model (LLM) hosts from external context providers (data sources, specialized execution tools, and prompt repositories). By replacing ad-hoc, proprietary $N \times M$ integration code with a unified $N + M$ protocol, MCP acts as the **"USB-C interface for AI integration"**.

This document details the topology, transport mechanisms, handshake lifecycle, core primitives (Tools, Resources, Prompts), JSON-RPC 2.0 wire protocol messages, and standard SDK implementation patterns in TypeScript (`@modelcontextprotocol/sdk`) and Python (`mcp`).

---

## 1. Protocol Topology & Roles

MCP defines a strict 3-tier architectural topology:

```
+-------------------------------------------------------------------+
|                            HOST                                   |
| (e.g., Claude Desktop, Cursor, VS Code, Sourcegraph Amp)         |
|                                                                   |
|   +-----------------------------------------------------------+   |
|   |                        CLIENT                             |   |
|   | (Manages 1:1 stateful connection, capability negotiation)  |   |
|   +----------------------------+------------------------------+   |
+--------------------------------|----------------------------------+
                                 |  JSON-RPC 2.0 (Stdio / SSE)
                                 v
+-------------------------------------------------------------------+
|                           SERVER                                  |
| (Exposes domain-specific capabilities: Tools, Resources, Prompts)  |
+-------------------------------------------------------------------+
```

### 1.1 Host
- **Definition:** The top-level application user interface or agent runtime environment (e.g., Claude Desktop, Cursor, IDE extensions).
- **Responsibilities:**
  - Manages the UI, user interactions, and security approvals.
  - Spawns or connects to MCP Server processes.
  - Controls LLM orchestration (sampling, context window assembly).
  - Enforces user confirmation for tool execution and resource access permissions.

### 1.2 Client
- **Definition:** The protocol handler residing inside (or tightly coupled with) the Host application.
- **Responsibilities:**
  - Maintains a **1:1 stateful connection** with an individual MCP Server.
  - Handles initial handshake protocol (`initialize` / `notifications/initialized`).
  - Negotiates capabilities and handles protocol versioning.
  - Serializes/deserializes JSON-RPC 2.0 messages over the transport layer.

### 1.3 Server
- **Definition:** An independent process or remote service providing structured capabilities to the Client.
- **Responsibilities:**
  - Exposes executable primitives: **Tools**, **Resources**, and **Prompts**.
  - Operates as a stateless or stateful capability provider.
  - Emits real-time notifications (e.g., resource updates, list changes) back to connected clients.

---

## 2. Transport Layer Mechanisms

MCP abstracts communication through a transport layer interface that handles raw message framing. The specification defines two primary standard transports:

### 2.1 Standard I/O (Stdio) Transport
- **Mechanics:** The Host launches the Server process locally via command line execution. Communication takes place over stdin (input) and stdout (output) using newline-delimited JSON-RPC 2.0 messages.
- **Logging Isolation:** Standard error (`stderr`) is strictly reserved for server logging, diagnostics, and debugging output. It is bypasses JSON-RPC parsing by the client.
- **Security:** Highly secure by default due to OS-level process boundaries and local-only access.

### 2.2 Server-Sent Events (SSE) Transport
- **Mechanics:** Designed for remote or HTTP-accessible servers.
  - **Downstream (Server -> Client):** The Client opens an HTTP GET request to an SSE endpoint (e.g., `/sse`), establishing a persistent event stream for receiving JSON-RPC messages from the server.
  - **Upstream (Client -> Server):** The Client transmits JSON-RPC requests via HTTP POST requests to an endpoint provided during SSE connection setup (e.g., `/message?sessionId=<id>`).
- **Use Case:** Remote microservices, cloud-hosted enterprise tools, containerized environments.

### 2.3 Custom / Streamable Transports
- MCP transport interfaces can be extended to WebSockets, Unix domain sockets, or memory buffers by implementing the base `Transport` interface (`send()`, `onmessage`, `onclose`, `onerror`).

---

## 3. Protocol Lifecycle & Handshake Flow

The MCP protocol lifecycle consists of four distinct phases: Handshake, Initialization Notification, Operational Phase, and Termination.

```
Client                                                 Server
  |                                                      |
  | -------------- initialize (Request) ---------------> |
  | <------------- initialize (Response) --------------  |
  |                                                      |
  | ---------- notifications/initialized -------------> |
  |                                                      |
  | ================= OPERATIONAL PHASE ================ |
  | (tools/list, tools/call, resources/read, etc.)       |
  |                                                      |
  | ----------------- Close / Exit --------------------> |
```

### 3.1 Handshake Protocol (`initialize`)
1. **Client Request (`initialize`):**
   - Transmits supported `protocolVersion` (e.g., `"2024-11-05"`).
   - Declares client capabilities (e.g., `roots`, `sampling`, `experimental`).
   - Identifies client software (`clientInfo` with `name` and `version`).
2. **Server Response:**
   - Returns agreed `protocolVersion`.
   - Declares server capabilities (e.g., `tools`, `resources`, `prompts`, `logging`).
   - Identifies server software (`serverInfo` with `name` and `version`).

### 3.2 Post-Handshake Notification (`notifications/initialized`)
- After receiving a successful `initialize` response, the Client **must** send a `notifications/initialized` message before invoking any operational RPC methods.
- The server does not reply to notifications.

### 3.3 Capability Negotiation Model

| Capability Category | Supported Features |
|---|---|
| **Server Capabilities** | `tools` (listChanged), `resources` (subscribe, listChanged), `prompts` (listChanged), `logging` |
| **Client Capabilities** | `roots` (listChanged), `sampling` (LLM completion forwarding), `experimental` |

---

## 4. Deep Dive into Primitives

MCP standardizes context sharing through three core primitives:

### 4.1 Tools (Executable Functions)
- **Model-Controlled:** The LLM decides when and how to execute tools based on prompt context and JSON Schemas.
- **Discovery:** `tools/list` returns available tool definitions including name, description, and an `inputSchema` compliant with JSON Schema Draft-07.
- **Execution:** `tools/call` executes the requested tool with specified parameters.
- **Output:** Returns an array of content items (e.g., text, image, embedded resource) and an optional `isError` flag.

### 4.2 Resources (Readable Data Sources)
- **Application/User-Controlled:** The Host or user attaches resources to the context window (files, API responses, database records, system logs).
- **Discovery:** `resources/list` returns discrete static resources; `resources/templates/list` returns parameterized URI templates (e.g., `postgres://{host}/{db}/{table}`).
- **Reading:** `resources/read` fetches content identified by a URI (`file:///...`, `http://...`, `custom://...`).
- **Pub/Sub Updates:** Clients can subscribe to resource updates via `resources/subscribe`; servers emit `notifications/resources/updated` when underlying data changes.

### 4.3 Prompts (Reusable Prompt Templates)
- **User-Controlled:** User-facing slash commands or prompt templates that construct standard structured context for tasks (e.g., `/code-review`, `/analyze-bug`).
- **Discovery:** `prompts/list` lists prompt definitions and arguments.
- **Fetching:** `prompts/get` expands a prompt template given concrete user arguments into role-based messages (`user`, `assistant`).

---

## 5. JSON-RPC 2.0 Message Examples (Exact & Valid Wire Format)

All MCP communications strictly adhere to the **JSON-RPC 2.0 specification**.

### 5.1 Protocol Handshake

#### `initialize` Request
```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "initialize",
  "params": {
    "protocolVersion": "2024-11-05",
    "capabilities": {
      "roots": {
        "listChanged": true
      },
      "sampling": {}
    },
    "clientInfo": {
      "name": "ClaudeDesktop",
      "version": "1.2.0"
    }
  }
}
```

#### `initialize` Response
```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": {
    "protocolVersion": "2024-11-05",
    "capabilities": {
      "tools": {
        "listChanged": true
      },
      "resources": {
        "subscribe": true,
        "listChanged": true
      },
      "prompts": {
        "listChanged": true
      },
      "logging": {}
    },
    "serverInfo": {
      "name": "EnterpriseDataServer",
      "version": "2.1.0"
    }
  }
}
```

#### `notifications/initialized` Notification
```json
{
  "jsonrpc": "2.0",
  "method": "notifications/initialized"
}
```

---

### 5.2 Tools Primitives

#### `tools/list` Request
```json
{
  "jsonrpc": "2.0",
  "id": 2,
  "method": "tools/list",
  "params": {}
}
```

#### `tools/list` Response
```json
{
  "jsonrpc": "2.0",
  "id": 2,
  "result": {
    "tools": [
      {
        "name": "calculate_sum",
        "description": "Calculates the sum of two numerical values",
        "inputSchema": {
          "type": "object",
          "properties": {
            "a": {
              "type": "number",
              "description": "First operand"
            },
            "b": {
              "type": "number",
              "description": "Second operand"
            }
          },
          "required": ["a", "b"]
        }
      }
    ]
  }
}
```

#### `tools/call` Request
```json
{
  "jsonrpc": "2.0",
  "id": 3,
  "method": "tools/call",
  "params": {
    "name": "calculate_sum",
    "arguments": {
      "a": 15,
      "b": 27
    }
  }
}
```

#### `tools/call` Response
```json
{
  "jsonrpc": "2.0",
  "id": 3,
  "result": {
    "content": [
      {
        "type": "text",
        "text": "42"
      }
    ],
    "isError": false
  }
}
```

---

### 5.3 Resources Primitives

#### `resources/list` Request
```json
{
  "jsonrpc": "2.0",
  "id": 4,
  "method": "resources/list",
  "params": {}
}
```

#### `resources/list` Response
```json
{
  "jsonrpc": "2.0",
  "id": 4,
  "result": {
    "resources": [
      {
        "uri": "file:///var/log/app.log",
        "name": "Application Production Log",
        "description": "Main application runtime log stream",
        "mimeType": "text/plain"
      }
    ]
  }
}
```

#### `resources/read` Request
```json
{
  "jsonrpc": "2.0",
  "id": 5,
  "method": "resources/read",
  "params": {
    "uri": "file:///var/log/app.log"
  }
}
```

#### `resources/read` Response
```json
{
  "jsonrpc": "2.0",
  "id": 5,
  "result": {
    "contents": [
      {
        "uri": "file:///var/log/app.log",
        "mimeType": "text/plain",
        "text": "[2026-08-04T14:00:00Z] INFO: Database connection established. Operations normal."
      }
    ]
  }
}
```

---

### 5.4 Prompts Primitives

#### `prompts/list` Request
```json
{
  "jsonrpc": "2.0",
  "id": 6,
  "method": "prompts/list",
  "params": {}
}
```

#### `prompts/list` Response
```json
{
  "jsonrpc": "2.0",
  "id": 6,
  "result": {
    "prompts": [
      {
        "name": "code_review",
        "description": "Generates a structured peer code review prompt",
        "arguments": [
          {
            "name": "language",
            "description": "Programming language of target snippet",
            "required": true
          },
          {
            "name": "code",
            "description": "Source code text to be reviewed",
            "required": true
          }
        ]
      }
    ]
  }
}
```

#### `prompts/get` Request
```json
{
  "jsonrpc": "2.0",
  "id": 7,
  "method": "prompts/get",
  "params": {
    "name": "code_review",
    "arguments": {
      "language": "TypeScript",
      "code": "const value: number = 42;"
    }
  }
}
```

#### `prompts/get` Response
```json
{
  "jsonrpc": "2.0",
  "id": 7,
  "result": {
    "description": "Structured code review evaluation context",
    "messages": [
      {
        "role": "user",
        "content": {
          "type": "text",
          "text": "Please review the following TypeScript code for best practices and security:\n\n```typescript\nconst value: number = 42;\n```"
        }
      }
    ]
  }
}
```

---

## 6. Official SDK Implementation Code Snippets

### 6.1 TypeScript SDK (`@modelcontextprotocol/sdk`)

#### Server Implementation (`server.ts`)
```typescript
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";

// Initialize high-level MCP Server
const server = new McpServer({
  name: "ts-mcp-demo-server",
  version: "1.0.0",
});

// 1. Register a Tool primitive
server.tool(
  "calculate_sum",
  "Calculates the sum of two numbers",
  {
    a: z.number().describe("First numerical parameter"),
    b: z.number().describe("Second numerical parameter"),
  },
  async ({ a, b }) => {
    const result = a + b;
    return {
      content: [
        {
          type: "text",
          text: String(result),
        },
      ],
    };
  }
);

// 2. Register a Resource primitive
server.resource(
  "app-log",
  "file:///var/log/app.log",
  async (uri) => ({
    contents: [
      {
        uri: uri.href,
        mimeType: "text/plain",
        text: "[2026-08-04T14:00:00Z] INFO: Server initialized successfully.",
      },
    ],
  })
);

// 3. Register a Prompt primitive
server.prompt(
  "code_review",
  {
    language: z.string().describe("Target language"),
    code: z.string().describe("Source code snippet"),
  },
  ({ language, code }) => ({
    messages: [
      {
        role: "user",
        content: {
          type: "text",
          text: `Perform a comprehensive code review for the following ${language} code:\n\n\`\`\`${language}\n${code}\n\`\`\``,
        },
      },
    ],
  })
);

// Launch server over Stdio transport
async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error("TypeScript MCP Server active on stdio.");
}

main().catch((err) => {
  console.error("Fatal server error:", err);
  process.exit(1);
});
```

#### Client Implementation (`client.ts`)
```typescript
import { Client } from "@modelcontextprotocol/sdk/client/index.js";
import { StdioClientTransport } from "@modelcontextprotocol/sdk/client/stdio.js";

async function main() {
  // Launch server process via stdio transport
  const transport = new StdioClientTransport({
    command: "node",
    args: ["dist/server.js"],
  });

  // Initialize Client instance
  const client = new Client(
    { name: "ts-mcp-demo-client", version: "1.0.0" },
    { capabilities: {} }
  );

  // Connect and execute negotiation handshake
  await client.connect(transport);
  console.log("Connected and negotiated session with MCP Server.");

  // Discover and call tools
  const tools = await client.listTools();
  console.log("Discovered Tools:", tools.tools.map((t) => t.name));

  const toolResult = await client.callTool({
    name: "calculate_sum",
    arguments: { a: 15, b: 27 },
  });
  console.log("Tool Result:", toolResult.content);

  // Read resource content
  const resourceData = await client.readResource({
    uri: "file:///var/log/app.log",
  });
  console.log("Resource Contents:", resourceData.contents);

  // Fetch prompt template
  const promptData = await client.getPrompt({
    name: "code_review",
    arguments: { language: "TypeScript", code: "const a = 10;" },
  });
  console.log("Prompt Messages:", promptData.messages);

  await client.close();
}

main().catch(console.error);
```

---

### 6.2 Python SDK (`mcp`)

#### Server Implementation (`server.py`)
```python
import sys
from mcp.server.fastmcp import FastMCP

# Initialize FastMCP Server helper
mcp = FastMCP("python-mcp-demo-server")

# 1. Register Tool Primitive
@mcp.tool()
def calculate_sum(a: float, b: float) -> float:
    """Calculates the sum of two numerical values."""
    return a + b

# 2. Register Resource Primitive
@mcp.resource("file:///var/log/app.log")
def get_app_log() -> str:
    """Returns the content of the system application log."""
    return "[2026-08-04T14:00:00Z] INFO: Python MCP Server running smoothly."

# 3. Register Prompt Primitive
@mcp.prompt()
def code_review(language: str, code: str) -> str:
    """Generates a structured prompt for reviewing code."""
    return f"Perform a comprehensive code review for the following {language} snippet:\n\n```{language}\n{code}\n```"

if __name__ == "__main__":
    # Run server via standard I/O (stdio)
    mcp.run(transport="stdio")
```

#### Client Implementation (`client.py`)
```python
import asyncio
from mcp import ClientSession, StdioServerParameters
from mcp.client.stdio import stdio_client

async def main():
    # Define execution parameters for the server process
    server_params = StdioServerParameters(
        command="python",
        args=["server.py"],
        env=None
    )

    # Establish transport stream and client session context
    async with stdio_client(server_params) as (read, write):
        async with ClientSession(read, write) as session:
            # Complete initialization handshake
            await session.initialize()
            print("Python MCP Client initialized successfully.")

            # 1. List and execute tools
            tools_list = await session.list_tools()
            print("Tools discovered:", [t.name for t in tools_list.tools])

            tool_result = await session.call_tool(
                "calculate_sum",
                arguments={"a": 15.0, "b": 27.0}
            )
            print("Tool call output:", tool_result.content)

            # 2. List and read resources
            resources_list = await session.list_resources()
            print("Resources discovered:", [r.uri for r in resources_list.resources])

            resource_content = await session.read_resource("file:///var/log/app.log")
            print("Resource content:", resource_content)

            # 3. List and fetch prompt template
            prompts_list = await session.list_prompts()
            print("Prompts discovered:", [p.name for p in prompts_list.prompts])

            prompt_res = await session.get_prompt(
                "code_review",
                arguments={"language": "Python", "code": "def hello(): pass"}
            )
            print("Expanded prompt messages:", prompt_res.messages)

if __name__ == "__main__":
    asyncio.run(main())
```

---

## 7. Architectural Comparative Matrix

| Feature / Primitive | **Tools** | **Resources** | **Prompts** |
|---|---|---|---|
| **Initiator / Control** | Model-controlled (LLM decides call) | App/User-controlled (Context injection) | User-controlled (Explicit template invocation) |
| **Primary Method** | `tools/call` | `resources/read` | `prompts/get` |
| **Discovery Method** | `tools/list` | `resources/list` / `resources/templates/list` | `prompts/list` |
| **Parameterization** | JSON Schema (`inputSchema`) | URI parameterization (`{var}`) | Named arguments list |
| **Notification Support**| `notifications/tools/list_changed` | `notifications/resources/updated` | `notifications/prompts/list_changed` |
| **Side Effects** | Permitted (Execute actions, compute) | Read-only (Fetch state data) | Read-only (Template expansion) |

---

## 8. Summary of Findings for Synthesis

1. **Topology:** 3 distinct roles (Host, Client, Server). Client maintains 1:1 stateful connection to Server. Host manages LLM + UI + Security approvals.
2. **Transports:** Stdio (process-based, local, stderr for logs) and SSE (HTTP-based, remote streaming + POST).
3. **Lifecycle:** Strict 4-phase sequence: Handshake (`initialize` request -> `initialize` response) -> Initialized Notification (`notifications/initialized`) -> Operational Phase -> Shutdown.
4. **Primitives:** Tools (executable functions with JSON Schema input), Resources (contextual readable URIs with subscribe updates), Prompts (parameterized message generation).
5. **Standard Compliance:** All SDKs (@modelcontextprotocol/sdk for TS, mcp for Python) generate standard JSON-RPC 2.0 frames over stdout or HTTP.

---
*Report stored at `/Volumes/MisAppsV/SearchMCP/.agents/explorer_survey_2/analysis.md`.*
