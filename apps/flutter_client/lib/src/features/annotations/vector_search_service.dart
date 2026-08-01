class SearchResult {
  final String text;
  final double score;

  const SearchResult(this.text, this.score);
}

class VectorSearchService {
  List<SearchResult> search(List<String> highlights, String query) {
    final queryTokens = query.toLowerCase().split(' ').toSet();
    final results = <SearchResult>[];

    for (final text in highlights) {
      final textTokens = text.toLowerCase().split(' ').toSet();
      final overlap = queryTokens.intersection(textTokens).length;
      final score = textTokens.isEmpty ? 0.0 : overlap / textTokens.length;
      results.add(SearchResult(text, score));
    }

    results.sort((a, b) => b.score.compareTo(a.score));
    return results;
  }
}
