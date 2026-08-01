import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/app.dart';
import '../../app/theme.dart';
import '../reader/rsvp_canvas.dart';
import '../reader/guided_highlight_view.dart';
import '../reader/bionic_fixation_view.dart';
import '../annotations/annotation_view.dart';
import '../flashcards/flashcard_view.dart';
import '../sync/sync_view.dart';
import '../analytics/analytics_view.dart';
import 'file_parser_service.dart';

// ── Root scaffold with persistent bottom nav ───────────────────────────────
class LibraryView extends StatefulWidget {
  final int initialTab;
  const LibraryView({super.key, this.initialTab = 0});

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  late int _tab;

  @override
  void initState() {
    super.initState();
    final uri = Uri.base;
    final path = uri.path;
    final fragment = uri.fragment;

    if (path.contains('knowledge') || fragment.contains('knowledge')) {
      _tab = 1;
    } else if (path.contains('analytics') || fragment.contains('analytics')) {
      _tab = 2;
    } else {
      _tab = widget.initialTab;
    }
  }

  void _onTabSelected(int i) {
    setState(() => _tab = i);
    final routeName = switch (i) {
      1 => '/knowledge',
      2 => '/analytics',
      _ => '/library',
    };
    SystemNavigator.routeInformationUpdated(uri: Uri.parse(routeName));
  }

  static const _sampleText =
      'The Agama Platform is engineered as a high-performance local-first zero-backend speed reading system. By executing PDF parsing, vector indexing, and ONNX complexity inference inside an embedded Rust core, the system achieves absolute privacy, zero cloud costs, and instant responsiveness.';

  final List<_Doc> _docs = [
    const _Doc('Zero-Backend SAD Architecture', 'PDF', 5100, 0.65, AgamaTheme.indigo),
    const _Doc('Quantum Optics & Photonic Computing', 'EPUB', 2450, 0.30, AgamaTheme.emerald),
    const _Doc('ONNX Syntactic Complexity Engine', 'MD', 1820, 0.90, AgamaTheme.amber),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final tabs = [
      _LibraryTab(docs: _docs, sampleText: _sampleText),
      const _KnowledgeTab(),
      const AnalyticsView(),
    ];

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 52,
        title: Row(
          children: [
            // Logo — dark tile with crimson ORP char
            Container(
              width: 28, height: 28,
              decoration: BoxDecoration(
                color: AgamaTheme.rsvpBg,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Center(
                child: Text('A',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 14, fontWeight: FontWeight.w800,
                    color: AgamaTheme.crimson,
                  )),
              ),
            ),
            const SizedBox(width: 9),
            Text('Agama',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(width: 10),
            _LivePulse(),
          ],
        ),
        actions: [
          _AppBarBtn(
            icon: isDark ? Icons.wb_sunny_outlined : Icons.dark_mode_outlined,
            tooltip: isDark ? 'Light mode' : 'Dark mode',
            onTap: () {
              themeModeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
          _AppBarBtn(
            icon: Icons.cloud_sync_outlined, tooltip: 'Sync',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SyncView())),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: tabs[_tab],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: _onTabSelected,
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: AgamaTheme.indigoLight,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        height: 62,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Library',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmarks_outlined),
            selectedIcon: Icon(Icons.bookmarks),
            label: 'Knowledge',
          ),
          NavigationDestination(
            icon: Icon(Icons.query_stats_outlined),
            selectedIcon: Icon(Icons.query_stats),
            label: 'Analytics',
          ),
        ],
      ),
    );
  }
}

// ── Tab 0: Library + Engine picker ────────────────────────────────────────
class _LibraryTab extends StatelessWidget {
  final List<_Doc> docs;
  final String sampleText;
  const _LibraryTab({required this.docs, required this.sampleText});

  void _navigate(BuildContext ctx, Widget page) =>
      Navigator.push(ctx, MaterialPageRoute(builder: (_) => page));

