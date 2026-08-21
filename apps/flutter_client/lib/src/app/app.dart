import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'scholarly_theme.dart';
import '../features/library/library_view.dart';
import '../core/command_palette.dart';
import '../features/settings/keyboard_shortcuts_view.dart';
import '../features/onboarding/onboarding_view.dart';

final ValueNotifier<ThemeMode> themeModeNotifier =
    ValueNotifier<ThemeMode>(ThemeMode.light);

class AgamaApp extends StatelessWidget {
  const AgamaApp({super.key});

  Widget _getInitialHome() {
    final uri = Uri.base;
    final path = uri.path;
    final fragment = uri.fragment;

    if (path.contains('onboarding') || fragment.contains('onboarding')) {
      return const OnboardingView();
    }
    if (path.contains('highlights') || fragment.contains('highlights')) {
      return const LibraryView(initialTab: 1);
    }
    if (path.contains('knowledge') || fragment.contains('knowledge')) {
      return const LibraryView(initialTab: 1);
    }
    if (path.contains('analytics') || fragment.contains('analytics')) {
      return const LibraryView(initialTab: 2);
    }
    if (path.contains('settings') || fragment.contains('settings')) {
      return const LibraryView(initialTab: 3);
    }
    return const LibraryView(initialTab: 0);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: 'Agama',
          debugShowCheckedModeBanner: false,
          themeMode: currentMode,
          theme: ScholarlyTheme.light(),
          darkTheme: ScholarlyTheme.dark(),
          builder: (context, child) {
            return GlobalKeyboardShortcutWrapper(
              child: child ?? const SizedBox.shrink(),
            );
          },
          onGenerateRoute: (settings) {
            final name = settings.name ?? '';
            if (name.contains('onboarding')) {
              return MaterialPageRoute(
                builder: (_) => const OnboardingView(),
                settings: settings,
              );
            }
            if (name.contains('shortcuts')) {
              return MaterialPageRoute(
                builder: (_) => const KeyboardShortcutsView(),
                settings: settings,
              );
            }
            if (name.contains('knowledge')) {
              return MaterialPageRoute(
                builder: (_) => const LibraryView(initialTab: 1),
                settings: settings,
              );
            }
            if (name.contains('analytics')) {
              return MaterialPageRoute(
                builder: (_) => const LibraryView(initialTab: 2),
                settings: settings,
              );
            }
            if (name.contains('highlights')) {
              return MaterialPageRoute(
                builder: (_) => const LibraryView(initialTab: 1),
                settings: settings,
              );
            }
            return MaterialPageRoute(
              builder: (_) => const LibraryView(initialTab: 0),
              settings: settings,
            );
          },
          home: _getInitialHome(),
        );
      },
    );
  }
}

class GlobalKeyboardShortcutWrapper extends StatelessWidget {
  final Widget child;

  const GlobalKeyboardShortcutWrapper({super.key, required this.child});

  void _openCommandPalette(BuildContext context) async {
    final navigator = Navigator.of(context, rootNavigator: true);
    final result = await showDialog<String>(
      context: context,
      builder: (_) => const CommandPaletteModal(),
    );

    if (result != null && context.mounted) {
      if (result == 'View Keyboard Shortcuts') {
        navigator.push(
          MaterialPageRoute(builder: (_) => const KeyboardShortcutsView()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyK, meta: true): () =>
            _openCommandPalette(context),
        const SingleActivator(LogicalKeyboardKey.keyK, control: true): () =>
            _openCommandPalette(context),
      },
      child: Focus(
        autofocus: true,
        child: child,
      ),
    );
  }
}
