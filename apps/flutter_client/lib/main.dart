import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/app/app.dart';
import 'src/features/library/file_parser_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FileParserService.instance.init();
  runApp(
    const ProviderScope(
      child: AgamaApp(),
    ),
  );
}
