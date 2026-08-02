import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import '../../app/app.dart';
import '../../app/theme.dart';
import '../reader/rsvp_canvas.dart';
import '../reader/guided_highlight_view.dart';
import '../reader/bionic_fixation_view.dart';
import '../annotations/annotation_view.dart';
import '../flashcards/flashcard_view.dart';
import '../analytics/analytics_view.dart';
import '../settings/user_settings_view.dart';
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
    } else if (path.contains('settings') || fragment.contains('settings')) {
      _tab = 3;
    } else {
      _tab = widget.initialTab;
    }
  }

  void _onTabSelected(int i) {
    setState(() => _tab = i);
    final routeName = switch (i) {
      1 => '/knowledge',
      2 => '/analytics',
      3 => '/settings',
      _ => '/library',
    };
    SystemNavigator.routeInformationUpdated(uri: Uri.parse(routeName));
  }

  static const _sampleText =
      'The Agama Platform is engineered as a high-performance local-first zero-backend speed reading system. By executing PDF parsing, vector indexing, and ONNX complexity inference inside an embedded Rust core, the system achieves absolute privacy, zero cloud costs, and instant responsiveness.';

  final List<_Doc> _docs = [
    const _Doc(
      'Zero-Backend SAD Architecture',
      'PDF',
      5100,
      0.65,
      AgamaTheme.indigo,
      'Zero-Backend SAD Architecture. The Agama Platform is engineered as a high-performance local-first zero-backend speed reading system. By executing PDF parsing, vector indexing, and ONNX complexity inference inside an embedded Rust core, the system achieves absolute privacy, zero cloud costs, and instant responsiveness.',
    ),
    const _Doc(
      'Quantum Optics & Photonic Computing',
      'EPUB',
      2450,
      0.30,
      AgamaTheme.emerald,
      'Quantum Optics & Photonic Computing. Photonic quantum information processing uses single photons to encode qubit states. Integrated optical circuits enable high-fidelity quantum logic operations at room temperature.',
    ),
    const _Doc(
      'ONNX Syntactic Complexity Engine',
      'MD',
      1820,
      0.90,
      AgamaTheme.amber,
      'ONNX Syntactic Complexity Engine. Syntactic parsing models analyze sentence structure to calculate cognitive load metrics. Real-time adaptation dynamically adjusts RSVP presentation speed based on syntactic clause depth.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final tabs = [
      _LibraryTab(docs: _docs, sampleText: _sampleText),
      const _KnowledgeTab(),
      const AnalyticsView(),
      const UserSettingsView(),
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
                    color: const Color(0xFFFD761A),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            margin: const EdgeInsets.only(right: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFD761A).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFD761A).withValues(alpha: 0.3)),
            ),
            child: Text(
              '🔥 5-Day Streak · ⚡ 450 WPM',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFFD761A),
              ),
            ),
          ),
          _AppBarBtn(
            icon: isDark ? Icons.wb_sunny_outlined : Icons.dark_mode_outlined,
            tooltip: isDark ? 'Light mode' : 'Dark mode',
            onTap: () {
              themeModeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
            },
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
        indicatorColor: const Color(0xFFFD761A).withValues(alpha: 0.2),
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
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

// ── Hero section with direct file & text input ───────────────────────────────
class _HeroSection extends StatefulWidget {
  final ValueChanged<String>? onTextChanged;
  const _HeroSection({this.onTextChanged});

  @override
  State<_HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<_HeroSection> {
  PlatformFile? _selectedFile;
  final TextEditingController _textController = TextEditingController();
  final FileParserService _parser = FileParserService();

  @override
  void initState() {
    super.initState();
    _textController.addListener(_handleTextChange);
  }

  void _handleTextChange() {
    widget.onTextChanged?.call(_textController.text);
  }

  @override
  void dispose() {
    _textController.removeListener(_handleTextChange);
    _textController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'epub', 'md', 'txt'],
        withData: true,
      );
      if (!mounted) return;

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.single;
        setState(() {
          _selectedFile = file;
        });
        ParsedDocument? parsed;
        if (file.bytes != null) {
          parsed = _parser.parseBytes(file.bytes!, file.name);
        } else if (file.path != null) {
          parsed = await _parser.parseFile(file.path!);
        }
        if (!mounted) return;

        if (parsed != null) {
          _textController.text = parsed.content;
          widget.onTextChanged?.call(parsed.content);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load document: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AgamaTheme.rsvpBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Read faster. Remember more.',
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Agama trains your reading speed using three science-backed methods. '
            'Select a document or paste text below to begin.',
            style: GoogleFonts.inter(
              fontSize: 13,
              height: 1.55,
              color: const Color(0xFF8A93AB),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16),
                side: const BorderSide(color: AgamaTheme.indigo, width: 1.5),
                backgroundColor: AgamaTheme.indigo.withValues(alpha: 0.15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _pickFile,
              icon: const Icon(Icons.upload_file, size: 18, color: Colors.white),
              label: Text(
                _selectedFile != null
                    ? _selectedFile!.name
                    : 'Select PDF, EPUB, or Markdown',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _textController,
            maxLines: 4,
            style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Paste document text here...',
              hintStyle: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF8A93AB),
              ),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.05),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AgamaTheme.indigo,
                ),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tab 0: Library + Engine picker ────────────────────────────────────────
class _LibraryTab extends StatefulWidget {
  final List<_Doc> docs;
  final String sampleText;
  const _LibraryTab({required this.docs, required this.sampleText});

  @override
  State<_LibraryTab> createState() => _LibraryTabState();
}

class _LibraryTabState extends State<_LibraryTab> {
  String _customText = '';

  void _navigate(BuildContext ctx, Widget page) =>
      Navigator.push(ctx, MaterialPageRoute(builder: (_) => page));

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
              _HeroSection(
                onTextChanged: (text) {
                  setState(() => _customText = text);
                },
              ),

              const SizedBox(height: 24),

              // ── Engine chooser with decision guide ───────────────────
              const _SectionLabel('CHOOSE YOUR METHOD'),
              const SizedBox(height: 10),
              _EngineChooser(customText: _customText.trim()),

              const SizedBox(height: 24),

              // ── Document library ─────────────────────────────────────
              const _SectionLabel('YOUR LIBRARY'),
              const SizedBox(height: 10),

              ...widget.docs.map((d) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _DocumentTile(
                  doc: d,
                  onTap: () => _navigate(context, RsvpCanvasView(text: d.content)),
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
  final String customText;
  const _EngineChooser({required this.customText});

  @override
  State<_EngineChooser> createState() => _EngineChooserState();
}

class _EngineChooserState extends State<_EngineChooser> {
  int _selected = 0; // 0=RSVP, 1=Sweep, 2=Bionic
  bool _showInputError = false;

  static const _engines = [
    _EngineInfo(
      label: 'RSVP Redicle',
      icon: Icons.remove_red_eye_outlined,
      accent: Color(0xFFFD761A),
      tagline: '⚡ MAX SPEED — One word at a time in center focus',
      bestFor: 'Articles, reports, anything you want to read quickly.',
      tradeoff: 'Single-word focus stage with ORP highlight.',
      wpmRange: '400–1000+ WPM',
    ),
    _EngineInfo(
      label: 'Guided Sweep',
      icon: Icons.highlight_alt_rounded,
      accent: Color(0xFF10B981),
      tagline: '📖 DEEP STUDY — Full text with moving focus cursor',
      bestFor: 'Complex or technical content where you may re-read.',
      tradeoff: 'Slower than RSVP, but comprehension stays higher.',
      wpmRange: '250–600 WPM',
    ),
    _EngineInfo(
      label: 'Bionic Fixation',
      icon: Icons.format_bold_rounded,
      accent: Color(0xFFF59E0B),
      tagline: '🧠 FOCUS AID — Full text, initial letters bolded',
      bestFor: 'Beginners, or when reading on a small screen.',
      tradeoff: 'Speed gain is modest (~15%). Good habit builder.',
      wpmRange: '200–450 WPM',
    ),
  ];

  void _selectEngine(int index) {
    setState(() {
      _selected = index;
      _showInputError = false;
    });
  }

  void _launch(BuildContext context) {
    if (widget.customText.isEmpty) {
      setState(() => _showInputError = true);
      return;
    }
    setState(() => _showInputError = false);
    final text = widget.customText;
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
                onTap: () => _selectEngine(i),
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
                    Expanded(
                      child: Text(e.tagline,
                        style: theme.textTheme.titleSmall?.copyWith(color: e.accent),
                        overflow: TextOverflow.ellipsis),
                    ),
                    const SizedBox(width: 8),
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
                      backgroundColor: _showInputError ? AgamaTheme.crimson : e.accent,
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9)),
                    ),
                    onPressed: () => _launch(context),
                    icon: const Icon(Icons.play_arrow_rounded, size: 16, color: Colors.white),
                    label: Text(
                      'Start Reading',
                      style: GoogleFonts.inter(
                        fontSize: 13, fontWeight: FontWeight.w600,
                        color: Colors.white)),
                  ),
                ),
                if (_showInputError) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Add text or select a file above first',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AgamaTheme.crimson,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
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

// ── Document data model ───────────────────────────────────────────────────
class _Doc {
  final String title, format;
  final int words;
  final double progress;
  final Color accent;
  final String content;
  const _Doc(this.title, this.format, this.words, this.progress, this.accent, this.content);
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
