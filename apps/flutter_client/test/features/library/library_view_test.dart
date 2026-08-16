import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_client/src/features/library/library_view.dart';
import 'package:flutter_client/src/features/reader/rsvp_canvas.dart';
import 'package:flutter_client/src/features/library/document_detail_view.dart';

void main() {
  testWidgets('LibraryView renders Home with direct text inputs and Library with import buttons', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: LibraryView(initialTab: 0))));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byType(TextField), findsWidgets); // Hero paste input
    expect(find.textContaining('Instant Speed Reader'), findsOneWidget);

    // Switch to Library tab
    await tester.tap(find.text('Library'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Import Document'), findsOneWidget);
    expect(find.text('Import URL'), findsOneWidget);
  });

  testWidgets('Typing custom text in hero section updates engine chooser and launches reader with custom text', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: LibraryView(initialTab: 0))));
    await tester.pump(const Duration(milliseconds: 200));

    // Type custom text into hero text field
    const customInput = 'Agama zero-backend AI speed reader test content';
    final textField = find.byType(TextField).first;
    await tester.enterText(textField, customInput);
    await tester.pump(const Duration(milliseconds: 100));

    // Scroll into view and tap Start Reading button to launch RSVP engine
    final startBtn = find.textContaining('Start Reading with RSVP Redicle');
    await tester.ensureVisible(startBtn);
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(startBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Verify reader canvas is opened with the custom text
    expect(find.byType(RsvpCanvasView), findsOneWidget);
  });

  testWidgets('Engine click triggers validation if no input', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: LibraryView(initialTab: 0))));
    await tester.pump(const Duration(milliseconds: 200));

    // Tap Start Reading with no input to trigger inline error
    final startBtn = find.textContaining('Start Reading with RSVP Redicle');
    await tester.ensureVisible(startBtn);
    await tester.tap(startBtn);
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Please enter or paste text above first'), findsOneWidget);
  });

  testWidgets('Tapping document tile opens DocumentDetailView and launches RSVP reader', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: LibraryView(initialTab: 1))));
    await tester.pump(const Duration(milliseconds: 200));
    
    final docTile = find.text('Zero-Backend SAD Architecture');
    await tester.ensureVisible(docTile);
    await tester.tap(docTile);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(DocumentDetailView), findsOneWidget);

    final startReadingBtn = find.text('Start Speed Reading');
    await tester.tap(startReadingBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(RsvpCanvasView), findsOneWidget);
    expect(find.text('Zero-Backend'), findsWidgets);
  });
}
