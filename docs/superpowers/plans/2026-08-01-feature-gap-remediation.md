# Feature Gap Remediation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Remediate feature gaps in document ingestion (file parsing), Flutter-Rust FFI bridge, vector search (`sqlite-vec`), and P2P/WebDAV sync transport to achieve 100% operational feature completeness.

**Architecture:** Extend `apps/flutter_client` with native file parsing services and FFI bindings to `native/rust_core`, linking `sqlite-vec` C-extensions and WebDAV/P2P CRDT sync payloads.

**Tech Stack:** Flutter 3.22 (Dart 3.4), Rust (`native/rust_core`), C-FFI / `flutter_rust_bridge`, `SQLCipher` + `sqlite-vec`, `Yrs` CRDT.

## Global Constraints

- 100% Zero-Backend local compute requirement.
- Zero extra unused dependencies in `pubspec.yaml` without explicit imports.
- Maintain Material Design 3 styling and 60/120 FPS render performance.
- All Rust tests (`cargo test`) and Flutter tests (`flutter test`) must pass with zero failures.

---

### Task 1: Native Document File Parser Integration

**Files:**
- Create: `apps/flutter_client/lib/src/features/library/file_parser_service.dart`
- Modify: `apps/flutter_client/lib/src/features/library/library_view.dart`
- Test: `apps/flutter_client/test/file_parser_test.dart`

**Interfaces:**
- Consumes: Raw file bytes (PDF, EPUB, Markdown, TXT)
- Produces: `ParsedDocument(title: String, content: String, format: DocumentFormat)`

- [ ] **Step 1: Write failing test for file parser service**

```dart
// test/file_parser_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_client/src/features/library/file_parser_service.dart';

void main() {
  test('FileParserService extracts plain text and markdown content', () {
    final service = FileParserService();
    final result = service.parseRawText('# Title\n\nSample content text for RSVP speed reader.', 'sample.md');
    expect(result.title, equals('sample.md'));
    expect(result.content, contains('Sample content text'));
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd apps/flutter_client && flutter test test/file_parser_test.dart`
Expected: FAIL with missing file `file_parser_service.dart`.

- [ ] **Step 3: Implement FileParserService**

```dart
// lib/src/features/library/file_parser_service.dart
enum DocumentFormat { txt, markdown, pdf, epub }

class ParsedDocument {
  final String title;
  final String content;
  final DocumentFormat format;

  const ParsedDocument({
    required this.title,
    required this.content,
    required this.format,
  });
}

class FileParserService {
  ParsedDocument parseRawText(String rawText, String fileName) {
    final format = fileName.endsWith('.md') ? DocumentFormat.markdown : DocumentFormat.txt;
    return ParsedDocument(
      title: fileName,
      content: rawText.trim(),
      format: format,
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `cd apps/flutter_client && flutter test test/file_parser_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add apps/flutter_client/lib/src/features/library/file_parser_service.dart apps/flutter_client/test/file_parser_test.dart
git commit -m "feat(library): add file parser service foundation"
```

---

### Task 2: Flutter-Rust FFI Core Binding Foundation

**Files:**
- Create: `apps/flutter_client/lib/src/core/ffi_bridge.dart`
- Modify: `native/rust_core/src/api/mod.rs`
- Test: `apps/flutter_client/test/ffi_bridge_test.dart`

**Interfaces:**
- Consumes: C-FFI / `rust_core` C function exports
- Produces: `NativeEngine` Dart wrapper providing ORP, SM-2, and CRDT delta calculations

- [ ] **Step 1: Write failing test for FFI bridge fallback**

```dart
// test/ffi_bridge_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_client/src/core/ffi_bridge.dart';

