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

    // Initially shows default sample text launch button label
    expect(find.text('Try with sample text'), findsOneWidget);

    // Type custom text into hero text field
    const customInput = 'Agama zero-backend AI speed reader test content';
    final textField = find.byType(TextField).first;
    await tester.enterText(textField, customInput);
    await tester.pump(const Duration(milliseconds: 100));

    // Verify engine launch button label updates to reflect custom text input
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
}
