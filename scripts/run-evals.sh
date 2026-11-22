#!/usr/bin/env bash
# Runs the standards plugin's evaluation suite on a workstation signed in to Claude Code.
#
# Usage: scripts/run-evals.sh [more claude plugin eval flags], from the repository root.
# For example, --case 'brainstorming-*' runs one skill's cases.
#
# A full run is about 100 sessions and about half an hour, and the command prices it near 27
# dollars. The cost cap stops a run that has gone wrong, and the command then exits 2. Results
# go to plugins/standards/evals/results/, which git ignores.
set -euo pipefail
claude plugin eval ./plugins/standards \
  --runs 6 --ablation none --threshold 0.8 \
  --model claude-fable-5-2 --judge-model claude-sonnet-5-5 \
  --scaffold --trust-plugin --no-publish -j 1 --max-cost-usd 35 \
  --output-dir plugins/standards/evals/results \
  --json plugins/standards/evals/results/latest.json "$@"
