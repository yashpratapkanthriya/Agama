# Agama Platform — Comprehensive Master Implementation Plan (New Features & Flow Gaps)

> **Document Status**: Approved Master Implementation Specification  
> **Source Documents**: `docs/new_nfeatures.md`, `docs/new_feature_diagram.md`, `docs/complete_end_to_end_implementation.md`  
> **Target Scope**: 15 New Components/Files, 15 Modified Existing Files (Total 30 Files)

---

## 1. Executive Summary & Context Topology

Based on `graphify` knowledge graph audit and architectural analysis of `docs/new_nfeatures.md` & `docs/new_feature_diagram.md`, Agama currently provides core RSVP / Bionic / Guided speed-reading engines, local ONNX vector search, and basic CRDT sync. However, **25 major UX flows and 20 visual diagrams** are required to transition Agama into a complete, enterprise-grade, offline-first speed-reading and knowledge synthesis platform.

This master implementation plan specifies the complete end-to-end steps, architecture refactoring, and exact file changes required.

---

## 2. File Change Inventory & Architecture Breakdown

| Category | File Path | Status | Primary Purpose / Scope |
| :--- | :--- | :--- | :--- |
| **Core Design System** | `apps/flutter_client/lib/src/core/app_tokens.dart` | **NEW** | Centralized design tokens (spacing, elevation, radii, breakpoints, motion) |
| **Core UI** | `apps/flutter_client/lib/src/core/empty_state_widget.dart` | **NEW** | Standardized empty state component with illustrations & CTAs |
| **Core Navigation** | `apps/flutter_client/lib/src/core/command_palette.dart` | **NEW** | Desktop/Web `⌘K` global search & action overlay modal |
| **Onboarding** | `apps/flutter_client/lib/src/features/onboarding/onboarding_view.dart` | **NEW** | Product tour, goal selector, engine guide, & tutorial |
| **Onboarding** | `apps/flutter_client/lib/src/features/onboarding/calibration_view.dart` | **NEW** | WPM speed calibration test & baseline calculator |
| **Auth & Identity** | `apps/flutter_client/lib/src/features/auth/auth_provider.dart` | **NEW** | Auth/Guest state manager & offline identity handling |
| **Auth & Identity** | `apps/flutter_client/lib/src/features/auth/profile_view.dart` | **NEW** | User profile, reading goals, streak tracking, & sync accounts |
| **Library** | `apps/flutter_client/lib/src/features/library/document_detail_view.dart` | **NEW** | Pre-reading document overview, summary, stats, & highlights |
| **Library** | `apps/flutter_client/lib/src/features/library/document_processing_modal.dart` | **NEW** | Step-by-step pipeline modal (OCR -> Chunking -> Vector Indexing) |
| **Library** | `apps/flutter_client/lib/src/features/library/url_import_service.dart` | **NEW** | Web URL scraper, clipboard auto-detector, & HTML text parser |
| **Knowledge & AI** | `apps/flutter_client/lib/src/features/knowledge/ai_chat_view.dart` | **NEW** | RAG document Q&A panel, auto-summarizer, & concept explainer |
| **Flashcards** | `apps/flutter_client/lib/src/features/flashcards/deck_model.dart` | **NEW** | Spaced Repetition System (SRS SM-2) memory queue models |
| **Flashcards** | `apps/flutter_client/lib/src/features/flashcards/deck_manager_view.dart` | **NEW** | Deck browser, card editor, & review queue manager |
| **Sync** | `apps/flutter_client/lib/src/features/sync/conflict_resolution_dialog.dart` | **NEW** | Interactive CRDT sync conflict resolver UI |
| **Settings** | `apps/flutter_client/lib/src/features/settings/keyboard_shortcuts_view.dart` | **NEW** | Interactive keyboard shortcut cheat sheet |
| **App Root** | `apps/flutter_client/lib/src/app/app.dart` | **MODIFIED** | Global `Shortcuts`/`Actions` listener (`⌘K`), onboarding route gate |
| **Theme** | `apps/flutter_client/lib/src/app/scholarly_theme.dart` | **MODIFIED** | `AppTokens` integration, high-contrast dark/sepia themes |
| **Library** | `apps/flutter_client/lib/src/features/library/library_view.dart` | **MODIFIED** | Add URL import button, click to `DocumentDetailView`, empty states |
| **Library** | `apps/flutter_client/lib/src/features/library/file_parser_service.dart` | **MODIFIED** | Integrate Web URL fetching & multi-format parser pipeline |
| **Reader Engine** | `apps/flutter_client/lib/src/features/reader/rsvp_canvas.dart` | **MODIFIED** | Add TOC drawer, bookmark manager, ETA indicator, pause rules |
| **Reader State** | `apps/flutter_client/lib/src/features/reader/reader_settings_provider.dart` | **MODIFIED** | Typography controls, punctuation delay, auto-pause settings |
| **Reader Engine** | `apps/flutter_client/lib/src/features/reader/guided_highlight_view.dart` | **MODIFIED** | Extended typography & bookmark triggers |
| **Reader Engine** | `apps/flutter_client/lib/src/features/reader/bionic_fixation_view.dart` | **MODIFIED** | Extended typography & bookmark triggers |
| **Flashcards** | `apps/flutter_client/lib/src/features/flashcards/flashcard_view.dart` | **MODIFIED** | Connect to SRS deck manager & SM-2 review queue |
| **Knowledge** | `apps/flutter_client/lib/src/features/annotations/annotation_view.dart` | **MODIFIED** | Add AI summary generator button & hybrid vector search |
| **Analytics** | `apps/flutter_client/lib/src/features/analytics/analytics_view.dart` | **MODIFIED** | Add WPM trend chart, CCI progress graph, heatmaps, streak counter |
| **Sync UI** | `apps/flutter_client/lib/src/features/sync/sync_view.dart` | **MODIFIED** | Queue status badge, manual trigger, conflict resolution prompt |
| **Settings UI** | `apps/flutter_client/lib/src/features/settings/user_settings_view.dart` | **MODIFIED** | Accessibility tab, Storage/Cache manager, Developer logs |
| **Rust API** | `native/rust_core/src/api/mod.rs` | **MODIFIED** | Add SRS SM-2 memory math functions & HTML/EPUB extractors |
| **Rust Models** | `native/rust_core/src/models/mod.rs` | **MODIFIED** | Add `SrsCardStats`, `ProcessingStage` enum, and CRDT sync metadata |

