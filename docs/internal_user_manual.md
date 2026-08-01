# Agama Platform: Internal User Manual & Operational Guide

> **Internal Confidentiality Notice:** This document is prepared for internal engineering, product, and research teams operating the Agama Zero-Backend AI Speed Reading & Knowledge Management Platform.

---

## 1. Executive Summary & Core Platform Philosophy

**Agama** is a local-first, zero-backend, high-performance speed reading and active-recall knowledge system. Unlike traditional cloud-dependent reading tools, Agama runs an embedded Rust engine directly inside the client application process (via `flutter_rust_bridge` v2 and WebAssembly), delivering:

1. **Absolute Zero Cloud Costs & Air-Gapped Privacy**: PDF layout parsing, vector indexing (`sqlite-vec`), and ONNX model token complexity scoring execute entirely on-device without external API calls.
2. **Sub-Millisecond Low Latency**: 60/120 FPS RSVP Redicle rendering and $< 4.5\text{ ms}$ vector similarity search queries.
3. **Decentralized Conflict-Free Synchronization**: Built-in Yrs (Yjs Rust port) CRDT state vectors allow zero-server multi-device sync over WebDAV, iCloud Drive, or local P2P.
4. **Zero Data Loss Historization**: SQLite database schemas utilize 17-character `histvon`/`histbis` temporal primary keys.

---

## 2. Core Internal Use Cases

```
+------------------------------------------------------------------------------------+
|                               AGAMA INTERNAL USE CASES                             |
+------------------------------------+-----------------------------------------------+
| Use Case 1: Literature Review      | Use Case 2: Technical & Code Specs           |
| High-speed PDF/EPUB scanning with  | Bionic Fixation (F1-F5) bolding for dense     |
| semantic vector search over notes. | technical & architectural documentation.      |
+------------------------------------+-----------------------------------------------+
| Use Case 3: Active Recall Prep     | Use Case 4: Air-Gapped Confidentiality        |
| Automated quiz generation & SM-2   | SQLCipher 256-bit AES encryption with zero     |
| flashcard spaced repetition review.| telemetry or cloud egress.                    |
+------------------------------------+-----------------------------------------------+
| Use Case 5: Multi-Device Sync      | Use Case 6: Comprehension Calibration         |
| E2EE Yrs CRDT sync over WebDAV,    | Real-time WPM vs quiz accuracy tracking via   |
| iCloud, or local Wi-Fi P2P.        | Comprehension Calibration Index (CCI).        |
+------------------------------------+-----------------------------------------------+
```

### Use Case 1: Academic & Research Literature Review
- **Scenario**: Researchers scanning 50+ papers per week.
- **Workflow**: Load paper PDF $\rightarrow$ Start RSVP Redicle at 450 WPM $\rightarrow$ Highlight key findings $\rightarrow$ Perform local vector similarity search across all annotated papers to surface cross-cutting themes.

### Use Case 2: Deep Technical & Code Architecture Analysis
- **Scenario**: Engineers reviewing complex architectural specifications or codebases.
- **Workflow**: Open spec document $\rightarrow$ Toggle **Bionic Fixation Mode ($F3/F4$)** $\rightarrow$ Read dense technical prose with reduced visual fatigue $\rightarrow$ Add inline marginalia notes.

### Use Case 3: Medical / Legal Active Recall & Exam Preparation
- **Scenario**: Team members studying dense domain material requiring 90%+ long-term retention.
- **Workflow**: Read material $\rightarrow$ Auto-generate flashcards $\rightarrow$ Open **SM-2 Flashcard Trainer** $\rightarrow$ Score recall quality (0–5) $\rightarrow$ Let SM-2 algorithm schedule optimal review intervals ($1 \text{ day} \rightarrow 6 \text{ days} \rightarrow I \times EF$).

### Use Case 4: Air-Gapped & Executive Confidentiality
- **Scenario**: Reviewing sensitive internal financial, legal, or unreleased product documents.
- **Workflow**: Run Agama on isolated hardware $\rightarrow$ Documents stored in 256-bit AES SQLCipher $\rightarrow$ All ONNX AI embeddings generated locally $\rightarrow$ Zero telemetry emitted.

---

## 3. Operational Feature Guide

