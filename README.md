# Agama

Zero-Backend AI Speed Reading & Knowledge Platform.

---

## Requirements
- Rust (`cargo` 1.80+)
- Flutter SDK (3.22+)
- `flutter_rust_bridge_codegen` (`cargo install flutter_rust_bridge_codegen`)

---

## Embedded Native Engine Runtime (Developer Note)

> **Do I need to start or run a separate Rust process/server before testing the app?**
>
> **NO!** The Rust core engine is **embedded directly inside the Flutter application process**. You do **not** need to launch any background daemon, local HTTP server, or separate Rust process.
>
> When you run `flutter run`, Flutter automatically compiles and links the native Rust engine (`.wasm` for Web, `.so` for Android, `.a` static framework for iOS, `.dylib` for macOS) directly into the application package via `flutter_rust_bridge` v2.
>
> Simply run `./scripts/generate_frb.sh` once if native FFI signatures change, then execute `flutter run -d <target>`.

---

## Cross-Platform Architecture Compatibility

Agama is engineered for **100% Zero-Backend Cross-Platform Compatibility** across Web, Android, iOS, macOS, Windows, and Linux.

- **Flutter UI Shell**: Universal Material 3 UI (`apps/flutter_client`).
- **Rust Core Engine**: Embedded compilation targets:
  - **Android**: `cargo build --target aarch64-linux-android` (`.so` JNI library)
  - **iOS**: `cargo build --target aarch64-apple-ios` (`.a` static framework)
  - **Web**: `wasm32-unknown-unknown` (`wasm-bindgen` WebAssembly compilation)
  - **Desktop**: macOS (`.dylib`), Windows (`.dll`), Linux (`.so`)

---

## Quick Start & Multi-Platform Commands

### 1. Build & Test Native Rust Engine Core
```bash
cd native/rust_core
cargo test
cargo build --release
```

### 2. Generate Cross-Platform FFI Bindings (`flutter_rust_bridge` v2)
```bash
./scripts/generate_frb.sh
```

---

### 3. Running & Testing by Platform Target

#### A. Web (Chrome / WebAssembly Target)
Test and launch the application in Google Chrome:
```bash
cd apps/flutter_client

# 1. Run Flutter Web application in Chrome
flutter run -d chrome

# 2. Build Web production distribution bundle
flutter build web --release
```

#### B. Android Target (Device or Emulator)
Launch an Android virtual device or connected device and run:
```bash
cd apps/flutter_client

# 1. Check connected Android devices or emulators
flutter devices

# 2. Start available Android emulator (if none active)
flutter emulators --launch <emulator_id>

# 3. Build & Run on Android
flutter run -d android

# 4. Build APK / App Bundle
flutter build apk --release
```

#### C. iOS Target (iPhone Simulator or Physical Device - macOS only)
Launch iOS Simulator and run:
```bash
cd apps/flutter_client

# 1. Open iOS Simulator
open -a Simulator

# 2. Check iOS Simulator device ID
flutter devices

# 3. Build & Run on iOS Simulator
flutter run -d ios

# 4. Build iOS IPA distribution bundle
flutter build ipa --release
```

#### D. Desktop Target (macOS / Windows / Linux)
```bash
cd apps/flutter_client
flutter run -d macos
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
- `apps/flutter_client`: Multi-platform Flutter Material 3 UI shell (RSVP, Guided Highlighting, Bionic Fixation, Annotations, SM-2 Flashcards, Sync, Analytics).
- `docs/`: Master Architecture (`SAD.md`), Master Implementation (`complete_end_to_end_implementation.md`), Database Schema (`schema.md`), Sync Spec (`decentralized_sync_architecture.md`).
- `CLAUDE.md`: Single Source of Truth agent memory, Superpowers workflows, Caveman/Ponytail rules, and testing standards.
