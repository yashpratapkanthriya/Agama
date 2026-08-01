# Task 3 Design Specification: Local Vector Search (`sqlite-vec`) & ONNX ML Engine

**Date:** 2026-08-01  
**Status:** Approved Specification  
**Domain:** AI Inference & Native Vector Storage  
**SSOT Reference:** [`docs/complete_end_to_end_implementation.md`](file:///Users/yashpratap/Documents/GitHub/Agama/docs/complete_end_to_end_implementation.md)

---

## 1. Overview & Goals

Task 3 delivers on-device semantic search and dynamic text complexity scoring without cloud API dependencies. This is achieved by embedding ONNX Runtime (`ort`) and `sqlite-vec` into Agama's native Rust core engine (`native/rust_core`).

---

## 2. Architecture & Components

```
+------------------------------------------------------------------------------------+
|                                 RUST NATIVE ENGINE                                 |
|                                                                                    |
|  +---------------------------+                +---------------------------------+  |
|  |   OnnxInferenceEngine     |                |  SQLCipher + sqlite-vec Store   |  |
|  | - ort::Session (MiniLM)   |                | - chunk_embeddings (vec0)       |  |
|  | - tokenizers::Tokenizer   |                | - KNN MATCH similarity queries  |  |
|  +-------------+-------------+                +----------------+----------------+  |
|                |                                               |                   |
|                +-----------------------+-----------------------+                   |
|                                        |                                           |
|                           flutter_rust_bridge v2 FFI                               |
+----------------------------------------+-------------------------------------------+
                                         |
                       +-----------------+-----------------+
                       |  Flutter Riverpod UI State Layer  |
                       |  - annotation_provider.dart      |
                       |  - library_search_view.dart       |
                       +-----------------------------------+
```

### 2.1 Model & Tokenizer Assets (`assets/models/`)
- `assets/models/minilm-l6-v2-int8.onnx`: Quantized 8-bit MiniLM-L6-v2 model generating 384-dimensional dense vector embeddings.
- `assets/models/tokenizer.json`: HuggingFace tokenization rules and vocabulary dictionary.

### 2.2 Rust ONNX Inference Pipeline (`native/rust_core/src/ai/mod.rs`)
- `OnnxInferenceEngine` struct manages `ort::Session` instance and `tokenizers::Tokenizer`.
- `infer_complexity(text: &str) -> f32`: Evaluates token length distribution, punctuation density, and sentence structure to return complexity multiplier $C \in [0.5, 2.0]$.
- `generate_embedding(text: &str) -> Result<Vec<f32>>`: 
  1. Tokenizes text string to input IDs and attention mask tensors.
  2. Runs forward pass through ONNX Session.
  3. Applies mean pooling over token embeddings to yield normalized 384-element float array.

### 2.3 `sqlite-vec` Vector Store (`native/rust_core/src/db/mod.rs`)
- Loads `sqlite3_vec_init` C-extension on `rusqlite` database connections.
- Virtual Table DDL:
  ```sql
  CREATE VIRTUAL TABLE IF NOT EXISTS chunk_embeddings USING vec0(
      chunk_id TEXT PRIMARY KEY,
      embedding float[384]
  );
  ```
- Vector Insert Query:
  ```sql
  INSERT OR REPLACE INTO chunk_embeddings(chunk_id, embedding) VALUES (?, ?);
  ```
- Similarity Match Query:
  ```sql
  SELECT chunk_id, distance
  FROM chunk_embeddings
  WHERE embedding MATCH ?
  ORDER BY distance
  LIMIT ?;
  ```

### 2.4 FFI API & Flutter State Integration (`apps/flutter_client`)
- Auto-generated `flutter_rust_bridge` entrypoints in `native/rust_core/src/api/mod.rs`:
  - `generate_embedding_async(text: String) -> Vec<f32>`
  - `search_similar_chunks_async(query: String, limit: u32) -> Vec<SearchResult>`
- Riverpod state providers in Dart bind semantic search query results directly to highlight and document search views.

---

## 3. Verification & Testing Strategy
1. **Rust Engine Unit & Integration Tests (`native/rust_core/src/ai/mod.rs` & `db/mod.rs`)**:
   - `test_onnx_embedding_dimension`: Verifies output vector has exactly 384 dimensions.
   - `test_sqlite_vec_knn_search`: Verifies exact match vector returns distance $\approx 0.0$.
2. **Flutter UI Integration Tests (`apps/flutter_client/test/`)**:
   - Verifies `searchEmbeddingsAsync` bridge call execution.
3. **Execution Gate**: `cargo test` and `flutter test` must pass with 0 errors.
