# Graph Report - Agama  (2026-08-01)

## Corpus Check
- 38 files · ~34,923 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 469 nodes · 553 edges · 30 communities (20 shown, 10 thin omitted)
- Extraction: 99% EXTRACTED · 1% INFERRED · 0% AMBIGUOUS · INFERRED: 7 edges (avg confidence: 0.81)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `c2ce44fd`
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

## God Nodes (most connected - your core abstractions)
1. `Production-Ready AI-First Platform: Master Technical Architecture & Specification` - 30 edges
2. `Production-Ready Local-First Architecture: Zero-Backend Platform` - 18 edges
3. `Graphify Full Pipeline` - 15 edges
4. `DatabaseEngine` - 14 edges
5. `4. Key Architectural Decision Records (ADRs)` - 12 edges
6. `Speed Reading Apps: Comprehensive Analysis & Gap Assessment` - 12 edges
7. `Complete End-to-End Implementation Specification: Zero-Backend AI Speed Reading & Knowledge Platform` - 12 edges
8. `test_annotations_and_flashcards_historization()` - 9 edges
9. `AdaptivePacingEngine` - 8 edges
10. `Software Architecture Document (SAD)` - 8 edges

## Surprising Connections (you probably didn't know these)
- `Graphify Always On Rule` --semantically_similar_to--> `CLAUDE.md Native Integration`  [INFERRED] [semantically similar]
  .agents/rules/graphify.md → .agents/skills/graphify/references/hooks.md
- `Graphify Fast Path` --semantically_similar_to--> `Code-Only Update Fast Path`  [INFERRED] [semantically similar]
  .agents/skills/graphify/SKILL.md → .agents/skills/graphify/references/update.md
- `generate_rsvp_timings()` --references--> `WordTiming`  [EXTRACTED]
  native/rust_core/src/api/mod.rs → native/rust_core/src/models/mod.rs
- `Graphify Full Pipeline` --references--> `Graphify Ingestion (Add URL)`  [EXTRACTED]
  .agents/skills/graphify/SKILL.md → .agents/skills/graphify/references/add-watch.md
- `Graphify Full Pipeline` --references--> `Obsidian Vault Export`  [EXTRACTED]
  .agents/skills/graphify/SKILL.md → .agents/skills/graphify/references/exports.md

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Graphify Core Execution Steps** — _agents_skills_graphify_skill_detect_files, _agents_skills_graphify_skill_ast_extraction, _agents_skills_graphify_skill_semantic_extraction, _agents_skills_graphify_skill_community_clustering, _agents_skills_graphify_skill_community_labeling [EXTRACTED 1.00]
- **Graphify Knowledge Traversal and Memory System** — _agents_skills_graphify_references_query_constrained_vocabulary_expansion, _agents_skills_graphify_references_query_bfs_dfs_traversal, _agents_skills_graphify_references_query_self_improving_feedback_loop [EXTRACTED 1.00]
- **Incremental Rebuilding and Watching Architecture** — _agents_skills_graphify_references_add_watch_graphify_watch, _agents_skills_graphify_references_update_incremental_update, _agents_skills_graphify_references_hooks_git_commit_hook [INFERRED 0.85]

## Communities (30 total, 10 thin omitted)

### Community 0 - "Graphify Full Pipeline"
Cohesion: 0.09
Nodes (24): Graphify Always On Rule, Graphify Ingestion (Add URL), Obsidian Vault Export, Confidence Score Rubric, Deterministic Node ID Format, Semantic Extraction Specification, Cross-Repo Graph Merge, CLAUDE.md Native Integration (+16 more)

### Community 1 - "rsvp_canvas.dart"
Cohesion: 0.11
Nodes (18): accentColor, build, _calculateOrpIndex, createState, _currentIndex, initState, _isPlaying, OrpGuidePainter (+10 more)

### Community 2 - "reader_provider.dart"
Cohesion: 0.15
Nodes (13): copyWith, currentWordIndex, isPlaying, paragraphComplexity, ReaderNotifier, readerProvider, ReaderState, setComplexity (+5 more)

### Community 3 - "library_view.dart"
Cohesion: 0.07
Nodes (26): ../annotations/annotation_view.dart, main, AgamaApp, build, build, LibraryView, sampleText, main (+18 more)

### Community 11 - "ai/mod.rs"
Cohesion: 0.11
Nodes (15): AdaptivePacingEngine, BionicFixationEngine, Default, Self, Vec, SpacedRepetitionEngine, test_bionic_fixation(), test_complexity_and_embedding() (+7 more)

### Community 12 - "Result"
Cohesion: 0.18
Nodes (18): Connection, DatabaseEngine, Result, Self, Vec, test_annotations_and_flashcards_historization(), test_db_init_and_document_insert(), Annotation (+10 more)

