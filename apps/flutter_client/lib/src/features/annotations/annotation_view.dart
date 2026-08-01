import 'package:flutter/material.dart';

class AnnotationItem {
  final String id;
  final String selectedText;
  final String? note;
  final Color color;

  const AnnotationItem({
    required this.id,
    required this.selectedText,
    this.note,
    required this.color,
  });
}

class AnnotationView extends StatefulWidget {
  const AnnotationView({super.key});

  @override
  State<AnnotationView> createState() => _AnnotationViewState();
}

class _AnnotationViewState extends State<AnnotationView> {
  final List<AnnotationItem> _annotations = [
    const AnnotationItem(
      id: '1',
      selectedText: 'Zero-backend local-first architecture ensures 100% data sovereignty.',
      note: 'Key architecture principle for Agama platform.',
      color: Color(0xFFFFD700), // Yellow
    ),
    const AnnotationItem(
      id: '2',
      selectedText: 'Adaptive Intelligent Pacing dynamically slows down WPM for dense sentences.',
      note: 'ONNX MiniLM-L6-v2 syntactic complexity calculation.',
      color: Color(0xFF4CAF50), // Green
    ),
  ];

  Color _selectedColor = const Color(0xFFFFD700);
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  void _addAnnotation() {
    if (_textController.text.trim().isEmpty) return;

    setState(() {
      _annotations.insert(
        0,
        AnnotationItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          selectedText: _textController.text.trim(),
          note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
          color: _selectedColor,
        ),
      );
    });

    _textController.clear();
    _noteController.clear();
    Navigator.pop(context);
  }

  void _showAddModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Inline Highlight & Note',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  labelText: 'Selected Text Snippet',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Markdown Marginalia Note (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Highlight Color: '),
                  const SizedBox(width: 8),
                  ...[
                    const Color(0xFFFFD700), // Yellow
                    const Color(0xFF4CAF50), // Green
                    const Color(0xFF2196F3), // Blue
                    const Color(0xFFE91E63), // Pink
                    const Color(0xFF9C27B0), // Purple
                  ].map((color) {
                    final isSelected = _selectedColor == color;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedColor = color),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(color: Colors.white, width: 3)
                              : null,
                        ),
                      ),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _addAnnotation,
                  child: const Text('Save Annotation'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Highlights & Knowledge Base'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('sqlite-vec 384-dim vector similarity search active')),
              );
            },
          ),
        ],
      ),
      body: _annotations.isEmpty
          ? const Center(child: Text('No highlights yet.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _annotations.length,
              itemBuilder: (context, index) {
                final ann = _annotations[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: ann.color,
                          width: 6,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '"${ann.selectedText}"',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        if (ann.note != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            ann.note!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddModal,
        child: const Icon(Icons.add_comment),
      ),
    );
  }
}
