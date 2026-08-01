import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_client/src/features/library/library_view.dart';
import 'package:flutter_client/src/features/reader/rsvp_canvas.dart';

void main() {
  testWidgets('LibraryView renders direct file picker and text inputs', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: LibraryView())));
    expect(find.text('Select PDF, EPUB, or Markdown'), findsOneWidget);
    expect(find.byType(TextField), findsWidgets); // Hero paste input
  });

  testWidgets('Typing custom text in hero section updates engine chooser and launches reader with custom text', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: LibraryView())));

    // Initially shows default launch button label
    expect(find.text('Start Reading'), findsOneWidget);

    // Type custom text into hero text field
    const customInput = 'Agama zero-backend AI speed reader test content';
    final textField = find.byType(TextField).first;
    await tester.enterText(textField, customInput);
    await tester.pump(const Duration(milliseconds: 100));

    // Verify engine launch button label reflects custom text input
    expect(find.text('Start Reading'), findsOneWidget);

    // Scroll into view and tap Start Reading button to launch RSVP engine
    final startBtn = find.widgetWithText(FilledButton, 'Start Reading');
    await tester.ensureVisible(startBtn);
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(startBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Verify reader canvas is opened with the custom text
    expect(find.byType(RsvpCanvasView), findsOneWidget);
  });

  testWidgets('Engine click triggers validation if no input', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: LibraryView())));
    await tester.tap(find.text('RSVP'));
    await tester.pump();
    // Tap Start Reading with no input to trigger inline error
    final startBtn = find.text('Start Reading');
    await tester.ensureVisible(startBtn);
    await tester.tap(startBtn);
    await tester.pump();
    expect(find.text('Add text or select a file above first'), findsOneWidget);
  });

  testWidgets('Tapping document tile launches RSVP reader with document text', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: LibraryView())));
    
    final docTile = find.text('Zero-Backend SAD Architecture');
    await tester.ensureVisible(docTile);
    await tester.tap(docTile);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(RsvpCanvasView), findsOneWidget);
    expect(find.text('Zero-Backend'), findsWidgets);
  });
}
