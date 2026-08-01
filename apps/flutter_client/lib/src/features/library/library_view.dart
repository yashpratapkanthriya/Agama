import 'package:flutter/material.dart';
import '../reader/rsvp_canvas.dart';
import '../reader/guided_highlight_view.dart';
import '../reader/bionic_fixation_view.dart';
import '../annotations/annotation_view.dart';
import '../flashcards/flashcard_view.dart';

class LibraryView extends StatelessWidget {
  const LibraryView({super.key});

  static const sampleText =
      'The Agama Platform is engineered as a high-performance local-first zero-backend multi-platform speed reading system. By executing PDF layout parsing, vector indexing, and ONNX token complexity inference inside an embedded Rust core, the system achieves absolute privacy, zero cloud runtime costs, and instant UI responsiveness.';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agama AI Platform'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.highlight),
            tooltip: 'Highlights & Notes',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AnnotationView()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.quiz),
            tooltip: 'SM-2 Flashcard Trainer',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FlashcardView()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Zero-Backend Speed Reader',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select reading display engine or knowledge training tools below.',
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
                      leading: const Icon(Icons.remove_red_eye, size: 32, color: Color(0xFF6750A4)),
                      title: const Text('Mode 1: RSVP ORP Redicle Reader'),
                      subtitle: const Text('Optimal Recognition Point anchor with accent color focus'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RsvpCanvasView(text: sampleText),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 2,
                    child: ListTile(
                      leading: const Icon(Icons.highlight_alt, size: 32, color: Color(0xFF4CAF50)),
                      title: const Text('Mode 2: Guided Highlighting (Smooth Sweep)'),
                      subtitle: const Text('Full-page paragraph text view with moving focus bar'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GuidedHighlightView(text: sampleText),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 2,
                    child: ListTile(
                      leading: const Icon(Icons.format_bold, size: 32, color: Color(0xFFFF9800)),
                      title: const Text('Mode 3: Bionic Fixation Bolding'),
                      subtitle: const Text('Configurable prefix bolding intensity (F1 to F5)'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BionicFixationView(text: sampleText),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  Text(
                    'Knowledge Management & Recall',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 1,
                    child: ListTile(
                      leading: const Icon(Icons.collections_bookmark, size: 28),
                      title: const Text('Highlights & Vector Search Base'),
                      subtitle: const Text('Inline color annotations & sqlite-vec semantic search'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AnnotationView()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 1,
                    child: ListTile(
                      leading: const Icon(Icons.psychology, size: 28),
                      title: const Text('SM-2 Spaced Repetition Flashcards'),
                      subtitle: const Text('Active recall drills with SuperMemo 2 scheduling'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const FlashcardView()),
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
