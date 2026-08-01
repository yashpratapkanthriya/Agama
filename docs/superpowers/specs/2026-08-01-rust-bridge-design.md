# Rust Bridge Setup Design

## Purpose
Connect the Dart UI (`apps/flutter_client`) to the Rust core (`native/rust_core`) using `flutter_rust_bridge` (v2), starting with the document parser API.

## Architecture & Components
1. **Rust API (`native/rust_core/src/api/mod.rs`)**
   - Add `pub fn parse_file(path: String) -> crate::parser::ParsedDocument`.
   - Exposes `UnifiedParser` functionality to Dart.
2. **Bridge Generation**
   - Run `flutter_rust_bridge_codegen generate` to build bindings in `lib/src/rust/api/mod.dart`.
3. **Dart Service (`lib/src/features/library/file_parser_service.dart`)**
   - Import generated rust bridge.
   - Replace fake text extraction with `parseFile(path)`.

## Data Flow
- User picks a file (PDF/EPUB) in UI.
- Dart passes the absolute file path (String) to Rust via the generated bridge.
- Rust reads the file, parses content using `epub_parser` or `TextParser`.
- Rust returns a `ParsedDocument` struct across FFI.
- Dart receives `ParsedDocument` and loads it into the UI.
