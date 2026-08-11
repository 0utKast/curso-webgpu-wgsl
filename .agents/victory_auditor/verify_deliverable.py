import re
import json
import ast
import os
import subprocess
import sys

TARGET_FILE = "/Volumes/MisAppsV/SearchMCP/tutorial_mcp/tutorial_introduccion_mcp.md"

def run_verification():
    results = {}
    print(f"=== INDEPENDENT VERIFICATION OF {TARGET_FILE} ===")

    if not os.path.exists(TARGET_FILE):
        print("FAIL: Target file does not exist.")
        sys.exit(1)

    with open(TARGET_FILE, "r", encoding="utf-8") as f:
        content = f.read()
        lines = content.splitlines()

    print(f"File size: {len(content)} bytes, {len(lines)} lines")

    # 1. Spanish Language Check
    spanish_keywords = ["Resumen", "Ejecutivo", "Introducción", "dilema", "interoperabilidad", "Problema", "Integración", "Solución", "Estándar", "Arquitectura", "Protocolo", "Primitivas", "Fundamentales", "Ejemplos", "Código", "Mensajes", "Bibliografía", "Citas", "desarrollo", "herramientas"]
    spanish_matches = sum(1 for kw in spanish_keywords if kw in content)
    results['spanish_language'] = (spanish_matches >= 15)
    print(f"Spanish Language Check: Matches {spanish_matches}/15 required keywords -> {'PASS' if results['spanish_language'] else 'FAIL'}")

    # 2. Check 7 Required Sections
    required_sections = [
        "1. Resumen Ejecutivo e Introducción",
        "2. El Problema de Integración N x M",
        "3. La Solución Estándar (N + M)",
        "4. Arquitectura del Protocolo",
        "5. Primitivas Fundamentales",
        "6. Ejemplos de Código y Mensajes JSON-RPC",
        "7. Bibliografía y Citas de O'Reilly"
    ]
    sections_found = []
    for sec in required_sections:
        found = any(sec in line for line in lines)
        sections_found.append((sec, found))
        print(f"Section Check [{sec}]: {'FOUND' if found else 'MISSING'}")
    results['all_sections_present'] = all(found for sec, found in sections_found)

    # 3. Check for Placeholders / Untested / TODOs (with word boundaries)
    prohibited_patterns = [r"\bTODO\b", r"\bTBD\b", r"\bFIXME\b", r"\bPLACEHOLDER\b", r"\bTEMP\b", r"Lorem ipsum"]
    forbidden_matches = []
    for pat in prohibited_patterns:
        matches = re.findall(pat, content, re.IGNORECASE)
        if matches:
            forbidden_matches.append((pat, len(matches)))
    results['no_placeholders'] = (len(forbidden_matches) == 0)
    print(f"Placeholder / Prohibited Pattern Check: {forbidden_matches} -> {'PASS' if results['no_placeholders'] else 'FAIL'}")

    # 4. Check N x M vs N + M Analysis
    nxm_mentions = len(re.findall(r"N\s*[xX×]\s*M", content))
    npm_mentions = len(re.findall(r"N\s*\+\s*M", content))
    usbc_mentions = len(re.findall(r"USB-C", content, re.IGNORECASE))
    results['nxm_analysis'] = (nxm_mentions >= 3 and npm_mentions >= 3 and usbc_mentions >= 1)
    print(f"N x M vs N + M Analysis Check: N x M count={nxm_mentions}, N + M count={npm_mentions}, USB-C count={usbc_mentions} -> {'PASS' if results['nxm_analysis'] else 'FAIL'}")

    # 5. Mermaid Diagrams Check
    mermaid_blocks = re.findall(r"```mermaid\n(.*?)\n```", content, re.DOTALL)
    print(f"Mermaid Blocks Found: {len(mermaid_blocks)}")
    valid_mermaid = 0
    for idx, block in enumerate(mermaid_blocks):
        block_clean = block.strip()
        if block_clean.startswith("flowchart") or block_clean.startswith("graph") or block_clean.startswith("sequenceDiagram"):
            valid_mermaid += 1
            print(f"  Mermaid Diagram {idx+1}: Valid type ({block_clean.split()[0]})")
        else:
            print(f"  Mermaid Diagram {idx+1}: Unknown type start '{block_clean[:20]}'")
    results['mermaid_diagrams'] = (len(mermaid_blocks) >= 2 and valid_mermaid >= 2)
    print(f"Mermaid Diagrams Verdict: {'PASS' if results['mermaid_diagrams'] else 'FAIL'}")

    # 6. JSON-RPC Message Payload Validation
    json_blocks = re.findall(r"```json\n(.*?)\n```", content, re.DOTALL)
    total_json_payloads = 0
    invalid_payloads = []

    for bidx, block in enumerate(json_blocks):
        # Extract all JSON objects bounded by { ... }
        # To accurately parse nested JSON, find balanced braces
        start = 0
        while True:
            pos = block.find('{', start)
            if pos == -1:
                break
            depth = 0
            end = pos
            for i in range(pos, len(block)):
                if block[i] == '{':
                    depth += 1
                elif block[i] == '}':
                    depth -= 1
                    if depth == 0:
                        end = i
                        break
            if depth == 0:
                json_str = block[pos:end+1]
                try:
                    parsed = json.loads(json_str)
                    total_json_payloads += 1
                except Exception as e:
                    invalid_payloads.append((bidx+1, str(e), json_str[:40]))
                start = end + 1
            else:
                start = pos + 1

    results['valid_json_messages'] = (total_json_payloads >= 10 and len(invalid_payloads) == 0)
    print(f"JSON-RPC Message Payloads: {total_json_payloads} valid payloads, {len(invalid_payloads)} invalid -> {'PASS' if results['valid_json_messages'] else 'FAIL'}")

    # 7. Python SDK Code Snippet Syntax Validation
    python_blocks = re.findall(r"```python\n(.*?)\n```", content, re.DOTALL)
    valid_python = 0
    for idx, py_code in enumerate(python_blocks):
        try:
            ast.parse(py_code)
            valid_python += 1
            print(f"  Python Snippet {idx+1}: Valid Syntax")
        except SyntaxError as e:
            print(f"  Python Snippet {idx+1}: SyntaxError - {e}")

    results['python_syntax'] = (len(python_blocks) >= 2 and valid_python == len(python_blocks))
    print(f"Python SDK Snippets Verdict: {'PASS' if results['python_syntax'] else 'FAIL'}")

    # 8. TypeScript SDK Code Snippet Syntax Validation
    ts_blocks = re.findall(r"```typescript\n(.*?)\n```", content, re.DOTALL)
    valid_ts = 0
    for idx, ts_code in enumerate(ts_blocks):
        tmp_fname = f"/Volumes/MisAppsV/SearchMCP/.agents/victory_auditor/temp_check_{idx}.ts"
        with open(tmp_fname, "w") as f_ts:
            f_ts.write(ts_code)
        res = subprocess.run(["node", "--experimental-strip-types", "--check", tmp_fname], capture_output=True, text=True)
        if res.returncode == 0:
            valid_ts += 1
            print(f"  TypeScript Snippet {idx+1}: Valid Syntax")
        else:
            print(f"  TypeScript Snippet {idx+1}: Syntax Error -> {res.stderr}")
        if os.path.exists(tmp_fname):
            os.remove(tmp_fname)

    results['typescript_syntax'] = (len(ts_blocks) >= 2 and valid_ts == len(ts_blocks))
    print(f"TypeScript SDK Snippets Verdict: {'PASS' if results['typescript_syntax'] else 'FAIL'}")

    # 9. Clickable O'Reilly Links Verification
    oreilly_links = re.findall(r"\[([^\]]+)\]\((https?://[^\s\)]*oreilly\.com[^\s\)]*)\)", content)
    print(f"O'Reilly Clickable Links Found: {len(oreilly_links)}")
    results['oreilly_links'] = (len(oreilly_links) >= 10)
    print(f"O'Reilly Links Verdict ({len(oreilly_links)} >= 10): {'PASS' if results['oreilly_links'] else 'FAIL'}")

    # OVERALL SUMMARY
    print("\n=== FINAL VERIFICATION SUMMARY ===")
    all_pass = all(results.values())
    for k, v in results.items():
        print(f"  {k}: {'PASS' if v else 'FAIL'}")

    verdict = "VICTORY CONFIRMED" if all_pass else "VICTORY REJECTED"
    print(f"\nOVERALL AUDIT VERDICT: {verdict}")
    return verdict, results

if __name__ == "__main__":
    run_verification()
