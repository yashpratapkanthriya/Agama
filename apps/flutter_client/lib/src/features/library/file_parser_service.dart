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
  ParsedDocument parseRawText(String rawText, String fileName) {
    final format = fileName.endsWith('.md') ? DocumentFormat.markdown : DocumentFormat.txt;
    return ParsedDocument(
      title: fileName,
      content: rawText.trim(),
      format: format,
    );
  }
}
