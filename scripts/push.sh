#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 registry/repository:tag" >&2
  exit 2
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/lib.sh"

stage_kit
trap cleanup_staged_kit EXIT

sbx kit push "$staged_kit_dir" "$1"
