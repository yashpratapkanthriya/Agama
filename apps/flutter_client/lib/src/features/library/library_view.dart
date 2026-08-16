import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import '../../app/app.dart';
import '../../app/theme.dart';
import '../reader/rsvp_canvas.dart';
import '../annotations/annotation_view.dart';
import '../flashcards/flashcard_view.dart';
import '../flashcards/deck_manager_view.dart';
import '../knowledge/ai_chat_view.dart';
import '../analytics/analytics_view.dart';
import '../settings/user_settings_view.dart';
import '../settings/keyboard_shortcuts_view.dart';
import '../../core/command_palette.dart';
import '../home/home_tab_view.dart';
import 'file_parser_service.dart';
import 'document_detail_view.dart';
import 'document_processing_modal.dart';
import 'url_import_service.dart';
import 'document_repository.dart';

// ── Root scaffold with persistent 5-tab navigation ───────────────────────────
class LibraryView extends ConsumerStatefulWidget {
  final int initialTab;
  const LibraryView({super.key, this.initialTab = 0});

  @override
  ConsumerState<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends ConsumerState<LibraryView> {
  late int _tab;

  @override
  void initState() {
    super.initState();
    final uri = Uri.base;
    final path = uri.path;
    final fragment = uri.fragment;

    if (path.contains('library') || fragment.contains('library')) {
      _tab = 1;
    } else if (path.contains('knowledge') || fragment.contains('knowledge')) {
      _tab = 2;
    } else if (path.contains('analytics') || fragment.contains('analytics')) {
      _tab = 3;
    } else if (path.contains('settings') || fragment.contains('settings')) {
      _tab = 4;
    } else {
      _tab = widget.initialTab;
    }
  }

  void _onTabSelected(int i) {
    setState(() => _tab = i);
    final routeName = switch (i) {
      0 => '/home',
      1 => '/library',
      2 => '/knowledge',
      3 => '/analytics',
      4 => '/settings',
      _ => '/home',
    };
    SystemNavigator.routeInformationUpdated(uri: Uri.parse(routeName));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final tabs = [
      HomeTabView(onNavigateToTab: _onTabSelected),
      const _LibraryTab(),
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
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AgamaTheme.rsvpBg,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Center(
                child: Text(
                  'A',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFFD761A),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 9),
            Text(
              'Agama',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
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
              '🔥 7-Day Streak · ⚡ 520 WPM',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFFD761A),
              ),
            ),
          ),
          _AppBarBtn(
            icon: Icons.search_rounded,
            tooltip: 'Command Palette (⌘K)',
            onTap: () async {
              final result = await showDialog<String>(
                context: context,
                builder: (_) => const CommandPaletteModal(),
              );
              if (result != null && result == 'View Keyboard Shortcuts' && context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const KeyboardShortcutsView()),
                );
              }
            },
          ),
          _AppBarBtn(
            icon: Icons.keyboard_outlined,
            tooltip: 'Keyboard Shortcuts',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const KeyboardShortcutsView()),
              );
            },
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
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book_rounded),
            label: 'Library',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmarks_outlined),
            selectedIcon: Icon(Icons.bookmarks_rounded),
            label: 'Knowledge',
          ),
          NavigationDestination(
            icon: Icon(Icons.query_stats_outlined),
            selectedIcon: Icon(Icons.query_stats_rounded),
            label: 'Analytics',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

// ── Tab 1: Library (All Documents, Grid & List View, Import) ───────────────
class _LibraryTab extends ConsumerStatefulWidget {
  const _LibraryTab();

  @override
  ConsumerState<_LibraryTab> createState() => _LibraryTabState();
}

class _LibraryTabState extends ConsumerState<_LibraryTab> {
  final TextEditingController _searchController = TextEditingController();
  final FileParserService _parser = FileParserService();
  bool _isGridView = true;
  String _searchQuery = '';
  String _selectedFormatFilter = 'ALL';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _importUrl() async {
    final controller = TextEditingController();
    final url = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Import Web Page / Article'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'https://example.com/article',
            labelText: 'Web Article URL',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: const Text('Import'),
          ),
        ],
      ),
    );

    if (url == null || url.trim().isEmpty || !mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);
    final rootNav = Navigator.of(context, rootNavigator: true);

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const DocumentProcessingModal(
          title: 'Fetching Article...',
          currentStep: 'Downloading and extracting text structure...',
          progress: 0.5,
        ),
      );

      final parsed = await UrlImportService.instance.fetchAndParseUrl(url);
      rootNav.pop();

      final words = parsed.content.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
      final newDoc = DocumentItem(
        id: 'doc-${DateTime.now().millisecondsSinceEpoch}',
        title: parsed.title.isNotEmpty ? parsed.title : 'Web Article',
        format: 'WEB',
        wordCount: words,
        progress: 0.0,
        lastReadAt: DateTime.now(),
        colorValue: AgamaTheme.indigo.toARGB32(),
        content: parsed.content,
      );

      ref.read(documentListProvider.notifier).addDocument(newDoc);

      final result = await nav.push(
        MaterialPageRoute(
          builder: (_) => DocumentDetailView(
            documentTitle: parsed.title,
            content: parsed.content,
          ),
        ),
      );

      if (result != null && result is String) {
        nav.push(
          MaterialPageRoute(
            builder: (_) => RsvpCanvasView(text: result),
          ),
        );
      }
    } catch (e) {
      rootNav.pop();
      messenger.showSnackBar(
        SnackBar(content: Text('Failed to import URL: $e')),
      );
    }
  }

  Future<void> _pickFile() async {
    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);

    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'epub', 'md', 'txt'],
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.single;
        ParsedDocument? parsed;
        if (file.bytes != null) {
          parsed = _parser.parseBytes(file.bytes!, file.name);
        } else if (file.path != null) {
          parsed = await _parser.parseFile(file.path!);
        }

        if (parsed != null) {
          final words = parsed.content.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
          final ext = file.extension?.toUpperCase() ?? 'DOC';
          final newDoc = DocumentItem(
            id: 'doc-${DateTime.now().millisecondsSinceEpoch}',
            title: parsed.title.isNotEmpty ? parsed.title : file.name,
            format: ext,
            wordCount: words,
            progress: 0.0,
            lastReadAt: DateTime.now(),
            colorValue: switch (ext) {
              'PDF' => AgamaTheme.indigo.toARGB32(),
              'EPUB' => AgamaTheme.emerald.toARGB32(),
              'MD' => AgamaTheme.amber.toARGB32(),
              _ => const Color(0xFFFD761A).toARGB32(),
            },
            content: parsed.content,
          );

          ref.read(documentListProvider.notifier).addDocument(newDoc);

          final detailResult = await nav.push(
            MaterialPageRoute(
              builder: (_) => DocumentDetailView(
                documentTitle: parsed!.title,
                content: parsed.content,
              ),
            ),
          );
          if (detailResult != null && detailResult is String) {
            nav.push(
              MaterialPageRoute(
                builder: (_) => RsvpCanvasView(text: detailResult),
              ),
            );
          }
        }
      }
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Failed to load document: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final allDocs = ref.watch(documentListProvider);

    final filteredDocs = allDocs.where((d) {
      final matchesSearch = _searchQuery.isEmpty ||
          d.title.toLowerCase().contains(_searchQuery) ||
          d.format.toLowerCase().contains(_searchQuery);
      final matchesFormat = _selectedFormatFilter == 'ALL' || d.format == _selectedFormatFilter;
      return matchesSearch && matchesFormat;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Library Header & Action Toolbar ──────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _SectionLabel('ALL DOCUMENTS'),
                      const SizedBox(height: 4),
                      Text(
                        '${allDocs.length} documents in local storage',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          side: BorderSide(color: theme.colorScheme.outline),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _importUrl,
                        icon: const Icon(Icons.link, size: 14),
                        label: Text(
                          'Import URL',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFFD761A),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _pickFile,
                        icon: const Icon(Icons.upload_file, size: 15),
                        label: Text(
                          'Import Document',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ── Search Bar + Format Filter + Grid/List Switcher ──────────
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF161B2E) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.colorScheme.outline),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, size: 18, color: theme.colorScheme.onSurfaceVariant),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: GoogleFonts.inter(fontSize: 13),
                        decoration: InputDecoration(
                          hintText: 'Search documents by title or format...',
                          hintStyle: GoogleFonts.inter(
                            fontSize: 13,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    if (_searchQuery.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear, size: 16),
                        onPressed: () => _searchController.clear(),
                      ),
                    const SizedBox(width: 8),
                    // Format filter chips
                    Wrap(
                      spacing: 4,
                      children: ['ALL', 'PDF', 'EPUB', 'MD'].map((fmt) {
                        final isSel = _selectedFormatFilter == fmt;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedFormatFilter = fmt),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isSel
                                  ? const Color(0xFFFD761A).withValues(alpha: 0.15)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: isSel ? const Color(0xFFFD761A) : theme.colorScheme.outline,
                              ),
                            ),
                            child: Text(
                              fmt,
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: isSel
                                    ? const Color(0xFFFD761A)
                                    : theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(width: 8),
                    Container(width: 1, height: 20, color: theme.colorScheme.outline),
                    const SizedBox(width: 8),
                    // Grid / List Toggle
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0F1322) : const Color(0xFFEAEFF8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.grid_view_rounded,
                              size: 16,
                              color: _isGridView
                                  ? const Color(0xFFFD761A)
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                            tooltip: 'Grid View',
                            padding: const EdgeInsets.all(6),
                            constraints: const BoxConstraints(),
                            onPressed: () => setState(() => _isGridView = true),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.view_list_rounded,
                              size: 18,
                              color: !_isGridView
                                  ? const Color(0xFFFD761A)
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                            tooltip: 'List View',
                            padding: const EdgeInsets.all(6),
                            constraints: const BoxConstraints(),
                            onPressed: () => setState(() => _isGridView = false),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Document Display (Grid or List) ──────────────────────────
              if (filteredDocs.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF161B2E) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.colorScheme.outline),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.folder_open_rounded,
                          size: 48, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
                      const SizedBox(height: 12),
                      Text(
                        'No matching documents found',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Import a PDF, EPUB, Markdown, or Web URL above.',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                )
              else if (_isGridView)
                LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = constraints.maxWidth > 650 ? 3 : 2;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredDocs.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.15,
                      ),
                      itemBuilder: (context, index) {
                        final doc = filteredDocs[index];
                        return _DocumentGridCard(
                          doc: doc,
                          onTap: () => _openDoc(doc),
                          onDelete: () => ref.read(documentListProvider.notifier).removeDocument(doc.id),
                        );
                      },
                    );
                  },
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredDocs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final doc = filteredDocs[index];
                    return _DocumentTile(
                      doc: doc,
                      onTap: () => _openDoc(doc),
                      onDelete: () => ref.read(documentListProvider.notifier).removeDocument(doc.id),
                    );
                  },
                ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _openDoc(DocumentItem doc) async {
    final nav = Navigator.of(context);
    final result = await nav.push(
      MaterialPageRoute(
        builder: (_) => DocumentDetailView(
          documentTitle: doc.title,
          content: doc.content,
        ),
      ),
    );
    if (result != null && result is String) {
      nav.push(
        MaterialPageRoute(
          builder: (_) => RsvpCanvasView(text: result),
        ),
      );
    }
  }
}

