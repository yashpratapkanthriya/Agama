import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_client/src/features/library/document_detail_view.dart';

void main() {
  testWidgets('DocumentDetailView displays title, estimated read time, overview, and Start Speed Reading button', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: DocumentDetailView(
          documentTitle: 'Sample Book Title',
          content: 'Sample text content for testing purposes.',
        ),
      ),
    );

    expect(find.text('Sample Book Title'), findsAtLeast(1));
    expect(find.text('Overview'), findsOneWidget);
    expect(find.textContaining('read time'), findsOneWidget);
    expect(find.text('Start Speed Reading'), findsOneWidget);
  });
}