---

## 3. Step-by-Step Implementation Roadmap

### Phase 1: Foundation, Design Tokens & Component Library (Files 1-3)
1. **Design Tokens (`app_tokens.dart`)**: Define standardized spacing scale (4, 8, 12, 16, 24, 32, 48), radius scale (sm: 4, md: 8, lg: 16, xl: 24), elevation shadows, animation duration tokens (fast: 150ms, normal: 250ms, slow: 400ms), and responsive breakpoint thresholds.
2. **Unified Empty State (`empty_state_widget.dart`)**: Build a reusable visual container displaying customizable icons, headers, subtitles, primary CTA buttons, and secondary help links for all empty screens.
3. **Command Palette (`command_palette.dart`)**: Implement desktop/web modal popup overlay triggered by `⌘K` or `/` key binding. Includes quick navigation (Library, Reader, Knowledge, Analytics, Settings), recent document jump, engine chooser shortcut, and search action handlers.

---

### Phase 2: First-Time Experience, Auth & User Profile (Files 4-7, 16)
1. **Onboarding Flow (`onboarding_view.dart` & `calibration_view.dart`)**:
   - Welcome & product feature tour slides.
   - Interactive speed calibration test: present a sample passage, calculate initial comfortable WPM.
   - Goal setting screen: daily reading target (words/day or minutes/day).
   - Preference persistence in Riverpod & SharedPreferences.
2. **Auth & Identity Management (`auth_provider.dart` & `profile_view.dart`)**:
   - Support local offline guest identity with seamless upgrade path to synced account.
   - Profile view displaying active user stats, total words read, current daily streak badge, connected WebDAV / cloud sync accounts, and exported data backups.
3. **App Navigation Guard (`app.dart`)**:
   - Check onboarding completion flag on launch; route new users to `OnboardingView` before entering `LibraryView`.
   - Wire global keyboard listener for `⌘K` Command Palette.

---

### Phase 3: Document Lifecycle, Processing Pipeline & Import Options (Files 8-10, 18-19)
1. **Document Processing Modal (`document_processing_modal.dart`)**:
   - Render multi-stage progress dialog: `[1/4] Extracting Text` -> `[2/4] Chunking Passages` -> `[3/4] Generating Embeddings` -> `[4/4] Indexing Vector Store`.
