#!/usr/bin/env bash
set -euo pipefail

kit_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
sandbox="${1:-muse-current}"

if [[ $# -gt 0 ]]; then
  shift
fi

exec sbx run --kit "$kit_dir" "$sandbox" "$@"
