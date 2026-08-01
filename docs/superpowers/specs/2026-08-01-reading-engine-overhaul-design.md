# Design Spec: Agama Sub-project 1 — Document Ingestion & Reading Engine Overhaul

## 1. Overview
This specification details the comprehensive overhaul of Agama's Document Ingestion and Speed Reading Engine. It addresses user feedback regarding missing and incomplete features by introducing robust PDF, EPUB, Markdown, and Web URL document ingestion alongside a highly customizable, ultra-responsive multi-engine reader (RSVP, Bionic Fixation, Guided Highlighting) with full theme, font, ORP reticle, and audio/TTS capabilities.

---

## 2. Architecture & Data Model

### 2.1 Document Ingestion Layer (`apps/flutter_client/lib/src/features/library/file_parser_service.dart`)
- **PDF Parser**: Pure-Dart PDF token stream extractor that parses page structure, extracts text blocks, strips control/binary sequences cleanly, and constructs well-formatted paragraphs.
- **EPUB Parser**: Container XML and OPF manifest reader unzipping EPUB archives, parsing chapter spine order, and converting XHTML content to structured plain text/markdown.
- **Markdown & Text Parser**: Preserves headers, lists, code blocks, and paragraph boundaries.
- **Web URL Parser**: Fetches web article URLs, strips navigation/ads, and extracts clean article body text.

### 2.2 Reader Settings State (`apps/flutter_client/lib/src/features/reader/reader_settings_provider.dart`)
- `wpm`: Reading speed (100–1200 WPM, default: 350).
- `fontSize`: Reader font size (14.0–48.0 px, default: 24.0).
- `fontFamily`: Font selection (`Inter`, `Roboto`, `Merriweather`, `JetBrains Mono`, `OpenDyslexic`).
- `themeMode`: Color palette (`OLED Dark`, `Sepia`, `Cream`, `Midnight Blue`).
- `orpColor`: Optimal Recognition Point reticle color (`Red`, `Amber`, `Cyan`, `Emerald`).
- `punctuationPauseMultiplier`: Dynamic delay scaling (1.5x for commas, 2.0x for sentence stops).
- `bionicFixationWeight`: Fixation bold ratio (30%–70%).
- `ttsEnabled`: Toggle for synchronized text-to-speech audio preview.

---

## 3. Component Design & User Interface

### 3.1 Library & Document Import (`library_view.dart`)
- **Drag-and-Drop / File Picker**: Supports `.pdf`, `.epub`, `.md`, `.txt` with real-time file validation and metadata parsing (word count, reading time estimation).
- **Web URL Import Sheet**: Input box to paste article links with instant live scraping and preview.

### 3.2 Multi-Engine Reader Workspace (`rsvp_canvas.dart`, `bionic_fixation_view.dart`, `guided_highlight_view.dart`)
- **RSVP Reader Canvas**:
  - Precision ORP (Optimal Recognition Point) redicle display box with customizable highlight color.
  - Surrounding context strip showing preceding and succeeding words (±3 words).
  - Play/pause toggle, scrubbing timeline slider, WPM adjustment, and keyboard shortcut support (Space = Play/Pause, Left/Right = Skip, Up/Down = Speed).
- **Bionic Fixation View**:
  - Highlights initial word stems in bold.
  - Interactive selection for highlight creation and note taking.
- **Guided Highlight View**:
  - Smooth vertical auto-scrolling with line focus pacing.
- **Reader Customization Drawer / Modal**:
  - Live controls for Theme, Font Family, Font Size, ORP Color, and TTS toggle.

---

## 4. Error Handling & Edge Cases
- **Corrupted PDF/EPUB Files**: Gracefully fall back to raw UTF-8 string decoding with a user-facing notification alert.
- **Empty or Unsupported Files**: Provide clear diagnostic error messages without crashing the app shell.
- **Web Fetch Timeouts / CORS**: Handle network errors gracefully with retry prompt.

---

## 5. Verification Plan
- `cargo test`: Ensure Rust core engine builds cleanly.
- `flutter analyze`: Validate static analysis with 0 errors.
- `flutter test`: Run widget and unit tests for document parser service and reader views.
