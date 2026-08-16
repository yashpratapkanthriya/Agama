import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/theme.dart';
import '../library/document_repository.dart';
import '../library/document_detail_view.dart';
import '../reader/rsvp_canvas.dart';
import '../reader/guided_highlight_view.dart';
import '../reader/bionic_fixation_view.dart';

class HomeTabView extends ConsumerStatefulWidget {
  final ValueChanged<int>? onNavigateToTab;
  const HomeTabView({super.key, this.onNavigateToTab});

  @override
  ConsumerState<HomeTabView> createState() => _HomeTabViewState();
}

class _HomeTabViewState extends ConsumerState<HomeTabView> {
  final TextEditingController _textController = TextEditingController();
  int _selectedMethod = 0; // 0=RSVP, 1=Sweep, 2=Bionic
  bool _showInputError = false;

  static const _engines = [
    _EngineInfo(
      label: 'RSVP Redicle',
      icon: Icons.remove_red_eye_outlined,
      accent: Color(0xFFFD761A),
      tagline: '⚡ MAX SPEED — One word at a time in center focus',
      bestFor: 'Articles, reports, anything you want to read quickly.',
      tradeoff: 'Single-word focus stage with ORP highlight.',
      wpmRange: '400–1000+ WPM',
    ),
    _EngineInfo(
      label: 'Guided Sweep',
      icon: Icons.highlight_alt_rounded,
      accent: Color(0xFF10B981),
      tagline: '📖 DEEP STUDY — Full text with moving focus cursor',
      bestFor: 'Complex or technical content where you may re-read.',
      tradeoff: 'Slower than RSVP, but comprehension stays higher.',
      wpmRange: '250–600 WPM',
    ),
    _EngineInfo(
      label: 'Bionic Fixation',
      icon: Icons.format_bold_rounded,
      accent: Color(0xFFF59E0B),
      tagline: '🧠 FOCUS AID — Full text, initial letters bolded',
      bestFor: 'Beginners, or when reading on a small screen.',
      tradeoff: 'Speed gain is modest (~15%). Good habit builder.',
      wpmRange: '200–450 WPM',
    ),
  ];

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _launchReader(BuildContext context) {
    final text = _textController.text.trim();
    if (text.isEmpty) {
      setState(() => _showInputError = true);
      return;
    }
    setState(() => _showInputError = false);
    Widget page = switch (_selectedMethod) {
      0 => RsvpCanvasView(text: text),
      1 => GuidedHighlightView(text: text),
      _ => BionicFixationView(text: text),
    };
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final docs = ref.watch(documentListProvider);
    final recentDocs = docs.take(3).toList();
    final engine = _engines[_selectedMethod];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Quick Metrics Strip ──────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const _SectionLabel('TODAY\'S METRICS'),
                  if (widget.onNavigateToTab != null)
                    TextButton.icon(
                      onPressed: () => widget.onNavigateToTab!(3),
                      icon: const Icon(Icons.show_chart, size: 14),
                      label: Text('Full Analytics',
                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.local_fire_department_rounded,
                      iconColor: const Color(0xFFFD761A),
                      value: '7 Days',
                      label: 'Reading Streak',
                      badge: 'Active 🔥',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.speed_rounded,
                      iconColor: AgamaTheme.emerald,
                      value: '520 WPM',
                      label: 'Current Speed',
                      badge: '+34% gain',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.menu_book_rounded,
                      iconColor: AgamaTheme.indigo,
                      value: '9,370',
                      label: 'Words Read Today',
                      badge: 'Goal: 10k',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ── Hero Speed Reader Stage ─────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AgamaTheme.rsvpBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withAlpha(15)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth > 500;
                        final headerText = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Instant Speed Reader',
                              style: GoogleFonts.outfit(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Paste or type any text below, choose your visual acceleration engine, and launch immediate training.',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                height: 1.5,
                                color: const Color(0xFF8A93AB),
                              ),
                            ),
                          ],
                        );

