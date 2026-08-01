import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/theme.dart';
import 'reader_settings_provider.dart';

typedef RSVPCanvas = RsvpCanvasView;

class RsvpCanvasView extends ConsumerStatefulWidget {
  final String text;
  final int? targetWpm;

  const RsvpCanvasView({
    super.key,
    this.text = 'Speed reading sample text for RSVP canvas',
    this.targetWpm,
  });

  @override
  ConsumerState<RsvpCanvasView> createState() => _RsvpCanvasViewState();
}

class _RsvpCanvasViewState extends ConsumerState<RsvpCanvasView> {
  late List<String> _words;
  int _idx = 0;
  bool _playing = false;
  int? _customWpm;
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _customWpm = widget.targetWpm;
    _words = widget.text
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();
  }

  @override
  void dispose() {
    _playing = false;
    _focus.dispose();
    super.dispose();
  }

  int _orp(String w) {
    final l = w.length;
    if (l <= 1) return 0;
    if (l <= 5) return 1;
    if (l <= 9) return 2;
    if (l <= 13) return 3;
    return 4;
  }

  void _togglePlay() {
    setState(() => _playing = !_playing);
    if (_playing) _tick();
  }

  int _delayForWord(String w, int wpm) {
    var ms = 60000.0 / wpm;
    if (w.length > 6) ms += (w.length - 6) * ms * 0.08;
    if (w.endsWith('.') || w.endsWith('!') || w.endsWith('?')) {
      ms += 350.0;
    } else if (w.endsWith(',') || w.endsWith(';') || w.endsWith(':')) {
      ms += 150.0;
    }
    return ms.round();
  }

  void _tick() async {
    if (!_playing || _idx >= _words.length - 1) {
      if (mounted) setState(() => _playing = false);
      return;
    }
    final settings = ref.read(readerSettingsProvider);
    final wpm = _customWpm ?? settings.wpm;
    final delayMs = _delayForWord(_words[_idx], wpm);
    await Future.delayed(Duration(milliseconds: delayMs));
    if (mounted && _playing) {
      setState(() => _idx++);
      _tick();
    }
  }

  void _step(int d) =>
      setState(() => _idx = (_idx + d).clamp(0, _words.length - 1));
  void _setWpm(int w) {
    setState(() => _customWpm = w);
    ref.read(readerSettingsProvider.notifier).setWpm(w);
  }

  void _onKey(KeyEvent e) {
    if (e is! KeyDownEvent) return;
    final settings = ref.read(readerSettingsProvider);
    final currentWpm = _customWpm ?? settings.wpm;
    switch (e.logicalKey) {
      case LogicalKeyboardKey.space:
        _togglePlay();
      case LogicalKeyboardKey.arrowLeft:
        _step(-1);
      case LogicalKeyboardKey.arrowRight:
        _step(1);
      case LogicalKeyboardKey.arrowUp:
        _setWpm((currentWpm + 50).clamp(100, 1500));
      case LogicalKeyboardKey.arrowDown:
        _setWpm((currentWpm - 50).clamp(100, 1500));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = ref.watch(readerSettingsProvider);
    final wpm = _customWpm ?? settings.wpm;

    if (_words.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('RSVP Reader')),
        body: const Center(child: Text('No text loaded.')),
      );
    }

    final w = _words[_idx];
    final orp = _orp(w);
    final pre = w.substring(0, orp.clamp(0, w.length));
    final key = w.isEmpty ? '' : w[orp.clamp(0, w.length - 1)];
    final suf = orp + 1 < w.length ? w.substring(orp + 1) : '';
    final rem = ((_words.length - 1 - _idx) / wpm * 60).round();
    final pct = (_idx + 1) / _words.length;

    // Context: 3 words before + 3 after current
    final ctxStart = (_idx - 3).clamp(0, _words.length);
    final ctxEnd = (_idx + 4).clamp(0, _words.length);
    final ctxWords = _words.sublist(ctxStart, ctxEnd);
    final ctxCurrentLocal = _idx - ctxStart;

    return KeyboardListener(
      focusNode: _focus,
      autofocus: true,
      onKeyEvent: _onKey,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            'RSVP Reader',
            style: theme.textTheme.titleMedium,
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AgamaTheme.indigo.withAlpha(15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AgamaTheme.indigo.withAlpha(40),
                ),
              ),
              child: Text(
                '$wpm WPM',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AgamaTheme.indigo,
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Progress bar — full width, minimal
              LinearProgressIndicator(
                value: pct,
                minHeight: 2,
                backgroundColor: theme.colorScheme.outline,
                valueColor: const AlwaysStoppedAnimation<Color>(AgamaTheme.indigo),
              ),

              // Metadata row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Word ${_idx + 1} / ${_words.length}',
                      style: theme.textTheme.labelSmall,
                    ),
                    Text(
                      '${rem}s remaining',
                      style: theme.textTheme.labelSmall,
                    ),
                  ],
                ),
              ),

              // ── Context strip — shows surrounding words ──────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 100),
                  child: Wrap(
                    key: ValueKey(_idx),
                    alignment: WrapAlignment.center,
                    spacing: 4, runSpacing: 2,
                    children: List.generate(ctxWords.length, (i) {
                      final isCurrent = i == ctxCurrentLocal;
                      return Text(ctxWords[i],
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w400,
                          color: isCurrent
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onSurfaceVariant.withAlpha(100),
                        ));
                    }),
                  ),
                ),
              ),

              // ── Main viewport ─────────────────────────────────────────
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Guide tick — top
                        Container(
                          width: 2,
                          height: 10,
                          color: AgamaTheme.crimson,
                        ),
                        // ORP viewport
                        Container(
                          constraints: const BoxConstraints(
                            minWidth: 240,
                            maxWidth: 520,
                          ),
                          decoration: BoxDecoration(
                            color: AgamaTheme.rsvpBg,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _playing
                                  ? AgamaTheme.indigo.withAlpha(80)
                                  : const Color(0xFF252D45),
                              width: 1.5,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 20,
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 80),
                            child: RichText(
                              key: ValueKey(_idx),
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: settings.fontSize,
                                  fontFamily: settings.fontFamily,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.2,
                                ),
                                children: [
                                  TextSpan(
                                    text: pre,
                                    style: const TextStyle(color: Colors.white70),
                                  ),
                                  TextSpan(
                                    text: key,
                                    style: const TextStyle(
                                      color: AgamaTheme.crimson,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  TextSpan(
                                    text: suf,
                                    style: const TextStyle(color: Colors.white38),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Guide tick — bottom
                        Container(
                          width: 2,
                          height: 10,
                          color: AgamaTheme.crimson,
                        ),
                        const SizedBox(height: 28),

                        // WPM guidance
                        const SizedBox(height: 12),
                        Text(
                          wpm < 350
                              ? 'Good starting pace — build from here'
                              : wpm < 600
                                  ? 'Comfortable reading speed'
                                  : wpm < 900
                                      ? 'Fast — check comprehension after'
                                      : 'Extreme speed — expert readers only',
                          style: theme.textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                        Wrap(
                          spacing: 8,
                          children: [300, 450, 600, 800, 1000]
                              .map((v) => _WpmChip(
                                    wpm: v,
                                    selected: wpm == v,
                                    onTap: () => _setWpm(v),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Controls ──────────────────────────────────────────────
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  border: Border(
                    top: BorderSide(color: theme.colorScheme.outline),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Scrubber
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 6,
                        ),
                      ),
                      child: Slider(
                        value: _idx.toDouble(),
                        min: 0,
                        max: (_words.length - 1).toDouble().clamp(0, 99999),
                        onChanged: (v) => setState(() => _idx = v.toInt()),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Buttons row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _ControlBtn(
                          icon: Icons.replay_rounded,
                          tooltip: 'Restart',
                          onTap: () => setState(() => _idx = 0),
                        ),
                        const SizedBox(width: 8),
                        _ControlBtn(
                          icon: Icons.fast_rewind_rounded,
                          tooltip: '−5',
                          onTap: () => _step(-5),
                        ),
                        const SizedBox(width: 14),
                        // Primary play/pause
                        GestureDetector(
                          onTap: _togglePlay,
                          child: Container(
                            width: 52,
                            height: 52,
                            decoration: const BoxDecoration(
                              color: AgamaTheme.indigo,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _playing
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        _ControlBtn(
                          icon: Icons.fast_forward_rounded,
                          tooltip: '+5',
                          onTap: () => _step(5),
                        ),
                        const SizedBox(width: 8),
                        _ControlBtn(
                          icon: Icons.skip_next_rounded,
                          tooltip: 'End',
                          onTap: () =>
                              setState(() => _idx = _words.length - 1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Space · ← → step · ↑ ↓ adjust WPM',
                      style: theme.textTheme.labelSmall,
                      textAlign: TextAlign.center,
                    ),
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

class _WpmChip extends StatelessWidget {
  final int wpm;
  final bool selected;
  final VoidCallback onTap;

  const _WpmChip(
      {required this.wpm, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AgamaTheme.indigo : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? AgamaTheme.indigo : Theme.of(context).colorScheme.outline,
          ),
        ),
        child: Text(
          '$wpm',
          style: GoogleFonts.jetBrainsMono(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : AgamaTheme.inkMuted,
          ),
        ),
      ),
    );
  }
}

class _ControlBtn extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _ControlBtn(
      {required this.icon, required this.tooltip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 22, color: AgamaTheme.inkMuted),
        ),
      ),
    );
  }
}

// Kept for CustomPainter backward compatibility
class OrpGuidePainter extends CustomPainter {
  final Color accentColor;
  OrpGuidePainter({required this.accentColor});

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = accentColor
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(size.width / 2, 0), Offset(size.width / 2, 10), p);
    canvas.drawLine(Offset(size.width / 2, size.height - 10),
        Offset(size.width / 2, size.height), p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}
