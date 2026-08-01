#!/usr/bin/env bash
set -euo pipefail

echo "==> Building native Rust core library..."
cd native/rust_core
cargo build --release
echo "==> Native build complete."
