# Agama Database Schema Specification
## Zero-Backend Local Database, Vector Store & Historization Architecture

> [!IMPORTANT]
> **SINGLE SOURCE OF TRUTH (SSOT) - DATABASE & HISTORIZATION SCHEMA**  
> This document defines the authoritative, production-grade SQLite schema, table dictionaries, indexing strategies, vector embeddings (`sqlite-vec`), and 17-character `histvon` / `histbis` historization mechanics for the Agama platform.

---

## Document Traceability & Cross-Reference Index

| Document Role | File Path | Status | Description / Relationship |
| --- | --- | --- | --- |
| **Database Schema (SSOT)** | [`docs/schema.md`](file:///Users/yashpratap/Documents/GitHub/Agama/docs/schema.md) | **ACTIVE (SSOT)** | Complete SQLite DDL, Field Dictionary, `histvon`/`histbis` Historization & Vector Indexing. |
| **System Architecture (SAD)** | [`docs/SAD.md`](file:///Users/yashpratap/Documents/GitHub/Agama/docs/SAD.md) | **ACTIVE (SSOT)** | ISO/IEC/IEEE 42010 Architectural Description, ADRs, & System Topology. |
| **Master Implementation Spec** | [`docs/complete_end_to_end_implementation.md`](file:///Users/yashpratap/Documents/GitHub/Agama/docs/complete_end_to_end_implementation.md) | **ACTIVE (SSOT)** | Master feature specification, Cargo.toml & pubspec.yaml manifests. |
| **Core Local Strategy** | [`docs/implementation_no_backend.md`](file:///Users/yashpratap/Documents/GitHub/Agama/docs/implementation_no_backend.md) | **ACTIVE REFERENCE** | Initial technical specification for the local-first Rust + Flutter architecture. |
| **Market & Cognitive Research** | [`docs/Speed_Reading_Apps_Detailed_Market_Analysis.md`](file:///Users/yashpratap/Documents/GitHub/Agama/docs/Speed_Reading_Apps_Detailed_Market_Analysis.md) | **ACTIVE REFERENCE** | Competitor analysis (Spreeder, Outread, Bionic Reading, Spritz) & scientific limitations. |
| **Cloud Backend Spec** | [`docs/implementation_plan_advance.md`](file:///Users/yashpratap/Documents/GitHub/Agama/docs/implementation_plan_advance.md) | 🛑 **ON HOLD** | Cloud-backend microservices spec. Placed on hold in favor of Zero-Backend architecture. |

---

## 1. Executive Data Architecture Summary

- **Embedded Engine:** `rusqlite` compiled with `bundled-sqlcipher` (256-bit AES-CBC hardware-backed encryption).
- **Vector Engine:** `sqlite-vec` (v0.1.1) native C extension providing 384-dimensional dense float array similarity search.
- **Historization Pattern:** Immutable 17-character timestamping (`histvon` = created, `histbis` = valid until / active marker `'9999'`).
- **Primary Keys:** Composite key `(id, histvon)` across all historized domain tables to allow multiple historical versions per logical entity ID.

---

## 2. Historization Pattern & Specification (`histvon` / `histbis`)

### 2.1 Timestamp Format Specification
- **Pattern:** Exactly 17-character string: `YYYYMMDDHHMMSSSSS`
  - `YYYY`: 4-digit Year (`2026`)
  - `MM`: 2-digit Month (`01`–`12`)
  - `DD`: 2-digit Day (`01`–`31`)
  - `HH`: 2-digit Hour (`00`–`23`)
  - `MM`: 2-digit Minute (`00`–`59`)
  - `SS`: 2-digit Second (`00`–`59`)
  - `SSS`: 3-digit Milliseconds (`000`–`999`)
  - *Example:* `20260801122321000`
- **Active Record Indicator:** `histbis = '9999'` (literal string).
- **Inactive / Historical Record Indicator:** `histbis = <17_char_deactivation_timestamp>`.

```
ACTIVE RECORD:      [ id: "doc_123", histvon: "20260801120000000", histbis: "9999" ]
                                  |
                                  v  (User updates document title)
HISTORIZED ROW:     [ id: "doc_123", histvon: "20260801120000000", histbis: "20260801122500000" ]
NEW ACTIVE ROW:     [ id: "doc_123", histvon: "20260801122500000", histbis: "9999" ]
```

### 2.2 Standard Mutation Workflow Rules

#### Querying Active Records (Select)
```sql
SELECT * FROM documents 
WHERE id = ? AND histbis = '9999';
```

#### Updating an Active Record (Mutation)
```sql
-- Step 1: Deactivate current active version
UPDATE documents 
SET histbis = ? -- Current 17-char timestamp, e.g. '20260801122500000'
WHERE id = ? AND histbis = '9999';

-- Step 2: Insert new active version
INSERT INTO documents (id, title, author, file_path, mime_type, word_count, reading_progress, checksum, histvon, histbis)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, '9999'); -- histvon = '20260801122500000'
```

#### Soft Deleting a Record
```sql
UPDATE documents 
SET histbis = ? -- Current 17-char timestamp
WHERE id = ? AND histbis = '9999';
```

---

## 3. Complete DDL Schema

```sql
-- Enable SQLCipher Encryption & Foreign Key Enforcements
PRAGMA key = 'passphrase-retrieved-from-device-secure-enclave';
PRAGMA foreign_keys = ON;

-- ============================================================================
-- 1. DOCUMENTS TABLE (Master Book/Document Catalog)
-- ============================================================================
CREATE TABLE documents (
    id TEXT NOT NULL,
    title TEXT NOT NULL,
    author TEXT,
    file_path TEXT NOT NULL,
    mime_type TEXT NOT NULL,
    word_count INTEGER NOT NULL,
    reading_progress REAL DEFAULT 0.0,
    checksum TEXT NOT NULL,
    histvon TEXT NOT NULL,                -- 17-char YYYYMMDDHHMMSSSSS
    histbis TEXT NOT NULL DEFAULT '9999', -- '9999' if active
    PRIMARY KEY (id, histvon)
);

-- ============================================================================
-- 2. DOCUMENT_CHUNKS TABLE (Paragraph Text Chunks & Complexity Index)
-- ============================================================================
CREATE TABLE document_chunks (
    id TEXT NOT NULL,
    document_id TEXT NOT NULL,
    chunk_index INTEGER NOT NULL,
    content TEXT NOT NULL,
    token_count INTEGER NOT NULL,
    complexity_score REAL DEFAULT 1.0,
    histvon TEXT NOT NULL,
    histbis TEXT NOT NULL DEFAULT '9999',
    PRIMARY KEY (id, histvon)
);

-- ============================================================================
-- 3. CHUNK_EMBEDDINGS TABLE (sqlite-vec Virtual Table for Local Vector Search)
-- ============================================================================
CREATE VIRTUAL TABLE chunk_embeddings USING vec0(
    chunk_id TEXT PRIMARY KEY,
    embedding float[384]
);

-- ============================================================================
-- 4. ANNOTATIONS TABLE (User Highlights, Colors & Markdown Marginalia Notes)
-- ============================================================================
CREATE TABLE annotations (
    id TEXT NOT NULL,
    document_id TEXT NOT NULL,
    selected_text TEXT NOT NULL,
    note TEXT,
    color_hex TEXT DEFAULT '#FFD700',
    start_offset INTEGER NOT NULL,
    end_offset INTEGER NOT NULL,
    chapter_index INTEGER DEFAULT 0,
    histvon TEXT NOT NULL,
    histbis TEXT NOT NULL DEFAULT '9999',
    PRIMARY KEY (id, histvon)
);

-- ============================================================================
-- 5. FLASHCARDS TABLE (Active Recall & Spaced Repetition Flashcards - SM-2)
-- ============================================================================
CREATE TABLE flashcards (
    id TEXT NOT NULL,
    annotation_id TEXT,
    document_id TEXT NOT NULL,
    question TEXT NOT NULL,
    answer TEXT NOT NULL,
    interval INTEGER DEFAULT 1,
    repetition_factor REAL DEFAULT 2.5,
    due_date INTEGER NOT NULL,
    histvon TEXT NOT NULL,
    histbis TEXT NOT NULL DEFAULT '9999',
    PRIMARY KEY (id, histvon)
);

-- ============================================================================
-- 6. SYNC_CRDT_DELTAS TABLE (Decentralized Yrs CRDT Outbox Store)
-- ============================================================================
CREATE TABLE sync_crdt_deltas (
    id TEXT PRIMARY KEY NOT NULL,
    entity_name TEXT NOT NULL,
    entity_id TEXT NOT NULL,
    crdt_clock INTEGER NOT NULL,
    delta_blob BLOB NOT NULL,
    histvon TEXT NOT NULL,
    histbis TEXT NOT NULL DEFAULT '9999'
);

-- ============================================================================
-- 7. READING_SESSIONS TABLE (Comprehension & WPM Analytics Audit Logs)
-- ============================================================================
CREATE TABLE reading_sessions (
    id TEXT NOT NULL,
    document_id TEXT NOT NULL,
    start_time INTEGER NOT NULL,
    end_time INTEGER NOT NULL,
    words_read INTEGER NOT NULL,
    avg_wpm INTEGER NOT NULL,
    quiz_score REAL,
    histvon TEXT NOT NULL,
    histbis TEXT NOT NULL DEFAULT '9999',
    PRIMARY KEY (id, histvon)
);

-- ============================================================================
-- PARTIAL INDEXES FOR ACTIVE RECORD QUERY OPTIMIZATION (WHERE histbis = '9999')
-- ============================================================================
CREATE INDEX idx_docs_active ON documents(id) WHERE histbis = '9999';
CREATE INDEX idx_docs_title_active ON documents(title) WHERE histbis = '9999';

CREATE INDEX idx_chunks_active ON document_chunks(document_id, chunk_index) WHERE histbis = '9999';

CREATE INDEX idx_annotations_active ON annotations(document_id) WHERE histbis = '9999';
CREATE INDEX idx_annotations_start ON annotations(document_id, start_offset) WHERE histbis = '9999';

CREATE INDEX idx_flashcards_active ON flashcards(due_date) WHERE histbis = '9999';
CREATE INDEX idx_flashcards_doc ON flashcards(document_id) WHERE histbis = '9999';

CREATE INDEX idx_sync_active ON sync_crdt_deltas(entity_name, entity_id) WHERE histbis = '9999';
CREATE INDEX idx_sessions_doc ON reading_sessions(document_id) WHERE histbis = '9999';
```

---

## 4. Entity Attribute Dictionary

### 4.1 Table: `documents`
| Column Name | SQLite Type | Constraint | Description | Example Value |
| --- | --- | --- | --- | --- |
| `id` | `TEXT` | `NOT NULL` | Logical UUID string identifying the document entity. | `"doc_a1b2c3d4"` |
| `title` | `TEXT` | `NOT NULL` | Extracted title of the document. | `"Deep Learning Concepts"` |
| `author` | `TEXT` | `NULLABLE` | Author metadata. | `"Ian Goodfellow"` |
| `file_path` | `TEXT` | `NOT NULL` | Local file system path. | `"/var/mobile/docs/book.pdf"` |
| `mime_type` | `TEXT` | `NOT NULL` | File MIME type classification. | `"application/pdf"` |
| `word_count` | `INTEGER` | `NOT NULL` | Total word count extracted. | `145200` |
| `reading_progress`| `REAL` | `DEFAULT 0.0` | Reading completion fraction ($0.0 \dots 1.0$). | `0.45` |
| `checksum` | `TEXT` | `NOT NULL` | SHA-256 checksum of raw file. | `"e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"` |
| `histvon` | `TEXT` | `NOT NULL` | 17-char timestamp `YYYYMMDDHHMMSSSSS` when row version became valid. | `"20260801122321000"` |
| `histbis` | `TEXT` | `NOT NULL` | 17-char timestamp when row was deactivated, or `'9999'` if active. | `"9999"` |

### 4.2 Table: `document_chunks`
| Column Name | SQLite Type | Constraint | Description | Example Value |
| --- | --- | --- | --- | --- |
| `id` | `TEXT` | `NOT NULL` | Logical UUID for text chunk. | `"chk_99x88y"` |
| `document_id` | `TEXT` | `NOT NULL` | Parent document UUID reference. | `"doc_a1b2c3d4"` |
| `chunk_index` | `INTEGER` | `NOT NULL` | Zero-based paragraph sequence index. | `12` |
| `content` | `TEXT` | `NOT NULL` | Raw text paragraph content. | `"Neural networks require gradient calculation..."` |
| `token_count` | `INTEGER` | `NOT NULL` | Number of tokens in chunk. | `48` |
| `complexity_score`| `REAL` | `DEFAULT 1.0` | ONNX calculated syntactic complexity ($C \in [0.5, 2.0]$). | `1.45` |
| `histvon` | `TEXT` | `NOT NULL` | 17-char timestamp when version became valid. | `"20260801122321000"` |
| `histbis` | `TEXT` | `NOT NULL` | 17-char timestamp when deactivated, or `'9999'`. | `"9999"` |

### 4.3 Virtual Table: `chunk_embeddings` (`sqlite-vec`)
| Column Name | Vector Type | Constraint | Description | Example Value |
| --- | --- | --- | --- | --- |
| `chunk_id` | `TEXT` | `PRIMARY KEY` | Primary key linking to `document_chunks.id`. | `"chk_99x88y"` |
| `embedding` | `float[384]` | `vec0` | 384-dimensional dense float vector from `MiniLM-L6-v2`. | `[-0.024, 0.142, ..., 0.089]` |

### 4.4 Table: `annotations`
| Column Name | SQLite Type | Constraint | Description | Example Value |
| --- | --- | --- | --- | --- |
| `id` | `TEXT` | `NOT NULL` | UUID for highlight/annotation. | `"ann_777bbb"` |
| `document_id` | `TEXT` | `NOT NULL` | Parent document UUID. | `"doc_a1b2c3d4"` |
| `selected_text`| `TEXT` | `NOT NULL` | Exact highlighted text snippet. | `"Backpropagation calculates the chain rule gradient."` |
| `note` | `TEXT` | `NULLABLE` | Rich Markdown note attached by user. | `"Key concept for Chapter 4 review."` |
| `color_hex` | `TEXT` | `DEFAULT '#FFD700'`| Color hex code for highlight background. | `"#FFD700"` |
| `start_offset` | `INTEGER` | `NOT NULL` | Start character index offset. | `4520` |
| `end_offset` | `INTEGER` | `NOT NULL` | End character index offset. | `4574` |
| `chapter_index`| `INTEGER` | `DEFAULT 0` | Chapter index where highlight occurs. | `4` |
| `histvon` | `TEXT` | `NOT NULL` | 17-char timestamp valid from. | `"20260801122321000"` |
| `histbis` | `TEXT` | `NOT NULL` | 17-char timestamp valid until, or `'9999'`. | `"9999"` |

---

## 5. Backward & Forward Document Linkage Matrix

- **Forward Link to SAD Document:** [`docs/SAD.md`](file:///Users/yashpratap/Documents/GitHub/Agama/docs/SAD.md)
- **Forward Link to Implementation Spec:** [`docs/complete_end_to_end_implementation.md`](file:///Users/yashpratap/Documents/GitHub/Agama/docs/complete_end_to_end_implementation.md)
- **Backward Link to Market Baseline:** [`docs/Speed_Reading_Apps_Detailed_Market_Analysis.md`](file:///Users/yashpratap/Documents/GitHub/Agama/docs/Speed_Reading_Apps_Detailed_Market_Analysis.md)
- **Backward Link to Strategy Doc:** [`docs/implementation_no_backend.md`](file:///Users/yashpratap/Documents/GitHub/Agama/docs/implementation_no_backend.md)
- **Archived Reference:** [`docs/implementation_plan_advance.md`](file:///Users/yashpratap/Documents/GitHub/Agama/docs/implementation_plan_advance.md) *(ON HOLD)*

---
*Schema specification approved for production deployment.*
