import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_client/src/features/library/library_view.dart';

void main() {
  testWidgets('LibraryView renders 4 navigation destinations including User/Settings', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LibraryView(initialTab: 0)));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Library'), findsOneWidget);
    expect(find.text('Knowledge'), findsOneWidget);
    expect(find.text('Analytics'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.textContaining('5-Day Streak'), findsOneWidget);
  });
}
