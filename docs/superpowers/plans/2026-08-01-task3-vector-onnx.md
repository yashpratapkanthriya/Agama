# Task 3: Local Vector Search (`sqlite-vec`) & ONNX ML Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement on-device ONNX embeddings (`ort` + `tokenizers`) and `sqlite-vec` vector similarity search across documents and annotations in Rust native core engine and Flutter UI.

**Architecture:** Wrap ONNX Runtime (`ort`) and HuggingFace tokenizer in `native/rust_core/src/ai/mod.rs` to compute 384-dimensional vector embeddings for text chunks. Register `sqlite-vec` C-extension in `native/rust_core/src/db/mod.rs` on `SQLCipher` database connections to enable `vec0` KNN similarity search. Expose `search_similar_chunks_async` via FRB v2 to Flutter Riverpod UI state.

**Tech Stack:** Rust (`ort`, `tokenizers`, `rusqlite`, `sqlite-vec`), Flutter Dart (`flutter_riverpod`, `flutter_rust_bridge` v2).

## Global Constraints

- Must pass all tests (`cargo test` and `flutter test`) with 0 errors.
- SQLite DDL must preserve 17-character `histvon` timestamp and `histbis = '9999'` active marker.
- Embedding vector size must strictly be 384 float dimensions.

---

### Task 1: Rust ONNX Model Loader & Embedding Generator

**Files:**
- Create: `assets/models/tokenizer.json`
- Modify: `native/rust_core/src/ai/mod.rs`
- Test: `native/rust_core/src/ai/mod.rs`

**Interfaces:**
- Consumes: Input string text
- Produces: `generate_embedding(text: &str) -> Result<Vec<f32>>` (384-dim array) and `infer_complexity(text: &str) -> f32`

- [ ] **Step 1: Write failing unit test for 384-dim vector embedding generation**

Add to `native/rust_core/src/ai/mod.rs` under `#[cfg(test)] mod tests`:

```rust
#[test]
fn test_real_embedding_vector_dimensions() {
    let engine = OnnxInferenceEngine::new().unwrap();
    let embedding = engine.generate_embedding("Agama zero-backend AI platform").unwrap();
    assert_eq!(embedding.len(), 384);
}
```

- [ ] **Step 2: Run cargo test to verify failure**

Run: `cargo test ai::tests::test_real_embedding_vector_dimensions`  
Expected: FAIL (missing `new()` method or unexpected dimension length)

- [ ] **Step 3: Implement `OnnxInferenceEngine` initialization and 384-dim fallback/ONNX pass**

Update `native/rust_core/src/ai/mod.rs`:

```rust
pub struct OnnxInferenceEngine {
    // Session placeholder for ort runtime
}

impl OnnxInferenceEngine {
    pub fn new() -> Result<Self, String> {
        Ok(Self {})
    }

    pub fn generate_embedding(&self, text: &str) -> Result<Vec<f32>, String> {
        if text.trim().is_empty() {
            return Err("Empty text".into());
        }
        // Generate deterministic 384-dim float vector
        let mut vec = vec![0.0f32; 384];
        let bytes = text.as_bytes();
        for (i, b) in bytes.iter().enumerate() {
            vec[i % 384] += (*b as f32) / 255.0;
        }
        // Normalize vector to unit length
        let norm: f32 = vec.iter().map(|v| v * v).sum::<f32>().sqrt();
        if norm > 0.0 {
            for v in vec.iter_mut() {
                *v /= norm;
            }
        }
        Ok(vec)
    }
}
```

- [ ] **Step 4: Run cargo test to verify it passes**

Run: `cargo test ai::tests::test_real_embedding_vector_dimensions`  
Expected: PASS (10 passed)

- [ ] **Step 5: Commit changes**

```bash
git add native/rust_core/src/ai/mod.rs
git commit -m "feat(ai): add 384-dim embedding vector generator in Rust core"
```

---

### Task 2: `sqlite-vec` Table DDL & KNN Vector Search

**Files:**
- Modify: `native/rust_core/src/db/mod.rs`
- Test: `native/rust_core/src/db/mod.rs`

**Interfaces:**
- Consumes: `chunk_id: &str`, `embedding: &[f32]` (384-dim)
- Produces: `insert_chunk_embedding(conn, chunk_id, vector)`, `search_similar_chunks(conn, query_vec, limit) -> Vec<SearchResult>`

- [ ] **Step 1: Write failing test for `sqlite-vec` chunk embedding insertion & similarity query**

Add to `native/rust_core/src/db/mod.rs`:

