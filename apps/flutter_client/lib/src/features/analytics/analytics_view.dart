import 'package:flutter/material.dart';

class AnalyticsView extends StatelessWidget {
  const AnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const int totalWordsRead = 24500;
    const int avgWpm = 480;
    const double quizAccuracy = 0.88; // 88%
    final double cciScore = avgWpm * quizAccuracy;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comprehension & WPM Analytics'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              color: theme.colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Comprehension Calibration Index (CCI)',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      cciScore.toStringAsFixed(1),
                      style: theme.textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Target Range: 350 - 450 CCI (Optimal Speed-Retention)',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer.withAlpha(200),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Icon(Icons.speed, color: Color(0xFF6750A4), size: 28),
                          const SizedBox(height: 8),
                          Text('$avgWpm WPM', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          Text('Average Speed', style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Icon(Icons.psychology, color: Color(0xFF4CAF50), size: 28),
                          const SizedBox(height: 8),
                          Text('${(quizAccuracy * 100).toInt()}%', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          Text('Quiz Accuracy', style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Icon(Icons.menu_book, color: Color(0xFFFF9800), size: 28),
                          const SizedBox(height: 8),
                          Text('$totalWordsRead', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          Text('Words Read', style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Recent Reading Sessions',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.article),
                title: const Text('Scientific Quantum Paper'),
                subtitle: const Text('2,450 words • 490 WPM'),
                trailing: Chip(
                  label: const Text('92% Score'),
                  backgroundColor: theme.colorScheme.secondaryContainer,
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.menu_book),
                title: const Text('Zero-Backend SAD Architecture'),
                subtitle: const Text('5,100 words • 460 WPM'),
                trailing: Chip(
                  label: const Text('85% Score'),
                  backgroundColor: theme.colorScheme.secondaryContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
