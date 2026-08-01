# Rust Bridge Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Connect Dart UI to Rust core via flutter_rust_bridge v2.

**Architecture:** Expose `UnifiedParser` in `rust_core/src/api/mod.rs`. Generate bindings. Call from Dart `file_parser_service.dart`.

**Tech Stack:** Rust, Dart, flutter_rust_bridge v2.

## Global Constraints

Zero-backend offline execution.
Native deps minimal.

---

### Task 1: Add Dependencies

**Files:**
- Modify: `apps/flutter_client/pubspec.yaml`
- Modify: `native/rust_core/Cargo.toml`

**Interfaces:**
- Consumes: N/A
- Produces: flutter_rust_bridge ready in both environments.

- [ ] **Step 1: Add Dart deps**
```bash
cd apps/flutter_client
flutter pub add flutter_rust_bridge
flutter pub add -d flutter_rust_bridge_codegen
```

- [ ] **Step 2: Add Rust deps**
```bash
cd native/rust_core
cargo add flutter_rust_bridge@^2.0.0
```

- [ ] **Step 3: Commit**
```bash
git add apps/flutter_client/pubspec.yaml apps/flutter_client/pubspec.lock native/rust_core/Cargo.toml native/rust_core/Cargo.lock
git commit -m "chore: add flutter_rust_bridge deps"
```

### Task 2: Expose Parser API

**Files:**
- Modify: `native/rust_core/src/api/mod.rs`

**Interfaces:**
- Consumes: `crate::parser::UnifiedParser`
- Produces: `pub fn parse_file(path: String) -> ParsedDocument`

- [ ] **Step 1: Add function to api/mod.rs**
```rust
// In native/rust_core/src/api/mod.rs
use crate::parser::ParsedDocument;
use crate::parser::UnifiedParser;

pub fn parse_file(path: String) -> anyhow::Result<ParsedDocument> {
    UnifiedParser::parse(&path)
}
```

- [ ] **Step 2: Commit**
```bash
git add native/rust_core/src/api/mod.rs
git commit -m "feat(api): expose parse_file to bridge"
```

### Task 3: Generate Bridge and Connect Dart

**Files:**
- Modify: `apps/flutter_client/lib/src/features/library/file_parser_service.dart`
- Create: `apps/flutter_client/lib/src/rust/*`

**Interfaces:**
- Consumes: `parse_file` from Rust
- Produces: UI ready FileParserService

- [ ] **Step 1: Run codegen**
```bash
cd apps/flutter_client
flutter_rust_bridge_codegen generate --rust-root ../../native/rust_core
```

- [ ] **Step 2: Update dart service**
```dart
// In apps/flutter_client/lib/src/features/library/file_parser_service.dart
import '../../rust/api/mod.dart' as rust;
import '../../rust/frb_generated.dart';

class FileParserService {
  Future<void> init() async {
    await RustLib.init();
  }
  
  Future<rust.ParsedDocument> parseFile(String filePath) async {
    return await rust.parseFile(path: filePath);
  }
}
```

- [ ] **Step 3: Commit**
```bash
git add apps/flutter_client/lib/src
git commit -m "feat(ui): integrate generated rust bridge in parser service"
```
