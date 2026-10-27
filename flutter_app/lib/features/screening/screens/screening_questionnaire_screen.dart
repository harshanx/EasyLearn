import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../services/screening_service.dart';
import 'screening_result_screen.dart';

class ScreeningQuestionnaireScreen extends ConsumerStatefulWidget {
  final String studentId;
  final String studentName;
  final String? grade;

  const ScreeningQuestionnaireScreen({
    Key? key,
    required this.studentId,
    required this.studentName,
    this.grade,
  }) : super(key: key);

  @override
  ConsumerState<ScreeningQuestionnaireScreen> createState() =>
      _ScreeningQuestionnaireScreenState();
}

class _ScreeningQuestionnaireScreenState
    extends ConsumerState<ScreeningQuestionnaireScreen> {
  // Scores 1-5 for each of the 6 cognitive domains
  final Map<String, double> _scores = {
    'reading_difficulty': 1.0,
    'writing_difficulty': 1.0,
    'math_difficulty': 1.0,
    'attention_difficulty': 1.0,
    'memory_difficulty': 1.0,
    'social_difficulty': 1.0,
  };

  // Observational clinical tags toggle state
  final Map<String, bool> _clinicalTags = {
    'Reverses Letters': false,
    'High Distractibility': false,
    'Finger Counting': false,
    'Verbal Preference': false,
    'Phoneme Confusion': false,
    'Motor Fatigue': false,
  };

  bool _isLoading = false;

  final List<Map<String, String>> _domainConfigs = [
    {
      'key': 'reading_difficulty',
      'title': '1. Reading & Phoneme Challenges',
      'subtitle': 'Observed letter reversals, decoding friction, or oral reading fluency gaps.',
    },
    {
      'key': 'writing_difficulty',
      'title': '2. Writing & Motor Control',
      'subtitle': 'Spatial placement, handwriting legibility, or pencil grip fatigue.',
    },
    {
      'key': 'math_difficulty',
      'title': '3. Math & Numeric Processing',
      'subtitle': 'Symbolic confusion, mental arithmetic computation, or dyscalculia indicators.',
    },
    {
      'key': 'attention_difficulty',
      'title': '4. Attention & Impulse Control',
      'subtitle': 'Sustained task concentration, restlessness, or frequent breaks needed.',
    },
    {
      'key': 'memory_difficulty',
      'title': '5. Working Memory Span',
      'subtitle': 'Multistep instruction retention, sequential recall, or short-term memory.',
    },
    {
      'key': 'social_difficulty',
      'title': '6. Social Communication',
      'subtitle': 'Peer collaboration, pragmatic language, or non-verbal cue reading.',
    },
  ];

  Future<void> _submitScreening() async {
    setState(() => _isLoading = true);
    try {
      final service = ScreeningService();
      final result = await service.predictScreening(
        studentId: widget.studentId,
        features: Map<String, double>.from(_scores),
      );
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (_) => ScreeningResultScreen(
            studentId: widget.studentId,
            studentName: widget.studentName,
            result: result,
            scores: Map<String, double>.from(_scores),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      final isDark = Theme.of(context).brightness == Brightness.dark;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error running screening: ${e.toString()}'),
          backgroundColor: isDark ? const Color(0xFFFFFFFF) : const Color(0xFF0A0A0A),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = isDark ? AppTheme.darkBackground : const Color(0xFFFFFFFF);
    final surface = isDark ? AppTheme.darkSurface : const Color(0xFFF7F7F9);
    final fg = isDark ? const Color(0xFFFFFFFF) : const Color(0xFF0A0A0A);
    final border = isDark ? AppTheme.darkHairline : const Color(0xFFE5E5EA);
    final textMuted = isDark ? AppTheme.ashGray : const Color(0xFF666666);

    return Scaffold(
      backgroundColor: bg,
      appBar: CupertinoNavigationBar(
        backgroundColor: bg.withOpacity(0.9),
        border: Border(bottom: BorderSide(color: border, width: 0.5)),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.back, color: fg),
          onPressed: () => Navigator.pop(context),
        ),
        middle: Text(
          'LIVE SCREENING',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            letterSpacing: 0.5,
            color: fg,
          ),
        ),
        trailing: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: fg,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              widget.studentName.isNotEmpty ? widget.studentName[0].toUpperCase() : 'S',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: bg,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          children: [
            // Student Profile Inset Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: border, width: 0.5),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: fg,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        widget.studentName.isNotEmpty
                            ? widget.studentName.split(' ').map((e) => e[0]).take(2).join()
                            : 'ST',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: bg,
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
                          widget.studentName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: fg,
                          ),
                        ),
                        Text(
                          'ID: ${widget.studentId} • ${widget.grade ?? "Std 4-B"}',
                          style: TextStyle(
                            fontSize: 12,
                            color: textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.darkSurfaceContainer : const Color(0xFFE5E5EA),
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Text(
                      'IN PROGRESS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: fg,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Header Marker
            Text(
              'COGNITIVE DOMAIN RATINGS (1 TO 5 SCALE)',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: textMuted,
              ),
            ),
            const SizedBox(height: 12),

            // Render 6 Domain Question Cards
            ..._domainConfigs.map((domain) {
              final key = domain['key']!;
              final currentVal = _scores[key]!;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: border, width: 0.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      domain['title']!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                        color: fg,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      domain['subtitle']!,
                      style: TextStyle(
                        fontSize: 13,
                        color: textMuted,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Segmented Rating Scale
                    Row(
                      children: List.generate(5, (index) {
                        final val = (index + 1).toDouble();
                        final isSelected = currentVal == val;
                        final isFirst = index == 0;
                        final isLast = index == 4;

                        BorderRadius borderRadius = BorderRadius.zero;
                        if (isFirst) {
                          borderRadius = const BorderRadius.horizontal(left: Radius.circular(8));
                        } else if (isLast) {
                          borderRadius = const BorderRadius.horizontal(right: Radius.circular(8));
                        }

                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() => _scores[key] = val);
                            },
                            child: Container(
                              height: 38,
                              decoration: BoxDecoration(
                                color: isSelected ? fg : bg,
                                borderRadius: borderRadius,
                                border: Border.all(
                                  color: isSelected ? fg : border,
                                  width: 0.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  val.toInt().toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                    color: isSelected ? bg : fg,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              );
            }).toList(),

            const SizedBox(height: 16),

            // Rapid Clinical Tagging Section
            Text(
              'OBSERVATIONAL CLINICAL TAGS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: textMuted,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: border, width: 0.5),
              ),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 12.0,
                children: _clinicalTags.keys.map((tag) {
                  final isSelected = _clinicalTags[tag]!;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _clinicalTags[tag] = !isSelected);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? fg : bg,
                        borderRadius: BorderRadius.circular(9999),
                        border: Border.all(
                          color: isSelected ? fg : border,
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isSelected)
                            Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Icon(CupertinoIcons.checkmark_alt, size: 14, color: bg),
                            ),
                          Text(
                            tag,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? bg : fg,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 32),

            // Submit Button
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CupertinoActivityIndicator(),
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                height: 52,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  color: fg,
                  borderRadius: BorderRadius.circular(9999),
                  onPressed: _submitScreening,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9999),
                      border: Border.all(color: fg, width: 1),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Run Cognitive Model',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: bg,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(CupertinoIcons.sparkles, size: 16, color: bg),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
