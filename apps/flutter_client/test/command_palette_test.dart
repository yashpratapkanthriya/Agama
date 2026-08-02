import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_client/src/core/command_palette.dart';

void main() {
  testWidgets('CommandPaletteModal filters actions on typing', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CommandPaletteModal(),
        ),
      ),
    );

    expect(find.text('Command Palette'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Settings');
    await tester.pumpAndSettle();
    expect(find.text('Go to Settings'), findsOneWidget);
    expect(find.text('Go to Library'), findsNothing);
  });

  testWidgets('CommandPaletteModal returns selected command on tap', (WidgetTester tester) async {
    String? selectedResult;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  selectedResult = await showDialog<String>(
                    context: context,
                    builder: (_) => const CommandPaletteModal(),
                  );
                },
                child: const Text('Open Palette'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open Palette'));
    await tester.pumpAndSettle();

    expect(find.text('Command Palette'), findsOneWidget);
    await tester.tap(find.text('Go to Knowledge'));
    await tester.pumpAndSettle();

    expect(selectedResult, 'Go to Knowledge');
  });
}
