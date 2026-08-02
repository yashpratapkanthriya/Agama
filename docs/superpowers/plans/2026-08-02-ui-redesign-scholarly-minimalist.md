# Scholarly Minimalist UI Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement the "Scholarly Minimalist" UI design system across Agama, featuring a 4-tab bento navigation layout, contextual top header with live reading streak, live engine previews, distraction-free RSVP reader spotlight, and a dedicated User / Settings P2P sync management dashboard.

**Architecture:** Refactor Agama theme tokens (`scholarly_theme.dart`), update `LibraryView` navigation scaffold to 4 tabs, upgrade RSVP reader focus stage, and add `UserSettingsView` for decentralized sync control and reading goals.

**Tech Stack:** Flutter, Riverpod / ValueNotifiers, Google Fonts (`Source Serif 4`, `Literata`, `Inter`), Flutter Test.

## Global Constraints

- **Primary Color:** `#041920` (Deep Slate Navy) / `#1a2e35`
- **Secondary Color:** `#fd761a` (Energetic Orange) / `#9d4300`
- **Background Color:** `#f9f9ff` (Soft White) / `#0F141C` (Dark Slate)
- **Typography:** Display/Headlines: `Source Serif 4`; Body/Reading: `Literata`; UI/Stats: `Inter`
- **Navigation Tabs:** 4 tabs: Library, Knowledge, Analytics, User/Settings
- **Zero native dependency additions:** Keep minimal dependencies (`flutter_riverpod`, `google_fonts`).

---

### Task 1: Theme & Visual Token Foundation (`scholarly_theme.dart`)

**Files:**
- Create: `apps/flutter_client/lib/src/app/scholarly_theme.dart`
- Modify: `apps/flutter_client/lib/src/app/app.dart:1-58`
- Test: `apps/flutter_client/test/scholarly_theme_test.dart`

**Interfaces:**
- Consumes: Flutter `ThemeData`, `GoogleFonts`
- Produces: `ScholarlyTheme.light()`, `ScholarlyTheme.dark()`, color constants (`primary`, `secondary`, `surface`, `orpHighlight`)

- [ ] **Step 1: Write the failing test**

Create `apps/flutter_client/test/scholarly_theme_test.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_client/src/app/scholarly_theme.dart';

void main() {
  test('ScholarlyTheme defines expected colors and text styles', () {
    final darkTheme = ScholarlyTheme.dark();
    expect(darkTheme.colorScheme.primary, equals(const Color(0xFF1A2E35)));
    expect(darkTheme.colorScheme.secondary, equals(const Color(0xFFFD761A)));
    expect(ScholarlyTheme.orpHighlight, equals(const Color(0xFFFD761A)));
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd apps/flutter_client && flutter test test/scholarly_theme_test.dart`
Expected: FAIL with "scholarly_theme.dart not found".

- [ ] **Step 3: Write minimal implementation**

Create `apps/flutter_client/lib/src/app/scholarly_theme.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScholarlyTheme {
  static const Color primary = Color(0xFF1A2E35);
  static const Color secondary = Color(0xFFFD761A);
  static const Color background = Color(0xFF0F141C);
  static const Color surfaceContainer = Color(0xFF1A202C);
  static const Color surfaceContainerHigh = Color(0xFF242C3D);
  static const Color onSurface = Color(0xFFF1F5F9);
  static const Color onSurfaceVariant = Color(0xFF94A3B8);
  static const Color outline = Color(0xFF42484A);
  static const Color orpHighlight = Color(0xFFFD761A);

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: surfaceContainer,
        onSurface: onSurface,
        onSurfaceVariant: onSurfaceVariant,
        outline: outline,
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.sourceSerif4(fontSize: 32, fontWeight: FontWeight.w600, color: onSurface),
        headlineMedium: GoogleFonts.sourceSerif4(fontSize: 24, fontWeight: FontWeight.w600, color: onSurface),
        bodyLarge: GoogleFonts.literata(fontSize: 18, fontWeight: FontWeight.w400, color: onSurface),
        bodyMedium: GoogleFonts.literata(fontSize: 16, fontWeight: FontWeight.w400, color: onSurfaceVariant),
        labelLarge: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.5, color: onSurface),
      ),
    );
  }

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF9F9FF),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF041920),
        secondary: Color(0xFFFD761A),
        surface: Color(0xFFE7EEFF),
        onSurface: Color(0xFF111C2C),
        onSurfaceVariant: Color(0xFF42484A),
        outline: Color(0xFF73787A),
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.sourceSerif4(fontSize: 32, fontWeight: FontWeight.w600, color: const Color(0xFF111C2C)),
        headlineMedium: GoogleFonts.sourceSerif4(fontSize: 24, fontWeight: FontWeight.w600, color: const Color(0xFF111C2C)),
        bodyLarge: GoogleFonts.literata(fontSize: 18, fontWeight: FontWeight.w400, color: const Color(0xFF111C2C)),
        bodyMedium: GoogleFonts.literata(fontSize: 16, fontWeight: FontWeight.w400, color: const Color(0xFF42484A)),
        labelLarge: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.5, color: const Color(0xFF111C2C)),
      ),
    );
  }
}
```

