import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/theme.dart';

class GuidedHighlightView extends StatefulWidget {
  final String text;
  final int targetWpm;

  const GuidedHighlightView({
    super.key,
    required this.text,
    this.targetWpm = 450,
  });

  @override
  State<GuidedHighlightView> createState() => _GuidedHighlightViewState();
}

class _GuidedHighlightViewState extends State<GuidedHighlightView> {
  late List<String> _words;
  int _idx = 0;
  bool _playing = false;
  late int _wpm;

  @override
  void initState() {
    super.initState();
    _wpm = widget.targetWpm;
    _words =
        widget.text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
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
    final delayMs = _delayForWord(_words[_idx], _wpm);
    await Future.delayed(Duration(milliseconds: delayMs));
    if (mounted && _playing) {
      setState(() => _idx++);
      _tick();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Guided Sweep', style: theme.textTheme.titleMedium),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AgamaTheme.emerald.withAlpha(15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AgamaTheme.emerald.withAlpha(40)),
            ),
            child: Text(
              '$_wpm WPM',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AgamaTheme.emerald,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            LinearProgressIndicator(
              value: (_idx + 1) / _words.length,
              minHeight: 2,
              backgroundColor: theme.colorScheme.outline,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AgamaTheme.emerald),
            ),

            // Reading surface — constrained to 65-75ch measure
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 680),
                    child: Wrap(
                      spacing: 5,
                      runSpacing: 8,
                      children: List.generate(_words.length, (i) {
                        final isCurrent = i == _idx;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 120),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: isCurrent
                                ? AgamaTheme.emerald.withAlpha(28)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _words[i],
                            style: GoogleFonts.inter(
                              fontSize: 17,
                              height: 1.65,
                              fontWeight: isCurrent
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                              color: isCurrent
                                  ? theme.colorScheme.onSurface
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),

            // Control bar
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border:
                    Border(top: BorderSide(color: theme.colorScheme.outline)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Slider(
                    value: _idx.toDouble(),
                    min: 0,
                    max: (_words.length - 1).toDouble().clamp(0, 99999),
                    onChanged: (v) => setState(() => _idx = v.toInt()),
                    activeColor: AgamaTheme.emerald,
                    inactiveColor: theme.colorScheme.outline,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // WPM selector
                      PopupMenuButton<int>(
                        tooltip: 'Speed',
                        icon: const Icon(Icons.speed,
                            color: AgamaTheme.inkMuted, size: 20),
                        onSelected: (v) => setState(() => _wpm = v),
                        itemBuilder: (_) => [300, 450, 600, 800]
                            .map((v) => PopupMenuItem(
                                  value: v,
                                  child: Text(
                                    '$v WPM',
                                    style: GoogleFonts.jetBrainsMono(
                                        fontSize: 13),
                                  ),
                                ))
                            .toList(),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: _togglePlay,
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: AgamaTheme.emerald,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _playing
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Tooltip(
                        message: 'Restart',
                        child: InkWell(
                          onTap: () => setState(() => _idx = 0),
                          borderRadius: BorderRadius.circular(8),
                          child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(Icons.replay_rounded,
                                size: 20, color: AgamaTheme.inkMuted),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
