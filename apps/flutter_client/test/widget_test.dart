import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_client/src/app/app.dart';
import 'package:flutter_client/src/features/reader/rsvp_canvas.dart';
import 'package:flutter_client/src/features/reader/guided_highlight_view.dart';
import 'package:flutter_client/src/features/reader/bionic_fixation_view.dart';
import 'package:flutter_client/src/features/flashcards/flashcard_view.dart';

void main() {
  testWidgets('AgamaApp launches LibraryView with title', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: AgamaApp(),
      ),
    );

    expect(find.text('Agama AI Platform'), findsOneWidget);
    expect(find.text('Zero-Backend Speed Reader'), findsOneWidget);
    expect(find.byType(Card), findsAtLeastNWidgets(3));
  });

  testWidgets('RsvpCanvasView renders ORP text redicle', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RsvpCanvasView(
          text: 'Quick brown fox jumps',
          targetWpm: 500,
        ),
      ),
    );

    expect(find.text('RSVP Redicle Reader'), findsOneWidget);
    expect(find.text('Target Speed: 500 WPM'), findsOneWidget);
    expect(find.byType(Slider), findsOneWidget);
  });

  testWidgets('GuidedHighlightView renders smooth sweep mode', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: GuidedHighlightView(
          text: 'High performance local speed reading',
          targetWpm: 400,
        ),
      ),
    );

    expect(find.text('Guided Highlighting Mode'), findsOneWidget);
    expect(find.text('Guided Pacing: 400 WPM'), findsOneWidget);
  });

  testWidgets('BionicFixationView renders fixation controls', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: BionicFixationView(
          text: 'Bionic reading fixation test text',
        ),
      ),
    );

    expect(find.text('Bionic Fixation Reading'), findsOneWidget);
    expect(find.text('Fixation Level: F3'), findsOneWidget);
  });

  testWidgets('FlashcardView renders question and answer toggle', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: FlashcardView(),
      ),
    );

    expect(find.text('SM-2 Active Recall Flashcards'), findsOneWidget);
    expect(find.text('QUESTION'), findsOneWidget);
  });
}

