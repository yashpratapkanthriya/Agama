import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_client/src/features/sync/sync_transport.dart';

void main() {
  test('SyncTransportAdapter packages Yrs CRDT delta payload', () {
    final adapter = SyncTransportAdapter();
    final payload = adapter.packageDelta([1, 2, 3, 4, 5]);
    expect(payload.isEncrypted, isTrue);
    expect(payload.bytes.length, equals(5));
  });
}
