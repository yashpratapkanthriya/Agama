import 'package:flutter/material.dart';

class FlashcardItem {
  final String id;
  final String question;
  final String answer;
  int interval;
  double ef;
  int dueSeconds;

  FlashcardItem({
    required this.id,
    required this.question,
    required this.answer,
    this.interval = 1,
    this.ef = 2.5,
    this.dueSeconds = 0,
  });
}

class FlashcardView extends StatefulWidget {
  const FlashcardView({super.key});

  @override
  State<FlashcardView> createState() => _FlashcardViewState();
}

class _FlashcardViewState extends State<FlashcardView> {
  final List<FlashcardItem> _cards = [
    FlashcardItem(
      id: 'c1',
      question: 'What is the core formula behind Adaptive Intelligent Pacing (AIP)?',
      answer: 't_delay = (60000 / W_target) * C * (1 + alpha * max(0, L - 6)) + punctuation_pauses',
    ),
    FlashcardItem(
      id: 'c2',
      question: 'What is the active indicator string for historized rows (histbis)?',
      answer: "'9999' (active entry marker with 17-char timestamp histvon)",
    ),
    FlashcardItem(
      id: 'c3',
      question: 'Which algorithm schedules flashcards for optimal memory retention in Agama?',
      answer: 'SuperMemo SM-2 Spaced Repetition Algorithm',
    ),
  ];

  int _currentIndex = 0;
  bool _showAnswer = false;

  void _rateCard(int quality) {
    // SM-2 calculation simulation
    final card = _cards[_currentIndex];
    final q = quality.clamp(0, 5);
    final newEf = (card.ef + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02))).clamp(1.3, 3.5);
    
    int newInterval = 1;
    if (q >= 3) {
      if (card.interval <= 1) {
        newInterval = 6;
      } else {
        newInterval = (card.interval * newEf).round();
      }
    }

    setState(() {
      card.ef = newEf;
      card.interval = newInterval;
      _showAnswer = false;
      if (_currentIndex < _cards.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('SM-2 Updated: Quality $q -> Next interval $newInterval days (EF: ${newEf.toStringAsFixed(2)})'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final card = _cards[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('SM-2 Active Recall Flashcards'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (_currentIndex + 1) / _cards.length,
            ),
            const SizedBox(height: 16),
            Text(
              'Card ${_currentIndex + 1} of ${_cards.length}',
              style: theme.textTheme.labelMedium,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _showAnswer = !_showAnswer),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _showAnswer ? 'ANSWER' : 'QUESTION',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _showAnswer ? card.answer : card.question,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          _showAnswer ? 'Tap to hide' : 'Tap to reveal answer',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_showAnswer)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                    onPressed: () => _rateCard(0),
                    child: const Text('Again (0)'),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.orange),
                    onPressed: () => _rateCard(2),
                    child: const Text('Hard (2)'),
                  ),
                  FilledButton.tonal(
                    onPressed: () => _rateCard(4),
                    child: const Text('Good (4)'),
                  ),
                  FilledButton(
                    onPressed: () => _rateCard(5),
                    child: const Text('Easy (5)'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
