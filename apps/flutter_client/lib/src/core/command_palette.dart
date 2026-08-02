import 'package:flutter/material.dart';
import 'app_tokens.dart';

class CommandPaletteModal extends StatefulWidget {
  const CommandPaletteModal({super.key});

  @override
  State<CommandPaletteModal> createState() => _CommandPaletteModalState();
}

class _CommandPaletteModalState extends State<CommandPaletteModal> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  final List<Map<String, String>> _commands = const [
    {'title': 'Go to Library', 'category': 'Navigation', 'shortcut': '⌘1'},
    {'title': 'Go to Knowledge', 'category': 'Navigation', 'shortcut': '⌘2'},
    {'title': 'Go to Analytics', 'category': 'Navigation', 'shortcut': '⌘3'},
    {'title': 'Go to Settings', 'category': 'Navigation', 'shortcut': '⌘4'},
    {'title': 'Import Text / Document', 'category': 'Action', 'shortcut': '⌘I'},
    {'title': 'View Keyboard Shortcuts', 'category': 'Help', 'shortcut': '?'},
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = _commands.where((c) {
      final queryLower = _query.toLowerCase();
      final titleLower = c['title']!.toLowerCase();
      final categoryLower = c['category']!.toLowerCase();
      return titleLower.contains(queryLower) || categoryLower.contains(queryLower);
    }).toList();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTokens.radiusLg),
      ),
      elevation: AppTokens.elevationMd,
      child: Container(
        width: 540,
        padding: const EdgeInsets.all(AppTokens.spaceMd),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.terminal_outlined, color: theme.colorScheme.primary),
                const SizedBox(width: AppTokens.spaceSm),
                Text(
                  'Command Palette',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTokens.spaceSm),
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(AppTokens.radiusMd),
              ),
              padding: const EdgeInsets.symmetric(horizontal: AppTokens.spaceSm),
              child: Row(
                children: [
                  Icon(Icons.search, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: AppTokens.spaceSm),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Type a command or search...',
                        border: InputBorder.none,
                      ),
                      onChanged: (val) => setState(() => _query = val),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTokens.spaceSm),
            const Divider(),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 320),
              child: filtered.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(AppTokens.spaceLg),
                      child: Center(
                        child: Text(
                          'No matching commands found',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final cmd = filtered[index];
                        return ListTile(
                          dense: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppTokens.radiusSm),
                          ),
                          leading: Icon(
                            cmd['category'] == 'Navigation'
                                ? Icons.explore_outlined
                                : cmd['category'] == 'Action'
                                    ? Icons.bolt_outlined
                                    : Icons.help_outline,
                            size: 20,
                          ),
                          title: Text(
                            cmd['title']!,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            cmd['category']!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTokens.spaceSm,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(AppTokens.radiusSm),
                            ),
                            child: Text(
                              cmd['shortcut']!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                          onTap: () => Navigator.of(context).pop(cmd['title']),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
