import 'package:flutter/material.dart';
import '../../core/app_tokens.dart';
import 'deck_model.dart';
import 'flashcard_view.dart';

class DeckManagerView extends StatefulWidget {
  const DeckManagerView({super.key});

  @override
  State<DeckManagerView> createState() => _DeckManagerViewState();
}

class _DeckManagerViewState extends State<DeckManagerView> {
  final List<FlashcardDeck> _decks = [
    FlashcardDeck(
      id: 'd1',
      name: 'Speed Reading Fundamentals',
      cards: [
        SrsCard(id: 'c1', front: 'What is AIP?', back: 'Adaptive Intelligent Pacing'),
        SrsCard(id: 'c2', front: 'What is ORP?', back: 'Optimal Recognition Point'),
      ],
    ),
    FlashcardDeck(
      id: 'd2',
      name: 'Agama Architecture & Sync',
      cards: [
        SrsCard(id: 'c3', front: 'What is histbis active marker?', back: "'9999'"),
        SrsCard(id: 'c4', front: 'What timestamp format is used?', back: '17-char ISO timestamp'),
      ],
    ),
  ];

  void _addDeck() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Create New Deck'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Deck Name', border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  _decks.add(FlashcardDeck(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: controller.text.trim(),
                    cards: [],
                  ));
                });
              }
              Navigator.pop(ctx);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcard Decks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Deck',
            onPressed: _addDeck,
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppTokens.spaceMd),
        itemCount: _decks.length,
        itemBuilder: (context, index) {
          final deck = _decks[index];
          return Card(
            margin: const EdgeInsets.only(bottom: AppTokens.spaceSm),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Icon(Icons.style, color: theme.colorScheme.onPrimaryContainer),
              ),
              title: Text(deck.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${deck.cards.length} cards'),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const FlashcardView(),
                  ));
                },
                child: const Text('Study'),
              ),
            ),
          );
        },
      ),
    );
  }
}
