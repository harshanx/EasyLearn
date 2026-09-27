import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import '../../../core/theme/app_theme.dart';
import '../../../services/intervention_service.dart';

class ScreeningResultScreen extends StatefulWidget {
  final String studentName;
  final Map<String, dynamic> result;
  final Map<String, double> scores;

  const ScreeningResultScreen({
    Key? key,
    required this.studentName,
    required this.result,
    required this.scores,
  }) : super(key: key);

  @override
  State<ScreeningResultScreen> createState() => _ScreeningResultScreenState();
}

class _ScreeningResultScreenState extends State<ScreeningResultScreen> {
  List<dynamic> _recommendations = [];
  bool _isLoadingInterventions = false;

  @override
  void initState() {
    super.initState();
    _fetchRecommendations();
  }

  Future<void> _fetchRecommendations() async {
    final topFeats = _topFeatures;
    if (topFeats.isEmpty) return;

    setState(() => _isLoadingInterventions = true);
    try {
      final service = InterventionService();
      final recsMap = await service.getRecommendations(
        studentAge: 9,
        studentGrade: '4',
        topFeatures: topFeats,
        riskLevel: _riskLevel,
      );
      final recs = (recsMap['recommendations'] as List?) ?? [];
      if (mounted) {
        setState(() {
          _recommendations = recs;
          _isLoadingInterventions = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoadingInterventions = false);
    }

  }

  String get _riskLevel =>
      (widget.result['risk_level'] ?? 'Moderate').toString();

  double get _probability =>
      (widget.result['model_probability'] as num?)?.toDouble() ?? 0.85;

  Map<String, double> get _shapValues {
    final raw = widget.result['shap_explanation'] ?? widget.result['shap_values'];
    if (raw == null) return {};
    Map<String, dynamic> map;
    if (raw is String) {
      try {
        map = json.decode(raw) as Map<String, dynamic>;
      } catch (_) {
        return {};
      }
    } else {
      map = raw as Map<String, dynamic>;
    }
    return map.map((k, v) => MapEntry(k, (v as num).toDouble()));
  }

  Map<String, double> get _classProbabilities {
    final raw = widget.result['class_probabilities'];
    if (raw == null) {
      return {'None': 0.05, 'Mild': 0.12, 'Moderate': 0.18, 'Elevated': 0.65};
    }
    if (raw is String) {
      try {
        final parsed = json.decode(raw) as Map<String, dynamic>;
        return parsed.map((k, v) => MapEntry(k, (v as num).toDouble()));
      } catch (_) {
        return {'None': 0.05, 'Mild': 0.12, 'Moderate': 0.18, 'Elevated': 0.65};
      }
    }
    return (raw as Map<String, dynamic>).map((k, v) => MapEntry(k, (v as num).toDouble()));
  }

  List<String> get _topFeatures {
    final raw = widget.result['top_features'];
    if (raw is List) {
      return raw.map((e) => e.toString()).toList();
    }
    final sorted = _shapValues.entries.toList()
      ..sort((a, b) => b.value.abs().compareTo(a.value.abs()));
    return sorted.take(3).map((e) => e.key).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final shap = _shapValues;
    final classProbs = _classProbabilities;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBackground : AppTheme.offWhiteSurface,
      appBar: AppBar(
        backgroundColor: (isDark ? AppTheme.darkBackground : AppTheme.offWhiteSurface).withOpacity(0.9),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.chevron_back, size: 22),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Explainability Audit Report',
          style: GoogleFonts.manrope(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.share, size: 20),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Exporting Report PDF...'),
                  backgroundColor: AppTheme.pitchBlack,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Context Header
            Text(
              'COGNITIVE DIAGNOSTICS & XAI AUDIT',
              style: GoogleFonts.hankenGrotesk(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: AppTheme.slateGray,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Assessment Report',
              style: GoogleFonts.manrope(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),

            // Hero Student Risk Card
            Container(
              padding: const EdgeInsets.all(20),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.studentName,
                            style: GoogleFonts.manrope(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Standard 4-B • Screened ${DateTime.now().year}',
                            style: GoogleFonts.hankenGrotesk(
                              fontSize: 13,
                              color: AppTheme.slateGray,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDark ? AppTheme.darkSurfaceContainer : AppTheme.surfaceContainerLow,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          CupertinoIcons.checkmark_shield_fill,
                          size: 20,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      AppTheme.buildRiskBadge(_riskLevel),
                      const SizedBox(width: 12),
                      Text(
                        '${(_probability * 100).toStringAsFixed(1)}% Confidence',
                        style: GoogleFonts.hankenGrotesk(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.slateGray,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Class Probabilities Segmented Bar Card
            Container(
              padding: const EdgeInsets.all(20),
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
                    'PREDICTED RISK PROBABILITY DISTRIBUTION',
                    style: GoogleFonts.hankenGrotesk(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                      color: AppTheme.slateGray,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Cohort Model Classification',
                    style: GoogleFonts.manrope(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Horizontal Segmented Probability Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(9999),
                    child: Container(
                      height: 28,
                      color: isDark ? AppTheme.darkSurfaceContainer : AppTheme.surfaceContainerHigh,
                      child: Row(
                        children: [
                          _probSegment(classProbs['None'] ?? 0.05, AppTheme.pureWhite, AppTheme.pitchBlack, 'None'),
                          _probSegment(classProbs['Mild'] ?? 0.12, AppTheme.surfaceContainerHighest, AppTheme.pitchBlack, 'Mild'),
                          _probSegment(classProbs['Moderate'] ?? 0.18, AppTheme.slateGray, AppTheme.pureWhite, 'Mod'),
                          _probSegment(classProbs['Elevated'] ?? 0.65, AppTheme.pitchBlack, AppTheme.pureWhite, 'Elevated'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Legend Ticks
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _legendTick('None', classProbs['None'] ?? 0.05, isDark),
                      _legendTick('Mild', classProbs['Mild'] ?? 0.12, isDark),
                      _legendTick('Moderate', classProbs['Moderate'] ?? 0.18, isDark),
                      _legendTick('Elevated', classProbs['Elevated'] ?? 0.65, isDark),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // SHAP Feature Attribution Waterfall Analysis
            if (shap.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(20),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'OBSERVED RISK CONTRIBUTORS',
                          style: GoogleFonts.hankenGrotesk(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                            color: AppTheme.slateGray,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: isDark ? AppTheme.darkSurfaceContainer : AppTheme.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: Text(
                            'SHAP Values',
                            style: GoogleFonts.hankenGrotesk(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rightward bars amplify risk priority; leftward indicates resilient compensation.',
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 12,
                        color: AppTheme.slateGray,
                      ),
                    ),
                    const SizedBox(height: 16),

                    ..._buildShapDivergingBars(shap, theme, isDark),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Clinical Synthesis Card
            Container(
              padding: const EdgeInsets.all(20),
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
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isDark ? AppTheme.pureWhite : AppTheme.pitchBlack,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          CupertinoIcons.sparkles,
                          size: 14,
                          color: isDark ? AppTheme.pitchBlack : AppTheme.pureWhite,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Clinical Synthesis',
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.darkSurfaceContainer : AppTheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      '“The model detected notable friction in phoneme segmentation and short-term sequential recall, while visual-spatial problem solving remains at an age-appropriate baseline.”',
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 14,
                        height: 1.45,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Recommended Interventions Section
            Text(
              'RECOMMENDED CLINICAL INTERVENTIONS',
              style: GoogleFonts.hankenGrotesk(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: AppTheme.slateGray,
              ),
            ),
            const SizedBox(height: 10),

            if (_isLoadingInterventions)
              const Center(child: Padding(padding: EdgeInsets.all(20), child: CupertinoActivityIndicator()))
            else if (_recommendations.isNotEmpty)
              ..._recommendations.map((rec) {
                final item = rec['intervention'] ?? rec;
                final title = item['title'] ?? 'Intervention';
                final desc = item['description'] ?? 'Targeted clinical activity.';


                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
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
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isDark ? AppTheme.darkSurfaceContainer : AppTheme.surfaceContainerLow,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          CupertinoIcons.lightbulb_fill,
                          size: 18,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: GoogleFonts.manrope(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              desc,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.hankenGrotesk(
                                fontSize: 12,
                                color: AppTheme.slateGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(CupertinoIcons.chevron_right, size: 16, color: AppTheme.ashGray),
                    ],
                  ),
                );
              }).toList()
            else
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
                    const Icon(CupertinoIcons.info_circle, size: 18, color: AppTheme.slateGray),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Interventions available: Phonics Flash Cards, Sight Word Bingo, Memory Card Game.',
                        style: GoogleFonts.hankenGrotesk(fontSize: 13, color: AppTheme.slateGray),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 28),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.onSurface,
                      side: BorderSide(
                        color: isDark ? AppTheme.darkHairline : AppTheme.paleHairline,
                        width: 0.5,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      'Done',
                      style: GoogleFonts.hankenGrotesk(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _probSegment(double weight, Color bg, Color fg, String label) {
    if (weight <= 0) return const SizedBox.shrink();
    return Expanded(
      flex: (weight * 100).round().clamp(1, 100),
      child: Container(
        height: double.infinity,
        color: bg,
        child: Center(
          child: Text(
            '${(weight * 100).round()}%',
            style: GoogleFonts.hankenGrotesk(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ),
      ),
    );
  }

  Widget _legendTick(String name, double val, bool isDark) {
    return Column(
      children: [
        Text(
          name,
          style: GoogleFonts.hankenGrotesk(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppTheme.slateGray,
          ),
        ),
        Text(
          '${(val * 100).round()}%',
          style: GoogleFonts.hankenGrotesk(
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildShapDivergingBars(
      Map<String, double> shap, ThemeData theme, bool isDark) {
    final sorted = shap.entries.toList()
      ..sort((a, b) => b.value.abs().compareTo(a.value.abs()));
    final maxAbs =
        sorted.isEmpty ? 1.0 : sorted.first.value.abs().clamp(0.001, double.infinity);

    return sorted.map((e) {
      final name = e.key.replaceAll('_', ' ').replaceAll('difficulty', '').trim().toUpperCase();
      final val = e.value;
      final isPositive = val >= 0;
      final pctFactor = (val.abs() / maxAbs).clamp(0.1, 1.0);

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: GoogleFonts.hankenGrotesk(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  '${isPositive ? '+' : ''}${val.toStringAsFixed(2)} SHAP',
                  style: GoogleFonts.hankenGrotesk(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isPositive ? theme.colorScheme.onSurface : AppTheme.slateGray,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Stack(
              children: [
                Container(
                  height: 10,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.darkSurfaceContainer : AppTheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 1,
                      color: isDark ? AppTheme.darkHairline : AppTheme.paleHairline,
                    ),
                  ),
                ),
                // Bar
                Positioned.fill(
                  child: Align(
                    alignment: isPositive ? Alignment.centerLeft : Alignment.centerRight,
                    child: FractionallySizedBox(
                      widthFactor: 0.5 * pctFactor,
                      child: Container(
                        height: 10,
                        decoration: BoxDecoration(
                          color: isPositive
                              ? (isDark ? AppTheme.pureWhite : AppTheme.pitchBlack)
                              : AppTheme.ashGray,
                          borderRadius: BorderRadius.circular(9999),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }).toList();
  }
}
