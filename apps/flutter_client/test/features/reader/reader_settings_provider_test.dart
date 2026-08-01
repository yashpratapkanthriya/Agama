import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_client/src/features/reader/reader_settings_provider.dart';

void main() {
  group('readerSettingsProvider', () {
    test('readerSettingsProvider defaults', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final settings = container.read(readerSettingsProvider);

      expect(settings.wpm, 350);
      expect(settings.fontSize, 24.0);
      expect(settings.fontFamily, 'Inter');
    });

    test('ReaderSettings copyWith creates new instance with updated values', () {
      const settings = ReaderSettings();
      final updated = settings.copyWith(wpm: 450, fontSize: 28.0, fontFamily: 'Roboto');

      expect(updated.wpm, 450);
      expect(updated.fontSize, 28.0);
      expect(updated.fontFamily, 'Roboto');
    });

    test('ReaderSettings value equality and hashCode', () {
      const s1 = ReaderSettings(wpm: 400, fontSize: 20.0, fontFamily: 'Serif');
      const s2 = ReaderSettings(wpm: 400, fontSize: 20.0, fontFamily: 'Serif');
      const s3 = ReaderSettings(wpm: 350, fontSize: 20.0, fontFamily: 'Serif');

      expect(s1, equals(s2));
      expect(s1.hashCode, equals(s2.hashCode));
      expect(s1, isNot(equals(s3)));
    });

    test('ReaderSettingsNotifier state mutation methods update state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(readerSettingsProvider.notifier);
      
      notifier.setWpm(500);
      expect(container.read(readerSettingsProvider).wpm, 500);

      notifier.setFontSize(30.0);
      expect(container.read(readerSettingsProvider).fontSize, 30.0);

      notifier.setFontFamily('Georgia');
      expect(container.read(readerSettingsProvider).fontFamily, 'Georgia');
    });
  });
}
