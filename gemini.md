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

## 5. Interactive Requirement Alignment & Pre-Merge Confirmation Protocol
- **Pre-PR Merge Confirmation**: Before merging any feature branch or finalizing a Pull Request (PR), ALWAYS present a summary of changes and explicitly ask the user for confirmation to verify if any adjustments are needed.
- **Interactive Requirement Interviewing (`/grill-me`)**: Whenever new instructions or feature requests are given, trigger interactive clarification questions to drill down on requirements, resolve ambiguities, and ensure the correct behavior is designed before writing code.
- **Live Browser Preview Offer**: Once any UI component, interactive dashboard, or feature tutorial/manual is built or updated, ALWAYS explicitly ask the user if they would like to launch and preview it live in action on their browser (`flutter run -d chrome` or browser preview tools).
- **Graphify Dependency Coverage Audit**: Use `graphify query` / `query_graph` to inspect all dependent code nodes, callers, tests, and linked documentation pages. Ensure 100% of linked dependencies, related code files, tests, and documentation pages are fully updated and synchronized.

---

## 6. Build, Testing & Code Linting Verification
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

## 7. Single Source of Truth (SSOT) Architecture References
- **Master Implementation Spec**: [`docs/complete_end_to_end_implementation.md`](file:///Users/yashpratap/Documents/GitHub/Agama/docs/complete_end_to_end_implementation.md)
- **Interactive Web Manual**: [`docs/internal_manual.html`](file:///Users/yashpratap/Documents/GitHub/Agama/docs/internal_manual.html)
- **Internal User Manual**: [`docs/internal_user_manual.md`](file:///Users/yashpratap/Documents/GitHub/Agama/docs/internal_user_manual.md)
- **Database & Historization Schema**: [`docs/schema.md`](file:///Users/yashpratap/Documents/GitHub/Agama/docs/schema.md) (`histvon` 17-char timestamp, `histbis = '9999'` active marker)
- **Decentralized Sync Architecture**: [`docs/decentralized_sync_architecture.md`](file:///Users/yashpratap/Documents/GitHub/Agama/docs/decentralized_sync_architecture.md)
- **Software Architecture Description**: [`docs/SAD.md`](file:///Users/yashpratap/Documents/GitHub/Agama/docs/SAD.md)

---

## 8. Platform & Build State (current)

### Supported Platforms
- **web** (`web/`) — Chrome via `flutter run -d chrome`
- **macOS** (`macos/`) — requires Xcode; `flutter run -d macos`
- Android / iOS: platform dirs not yet scaffolded

### pubspec.yaml — minimal deps only
All unused native deps stripped (flutter_rust_bridge, flutter_secure_storage, file_picker, path_provider, flutter_spinkit, smooth_page_indicator, flutter_markdown, riverpod_generator, build_runner, freezed_annotation, json_annotation). Only keep:
- `flutter_riverpod` — state
- `google_fonts` — typography

> **Rule:** Never re-add a dep without a direct import in `lib/`. Verify with: `grep -r '<dep>' apps/flutter_client/lib/`

### Navigation architecture
- **Root:** `LibraryView` (StatefulWidget) with `NavigationBar` — 3 tabs: Library · Knowledge · Analytics
- **Library tab:** hero section direct file/text input → engine chooser → push reader route
- **Knowledge tab:** Highlights (`AnnotationView`) + Flashcards (`FlashcardView`)
- **Analytics tab:** inline `AnalyticsView` (no push)
- All reader routes: push from Library tab via `Navigator.push`

### DevTools & VS Code Integration
- **Flutter DevTools Reference**: [Flutter DevTools for VS Code](https://docs.flutter.dev/tools/devtools/vscode)
- **Launch Configurations**: `.vscode/launch.json` configured for Chrome Web (`-d chrome`) and macOS (`-d macos`).
- **DevTools Auto-Open**: `.vscode/settings.json` configured to auto-launch Flutter Inspector and widget error notifications.

### UX invariants
- No dead SnackBar for navigable actions
- RSVP reader always shows context strip (±3 words)
- Engine chooser always shows tradeoffs, WPM range, best-for before user commits
- Import = paste text (no file_picker dep needed for demo)
