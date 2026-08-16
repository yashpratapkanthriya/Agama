import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_client/src/app/theme.dart';
import 'package:flutter_client/src/features/library/library_view.dart';
import 'package:flutter_client/src/features/reader/rsvp_canvas.dart';
import 'package:flutter_client/src/features/reader/guided_highlight_view.dart';
import 'package:flutter_client/src/features/reader/bionic_fixation_view.dart';
import 'package:flutter_client/src/features/flashcards/flashcard_view.dart';
import 'package:flutter_client/src/features/sync/sync_view.dart';
import 'package:flutter_client/src/features/analytics/analytics_view.dart';

void main() {
  testWidgets('AgamaApp launches LibraryView with title', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AgamaTheme.light(),
          home: const LibraryView(),
        ),
      ),
    );

    // Pump one frame
    await tester.pump(const Duration(milliseconds: 100));

    // New UI: compact logo + 'Agama' wordmark in AppBar
    expect(find.text('Agama'), findsAtLeastNWidgets(1));
    // Engine chooser first tab label
    expect(find.text('RSVP Redicle'), findsAtLeastNWidgets(1));
    // Continue reading section on Home tab
    expect(find.text('CONTINUE READING'), findsOneWidget);
  });


  testWidgets('RsvpCanvasView renders ORP redicle and controls', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: RsvpCanvasView(
            text: 'Quick brown fox jumps',
            targetWpm: 500,
          ),
        ),
      ),
    );

    expect(find.text('RSVP Reader'), findsOneWidget);
    expect(find.text('500 WPM'), findsOneWidget);
    expect(find.byType(Slider), findsOneWidget);
  });

  testWidgets('GuidedHighlightView renders and shows WPM badge', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: GuidedHighlightView(
          text: 'High performance local speed reading',
          targetWpm: 400,
        ),
      ),
    );

    expect(find.text('Guided Sweep'), findsOneWidget);
    expect(find.text('400 WPM'), findsOneWidget);
  });

  testWidgets('BionicFixationView renders fixation controls', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: BionicFixationView(
          text: 'Bionic reading fixation test text',
        ),
      ),
    );

    expect(find.text('Bionic Fixation'), findsOneWidget);
    // Level F3 is default — appears in AppBar badge and toggle buttons
    expect(find.text('F3'), findsAtLeastNWidgets(1));
  });

  testWidgets('FlashcardView renders question state', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: FlashcardView(),
      ),
    );

    expect(find.text('Flashcards'), findsOneWidget);
    // Initial state shows QUESTION pill
    expect(find.text('QUESTION'), findsOneWidget);
  });

  testWidgets('SyncView renders status card and pending ops', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SyncView(),
      ),
    );

    expect(find.text('Sync'), findsOneWidget);
    expect(find.text('Pending operations'), findsOneWidget);
    // 3 ops in outbox
    expect(find.text('3 ops'), findsOneWidget);
  });

  testWidgets('AnalyticsView renders CCI section and sessions', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: AnalyticsView()),
      ),
    );

    expect(find.text('Comprehension Confidence Index'), findsOneWidget);
    expect(find.text('Recent sessions'), findsOneWidget);
  });
}
