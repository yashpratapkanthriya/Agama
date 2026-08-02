import 'file_parser_service.dart';

class UrlImportService {
  static final UrlImportService instance = UrlImportService();

  bool isValidUrl(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return false;
    final uri = Uri.tryParse(trimmed);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  String extractTitleFromUrl(String urlStr) {
    try {
      final uri = Uri.parse(urlStr.trim());
      final pathSegments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
      if (pathSegments.isNotEmpty) {
        final last = pathSegments.last.replaceAll(RegExp(r'[-_]'), ' ');
        if (last.contains('.')) {
          return last.substring(0, last.lastIndexOf('.'));
        }
        return last.toUpperCase();
      }
      return uri.toString();
    } catch (_) {
      return urlStr;
    }
  }

  Future<ParsedDocument> fetchAndParseUrl(String urlStr) async {
    final trimmed = urlStr.trim();
    if (!isValidUrl(trimmed)) {
      throw ArgumentError('Invalid HTTP/HTTPS URL: $urlStr');
    }

    final title = extractTitleFromUrl(trimmed);
    final mockContent = 'Extracted content from $trimmed';

    return ParsedDocument(
      title: title,
      content: mockContent,
      format: DocumentFormat.markdown,
    );
  }
}
