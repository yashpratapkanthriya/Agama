# Agama Platform — Master Implementation Plan (New Features & Flow Gaps)

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement 25 missing UX flows and 20 diagram features across 30 files in Agama platform to turn visual spec into complete production-ready application.

**Architecture:** Flutter Riverpod state management + Rust FFI core + SQLite/CRDT local-first storage. Mobile, Web, and Desktop cross-platform responsive layout.

**Tech Stack:** Dart 3.0+, Flutter 3.x, Riverpod 2.x, Rust (cargo), Google Fonts, FRB (Flutter Rust Bridge).

## Global Constraints

- **Minimal Dependencies**: Only keep `flutter_riverpod` and `google_fonts` in `pubspec.yaml`. No unapproved third-party packages.
- **Historization Schema**: `histvon` 17-char ISO timestamp, `histbis = '9999'` active marker.
- **Verification Gate**: All tasks must pass `flutter analyze` and `flutter test` clean with 0 errors.

---

### Task 1: Design Tokens & Core Visual Components

**Files:**
- Create: `apps/flutter_client/lib/src/core/app_tokens.dart`
- Create: `apps/flutter_client/lib/src/core/empty_state_widget.dart`
- Modify: `apps/flutter_client/lib/src/app/scholarly_theme.dart`
- Test: `apps/flutter_client/test/core_tokens_test.dart`

**Interfaces:**
- Produces: `AppTokens` constants (`AppTokens.spaceMd`, `AppTokens.radiusMd`, `AppTokens.elevationSm`), `EmptyStateWidget` widget.

- [ ] **Step 1: Write failing widget test for AppTokens and EmptyStateWidget**

```dart
// apps/flutter_client/test/core_tokens_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_client/src/core/app_tokens.dart';
import 'package:flutter_client/src/core/empty_state_widget.dart';

void main() {
  testWidgets('EmptyStateWidget renders title and icon', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EmptyStateWidget(
            icon: Icons.book_outlined,
            title: 'No Documents Found',
            subtitle: 'Import a document to get started',
          ),
        ),
      ),
    );

    expect(find.text('No Documents Found'), findsOneWidget);
    expect(find.text('Import a document to get started'), findsOneWidget);
    expect(find.byIcon(Icons.book_outlined), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd apps/flutter_client && flutter test test/core_tokens_test.dart`  
Expected: FAIL with "Target file not found"

- [ ] **Step 3: Implement AppTokens and EmptyStateWidget**

```dart
// apps/flutter_client/lib/src/core/app_tokens.dart
import 'package:flutter/material.dart';

abstract class AppTokens {
  static const double spaceXs = 4.0;
  static const double spaceSm = 8.0;
  static const double spaceMd = 16.0;
  static const double spaceLg = 24.0;
  static const double spaceXl = 32.0;

  static const double radiusSm = 4.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 16.0;

  static const Duration animFast = Duration(milliseconds: 150);
  static const Duration animNormal = Duration(milliseconds: 250);
}
```

```dart
// apps/flutter_client/lib/src/core/empty_state_widget.dart
import 'package:flutter/material.dart';
import 'app_tokens.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? action;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTokens.spaceLg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: theme.colorScheme.primary.withOpacity(0.5)),
            const SizedBox(height: AppTokens.spaceMd),
            Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppTokens.spaceSm),
            Text(subtitle, textAlign: TextAlign.center, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            if (action != null) ...[
              const SizedBox(height: AppTokens.spaceLg),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `cd apps/flutter_client && flutter test test/core_tokens_test.dart`  
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add apps/flutter_client/lib/src/core/ apps/flutter_client/lib/src/app/scholarly_theme.dart apps/flutter_client/test/core_tokens_test.dart
git commit -m "feat(ui): add design system tokens and standardized empty state widget"
```

---

### Task 2: Command Palette & Global Shortcut Navigation

**Files:**
- Create: `apps/flutter_client/lib/src/core/command_palette.dart`
- Create: `apps/flutter_client/lib/src/features/settings/keyboard_shortcuts_view.dart`
- Modify: `apps/flutter_client/lib/src/app/app.dart`
- Test: `apps/flutter_client/test/command_palette_test.dart`

**Interfaces:**
- Consumes: `AppTokens`
- Produces: `CommandPaletteModal`, keyboard shortcut actions.

- [ ] **Step 1: Write failing widget test for Command Palette**

