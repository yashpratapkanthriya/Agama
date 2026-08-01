#!/usr/bin/env bash
set -euo pipefail

echo "==> Generating flutter_rust_bridge FFI code..."
flutter_rust_bridge_codegen generate \
  --rust-input native/rust_core/src/api/mod.rs \
  --dart-output apps/flutter_client/lib/src/rust/api/mod.dart \
  --rust-root native/rust_core
echo "==> FRB Code generation complete."
