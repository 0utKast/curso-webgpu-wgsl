#!/usr/bin/env python3
"""
Empirical verification script for Challenger 2:
1. Validates mathematical model N x M vs N + M, example N=10, M=20, and percentage reduction.
2. Parses tutorial Markdown to extract Mermaid diagrams and validates them.
"""

import sys
import os
import re
import subprocess

def test_math_model():
    print("=== TEST 1: Mathematical Model Verification ===")
    N = 10
    M = 20
    
    # Ad-hoc integration count
    ad_hoc_count = N * M
    expected_ad_hoc = 200
    assert ad_hoc_count == expected_ad_hoc, f"Expected {expected_ad_hoc}, got {ad_hoc_count}"
    
    # MCP integration count
    mcp_count = N + M
    expected_mcp = 30
    assert mcp_count == expected_mcp, f"Expected {expected_mcp}, got {mcp_count}"
    
    # Percentage reduction
    reduction = (ad_hoc_count - mcp_count) / ad_hoc_count
    expected_reduction = 0.85
    assert abs(reduction - expected_reduction) < 1e-6, f"Expected {expected_reduction}, got {reduction}"
    
    print(f"PASS: N x M = {N} * {M} = {ad_hoc_count}")
    print(f"PASS: N + M = {N} + {M} = {mcp_count}")
    print(f"PASS: Reduction = {reduction * 100:.1f}%")
    return True

def test_mermaid_syntax():
    print("\n=== TEST 2: Mermaid Diagram Extraction & Validation ===")
    doc_path = "/Volumes/MisAppsV/SearchMCP/tutorial_mcp/tutorial_introduccion_mcp.md"
    with open(doc_path, "r", encoding="utf-8") as f:
        content = f.read()
    
    mermaid_blocks = re.findall(r"```mermaid\n(.*?)```", content, re.DOTALL)
    print(f"Found {len(mermaid_blocks)} Mermaid diagram block(s) in tutorial document.")
    assert len(mermaid_blocks) == 2, f"Expected 2 mermaid blocks, found {len(mermaid_blocks)}"
    
    scratch_dir = "/Volumes/MisAppsV/SearchMCP/.agents/challenger_2/scratch"
    os.makedirs(scratch_dir, exist_ok=True)
    
    all_passed = True
    for idx, block in enumerate(mermaid_blocks, start=1):
        mmd_file = os.path.join(scratch_dir, f"test_diagram_{idx}.mmd")
        svg_file = os.path.join(scratch_dir, f"test_diagram_{idx}.svg")
        
        with open(mmd_file, "w", encoding="utf-8") as f:
            f.write(block)
            
        print(f"Testing Diagram {idx} ({mmd_file})...")
        cmd = ["npx", "-y", "@mermaid-js/mermaid-cli", "-i", mmd_file, "-o", svg_file]
        res = subprocess.run(cmd, capture_output=True, text=True)
        
        if res.returncode == 0 and os.path.exists(svg_file) and os.path.getsize(svg_file) > 0:
            print(f"PASS: Diagram {idx} compiled successfully to SVG ({os.path.getsize(svg_file)} bytes).")
        else:
            print(f"FAIL: Diagram {idx} failed to compile.")
            print("Stderr:", res.stderr)
            print("Stdout:", res.stdout)
            all_passed = False
            
    return all_passed

if __name__ == "__main__":
    math_ok = test_math_model()
    mermaid_ok = test_mermaid_syntax()
    
    if math_ok and mermaid_ok:
        print("\nALL VERIFICATION TESTS PASSED SUCCESSFULLY!")
        sys.exit(0)
    else:
        print("\nSOME VERIFICATION TESTS FAILED!")
        sys.exit(1)