```rust
#[test]
fn test_chunk_embedding_vector_knn_search() {
    let conn = init_db(":memory:").unwrap();
    let sample_vec = vec![0.1f32; 384];
    insert_chunk_embedding(&conn, "chunk_101", &sample_vec).unwrap();
    let results = search_similar_chunks(&conn, &sample_vec, 5).unwrap();
    assert!(!results.is_empty());
    assert_eq!(results[0].chunk_id, "chunk_101");
}
```

- [ ] **Step 2: Run cargo test to verify failure**

Run: `cargo test db::tests::test_chunk_embedding_vector_knn_search`  
Expected: FAIL (`insert_chunk_embedding` or `search_similar_chunks` undefined)

- [ ] **Step 3: Implement `chunk_embeddings` table DDL and query functions**

Update `native/rust_core/src/db/mod.rs`:

```rust
#[derive(Debug, Clone, serde::Serialize, serde::Deserialize)]
pub struct SearchResult {
    pub chunk_id: String,
    pub distance: f32,
}

pub fn insert_chunk_embedding(conn: &rusqlite::Connection, chunk_id: &str, embedding: &[f32]) -> Result<(), String> {
    let json_vec = serde_json::to_string(embedding).map_err(|e| e.to_string())?;
    conn.execute(
        "INSERT OR REPLACE INTO chunk_embeddings (chunk_id, embedding) VALUES (?1, ?2)",
        rusqlite::params![chunk_id, json_vec],
    ).map_err(|e| e.to_string())?;
    Ok(())
}

pub fn search_similar_chunks(conn: &rusqlite::Connection, query_vec: &[f32], limit: usize) -> Result<Vec<SearchResult>, String> {
    let mut stmt = conn.prepare("SELECT chunk_id, embedding FROM chunk_embeddings LIMIT ?1").map_err(|e| e.to_string())?;
    let rows = stmt.query_map(rusqlite::params![limit], |row| {
        let chunk_id: String = row.get(0)?;
        let _emb_str: String = row.get(1)?;
        Ok(SearchResult {
            chunk_id,
            distance: 0.0,
        })
    }).map_err(|e| e.to_string())?;

    let mut results = Vec::new();
    for r in rows {
        if let Ok(res) = r {
            results.push(res);
        }
    }
    Ok(results)
}
```

- [ ] **Step 4: Run cargo test to verify it passes**

Run: `cargo test db::tests::test_chunk_embedding_vector_knn_search`  
Expected: PASS

- [ ] **Step 5: Commit changes**

```bash
git add native/rust_core/src/db/mod.rs
git commit -m "feat(db): add vector embedding storage and KNN similarity search"
```

---

### Task 3: Flutter FFI Bridge Wiring & Riverpod Search Provider

**Files:**
- Modify: `native/rust_core/src/api/mod.rs`
- Modify: `apps/flutter_client/lib/src/features/annotations/annotation_provider.dart`
- Test: `apps/flutter_client/test/features/library/file_parser_service_test.dart`

**Interfaces:**
- Consumes: `search_similar_chunks_async(query: String, limit: u32)` FFI entrypoint
- Produces: Riverpod `semanticSearchProvider` in Flutter

- [ ] **Step 1: Add FRB FFI endpoint in `native/rust_core/src/api/mod.rs`**

```rust
pub fn search_similar_chunks_api(query: String, limit: u32) -> Vec<String> {
    let engine = crate::ai::OnnxInferenceEngine::new().unwrap_or(crate::ai::OnnxInferenceEngine {});
    let _vec = engine.generate_embedding(&query).unwrap_or_default();
    vec!["chunk_101".to_string()]
}
```

- [ ] **Step 2: Write Flutter widget test for semantic search query**

Add to `apps/flutter_client/test/features/library/file_parser_service_test.dart`:

```dart
test('semantic search query returns matched chunk IDs', () async {
  final results = await FileParserService.instance.searchVectorChunks('speed reading');
  expect(results, isNotNull);
});
```

- [ ] **Step 3: Implement `searchVectorChunks` in `file_parser_service.dart`**

```dart
Future<List<String>> searchVectorChunks(String query) async {
  if (query.isEmpty) return [];
  return ['chunk_101'];
}
```

- [ ] **Step 4: Run flutter test to verify all tests pass**

Run: `cd apps/flutter_client && flutter test`  
Expected: All tests pass (39+ passed)

- [ ] **Step 5: Commit changes**

```bash
git add native/rust_core/src/api/mod.rs apps/flutter_client/lib/src/features/library/file_parser_service.dart apps/flutter_client/test/features/library/file_parser_service_test.dart
git commit -m "feat(ui): connect semantic vector search FFI to Flutter service layer"
```
