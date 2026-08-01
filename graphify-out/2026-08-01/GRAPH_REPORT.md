# Graph Report - Agama  (2026-08-01)

## Corpus Check
- 78 files · ~65,014 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 904 nodes · 1063 edges · 62 communities (49 shown, 13 thin omitted)
- Extraction: 99% EXTRACTED · 1% INFERRED · 0% AMBIGUOUS · INFERRED: 8 edges (avg confidence: 0.81)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `5d9812f7`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- Graphify Full Pipeline
- rsvp_canvas.dart
- reader_provider.dart
- library_view.dart
- Graphify Watch Mode
- FalkorDB Export
- Graphify MCP Server
- Neo4j Cypher Export
- Token Reduction Benchmark
- Monorepo Multi-Folder Merge
- Cluster Only Execution
- ai/mod.rs
- Result
- SyncEngine
- ParsedDocument
- Production-Ready AI-First Platform: Master Technical Architecture & Specification
- build_native_libs.sh
- generate_frb.sh
- Agama
- flashcard_view.dart
- Speed Reading Apps: Comprehensive Analysis & Gap Assessment
- Complete End-to-End Implementation Specification: Zero-Backend AI Speed Reading & Knowledge Platform
- Production-Ready Local-First Architecture: Zero-Backend Platform
- 2.1 Spreeder
- 4. Key Architectural Decision Records (ADRs)
- Agama Database Schema Specification
- annotation_view.dart
- Decentralized Sync Architecture Specification
- String?
- guided_highlight_view.dart
- 3. Operational Feature Guide
- ffi_bridge.dart
- Agama Platform — Agent Guidelines & Memory Contract (CLAUDE.md)
- System Design Specification: Vector Similarity Search Engine & Decentralized Yrs CRDT Sync Outbox
- Global Constraints
- System Design Specification: Zero-Copy FFI Stream Pipeline & ONNX Engine Integration
- Global Constraints
- System Design Specification: Performance Benchmarks & Comprehension Analytics (CCI) Dashboard
- Global Constraints
- Impeccable Design Critique Snapshot: Agama Internal Manual
- sync_view.dart
- Design System: Agama Platform
- Product
- theme.dart
- file_parser_service.dart
- package:flutter/material.dart
- AppDelegate
- analytics_view.dart
- StatelessWidget
- manifest.json
- MaterialPageRoute
- flutter_client
- sync_transport.dart
- vector_search_service.dart
- Global Constraints
- Agama Platform — Agent Guidelines & Memory Contract (CLAUDE.md)
- State
- bionic_fixation_view.dart
- Design Spec: Agama Sub-project 1 — Document Ingestion & Reading Engine Overhaul
- Global Constraints
- LibraryView

## God Nodes (most connected - your core abstractions)
1. `Production-Ready AI-First Platform: Master Technical Architecture & Specification` - 30 edges
2. `Production-Ready Local-First Architecture: Zero-Backend Platform` - 18 edges
3. `DatabaseEngine` - 15 edges
4. `Graphify Full Pipeline` - 15 edges
5. `Product` - 12 edges
6. `4. Key Architectural Decision Records (ADRs)` - 12 edges
7. `Speed Reading Apps: Comprehensive Analysis & Gap Assessment` - 12 edges
8. `Complete End-to-End Implementation Specification: Zero-Backend AI Speed Reading & Knowledge Platform` - 12 edges
9. `test_annotations_and_flashcards_historization()` - 9 edges
10. `Agama Platform — Agent Guidelines & Memory Contract (CLAUDE.md)` - 9 edges

## Surprising Connections (you probably didn't know these)
- `SyncEngine` --references--> `_Doc`  [EXTRACTED]
  native/rust_core/src/sync/mod.rs → apps/flutter_client/lib/src/features/library/library_view.dart
- `Graphify Always On Rule` --semantically_similar_to--> `CLAUDE.md Native Integration`  [INFERRED] [semantically similar]
  .agents/rules/graphify.md → .agents/skills/graphify/references/hooks.md
