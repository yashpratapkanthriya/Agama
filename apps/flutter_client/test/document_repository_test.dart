import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_client/src/features/library/document_repository.dart';

void main() {
  test('DocumentNotifier initializes with seed documents', () {
    final notifier = DocumentNotifier();
    expect(notifier.state.length, greaterThanOrEqualTo(3));
  });

  test('DocumentNotifier adds document and updates progress', () {
    final notifier = DocumentNotifier();
    final newDoc = DocumentItem(
      id: 'test-1',
      title: 'Test Doc',
      format: 'PDF',
      wordCount: 1200,
      progress: 0.0,
      lastReadAt: DateTime.now(),
      colorValue: 0xFF6366F1,
      content: 'Sample test content',
    );
    notifier.addDocument(newDoc);
    expect(notifier.state.any((d) => d.id == 'test-1'), isTrue);

    notifier.updateProgress('test-1', 0.45);
    final updated = notifier.state.firstWhere((d) => d.id == 'test-1');
    expect(updated.progress, 0.45);
  });

  test('DocumentNotifier removes document', () {
    final notifier = DocumentNotifier();
    final newDoc = DocumentItem(
      id: 'test-delete',
      title: 'Delete Me',
      format: 'TXT',
      wordCount: 100,
      progress: 0.1,
      lastReadAt: DateTime.now(),
      colorValue: 0xFF10B981,
      content: 'Short content',
    );
    notifier.addDocument(newDoc);
    expect(notifier.state.any((d) => d.id == 'test-delete'), isTrue);

    notifier.removeDocument('test-delete');
    expect(notifier.state.any((d) => d.id == 'test-delete'), isFalse);
  });
}