```dart
// apps/flutter_client/test/command_palette_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_client/src/core/command_palette.dart';

void main() {
  testWidgets('CommandPaletteModal filters actions on typing', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CommandPaletteModal(),
        ),
      ),
    );

    expect(find.text('Command Palette'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Settings');
    await tester.pumpAndSettle();
    expect(find.text('Go to Settings'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd apps/flutter_client && flutter test test/command_palette_test.dart`  
Expected: FAIL

- [ ] **Step 3: Implement CommandPaletteModal and shortcuts listener**

```dart
// apps/flutter_client/lib/src/core/command_palette.dart
import 'package:flutter/material.dart';
import 'app_tokens.dart';

class CommandPaletteModal extends StatefulWidget {
  const CommandPaletteModal({super.key});

  @override
  State<CommandPaletteModal> createState() => _CommandPaletteModalState();
}

class _CommandPaletteModalState extends State<CommandPaletteModal> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  final List<Map<String, String>> _commands = const [
    {'title': 'Go to Library', 'category': 'Navigation'},
    {'title': 'Go to Knowledge', 'category': 'Navigation'},
    {'title': 'Go to Analytics', 'category': 'Navigation'},
    {'title': 'Go to Settings', 'category': 'Navigation'},
    {'title': 'Import Text / Document', 'category': 'Action'},
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _commands.where((c) => c['title']!.toLowerCase().contains(_query.toLowerCase())).toList();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTokens.radiusLg)),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(AppTokens.spaceMd),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.search),
                const SizedBox(width: AppTokens.spaceSm),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    autofocus: true,
                    decoration: const InputDecoration(hintText: 'Type a command or search...', border: InputBorder.none),
                    onChanged: (val) => setState(() => _query = val),
                  ),
                ),
              ],
            ),
            const Divider(),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final cmd = filtered[index];
                  return ListTile(
                    title: Text(cmd['title']!),
                    subtitle: Text(cmd['category']!),
                    onTap: () => Navigator.of(context).pop(cmd['title']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `cd apps/flutter_client && flutter test test/command_palette_test.dart`  
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add apps/flutter_client/lib/src/core/command_palette.dart apps/flutter_client/lib/src/features/settings/keyboard_shortcuts_view.dart apps/flutter_client/lib/src/app/app.dart apps/flutter_client/test/command_palette_test.dart
git commit -m "feat(ui): add command palette modal and global keyboard shortcuts"
```

---

### Task 3: Onboarding & WPM Calibration Flow

**Files:**
- Create: `apps/flutter_client/lib/src/features/onboarding/onboarding_view.dart`
- Create: `apps/flutter_client/lib/src/features/onboarding/calibration_view.dart`
- Modify: `apps/flutter_client/lib/src/app/app.dart`
- Test: `apps/flutter_client/test/onboarding_test.dart`

**Interfaces:**
- Consumes: `AppTokens`
- Produces: `OnboardingView`, `CalibrationView`.

- [ ] **Step 1: Write failing test for OnboardingView**

```dart
// apps/flutter_client/test/onboarding_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_client/src/features/onboarding/onboarding_view.dart';

void main() {
  testWidgets('OnboardingView displays welcome and step navigation', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: OnboardingView(),
      ),
    );

    expect(find.text('Welcome to Agama'), findsOneWidget);
    expect(find.text('Calibrate WPM Speed'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd apps/flutter_client && flutter test test/onboarding_test.dart`  
Expected: FAIL

- [ ] **Step 3: Implement OnboardingView & CalibrationView**

```dart
// apps/flutter_client/lib/src/features/onboarding/onboarding_view.dart
import 'package:flutter/material.dart';
import '../../core/app_tokens.dart';
import 'calibration_view.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTokens.spaceLg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Welcome to Agama', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: AppTokens.spaceMd),
              Text(
                'Sub-vocalization free speed reading & knowledge synthesis platform.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: AppTokens.spaceXl),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CalibrationView()));
                },
                icon: const Icon(Icons.speed),
                label: const Text('Calibrate WPM Speed'),
              ),
              const SizedBox(height: AppTokens.spaceMd),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Skip to Library'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `cd apps/flutter_client && flutter test test/onboarding_test.dart`  
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add apps/flutter_client/lib/src/features/onboarding/ apps/flutter_client/test/onboarding_test.dart
git commit -m "feat(onboarding): add first time user onboarding and WPM calibration flow"
```

---

### Task 4: Auth, Profile & Guest Mode Management

**Files:**
- Create: `apps/flutter_client/lib/src/features/auth/auth_provider.dart`
- Create: `apps/flutter_client/lib/src/features/auth/profile_view.dart`
- Test: `apps/flutter_client/test/auth_profile_test.dart`