- `Graphify Fast Path` --semantically_similar_to--> `Code-Only Update Fast Path`  [INFERRED] [semantically similar]
  .agents/skills/graphify/SKILL.md → .agents/skills/graphify/references/update.md
- `build` --references--> `readerSettingsProvider`  [EXTRACTED]
  apps/flutter_client/lib/src/features/reader/rsvp_canvas.dart → apps/flutter_client/lib/src/features/reader/reader_settings_provider.dart
- `_onKey` --references--> `readerSettingsProvider`  [EXTRACTED]
  apps/flutter_client/lib/src/features/reader/rsvp_canvas.dart → apps/flutter_client/lib/src/features/reader/reader_settings_provider.dart

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Graphify Core Execution Steps** — _agents_skills_graphify_skill_detect_files, _agents_skills_graphify_skill_ast_extraction, _agents_skills_graphify_skill_semantic_extraction, _agents_skills_graphify_skill_community_clustering, _agents_skills_graphify_skill_community_labeling [EXTRACTED 1.00]
- **Graphify Knowledge Traversal and Memory System** — _agents_skills_graphify_references_query_constrained_vocabulary_expansion, _agents_skills_graphify_references_query_bfs_dfs_traversal, _agents_skills_graphify_references_query_self_improving_feedback_loop [EXTRACTED 1.00]
- **Incremental Rebuilding and Watching Architecture** — _agents_skills_graphify_references_add_watch_graphify_watch, _agents_skills_graphify_references_update_incremental_update, _agents_skills_graphify_references_hooks_git_commit_hook [INFERRED 0.85]

## Communities (62 total, 13 thin omitted)

### Community 0 - "Graphify Full Pipeline"
Cohesion: 0.09
Nodes (24): Graphify Always On Rule, Graphify Ingestion (Add URL), Obsidian Vault Export, Confidence Score Rubric, Deterministic Node ID Format, Semantic Extraction Specification, Cross-Repo Graph Merge, CLAUDE.md Native Integration (+16 more)

### Community 1 - "rsvp_canvas.dart"
Cohesion: 0.06
Nodes (40): readerSettingsProvider, accentColor, build, createState, _customWpm, _delayForWord, dispose, _focus (+32 more)

### Community 2 - "reader_provider.dart"
Cohesion: 0.07
Nodes (29): copyWith, currentWordIndex, isPlaying, notifier, paragraphComplexity, ReaderNotifier, readerProvider, ReaderState (+21 more)

### Community 3 - "library_view.dart"
Cohesion: 0.05
Nodes (37): ../analytics/analytics_view.dart, Animation, AnimationController, ../../app/app.dart, _ac, accent, _anim, color (+29 more)

### Community 11 - "ai/mod.rs"
Cohesion: 0.10
Nodes (19): AdaptivePacingEngine, BionicFixationEngine, OnnxInferenceEngine, Default, Self, Vec, SpacedRepetitionEngine, test_bionic_fixation() (+11 more)

### Community 12 - "Result"
Cohesion: 0.17
Nodes (19): Connection, DatabaseEngine, Result, Self, Vec, test_annotations_and_flashcards_historization(), test_db_init_and_document_insert(), test_performance_benchmark_and_cci_math() (+11 more)

### Community 13 - "SyncEngine"
Cohesion: 0.22
Nodes (8): _Doc, Default, Result, Self, String, Vec, SyncEngine, test_yrs_crdt_delta_generation_and_merge()

### Community 14 - "ParsedDocument"
Cohesion: 0.26
Nodes (9): DocumentParser, EpubParser, ParsedDocument, Option, Result, String, Vec, TextParser (+1 more)

