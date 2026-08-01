import 'package:flutter/material.dart';

class BionicFixationView extends StatefulWidget {
  final String text;

  const BionicFixationView({
    super.key,
    required this.text,
  });

  @override
  State<BionicFixationView> createState() => _BionicFixationViewState();
}

class _BionicFixationViewState extends State<BionicFixationView> {
  int _fixationLevel = 3; // F1 to F5
  double _fontSize = 20.0;

  Map<String, String> _splitBionic(String word, int level) {
    final len = word.length;
    if (len == 0) return {'prefix': '', 'suffix': ''};

    final ratio = switch (level.clamp(1, 5)) {
      1 => 0.30,
      2 => 0.40,
      3 => 0.50,
      4 => 0.60,
      5 => 0.70,
      _ => 0.50,
    };

    final boldLen = ((len * ratio).ceil()).clamp(1, len);
    return {
      'prefix': word.substring(0, boldLen),
      'suffix': word.substring(boldLen),
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final words = widget.text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bionic Fixation Reading'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Wrap(
                spacing: 6.0,
                runSpacing: 8.0,
                children: words.map((w) {
                  final parts = _splitBionic(w, _fixationLevel);
                  return RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: _fontSize,
                        height: 1.6,
                        color: theme.colorScheme.onSurface,
                      ),
                      children: [
                        TextSpan(
                          text: parts['prefix'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        TextSpan(
                          text: parts['suffix'],
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            color: theme.colorScheme.surfaceContainerHighest,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fixation Level: F$_fixationLevel',
                        style: theme.textTheme.labelMedium,
                      ),
                      Slider(
                        value: _fixationLevel.toDouble(),
                        min: 1,
                        max: 5,
                        divisions: 4,
                        label: 'F$_fixationLevel',
                        onChanged: (val) {
                          setState(() {
                            _fixationLevel = val.toInt();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Font Size: ${_fontSize.toInt()}pt',
                        style: theme.textTheme.labelMedium,
                      ),
                      Slider(
                        value: _fontSize,
                        min: 14,
                        max: 32,
                        divisions: 9,
                        label: '${_fontSize.toInt()}pt',
                        onChanged: (val) {
                          setState(() {
                            _fontSize = val;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
