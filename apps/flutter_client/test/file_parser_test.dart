import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_client/src/features/library/file_parser_service.dart';
import 'package:flutter_client/src/rust/frb_generated.dart';
import 'package:flutter_client/src/rust/parser.dart' as rust_parser;

void main() {

  group('FileParserService parseRawText', () {
    final service = FileParserService();

    test('extracts markdown content and identifies .md format', () {
      final result = service.parseRawText('# Title\n\nSample content text for RSVP speed reader.', 'sample.md');
      expect(result.title, equals('sample.md'));
      expect(result.content, equals('# Title\n\nSample content text for RSVP speed reader.'));
      expect(result.format, equals(DocumentFormat.markdown));
    });

    test('identifies uppercase .MD extension as markdown format', () {
      final result = service.parseRawText('Markdown text', 'README.MD');
      expect(result.title, equals('README.MD'));
      expect(result.content, equals('Markdown text'));
      expect(result.format, equals(DocumentFormat.markdown));
    });

    test('identifies .txt format and extracts text', () {
      final result = service.parseRawText('Plain text content', 'notes.txt');
      expect(result.title, equals('notes.txt'));
      expect(result.content, equals('Plain text content'));
      expect(result.format, equals(DocumentFormat.txt));
    });

    test('identifies .pdf format and extracts text', () {
      final result = service.parseRawText('PDF text content', 'document.pdf');
      expect(result.title, equals('document.pdf'));
      expect(result.content, equals('PDF text content'));
      expect(result.format, equals(DocumentFormat.pdf));
    });

    test('identifies .epub format and extracts text', () {
      final result = service.parseRawText('EPUB text content', 'book.epub');
      expect(result.title, equals('book.epub'));
      expect(result.content, equals('EPUB text content'));
      expect(result.format, equals(DocumentFormat.epub));
    });

    test('handles empty input', () {
      final result = service.parseRawText('', 'empty.txt');
      expect(result.title, equals('empty.txt'));
      expect(result.content, equals(''));
      expect(result.format, equals(DocumentFormat.txt));
    });

    test('trims leading and trailing whitespace', () {
      final result = service.parseRawText('   \n  Padded text content  \n\t ', 'padded.txt');
      expect(result.content, equals('Padded text content'));
      expect(result.format, equals(DocumentFormat.txt));
    });
  });

  group('FileParserService parseBytes', () {
    final service = FileParserService();

    test('parses markdown bytes', () {
      final bytes = Uint8List.fromList(utf8.encode('# Markdown Header\nBody text'));
      final result = service.parseBytes(bytes, 'doc.md');
      expect(result.title, equals('doc.md'));
      expect(result.content, equals('# Markdown Header\nBody text'));
      expect(result.format, equals(DocumentFormat.markdown));
    });

    test('parses txt bytes', () {
      final bytes = Uint8List.fromList(utf8.encode('Plain text byte stream'));
      final result = service.parseBytes(bytes, 'data.txt');
      expect(result.title, equals('data.txt'));
      expect(result.content, equals('Plain text byte stream'));
      expect(result.format, equals(DocumentFormat.txt));
    });

    test('extracts text from pdf bytes stream', () {
      final bytes = Uint8List.fromList(utf8.encode('%PDF-1.4\n1 0 obj\n<< /Length 50 >>\nstream\nSample PDF text content\nendstream\nendobj'));
      final result = service.parseBytes(bytes, 'article.pdf');
      expect(result.title, equals('article.pdf'));
      expect(result.content, contains('Sample PDF text content'));
      expect(result.format, equals(DocumentFormat.pdf));
    });

    test('extracts text from epub bytes stream', () {
      final bytes = Uint8List.fromList(utf8.encode('PK\x03\x04 Chapter 1: EPUB eBook content story text'));
      final result = service.parseBytes(bytes, 'story.epub');
      expect(result.title, equals('story.epub'));
      expect(result.content, contains('Chapter 1: EPUB eBook content story text'));
      expect(result.format, equals(DocumentFormat.epub));
    });

    test('parses uppercase .PDF extension bytes', () {
      final bytes = Uint8List.fromList(utf8.encode('Upper PDF content'));
      final result = service.parseBytes(bytes, 'REPORT.PDF');
      expect(result.format, equals(DocumentFormat.pdf));
      expect(result.content, contains('Upper PDF content'));
    });

    test('handles empty bytes', () {
      final result = service.parseBytes(Uint8List(0), 'empty.epub');
      expect(result.content, equals(''));
      expect(result.format, equals(DocumentFormat.epub));
    });

    test('trims whitespace in byte content', () {
      final bytes = Uint8List.fromList(utf8.encode('   Byte text with padding   \n'));
      final result = service.parseBytes(bytes, 'padded.txt');
      expect(result.content, equals('Byte text with padding'));
      expect(result.format, equals(DocumentFormat.txt));
    });
  });

  group('FileParserService Rust Bridge interface', () {
    late MockRustLibApi mockApi;
    late FileParserService service;

    setUpAll(() {
      mockApi = MockRustLibApi();
      RustLib.initMock(api: mockApi);
    });

    setUp(() {
      service = FileParserService();
    });

    test('init executes when initialized', () async {
      await expectLater(service.init(), completes);
    });

    test('parseFile invokes crateApiParseFile on RustLib and returns ParsedDocument', () async {
      final doc = await service.parseFile('/path/to/sample.txt');

      expect(mockApi.parseFileCalled, isTrue);
      expect(mockApi.lastPathParsed, equals('/path/to/sample.txt'));
      expect(doc.title, equals('mock_title'));
      expect(doc.content, equals('Chunk 1\n\nChunk 2'));
      expect(doc.format, equals(DocumentFormat.txt));
    });
  });



}

class MockRustLibApi extends Fake implements RustLibApi {
  bool parseFileCalled = false;
  String? lastPathParsed;

  @override
  Future<rust_parser.ParsedDocument> crateApiParseFile({required String path}) async {
    parseFileCalled = true;
    lastPathParsed = path;
    return rust_parser.ParsedDocument(
      title: 'mock_title',
      author: 'mock_author',
      chunks: const ['Chunk 1', 'Chunk 2'],
      wordCount: BigInt.from(42),
      mimeType: 'text/plain',
    );
  }
}