  void _showImportSheet(BuildContext context) {
    final ctrl = TextEditingController();
    final parser = FileParserService();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20,
              MediaQuery.of(context).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Import & Read Document',
                      style: Theme.of(context).textTheme.titleMedium),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AgamaTheme.indigo.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('.PDF', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AgamaTheme.indigo)),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AgamaTheme.emerald.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('.EPUB', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AgamaTheme.emerald)),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AgamaTheme.amber.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('.MD', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AgamaTheme.amber)),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text('Paste text or select a PDF / EPUB / Markdown file below.',
                  style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 12),
              // Preset PDF / EPUB Quick Import Bar
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        const samplePdfHeader = 'BT /F1 12 Tf 72 712 Td (Agama Platform PDF Specification: Zero-Backend Speed Reader) Tj ET';
                        final bytes = Uint8List.fromList(utf8.encode('%PDF-1.7 $samplePdfHeader'));
                        final parsed = parser.parseBytes(bytes, 'document_sample.pdf');
                        ctrl.text = parsed.content;
                        setModalState(() {});
                      },
                      icon: const Icon(Icons.picture_as_pdf_outlined, size: 16, color: Colors.redAccent),
                      label: const Text('Sample .PDF', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        const sampleEpubText = 'Chapter 1: Quantum Photonic Architecture and Sub-Millisecond RSVP Fixation Engine';
                        final bytes = Uint8List.fromList(utf8.encode(sampleEpubText));
                        final parsed = parser.parseBytes(bytes, 'research_paper.epub');
                        ctrl.text = parsed.content;
                        setModalState(() {});
                      },
                      icon: const Icon(Icons.book_outlined, size: 16, color: Colors.teal),
                      label: const Text('Sample .EPUB', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // External Workflow Integrations
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        const sampleText = 'Instapaper Sync: "How to Build Zero-Backend Apps" by Local-First Web';
                        final bytes = Uint8List.fromList(utf8.encode(sampleText));
                        final parsed = parser.parseBytes(bytes, 'instapaper_article.txt');
                        ctrl.text = parsed.content;
                        setModalState(() {});
                      },
                      icon: const Icon(Icons.bookmark_border, size: 16, color: Colors.blueGrey),
                      label: const Text('Instapaper', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        const sampleText = 'Pocket Sync: "The Future of Offline-First AI" by Agama Labs';
                        final bytes = Uint8List.fromList(utf8.encode(sampleText));
                        final parsed = parser.parseBytes(bytes, 'pocket_article.txt');
                        ctrl.text = parsed.content;
                        setModalState(() {});
                      },
                      icon: const Icon(Icons.save_outlined, size: 16, color: Colors.red),
                      label: const Text('Pocket', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        const sampleText = 'RSS Sync: "Hacker News Frontpage Dump"';
                        final bytes = Uint8List.fromList(utf8.encode(sampleText));
                        final parsed = parser.parseBytes(bytes, 'rss_feed.txt');
                        ctrl.text = parsed.content;
                        setModalState(() {});
                      },
                      icon: const Icon(Icons.rss_feed, size: 16, color: Colors.orange),
                      label: const Text('RSS Feed', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: ctrl,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Paste document text or click Sample .PDF / .EPUB above…',
                ),
              ),
              const SizedBox(height: 16),
              // Engine choice inline
              Text('Choose reading mode:',
                  style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: _EngineBtn(
                  label: 'RSVP', sub: 'Fastest', color: AgamaTheme.indigo,
                  onTap: () {
                    final parsed = parser.parseRawText(ctrl.text, 'imported_document.pdf');
                    if (parsed.content.isEmpty) return;
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (_) => RsvpCanvasView(text: parsed.content),
                    ));
                  },
                )),
                const SizedBox(width: 8),
                Expanded(child: _EngineBtn(
                  label: 'Sweep', sub: 'Natural', color: AgamaTheme.emerald,
                  onTap: () {
                    final parsed = parser.parseRawText(ctrl.text, 'imported_document.pdf');
                    if (parsed.content.isEmpty) return;
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (_) => GuidedHighlightView(text: parsed.content),
                    ));
                  },
                )),
                const SizedBox(width: 8),
                Expanded(child: _EngineBtn(
                  label: 'Bionic', sub: 'Full text', color: AgamaTheme.amber,
                  onTap: () {
                    final parsed = parser.parseRawText(ctrl.text, 'imported_document.pdf');
                    if (parsed.content.isEmpty) return;
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (_) => BionicFixationView(text: parsed.content),
                    ));
                  },
                )),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Hero — what is this app? ─────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AgamaTheme.rsvpBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Read faster. Remember more.',
                      style: GoogleFonts.outfit(
                        fontSize: 22, fontWeight: FontWeight.w800,
                        color: Colors.white, height: 1.2,
                      )),
                    const SizedBox(height: 8),
                    Text(
                      'Agama trains your reading speed using three science-backed methods. '
                      'Paste any text below to begin.',
                      style: GoogleFonts.inter(
                        fontSize: 13, height: 1.55,
                        color: const Color(0xFF8A93AB),
                      )),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: AgamaTheme.indigo,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9)),
                        ),
                        onPressed: () => _showImportSheet(context),
                        icon: const Icon(Icons.add_rounded, size: 18, color: Colors.white),
                        label: Text('Paste text to read',
                          style: GoogleFonts.inter(
                            fontSize: 14, fontWeight: FontWeight.w600,
                            color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Engine chooser with decision guide ───────────────────
              const _SectionLabel('CHOOSE YOUR METHOD'),
              const SizedBox(height: 10),
              _EngineChooser(sampleText: sampleText),

              const SizedBox(height: 24),

              // ── Document library ─────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const _SectionLabel('YOUR LIBRARY'),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: AgamaTheme.indigo,
                      textStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    ),
                    onPressed: () => _showImportSheet(context),
                    icon: const Icon(Icons.add, size: 15),
                    label: const Text('Import'),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              ...docs.map((d) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _DocumentTile(
                  doc: d,
                  onTap: () => _navigate(context, RsvpCanvasView(text: sampleText)),
                ),
              )),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Tab 1: Knowledge (Highlights + Flashcards) ────────────────────────────
