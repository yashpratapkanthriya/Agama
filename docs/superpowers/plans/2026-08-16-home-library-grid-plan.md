# Home Dashboard, Persistent Library Grid/List & Ingestion Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement 5-tab root navigation with a dedicated Home dashboard (Hero speed reader + Recent reads), persistent Document State repository with instant ingestion, and interactive Grid / List views in the Library tab.

**Architecture:** A shared Riverpod `StateNotifier` (`DocumentNotifier`) manages `List<DocumentItem>`. Home tab surfaces the hero speed reader and "Continue Reading" cards. Library tab features an interactive Grid/List toggle, search filter, and file/URL import buttons that immediately persist into the library.

**Tech Stack:** Flutter, Riverpod (`flutter_riverpod`), `google_fonts`, `file_picker`.

## Global Constraints
- Minimal dependencies only (do not add unused packages to `pubspec.yaml`).
- 0 lint errors (`flutter analyze`) and 0 test failures (`flutter test`).
- Semantic Conventional Commits (`feat(ui): ...`, `test(ui): ...`).

---

### Task 1: Document State Repository & Model
**Files:**
- Create: `apps/flutter_client/lib/src/features/library/document_repository.dart`
- Test: `apps/flutter_client/test/document_repository_test.dart`

**Interfaces:**
- Produces: `DocumentItem`, `DocumentNotifier`, `documentListProvider`

- [ ] **Step 1: Write unit test for `DocumentNotifier`**
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_client/src/features/library/document_repository.dart';

