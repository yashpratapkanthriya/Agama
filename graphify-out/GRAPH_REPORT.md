# Graph Report - Agama  (2026-08-01)

## Corpus Check
- 25 files · ~13,005 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 136 nodes · 155 edges · 19 communities (10 shown, 9 thin omitted)
- Extraction: 98% EXTRACTED · 2% INFERRED · 0% AMBIGUOUS · INFERRED: 3 edges (avg confidence: 0.83)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `710c14a2`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- Graphify Full Pipeline
- rsvp_canvas.dart
- app.dart
- Graphify Watch Mode
- FalkorDB Export
- Graphify MCP Server
- Neo4j Cypher Export
- Token Reduction Benchmark
- Monorepo Multi-Folder Merge
- Cluster Only Execution
- AdaptivePacingEngine
- DatabaseEngine
- SyncEngine
- ParsedDocument
- models/mod.rs
- build_native_libs.sh
- generate_frb.sh
- Agama

## God Nodes (most connected - your core abstractions)
1. `Graphify Full Pipeline` - 15 edges
2. `DatabaseEngine` - 7 edges
3. `ParsedDocument` - 7 edges
4. `AdaptivePacingEngine` - 6 edges
5. `WordTiming` - 6 edges
6. `SyncEngine` - 6 edges
7. `Document` - 5 edges
8. `generate_rsvp_timings()` - 4 edges
9. `Agama` - 4 edges
10. `Quick Start` - 4 edges

## Surprising Connections (you probably didn't know these)
- `Graphify Always On Rule` --semantically_similar_to--> `CLAUDE.md Native Integration`  [INFERRED] [semantically similar]
  .agents/rules/graphify.md → .agents/skills/graphify/references/hooks.md
- `Graphify Fast Path` --semantically_similar_to--> `Code-Only Update Fast Path`  [INFERRED] [semantically similar]
  .agents/skills/graphify/SKILL.md → .agents/skills/graphify/references/update.md
- `Graphify Full Pipeline` --references--> `Graphify Ingestion (Add URL)`  [EXTRACTED]
  .agents/skills/graphify/SKILL.md → .agents/skills/graphify/references/add-watch.md
- `Graphify Full Pipeline` --references--> `Obsidian Vault Export`  [EXTRACTED]
  .agents/skills/graphify/SKILL.md → .agents/skills/graphify/references/exports.md
- `Graphify Full Pipeline` --references--> `Cross-Repo Graph Merge`  [EXTRACTED]
  .agents/skills/graphify/SKILL.md → .agents/skills/graphify/references/github-and-merge.md

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Graphify Core Execution Steps** — _agents_skills_graphify_skill_detect_files, _agents_skills_graphify_skill_ast_extraction, _agents_skills_graphify_skill_semantic_extraction, _agents_skills_graphify_skill_community_clustering, _agents_skills_graphify_skill_community_labeling [EXTRACTED 1.00]
- **Graphify Knowledge Traversal and Memory System** — _agents_skills_graphify_references_query_constrained_vocabulary_expansion, _agents_skills_graphify_references_query_bfs_dfs_traversal, _agents_skills_graphify_references_query_self_improving_feedback_loop [EXTRACTED 1.00]
- **Incremental Rebuilding and Watching Architecture** — _agents_skills_graphify_references_add_watch_graphify_watch, _agents_skills_graphify_references_update_incremental_update, _agents_skills_graphify_references_hooks_git_commit_hook [INFERRED 0.85]

## Communities (19 total, 9 thin omitted)

### Community 0 - "Graphify Full Pipeline"
Cohesion: 0.09
Nodes (24): Graphify Always On Rule, Graphify Ingestion (Add URL), Obsidian Vault Export, Confidence Score Rubric, Deterministic Node ID Format, Semantic Extraction Specification, Cross-Repo Graph Merge, CLAUDE.md Native Integration (+16 more)

### Community 1 - "rsvp_canvas.dart"
Cohesion: 0.09
Nodes (22): accentColor, build, _calculateOrpIndex, createState, _currentIndex, initState, _isPlaying, OrpGuidePainter (+14 more)

### Community 3 - "app.dart"
Cohesion: 0.13
Nodes (13): main, AgamaApp, build, build, LibraryView, ../features/library/library_view.dart, MaterialPageRoute, package:flutter/material.dart (+5 more)

### Community 11 - "AdaptivePacingEngine"
Cohesion: 0.22
Nodes (7): AdaptivePacingEngine, Default, Self, generate_rsvp_timings(), String, Vec, WordTiming

### Community 12 - "DatabaseEngine"
Cohesion: 0.38
Nodes (5): Connection, DatabaseEngine, Result, Self, Vec

### Community 13 - "SyncEngine"
Cohesion: 0.28
Nodes (5): Doc, Default, Self, Vec, SyncEngine

### Community 14 - "ParsedDocument"
Cohesion: 0.26
Nodes (9): DocumentParser, EpubParser, ParsedDocument, Option, Result, String, Vec, TextParser (+1 more)

### Community 15 - "models/mod.rs"
Cohesion: 0.43
Nodes (6): Document, DocumentChunk, generate_histvon_timestamp(), Highlight, Option, String

### Community 19 - "Agama"
Cohesion: 0.25
Nodes (7): 1. Build Rust Engine, 2. Generate FFI Bindings, 3. Run Flutter Application, Agama, Quick Start, Requirements, Structure

## Knowledge Gaps
- **41 isolated node(s):** `main`, `build`, `text`, `targetWpm`, `_words` (+36 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **9 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `WordTiming` connect `AdaptivePacingEngine` to `models/mod.rs`?**
  _High betweenness centrality (0.027) - this node is a cross-community bridge._
- **Why does `Document` connect `models/mod.rs` to `DatabaseEngine`?**
  _High betweenness centrality (0.017) - this node is a cross-community bridge._
- **What connects `main`, `build`, `text` to the rest of the system?**
  _41 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Graphify Full Pipeline` be split into smaller, more focused modules?**
  _Cohesion score 0.09057971014492754 - nodes in this community are weakly interconnected._
- **Should `rsvp_canvas.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.09090909090909091 - nodes in this community are weakly interconnected._
- **Should `app.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.13333333333333333 - nodes in this community are weakly interconnected._