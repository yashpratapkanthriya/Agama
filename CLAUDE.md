# Agama Platform — Agent Guidelines & Memory Contract (CLAUDE.md)

This file defines the mandatory workflows, agent behaviors, coding rules, and verification standards for all AI agent sessions working on the Agama platform.

---

## 1. Process & Skill Activation Rules (Superpowers Plugin)
- **Always invoke relevant skills BEFORE taking action or asking clarifying questions** (`superpowers:using-superpowers`).
- **Pre-Implementation**: Invoke `superpowers:brainstorming` before designing or writing new features.
- **Debugging & Error Investigation**: Invoke `superpowers:systematic-debugging` first when encountering bugs or test failures.
- **Verification Gate**: Invoke `superpowers:verification-before-completion` before claiming any status, committing, or creating PRs.
- **Branch Completion**: Invoke `superpowers:finishing-a-development-branch` when feature implementation is complete and verified green.

---

## 2. Token & Architecture Optimization Modes
- **Caveman Engine (`wenyan-ultra` / `ultra`)**: Maintain concise, dense, high-efficiency responses to preserve context window longevity.
- **Ponytail Engine (`ultra`)**: Enforce anti-overengineering rules — eliminate dead code, unnecessary abstraction wrappers, and complex boilerplate.

---

## 3. Knowledge Graph Navigation (Graphify)
- **Architecture & Codebase Queries**: When `graphify-out/graph.json` exists, always query the knowledge graph first via CLI:
  ```bash
  graphify query "<question>"
  ```
- **Graph Updates**: Always execute `graphify update .` after making code modifications to keep AST knowledge topology current.

---

## 4. Branching, PR per Feature & Semantic Commits
- **Feature Isolation**: Work on feature branches (`feature/<domain-name>`) for each distinct feature module.
- **Pull Requests (PR)**: Create PR per feature, verify linting & test suite on merged result, and merge cleanly.
- **Semantic Commit Conventions**: Enforce exact Conventional Commits format:
  - `feat(<scope>): ...` — New features (e.g. `feat(ai): ...`, `feat(ui): ...`, `feat(db): ...`)
  - `fix(<scope>): ...` — Bug fixes
  - `docs(<scope>): ...` — Documentation updates
  - `test(<scope>): ...` — Unit and widget test additions
  - `chore(<scope>): ...` — Maintenance, dependencies, and graph updates

---

## 5. Build, Testing & Code Linting Verification
All changes MUST pass clean static analysis and unit tests with 0 errors and 0 failures:

```bash
# 1. Rust Engine Core Tests
cargo test

# 2. Flutter UI Shell Linting & Widget Tests
cd apps/flutter_client
flutter analyze
flutter test
```

---

## 6. Single Source of Truth (SSOT) Architecture References
- **Master Implementation Spec**: [`docs/complete_end_to_end_implementation.md`](file:///Users/yashpratap/Documents/GitHub/Agama/docs/complete_end_to_end_implementation.md)
- **Database & Historization Schema**: [`docs/schema.md`](file:///Users/yashpratap/Documents/GitHub/Agama/docs/schema.md) (`histvon` 17-char timestamp, `histbis = '9999'` active marker)
- **Decentralized Sync Architecture**: [`docs/decentralized_sync_architecture.md`](file:///Users/yashpratap/Documents/GitHub/Agama/docs/decentralized_sync_architecture.md)
- **Software Architecture Description**: [`docs/SAD.md`](file:///Users/yashpratap/Documents/GitHub/Agama/docs/SAD.md)
