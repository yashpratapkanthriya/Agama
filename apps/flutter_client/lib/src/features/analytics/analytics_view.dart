import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/theme.dart';

class AnalyticsView extends StatelessWidget {
  const AnalyticsView({super.key});

  static const _sessions = [
    {'doc': 'Zero-Backend SAD', 'wpm': 468, 'cci': 0.74, 'words': 820},
    {'doc': 'Quantum Optics', 'wpm': 491, 'cci': 0.68, 'words': 1100},
    {'doc': 'ONNX Inference', 'wpm': 512, 'cci': 0.82, 'words': 640},
    {'doc': 'SM-2 Algorithm', 'wpm': 445, 'cci': 0.61, 'words': 290},
  ];

  static const _peers = [
    {'name': 'Alice (Mesh)', 'wpm': 480, 'streak': 12, 'status': 'Reading: Quantum Optics', 'color': AgamaTheme.emerald},
    {'name': 'Bob (Sync)', 'wpm': 350, 'streak': 3, 'status': 'Offline 2h ago', 'color': AgamaTheme.inkMuted},
    {'name': 'Charlie (Relay)', 'wpm': 510, 'streak': 28, 'status': 'Reviewing flashcards', 'color': AgamaTheme.amber},
  ];

  double get _avgWpm {
    final total =
        _sessions.fold<double>(0, (s, e) => s + (e['wpm'] as int));
    return total / _sessions.length;
  }

  double get _avgCci {
    final total =
        _sessions.fold<double>(0, (s, e) => s + (e['cci'] as double));
    return total / _sessions.length;
  }

  int get _totalWords =>
      _sessions.fold<int>(0, (s, e) => s + (e['words'] as int));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics', style: theme.textTheme.titleMedium),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Hero metrics ─────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _MetricCard(
                      label: 'Avg WPM',
                      value: _avgWpm.toStringAsFixed(0),
                      accent: AgamaTheme.indigo,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _MetricCard(
                      label: 'Avg CCI',
                      value: _avgCci.toStringAsFixed(2),
                      accent: AgamaTheme.emerald,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _MetricCard(
                      label: 'Words read',
                      value: '$_totalWords',
                      accent: AgamaTheme.amber,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ── CCI gauge ────────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.colorScheme.outline),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Comprehension Confidence Index',
                        style: theme.textTheme.titleSmall),
                    const SizedBox(height: 4),
                    Text(
                      'Composite reading efficiency across sessions',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: _avgCci,
                        minHeight: 10,
                        backgroundColor: theme.colorScheme.outline,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _avgCci > 0.75
                              ? AgamaTheme.emerald
                              : _avgCci > 0.55
                                  ? AgamaTheme.amber
                                  : AgamaTheme.crimson,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('0.00', style: theme.textTheme.labelSmall),
                        Text(
                          '${(_avgCci * 100).toStringAsFixed(1)}%',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AgamaTheme.emerald,
                          ),
                        ),
                        Text('1.00', style: theme.textTheme.labelSmall),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Session list ─────────────────────────────────────────
              Text('Recent sessions', style: theme.textTheme.titleSmall),
              const SizedBox(height: 10),

              ...List.generate(_sessions.length, (i) {
                final s = _sessions[i];
                final wpm = s['wpm'] as int;
                final cci = s['cci'] as double;
                final words = s['words'] as int;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: theme.colorScheme.outline),
                    ),
                    child: Row(
                      children: [
                        // Session index
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AgamaTheme.indigo.withAlpha(15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              '${i + 1}',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: AgamaTheme.indigo,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Title
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s['doc'] as String,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '$words words read',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '$wpm WPM',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AgamaTheme.indigo,
                              ),
                            ),
                            Text(
                              'CCI ${cci.toStringAsFixed(2)}',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: cci > 0.7
                                    ? AgamaTheme.emerald
                                    : AgamaTheme.amber,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
              
              const SizedBox(height: 32),
              
              // ── Network Accountability ───────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Peer Accountability (Local Mesh)', style: theme.textTheme.titleSmall),
                  Icon(Icons.wifi_tethering, size: 16, color: AgamaTheme.indigo.withAlpha(150)),
                ],
              ),
              const SizedBox(height: 10),
              
              ...List.generate(_peers.length, (i) {
                final p = _peers[i];
                final name = p['name'] as String;
                final wpm = p['wpm'] as int;
                final streak = p['streak'] as int;
                final status = p['status'] as String;
                final color = p['color'] as Color;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: theme.colorScheme.outline),
                    ),
                    child: Row(
                      children: [
                        // Avatar
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: color.withAlpha(20),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              name[0],
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: color,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    name,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                status,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(width: 8),

                        // Stats
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '$streak day streak',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AgamaTheme.amber,
                              ),
                            ),
                            Text(
                              '$wpm WPM avg',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AgamaTheme.indigo,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final Color accent;

  const _MetricCard(
      {required this.label, required this.value, required this.accent});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: accent,
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
