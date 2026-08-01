import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/theme.dart';
import 'vector_search_service.dart';
import '../flashcards/flashcard_view.dart';

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

class AnnotationStore {
  static final List<AnnotationItem> items = [
    const AnnotationItem(
      id: '1',
      selectedText:
          'Zero-backend local-first architecture ensures 100% data sovereignty.',
      note: 'Core principle — nothing leaves the device.',
      color: AgamaTheme.indigo,
    ),
    const AnnotationItem(
      id: '2',
      selectedText:
          'Adaptive Intelligent Pacing slows WPM dynamically for complex sentences.',
      note: 'ONNX MiniLM-L6-v2 computes syntactic complexity per sentence.',
      color: AgamaTheme.emerald,
    ),
    const AnnotationItem(
      id: '3',
      selectedText:
          'ORP redicle positions fixation at the 35% word prefix for maximum throughput.',
      note: null,
      color: AgamaTheme.amber,
    ),
  ];
}

class AnnotationView extends StatefulWidget {
  final bool showCreateOnLaunch;
  const AnnotationView({super.key, this.showCreateOnLaunch = false});

  @override
  State<AnnotationView> createState() => _AnnotationViewState();
}

class _AnnotationViewState extends State<AnnotationView> {
  List<AnnotationItem> get _items => AnnotationStore.items;

  Color _pickedColor = AgamaTheme.indigo;
  final _textCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    if (widget.showCreateOnLaunch) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showSheet();
      });
    }
  }

  void _showSheet() {
    final isDesktop = MediaQuery.of(context).size.width > 600;
    if (isDesktop) {
      showDialog(
        context: context,
        useRootNavigator: false,
        builder: (dialogCtx) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: StatefulBuilder(
              builder: (context, setModalState) => Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Add highlight', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _textCtrl,
                      maxLines: 3,
                      autofocus: true,
                      decoration: const InputDecoration(
                        labelText: 'Selected passage',
                        hintText: 'Enter text to highlight…',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _noteCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Marginalia note (optional)',
                        hintText: 'Add your note here…',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text('Colour: ', style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(width: 8),
                        ...[AgamaTheme.indigo, AgamaTheme.emerald, AgamaTheme.amber,
                            AgamaTheme.crimson, const Color(0xFF7C3AED)]
                            .map((c) {
                          final sel = _pickedColor == c;
                          return GestureDetector(
                            onTap: () {
                              setModalState(() => _pickedColor = c);
                              setState(() => _pickedColor = c);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                color: c,
                                shape: BoxShape.circle,
                                border: sel
                                    ? Border.all(
                                        color: Theme.of(context).colorScheme.onSurface,
                                        width: 2.5)
                                    : null,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogCtx),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          onPressed: () {
                            final text = _textCtrl.text.trim();
                            if (text.isEmpty) return;
                            final noteText = _noteCtrl.text.trim();
                            setState(() {
                              AnnotationStore.items.insert(
                                0,
                                AnnotationItem(
                                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                                  selectedText: text,
                                  note: noteText.isEmpty ? null : noteText,
                                  color: _pickedColor,
                                ),
                              );
                            });
                            _textCtrl.clear();
                            _noteCtrl.clear();
                            Navigator.pop(dialogCtx);
                          },
                          child: const Text('Save highlight'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        useRootNavigator: false,
        isScrollControlled: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (sheetCtx) => StatefulBuilder(
          builder: (context, setModalState) => Padding(
            padding: EdgeInsets.only(
              left: 20, right: 20, top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Add highlight',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 16),
                TextField(
                  controller: _textCtrl,
                  maxLines: 2,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Selected passage',
                    hintText: 'Enter text to highlight…',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _noteCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Marginalia note (optional)',
                    hintText: 'Add your note here…',
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Text('Colour: ', style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(width: 8),
                    ...[AgamaTheme.indigo, AgamaTheme.emerald, AgamaTheme.amber,
                        AgamaTheme.crimson, const Color(0xFF7C3AED)]
                        .map((c) {
                      final sel = _pickedColor == c;
                      return GestureDetector(
                        onTap: () {
                          setModalState(() => _pickedColor = c);
                          setState(() => _pickedColor = c);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: c,
                            shape: BoxShape.circle,
                            border: sel
                                ? Border.all(
                                    color: Theme.of(context).colorScheme.onSurface,
                                    width: 2.5)
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
                    onPressed: () {
                      final text = _textCtrl.text.trim();
                      if (text.isEmpty) return;
                      final noteText = _noteCtrl.text.trim();
                      setState(() {
                        AnnotationStore.items.insert(
                          0,
                          AnnotationItem(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            selectedText: text,
                            note: noteText.isEmpty ? null : noteText,
                            color: _pickedColor,
                          ),
                        );
                      });
                      _textCtrl.clear();
                      _noteCtrl.clear();
                      Navigator.pop(sheetCtx);
                    },
                    child: const Text('Save highlight'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final List<AnnotationItem> filtered;
    if (_query.isEmpty) {
      filtered = _items;
    } else {
      final searchService = VectorSearchService();
      final searchResults = searchService.search(
        _items.map((a) => a.selectedText).toList(),
        _query,
      );
      final scoredItems = <AnnotationItem>[];
      for (final res in searchResults) {
        final item = _items.firstWhere((a) => a.selectedText == res.text);
        if (res.score > 0 ||
            item.selectedText.toLowerCase().contains(_query.toLowerCase()) ||
            (item.note?.toLowerCase().contains(_query.toLowerCase()) ?? false)) {
          if (!scoredItems.contains(item)) {
            scoredItems.add(item);
          }
        }
      }
      filtered = scoredItems;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Highlights', style: theme.textTheme.titleMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add highlight',
            onPressed: _showSheet,
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AgamaTheme.indigo.withAlpha(15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AgamaTheme.indigo.withAlpha(40)),
            ),
            child: Text(
              '${_items.length} notes',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AgamaTheme.indigo,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Search bar
              TextField(
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: 'Search highlights…',
                  prefixIcon: const Icon(Icons.search, size: 18),
                  suffixIcon: Container(
                    margin: const EdgeInsets.all(6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: AgamaTheme.indigo.withAlpha(15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '384d',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AgamaTheme.indigo,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // List
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Text(
                          _query.isEmpty
                              ? 'No highlights yet.'
                              : 'No matches found.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (_, i) {
                          final a = filtered[i];
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: theme.colorScheme.outline),
                              ),
                              child: IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Container(width: 4, color: a.color),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 14,
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '"${a.selectedText}"',
                                              style: theme.textTheme.bodyMedium?.copyWith(
                                                color: theme.colorScheme.onSurface,
                                                fontWeight: FontWeight.w500,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                            if (a.note != null) ...[
                                              const SizedBox(height: 8),
                                              Text(
                                                a.note!,
                                                style: theme.textTheme.bodySmall?.copyWith(
                                                  color: theme.colorScheme.onSurfaceVariant,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.style_outlined, size: 20),
                                      tooltip: 'Create Flashcard',
                                      color: theme.colorScheme.onSurfaceVariant,
                                      onPressed: () {
                                        FlashcardStore.items.add(FlashcardItem(
                                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                                          question: 'Recall the context and meaning of:\n\n"${a.selectedText}"',
                                          answer: a.note ?? 'Review the highlight again.',
                                        ));
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: const Text('Flashcard created for active recall!'),
                                            action: SnackBarAction(
                                              label: 'View',
                                              onPressed: () {},
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showSheet,
        backgroundColor: AgamaTheme.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
        icon: const Icon(Icons.add_comment_outlined, size: 18),
        label: Text(
          'Add highlight',
          style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
