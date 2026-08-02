import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart'
    show PlatformInt64Util;
import '../../app/theme.dart';
import '../../rust/api.dart' as rust_api;

class FlashcardItem {
  final String id;
  final String question;
  final String answer;
  int interval;
  double ef;

  FlashcardItem({
    required this.id,
    required this.question,
    required this.answer,
    this.interval = 1,
    this.ef = 2.5,
  });
}

class FlashcardView extends StatefulWidget {
  const FlashcardView({super.key});

  @override
  State<FlashcardView> createState() => _FlashcardViewState();
}

class FlashcardStore {
  static final List<FlashcardItem> items = [
    FlashcardItem(
      id: 'c1',
      question:
          'What is the core formula behind Adaptive Intelligent Pacing (AIP)?',
      answer:
          't_delay = (60000 / W_target) × C × (1 + α × max(0, L − 6)) + punctuation_pauses',
    ),
    FlashcardItem(
      id: 'c2',
      question:
          'What marks an active row in the Agama bi-temporal schema (histbis)?',
      answer: "histbis = '9999' marks active rows; histvon is the creation timestamp.",
    ),
    FlashcardItem(
      id: 'c3',
      question:
          'Which algorithm schedules Agama flashcards for memory retention?',
      answer: 'SuperMemo SM-2 — interval × EF after each quality rating 0–5',
    ),
  ];

  /// Auto-generates a flashcard from a highlight/annotation.
  /// Safe to call from annotation_view.dart — no circular import.
  static void addFromHighlight({
    required String id,
    required String text,
    required String? note,
  }) {
    if (items.any((c) => c.id == 'ann_$id')) return; // deduplicate
    items.insert(
      0,
      FlashcardItem(
        id: 'ann_$id',
        question:
            'Recall: "${text.length > 80 ? '${text.substring(0, 80)}\u2026' : text}"',
        answer: note ?? 'Review the original highlight.',
      ),
    );
  }
}

class _FlashcardViewState extends State<FlashcardView> {
  List<FlashcardItem> get _cards => FlashcardStore.items;

  int _idx = 0;
  bool _revealed = false;
  String? _nextReviewText;

  void _rate(int q) async {
    final c = _cards[_idx];
    int newInterval = c.interval;
    double newEf = c.ef;
    try {
      final nowSec = PlatformInt64Util.from(
          DateTime.now().millisecondsSinceEpoch ~/ 1000);
      final result = await rust_api.calculateSm2Review(
        quality: q.clamp(0, 5),
        currentInterval: PlatformInt64Util.from(c.interval),
        currentEf: c.ef,
        currentTimeSec: nowSec,
      );
      newInterval = result.$1;
      newEf = result.$2;
    } catch (_) {
      // Fallback: pure-Dart SM-2
      final clamped = q.clamp(0, 5);
      newEf = (c.ef + (0.1 - (5 - clamped) * (0.08 + (5 - clamped) * 0.02)))
          .clamp(1.3, 3.5);
      newInterval =
          clamped >= 3 ? (c.interval <= 1 ? 6 : (c.interval * newEf).round()) : 1;
    }
    if (!mounted) return;
    setState(() {
      c.ef = newEf;
      c.interval = newInterval;
      _nextReviewText =
          'Next review: $newInterval day${newInterval == 1 ? '' : 's'} (EF ${newEf.toStringAsFixed(2)})';
      _revealed = false;
      _idx = (_idx + 1) % _cards.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final card = _cards[_idx];
    final pct = (_idx + 1) / _cards.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Flashcards', style: theme.textTheme.titleMedium),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AgamaTheme.indigo.withAlpha(15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AgamaTheme.indigo.withAlpha(40)),
            ),
            child: Text(
              '${_idx + 1} / ${_cards.length}',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AgamaTheme.indigo,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(
              value: pct,
              minHeight: 2,
              backgroundColor: theme.colorScheme.outline,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AgamaTheme.indigo),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Column(
                      children: [
                        // EF badge
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'EF ${card.ef.toStringAsFixed(2)}',
                            style: theme.textTheme.labelSmall,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Flip card
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _revealed = !_revealed),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: _revealed
                                      ? AgamaTheme.emerald.withAlpha(100)
                                      : theme.colorScheme.outline,
                                  width: 1.5,
                                ),
                              ),
                              padding: const EdgeInsets.all(28),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // State pill
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _revealed
                                          ? AgamaTheme.emerald.withAlpha(20)
                                          : AgamaTheme.indigo.withAlpha(15),
                                      borderRadius:
                                          BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      _revealed ? 'ANSWER' : 'QUESTION',
                                      style: GoogleFonts.jetBrainsMono(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.2,
                                        color: _revealed
                                            ? AgamaTheme.emerald
                                            : AgamaTheme.indigo,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    _revealed ? card.answer : card.question,
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      height: 1.6,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    _revealed
                                        ? 'Tap to hide'
                                        : 'Tap to reveal answer',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Rating row — only when revealed
                        AnimatedSize(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                          child: _revealed
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Row(
                                    children: [
                                      _RateBtn(
                                          label: 'Again',
                                          sub: '0',
                                          color: const Color(0xFFDC2626),
                                          onTap: () => _rate(0)),
                                      const SizedBox(width: 8),
                                      _RateBtn(
                                          label: 'Hard',
                                          sub: '2',
                                          color: AgamaTheme.amber,
                                          onTap: () => _rate(2)),
                                      const SizedBox(width: 8),
                                      _RateBtn(
                                          label: 'Good',
                                          sub: '4',
                                          color: AgamaTheme.indigo,
                                          onTap: () => _rate(4)),
                                      const SizedBox(width: 8),
                                      _RateBtn(
                                          label: 'Easy',
                                          sub: '5',
                                          color: AgamaTheme.emerald,
                                          onTap: () => _rate(5)),
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),

                        // Inline SM-2 review feedback
                        if (_nextReviewText != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              _nextReviewText!,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withAlpha(120),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RateBtn extends StatelessWidget {
  final String label;
  final String sub;
  final Color color;
  final VoidCallback onTap;

  const _RateBtn({
    required this.label,
    required this.sub,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: color.withAlpha(15),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withAlpha(50)),
          ),
          child: Column(
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              Text(
                sub,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: color.withAlpha(180),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
