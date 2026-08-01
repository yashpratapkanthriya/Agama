# Agama

Zero-Backend AI Speed Reading & Knowledge Platform.

## Requirements
- Rust (`cargo` 1.80+)
- Flutter SDK (3.22+)
- `flutter_rust_bridge_codegen` (`cargo install flutter_rust_bridge_codegen`)

## Quick Start

### 1. Build Rust Engine
```bash
cd native/rust_core
cargo build --release
```

### 2. Generate FFI Bindings
```bash
./scripts/generate_frb.sh
```

### 3. Run Flutter Application
```bash
cd apps/flutter_client
flutter pub get
flutter run
```

## Structure
- `native/rust_core`: Embedded Rust engine (AIP pacing, ORP redicle, SQLite `histvon`/`histbis`, Yrs CRDT).
- `apps/flutter_client`: Flutter Material 3 UI shell.
- `docs/`: SSOT architecture, database schema, sync specifications.