// ── Document Grid Card ───────────────────────────────────────────────────────
class _DocumentGridCard extends StatelessWidget {
  final DocumentItem doc;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _DocumentGridCard({
    required this.doc,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final pct = (doc.progress * 100).toInt();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF161B2E) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.outline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: doc.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    doc.format,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: doc.color,
                    ),
                  ),
                ),
                const Spacer(),
                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.more_vert, size: 16, color: theme.colorScheme.onSurfaceVariant),
                  onSelected: (val) {
                    if (val == 'delete') onDelete();
                  },
                  itemBuilder: (ctx) => [
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, size: 16, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Remove from Library', style: TextStyle(color: Colors.red, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Text(
              doc.title,
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '${doc.wordCount} words',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: doc.progress,
                      minHeight: 4,
                      backgroundColor: doc.color.withValues(alpha: 0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(doc.color),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$pct%',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: doc.color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Document List Tile ───────────────────────────────────────────────────────
class _DocumentTile extends StatelessWidget {
  final DocumentItem doc;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const _DocumentTile({
    required this.doc,
    required this.onTap,
    this.onDelete,
  });

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
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: doc.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  doc.format,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: doc.color,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doc.title,
                    style: theme.textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text('${doc.wordCount} words', style: theme.textTheme.bodySmall),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: LinearProgressIndicator(
                            value: doc.progress,
                            minHeight: 3,
                            backgroundColor: doc.color.withValues(alpha: 0.2),
                            valueColor: AlwaysStoppedAnimation<Color>(doc.color),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$pct%',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: doc.color,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Icon(Icons.chevron_right_rounded, size: 18, color: theme.colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

// ── Tab 2: Knowledge (Highlights + Flashcards + AI Assistant) ─────────────
class _KnowledgeTab extends StatelessWidget {
  const _KnowledgeTab();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const _SectionLabel('KNOWLEDGE TOOLS'),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          side: BorderSide(color: theme.colorScheme.outline),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const DeckManagerView()),
                          );
                        },
                        icon: const Icon(Icons.style_outlined, size: 14),
                        label: Text(
                          'Manage Decks',
                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(width: 8),
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
                            MaterialPageRoute(
                                builder: (_) => const AnnotationView(showCreateOnLaunch: true)),
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
              Text(
                'Save highlights, ask questions with local AI, and train your memory with spaced repetition.',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 20),
              _KnowledgeTile(
                icon: Icons.chat_bubble_outline_rounded,
                accent: const Color(0xFFFD761A),
                title: 'AI Document Assistant',
                subtitle: 'Local-first RAG chat · zero cloud calls · 384-dim search',
                detail: 'Ask questions about your loaded documents and passages.',
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => const AiChatView()));
                },
              ),
              const SizedBox(height: 10),
              _KnowledgeTile(
                icon: Icons.bookmarks_outlined,
                accent: AgamaTheme.indigo,
                title: 'Highlights & Notes',
                subtitle: 'Save passages · search by meaning (384-dim vectors)',
                detail: 'Tap any highlighted passage to jump back to its context.',
                onTap: () {
                  SystemNavigator.routeInformationUpdated(uri: Uri.parse('/highlights'));
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => const AnnotationView()));
                },
              ),
              const SizedBox(height: 10),
              _KnowledgeTile(
                icon: Icons.psychology_outlined,
                accent: AgamaTheme.emerald,
                title: 'Flashcard Trainer',
                subtitle: 'SM-2 spaced repetition · rate each card 0–5',
                detail: 'Cards you find hard appear more often. Easy ones space out.',
                onTap: () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => const FlashcardView())),
              ),
              const SizedBox(height: 10),
              _KnowledgeTile(
                icon: Icons.style_outlined,
                accent: AgamaTheme.amber,
                title: 'Flashcard Decks Manager',
                subtitle: 'Create and organize custom study decks',
                detail: 'Manage decks, add cards, and launch focused review sessions.',
                onTap: () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => const DeckManagerView())),
              ),
            ],
          ),
        ),
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
    required this.icon,
    required this.accent,
    required this.title,
    required this.subtitle,
    required this.detail,
    required this.onTap,
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
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: accent, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleSmall),
                  const SizedBox(height: 3),
                  Text(subtitle, style: theme.textTheme.bodySmall),
                  const SizedBox(height: 6),
                  Text(
                    detail,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, size: 18, color: theme.colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

// ── App bar button ─────────────────────────────────────────────────────────
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
    return Text(
      text,
      style: GoogleFonts.jetBrainsMono(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
        color: AgamaTheme.inkFaint,
      ),
    );
  }
}

// ── Live latency pulse ────────────────────────────────────────────────────
class _LivePulse extends StatefulWidget {
  @override
  State<_LivePulse> createState() => _LivePulseState();
}

class _LivePulseState extends State<_LivePulse> with SingleTickerProviderStateMixin {
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _anim,
          builder: (_, __) => Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AgamaTheme.emerald
                  .withValues(alpha: _anim.value * 0.5 + 0.5),
            ),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          'local',
          style: GoogleFonts.jetBrainsMono(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AgamaTheme.emerald,
          ),
        ),
      ],
    );
  }
}
