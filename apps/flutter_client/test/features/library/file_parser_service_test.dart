import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_client/src/features/library/file_parser_service.dart';

void main() {
  test('parseUrl stub', () {
    final service = FileParserService();
    final doc = service.parseUrl('https://example.com');
    expect(doc.format, DocumentFormat.markdown);
  });
}