class _KnowledgeTab extends StatelessWidget {
  const _KnowledgeTab();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const _SectionLabel('KNOWLEDGE TOOLS'),
              Row(
                children: [
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: AgamaTheme.indigo,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      SystemNavigator.routeInformationUpdated(uri: Uri.parse('/highlights'));
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AnnotationView(showCreateOnLaunch: true)),
                      );
                    },
                    icon: const Icon(Icons.add, size: 16),
                    label: Text(
                      'Add Highlight',
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text('Save highlights and train your memory with spaced repetition.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: 20),
          _KnowledgeTile(
            icon: Icons.bookmarks_outlined,
            accent: AgamaTheme.indigo,
            title: 'Highlights & Notes',
            subtitle: 'Save passages · search by meaning (384-dim vectors)',
            detail: 'Tap any highlighted passage to jump back to its context.',
            onTap: () {
              SystemNavigator.routeInformationUpdated(uri: Uri.parse('/highlights'));
              Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AnnotationView()));
            },
          ),
          const SizedBox(height: 10),
          _KnowledgeTile(
            icon: Icons.psychology_outlined,
            accent: AgamaTheme.emerald,
            title: 'Flashcard Trainer',
            subtitle: 'SM-2 spaced repetition · rate each card 0–5',
            detail: 'Cards you find hard appear more often. Easy ones space out.',
            onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const FlashcardView())),
          ),
        ],
      ),
    );
  }
}

// ── Engine chooser — decision guide ──────────────────────────────────────
class _EngineChooser extends StatefulWidget {
  final String sampleText;
  const _EngineChooser({required this.sampleText});

  @override
  State<_EngineChooser> createState() => _EngineChooserState();
}

class _EngineChooserState extends State<_EngineChooser> {
  int _selected = 0; // 0=RSVP, 1=Sweep, 2=Bionic

