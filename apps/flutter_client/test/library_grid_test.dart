import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_client/src/features/library/library_view.dart';

void main() {
  testWidgets('Library tab toggles between grid and list views', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: LibraryView(initialTab: 1),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.byIcon(Icons.grid_view_rounded), findsOneWidget);
    expect(find.byIcon(Icons.view_list_rounded), findsOneWidget);

    // Verify grid cards exist
    expect(find.text('Zero-Backend SAD Architecture'), findsOneWidget);

    // Tap List view toggle
    await tester.tap(find.byIcon(Icons.view_list_rounded));
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Zero-Backend SAD Architecture'), findsOneWidget);

    // Tap Grid view toggle back
    await tester.tap(find.byIcon(Icons.grid_view_rounded));
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Zero-Backend SAD Architecture'), findsOneWidget);
  });
}
