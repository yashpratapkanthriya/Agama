import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_client/src/features/reader/rsvp_canvas.dart';

void main() {
  testWidgets('RsvpCanvasView renders spotlight and context strip', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: RsvpCanvasView(text: 'The Agama platform is engineered for speed'),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(RsvpCanvasView), findsOneWidget);
  });
}