  static const _engines = [
    _EngineInfo(
      label: 'RSVP Redicle',
      icon: Icons.remove_red_eye_outlined,
      accent: AgamaTheme.indigo,
      tagline: 'Fastest — one word at a time',
      bestFor: 'Articles, reports, anything you want to read quickly.',
      tradeoff: 'You lose visual context. Good once you\'re comfortable.',
      wpmRange: '400–1000+ WPM',
    ),
    _EngineInfo(
      label: 'Guided Sweep',
      icon: Icons.highlight_alt_rounded,
      accent: AgamaTheme.emerald,
      tagline: 'Natural — full text with moving focus',
      bestFor: 'Complex or technical content where you may re-read.',
      tradeoff: 'Slower than RSVP, but comprehension stays higher.',
      wpmRange: '250–600 WPM',
    ),
    _EngineInfo(
      label: 'Bionic Fixation',
      icon: Icons.format_bold_rounded,
      accent: AgamaTheme.amber,
      tagline: 'Hybrid — full text, key letters bolded',
      bestFor: 'Beginners, or when reading on a small screen.',
      tradeoff: 'Speed gain is modest (~15%). Good habit builder.',
      wpmRange: '200–450 WPM',
    ),
  ];

  void _launch(BuildContext context) {
    final text = widget.sampleText;
    Widget page = switch (_selected) {
      0 => RsvpCanvasView(text: text),
      1 => GuidedHighlightView(text: text),
      _ => BionicFixationView(text: text),
    };
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final e = _engines[_selected];

    return Column(
      children: [
        // Selector row
        Row(children: List.generate(3, (i) {
          final eng = _engines[i];
          final sel = _selected == i;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i < 2 ? 8 : 0),
              child: GestureDetector(
                onTap: () => setState(() => _selected = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: sel ? eng.accent.withAlpha(18) : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: sel ? eng.accent : theme.colorScheme.outline,
                      width: sel ? 1.5 : 1,
                    ),
                  ),
                  child: Column(children: [
                    Icon(eng.icon,
                      color: sel ? eng.accent : theme.colorScheme.onSurfaceVariant,
                      size: 20),
                    const SizedBox(height: 4),
                    Text(eng.label.split(' ').first,
                      style: GoogleFonts.inter(
                        fontSize: 11, fontWeight: FontWeight.w600,
                        color: sel ? eng.accent : theme.colorScheme.onSurfaceVariant,
                      )),
                  ]),
                ),
              ),
            ),
          );
        })),

        const SizedBox(height: 12),

        // Detail card for selected engine
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: Container(
            key: ValueKey(_selected),
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: e.accent.withAlpha(60), width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(e.tagline,
                      style: theme.textTheme.titleSmall?.copyWith(color: e.accent)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: e.accent.withAlpha(15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(e.wpmRange,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 10, fontWeight: FontWeight.w700,
                          color: e.accent)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _EngineRow(icon: Icons.check_circle_outline, text: e.bestFor, color: e.accent),
                const SizedBox(height: 4),
                _EngineRow(icon: Icons.info_outline, text: e.tradeoff,
                  color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: e.accent,
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9)),
                    ),
                    onPressed: () => _launch(context),
                    icon: const Icon(Icons.play_arrow_rounded, size: 16, color: Colors.white),
                    label: Text('Try with sample text',
                      style: GoogleFonts.inter(
                        fontSize: 13, fontWeight: FontWeight.w600,
                        color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _EngineRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  const _EngineRow({required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 6),
        Expanded(
          child: Text(text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.5)),
        ),
      ],
    );
  }
}

class _EngineInfo {
  final String label, tagline, bestFor, tradeoff, wpmRange;
  final IconData icon;
  final Color accent;
  const _EngineInfo({
    required this.label, required this.icon, required this.accent,
    required this.tagline, required this.bestFor,
    required this.tradeoff, required this.wpmRange,
  });
}