void main() {
  test('DocumentNotifier initializes with seed documents', () {
    final notifier = DocumentNotifier();
    expect(notifier.state.length, greaterThanOrEqualTo(3));
  });

  test('DocumentNotifier adds document and updates progress', () {
    final notifier = DocumentNotifier();
    final newDoc = DocumentItem(
      id: 'test-1',
      title: 'Test Doc',
      format: 'PDF',
      wordCount: 1200,
      progress: 0.0,
      lastReadAt: DateTime.now(),
      colorValue: 0xFF6366F1,
      content: 'Sample test content',
    );
    notifier.addDocument(newDoc);
    expect(notifier.state.any((d) => d.id == 'test-1'), isTrue);

    notifier.updateProgress('test-1', 0.45);
    final updated = notifier.state.firstWhere((d) => d.id == 'test-1');
    expect(updated.progress, 0.45);
  });
}
```

- [ ] **Step 2: Run test to verify failure**
Run: `cd apps/flutter_client && flutter test test/document_repository_test.dart`
Expected: FAIL (file missing)

- [ ] **Step 3: Implement `document_repository.dart`**
Create `apps/flutter_client/lib/src/features/library/document_repository.dart` with `DocumentItem`, initial seed docs, and `DocumentNotifier`.

- [ ] **Step 4: Run test to verify pass**
Run: `cd apps/flutter_client && flutter test test/document_repository_test.dart`
Expected: PASS

- [ ] **Step 5: Commit**
```bash
git add apps/flutter_client/lib/src/features/library/document_repository.dart apps/flutter_client/test/document_repository_test.dart
git commit -m "feat(library): add DocumentItem model and DocumentNotifier state repository"
```

---

### Task 2: Build Home Tab Dashboard with Recent Reads & Hero Reader
**Files:**
- Create: `apps/flutter_client/lib/src/features/home/home_tab_view.dart`
- Modify: `apps/flutter_client/lib/src/features/library/library_view.dart`
- Test: `apps/flutter_client/test/home_tab_view_test.dart`

**Interfaces:**
- Consumes: `documentListProvider`, `DocumentItem`
- Produces: `HomeTabView` widget

- [ ] **Step 1: Write widget test for `HomeTabView`**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_client/src/features/home/home_tab_view.dart';

void main() {
  testWidgets('HomeTabView renders hero reader and recent reads', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(body: HomeTabView()),
        ),
      ),
    );
    expect(find.textContaining('CONTINUE READING'), findsOneWidget);
    expect(find.textContaining('SELECT READING METHOD'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify failure**
Run: `cd apps/flutter_client && flutter test test/home_tab_view_test.dart`
Expected: FAIL

- [ ] **Step 3: Implement `HomeTabView`**
Create `apps/flutter_client/lib/src/features/home/home_tab_view.dart` with:
- Hero instant reader stage (Paste box + RSVP / Sweep / Bionic switcher + Live animated ORP redicle).
- "Continue Reading" horizontal cards displaying recent documents with resume button and progress bar.
- Daily streak & quick stats banner.

- [ ] **Step 4: Run test to verify pass**
Run: `cd apps/flutter_client && flutter test test/home_tab_view_test.dart`
Expected: PASS

- [ ] **Step 5: Commit**
```bash
git add apps/flutter_client/lib/src/features/home/home_tab_view.dart apps/flutter_client/test/home_tab_view_test.dart
git commit -m "feat(ui): add HomeTabView with recent reads carousel and hero speed reader"
```

---

### Task 3: Library Tab with Grid & List View Toggle and Ingestion Pipeline
**Files:**
- Modify: `apps/flutter_client/lib/src/features/library/library_view.dart`
- Create: `apps/flutter_client/lib/src/features/library/library_grid_card.dart`
- Test: `apps/flutter_client/test/library_grid_test.dart`

**Interfaces:**
- Consumes: `documentListProvider`, `DocumentItem`, `FileParserService`, `UrlImportService`
- Produces: `LibraryTabView` with Grid and List views

- [ ] **Step 1: Write widget test for Grid & List view toggle in Library**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_client/src/features/library/library_view.dart';

void main() {
  testWidgets('Library tab toggles between grid and list views', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: LibraryView(initialTab: 1),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.grid_view_rounded), findsOneWidget);
    expect(find.byIcon(Icons.view_list_rounded), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify failure**
Run: `cd apps/flutter_client && flutter test test/library_grid_test.dart`
Expected: FAIL

- [ ] **Step 3: Implement Grid view & Ingestion updates in `LibraryView`**
- Connect `LibraryView` to `ConsumerStatefulWidget` using `ref.watch(documentListProvider)`.
- Implement `_DocumentGridView` with responsive layout cards (Cover header, format tag, word count, progress ring/bar, launch button).
- Implement `_DocumentListView` with dense metadata rows.
- Ensure `_pickFile()` and `_importUrl()` append the new `DocumentItem` to `documentListProvider.notifier.addDocument(...)`.

- [ ] **Step 4: Run test to verify pass**
Run: `cd apps/flutter_client && flutter test test/library_grid_test.dart`
Expected: PASS

- [ ] **Step 5: Commit**
```bash
git add apps/flutter_client/lib/src/features/library/ apps/flutter_client/test/library_grid_test.dart
git commit -m "feat(library): add Grid and List view switcher and dynamic document ingestion"
```

---

### Task 4: 5-Tab Navigation & Route Integration
**Files:**
- Modify: `apps/flutter_client/lib/src/features/library/library_view.dart`
- Modify: `apps/flutter_client/lib/src/core/command_palette.dart`
- Modify: `apps/flutter_client/lib/src/features/settings/keyboard_shortcuts_view.dart`
- Test: `apps/flutter_client/test/navigation_test.dart`

- [ ] **Step 1: Write test for 5-tab navigation**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_client/src/features/library/library_view.dart';

void main() {
  testWidgets('LibraryView renders 5 navigation destinations', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: LibraryView(initialTab: 0),
        ),
      ),
    );
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Library'), findsOneWidget);
    expect(find.text('Knowledge'), findsOneWidget);
    expect(find.text('Analytics'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify failure**
Run: `cd apps/flutter_client && flutter test test/navigation_test.dart`
Expected: FAIL

- [ ] **Step 3: Update `LibraryView` scaffold and routes**
- Wire 5 NavigationBar destinations: Home (0), Library (1), Knowledge (2), Analytics (3), Settings (4).
- Update URL route listeners and command palette shortcuts (`⌘1` Home, `⌘2` Library, `⌘3` Knowledge, `⌘4` Analytics, `⌘5` Settings).

- [ ] **Step 4: Run test to verify pass**
Run: `cd apps/flutter_client && flutter test test/navigation_test.dart`
Expected: PASS

- [ ] **Step 5: Commit**
```bash
git add apps/flutter_client/lib/ apps/flutter_client/test/navigation_test.dart
git commit -m "feat(nav): integrate 5-tab root navigation and updated shortcut routing"
```

---

### Task 5: Static Analysis, Full Test Suite & Graph Update
**Files:**
- All modified files

- [ ] **Step 1: Run Rust core tests**
Run: `cargo test`
Expected: PASS (0 failures)

- [ ] **Step 2: Run Flutter analyze**
Run: `cd apps/flutter_client && flutter analyze`
Expected: 0 errors, 0 warnings

- [ ] **Step 3: Run all Flutter tests**
Run: `cd apps/flutter_client && flutter test`
Expected: All tests passing

- [ ] **Step 4: Update Knowledge Graph**
Run: `graphify update .`

- [ ] **Step 5: Final Semantic Commit**
```bash
git add .
git commit -m "chore(release): complete Home tab, persistent Library grid/list view, and doc ingestion"
```
