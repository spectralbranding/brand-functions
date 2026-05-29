#!/usr/bin/env bash
# reproduce.sh — Validate every Brand Function against the JSON Schema
#
# Conforms to PUBLIC_MIRROR_STANDARD.md v1.0.0.
#
# This repository is a spec registry, not a computational pipeline: there are
# no figures or tables to regenerate from raw inputs. Reproduction here means
# verifying that every brands/<slug>/brand.json conforms to
# schema/brand-function-v1.schema.json.
#
# Usage:
#   ./reproduce.sh                 # Validate all brand.json files
#   ./reproduce.sh --check-only    # Verify dependencies; do not validate
#
# Dependencies: python3 with the `jsonschema` package (pip install jsonschema).
#
# Outputs:
#   output/logs/master_run.log      Pipeline run log
#   output/tables/validation.csv    One row per brand: slug, status, error

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_ROOT"

mkdir -p output/figures output/tables output/logs
LOG_FILE="output/logs/master_run.log"
TABLE_FILE="output/tables/validation.csv"

echo "==================================================" | tee -a "$LOG_FILE"
echo "Pipeline run: $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee -a "$LOG_FILE"
echo "Repo: $REPO_ROOT" | tee -a "$LOG_FILE"
echo "Git SHA: $(git rev-parse HEAD 2>/dev/null || echo 'not-a-repo')" | tee -a "$LOG_FILE"
echo "==================================================" | tee -a "$LOG_FILE"

CHECK_ONLY=0
for arg in "$@"; do
  case "$arg" in
    --check-only) CHECK_ONLY=1 ;;
    *) echo "Unknown flag: $arg"; exit 2 ;;
  esac
done

# 1. Dependency check
echo ">>> Checking dependencies..." | tee -a "$LOG_FILE"
if ! command -v python3 >/dev/null 2>&1; then
  echo "ERROR: python3 not found." | tee -a "$LOG_FILE"
  exit 1
fi
if ! python3 -c "import jsonschema" 2>/dev/null; then
  echo "ERROR: 'jsonschema' Python package not installed. Run: pip install jsonschema" | tee -a "$LOG_FILE"
  exit 1
fi

if [[ "$CHECK_ONLY" == "1" ]]; then
  echo ">>> Check-only mode; exiting before validation." | tee -a "$LOG_FILE"
  exit 0
fi

# 2. Validate every brands/<slug>/brand.json against the schema
echo ">>> Validating brand.json files against schema..." | tee -a "$LOG_FILE"
echo "slug,status,error" > "$TABLE_FILE"

python3 - "$TABLE_FILE" <<'PY' | tee -a "$LOG_FILE"
import csv, json, sys
from pathlib import Path
import jsonschema

repo = Path.cwd()
schema_path = repo / "schema" / "brand-function-v1.schema.json"
schema = json.loads(schema_path.read_text())
brand_dirs = sorted((repo / "brands").glob("*/brand.json"))

table_file = sys.argv[1]
total = 0
ok = 0
fail = 0
with open(table_file, "a", newline="") as fh:
    w = csv.writer(fh)
    for bf in brand_dirs:
        slug = bf.parent.name
        total += 1
        try:
            data = json.loads(bf.read_text())
            jsonschema.validate(data, schema)
            print(f"  PASS  {slug}")
            w.writerow([slug, "PASS", ""])
            ok += 1
        except Exception as e:
            msg = str(e).splitlines()[0]
            print(f"  FAIL  {slug}: {msg}")
            w.writerow([slug, "FAIL", msg])
            fail += 1

print(f"\nValidated {total} brand functions: {ok} pass, {fail} fail")
sys.exit(0 if fail == 0 else 1)
PY

echo "==================================================" | tee -a "$LOG_FILE"
echo "Pipeline complete: $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee -a "$LOG_FILE"
echo "Outputs: $(find output/figures output/tables -type f | wc -l | tr -d ' ') files" | tee -a "$LOG_FILE"
echo "==================================================" | tee -a "$LOG_FILE"
