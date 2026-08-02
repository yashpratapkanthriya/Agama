import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_client/src/core/app_tokens.dart';
import 'package:flutter_client/src/core/empty_state_widget.dart';

void main() {
  test('AppTokens contains standard spacing and radius values', () {
    expect(AppTokens.spaceXs, 4.0);
    expect(AppTokens.spaceSm, 8.0);
    expect(AppTokens.spaceMd, 16.0);
    expect(AppTokens.spaceLg, 24.0);
    expect(AppTokens.spaceXl, 32.0);

    expect(AppTokens.radiusSm, 4.0);
    expect(AppTokens.radiusMd, 8.0);
    expect(AppTokens.radiusLg, 16.0);

    expect(AppTokens.elevationSm, 2.0);

    expect(AppTokens.animFast, const Duration(milliseconds: 150));
    expect(AppTokens.animNormal, const Duration(milliseconds: 250));
  });

  testWidgets('EmptyStateWidget renders title, subtitle, icon and action', (WidgetTester tester) async {
    bool actionPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EmptyStateWidget(
            icon: Icons.book_outlined,
            title: 'No Documents Found',
            subtitle: 'Import a document to get started',
            action: ElevatedButton(
              onPressed: () {
                actionPressed = true;
              },
              child: const Text('Add Document'),
            ),
          ),
        ),
      ),
    );

    expect(find.text('No Documents Found'), findsOneWidget);
    expect(find.text('Import a document to get started'), findsOneWidget);
    expect(find.byIcon(Icons.book_outlined), findsOneWidget);
    expect(find.text('Add Document'), findsOneWidget);

    await tester.tap(find.text('Add Document'));
    expect(actionPressed, isTrue);
  });
}
