import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/app_tokens.dart';
import 'auth_provider.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userProfile = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: ListView(
        padding: const EdgeInsets.all(AppTokens.spaceMd),
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTokens.radiusMd),
            ),
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(userProfile.name),
              subtitle: Text(
                userProfile.isSyncEnabled
                    ? 'Cloud Sync Enabled — ISO 8601 Historization'
                    : 'Offline Mode — Sync Disabled',
              ),
              trailing: ElevatedButton(
                onPressed: () {
                  ref.read(authProvider.notifier).toggleSync();
                },
                child: Text(
                  userProfile.isSyncEnabled ? 'Disable Sync' : 'Enable Sync',
                ),
              ),
            ),
          ),
          const SizedBox(height: AppTokens.spaceMd),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTokens.radiusMd),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppTokens.spaceMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Reading Streak', style: theme.textTheme.titleMedium),
                  const SizedBox(height: AppTokens.spaceSm),
                  Row(
                    children: [
                      const Icon(Icons.local_fire_department, color: Colors.orange),
                      const SizedBox(width: AppTokens.spaceSm),
                      Text(
                        '${userProfile.streakDays} Days Active Streak',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppTokens.spaceMd),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTokens.radiusMd),
            ),
            child: SwitchListTile(
              title: const Text('Offline Sync Status'),
              subtitle: Text(
                userProfile.isSyncEnabled
                    ? 'Syncing active (histbis=9999)'
                    : 'Local local-first SQLite engine active',
              ),
              value: userProfile.isSyncEnabled,
              onChanged: (val) {
                ref.read(authProvider.notifier).setSyncEnabled(val);
              },
            ),
          ),
        ],
      ),
    );
  }
}
