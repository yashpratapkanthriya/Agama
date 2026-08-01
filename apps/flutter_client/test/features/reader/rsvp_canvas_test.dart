import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_client/src/features/reader/rsvp_canvas.dart';
import 'package:flutter_client/src/features/reader/reader_settings_provider.dart';

void main() {
  group('RSVPCanvas (RsvpCanvasView)', () {
    testWidgets('consumes default readerSettingsProvider values', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RSVPCanvas(text: 'Quick brown fox jumps'),
          ),
        ),
      );

      // Verify WPM from default settings (350) is rendered
      expect(find.text('350 WPM'), findsOneWidget);

      // Verify ORP RichText uses default fontSize (24.0) and fontFamily ('Inter')
      final richTextFinder = find.byWidgetPredicate((w) => w is RichText && w.key == const ValueKey(0));
      expect(richTextFinder, findsOneWidget);
      final richText = tester.widget<RichText>(richTextFinder);
      expect(richText.text.style?.fontSize, 24.0);
      expect(richText.text.style?.fontFamily, 'Inter');
    });

    testWidgets('consumes updated readerSettingsProvider values', (WidgetTester tester) async {
      final container = ProviderContainer(
        overrides: [
          readerSettingsProvider.overrideWith(
            (ref) => ReaderSettingsNotifier(
              const ReaderSettings(
                wpm: 600,
                fontSize: 32.0,
                fontFamily: 'Roboto',
              ),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: RsvpCanvasView(text: 'Quick brown fox jumps'),
          ),
        ),
      );

      // Verify updated WPM (600) is rendered
      expect(find.text('600 WPM'), findsOneWidget);

      // Verify ORP RichText uses updated fontSize (32.0) and fontFamily ('Roboto')
      final richTextFinder = find.byWidgetPredicate((w) => w is RichText && w.key == const ValueKey(0));
      expect(richTextFinder, findsOneWidget);
      final richText = tester.widget<RichText>(richTextFinder);
      expect(richText.text.style?.fontSize, 32.0);
      expect(richText.text.style?.fontFamily, 'Roboto');
    });

    testWidgets('updating WPM in view syncs with readerSettingsProvider', (WidgetTester tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: RsvpCanvasView(text: 'Quick brown fox jumps'),
          ),
        ),
      );

      // Tap 800 WPM chip
      await tester.tap(find.text('800'));
      await tester.pump();

      expect(find.text('800 WPM'), findsOneWidget);
      expect(container.read(readerSettingsProvider).wpm, 800);
    });
  });
}