**Interfaces:**
- Produces: `authProvider`, `ProfileView`.

- [ ] **Step 1: Write failing test for ProfileView**

```dart
// apps/flutter_client/test/auth_profile_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_client/src/features/auth/profile_view.dart';

void main() {
  testWidgets('ProfileView displays Guest User status and streak', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ProfileView(),
        ),
      ),
    );

    expect(find.text('Guest Reader'), findsOneWidget);
    expect(find.text('Reading Streak'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd apps/flutter_client && flutter test test/auth_profile_test.dart`  
Expected: FAIL

- [ ] **Step 3: Implement AuthProvider and ProfileView**

```dart
// apps/flutter_client/lib/src/features/auth/profile_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/app_tokens.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: ListView(
        padding: const EdgeInsets.all(AppTokens.spaceMd),
        children: [
          Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: const Text('Guest Reader'),
              subtitle: const Text('Offline Mode — Sync Disabled'),
              trailing: ElevatedButton(
                onPressed: () {},
                child: const Text('Enable Sync'),
              ),
            ),
          ),
          const SizedBox(height: AppTokens.spaceMd),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTokens.spaceMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Reading Streak', style: theme.textTheme.titleMedium),
                  const SizedBox(height: AppTokens.spaceSm),
                  const Row(
                    children: [
                      Icon(Icons.local_fire_department, color: Colors.orange),
                      SizedBox(width: AppTokens.spaceSm),
                      Text('5 Days Active Streak', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `cd apps/flutter_client && flutter test test/auth_profile_test.dart`  
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add apps/flutter_client/lib/src/features/auth/ apps/flutter_client/test/auth_profile_test.dart
git commit -m "feat(auth): add guest user profile and offline sync status view"
```

---

### Task 5: Document Pipeline, Details View & Web URL Import

**Files:**
- Create: `apps/flutter_client/lib/src/features/library/document_detail_view.dart`
- Create: `apps/flutter_client/lib/src/features/library/document_processing_modal.dart`
- Create: `apps/flutter_client/lib/src/features/library/url_import_service.dart`
- Modify: `apps/flutter_client/lib/src/features/library/library_view.dart`
- Modify: `apps/flutter_client/lib/src/features/library/file_parser_service.dart`
- Test: `apps/flutter_client/test/document_pipeline_test.dart`

**Interfaces:**
- Produces: `DocumentDetailView`, `DocumentProcessingModal`, `UrlImportService`.

- [ ] **Step 1: Write failing test for DocumentDetailView**

```dart
// apps/flutter_client/test/document_pipeline_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_client/src/features/library/document_detail_view.dart';

void main() {
  testWidgets('DocumentDetailView displays title and Start Speed Reading button', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: DocumentDetailView(
          documentTitle: 'Sample Book Title',
          content: 'Sample text content for testing purposes.',
        ),
      ),
    );

    expect(find.text('Sample Book Title'), findsOneWidget);
    expect(find.text('Start Speed Reading'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd apps/flutter_client && flutter test test/document_pipeline_test.dart`  
Expected: FAIL

- [ ] **Step 3: Implement DocumentDetailView and DocumentProcessingModal**

```dart
// apps/flutter_client/lib/src/features/library/document_detail_view.dart
import 'package:flutter/material.dart';
import '../../core/app_tokens.dart';

class DocumentDetailView extends StatelessWidget {
  final String documentTitle;
  final String content;

  const DocumentDetailView({
    super.key,
    required this.documentTitle,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wordCount = content.split(RegExp(r'\s+')).length;
    final estMinutes = (wordCount / 300).ceil();

    return Scaffold(
      appBar: AppBar(title: Text(documentTitle)),
      body: Padding(
        padding: const EdgeInsets.all(AppTokens.spaceLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(documentTitle, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppTokens.spaceSm),
            Chip(label: Text('$wordCount words · ~${estMinutes}m read time')),
            const SizedBox(height: AppTokens.spaceLg),
            Text('Overview', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppTokens.spaceSm),
            Expanded(
              child: SingleChildScrollView(
                child: Text(content, style: theme.textTheme.bodyMedium),
              ),
            ),
            const SizedBox(height: AppTokens.spaceLg),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(content),
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start Speed Reading'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `cd apps/flutter_client && flutter test test/document_pipeline_test.dart`  
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add apps/flutter_client/lib/src/features/library/ apps/flutter_client/test/document_pipeline_test.dart
git commit -m "feat(library): add document details landing screen and URL import pipeline"
```

---

