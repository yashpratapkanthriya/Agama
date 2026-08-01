import 'package:flutter/material.dart';
import '../reader/rsvp_canvas.dart';

class LibraryView extends StatelessWidget {
  const LibraryView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agama Library'),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Zero-Backend AI Speed Reading',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Local-first document ingestion & adaptive intelligent pacing engine.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: [
                  Card(
                    elevation: 2,
                    child: ListTile(
                      leading: const Icon(Icons.book, size: 36),
                      title: const Text('Demo Sample: Scientific Reading Paper'),
                      subtitle: const Text('Adaptive Intelligent Pacing (AIP) & ORP Redicle Demo'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RsvpCanvasView(
                              text:
                                  'The Agama Platform is engineered as a high-performance local-first zero-backend multi-platform speed reading system. By executing PDF layout parsing, vector indexing, and ONNX token complexity inference inside an embedded Rust core, the system achieves absolute privacy, zero cloud runtime costs, and instant UI responsiveness.',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