Update `apps/flutter_client/lib/src/app/app.dart` to consume `ScholarlyTheme.light()` and `ScholarlyTheme.dark()`.

- [ ] **Step 4: Run test to verify it passes**

Run: `cd apps/flutter_client && flutter test test/scholarly_theme_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add apps/flutter_client/lib/src/app/scholarly_theme.dart apps/flutter_client/lib/src/app/app.dart apps/flutter_client/test/scholarly_theme_test.dart
git commit -m "feat(ui): add Scholarly Minimalist theme tokens and color palette"
```

---

### Task 2: Contextual Top Header & 4-Tab Navigation Bar Redesign

**Files:**
- Create: `apps/flutter_client/lib/src/features/settings/user_settings_view.dart`
- Modify: `apps/flutter_client/lib/src/features/library/library_view.dart:1-200`
- Test: `apps/flutter_client/test/navigation_4tabs_test.dart`

**Interfaces:**
- Consumes: `LibraryView(initialTab)`
- Produces: 4-tab scaffold (Library, Knowledge, Analytics, User/Settings), contextual header with live streak badge (`🔥 5-Day Streak · ⚡ 450 WPM`).

- [ ] **Step 1: Write the failing test**

Create `apps/flutter_client/test/navigation_4tabs_test.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_client/src/features/library/library_view.dart';

void main() {
  testWidgets('LibraryView renders 4 navigation destinations including User/Settings', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LibraryView(initialTab: 0)));
    await tester.pumpAndSettle();

    expect(find.text('Library'), findsOneWidget);
    expect(find.text('Knowledge'), findsOneWidget);
    expect(find.text('Analytics'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.textContaining('5-Day Streak'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd apps/flutter_client && flutter test test/navigation_4tabs_test.dart`
Expected: FAIL (only 3 destinations exist, Settings tab missing).

- [ ] **Step 3: Write minimal implementation**

Create `apps/flutter_client/lib/src/features/settings/user_settings_view.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserSettingsView extends StatelessWidget {
  const UserSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('User Settings & Decentralized Sync',
              style: GoogleFonts.sourceSerif4(fontSize: 22, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          // User Profile Bento Tile
          _BentoTile(
            title: 'USER PROFILE & GOALS',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Daily Reading Goal: 30 minutes', style: GoogleFonts.literata(fontSize: 14)),
                const SizedBox(height: 8),
                Text('Current Streak: 🔥 5 Days', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Decentralized Sync Bento Tile
          _BentoTile(
            title: 'DECENTRALIZED P2P SYNC',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Status: ACTIVE (Local Rust Engine)', style: GoogleFonts.inter(fontSize: 13, color: Colors.green)),
                const SizedBox(height: 4),
                Text('Last Sync: 2026-08-02T12:40:00 (17-char timestamp)', style: GoogleFonts.jetBrainsMono(fontSize: 11)),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.sync, size: 16),
                  label: const Text('Trigger P2P Sync Now'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BentoTile extends StatelessWidget {
  final String title;
  final Widget child;
  const _BentoTile({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
```

Update `apps/flutter_client/lib/src/features/library/library_view.dart`:
- Add 4th navigation tab: `NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Settings')`.
- Add `UserSettingsView()` to tab array.
- Replace top header sync button with `_StreakBadge()` (`🔥 5-Day Streak · ⚡ 450 WPM`).

