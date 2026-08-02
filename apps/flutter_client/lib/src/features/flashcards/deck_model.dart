class SrsCard {
  final String id;
  final String front;
  final String back;
  final int intervalDays;
  final double easeFactor;
  final int repetitionCount;

  SrsCard({
    required this.id,
    required this.front,
    required this.back,
    this.intervalDays = 1,
    this.easeFactor = 2.5,
    this.repetitionCount = 0,
  });

  SrsCard calculateNextInterval({required int quality}) {
    double newEase = easeFactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
    if (newEase < 1.3) newEase = 1.3;
    int nextInterval = (intervalDays * newEase).round();
    if (nextInterval < 1) nextInterval = 1;
    return SrsCard(
      id: id,
      front: front,
      back: back,
      intervalDays: nextInterval,
      easeFactor: newEase,
      repetitionCount: repetitionCount + 1,
    );
  }
}

class FlashcardDeck {
  final String id;
  final String name;
  final List<SrsCard> cards;

  FlashcardDeck({
    required this.id,
    required this.name,
    required this.cards,
  });
}