2. **URL & Web Import (`url_import_service.dart`)**:
   - Add HTTP fetcher with article text extractor (HTML tag stripping, main content isolation).
   - Clipboard auto-detection: prompt user when valid HTTP URL or long text is detected in system clipboard.
3. **Document Details Intermediate View (`document_detail_view.dart`)**:
   - Insert document landing page showing title, estimated reading time, summary preview, extracted tags, table of contents outline, associated highlights/flashcards, and "Start Speed Reading" engine action buttons.
4. **Library Integration (`library_view.dart` & `file_parser_service.dart`)**:
   - Update Library cards to open `DocumentDetailView` on tap.
   - Add "Import from Web URL" and "Import from Clipboard" speed dial buttons.

---

### Phase 4: Reader Engine Overhaul & Extended Settings (Files 20-23, 30)
1. **Advanced Reader Settings (`reader_settings_provider.dart`)**:
   - Add typography customization: font choice (Inter, Roboto, OpenDyslexic, Serif), line spacing, margins.
   - Add pause parameters: punctuation delay multiplier (e.g. 2x pause on periods, 1.5x on commas), auto-pause frequency on long words (>12 chars).
2. **Reader Canvas Features (`rsvp_canvas.dart`, `guided_highlight_view.dart`, `bionic_fixation_view.dart`)**:
   - Table of Contents side-drawer: jump instantly to chapters or headings.
   - Bookmarks drawer: save and toggle bookmark pins.
   - Real-time ETA indicator: display remaining minutes based on current WPM and remaining word count.
   - Progress bar with chunk preview overlay.

---

### Phase 5: Knowledge Synthesis, Spaced Repetition & AI Features (Files 11-13, 24-25, 29)
1. **Spaced Repetition System (SRS SM-2) (`deck_model.dart`, `deck_manager_view.dart`, `flashcard_view.dart`)**:
   - Implement SuperMemo-2 algorithm in Rust/Dart (`native/rust_core/src/api/mod.rs` & `deck_model.dart`) calculating repetition intervals, ease factors, and review due dates.
   - Build Deck Manager UI for organizing flashcards into custom decks by document, topic, or tag.
   - Update Flashcard review screen with rating buttons (Again: 1, Hard: 2, Good: 3, Easy: 4) updating the review queue dynamically.
2. **RAG & AI Document Assistant (`ai_chat_view.dart` & `annotation_view.dart`)**:
   - Dedicated AI Chat panel allowing natural language Q&A grounded on active document vector chunks.
   - One-click actions: "Summarize Chapter", "Explain Concept", "Generate 5 Flashcards from Selection".

---

### Phase 6: Advanced Analytics, Sync & Comprehensive Settings (Files 14-15, 26-28)
1. **Analytics Dashboard Expansion (`analytics_view.dart`)**:
   - WPM progression line chart over 7/30/90 days.
   - Cognitive Capacity Index (CCI) trend graph combining WPM, focus score, and quiz retention rates.
   - GitHub-style reading streak activity heatmap grid.
2. **Conflict Resolution & Sync Queue (`conflict_resolution_dialog.dart` & `sync_view.dart`)**:
   - Interactive dialog displaying side-by-side local vs remote CRDT delta differences with "Keep Local", "Keep Remote", or "Merge Both" actions.
   - Offline sync queue status indicator showing pending local changes waiting for connection.
3. **User Settings & Developer Tools (`user_settings_view.dart` & `keyboard_shortcuts_view.dart`)**:
   - Accessibility settings: High Contrast toggle, Dyslexic font toggle, Reduced Motion mode.
   - Storage manager: view database size, clear vector cache, clear offline document cache.
   - Developer logs tab displaying FFI bridge calls, vector embedding performance timings, and sync logs.

---

## 4. Single Source of Truth (SSOT) Synchronization

To comply with Agama project guidelines:
1. All architectural decisions in this document update `docs/complete_end_to_end_implementation.md` and `docs/internal_user_manual.md`.
2. Following completion of code changes, `graphify update .` must be executed to keep AST topology synchronized.
3. Static analysis (`flutter analyze`, `cargo test`) and widget test suite (`flutter test`) must verify clean compilation with 0 errors.

---