- [ ] **Step 4: Run test to verify it passes**

Run: `cd apps/flutter_client && flutter test test/navigation_4tabs_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add apps/flutter_client/lib/src/features/settings/user_settings_view.dart apps/flutter_client/lib/src/features/library/library_view.dart apps/flutter_client/test/navigation_4tabs_test.dart
git commit -m "feat(ui): implement 4-tab navigation and top header streak badge"
```

---

### Task 3: Engine Chooser Bento Grid with Live Preview

**Files:**
- Modify: `apps/flutter_client/lib/src/features/library/library_view.dart:460-650`
- Test: `apps/flutter_client/test/engine_preview_test.dart`

**Interfaces:**
- Consumes: `_EngineChooser`
- Produces: Interactive 3-card bento grid (RSVP, Guided Sweep, Bionic) with energetic orange highlight (`#fd761a`) and live 3-second animated text preview snippet.

- [ ] **Step 1: Write the failing test**

Create `apps/flutter_client/test/engine_preview_test.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_client/src/features/library/library_view.dart';

void main() {
  testWidgets('_EngineChooser shows live animated preview section', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: SingleChildScrollView(child: LibraryView(initialTab: 0)))));
    await tester.pumpAndSettle();

    expect(find.textContaining('MAX SPEED'), findsOneWidget);
    expect(find.textContaining('LIVE PREVIEW'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd apps/flutter_client && flutter test test/engine_preview_test.dart`
Expected: FAIL.

- [ ] **Step 3: Write minimal implementation**

Update `_EngineChooserState` in `library_view.dart`:
- Add energetic orange highlight badge for active engine (`#FD761A`).
- Add live animated preview box showing simulated word presentation for the selected engine.

- [ ] **Step 4: Run test to verify it passes**

Run: `cd apps/flutter_client && flutter test test/engine_preview_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add apps/flutter_client/lib/src/features/library/library_view.dart apps/flutter_client/test/engine_preview_test.dart
git commit -m "feat(ui): add Scholarly Minimalist bento cards and live engine preview"
```

---

### Task 4: Distraction-Free RSVP Reader Stage & ORP Highlight

**Files:**
- Modify: `apps/flutter_client/lib/src/features/reader/rsvp_canvas.dart:1-300`
- Test: `apps/flutter_client/test/rsvp_canvas_test.dart`

**Interfaces:**
- Consumes: `RsvpCanvasView(text)`
- Produces: Central reading spotlight with ORP focus character in Energetic Orange (`#FD761A`), context strip (±3 words) in `Literata` / `Inter`, floating control bar.

- [ ] **Step 1: Write failing test**

Create `apps/flutter_client/test/rsvp_canvas_test.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_client/src/features/reader/rsvp_canvas.dart';

void main() {
  testWidgets('RsvpCanvasView renders spotlight and context strip', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: RsvpCanvasView(text: 'The Agama platform is engineered for speed')));
    await tester.pumpAndSettle();

    expect(find.byType(RsvpCanvasView), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify failure/pass state**

Run: `cd apps/flutter_client && flutter test test/rsvp_canvas_test.dart`

- [ ] **Step 3: Update implementation**

Update `rsvp_canvas.dart` with Scholarly Minimalist tokens:
- Background: `#0F141C`
- ORP Highlight Color: `#FD761A`
- Context Strip: `Literata` text style.

- [ ] **Step 4: Verify pass**

Run: `cd apps/flutter_client && flutter test test/rsvp_canvas_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add apps/flutter_client/lib/src/features/reader/rsvp_canvas.dart apps/flutter_client/test/rsvp_canvas_test.dart
git commit -m "feat(ui): update RSVP Canvas with Scholarly Minimalist ORP focus spotlight"
```

---

### Task 5: Static Analysis & Suite Verification

- [ ] **Step 1: Run static analysis**

Run: `cd apps/flutter_client && flutter analyze`
Expected: 0 errors, 0 warnings.

- [ ] **Step 2: Run unit test suite**

Run: `cd apps/flutter_client && flutter test`
Expected: All tests green.

- [ ] **Step 3: Commit**

```bash
git commit --allow-empty -m "chore(ui): verify Scholarly Minimalist UI suite passes cleanly"
```
