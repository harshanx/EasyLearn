import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
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
        MaterialPageRoute(
          builder: (_) => ScreeningResultScreen(
            studentName: widget.studentName,
            result: result,
            scores: Map<String, double>.from(_scores),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error running screening: ${e.toString()}'),
          backgroundColor: AppTheme.pitchBlack,
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBackground : AppTheme.offWhiteSurface,
      appBar: AppBar(
        backgroundColor: (isDark ? AppTheme.darkBackground : AppTheme.offWhiteSurface).withOpacity(0.9),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.chevron_back, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Live Screening Session',
          style: GoogleFonts.manrope(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: isDark ? AppTheme.pureWhite : AppTheme.pitchBlack,
              child: Text(
                widget.studentName.isNotEmpty ? widget.studentName[0].toUpperCase() : 'S',
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppTheme.pitchBlack : AppTheme.pureWhite,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student Profile Inset Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkSurface : AppTheme.pureWhite,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppTheme.darkHairline : AppTheme.paleHairline,
                  width: 0.5,
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: isDark ? AppTheme.pureWhite : AppTheme.pitchBlack,
                    child: Text(
                      widget.studentName.isNotEmpty
                          ? widget.studentName.split(' ').map((e) => e[0]).take(2).join()
                          : 'ST',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppTheme.pitchBlack : AppTheme.pureWhite,
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
                          style: GoogleFonts.manrope(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          'ID: ${widget.studentId} • ${widget.grade ?? "Std 4-B"}',
                          style: GoogleFonts.hankenGrotesk(
                            fontSize: 12,
                            color: AppTheme.slateGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.darkSurfaceContainer : AppTheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Text(
                      'IN PROGRESS',
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Header Marker
            Text(
              'COGNITIVE DOMAIN RATINGS (1 TO 5 SCALE)',
              style: GoogleFonts.hankenGrotesk(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: AppTheme.slateGray,
              ),
            ),
            const SizedBox(height: 12),

            // Render 6 Domain Question Cards
            ..._domainConfigs.map((domain) {
              final key = domain['key']!;
              final currentVal = _scores[key]!;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.darkSurface : AppTheme.pureWhite,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? AppTheme.darkHairline : AppTheme.paleHairline,
                    width: 0.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      domain['title']!,
                      style: GoogleFonts.manrope(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      domain['subtitle']!,
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 13,
                        color: AppTheme.slateGray,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Likert 5-Segmented Rating Control
                    Row(
                      children: List.generate(5, (index) {
                        final scoreVal = (index + 1).toDouble();
                        final isSelected = currentVal == scoreVal;
                        final labels = ['1 Never', '2 Rare', '3 Sometimes', '4 Often', '5 Always'];

                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _scores[key] = scoreVal;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              margin: EdgeInsets.only(right: index < 4 ? 6 : 0),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? (isDark ? AppTheme.pureWhite : AppTheme.pitchBlack)
                                    : (isDark ? AppTheme.darkSurfaceContainer : AppTheme.surfaceContainerLow),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${index + 1}',
                                    style: GoogleFonts.hankenGrotesk(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: isSelected
                                          ? (isDark ? AppTheme.pitchBlack : AppTheme.pureWhite)
                                          : theme.colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    labels[index].split(' ').last,
                                    style: GoogleFonts.hankenGrotesk(
                                      fontSize: 9,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                      color: isSelected
                                          ? (isDark ? AppTheme.pitchBlack : AppTheme.pureWhite).withOpacity(0.85)
                                          : AppTheme.slateGray,
                                    ),
                                  ),
                                ],
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

            const SizedBox(height: 8),
            // Observational Clinical Tags Section
            Text(
              'OBSERVATIONAL CLINICAL TAGS',
              style: GoogleFonts.hankenGrotesk(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: AppTheme.slateGray,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _clinicalTags.keys.map((tag) {
                final active = _clinicalTags[tag]!;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _clinicalTags[tag] = !active;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: active
                          ? (isDark ? AppTheme.pureWhite : AppTheme.pitchBlack)
                          : (isDark ? AppTheme.darkSurface : AppTheme.pureWhite),
                      borderRadius: BorderRadius.circular(9999),
                      border: Border.all(
                        color: active
                            ? (isDark ? AppTheme.pureWhite : AppTheme.pitchBlack)
                            : (isDark ? AppTheme.darkHairline : AppTheme.paleHairline),
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          active ? CupertinoIcons.checkmark_alt : CupertinoIcons.add,
                          size: 14,
                          color: active
                              ? (isDark ? AppTheme.pitchBlack : AppTheme.pureWhite)
                              : theme.colorScheme.onSurface,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          tag,
                          style: GoogleFonts.hankenGrotesk(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: active
                                ? (isDark ? AppTheme.pitchBlack : AppTheme.pureWhite)
                                : theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitScreening,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? AppTheme.pureWhite : AppTheme.pitchBlack,
                  foregroundColor: isDark ? AppTheme.pitchBlack : AppTheme.pureWhite,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
                child: _isLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CupertinoActivityIndicator(
                            color: isDark ? AppTheme.pitchBlack : AppTheme.pureWhite,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Processing Evaluation...',
                            style: GoogleFonts.hankenGrotesk(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Run Explainable AI Assessment',
                            style: GoogleFonts.hankenGrotesk(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(CupertinoIcons.arrow_right, size: 18),
                        ],
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
