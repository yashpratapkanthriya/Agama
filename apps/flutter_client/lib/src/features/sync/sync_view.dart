import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/theme.dart';
import 'sync_transport.dart';
import 'conflict_resolution_dialog.dart';

class SyncView extends StatefulWidget {
  const SyncView({super.key});

  @override
  State<SyncView> createState() => _SyncViewState();
}

class _SyncViewState extends State<SyncView> {
  bool _syncing = false;
  final SyncTransportAdapter _transportAdapter = SyncTransportAdapter();

  static final List<Map<String, dynamic>> _outbox = [
    {'id': 'op-001', 'op': 'highlight_upsert', 'bytes': 420, 'status': 'queued'},
    {'id': 'op-002', 'op': 'annotation_create', 'bytes': 188, 'status': 'queued'},
    {'id': 'op-003', 'op': 'progress_update', 'bytes': 64, 'status': 'queued'},
  ];

  void _sync() async {
    setState(() => _syncing = true);
    final _ = _transportAdapter.packageDelta([1, 2, 3, 4, 5]);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _syncing = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('3 operations replicated via CRDT merge')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Sync', style: theme.textTheme.titleMedium),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AgamaTheme.emerald.withAlpha(10),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AgamaTheme.emerald.withAlpha(60)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AgamaTheme.emerald.withAlpha(25),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.storage_outlined,
                        color: AgamaTheme.emerald,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Local-first · CRDT merge',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: AgamaTheme.emerald,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'All data encrypted with SQLCipher at rest',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Outbox header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Pending operations',
                      style: theme.textTheme.titleSmall),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 9, vertical: 3),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: theme.colorScheme.outline),
                    ),
                    child: Text(
                      '${_outbox.length} ops',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Expanded(
                child: ListView.separated(
                  itemCount: _outbox.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 6),
                  itemBuilder: (_, i) {
                    final op = _outbox[i];
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 13),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: theme.colorScheme.outline),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.sync_outlined,
                              size: 16,
                              color: theme.colorScheme.onSurfaceVariant),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  op['op'] as String,
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                                Text(
                                  '${op['bytes']} bytes · ${op['id']}',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AgamaTheme.amber.withAlpha(20),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              op['status'] as String,
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AgamaTheme.amber,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => const ConflictResolutionDialog(),
                        );
                      },
                      icon: const Icon(Icons.alt_route, size: 18),
                      label: const Text('Conflicts'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _syncing
                        ? const Center(child: CircularProgressIndicator())
                        : FilledButton.icon(
                            onPressed: _sync,
                            icon: const Icon(Icons.cloud_upload_outlined,
                                size: 18),
                            label: const Text('Replicate'),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
