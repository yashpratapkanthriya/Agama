class NativeEngine {
  int calculateOrpIndex(String word) {
    if (word.isEmpty) return 0;
    final len = word.length;
    if (len <= 1) return 0;
    if (len <= 5) return 1;
    if (len <= 9) return 2;
    if (len <= 13) return 3;
    return (len * 0.35).floor();
  }
}
