import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserSettingsView extends StatelessWidget {
  const UserSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'User Settings & Decentralized Sync',
                style: GoogleFonts.sourceSerif4(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              // Bento Tile 1: Profile & Goals
              _BentoTile(
                title: 'USER PROFILE & GOALS',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Daily Target: 30 minutes', style: GoogleFonts.literata(fontSize: 14)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFD761A).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '🔥 5-Day Streak',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFFD761A),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text('Total Words Speed-Read: 142,500 words',
                        style: GoogleFonts.inter(fontSize: 13, color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              // Bento Tile 2: Decentralized P2P Sync
              _BentoTile(
                title: 'DECENTRALIZED P2P SYNC MANAGER',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.swap_horizontal_circle, color: Color(0xFF10B981), size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'P2P Node Active',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Last Sync Timestamp: 20260802124000 (17-char histvon)',
                      style: GoogleFonts.jetBrainsMono(fontSize: 11, color: theme.colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 4),
                    Text('Paired Local Nodes: 2 devices (MacBook, iPad)',
                        style: GoogleFonts.inter(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
                    const SizedBox(height: 14),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF1A2E35),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('P2P Sync initiated with connected local nodes.')),
                        );
                      },
                      icon: const Icon(Icons.sync, size: 16),
                      label: Text('Trigger P2P Sync Now', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              // Bento Tile 3: Engine Defaults & Customization
              _BentoTile(
                title: 'ENGINE DEFAULTS & CUSTOMIZATION',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Default Reading Engine: RSVP Redicle', style: GoogleFonts.literata(fontSize: 14)),
                    const SizedBox(height: 4),
                    Text('Default Speed Target: 450 WPM', style: GoogleFonts.inter(fontSize: 13, color: theme.colorScheme.onSurfaceVariant)),
                    const SizedBox(height: 4),
                    Text('ORP Focus Highlight: Energetic Orange (#FD761A)', style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFFFD761A))),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              // Bento Tile 4: Data & Storage
              _BentoTile(
                title: 'DATA & LOCAL RUST ENGINE STORAGE',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Rust Core Core State: Embedded local execution (0 cloud calls)', style: GoogleFonts.inter(fontSize: 12)),
                    const SizedBox(height: 4),
                    Text('Vector Storage Index: 384-dim semantic embeddings', style: GoogleFonts.jetBrainsMono(fontSize: 11, color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BentoTile extends StatelessWidget {
  final String title;
  final Widget child;
  const _BentoTile({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
