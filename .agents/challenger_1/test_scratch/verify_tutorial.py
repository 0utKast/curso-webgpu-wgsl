import re
import json
import sys
import os

target_path = "/Volumes/MisAppsV/SearchMCP/tutorial_mcp/tutorial_introduccion_mcp.md"

with open(target_path, "r", encoding="utf-8") as f:
    lines = f.readlines()

code_blocks = []
in_block = False
block_lang = ""
block_lines = []
start_line = 0

for idx, line in enumerate(lines, 1):
    if line.startswith("```"):
        if not in_block:
            in_block = True
            block_lang = line.strip().lstrip("`").strip()
            block_lines = []
            start_line = idx + 1
        else:
            in_block = False
            code_blocks.append({
                "lang": block_lang,
                "start_line": start_line,
                "end_line": idx - 1,
                "content": "".join(block_lines)
            })
    elif in_block:
        block_lines.append(line)

print(f"Total code blocks found: {len(code_blocks)}")

json_blocks = [b for b in code_blocks if b["lang"] in ("json", "jsonc")]
ts_blocks = [b for b in code_blocks if b["lang"] in ("typescript", "ts")]
py_blocks = [b for b in code_blocks if b["lang"] in ("python", "py")]

print(f"JSON blocks: {len(json_blocks)}")
print(f"TS blocks: {len(ts_blocks)}")
print(f"Python blocks: {len(py_blocks)}")

# Validate JSON blocks
print("\n--- VALIDATING JSON BLOCKS ---")
for i, block in enumerate(json_blocks, 1):
    raw_content = block["content"]
    print(f"\nBlock #{i} (Lines {block['start_line']}-{block['end_line']}):")
    # Check strict JSON parse first
    try:
        data = json.loads(raw_content)
        print("  [SUCCESS] Strict JSON parse: PASSED")
    except Exception as e:
        print(f"  [FAIL] Strict JSON parse: FAILED ({e})")
        # Try stripping // comments to see if comments were the issue
        stripped = "\n".join([line for line in raw_content.splitlines() if not line.strip().startswith("//")])
        try:
            data = json.loads(stripped)
            print("  [INFO] JSON parse after stripping '//' comments: PASSED")
        except Exception as e2:
            print(f"  [FAIL] JSON parse after stripping comments: FAILED ({e2})")
            continue

    # If parsing (or stripped parsing) succeeded, check JSON-RPC 2.0 rules
    # Note: block might contain multiple JSON objects separated by comments!
    # Let's inspect objects in block
    objs = []
    if raw_content.strip().startswith("{"):
        # Split by comments or try multiple objects
        parts = [p.strip() for p in raw_content.split("//") if p.strip()]
        for p in raw_content.splitlines():
            pass

    # Let's write a helper to extract all JSON objects from raw text
    def extract_json_objects(text):
        results = []
        # find matching braces
        depth = 0
        start = -1
        for idx, ch in enumerate(text):
            if ch == '{':
                if depth == 0:
                    start = idx
                depth += 1
            elif ch == '}':
                depth -= 1
                if depth == 0 and start != -1:
                    obj_str = text[start:idx+1]
                    try:
                        results.append(json.loads(obj_str))
                    except Exception as err:
                        results.append({"_error": str(err), "_raw": obj_str})
                    start = -1
        return results

    objs = extract_json_objects(raw_content)
    print(f"  Extracted JSON objects count: {len(objs)}")
    for j, obj in enumerate(objs, 1):
        if "_error" in obj:
            print(f"  Object #{j}: PARSE ERROR: {obj['_error']}")
            continue
        print(f"  Object #{j}:")
        jsonrpc = obj.get("jsonrpc")
        msg_id = obj.get("id")
        method = obj.get("method")
        result = obj.get("result")
        error = obj.get("error")
        params = obj.get("params")

        print(f"    jsonrpc: {repr(jsonrpc)}")
        print(f"    id: {repr(msg_id)}")
        print(f"    method: {repr(method)}")
        print(f"    has params: {params is not None}")
        print(f"    has result: {result is not None}")
        print(f"    has error: {error is not None}")

        # JSON-RPC 2.0 validation checks
        if jsonrpc != "2.0":
            print(f"    [FAIL] Invalid jsonrpc version: {repr(jsonrpc)} (expected '2.0')")
        
        if method is not None:
            # Request or Notification
            if msg_id is None and not method.startswith("notifications/"):
                print(f"    [WARN/FAIL] Notification method '{method}' does not follow 'notifications/' or has no id")
            elif msg_id is not None:
                print(f"    [PASS] Request format valid")
            else:
                print(f"    [PASS] Notification format valid")
        elif result is not None or error is not None:
            # Response
            if msg_id is None:
                print(f"    [FAIL] Response object missing 'id' field")
            else:
                print(f"    [PASS] Response format valid")
        else:
            print(f"    [FAIL] Unknown JSON-RPC message type (neither method nor result/error)")
