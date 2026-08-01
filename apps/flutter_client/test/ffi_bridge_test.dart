import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_client/src/core/ffi_bridge.dart';

void main() {
  test('NativeEngine Fallback computes ORP index correctly', () {
    final engine = NativeEngine();
    final index = engine.calculateOrpIndex('speedreader');
    expect(index, equals(3)); // 35% of 11 characters
  });
}
