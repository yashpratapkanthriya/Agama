import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../features/library/library_view.dart';

class AgamaApp extends StatelessWidget {
  const AgamaApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seedColor = Color(0xFF6750A4);

    final darkColorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
      surface: const Color(0xFF1C1B1F),
      error: const Color(0xFFFFB4AB),
    );

    return MaterialApp(
      title: 'Agama AI Speed Reader',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
        textTheme: GoogleFonts.interTextTheme(
          ThemeData.dark().textTheme,
        ),
        scaffoldBackgroundColor: const Color(0xFF1C1B1F),
      ),
      home: const LibraryView(),
    );
  }
}
