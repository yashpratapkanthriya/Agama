# Design Spec: Home Dashboard, Persistent Library with Grid/List Views, and Knowledge Integration

## 1. Overview & Goals
Provide a structured, persistent, and multi-view reading experience in the Agama Flutter UI:
1. **Home Tab (New)**: Instant speed reading hero stage (paste/type), live RSVP redicle animation, recent reads carousel ("Continue Reading"), and daily reading streak stats.
2. **Library Tab (Upgraded)**: Complete document repository with dynamic ingestion (PDF, EPUB, Markdown, Web URL), search & filtering, persistent state management, and an interactive **Grid / List view switcher**.
3. **Unified Document Repository**: Shared Riverpod state for documents so imported files persist across navigation, update reading progress, and feed into Knowledge AI Assistant.
4. **Knowledge Tab Linkage**: AI Document Assistant and Highlight annotations dynamically reference loaded library documents.

---

## 2. Navigation Architecture (5 Persistent Tabs)

```
Root: LibraryView (Scaffold with NavigationBar / NavigationRail)
 ├── Tab 0: Home (/home)
 │     ├── Hero RSVP Live Preview & Quick Reader Stage (Paste / Direct Input)
 │     ├── "Continue Reading" Recent Documents Carousel
 │     └── Quick Stats Strip (Streak, WPM Goal, Today's Words Read)
 ├── Tab 1: Library (/library)
 │     ├── Header: Search Bar + View Toggle (Grid / List) + "Import Document" button
 │     ├── Grid View (2-3 column responsive cards with cover preview, badge, % progress)
 │     ├── List View (Detailed rows with word count, format badge, progress bar, action menu)
 │     └── Empty State / Ingestion Dropzone
 ├── Tab 2: Knowledge (/knowledge)
 │     ├── AI Document Assistant (Local RAG grounded in loaded docs)
 │     ├── Highlights & Notes (Semantic vector search)
 │     └── Flashcards & Deck Manager (SM-2 spaced repetition)
 ├── Tab 3: Analytics (/analytics)
 │     └── Reading speed trends, comprehension curves, cognitive load graphs
 └── Tab 4: Settings (/settings)
       └── User profile, reading preferences, keyboard shortcuts
```

---

## 3. Component & State Design

### 3.1 Document State Management (`DocumentProvider`)
- Model: `DocumentItem`
  - `id`: Unique UUID
  - `title`: Extracted title or filename
  - `format`: `PDF`, `EPUB`, `MD`, `TXT`, `WEB`
  - `wordCount`: Computed integer
  - `progress`: Floating point 0.0 to 1.0
  - `lastReadAt`: DateTime
  - `content`: Raw text content
  - `color`: Accent theme color
- Provider: `documentListProvider` (`StateNotifier<List<DocumentItem>>`)
  - Initial seed documents (SAD Architecture, Quantum Optics, ONNX Engine)
  - `addDocument(DocumentItem doc)`
  - `updateProgress(String id, double progress)`
  - `removeDocument(String id)`

### 3.2 Home Tab View (`_HomeTab`)
- **Hero Input Stage**: Preserves the instant paste/input box with method switcher (RSVP Redicle, Guided Sweep, Bionic Fixation) and live redicle animated ticker.
- **Recent Reads Strip**: Displays last 3 active documents in cards with resume button, current reading progress %, and estimated time left.

### 3.3 Library Tab View (`_LibraryTab`)
- **Action Header**:
  - Search input field for real-time document filtering.
  - Import button (`Import PDF / EPUB / MD` & `Import URL`).
  - View toggle button group: `[ ⊞ Grid | ☰ List ]`.
- **Grid Layout**: Responsive `GridView.builder` with card elevation, document format tag, reading progress bar, word count, and quick tap to open `DocumentDetailView`.
- **List Layout**: `ListView.separated` with horizontal tiles, status chips, and delete/archive actions.

### 3.4 Ingestion & Flow
1. User clicks **Import** in Library tab or top bar.
2. File picker or URL dialog parses file via `FileParserService`.
3. New `DocumentItem` created and added to `documentListProvider`.
4. Navigates to `DocumentDetailView` for structural inspection (TOC, syntax complexity).
5. Reading session launched in chosen engine (RSVP / Sweep / Bionic).
6. Progress automatically updates upon reader exit and reflects on Home & Library tabs.

---

## 4. Verification & Testing Gate
- `cargo test`: Ensure Rust core engine tests pass.
- `flutter analyze`: 0 errors, 0 warnings.
- `flutter test`: Unit and widget tests for Home view, Library Grid/List toggle, and Document state updates.
