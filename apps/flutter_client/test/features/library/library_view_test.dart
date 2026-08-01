import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/src/features/library/library_view.dart';

void main() {
  testWidgets('LibraryView renders direct file picker and text inputs', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LibraryView()));
    expect(find.text('Select PDF, EPUB, or Markdown'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget); // For text paste
  });
}
