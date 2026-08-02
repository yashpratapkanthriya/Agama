import 'package:flutter/material.dart';
import '../../core/app_tokens.dart';
import 'calibration_view.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTokens.spaceLg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Icon(
                Icons.bolt,
                size: 80,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: AppTokens.spaceMd),
              Text(
                'Welcome to Agama',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppTokens.spaceMd),
              Text(
                'Sub-vocalization free speed reading & knowledge synthesis platform.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CalibrationView()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppTokens.spaceMd),
                ),
                icon: const Icon(Icons.speed),
                label: const Text('Calibrate WPM Speed'),
              ),
              const SizedBox(height: AppTokens.spaceMd),
              TextButton(
                onPressed: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context).pushReplacementNamed('/library');
                  }
                },
                child: const Text('Skip to Library'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
