import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_client/src/features/home/home_tab_view.dart';

void main() {
  testWidgets('HomeTabView renders hero reader and continue reading section', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(body: HomeTabView()),
        ),
      ),
    );
    await tester.pump();
    expect(find.textContaining('CONTINUE READING'), findsOneWidget);
    expect(find.textContaining('SELECT READING METHOD'), findsOneWidget);
    expect(find.textContaining('TODAY\'S METRICS'), findsOneWidget);
  });
}