### Community 15 - "Production-Ready AI-First Platform: Master Technical Architecture & Specification"
Cohesion: 0.04
Nodes (48): ADR 001: Choice of Flutter for Cross-Platform Client, ADR 002: Next.js 15 App Router & Better Auth for Backend Architecture, Cache Invalidation Governance, Complete Prisma Schema Definition, Conflict Resolution Strategy: Optimistic Locking + Modified Field Level LWW, Core Architectural Guiding Principles, DFD Level 0 (Context Diagram), DFD Level 1 (Core Data Subsystems) (+40 more)

### Community 19 - "Agama"
Cohesion: 0.11
Nodes (17): 1. Build & Test Native Rust Engine Core, 1. Schema Versioning (`PRAGMA user_version`), 2. Generate Cross-Platform FFI Bindings (`flutter_rust_bridge` v2), 2. Pushing Schema Updates, 3. Data Rollbacks (Zero Data Loss), 3. Running & Testing by Platform Target, A. Web (Chrome / WebAssembly Target), Agama (+9 more)

### Community 20 - "flashcard_view.dart"
Cohesion: 0.10
Nodes (19): answer, build, _cards, color, createState, ef, FlashcardItem, FlashcardStore (+11 more)

### Community 21 - "Speed Reading Apps: Comprehensive Analysis & Gap Assessment"
Cohesion: 0.06
Nodes (31): 1. Executive Summary, 3.1 The Subvocalization Myth, 3.2 RSVP Comprehension Problems, 3.3 Bionic Reading — The Evidence Gap, 3.4 Eye Strain & Fatigue, 3.5 Peripheral Vision Claims, 3. Scientific & Cognitive Limitations, 4.1 Content Format Destruction (+23 more)

### Community 22 - "Complete End-to-End Implementation Specification: Zero-Backend AI Speed Reading & Knowledge Platform"
Cohesion: 0.06
Nodes (31): 10. Backward & Forward Document Linkage Matrix, 1.1 Problem Statement & Market Opportunity, 1.2 The Platform Solution, 1. Executive Product & Architecture Vision, 2.1 Styling & UI Design System (Flutter Material UI / Material Design 3), 2.2 Adaptive Intelligent Pacing (AIP) Engine, 2.3 Display & Reading Modes, 2.4 Multi-Format Layout-Preserving Document Processor (+23 more)

### Community 23 - "Production-Ready Local-First Architecture: Zero-Backend Platform"
Cohesion: 0.07
Nodes (27): Core Architectural Principles, Executive Architecture Summary, Flutter Riverpod Controller Consuming Rust Stream, High-Level Component Topology, On-Device Complexity Algorithm, PART 10: Riverpod 2.x State Management & FFI Stream Integration, PART 11: Enterprise Monorepo Structure, PART 12: Zero-Backend Security & Data Privacy Matrix (+19 more)

### Community 24 - "2.1 Spreeder"
Cohesion: 0.08
Nodes (25): 2.1 Spreeder, 2.2 Outread, 2.3 Bionic Reading, 2.4 Spritz, 2. App-by-App Deep Dive, Core Features, Core Features, Core Features (+17 more)

### Community 25 - "4. Key Architectural Decision Records (ADRs)"
Cohesion: 0.09
Nodes (22): 1.1 Architectural Vision, 1. Executive Architecture Summary, 2.1 Logical View (Layered Architecture), 2. Architectural Representation & Views, 3.1 Historization Concept (`histvon` / `histbis`), 3. Data Architecture & Historization Pattern, 4. Key Architectural Decision Records (ADRs), 5. Backward & Forward Document Linkage Matrix (+14 more)

### Community 26 - "Agama Database Schema Specification"
Cohesion: 0.09
Nodes (22): 1. Executive Data Architecture Summary, 1. Schema Version Tracking (`PRAGMA user_version`), 2.1 Timestamp Format Specification, 2.2 Standard Mutation Workflow Rules, 2.3 Database Schema Versioning, Upgrades & Rollback Procedures, 2. Historization Pattern & Specification (`histvon` / `histbis`), 2. Migration Execution Pipeline (`native/rust_core/src/db/mod.rs`), 3. Complete DDL Schema (+14 more)

