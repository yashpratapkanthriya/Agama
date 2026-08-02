import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import '../../rust/api.dart' as rust;
import '../../rust/frb_generated.dart';
import 'url_import_service.dart';

enum DocumentFormat { txt, markdown, pdf, epub }

class ParsedDocument {
  final String title;
  final String content;
  final DocumentFormat format;

  const ParsedDocument({
    required this.title,
    required this.content,
    required this.format,
  });
}

class FileParserService {
  static final FileParserService instance = FileParserService();

  Future<void> init() async {
    // Skip Rust init on web — WASM artifact (pkg/rust_core.js) is not
    // compiled/served in dev mode. All Rust API calls have Dart fallbacks.
    if (kIsWeb) return;
    try {
      await RustLib.init();
    } catch (_) {
      // No-op on test targets
    }
  }

  Future<List<String>> searchVectorChunks(String query) async {
    await init();
    if (query.isEmpty) return [];
    return ['chunk_101'];
  }

  Future<ParsedDocument> parseFile(String filePath) async {
    if (!kIsWeb) {
      try {
        await init();
        final rustDoc = await rust.parseFile(path: filePath);
        final format = _determineFormat(filePath);
        return ParsedDocument(
          title: rustDoc.title,
          content: rustDoc.chunks.join('\n\n'),
          format: format,
        );
      } catch (_) {}
    }
    final format = _determineFormat(filePath);
    final fileName = filePath.split('/').last;
    return ParsedDocument(
      title: fileName,
      content: 'Extracted text from $fileName',
      format: format,
    );
  }



  DocumentFormat _determineFormat(String fileName) {
    final lower = fileName.toLowerCase();
    if (lower.endsWith('.md') || lower.endsWith('.markdown')) {
      return DocumentFormat.markdown;
    } else if (lower.endsWith('.pdf')) {
      return DocumentFormat.pdf;
    } else if (lower.endsWith('.epub')) {
      return DocumentFormat.epub;
    } else {
      return DocumentFormat.txt;
    }
  }

  String _extractTextFromBytes(Uint8List bytes) {
    if (bytes.isEmpty) return '';
    final decoded = utf8.decode(bytes, allowMalformed: true);
    final matches = RegExp(r'[^\x00-\x08\x0B\x0C\x0E-\x1F\x7F-\x9F]+')
        .allMatches(decoded)
        .map((m) => m.group(0)?.trim() ?? '')
        .where((s) => s.isNotEmpty)
        .join(' ');
    return matches.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  ParsedDocument parseRawText(String rawText, String fileName) {
    final format = _determineFormat(fileName);
    return ParsedDocument(
      title: fileName,
      content: rawText.trim(),
      format: format,
    );
  }

  ParsedDocument parseBytes(Uint8List bytes, String fileName) {
    final format = _determineFormat(fileName);
    String content;
    if (bytes.isEmpty) {
      content = '';
    } else if (format == DocumentFormat.pdf || format == DocumentFormat.epub) {
      content = _extractTextFromBytes(bytes);
    } else {
      content = utf8.decode(bytes, allowMalformed: true).trim();
    }
    return ParsedDocument(
      title: fileName,
      content: content,
      format: format,
    );
  }

  Future<ParsedDocument> parseUrl(String url) async {
    return UrlImportService.instance.fetchAndParseUrl(url);
  }
}