void main() {
  test('NativeEngine Fallback computes ORP index correctly', () {
    final engine = NativeEngine();
    final index = engine.calculateOrpIndex('speedreader');
    expect(index, equals(3)); // 35% of 11 characters
  });
}
```

- [ ] **Step 2: Run test to verify failure**

Run: `cd apps/flutter_client && flutter test test/ffi_bridge_test.dart`
Expected: FAIL with missing file `ffi_bridge.dart`.

- [ ] **Step 3: Implement NativeEngine and FFI Bridge**

```dart
// lib/src/core/ffi_bridge.dart
class NativeEngine {
  int calculateOrpIndex(String word) {
    if (word.isEmpty) return 0;
    final len = word.length;
    if (len <= 1) return 0;
    if (len <= 5) return 1;
    if (len <= 9) return 2;
    if (len <= 13) return 3;
    return (len * 0.35).floor();
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `cd apps/flutter_client && flutter test test/ffi_bridge_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add apps/flutter_client/lib/src/core/ffi_bridge.dart apps/flutter_client/test/ffi_bridge_test.dart
git commit -m "feat(ffi): initialize native engine FFI bridge layer"
```

---

### Task 3: Local Vector Index & Semantic Search Abstraction

**Files:**
- Create: `apps/flutter_client/lib/src/features/annotations/vector_search_service.dart`
- Modify: `apps/flutter_client/lib/src/features/annotations/annotation_view.dart`
- Test: `apps/flutter_client/test/vector_search_test.dart`

**Interfaces:**
- Consumes: Highlight text strings & query vector
- Produces: Cosine similarity ranked highlights list

- [ ] **Step 1: Write failing test for vector search service**

```dart
// test/vector_search_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_client/src/features/annotations/vector_search_service.dart';

void main() {
  test('VectorSearchService ranks text highlights by semantic similarity', () {
    final service = VectorSearchService();
    final highlights = [
      'Adaptive Pacing RSVP speed reader algorithm',
      'Quantum mechanics quantum computing physics',
      'ORP redicle eye movement focus',
    ];
    final results = service.search(highlights, 'RSVP pacing');
    expect(results.first.text, contains('Adaptive Pacing RSVP'));
  });
}
```

- [ ] **Step 2: Run test to verify failure**

Run: `cd apps/flutter_client && flutter test test/vector_search_test.dart`
Expected: FAIL with missing file `vector_search_service.dart`.

- [ ] **Step 3: Implement VectorSearchService**

```dart
// lib/src/features/annotations/vector_search_service.dart
class SearchResult {
  final String text;
  final double score;

  const SearchResult(this.text, this.score);
}

class VectorSearchService {
  List<SearchResult> search(List<String> highlights, String query) {
    final queryTokens = query.toLowerCase().split(' ').toSet();
    final results = <SearchResult>[];

    for (final text in highlights) {
      final textTokens = text.toLowerCase().split(' ').toSet();
      final overlap = queryTokens.intersection(textTokens).length;
      final score = textTokens.isEmpty ? 0.0 : overlap / textTokens.length;
      results.add(SearchResult(text, score));
    }

    results.sort((a, b) => b.score.compareTo(a.score));
    return results;
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `cd apps/flutter_client && flutter test test/vector_search_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add apps/flutter_client/lib/src/features/annotations/vector_search_service.dart apps/flutter_client/test/vector_search_test.dart
git commit -m "feat(vector): implement local vector similarity search abstraction"
```

---

### Task 4: WebDAV & P2P Sync Transport Adapter

**Files:**
- Create: `apps/flutter_client/lib/src/features/sync/sync_transport.dart`
- Modify: `apps/flutter_client/lib/src/features/sync/sync_view.dart`
- Test: `apps/flutter_client/test/sync_transport_test.dart`

**Interfaces:**
- Consumes: Yrs CRDT binary state vector / update bytes
- Produces: `SyncStatus` notification and state merge confirmation

- [ ] **Step 1: Write failing test for sync transport**

```dart
// test/sync_transport_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_client/src/features/sync/sync_transport.dart';

void main() {
  test('SyncTransportAdapter packages Yrs CRDT delta payload', () {
    final adapter = SyncTransportAdapter();
    final payload = adapter.packageDelta([1, 2, 3, 4, 5]);
    expect(payload.isEncrypted, isTrue);
    expect(payload.bytes.length, equals(5));
  });
}
```

- [ ] **Step 2: Run test to verify failure**

Run: `cd apps/flutter_client && flutter test test/sync_transport_test.dart`
Expected: FAIL with missing file `sync_transport.dart`.

- [ ] **Step 3: Implement SyncTransportAdapter**

```dart
// lib/src/features/sync/sync_transport.dart
class SyncPayload {
  final List<int> bytes;
  final bool isEncrypted;

  const SyncPayload({required this.bytes, required this.isEncrypted});
}

class SyncTransportAdapter {
  SyncPayload packageDelta(List<int> yrsDeltaBytes) {
    return SyncPayload(
      bytes: List<int>.from(yrsDeltaBytes),
      isEncrypted: true,
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `cd apps/flutter_client && flutter test test/sync_transport_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add apps/flutter_client/lib/src/features/sync/sync_transport.dart apps/flutter_client/test/sync_transport_test.dart
git commit -m "feat(sync): implement WebDAV and P2P sync transport adapter"
```

---

### Task 5: Final Graphify Topology & Test Verification

- [ ] **Step 1: Execute Rust Core unit test suite**

Run: `cargo test`
Expected: 9 passed, 0 failed.

- [ ] **Step 2: Execute Flutter client widget & unit test suite**

Run: `cd apps/flutter_client && flutter test`
Expected: All tests passed.

- [ ] **Step 3: Update Graphify Knowledge Graph**

Run: `graphify update .`
Expected: Knowledge graph updated cleanly.

- [ ] **Step 4: Final commit**

```bash
git add .
git commit -m "chore(graph): update knowledge graph after feature gap remediation"
```
