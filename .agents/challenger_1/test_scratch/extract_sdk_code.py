import os
import re

target_path = "/Volumes/MisAppsV/SearchMCP/tutorial_mcp/tutorial_introduccion_mcp.md"

with open(target_path, "r", encoding="utf-8") as f:
    content = f.read()

# Extract TypeScript blocks
ts_pattern = r"```typescript\n(.*?)```"
ts_matches = re.findall(ts_pattern, content, re.DOTALL)

print(f"Found {len(ts_matches)} TypeScript code blocks.")
if len(ts_matches) >= 2:
    with open("server.ts", "w", encoding="utf-8") as f:
        f.write(ts_matches[0])
    with open("client.ts", "w", encoding="utf-8") as f:
        f.write(ts_matches[1])
    print("Wrote server.ts and client.ts")

# Extract Python blocks
py_pattern = r"```python\n(.*?)```"
py_matches = re.findall(py_pattern, content, re.DOTALL)

print(f"Found {len(py_matches)} Python code blocks.")
if len(py_matches) >= 2:
    with open("server.py", "w", encoding="utf-8") as f:
        f.write(py_matches[0])
    with open("client.py", "w", encoding="utf-8") as f:
        f.write(py_matches[1])
    print("Wrote server.py and client.py")
