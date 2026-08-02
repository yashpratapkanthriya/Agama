import 'package:flutter/material.dart';
import '../../core/app_tokens.dart';

class CalibrationView extends StatefulWidget {
  const CalibrationView({super.key});

  @override
  State<CalibrationView> createState() => _CalibrationViewState();
}

class _CalibrationViewState extends State<CalibrationView> {
  double _wpm = 300.0;
  bool _isTesting = false;
  int _currentWordIndex = 0;
  final List<String> _sampleWords = [
    'Speed',
    'reading',
    'allows',
    'you',
    'to',
    'process',
    'information',
    'faster',
    'while',
    'maintaining',
    'high',
    'comprehension.',
    'Agama',
    'helps',
    'train',
    'your',
    'brain',
    'to',
    'eliminate',
    'sub-vocalization.'
  ];

  void _startTest() {
    setState(() {
      _isTesting = true;
      _currentWordIndex = 0;
    });
    _runWordLoop();
  }

  void _runWordLoop() async {
    while (_isTesting && mounted && _currentWordIndex < _sampleWords.length) {
      final delayMs = (60000 / _wpm).round();
      await Future.delayed(Duration(milliseconds: delayMs));
      if (mounted && _isTesting) {
        setState(() {
          _currentWordIndex++;
          if (_currentWordIndex >= _sampleWords.length) {
            _isTesting = false;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('WPM Speed Calibration'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTokens.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Calibrate Reading Speed',
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppTokens.spaceSm),
              Text(
                'Adjust your target Words Per Minute (WPM) and preview RSVP reading pace.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppTokens.spaceLg),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTokens.radiusLg),
                ),
                child: Container(
                  height: 160,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(AppTokens.spaceMd),
                  child: _isTesting
                      ? Text(
                          _currentWordIndex < _sampleWords.length
                              ? _sampleWords[_currentWordIndex]
                              : 'Calibration Complete!',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        )
                      : Text(
                          'Press "Test Pace" to preview RSVP word display',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: AppTokens.spaceLg),
              Text(
                'Target Speed: ${_wpm.round()} WPM',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Slider(
                value: _wpm,
                min: 100,
                max: 1000,
                divisions: 18,
                label: '${_wpm.round()} WPM',
                onChanged: (val) {
                  setState(() {
                    _wpm = val;
                  });
                },
              ),
              const SizedBox(height: AppTokens.spaceMd),
              OutlinedButton.icon(
                onPressed: _startTest,
                icon: const Icon(Icons.play_arrow),
                label: Text(_isTesting ? 'Restart Test' : 'Test Pace'),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(_wpm.round());
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppTokens.spaceMd),
                ),
                child: const Text('Save Speed & Complete Onboarding'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
