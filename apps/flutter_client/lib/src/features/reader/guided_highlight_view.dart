import 'package:flutter/material.dart';

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
  int _highlightedIndex = 0;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _words = widget.text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
    if (_isPlaying) {
      _startHighlightStream();
    }
  }

  void _startHighlightStream() async {
    if (!_isPlaying || _highlightedIndex >= _words.length - 1) {
      setState(() => _isPlaying = false);
      return;
    }

    final delay = (60000 / widget.targetWpm).round();
    await Future.delayed(Duration(milliseconds: delay));

    if (mounted && _isPlaying) {
      setState(() {
        _highlightedIndex++;
      });
      _startHighlightStream();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Guided Highlighting Mode'),
        actions: [
          IconButton(
            icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: _togglePlay,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Wrap(
                spacing: 6.0,
                runSpacing: 8.0,
                children: List.generate(_words.length, (index) {
                  final isCurrent = index == _highlightedIndex;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? theme.colorScheme.primaryContainer
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(4.0),
                      border: isCurrent
                          ? Border.all(color: theme.colorScheme.primary, width: 1.5)
                          : null,
                    ),
                    child: Text(
                      _words[index],
                      style: TextStyle(
                        fontSize: 20,
                        height: 1.6,
                        fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                        color: isCurrent
                            ? theme.colorScheme.onPrimaryContainer
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            color: theme.colorScheme.surfaceContainerHighest,
            child: Column(
              children: [
                Text(
                  'Guided Pacing: ${widget.targetWpm} WPM',
                  style: theme.textTheme.bodyMedium,
                ),
                Slider(
                  value: _highlightedIndex.toDouble(),
                  min: 0,
                  max: (_words.length - 1).toDouble().clamp(0, double.infinity),
                  onChanged: (val) {
                    setState(() {
                      _highlightedIndex = val.toInt();
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