### Community 13 - "SyncEngine"
Cohesion: 0.28
Nodes (5): Doc, Default, Self, Vec, SyncEngine

### Community 14 - "ParsedDocument"
Cohesion: 0.26
Nodes (9): DocumentParser, EpubParser, ParsedDocument, Option, Result, String, Vec, TextParser (+1 more)

### Community 15 - "Production-Ready AI-First Platform: Master Technical Architecture & Specification"
Cohesion: 0.04
Nodes (48): ADR 001: Choice of Flutter for Cross-Platform Client, ADR 002: Next.js 15 App Router & Better Auth for Backend Architecture, Cache Invalidation Governance, Complete Prisma Schema Definition, Conflict Resolution Strategy: Optimistic Locking + Modified Field Level LWW, Core Architectural Guiding Principles, DFD Level 0 (Context Diagram), DFD Level 1 (Core Data Subsystems) (+40 more)

### Community 19 - "Agama"
Cohesion: 0.25
Nodes (7): 1. Build Rust Engine, 2. Generate FFI Bindings, 3. Run Flutter Application, Agama, Quick Start, Requirements, Structure

### Community 20 - "flashcard_view.dart"
Cohesion: 0.05
Nodes (40): AnnotationView, _AnnotationViewState, answer, build, _cards, createState, _currentIndex, dueSeconds (+32 more)

### Community 21 - "Speed Reading Apps: Comprehensive Analysis & Gap Assessment"
Cohesion: 0.06
Nodes (31): 1. Executive Summary, 3.1 The Subvocalization Myth, 3.2 RSVP Comprehension Problems, 3.3 Bionic Reading — The Evidence Gap, 3.4 Eye Strain & Fatigue, 3.5 Peripheral Vision Claims, 3. Scientific & Cognitive Limitations, 4.1 Content Format Destruction (+23 more)

### Community 22 - "Complete End-to-End Implementation Specification: Zero-Backend AI Speed Reading & Knowledge Platform"
Cohesion: 0.07
Nodes (28): 10. Backward & Forward Document Linkage Matrix, 1.1 Problem Statement & Market Opportunity, 1.2 The Platform Solution, 1. Executive Product & Architecture Vision, 2.1 Styling & UI Design System (Flutter Material UI / Material Design 3), 2.2 Adaptive Intelligent Pacing (AIP) Engine, 2.3 Display & Reading Modes, 2.4 Multi-Format Layout-Preserving Document Processor (+20 more)

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
Cohesion: 0.11
Nodes (17): 1. Executive Data Architecture Summary, 2.1 Timestamp Format Specification, 2.2 Standard Mutation Workflow Rules, 2. Historization Pattern & Specification (`histvon` / `histbis`), 3. Complete DDL Schema, 4.1 Table: `documents`, 4.2 Table: `document_chunks`, 4.3 Virtual Table: `chunk_embeddings` (`sqlite-vec`) (+9 more)

### Community 27 - "annotation_view.dart"
Cohesion: 0.12
Nodes (15): _addAnnotation, AnnotationItem, _annotations, build, color, createState, id, note (+7 more)

### Community 28 - "Decentralized Sync Architecture Specification"
Cohesion: 0.12
Nodes (15): 1. Executive Summary & Core Principles, 2.1 The Cross-Platform Challenge, 2.2 The WebDAV Solution, 2.3 Channel Comparison Matrix, 2. Why WebDAV is the Primary Sync Channel, 3.1 End-to-End Encrypted WebDAV Sync Loop, 3. Sequence & Data Flow Specifications, 4.1 Encrypted Sync File Format (`.crdt`) (+7 more)

## Knowledge Gaps
- **258 isolated node(s):** `main`, `build`, `AnnotationItem`, `id`, `selectedText` (+253 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **10 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Speed Reading Apps: Comprehensive Analysis & Gap Assessment` connect `Speed Reading Apps: Comprehensive Analysis & Gap Assessment` to `2.1 Spreeder`?**
  _High betweenness centrality (0.011) - this node is a cross-community bridge._
- **Why does `2. App-by-App Deep Dive` connect `2.1 Spreeder` to `Speed Reading Apps: Comprehensive Analysis & Gap Assessment`?**
  _High betweenness centrality (0.009) - this node is a cross-community bridge._
- **What connects `main`, `build`, `AnnotationItem` to the rest of the system?**
  _258 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Graphify Full Pipeline` be split into smaller, more focused modules?**
  _Cohesion score 0.09057971014492754 - nodes in this community are weakly interconnected._
- **Should `rsvp_canvas.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.1111111111111111 - nodes in this community are weakly interconnected._
- **Should `library_view.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.07126436781609195 - nodes in this community are weakly interconnected._
- **Should `ai/mod.rs` be split into smaller, more focused modules?**
  _Cohesion score 0.1111111111111111 - nodes in this community are weakly interconnected._