import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_client/src/app/scholarly_theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('ScholarlyTheme defines expected colors and text styles', () {
    final darkTheme = ScholarlyTheme.dark();
    expect(darkTheme.colorScheme.primary, equals(const Color(0xFF1A2E35)));
    expect(darkTheme.colorScheme.secondary, equals(const Color(0xFFFD761A)));
    expect(ScholarlyTheme.orpHighlight, equals(const Color(0xFFFD761A)));
  });
}
