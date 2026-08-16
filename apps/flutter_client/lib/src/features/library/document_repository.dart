import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/theme.dart';

/// Represents a document stored locally in the library
class DocumentItem {
  final String id;
  final String title;
  final String format; // PDF, EPUB, MD, TXT, WEB
  final int wordCount;
  final double progress; // 0.0 to 1.0
  final DateTime lastReadAt;
  final int colorValue;
  final String content;

  const DocumentItem({
    required this.id,
    required this.title,
    required this.format,
    required this.wordCount,
    required this.progress,
    required this.lastReadAt,
    required this.colorValue,
    required this.content,
  });

  Color get color => Color(colorValue);

  DocumentItem copyWith({
    String? id,
    String? title,
    String? format,
    int? wordCount,
    double? progress,
    DateTime? lastReadAt,
    int? colorValue,
    String? content,
  }) {
    return DocumentItem(
      id: id ?? this.id,
      title: title ?? this.title,
      format: format ?? this.format,
      wordCount: wordCount ?? this.wordCount,
      progress: progress ?? this.progress,
      lastReadAt: lastReadAt ?? this.lastReadAt,
      colorValue: colorValue ?? this.colorValue,
      content: content ?? this.content,
    );
  }
}

class DocumentNotifier extends StateNotifier<List<DocumentItem>> {
  DocumentNotifier() : super(_initialDocs);

  static final List<DocumentItem> _initialDocs = [
    DocumentItem(
      id: 'doc-sad-arch',
      title: 'Zero-Backend SAD Architecture',
      format: 'PDF',
      wordCount: 5100,
      progress: 0.65,
      lastReadAt: DateTime.now().subtract(const Duration(minutes: 42)),
      colorValue: AgamaTheme.indigo.toARGB32(),
      content:
          'Zero-Backend SAD Architecture. The Agama Platform is engineered as a high-performance local-first zero-backend speed reading system. By executing PDF parsing, vector indexing, and ONNX complexity inference inside an embedded Rust core, the system achieves absolute privacy, zero cloud costs, and instant responsiveness.',
    ),
    DocumentItem(
      id: 'doc-quantum-optics',
      title: 'Quantum Optics & Photonic Computing',
      format: 'EPUB',
      wordCount: 2450,
      progress: 0.30,
      lastReadAt: DateTime.now().subtract(const Duration(hours: 3)),
      colorValue: AgamaTheme.emerald.toARGB32(),
      content:
          'Quantum Optics & Photonic Computing. Photonic quantum information processing uses single photons to encode qubit states. Integrated optical circuits enable high-fidelity quantum logic operations at room temperature.',
    ),
    DocumentItem(
      id: 'doc-onnx-engine',
      title: 'ONNX Syntactic Complexity Engine',
      format: 'MD',
      wordCount: 1820,
      progress: 0.90,
      lastReadAt: DateTime.now().subtract(const Duration(days: 1)),
      colorValue: AgamaTheme.amber.toARGB32(),
      content:
          'ONNX Syntactic Complexity Engine. Syntactic parsing models analyze sentence structure to calculate cognitive load metrics. Real-time adaptation dynamically adjusts RSVP presentation speed based on syntactic clause depth.',
    ),
  ];

  void addDocument(DocumentItem doc) {
    // Check if doc with same id or title already exists, replace or prepend
    final existingIndex = state.indexWhere((d) => d.id == doc.id || (d.title == doc.title && d.title.isNotEmpty));
    if (existingIndex >= 0) {
      final updated = List<DocumentItem>.from(state);
      updated[existingIndex] = doc;
      state = updated;
    } else {
      state = [doc, ...state];
    }
  }

  void updateProgress(String id, double progress) {
    state = [
      for (final doc in state)
        if (doc.id == id)
          doc.copyWith(
            progress: progress.clamp(0.0, 1.0),
            lastReadAt: DateTime.now(),
          )
        else
          doc,
    ];
  }

  void removeDocument(String id) {
    state = state.where((d) => d.id != id).toList();
  }
}

final documentListProvider =
    StateNotifierProvider<DocumentNotifier, List<DocumentItem>>((ref) {
  return DocumentNotifier();
});
