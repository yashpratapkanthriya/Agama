import 'dart:convert';
import 'dart:typed_data';

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
}

