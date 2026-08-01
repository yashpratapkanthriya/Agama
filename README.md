# Agama

Zero-Backend AI Speed Reading & Knowledge Platform.

---

## Requirements
- Rust (`cargo` 1.80+)
- Flutter SDK (3.22+)
- `flutter_rust_bridge_codegen` (`cargo install flutter_rust_bridge_codegen`)

---

## Quick Start

### 1. Build & Test Rust Engine
```bash
cd native/rust_core
cargo test
cargo build --release
```

### 2. Generate FFI Bindings
```bash
./scripts/generate_frb.sh
```

### 3. Analyze & Run Flutter Application
```bash
cd apps/flutter_client
flutter pub get
flutter analyze
flutter test
flutter run
```

---

## Database Versioning, Migrations & Rollback Workflow

The platform utilizes a local-first **SQLCipher + sqlite-vec** database with 17-character `histvon` timestamping and active marker `histbis = '9999'`.

### 1. Schema Versioning (`PRAGMA user_version`)
- Tracked via `PRAGMA user_version`.
- Managed inside `DatabaseEngine::init_schema()` in `native/rust_core/src/db/mod.rs`.

### 2. Pushing Schema Updates
1. Define new tables or columns in `native/rust_core/src/db/mod.rs`.
2. Add migration block under `PRAGMA user_version` increment.
3. Run `cargo test` and `flutter test` to verify.
4. Commit with semantic message: `feat(db): add V<N> schema update for <feature>`.

### 3. Data Rollbacks (Zero Data Loss)
Because entity primary keys are composite `(id, histvon)`, historical row versions are preserved:
```sql
-- Step 1: Deactivate unwanted current version
UPDATE documents SET histbis = '<current_17_char_timestamp>' WHERE id = ? AND histbis = '9999';

-- Step 2: Reactivate previous historical version
UPDATE documents SET histbis = '9999' WHERE id = ? AND histvon = '<desired_previous_timestamp>';
```

For detailed DDL schemas and historization specs, see:
📄 [`docs/schema.md`](file:///Users/yashpratap/Documents/GitHub/Agama/docs/schema.md) & [`CLAUDE.md`](file:///Users/yashpratap/Documents/GitHub/Agama/CLAUDE.md)

---

## Repository Structure
- `native/rust_core`: Embedded Rust core (AIP pacing, ONNX complexity, ORP redicle, SQLite `histvon`/`histbis`, Yrs CRDT sync engine).
- `apps/flutter_client`: Multi-platform Flutter Material 3 UI shell (RSVP, Guided Highlighting, Bionic Fixation, Annotations, SM-2 Flashcards).
- `docs/`: Master Architecture (`SAD.md`), Master Implementation (`complete_end_to_end_implementation.md`), Database Schema (`schema.md`), Sync Spec (`decentralized_sync_architecture.md`).
- `CLAUDE.md`: Single Source of Truth agent memory, Superpowers workflows, Caveman/Ponytail rules, and testing standards.
