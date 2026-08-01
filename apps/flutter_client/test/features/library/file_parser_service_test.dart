import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_client/src/features/library/file_parser_service.dart';

void main() {
  test('parseUrl stub', () async {
    final service = FileParserService();
    final doc = await service.parseUrl('https://example.com');
    expect(doc.title, 'https://example.com');
    expect(doc.content, 'Extracted content from https://example.com');
    expect(doc.format, DocumentFormat.markdown);
  });

  test('semantic search query returns matched chunk IDs', () async {
    final results = await FileParserService.instance.searchVectorChunks('speed reading');
    expect(results, isNotNull);
    expect(results, contains('chunk_101'));
  });
}

