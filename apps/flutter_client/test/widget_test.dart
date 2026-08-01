import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_client/src/app/app.dart';
import 'package:flutter_client/src/features/reader/rsvp_canvas.dart';

void main() {
  testWidgets('AgamaApp launches LibraryView with title', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: AgamaApp(),
      ),
    );

    expect(find.text('Agama Library'), findsOneWidget);
    expect(find.text('Zero-Backend AI Speed Reading'), findsOneWidget);
    expect(find.byType(ListTile), findsOneWidget);
  });

  testWidgets('RsvpCanvasView renders ORP text redicle', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RsvpCanvasView(
          text: 'Quick brown fox jumps',
          targetWpm: 500,
        ),
      ),
    );

    expect(find.text('RSVP Redicle Reader'), findsOneWidget);
    expect(find.text('Target Speed: 500 WPM'), findsOneWidget);
    expect(find.byType(Slider), findsOneWidget);
  });
}
