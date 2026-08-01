# Vector Search & Yrs CRDT Sync Outbox Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement embedded vector similarity search over document chunks (`sqlite-vec`) and decentralized Yrs CRDT delta sync outbox stream in Rust core with Flutter UI widgets.

**Architecture:** Extend Rust `DatabaseEngine` with virtual table vector search and `SyncEngine` with Yrs CRDT delta blob generation/merging logged into `sync_crdt_deltas` with 17-character `histvon` timestamping. Connect to Flutter `SyncView` and `AnnotationView` search bar.

**Tech Stack:** Rust (`rusqlite`, `sqlite-vec`, `yrs`), Flutter 3.x, Material 3, Riverpod.

---

## Global Constraints
- `histvon` format: 17-character string `YYYYMMDDHHMMSSSSS`
- Active record indicator: `histbis = '9999'`
- All tests must pass cleanly (`cargo test`, `flutter analyze`, `flutter test`)
- Use Conventional Commits (`feat(ai):`, `feat(sync):`, `feat(ui):`, `docs:`)

---

### Task 1: Rust Vector Search & Yrs CRDT Engine Core

**Files:**
- Modify: `native/rust_core/src/db/mod.rs`
- Modify: `native/rust_core/src/sync/mod.rs`
- Modify: `native/rust_core/src/api/mod.rs`

**Interfaces:**
- Consumes: `AdaptivePacingEngine::generate_embedding`, `Yrs::Doc`
- Produces: `DatabaseEngine::search_similar_chunks`, `SyncEngine::generate_delta_blob`, `SyncEngine::apply_remote_delta`

- [ ] **Step 1: Write failing Rust unit test for vector search and Yrs CRDT outbox**

```rust
#[test]
fn test_vector_search_and_crdt_outbox() -> Result<()> {
    let db = DatabaseEngine::new_in_memory()?;
    let mut sync = SyncEngine::new();
    let blob = sync.generate_delta_blob();
    assert!(!blob.is_empty());
    Ok(())
}
```

- [ ] **Step 2: Run test to verify it compiles and fails if missing**

Run: `cargo test db::tests::test_vector_search_and_crdt_outbox`
Expected: FAIL or missing method

- [ ] **Step 3: Implement Yrs CRDT delta generation & DB vector search**

In `native/rust_core/src/sync/mod.rs`:
```rust
impl SyncEngine {
    pub fn generate_delta_blob(&self) -> Vec<u8> {
        let txn = self.doc.transact();
        txn.state_vector().encode_v1()
    }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `cargo test`
Expected: PASS (7/7 tests green)

- [ ] **Step 5: Commit**

```bash
git add native/rust_core/
git commit -m "feat(sync): implement Yrs CRDT delta blob generation and outbox persistence"
```

---

### Task 2: Flutter Decentralized Sync View & Semantic Search UI

**Files:**
- Create: `apps/flutter_client/lib/src/features/sync/sync_view.dart`
- Modify: `apps/flutter_client/lib/src/features/annotations/annotation_view.dart`
- Modify: `apps/flutter_client/lib/src/features/library/library_view.dart`
- Modify: `apps/flutter_client/test/widget_test.dart`

**Interfaces:**
- Consumes: Flutter Material 3, Riverpod
- Produces: `SyncView` widget, Semantic Search modal in `AnnotationView`

- [ ] **Step 1: Write failing widget test for SyncView**

```dart
testWidgets('SyncView renders WebDAV and outbox status', (WidgetTester tester) async {
  await tester.pumpWidget(const MaterialApp(home: SyncView()));
  expect(find.text('Decentralized Sync Settings'), findsOneWidget);
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test`
Expected: FAIL with missing SyncView widget

- [ ] **Step 3: Implement SyncView widget**

Create `apps/flutter_client/lib/src/features/sync/sync_view.dart` with WebDAV server configuration and sync outbox indicator.

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test`
Expected: PASS (6/6 tests green)

- [ ] **Step 5: Commit**

```bash
git add apps/flutter_client/
git commit -m "feat(ui): add Decentralized SyncView dashboard and semantic search bar"
```
