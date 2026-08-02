import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_client/src/features/auth/profile_view.dart';

void main() {
  testWidgets('ProfileView displays Guest User status, reading streak, and sync toggle', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ProfileView(),
        ),
      ),
    );

    expect(find.text('Guest Reader'), findsOneWidget);
    expect(find.text('Reading Streak'), findsOneWidget);
    expect(find.text('Enable Sync'), findsOneWidget);
  });
}