                        if (isWide) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(child: headerText),
                              const SizedBox(width: 16),
                              const SizedBox(width: 170, child: _RsvpGifPreview()),
                            ],
                          );
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              headerText,
                              const SizedBox(height: 12),
                              const Center(child: SizedBox(width: 200, child: _RsvpGifPreview())),
                            ],
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 18),

                    // Paste Box
                    TextField(
                      controller: _textController,
                      maxLines: 4,
                      style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Paste document text here or type to start reading...',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 13,
                          color: const Color(0xFF8A93AB),
                        ),
                        filled: true,
                        fillColor: Colors.white.withAlpha(10),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.white.withAlpha(20)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AgamaTheme.indigo),
                        ),
                        contentPadding: const EdgeInsets.all(14),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Methods Divider
                    Row(
                      children: [
                        const _SectionLabel('SELECT READING METHOD'),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Colors.white.withAlpha(15),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Engine Selection Buttons
                    Row(
                      children: List.generate(3, (i) {
                        final eng = _engines[i];
                        final isSel = _selectedMethod == i;
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: i < 2 ? 8 : 0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedMethod = i;
                                  _showInputError = false;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 160),
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                                decoration: BoxDecoration(
                                  color: isSel ? eng.accent.withAlpha(30) : Colors.white.withAlpha(6),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isSel ? eng.accent : Colors.white.withAlpha(20),
                                    width: isSel ? 1.5 : 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Icon(eng.icon, color: isSel ? eng.accent : Colors.white70, size: 20),
                                    const SizedBox(height: 4),
                                    Text(
                                      eng.label,
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: isSel ? Colors.white : Colors.white70,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 14),

                    // Engine Details & Launch
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(6),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: engine.accent.withAlpha(70), width: 1.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  engine.tagline,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: engine.accent,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: engine.accent.withAlpha(25),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  engine.wpmRange,
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: engine.accent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _EngineBullet(icon: Icons.check_circle_outline, text: engine.bestFor, color: engine.accent),
                          const SizedBox(height: 4),
                          _EngineBullet(
                            icon: Icons.info_outline,
                            text: engine.tradeoff,
                            color: const Color(0xFF8A93AB),
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              style: FilledButton.styleFrom(
                                backgroundColor: _showInputError ? AgamaTheme.crimson : engine.accent,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () => _launchReader(context),
                              icon: Icon(_showInputError ? Icons.warning_amber_rounded : Icons.play_arrow_rounded,
                                  size: 18),
                              label: Text(
                                _showInputError ? 'Please enter or paste text above first' : 'Start Reading with ${engine.label}',
                                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ── Continue Reading Section ────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const _SectionLabel('CONTINUE READING'),
                  if (widget.onNavigateToTab != null)
                    TextButton.icon(
                      onPressed: () => widget.onNavigateToTab!(1),
                      icon: const Icon(Icons.arrow_forward, size: 14),
                      label: Text('Open Library (${docs.length})',
                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              if (recentDocs.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF161B2E) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.colorScheme.outline),
                  ),
                  child: Center(
                    child: Text('No documents in library yet. Import your first file in Library tab.',
                        style: GoogleFonts.inter(color: theme.colorScheme.onSurfaceVariant, fontSize: 13)),
                  ),
                )
              else
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isDesktop = constraints.maxWidth > 700;
                    if (isDesktop) {
                      return Row(
                        children: recentDocs.map((doc) {
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: _RecentDocCard(
                                doc: doc,
                                onTap: () => _openDoc(context, doc),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    } else {
                      return Column(
                        children: recentDocs.map((doc) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: _RecentDocCard(
                              doc: doc,
                              onTap: () => _openDoc(context, doc),
                            ),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _openDoc(BuildContext context, DocumentItem doc) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DocumentDetailView(
          documentTitle: doc.title,
          content: doc.content,
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final String badge;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    required this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B2E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: iconColor, size: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  badge,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: iconColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _RecentDocCard extends StatelessWidget {
  final DocumentItem doc;
  final VoidCallback onTap;

  const _RecentDocCard({required this.doc, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF161B2E) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.outline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: doc.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    doc.format,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: doc.color,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  '${(doc.progress * 100).toInt()}%',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: doc.color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              doc.title,
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              '${doc.wordCount} words',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: doc.progress,
                minHeight: 4,
                backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.5),
                valueColor: AlwaysStoppedAnimation<Color>(doc.color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EngineInfo {
  final String label;
  final IconData icon;
  final Color accent;
  final String tagline;
  final String bestFor;
  final String tradeoff;
  final String wpmRange;

  const _EngineInfo({
    required this.label,
    required this.icon,
    required this.accent,
    required this.tagline,
    required this.bestFor,
    required this.tradeoff,
    required this.wpmRange,
  });
}

class _EngineBullet extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _EngineBullet({required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(fontSize: 11, color: Colors.white70, height: 1.4),
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.jetBrainsMono(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.0,
        color: const Color(0xFFFD761A),
      ),
    );
  }
}

class _RsvpGifPreview extends StatefulWidget {
  const _RsvpGifPreview();

  @override
  State<_RsvpGifPreview> createState() => _RsvpGifPreviewState();
}

class _RsvpGifPreviewState extends State<_RsvpGifPreview> {
  late final Timer _timer;
  int _wordIndex = 0;
  static const _words = ['Read', 'faster.', 'Remember', 'more.', 'Agama'];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 550), (_) {
      if (mounted) {
        setState(() => _wordIndex = (_wordIndex + 1) % _words.length);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final word = _words[_wordIndex];
    final orpIndex = (word.length / 2).floor();
    final leftStr = word.substring(0, orpIndex);
    final centerChar = word.substring(orpIndex, orpIndex + 1);
    final rightStr = word.substring(orpIndex + 1);

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF07090E),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withAlpha(25)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 1.5, height: 5, color: const Color(0xFF4A5568)),
          const SizedBox(height: 1),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: leftStr,
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: centerChar,
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFEF4444),
                    ),
                  ),
                  TextSpan(
                    text: rightStr,
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 1),
          Container(width: 1.5, height: 5, color: const Color(0xFF4A5568)),
        ],
      ),
    );
  }
}
