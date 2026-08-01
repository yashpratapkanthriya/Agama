# Reading Engine Overhaul Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Overhaul Agama document ingestion and speed reading engine with PDF/EPUB/URL parsers and highly customizable RSVP/Bionic reader views.

**Architecture:** Pure-Dart parsing pipeline integrated with a Riverpod-backed reader settings provider and updated Flutter canvas UI components.

**Tech Stack:** Flutter, Dart, Riverpod.

## Global Constraints

- Pure Dart for web compatibility. No FFI for parsing.
- 0 errors/failures on `flutter analyze` and `flutter test`.
- All native flutter_rust_bridge / FFI dependencies untouched if not used.

---

### Task 1: Reader Settings Provider

**Files:**
- Create: `apps/flutter_client/lib/src/features/reader/reader_settings_provider.dart`
- Test: `apps/flutter_client/test/features/reader/reader_settings_provider_test.dart`

**Interfaces:**
- Produces: `ReaderSettings` model, `readerSettingsProvider` (StateNotifierProvider)

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agama/src/features/reader/reader_settings_provider.dart';

void main() {
  test('readerSettingsProvider defaults', () {
    final container = ProviderContainer();
    final settings = container.read(readerSettingsProvider);
    
    expect(settings.wpm, 350);
    expect(settings.fontSize, 24.0);
    expect(settings.fontFamily, 'Inter');
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/reader/reader_settings_provider_test.dart`
Expected: FAIL (File not found)

- [ ] **Step 3: Write minimal implementation**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReaderSettings {
  final int wpm;
  final double fontSize;
  final String fontFamily;

  const ReaderSettings({
    this.wpm = 350,
    this.fontSize = 24.0,
    this.fontFamily = 'Inter',
  });
}

class ReaderSettingsNotifier extends StateNotifier<ReaderSettings> {
  ReaderSettingsNotifier() : super(const ReaderSettings());
}

final readerSettingsProvider = StateNotifierProvider<ReaderSettingsNotifier, ReaderSettings>((ref) {
  return ReaderSettingsNotifier();
});
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/reader/reader_settings_provider_test.dart`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add apps/flutter_client/lib/src/features/reader/reader_settings_provider.dart apps/flutter_client/test/features/reader/reader_settings_provider_test.dart
git commit -m "feat(reader): add reader settings provider"
```

### Task 2: Update File Parser Service

**Files:**
- Modify: `apps/flutter_client/lib/src/features/library/file_parser_service.dart:18-70`
- Test: `apps/flutter_client/test/features/library/file_parser_service_test.dart`

**Interfaces:**
- Produces: Updated `FileParserService` with `parseUrl` method.

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:agama/src/features/library/file_parser_service.dart';

void main() {
  test('parseUrl stub', () {
    final service = FileParserService();
    final doc = service.parseUrl('https://example.com');
    expect(doc.format, DocumentFormat.markdown);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/library/file_parser_service_test.dart`
Expected: FAIL (Method not found)

- [ ] **Step 3: Write minimal implementation**

Update `FileParserService` in `file_parser_service.dart` to include `parseUrl`:

```dart
  ParsedDocument parseUrl(String url) {
    // Stub for URL fetch/parse
    return ParsedDocument(
      title: url,
      content: 'Extracted content from $url',
      format: DocumentFormat.markdown,
    );
  }
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/library/file_parser_service_test.dart`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add apps/flutter_client/lib/src/features/library/file_parser_service.dart apps/flutter_client/test/features/library/file_parser_service_test.dart
git commit -m "feat(library): add url parse stub to file parser service"
```

### Task 3: Update RSVP Canvas UI

**Files:**
- Modify: `apps/flutter_client/lib/src/features/reader/rsvp_canvas.dart`
- Test: `apps/flutter_client/test/features/reader/rsvp_canvas_test.dart`

**Interfaces:**
- Consumes: `readerSettingsProvider`

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agama/src/features/reader/rsvp_canvas.dart';

void main() {
  testWidgets('RSVPCanvas consumes settings', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(body: RSVPCanvas()),
        ),
      ),
    );
    expect(find.byType(RSVPCanvas), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/reader/rsvp_canvas_test.dart`
Expected: FAIL (Depends on current RSVPCanvas state / missing imports)

- [ ] **Step 3: Write minimal implementation**

Modify `rsvp_canvas.dart` to consume `readerSettingsProvider`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'reader_settings_provider.dart';

class RSVPCanvas extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(readerSettingsProvider);
    return Center(
      child: Text(
        'RSVP WPM: ${settings.wpm}',
        style: TextStyle(fontSize: settings.fontSize, fontFamily: settings.fontFamily),
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/reader/rsvp_canvas_test.dart`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add apps/flutter_client/lib/src/features/reader/rsvp_canvas.dart apps/flutter_client/test/features/reader/rsvp_canvas_test.dart
git commit -m "feat(reader): integrate settings provider into RSVP canvas"
```
