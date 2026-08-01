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
}
