class SyncPayload {
  final List<int> bytes;
  final bool isEncrypted;

  const SyncPayload({required this.bytes, required this.isEncrypted});
}

class SyncTransportAdapter {
  SyncPayload packageDelta(List<int> yrsDeltaBytes) {
    return SyncPayload(
      bytes: List<int>.from(yrsDeltaBytes),
      isEncrypted: true,
    );
  }
}
