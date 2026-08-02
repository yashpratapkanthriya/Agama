import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_client/src/features/knowledge/ai_chat_view.dart';
import 'package:flutter_client/src/features/flashcards/deck_model.dart';

void main() {
  test('SrsCard calculateNextInterval updates ease factor and interval', () {
    final card = SrsCard(id: '1', front: 'Q', back: 'A');
    final next = card.calculateNextInterval(quality: 4); // Easy
    expect(next.intervalDays, greaterThan(1));
  });

  testWidgets('AiChatView renders prompt input and submit button', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AiChatView(),
      ),
    );

    expect(find.text('AI Document Assistant'), findsOneWidget);
    expect(find.byIcon(Icons.send), findsOneWidget);
  });
}