// ── Document data model ───────────────────────────────────────────────────
class _Doc {
  final String title, format;
  final int words;
  final double progress;
  final Color accent;
  const _Doc(this.title, this.format, this.words, this.progress, this.accent);
}

// ── Document tile ─────────────────────────────────────────────────────────
class _DocumentTile extends StatelessWidget {
  final _Doc doc;
  final VoidCallback onTap;
  const _DocumentTile({required this.doc, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pct = (doc.progress * 100).round();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.outline),
        ),
        child: Row(children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: doc.accent.withAlpha(18),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(child: Text(doc.format,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 9, fontWeight: FontWeight.w800,
                color: doc.accent, letterSpacing: 0.3))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(doc.title, style: theme.textTheme.titleSmall,
                maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 3),
              Text('${doc.words} words', style: theme.textTheme.bodySmall),
              const SizedBox(height: 6),
              Row(children: [
                Expanded(child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: doc.progress, minHeight: 3,
                    backgroundColor: doc.accent.withAlpha(22),
                    valueColor: AlwaysStoppedAnimation<Color>(doc.accent),
                  ),
                )),
                const SizedBox(width: 8),
                Text('$pct%', style: GoogleFonts.jetBrainsMono(
                  fontSize: 10, fontWeight: FontWeight.w700, color: doc.accent)),
              ]),
            ]),
          ),
          const SizedBox(width: 10),
          Icon(Icons.chevron_right_rounded,
            size: 18, color: theme.colorScheme.onSurfaceVariant),
        ]),
      ),
    );
  }
}

// ── Knowledge tile ────────────────────────────────────────────────────────
class _KnowledgeTile extends StatelessWidget {
  final IconData icon;
  final Color accent;
  final String title, subtitle, detail;
  final VoidCallback onTap;
  const _KnowledgeTile({
    required this.icon, required this.accent,
    required this.title, required this.subtitle,
    required this.detail, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.outline),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(
                color: accent.withAlpha(18),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: accent, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleSmall),
                const SizedBox(height: 3),
                Text(subtitle, style: theme.textTheme.bodySmall),
                const SizedBox(height: 6),
                Text(detail,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  )),
              ],
            )),
            Icon(Icons.chevron_right_rounded,
              size: 18, color: theme.colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

// ── Shared AppBar button ──────────────────────────────────────────────────
class _AppBarBtn extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  const _AppBarBtn({required this.icon, required this.tooltip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Icon(icon, size: 20, color: AgamaTheme.inkMuted),
        ),
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
      style: GoogleFonts.jetBrainsMono(
        fontSize: 10, fontWeight: FontWeight.w700,
        letterSpacing: 1.5, color: AgamaTheme.inkFaint,
      ));
  }
}

// ── Engine launch button (used in import sheet) ───────────────────────────
class _EngineBtn extends StatelessWidget {
  final String label, sub;
  final Color color;
  final VoidCallback onTap;
  const _EngineBtn({required this.label, required this.sub,
    required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withAlpha(15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withAlpha(50)),
        ),
        child: Column(children: [
          Text(label, style: GoogleFonts.inter(
            fontSize: 13, fontWeight: FontWeight.w700, color: color)),
          Text(sub, style: GoogleFonts.inter(
            fontSize: 10, color: color.withAlpha(180))),
        ]),
      ),
    );
  }
}

// ── Live latency pulse ────────────────────────────────────────────────────
class _LivePulse extends StatefulWidget {
  @override
  State<_LivePulse> createState() => _LivePulseState();
}

class _LivePulseState extends State<_LivePulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ac;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))
      ..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ac, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      AnimatedBuilder(animation: _anim, builder: (_, __) => Container(
        width: 6, height: 6,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AgamaTheme.emerald.withAlpha(((_anim.value * 0.5 + 0.5) * 255).toInt()),
        ),
      )),
      const SizedBox(width: 5),
      Text('local', style: GoogleFonts.jetBrainsMono(
        fontSize: 10, fontWeight: FontWeight.w600, color: AgamaTheme.emerald)),
    ]);
  }
}
