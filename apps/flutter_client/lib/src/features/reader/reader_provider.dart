import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReaderState {
  final int targetWpm;
  final bool isPlaying;
  final int currentWordIndex;
  final double paragraphComplexity;

  const ReaderState({
    this.targetWpm = 450,
    this.isPlaying = false,
    this.currentWordIndex = 0,
    this.paragraphComplexity = 1.0,
  });

  ReaderState copyWith({
    int? targetWpm,
    bool? isPlaying,
    int? currentWordIndex,
    double? paragraphComplexity,
  }) {
    return ReaderState(
      targetWpm: targetWpm ?? this.targetWpm,
      isPlaying: isPlaying ?? this.isPlaying,
      currentWordIndex: currentWordIndex ?? this.currentWordIndex,
      paragraphComplexity: paragraphComplexity ?? this.paragraphComplexity,
    );
  }
}

class ReaderNotifier extends StateNotifier<ReaderState> {
  ReaderNotifier() : super(const ReaderState());

  void setWpm(int wpm) {
    state = state.copyWith(targetWpm: wpm);
  }

  void togglePlay() {
    state = state.copyWith(isPlaying: !state.isPlaying);
  }

  void setWordIndex(int index) {
    state = state.copyWith(currentWordIndex: index);
  }

  void setComplexity(double complexity) {
    state = state.copyWith(paragraphComplexity: complexity);
  }

  Stream<int> streamWordTimings(int totalWords) async* {
    for (int i = 0; i < totalWords; i++) {
      if (!state.isPlaying) break;
      final delayMs = (60000 / (state.targetWpm * state.paragraphComplexity)).round();
      await Future.delayed(Duration(milliseconds: delayMs));
      yield i;
    }
  }
}

final readerProvider = StateNotifierProvider<ReaderNotifier, ReaderState>((ref) {
  return ReaderNotifier();
});

final readerStreamProvider = StreamProvider.family<int, int>((ref, totalWords) {
  final notifier = ref.watch(readerProvider.notifier);
  return notifier.streamWordTimings(totalWords);
});

