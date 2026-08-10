#!/usr/bin/env bash

set -euo pipefail

if [[ $# -gt 1 ]]; then
  echo "Usage: $0 [output.zip]" >&2
  exit 2
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/lib.sh"

output="${1:-$PWD/muse-code-sbx-kit.zip}"
stage_kit
trap cleanup_staged_kit EXIT

sbx kit pack "$staged_kit_dir" -o "$output"
