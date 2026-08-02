import 'package:flutter/material.dart';
import '../../core/app_tokens.dart';

class DocumentProcessingModal extends StatelessWidget {
  final String title;
  final String currentStep;
  final double progress;
  final VoidCallback? onCancel;

  const DocumentProcessingModal({
    super.key,
    this.title = 'Processing Document...',
    required this.currentStep,
    required this.progress,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTokens.radiusLg),
      ),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(AppTokens.spaceLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTokens.spaceMd),
            LinearProgressIndicator(
              value: progress > 0 ? progress : null,
              borderRadius: BorderRadius.circular(AppTokens.radiusSm),
            ),
            const SizedBox(height: AppTokens.spaceMd),
            Row(
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: AppTokens.spaceSm),
                Expanded(
                  child: Text(
                    currentStep,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            if (onCancel != null) ...[
              const SizedBox(height: AppTokens.spaceLg),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: onCancel,
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