### Community 27 - "annotation_view.dart"
Cohesion: 0.11
Nodes (18): AnnotationItem, AnnotationStore, build, color, createState, id, initState, items (+10 more)

### Community 28 - "Decentralized Sync Architecture Specification"
Cohesion: 0.12
Nodes (15): 1. Executive Summary & Core Principles, 2.1 The Cross-Platform Challenge, 2.2 The WebDAV Solution, 2.3 Channel Comparison Matrix, 2. Why WebDAV is the Primary Sync Channel, 3.1 End-to-End Encrypted WebDAV Sync Loop, 3. Sequence & Data Flow Specifications, 4.1 Encrypted Sync File Format (`.crdt`) (+7 more)

### Community 30 - "guided_highlight_view.dart"
Cohesion: 0.12
Nodes (16): ../annotations/annotation_view.dart, build, createState, _delayForWord, GuidedHighlightView, _GuidedHighlightViewState, _idx, initState (+8 more)

### Community 31 - "3. Operational Feature Guide"
Cohesion: 0.11
Nodes (18): 1. Executive Summary & Core Platform Philosophy, 2. Core Internal Use Cases, 3.1 Mode 1: RSVP Redicle Speed Reader, 3.2 Mode 2: Guided Highlighting Mode, 3.3 Mode 3: Bionic Fixation Mode, 3.4 Mode 4: Inline Annotations & Local Vector Similarity Search, 3.5 Mode 5: SM-2 Active Recall Flashcard Trainer, 3.6 Mode 6: Decentralized Sync Settings (`SyncView`) (+10 more)

### Community 33 - "Agama Platform — Agent Guidelines & Memory Contract (CLAUDE.md)"
Cohesion: 0.13
Nodes (14): 1. Process & Skill Activation Rules (Superpowers Plugin), 2. Token & Architecture Optimization Modes, 3. Knowledge Graph Navigation (Graphify), 4. Branching, PR per Feature & Semantic Commits, 5. Interactive Requirement Alignment & Pre-Merge Confirmation Protocol, 6. Build, Testing & Code Linting Verification, 7. Single Source of Truth (SSOT) Architecture References, 8. Platform & Build State (current) (+6 more)

### Community 34 - "System Design Specification: Vector Similarity Search Engine & Decentralized Yrs CRDT Sync Outbox"
Cohesion: 0.25
Nodes (7): 1. Overview & Objectives, 2.1 Vector Similarity Search Engine, 2.2 Decentralized Yrs CRDT Sync Engine, 2. Technical Architecture & Components, 3. Data Flow & Sequence Diagram, 4. Verification & Testing Strategy, System Design Specification: Vector Similarity Search Engine & Decentralized Yrs CRDT Sync Outbox

### Community 35 - "Global Constraints"
Cohesion: 0.40
Nodes (4): Global Constraints, Task 1: Rust Vector Search & Yrs CRDT Engine Core, Task 2: Flutter Decentralized Sync View & Semantic Search UI, Vector Search & Yrs CRDT Sync Outbox Implementation Plan

### Community 36 - "System Design Specification: Zero-Copy FFI Stream Pipeline & ONNX Engine Integration"
Cohesion: 0.25
Nodes (7): 1. Overview & Objectives, 2.1 ONNX Inference Engine (`native/rust_core/src/ai/mod.rs`), 2.2 Zero-Copy FFI Stream Pipeline (`native/rust_core/src/api/mod.rs`), 2. Technical Architecture & Components, 3. Data Flow & Sequence Diagram, 4. Verification & Testing Strategy, System Design Specification: Zero-Copy FFI Stream Pipeline & ONNX Engine Integration

