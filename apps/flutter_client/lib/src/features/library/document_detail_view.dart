import 'package:flutter/material.dart';
import '../../core/app_tokens.dart';

class DocumentDetailView extends StatelessWidget {
  final String documentTitle;
  final String content;

  const DocumentDetailView({
    super.key,
    required this.documentTitle,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final words = content.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    final wordCount = words.isEmpty ? 0 : words.length;
    final estMinutes = (wordCount / 300).ceil();

    return Scaffold(
      appBar: AppBar(
        title: Text(documentTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppTokens.spaceLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              documentTitle,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTokens.spaceSm),
            Chip(
              avatar: const Icon(Icons.timer_outlined, size: 16),
              label: Text('$wordCount words · ~${estMinutes}m read time'),
            ),
            const SizedBox(height: AppTokens.spaceLg),
            Text(
              'Overview',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTokens.spaceSm),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppTokens.spaceMd),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(AppTokens.radiusMd),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    content,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppTokens.spaceLg),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(content),
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start Speed Reading'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
