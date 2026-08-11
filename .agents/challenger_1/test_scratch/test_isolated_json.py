import json

raw_blocks = [
    # Block 4 Request
    ('''{
  "jsonrpc": "2.0",
  "id": 2,
  "method": "tools/list",
  "params": {}
}''', "Block 4 tools/list Request"),
    # Block 4 Response
    ('''{
  "jsonrpc": "2.0",
  "id": 2,
  "result": {
    "tools": [
      {
        "name": "query_users",
        "description": "Consulta la tabla de usuarios filtrando por estado activo.",
        "inputSchema": {
          "type": "object",
          "properties": {
            "limit": {
              "type": "number",
              "description": "Número máximo de registros a retornar"
            }
          },
          "required": ["limit"]
        }
      }
    ]
  }
}''', "Block 4 tools/list Response"),
    # Block 5 Request
    ('''{
  "jsonrpc": "2.0",
  "id": 3,
  "method": "tools/call",
  "params": {
    "name": "query_users",
    "arguments": {
      "limit": 2
    }
  }
}''', "Block 5 tools/call Request"),
    # Block 5 Response
    ('''{
  "jsonrpc": "2.0",
  "id": 3,
  "result": {
    "content": [
      {
        "type": "text",
        "text": "[{\\"id\\": 101, \\"name\\": \\"Alice\\", \\"role\\": \\"Admin\\"}, {\\"id\\": 102, \\"name\\": \\"Bob\\", \\"role\\": \\"Engineer\\"}]"
      }
    ],
    "isError": false
  }
}''', "Block 5 tools/call Response"),
    # Block 6 Request
    ('''{
  "jsonrpc": "2.0",
  "id": 4,
  "method": "resources/read",
  "params": {
    "uri": "file:///var/log/syslog"
  }
}''', "Block 6 resources/read Request"),
    # Block 6 Response
    ('''{
  "jsonrpc": "2.0",
  "id": 4,
  "result": {
    "contents": [
      {
        "uri": "file:///var/log/syslog",
        "mimeType": "text/plain",
        "text": "[2026-08-04T15:00:00Z] SYSTEM OK: Servicio de base de datos respondiendo normalmente."
      }
    ]
  }
}''', "Block 6 resources/read Response"),
    # Block 7 Request
    ('''{
  "jsonrpc": "2.0",
  "id": 5,
  "method": "prompts/get",
  "params": {
    "name": "code_review",
    "arguments": {
      "language": "TypeScript"
    }
  }
}''', "Block 7 prompts/get Request"),
    # Block 7 Response
    ('''{
  "jsonrpc": "2.0",
  "id": 5,
  "result": {
    "description": "Plantilla de revisión de código para TypeScript",
    "messages": [
      {
        "role": "user",
        "content": {
          "type": "text",
          "text": "Por favor, realiza una auditoría de seguridad y estilo para el código TypeScript adjunto en la ventana de contexto."
        }
      }
    ]
  }
}''', "Block 7 prompts/get Response")
]

print("--- TESTING ISOLATED JSON OBJECTS ---")
for raw, name in raw_blocks:
    try:
        obj = json.loads(raw)
        print(f"[PASS] {name}: Valid JSON")
        # Validate fields
        jsonrpc = obj.get("jsonrpc")
        msg_id = obj.get("id")
        method = obj.get("method")
        result = obj.get("result")
        
        if jsonrpc != "2.0":
            print(f"  [FAIL] jsonrpc is not '2.0': {jsonrpc}")
        if method:
            if "params" not in obj:
                print(f"  [WARN] Request missing params")
        if result:
            if "id" not in obj:
                print(f"  [FAIL] Response missing id")
    except Exception as e:
        print(f"[FAIL] {name}: JSON Syntax Error: {e}")
