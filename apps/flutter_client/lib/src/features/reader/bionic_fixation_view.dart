import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/theme.dart';

class BionicFixationView extends StatefulWidget {
  final String text;
  const BionicFixationView({super.key, required this.text});

  @override
  State<BionicFixationView> createState() => _BionicFixationViewState();
}

class _BionicFixationViewState extends State<BionicFixationView> {
  int _level = 3;
  double _fontSize = 18;

  ({String bold, String light}) _split(String word) {
    final len = word.length;
    if (len == 0) return (bold: '', light: '');
    final ratio = switch (_level.clamp(1, 5)) {
      1 => 0.30,
      2 => 0.40,
      3 => 0.50,
      4 => 0.60,
      5 => 0.70,
      _ => 0.50,
    };
    final n = ((len * ratio).ceil()).clamp(1, len);
    return (bold: word.substring(0, n), light: word.substring(n));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final words =
        widget.text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Bionic Fixation', style: theme.textTheme.titleMedium),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AgamaTheme.amber.withAlpha(15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AgamaTheme.amber.withAlpha(40)),
            ),
            child: Text(
              'F$_level',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AgamaTheme.amber,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Reading surface
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 680),
                    child: Wrap(
                      spacing: 5,
                      runSpacing: 8,
                      children: words.map((w) {
                        final p = _split(w);
                        return RichText(
                          text: TextSpan(
                            style: GoogleFonts.inter(
                              fontSize: _fontSize,
                              height: 1.65,
                            ),
                            children: [
                              TextSpan(
                                text: p.bold,
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              TextSpan(
                                text: p.light,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color:
                                      theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),

            // Controls
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border:
                    Border(top: BorderSide(color: theme.colorScheme.outline)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fixation level
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Fixation intensity',
                          style: theme.textTheme.labelMedium),
                      Text('Level F$_level',
                          style: theme.textTheme.labelSmall),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(5, (i) {
                      final l = i + 1;
                      final sel = _level == l;
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: i < 4 ? 6 : 0),
                          child: GestureDetector(
                            onTap: () => setState(() => _level = l),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 120),
                              height: 36,
                              decoration: BoxDecoration(
                                color: sel
                                    ? AgamaTheme.amber
                                    : theme.colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: sel
                                      ? AgamaTheme.amber
                                      : theme.colorScheme.outline,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'F$l',
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: sel
                                        ? Colors.white
                                        : theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 14),

                  // Font size slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Text size', style: theme.textTheme.labelMedium),
                      Text('${_fontSize.toInt()}pt',
                          style: theme.textTheme.labelSmall),
                    ],
                  ),
                  Slider(
                    value: _fontSize,
                    min: 14,
                    max: 28,
                    divisions: 7,
                    activeColor: AgamaTheme.amber,
                    inactiveColor: theme.colorScheme.outline,
                    onChanged: (v) => setState(() => _fontSize = v),
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
