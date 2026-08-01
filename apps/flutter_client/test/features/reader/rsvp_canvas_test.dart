import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_client/src/features/reader/rsvp_canvas.dart';

void main() {
  testWidgets('RSVPCanvas consumes settings', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(body: RSVPCanvas()),
        ),
      ),
    );
    expect(find.byType(RSVPCanvas), findsOneWidget);
  });
}
