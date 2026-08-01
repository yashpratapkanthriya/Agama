import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_client/src/features/annotations/vector_search_service.dart';

void main() {
  test('VectorSearchService ranks text highlights by semantic similarity', () {
    final service = VectorSearchService();
    final highlights = [
      'Adaptive Pacing RSVP speed reader algorithm',
      'Quantum mechanics quantum computing physics',
      'ORP redicle eye movement focus',
    ];
    final results = service.search(highlights, 'RSVP pacing');
    expect(results.first.text, contains('Adaptive Pacing RSVP'));
  });
}
