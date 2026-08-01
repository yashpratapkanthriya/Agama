import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReaderSettings {
  final int wpm;
  final double fontSize;
  final String fontFamily;

  const ReaderSettings({
    this.wpm = 350,
    this.fontSize = 24.0,
    this.fontFamily = 'Inter',
  });

  ReaderSettings copyWith({
    int? wpm,
    double? fontSize,
    String? fontFamily,
  }) {
    return ReaderSettings(
      wpm: wpm ?? this.wpm,
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReaderSettings &&
          runtimeType == other.runtimeType &&
          wpm == other.wpm &&
          fontSize == other.fontSize &&
          fontFamily == other.fontFamily;

  @override
  int get hashCode => Object.hash(wpm, fontSize, fontFamily);
}

class ReaderSettingsNotifier extends StateNotifier<ReaderSettings> {
  ReaderSettingsNotifier([ReaderSettings? initialSettings])
      : super(initialSettings ?? const ReaderSettings());

  void setWpm(int wpm) {
    state = state.copyWith(wpm: wpm);
  }

  void setFontSize(double fontSize) {
    state = state.copyWith(fontSize: fontSize);
  }

  void setFontFamily(String fontFamily) {
    state = state.copyWith(fontFamily: fontFamily);
  }

  void updateSettings(ReaderSettings settings) {
    state = settings;
  }
}

final readerSettingsProvider =
    StateNotifierProvider<ReaderSettingsNotifier, ReaderSettings>((ref) {
  return ReaderSettingsNotifier();
});