```
+------------------------------------------------------------------------------------+
|                         MAIN APPLICATION NAVIGATION BAR                            |
+-------------------┬-------------------┬-------------------┬------------------------+
| 📊 CCI Analytics  | 🖍️ Highlights     | 🎴 SM-2 Cards     | ☁️ Decentralized Sync   |
| WPM & Quiz Trends | Notes & Search    | Active Recall     | Outbox & WebDAV Sync   |
+-------------------┴-------------------┴-------------------┴------------------------+
```

### 3.1 Mode 1: RSVP Redicle Speed Reader
- **Description**: Rapid Serial Visual Presentation (RSVP) displaying one word at a time focused on the **Optimal Recognition Point (ORP)** (highlighted in red at 35% word prefix).
- **Controls**:
  - **Speed Slider**: Adjust WPM from 100 to 1,000 WPM.
  - **Play/Pause Button**: Start or pause the stream.
  - **Dynamic AIP Pacing**: Automatically adds micro-delays for long words, punctuation, and complex sentence structures.

### 3.2 Mode 2: Guided Highlighting Mode
- **Description**: Displays full paragraphs while sweeping a smooth focus highlight bar across words.
- **Best For**: Readers who prefer reading full paragraph context while maintaining high-speed visual pacing.

### 3.3 Mode 3: Bionic Fixation Mode
- **Description**: Emphasizes the initial characters of words in bold type to guide eye saccades.
- **Fixation Levels**:
  - **F1 (30%)**: Subtle fixation for light reading.
  - **F3 (50%)**: Balanced fixation for technical articles.
  - **F5 (70%)**: Aggressive fixation for maximum speed scanning.

### 3.4 Mode 4: Inline Annotations & Local Vector Similarity Search
- **Description**: Highlight text in multiple colors, add Markdown notes, and perform semantic queries.
- **Vector Search**: Type natural language queries (e.g., *"zero-backend architecture"*) into the search bar. The embedded `sqlite-vec` engine computes cosine similarity over 384-dimensional dense vectors to return ranked matching chunks.

### 3.5 Mode 5: SM-2 Active Recall Flashcard Trainer
- **Description**: Review flashcards using the SuperMemo-2 spaced repetition algorithm.
- **Interactions**:
  - Click **Show Answer** to reveal the answer.
  - Rate recall quality from **0 (Total Blackout)** to **5 (Perfect Recall)**.
  - The engine automatically updates repetition interval and ease factor ($EF$).

### 3.6 Mode 6: Decentralized Sync Settings (`SyncView`)
- **Description**: Synchronize reading progress, annotations, and flashcards across devices without a central server.
- **Providers Supported**:
  - **WebDAV (Nextcloud)**
  - **Apple iCloud Drive**
  - **Local Wi-Fi P2P (mDNS)**
- **Outbox Monitor**: View pending un-synced Yrs CRDT delta operations and click **Sync Now** to push deltas.

### 3.7 Mode 7: Comprehension Calibration Index (CCI) Analytics
- **Description**: Monitor reading performance metrics.
- **Formula**:
  $$CCI = \text{Average WPM} \times \left( \frac{\text{Quiz Accuracy \%}}{100} \right)$$
- **Target Range**: $350 - 450 \text{ CCI}$ represents the optimal speed-comprehension sweet spot.

---

## 4. Database Historization & Data Recovery Guide

The platform uses a historized SQLite schema to ensure **zero data loss**:

- Active records have `histbis = '9999'`.
- Deactivated historical records have `histbis = '<17-char timestamp>'`.

### Point-in-Time Data Rollback Procedure
If data needs to be rolled back to a previous state:
```sql
-- Deactivate current state
UPDATE documents SET histbis = '20260801120000000' WHERE id = 'doc_1' AND histbis = '9999';

-- Reactivate target historical state
UPDATE documents SET histbis = '9999' WHERE id = 'doc_1' AND histvon = '20260801100000000';
```

---

## 5. Quick Reference & Command Cheat Sheet

```bash
# 1. Run Rust Core Unit Tests
cd native/rust_core && cargo test

# 2. Run Flutter Static Analysis & Widget Tests
cd apps/flutter_client && flutter analyze && flutter test

# 3. Launch App on Preferred Target
flutter run -d chrome     # Web Target
flutter run -d android    # Android Device/Emulator
flutter run -d ios        # iOS Simulator/Device
flutter run -d macos      # macOS Desktop
```

---
*Agama Internal Platform Manual — Version 1.0 (August 2026)*
