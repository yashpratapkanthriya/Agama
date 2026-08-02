import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_client/src/features/onboarding/onboarding_view.dart';
import 'package:flutter_client/src/features/onboarding/calibration_view.dart';

void main() {
  testWidgets('OnboardingView displays welcome and step navigation to CalibrationView', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: OnboardingView(),
      ),
    );

    expect(find.text('Welcome to Agama'), findsOneWidget);
    expect(find.text('Calibrate WPM Speed'), findsOneWidget);

    await tester.tap(find.text('Calibrate WPM Speed'));
    await tester.pumpAndSettle();

    expect(find.byType(CalibrationView), findsOneWidget);
    expect(find.text('WPM Speed Calibration'), findsOneWidget);
  });
}
