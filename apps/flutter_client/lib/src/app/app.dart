import 'package:flutter/material.dart';
import 'theme.dart';
import '../features/library/library_view.dart';
import '../features/annotations/annotation_view.dart';

final ValueNotifier<ThemeMode> themeModeNotifier =
    ValueNotifier<ThemeMode>(ThemeMode.light);

class AgamaApp extends StatelessWidget {
  const AgamaApp({super.key});

  Widget _getInitialHome() {
    final uri = Uri.base;
    final path = uri.path;
    final fragment = uri.fragment;

    if (path.contains('highlights') || fragment.contains('highlights')) {
      return const AnnotationView();
    }
    if (path.contains('knowledge') || fragment.contains('knowledge')) {
      return const LibraryView(initialTab: 1);
    }
    if (path.contains('analytics') || fragment.contains('analytics')) {
      return const LibraryView(initialTab: 2);
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
          theme: AgamaTheme.light(),
          darkTheme: AgamaTheme.dark(),
          home: _getInitialHome(),
        );
      },
    );
  }
}
