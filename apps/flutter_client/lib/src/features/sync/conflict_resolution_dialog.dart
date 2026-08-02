import 'package:flutter/material.dart';
import '../../core/app_tokens.dart';

enum ConflictResolutionChoice { keepLocal, keepRemote, mergeBoth }

class ConflictResolutionDialog extends StatelessWidget {
  final String title;
  final String localVersion;
  final String remoteVersion;
  final String localTimestamp;
  final String remoteTimestamp;

  const ConflictResolutionDialog({
    super.key,
    this.title = 'Sync Conflict Detected',
    this.localVersion = 'Local edit version',
    this.remoteVersion = 'Remote peer version',
    this.localTimestamp = '20260802141500000',
    this.remoteTimestamp = '20260802141600000',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: theme.colorScheme.error),
          const SizedBox(width: AppTokens.spaceSm),
          Text(title),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'A CRDT synchronization conflict occurred between local and remote states.',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: AppTokens.spaceMd),
            Container(
              padding: const EdgeInsets.all(AppTokens.spaceSm),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppTokens.radiusSm),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Local Version (histvon: $localTimestamp)',
                      style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(localVersion, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
            const SizedBox(height: AppTokens.spaceSm),
            Container(
              padding: const EdgeInsets.all(AppTokens.spaceSm),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppTokens.radiusSm),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Remote Peer Version (histvon: $remoteTimestamp)',
                      style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(remoteVersion, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(ConflictResolutionChoice.keepLocal),
          child: const Text('Keep Local'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(ConflictResolutionChoice.keepRemote),
          child: const Text('Keep Remote'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(ConflictResolutionChoice.mergeBoth),
          child: const Text('Merge Both'),
        ),
      ],
    );
  }
}
