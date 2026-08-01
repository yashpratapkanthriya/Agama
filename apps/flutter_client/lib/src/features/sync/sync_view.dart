import 'package:flutter/material.dart';

class SyncView extends StatefulWidget {
  const SyncView({super.key});

  @override
  State<SyncView> createState() => _SyncViewState();
}

class _SyncViewState extends State<SyncView> {
  bool _autoSyncEnabled = true;
  String _selectedProvider = 'WebDAV (Nextcloud)';
  int _pendingOutboxCount = 3;
  bool _isSyncing = false;

  void _triggerSync() async {
    setState(() => _isSyncing = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _isSyncing = false;
        _pendingOutboxCount = 0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Yrs CRDT E2EE Delta Sync Complete!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Decentralized Sync Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.cloud_sync, size: 32, color: Color(0xFF6750A4)),
                        const SizedBox(width: 12),
                        Text(
                          'Zero-Backend E2EE Sync',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'User-owned state sync using Yrs CRDTs across your own cloud storage.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.sync),
              title: const Text('Auto-Sync Deltas'),
              subtitle: const Text('Sync CRDT delta blobs in background'),
              trailing: Switch(
                value: _autoSyncEnabled,
                onChanged: (val) => setState(() => _autoSyncEnabled = val),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.storage),
              title: const Text('Primary Sync Channel'),
              subtitle: Text(_selectedProvider),
              trailing: PopupMenuButton<String>(
                onSelected: (val) => setState(() => _selectedProvider = val),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'WebDAV (Nextcloud)', child: Text('WebDAV (Nextcloud)')),
                  const PopupMenuItem(value: 'Apple iCloud Drive', child: Text('Apple iCloud Drive')),
                  const PopupMenuItem(value: 'Local Wi-Fi P2P', child: Text('Local Wi-Fi P2P (mDNS)')),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.outbox),
              title: const Text('Pending Outbox Deltas'),
              subtitle: Text('$_pendingOutboxCount un-synced CRDT operations'),
              trailing: _isSyncing
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    )
                  : FilledButton.tonal(
                      onPressed: _pendingOutboxCount == 0 ? null : _triggerSync,
                      child: const Text('Sync Now'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
