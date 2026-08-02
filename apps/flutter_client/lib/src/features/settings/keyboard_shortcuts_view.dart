import 'package:flutter/material.dart';
import '../../core/app_tokens.dart';

class KeyboardShortcutsView extends StatelessWidget {
  const KeyboardShortcutsView({super.key});

  static const List<Map<String, dynamic>> _shortcutGroups = [
    {
      'category': 'General & Navigation',
      'shortcuts': [
        {'action': 'Open Command Palette', 'keys': '⌘K / Ctrl+K'},
        {'action': 'Go to Library Tab', 'keys': '⌘1'},
        {'action': 'Go to Knowledge Tab', 'keys': '⌘2'},
        {'action': 'Go to Analytics Tab', 'keys': '⌘3'},
        {'action': 'Go to Settings Tab', 'keys': '⌘4'},
      ],
    },
    {
      'category': 'RSVP Reader Control',
      'shortcuts': [
        {'action': 'Play / Pause Reader', 'keys': 'Space'},
        {'action': 'Step Backward', 'keys': '←'},
        {'action': 'Step Forward', 'keys': '→'},
        {'action': 'Increase WPM', 'keys': '↑'},
        {'action': 'Decrease WPM', 'keys': '↓'},
        {'action': 'Exit Reader', 'keys': 'Esc'},
      ],
    },
    {
      'category': 'Knowledge & Flashcards',
      'shortcuts': [
        {'action': 'Create Flashcard', 'keys': '⌘F'},
        {'action': 'Highlight Text', 'keys': '⌘H'},
        {'action': 'Rate Easy / Hard', 'keys': '1 - 4'},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keyboard Shortcuts'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppTokens.spaceMd),
        itemCount: _shortcutGroups.length,
        itemBuilder: (context, groupIndex) {
          final group = _shortcutGroups[groupIndex];
          final shortcuts = group['shortcuts'] as List<Map<String, String>>;

          return Card(
            margin: const EdgeInsets.only(bottom: AppTokens.spaceMd),
            child: Padding(
              padding: const EdgeInsets.all(AppTokens.spaceMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group['category'] as String,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: AppTokens.spaceSm),
                  const Divider(),
                  ...shortcuts.map((shortcut) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppTokens.spaceSm),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            shortcut['action']!,
                            style: theme.textTheme.bodyMedium,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTokens.spaceSm,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(AppTokens.radiusSm),
                              border: Border.all(
                                color: theme.colorScheme.outline.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              shortcut['keys']!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
