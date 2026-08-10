#!/usr/bin/env bash

set -euo pipefail

kit_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
staged_kit_dir=""

stage_kit() {
  staged_kit_dir="$(mktemp -d "${TMPDIR:-/tmp}/muse-code-sbx-kit.XXXXXX")"

  install -m 0644 "$kit_dir/spec.yaml" "$staged_kit_dir/spec.yaml"

  # A kit artifact contains only its manifest and optional static files. Do not
  # stage repository metadata, CI configuration, or documentation.
  if [[ -d "$kit_dir/files" ]]; then
    cp -R "$kit_dir/files" "$staged_kit_dir/files"
  fi

  sbx kit validate "$staged_kit_dir"
}

cleanup_staged_kit() {
  if [[ -n "$staged_kit_dir" ]]; then
    rm -rf -- "$staged_kit_dir"
  fi
}