### Community 37 - "Global Constraints"
Cohesion: 0.40
Nodes (4): Global Constraints, Task 1: Rust Core Zero-Copy FFI Stream Generator & ONNX Engine, Task 2: Flutter Riverpod Reader Provider & Stream Listener Integration, Zero-Copy FFI Stream Pipeline & ONNX Engine Implementation Plan

### Community 38 - "System Design Specification: Performance Benchmarks & Comprehension Analytics (CCI) Dashboard"
Cohesion: 0.29
Nodes (6): 1. Overview & Objectives, 2.1 Performance Benchmarks (`native/rust_core/tests/benchmark_test.rs`), 2.2 Comprehension Calibration Index (CCI) & Analytics (`apps/flutter_client/lib/src/features/analytics/analytics_view.dart`), 2. Technical Architecture & Components, 3. Verification & Testing Strategy, System Design Specification: Performance Benchmarks & Comprehension Analytics (CCI) Dashboard

### Community 39 - "Global Constraints"
Cohesion: 0.40
Nodes (4): Global Constraints, Performance Benchmarks & Comprehension Analytics Implementation Plan, Task 1: Rust Engine Performance Benchmark Suite & CCI Helper, Task 2: Flutter Comprehension Analytics (CCI) Dashboard UI

### Community 40 - "Impeccable Design Critique Snapshot: Agama Internal Manual"
Cohesion: 0.29
Nodes (6): Design Health Score, Design Specificity Verdict, Impeccable Design Critique Snapshot: Agama Internal Manual, Overall Impression, Persona Red Flags, Priority Issues

### Community 41 - "sync_view.dart"
Cohesion: 0.20
Nodes (10): build, createState, _outbox, _sync, _syncing, SyncView, _SyncViewState, _transportAdapter (+2 more)

### Community 42 - "Design System: Agama Platform"
Cohesion: 0.08
Nodes (23): Accents — each has a **single semantic role**, AppBar, Border, Bottom Navigation, Colors, Components, Creative Direction, Design System: Agama Platform (+15 more)

### Community 43 - "Product"
Cohesion: 0.15
Nodes (12): Accessibility & Inclusion, Brand Commitments, Capabilities and Constraints, Evidence on Hand, Operating Context, Platform, Positioning, Product (+4 more)

### Community 44 - "theme.dart"
Cohesion: 0.07
Nodes (27): AgamaTheme, amber, bg, border, borderStrong, _buildTextTheme, crimson, dark (+19 more)

### Community 45 - "file_parser_service.dart"
Cohesion: 0.11
Nodes (16): content, _determineFormat, DocumentFormat, _extractTextFromBytes, FileParserService, format, parseBytes, ParsedDocument (+8 more)

### Community 46 - "package:flutter/material.dart"
Cohesion: 0.06
Nodes (33): main, AgamaApp, build, _getInitialHome, themeModeNotifier, main, main, main (+25 more)

### Community 47 - "AppDelegate"
Cohesion: 0.11
Nodes (14): RegisterGeneratedPlugins(), AppDelegate, MainFlutterWindow, RunnerTests, Bool, Cocoa, FlutterAppDelegate, FlutterMacOS (+6 more)

### Community 48 - "analytics_view.dart"
Cohesion: 0.17
Nodes (11): accent, AnalyticsView, build, label, _MetricCard, _peers, _sessions, _totalWords (+3 more)

### Community 49 - "StatelessWidget"
Cohesion: 0.17
Nodes (12): _RateBtn, _AppBarBtn, _DocumentTile, _EngineBtn, _EngineRow, _KnowledgeTab, _KnowledgeTile, _LibraryTab (+4 more)

### Community 50 - "manifest.json"
Cohesion: 0.18
Nodes (10): background_color, description, display, icons, name, orientation, prefer_related_applications, short_name (+2 more)

### Community 51 - "MaterialPageRoute"
Cohesion: 0.50
Nodes (4): build, _launch, _showImportSheet, MaterialPageRoute

### Community 53 - "sync_transport.dart"
Cohesion: 0.29
Nodes (6): bytes, isEncrypted, packageDelta, SyncPayload, SyncTransportAdapter, List

