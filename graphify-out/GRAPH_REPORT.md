# Graph Report - Agama  (2026-08-01)

## Corpus Check
- 90 files · ~72,794 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1322 nodes · 1665 edges · 80 communities (68 shown, 12 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS · INFERRED: 8 edges (avg confidence: 0.81)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `4199ceef`
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
- String
- SyncEngine
- ParsedDocument
- Production-Ready AI-First Platform: Master Technical Architecture & Specification
- build_native_libs.sh
- generate_frb.sh
- package:flutter_riverpod/flutter_riverpod.dart
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
- frb_generated.dart
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
- Library UI Overhaul Design Spec
- GeneratedPluginRegistrant.swift
- analytics_view.dart
- Global Constraints
- manifest.json
- .sse_decode
- flutter_client
- sync_transport.dart
- vector_search_service.dart
- Global Constraints
- Agama Platform — Agent Guidelines & Memory Contract (CLAUDE.md)
- State
- package:flutter/material.dart
- Design Spec: Agama Sub-project 1 — Document Ingestion & Reading Engine Overhaul
- Global Constraints
- Global Constraints
- Rust Bridge Setup Design
- frb_generated.io.dart
- _
- models.dart
- readerSettingsProvider
- RsvpCanvasView
- widget_test.dart
- OrpGuidePainter
- 5. Market Gaps & Unaddressed Opportunities
- 4. User Complaints & Real-World Problems
- RustLib
- 2.2 Outread
- 2.3 Bionic Reading
- 2.4 Spritz
- 3. Scientific & Cognitive Limitations
- RustLibApiImplPlatform
- RustLibWasmModule
- RustLibWire

## God Nodes (most connected - your core abstractions)
1. `_` - 73 edges
2. `Production-Ready AI-First Platform: Master Technical Architecture & Specification` - 30 edges
3. `Production-Ready Local-First Architecture: Zero-Backend Platform` - 18 edges
4. `DatabaseEngine` - 15 edges
5. `Graphify Full Pipeline` - 15 edges
6. `()` - 13 edges
7. `Product` - 12 edges
8. `4. Key Architectural Decision Records (ADRs)` - 12 edges
9. `Speed Reading Apps: Comprehensive Analysis & Gap Assessment` - 12 edges
10. `Complete End-to-End Implementation Specification: Zero-Backend AI Speed Reading & Knowledge Platform` - 12 edges

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

## Communities (80 total, 12 thin omitted)

### Community 0 - "Graphify Full Pipeline"
Cohesion: 0.09
Nodes (24): Graphify Always On Rule, Graphify Ingestion (Add URL), Obsidian Vault Export, Confidence Score Rubric, Deterministic Node ID Format, Semantic Extraction Specification, Cross-Repo Graph Merge, CLAUDE.md Native Integration (+16 more)

### Community 1 - "rsvp_canvas.dart"
Cohesion: 0.07
Nodes (28): accentColor, createState, _customWpm, _delayForWord, dispose, _focus, icon, _idx (+20 more)

### Community 2 - "reader_provider.dart"
Cohesion: 0.12
Nodes (16): copyWith, currentWordIndex, isPlaying, notifier, paragraphComplexity, ReaderNotifier, readerProvider, ReaderState (+8 more)

### Community 3 - "library_view.dart"
Cohesion: 0.04
Nodes (52): ../analytics/analytics_view.dart, Animation, AnimationController, ../../app/app.dart, _ac, accent, _anim, build (+44 more)

### Community 11 - "ai/mod.rs"
Cohesion: 0.13
Nodes (13): AdaptivePacingEngine, BionicFixationEngine, OnnxInferenceEngine, BionicWord, Default, Self, Vec, WordTiming (+5 more)

### Community 12 - "String"
Cohesion: 0.10
Nodes (32): Connection, calculate_orp_index(), generate_bionic_words(), generate_rsvp_timings(), parse_file(), BionicWord, ParsedDocument, Result (+24 more)

### Community 13 - "SyncEngine"
Cohesion: 0.24
Nodes (7): _Doc, Default, Result, Self, Vec, SyncEngine, test_yrs_crdt_delta_generation_and_merge()

### Community 14 - "ParsedDocument"
Cohesion: 0.29
Nodes (8): DocumentParser, EpubParser, ParsedDocument, Option, Result, Vec, TextParser, UnifiedParser

### Community 15 - "Production-Ready AI-First Platform: Master Technical Architecture & Specification"
Cohesion: 0.04
Nodes (48): ADR 001: Choice of Flutter for Cross-Platform Client, ADR 002: Next.js 15 App Router & Better Auth for Backend Architecture, Cache Invalidation Governance, Complete Prisma Schema Definition, Conflict Resolution Strategy: Optimistic Locking + Modified Field Level LWW, Core Architectural Guiding Principles, DFD Level 0 (Context Diagram), DFD Level 1 (Core Data Subsystems) (+40 more)

### Community 18 - "package:flutter_riverpod/flutter_riverpod.dart"
Cohesion: 0.33
Nodes (5): main, main, package:flutter_client/src/features/reader/reader_settings_provider.dart, package:flutter_riverpod/flutter_riverpod.dart, RichText

### Community 19 - "Agama"
Cohesion: 0.11
Nodes (17): 1. Build & Test Native Rust Engine Core, 1. Schema Versioning (`PRAGMA user_version`), 2. Generate Cross-Platform FFI Bindings (`flutter_rust_bridge` v2), 2. Pushing Schema Updates, 3. Data Rollbacks (Zero Data Loss), 3. Running & Testing by Platform Target, A. Web (Chrome / WebAssembly Target), Agama (+9 more)

### Community 20 - "flashcard_view.dart"
Cohesion: 0.10
Nodes (21): answer, build, _cards, color, createState, ef, FlashcardItem, FlashcardStore (+13 more)

### Community 21 - "Speed Reading Apps: Comprehensive Analysis & Gap Assessment"
Cohesion: 0.18
Nodes (10): 1. Executive Summary, 6. Competitive Feature Matrix, 7. Recommendations for Product Development, 8. Conclusion, For Existing Apps, For New Market Entrants, Sources & References, Speed Reading Apps: Comprehensive Analysis & Gap Assessment (+2 more)

### Community 22 - "Complete End-to-End Implementation Specification: Zero-Backend AI Speed Reading & Knowledge Platform"
Cohesion: 0.06
Nodes (31): 10. Backward & Forward Document Linkage Matrix, 1.1 Problem Statement & Market Opportunity, 1.2 The Platform Solution, 1. Executive Product & Architecture Vision, 2.1 Styling & UI Design System (Flutter Material UI / Material Design 3), 2.2 Adaptive Intelligent Pacing (AIP) Engine, 2.3 Display & Reading Modes, 2.4 Multi-Format Layout-Preserving Document Processor (+23 more)

### Community 23 - "Production-Ready Local-First Architecture: Zero-Backend Platform"
Cohesion: 0.07
Nodes (27): Core Architectural Principles, Executive Architecture Summary, Flutter Riverpod Controller Consuming Rust Stream, High-Level Component Topology, On-Device Complexity Algorithm, PART 10: Riverpod 2.x State Management & FFI Stream Integration, PART 11: Enterprise Monorepo Structure, PART 12: Zero-Backend Security & Data Privacy Matrix (+19 more)

### Community 24 - "2.1 Spreeder"
Cohesion: 0.29
Nodes (7): 2.1 Spreeder, 2. App-by-App Deep Dive, Core Features, Critical Gaps, Upcoming/Rumored Features, What Users Hate, What Users Love

### Community 25 - "4. Key Architectural Decision Records (ADRs)"
Cohesion: 0.09
Nodes (22): 1.1 Architectural Vision, 1. Executive Architecture Summary, 2.1 Logical View (Layered Architecture), 2. Architectural Representation & Views, 3.1 Historization Concept (`histvon` / `histbis`), 3. Data Architecture & Historization Pattern, 4. Key Architectural Decision Records (ADRs), 5. Backward & Forward Document Linkage Matrix (+14 more)

### Community 26 - "Agama Database Schema Specification"
Cohesion: 0.09
Nodes (22): 1. Executive Data Architecture Summary, 1. Schema Version Tracking (`PRAGMA user_version`), 2.1 Timestamp Format Specification, 2.2 Standard Mutation Workflow Rules, 2.3 Database Schema Versioning, Upgrades & Rollback Procedures, 2. Historization Pattern & Specification (`histvon` / `histbis`), 2. Migration Execution Pipeline (`native/rust_core/src/db/mod.rs`), 3. Complete DDL Schema (+14 more)

### Community 27 - "annotation_view.dart"
Cohesion: 0.10
Nodes (19): AnnotationItem, AnnotationStore, build, color, createState, id, initState, items (+11 more)

### Community 28 - "Decentralized Sync Architecture Specification"
Cohesion: 0.12
Nodes (15): 1. Executive Summary & Core Principles, 2.1 The Cross-Platform Challenge, 2.2 The WebDAV Solution, 2.3 Channel Comparison Matrix, 2. Why WebDAV is the Primary Sync Channel, 3.1 End-to-End Encrypted WebDAV Sync Loop, 3. Sequence & Data Flow Specifications, 4.1 Encrypted Sync File Format (`.crdt`) (+7 more)

### Community 29 - "frb_generated.dart"
Cohesion: 0.02
Nodes (90): ApiImplConstructor, apiImplConstructor, codegenVersion, crateApiCalculateCciScore, crateApiCalculateOrpIndex, crateApiGenerateBionicWords, crateApiGenerateRsvpTimings, crateApiParseFile (+82 more)

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
Cohesion: 0.18
Nodes (11): ../../app/theme.dart, build, createState, _outbox, _sync, _syncing, SyncView, _SyncViewState (+3 more)

### Community 42 - "Design System: Agama Platform"
Cohesion: 0.08
Nodes (23): Accents — each has a **single semantic role**, AppBar, Border, Bottom Navigation, Colors, Components, Creative Direction, Design System: Agama Platform (+15 more)

### Community 43 - "Product"
Cohesion: 0.15
Nodes (12): Accessibility & Inclusion, Brand Commitments, Capabilities and Constraints, Evidence on Hand, Operating Context, Platform, Positioning, Product (+4 more)

### Community 44 - "theme.dart"
Cohesion: 0.05
Nodes (36): AgamaApp, build, _getInitialHome, themeModeNotifier, AgamaTheme, amber, bg, border (+28 more)

### Community 45 - "file_parser_service.dart"
Cohesion: 0.05
Nodes (34): content, _determineFormat, DocumentFormat, _extractTextFromBytes, FileParserService, format, init, parseBytes (+26 more)

### Community 46 - "Library UI Overhaul Design Spec"
Cohesion: 0.18
Nodes (10): 1. Hero Input Section, 2. Engine Selection Section, 3. Library Section (Recent Documents), Architecture & Layout, Context, Design Goals, Error Handling, Implementation Details (+2 more)

### Community 47 - "GeneratedPluginRegistrant.swift"
Cohesion: 0.11
Nodes (15): RegisterGeneratedPlugins(), AppDelegate, MainFlutterWindow, RunnerTests, Bool, Cocoa, file_picker, FlutterAppDelegate (+7 more)

### Community 48 - "analytics_view.dart"
Cohesion: 0.09
Nodes (22): accent, AnalyticsView, build, label, _MetricCard, _peers, _sessions, _totalWords (+14 more)

### Community 49 - "Global Constraints"
Cohesion: 0.40
Nodes (4): Global Constraints, Library UI Overhaul Implementation Plan, Task 1: Expose Direct Inputs in Hero Section, Task 2: Connect Inputs to Engine Chooser and Remove Bottom Sheet

### Community 50 - "manifest.json"
Cohesion: 0.18
Nodes (10): background_color, description, display, icons, name, orientation, prefer_related_applications, short_name (+2 more)

### Community 51 - ".sse_decode"
Cohesion: 0.06
Nodes (43): DartAbi, IntoDart, IntoDartExceptPrimitive, IntoIntoDart, MessagePort, (), bool, crate::models::BionicWord (+35 more)

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
Cohesion: 0.18
Nodes (15): AnnotationView, _AnnotationViewState, _EngineChooser, _EngineChooserState, _HeroSection, _HeroSectionState, _LibraryTab, _LibraryTabState (+7 more)

### Community 58 - "package:flutter/material.dart"
Cohesion: 0.15
Nodes (12): main, BionicFixationView, _BionicFixationViewState, build, createState, _fontSize, _level, _split (+4 more)

### Community 59 - "Design Spec: Agama Sub-project 1 — Document Ingestion & Reading Engine Overhaul"
Cohesion: 0.18
Nodes (10): 1. Overview, 2.1 Document Ingestion Layer (`apps/flutter_client/lib/src/features/library/file_parser_service.dart`), 2.2 Reader Settings State (`apps/flutter_client/lib/src/features/reader/reader_settings_provider.dart`), 2. Architecture & Data Model, 3.1 Library & Document Import (`library_view.dart`), 3.2 Multi-Engine Reader Workspace (`rsvp_canvas.dart`, `bionic_fixation_view.dart`, `guided_highlight_view.dart`), 3. Component Design & User Interface, 4. Error Handling & Edge Cases (+2 more)

### Community 60 - "Global Constraints"
Cohesion: 0.33
Nodes (5): Global Constraints, Reading Engine Overhaul Implementation Plan, Task 1: Reader Settings Provider, Task 2: Update File Parser Service, Task 3: Update RSVP Canvas UI

### Community 61 - "Global Constraints"
Cohesion: 0.33
Nodes (5): Global Constraints, Rust Bridge Implementation Plan, Task 1: Add Dependencies, Task 2: Expose Parser API, Task 3: Generate Bridge and Connect Dart

### Community 62 - "Rust Bridge Setup Design"
Cohesion: 0.40
Nodes (4): Architecture & Components, Data Flow, Purpose, Rust Bridge Setup Design

### Community 63 - "frb_generated.io.dart"
Cohesion: 0.03
Nodes (63): dco_decode_AnyhowException, dco_decode_bionic_word, dco_decode_bool, dco_decode_f_64, dco_decode_i_64, dco_decode_list_bionic_word, dco_decode_list_prim_u_8_strict, dco_decode_list_String (+55 more)

### Community 64 - "_"
Cohesion: 0.03
Nodes (64): api.dart, _, dco_decode_AnyhowException, dco_decode_bionic_word, dco_decode_bool, dco_decode_f_64, dco_decode_i_64, dco_decode_list_bionic_word (+56 more)

### Community 65 - "models.dart"
Cohesion: 0.05
Nodes (44): copyWith, fontFamily, fontSize, hashCode, operator, ReaderSettings, ReaderSettingsNotifier, setFontFamily (+36 more)

### Community 66 - "readerSettingsProvider"
Cohesion: 0.40
Nodes (5): readerSettingsProvider, build, _onKey, _setWpm, _tick

### Community 67 - "RsvpCanvasView"
Cohesion: 0.40
Nodes (5): RSVPCanvas, RsvpCanvasView, _RsvpCanvasViewState, ConsumerState, ConsumerStatefulWidget

### Community 68 - "widget_test.dart"
Cohesion: 0.18
Nodes (10): main, main, package:flutter_client/src/app/theme.dart, package:flutter_client/src/features/analytics/analytics_view.dart, package:flutter_client/src/features/flashcards/flashcard_view.dart, package:flutter_client/src/features/library/library_view.dart, package:flutter_client/src/features/reader/bionic_fixation_view.dart, package:flutter_client/src/features/reader/guided_highlight_view.dart (+2 more)

### Community 72 - "5. Market Gaps & Unaddressed Opportunities"
Cohesion: 0.25
Nodes (8): 5.1 The "Adaptive Intelligent Pacing" Opportunity, 5.2 Annotation-Native Speed Reading, 5.3 Cross-Platform, Offline-First Design, 5.4 Evidence-Based Comprehension Scaffolding, 5.5 Multilingual & Script Support, 5.6 Social Reading & Accountability, 5.7 Integration with Existing Workflows, 5. Market Gaps & Unaddressed Opportunities

### Community 73 - "4. User Complaints & Real-World Problems"
Cohesion: 0.29
Nodes (7): 4.1 Content Format Destruction, 4.2 DRM & File Import Frustrations, 4.3 Platform & Pricing Pain Points, 4.4 The "Reading Flow" Problem, 4.5 Annotation & Knowledge Management Gap, 4.6 Social & Motivation Deficit, 4. User Complaints & Real-World Problems

### Community 74 - "RustLib"
Cohesion: 0.40
Nodes (6): RustLib, RustLibApi, RustLibApiImpl, BaseApi, BaseEntrypoint, RustLibApiImplPlatform

### Community 75 - "2.2 Outread"
Cohesion: 0.33
Nodes (6): 2.2 Outread, Core Features, Critical Gaps, Upcoming/Rumored Features, What Users Hate, What Users Love

### Community 76 - "2.3 Bionic Reading"
Cohesion: 0.33
Nodes (6): 2.3 Bionic Reading, Core Features, Critical Gaps, Upcoming/Rumored Features, What Users Hate, What Users Love

### Community 77 - "2.4 Spritz"
Cohesion: 0.33
Nodes (6): 2.4 Spritz, Core Features, Critical Gaps, Upcoming/Rumored Features, What Users Hate, What Users Love

### Community 78 - "3. Scientific & Cognitive Limitations"
Cohesion: 0.33
Nodes (6): 3.1 The Subvocalization Myth, 3.2 RSVP Comprehension Problems, 3.3 Bionic Reading — The Evidence Gap, 3.4 Eye Strain & Fatigue, 3.5 Peripheral Vision Claims, 3. Scientific & Cognitive Limitations

### Community 79 - "RustLibApiImplPlatform"
Cohesion: 0.67
Nodes (4): RustLibApiImplPlatform, RustLibApiImplPlatform, BaseApiImpl, RustLibWire

### Community 80 - "RustLibWasmModule"
Cohesion: 0.67
Nodes (3): @anonymous, @JS, RustLibWasmModule

### Community 81 - "RustLibWire"
Cohesion: 0.67
Nodes (3): RustLibWire, RustLibWire, BaseWire

## Knowledge Gaps
- **778 isolated node(s):** `main`, `themeModeNotifier`, `_getInitialHome`, `build`, `AgamaTheme` (+773 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **12 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `String` connect `String` to `.sse_decode`, `SyncEngine`, `ParsedDocument`?**
  _High betweenness centrality (0.095) - this node is a cross-community bridge._
- **Why does `_` connect `_` to `models.dart`, `file_parser_service.dart`, `RustLibApiImplPlatform`, `RustLibWasmModule`, `RustLibWire`, `frb_generated.io.dart`?**
  _High betweenness centrality (0.084) - this node is a cross-community bridge._
- **What connects `main`, `themeModeNotifier`, `_getInitialHome` to the rest of the system?**
  _778 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Graphify Full Pipeline` be split into smaller, more focused modules?**
  _Cohesion score 0.09057971014492754 - nodes in this community are weakly interconnected._
- **Should `rsvp_canvas.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.06896551724137931 - nodes in this community are weakly interconnected._
- **Should `reader_provider.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.125 - nodes in this community are weakly interconnected._
- **Should `library_view.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.03918722786647315 - nodes in this community are weakly interconnected._