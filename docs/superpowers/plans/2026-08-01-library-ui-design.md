# Library UI Overhaul Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Remove the import bottom sheet and expose file picking and text pasting directly in the hero section, driving the engine launchers natively.

**Architecture:** A refactor of `LibraryView` to maintain a single local state containing `PlatformFile? selectedFile` and `String pastedText`, passing these to the selected engine route upon tap.

**Tech Stack:** Flutter, file_picker, Riverpod.

## Global Constraints

Zero-backend offline execution.
Native deps minimal.
AgamaTheme colors, JetBrains Mono, 12px radius.

---

### Task 1: Expose Direct Inputs in Hero Section

**Files:**
- Modify: `apps/flutter_client/lib/src/features/library/library_view.dart`
- Test: `apps/flutter_client/test/features/library/library_view_test.dart` (or create if needed)

**Interfaces:**
- Consumes: `file_picker`
- Produces: UI component for File/Text input

- [ ] **Step 1: Write the failing test**

```dart
// apps/flutter_client/test/features/library/library_view_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/src/features/library/library_view.dart';

void main() {
  testWidgets('LibraryView renders direct file picker and text inputs', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: const LibraryView()));
    expect(find.text('Select PDF, EPUB, or Markdown'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget); // For text paste
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd apps/flutter_client && flutter test test/features/library/library_view_test.dart`
Expected: FAIL

- [ ] **Step 3: Write minimal implementation**

Modify `apps/flutter_client/lib/src/features/library/library_view.dart` to add a `StatefulWidget` or use `State` to store `PlatformFile? selectedFile` and a `TextEditingController`.
Render the "Select PDF, EPUB, or Markdown" button and the `TextField` in the `_HeroSection`.

- [ ] **Step 4: Run test to verify it passes**

Run: `cd apps/flutter_client && flutter test test/features/library/library_view_test.dart`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
cd apps/flutter_client
git add .
git commit -m "feat(ui): add direct inputs in library hero section"
```

### Task 2: Connect Inputs to Engine Chooser and Remove Bottom Sheet

**Files:**
- Modify: `apps/flutter_client/lib/src/features/library/library_view.dart`

**Interfaces:**
- Consumes: Selected file / text state from Task 1.

- [ ] **Step 1: Write the failing test**

```dart
// Append to library_view_test.dart
  testWidgets('Engine click triggers validation if no input', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: const LibraryView()));
    await tester.tap(find.text('RSVP'));
    await tester.pumpAndSettle();
    expect(find.text('Please select a file or paste text first'), findsOneWidget);
  });
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd apps/flutter_client && flutter test test/features/library/library_view_test.dart`
Expected: FAIL

- [ ] **Step 3: Write minimal implementation**

In `apps/flutter_client/lib/src/features/library/library_view.dart`, modify `_EngineChooserSection`. When an engine is clicked:
1. Check if `selectedFile != null` OR `textController.text.isNotEmpty`.
2. If empty, show a `SnackBar` with 'Please select a file or paste text first'.
3. If valid, invoke `FileParserService` and push the appropriate route (like `RsvpCanvasView`).
4. Delete `_showImportSheet` and related bottom sheet code.

- [ ] **Step 4: Run test to verify it passes**

Run: `cd apps/flutter_client && flutter test test/features/library/library_view_test.dart`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
cd apps/flutter_client
git add .
git commit -m "feat(ui): connect inputs to engine launchers and remove bottom sheet"
```
