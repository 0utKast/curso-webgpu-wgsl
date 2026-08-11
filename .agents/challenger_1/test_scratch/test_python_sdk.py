import subprocess
import sys
import time

py_bin = "/Volumes/MisAppsV/SearchMCP/.agents/challenger_1/test_scratch/.py311venv/bin/python"

print("--- TESTING PYTHON SERVER SYNTAX AND IMPORTS ---")
res1 = subprocess.run([py_bin, "-c", "import server; print('server.py import success')"], capture_output=True, text=True, cwd="/Volumes/MisAppsV/SearchMCP/.agents/challenger_1/test_scratch")
print("server.py stdout:", res1.stdout)
print("server.py stderr:", res1.stderr)
print("server.py returncode:", res1.returncode)

print("\n--- TESTING PYTHON CLIENT SYNTAX AND IMPORTS ---")
res2 = subprocess.run([py_bin, "-c", "import client; print('client.py import success')"], capture_output=True, text=True, cwd="/Volumes/MisAppsV/SearchMCP/.agents/challenger_1/test_scratch")
print("client.py stdout:", res2.stdout)
print("client.py stderr:", res2.stderr)
print("client.py returncode:", res2.returncode)
