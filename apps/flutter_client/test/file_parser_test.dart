import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_client/src/features/library/file_parser_service.dart';

void main() {
  test('FileParserService extracts plain text and markdown content', () {
    final service = FileParserService();
    final result = service.parseRawText('# Title\n\nSample content text for RSVP speed reader.', 'sample.md');
    expect(result.title, equals('sample.md'));
    expect(result.content, contains('Sample content text'));
  });
}
