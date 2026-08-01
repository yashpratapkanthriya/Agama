# Graph Report - /Users/yashpratap/Documents/GitHub/Agama  (2026-08-01)

## Corpus Check
- Corpus is ~10,988 words - fits in a single context window. You may not need a graph.

## Summary
- 31 nodes · 25 edges · 11 communities (4 shown, 7 thin omitted)
- Extraction: 92% EXTRACTED · 8% INFERRED · 0% AMBIGUOUS · INFERRED: 2 edges (avg confidence: 0.85)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- Core Pipeline and Extraction System
- Incremental Update and Rule Integration
- Semantic Extraction Specifications
- Query Traversal and Vocabulary Expansion
- Watch Mode System
- FalkorDB Graph Export
- MCP Server Integration
- Neo4j Cypher Export
- Token Reduction Benchmark
- Monorepo Merging Workflows
- Cluster-Only Execution

## God Nodes (most connected - your core abstractions)
1. `Graphify Full Pipeline` - 15 edges
2. `Graph Traversal Modes` - 4 edges
3. `Graphify Always On Rule` - 3 edges
4. `Semantic Extraction Specification` - 3 edges
5. `Incremental Update Pipeline` - 3 edges
6. `Graphify Fast Path` - 2 edges
7. `Semantic Extraction Subagents` - 2 edges
8. `Code-Only Update Fast Path` - 2 edges
9. `File Detection Step` - 1 edges
10. `AST Structural Extraction` - 1 edges

## Surprising Connections (you probably didn't know these)
- `Graphify Always On Rule` --semantically_similar_to--> `CLAUDE.md Native Integration`  [INFERRED] [semantically similar]
  .agents/rules/graphify.md → .agents/skills/graphify/references/hooks.md
- `Graphify Fast Path` --semantically_similar_to--> `Code-Only Update Fast Path`  [INFERRED] [semantically similar]
  .agents/skills/graphify/SKILL.md → .agents/skills/graphify/references/update.md
- `Graphify Always On Rule` --references--> `Graph Traversal Modes`  [EXTRACTED]
  .agents/rules/graphify.md → .agents/skills/graphify/references/query.md
- `Graphify Full Pipeline` --references--> `Graphify Ingestion (Add URL)`  [EXTRACTED]
  .agents/skills/graphify/SKILL.md → .agents/skills/graphify/references/add-watch.md
- `Graphify Full Pipeline` --references--> `Obsidian Vault Export`  [EXTRACTED]
  .agents/skills/graphify/SKILL.md → .agents/skills/graphify/references/exports.md

## Hyperedges (group relationships)
- **Graphify Core Execution Steps** — _agents_skills_graphify_skill_detect_files, _agents_skills_graphify_skill_ast_extraction, _agents_skills_graphify_skill_semantic_extraction, _agents_skills_graphify_skill_community_clustering, _agents_skills_graphify_skill_community_labeling [EXTRACTED 1.00]
- **Graphify Knowledge Traversal and Memory System** — _agents_skills_graphify_references_query_constrained_vocabulary_expansion, _agents_skills_graphify_references_query_bfs_dfs_traversal, _agents_skills_graphify_references_query_self_improving_feedback_loop [EXTRACTED 1.00]
- **Incremental Rebuilding and Watching Architecture** — _agents_skills_graphify_references_add_watch_graphify_watch, _agents_skills_graphify_references_update_incremental_update, _agents_skills_graphify_references_hooks_git_commit_hook [INFERRED 0.85]

## Communities (11 total, 7 thin omitted)

### Community 0 - "Core Pipeline and Extraction System"
Cohesion: 0.17
Nodes (12): Graphify Ingestion (Add URL), Obsidian Vault Export, Cross-Repo Graph Merge, Git Post-Commit Hook, Whisper Video Audio Transcription, AST Structural Extraction, Community Clustering Step, Community Labeling Step (+4 more)

### Community 1 - "Incremental Update and Rule Integration"
Cohesion: 0.40
Nodes (5): Graphify Always On Rule, CLAUDE.md Native Integration, Code-Only Update Fast Path, Incremental Update Pipeline, Graphify Fast Path

### Community 2 - "Semantic Extraction Specifications"
Cohesion: 0.50
Nodes (4): Confidence Score Rubric, Deterministic Node ID Format, Semantic Extraction Specification, Semantic Extraction Subagents

### Community 3 - "Query Traversal and Vocabulary Expansion"
Cohesion: 0.67
Nodes (3): Graph Traversal Modes, Constrained Vocabulary Expansion, Self-Improving Feedback Loop

## Knowledge Gaps
- **18 isolated node(s):** `File Detection Step`, `AST Structural Extraction`, `Community Clustering Step`, `Community Labeling Step`, `Graphify Ingestion (Add URL)` (+13 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **7 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Graphify Full Pipeline` connect `Core Pipeline and Extraction System` to `Incremental Update and Rule Integration`, `Semantic Extraction Specifications`, `Query Traversal and Vocabulary Expansion`?**
  _High betweenness centrality (0.523) - this node is a cross-community bridge._
- **Why does `Semantic Extraction Subagents` connect `Semantic Extraction Specifications` to `Core Pipeline and Extraction System`?**
  _High betweenness centrality (0.138) - this node is a cross-community bridge._
- **Why does `Graph Traversal Modes` connect `Query Traversal and Vocabulary Expansion` to `Core Pipeline and Extraction System`, `Incremental Update and Rule Integration`?**
  _High betweenness centrality (0.137) - this node is a cross-community bridge._
- **What connects `File Detection Step`, `AST Structural Extraction`, `Community Clustering Step` to the rest of the system?**
  _18 weakly-connected nodes found - possible documentation gaps or missing edges._