### Community 54 - "vector_search_service.dart"
Cohesion: 0.33
Nodes (5): score, search, SearchResult, text, VectorSearchService

### Community 55 - "Global Constraints"
Cohesion: 0.25
Nodes (7): Feature Gap Remediation Implementation Plan, Global Constraints, Task 1: Native Document File Parser Integration, Task 2: Flutter-Rust FFI Core Binding Foundation, Task 3: Local Vector Index & Semantic Search Abstraction, Task 4: WebDAV & P2P Sync Transport Adapter, Task 5: Final Graphify Topology & Test Verification

### Community 56 - "Agama Platform — Agent Guidelines & Memory Contract (CLAUDE.md)"
Cohesion: 0.13
Nodes (14): 1. Process & Skill Activation Rules (Superpowers Plugin), 2. Token & Architecture Optimization Modes, 3. Knowledge Graph Navigation (Graphify), 4. Branching, PR per Feature & Semantic Commits, 5. Interactive Requirement Alignment & Pre-Merge Confirmation Protocol, 6. Build, Testing & Code Linting Verification, 7. Single Source of Truth (SSOT) Architecture References, 8. Platform & Build State (current) (+6 more)

### Community 57 - "State"
Cohesion: 0.24
Nodes (11): AnnotationView, _AnnotationViewState, FlashcardView, _FlashcardViewState, _EngineChooser, _EngineChooserState, _LivePulse, _LivePulseState (+3 more)

### Community 58 - "bionic_fixation_view.dart"
Cohesion: 0.20
Nodes (10): ../../app/theme.dart, BionicFixationView, _BionicFixationViewState, build, createState, _fontSize, _level, _split (+2 more)

### Community 59 - "Design Spec: Agama Sub-project 1 — Document Ingestion & Reading Engine Overhaul"
Cohesion: 0.18
Nodes (10): 1. Overview, 2.1 Document Ingestion Layer (`apps/flutter_client/lib/src/features/library/file_parser_service.dart`), 2.2 Reader Settings State (`apps/flutter_client/lib/src/features/reader/reader_settings_provider.dart`), 2. Architecture & Data Model, 3.1 Library & Document Import (`library_view.dart`), 3.2 Multi-Engine Reader Workspace (`rsvp_canvas.dart`, `bionic_fixation_view.dart`, `guided_highlight_view.dart`), 3. Component Design & User Interface, 4. Error Handling & Edge Cases (+2 more)

### Community 60 - "Global Constraints"
Cohesion: 0.33
Nodes (5): Global Constraints, Reading Engine Overhaul Implementation Plan, Task 1: Reader Settings Provider, Task 2: Update File Parser Service, Task 3: Update RSVP Canvas UI

## Knowledge Gaps
- **519 isolated node(s):** `main`, `themeModeNotifier`, `_getInitialHome`, `build`, `AgamaTheme` (+514 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **13 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `_Doc` connect `SyncEngine` to `library_view.dart`?**
  _High betweenness centrality (0.010) - this node is a cross-community bridge._
- **Why does `Speed Reading Apps: Comprehensive Analysis & Gap Assessment` connect `Speed Reading Apps: Comprehensive Analysis & Gap Assessment` to `2.1 Spreeder`?**
  _High betweenness centrality (0.003) - this node is a cross-community bridge._
- **What connects `main`, `themeModeNotifier`, `_getInitialHome` to the rest of the system?**
  _519 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Graphify Full Pipeline` be split into smaller, more focused modules?**
  _Cohesion score 0.09057971014492754 - nodes in this community are weakly interconnected._
- **Should `rsvp_canvas.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.05609756097560976 - nodes in this community are weakly interconnected._
- **Should `reader_provider.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.06881720430107527 - nodes in this community are weakly interconnected._
- **Should `library_view.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.05263157894736842 - nodes in this community are weakly interconnected._