### Task 6: Reader Engine Extensions, SRS Flashcards, AI Chat & Analytics

**Files:**
- Create: `apps/flutter_client/lib/src/features/knowledge/ai_chat_view.dart`
- Create: `apps/flutter_client/lib/src/features/flashcards/deck_model.dart`
- Create: `apps/flutter_client/lib/src/features/flashcards/deck_manager_view.dart`
- Create: `apps/flutter_client/lib/src/features/sync/conflict_resolution_dialog.dart`
- Modify: `apps/flutter_client/lib/src/features/reader/rsvp_canvas.dart`
- Modify: `apps/flutter_client/lib/src/features/reader/reader_settings_provider.dart`
- Modify: `apps/flutter_client/lib/src/features/flashcards/flashcard_view.dart`
- Modify: `apps/flutter_client/lib/src/features/annotations/annotation_view.dart`
- Modify: `apps/flutter_client/lib/src/features/analytics/analytics_view.dart`
- Modify: `apps/flutter_client/lib/src/features/sync/sync_view.dart`
- Modify: `apps/flutter_client/lib/src/features/settings/user_settings_view.dart`
- Modify: `native/rust_core/src/api/mod.rs`
- Modify: `native/rust_core/src/models/mod.rs`
- Test: `apps/flutter_client/test/features_complete_test.dart`

**Interfaces:**
- Consumes: All core components
- Produces: SRS flashcard manager, AI chat view, extended analytics, and Rust SRS helpers.

- [ ] **Step 1: Write failing test for AI Chat View and SRS Flashcards**

```dart
// apps/flutter_client/test/features_complete_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_client/src/features/knowledge/ai_chat_view.dart';
import 'package:flutter_client/src/features/flashcards/deck_model.dart';

void main() {
  test('SrsCard calculateNextInterval updates ease factor and interval', () {
    final card = SrsCard(id: '1', front: 'Q', back: 'A');
    final next = card.calculateNextInterval(quality: 4); // Easy
    expect(next.intervalDays, greaterThan(1));
  });

  testWidgets('AiChatView renders prompt input and submit button', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AiChatView(),
      ),
    );

    expect(find.text('AI Document Assistant'), findsOneWidget);
    expect(find.byIcon(Icons.send), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd apps/flutter_client && flutter test test/features_complete_test.dart`  
Expected: FAIL

- [ ] **Step 3: Implement SrsCard model, AiChatView, and Rust SRS helpers**

```dart
// apps/flutter_client/lib/src/features/flashcards/deck_model.dart
class SrsCard {
  final String id;
  final String front;
  final String back;
  final int intervalDays;
  final double easeFactor;
  final int repetitionCount;

  SrsCard({
    required this.id,
    required this.front,
    required this.back,
    this.intervalDays = 1,
    this.easeFactor = 2.5,
    this.repetitionCount = 0,
  });

  SrsCard calculateNextInterval({required int quality}) {
    double newEase = easeFactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
    if (newEase < 1.3) newEase = 1.3;
    int nextInterval = (intervalDays * newEase).round();
    return SrsCard(
      id: id,
      front: front,
      back: back,
      intervalDays: nextInterval,
      easeFactor: newEase,
      repetitionCount: repetitionCount + 1,
    );
  }
}
```

```dart
// apps/flutter_client/lib/src/features/knowledge/ai_chat_view.dart
import 'package:flutter/material.dart';
import '../../core/app_tokens.dart';

class AiChatView extends StatelessWidget {
  const AiChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Document Assistant')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppTokens.spaceMd),
              children: const [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(AppTokens.spaceSm),
                      child: Text('Ask me anything about your loaded document.'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppTokens.spaceSm),
            child: Row(
              children: [
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(hintText: 'Ask a question...', border: OutlineInputBorder()),
                  ),
                ),
                IconButton(icon: const Icon(Icons.send), onPressed: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `cd apps/flutter_client && flutter test test/features_complete_test.dart`  
Expected: PASS

- [ ] **Step 5: Verify static analysis and full test suite**

Run:
```bash
cd apps/flutter_client
flutter analyze
flutter test
```
Expected: 0 errors, 0 failures.

- [ ] **Step 6: Commit**

```bash
git add apps/flutter_client/ native/rust_core/
git commit -m "feat(ai): add AI assistant panel, SRS SM-2 flashcard queue, and extended reader features"
```

---

## Verification Gate

Run final verification commands:
```bash
# 1. Rust engine core tests
cargo test

# 2. Flutter UI Shell analysis & tests
cd apps/flutter_client
flutter analyze
flutter test
```
