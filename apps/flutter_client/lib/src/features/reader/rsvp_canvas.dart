import 'package:flutter/material.dart';

class RsvpCanvasView extends StatefulWidget {
  final String text;
  final int targetWpm;

  const RsvpCanvasView({
    super.key,
    required this.text,
    this.targetWpm = 450,
  });

  @override
  State<RsvpCanvasView> createState() => _RsvpCanvasViewState();
}

class _RsvpCanvasViewState extends State<RsvpCanvasView> {
  late List<String> _words;
  int _currentIndex = 0;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _words = widget.text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
  }

  int _calculateOrpIndex(String word) {
    final len = word.length;
    if (len <= 1) return 0;
    if (len <= 5) return 1;
    if (len <= 9) return 2;
    if (len <= 13) return 3;
    return 4;
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
    if (_isPlaying) {
      _tick();
    }
  }

  void _tick() async {
    if (!_isPlaying || _currentIndex >= _words.length - 1) {
      setState(() => _isPlaying = false);
      return;
    }

    final delay = (60000 / widget.targetWpm).round();
    await Future.delayed(Duration(milliseconds: delay));
    if (mounted && _isPlaying) {
      setState(() {
        _currentIndex++;
      });
      _tick();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_words.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No text loaded.')),
      );
    }

    final currentWord = _words[_currentIndex];
    final orpIndex = _calculateOrpIndex(currentWord);

    final prefix = currentWord.substring(0, orpIndex.clamp(0, currentWord.length));
    final keyChar = currentWord.isEmpty
        ? ''
        : currentWord[orpIndex.clamp(0, currentWord.length - 1)];
    final suffix = (orpIndex + 1 < currentWord.length)
        ? currentWord.substring(orpIndex + 1)
        : '';

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('RSVP Redicle Reader'),
        actions: [
          IconButton(
            icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: _togglePlay,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ORP Focus Redicle Box
          Center(
            child: Container(
              height: 120,
              width: 320,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.outlineVariant,
                  width: 1.5,
                ),
              ),
              child: CustomPaint(
                painter: OrpGuidePainter(
                  accentColor: theme.colorScheme.error,
                ),
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 32,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: prefix,
                          style: TextStyle(color: theme.colorScheme.onSurface),
                        ),
                        TextSpan(
                          text: keyChar,
                          style: TextStyle(
                            color: theme.colorScheme.error,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        TextSpan(
                          text: suffix,
                          style: TextStyle(color: theme.colorScheme.onSurface),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Target Speed: ${widget.targetWpm} WPM',
            style: theme.textTheme.bodyMedium,
          ),
          Slider(
            value: _currentIndex.toDouble(),
            min: 0,
            max: (_words.length - 1).toDouble().clamp(0, double.infinity),
            onChanged: (val) {
              setState(() {
                _currentIndex = val.toInt();
              });
            },
          ),
        ],
      ),
    );
  }
}

class OrpGuidePainter extends CustomPainter {
  final Color accentColor;

  OrpGuidePainter({required this.accentColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = accentColor.withOpacity(0.5)
      ..strokeWidth = 2;

    // Top vertical guide tick
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, 12),
      paint,
    );

    // Bottom vertical guide tick
    canvas.drawLine(
      Offset(size.width / 2, size.height - 12),
      Offset(size.width / 2, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
