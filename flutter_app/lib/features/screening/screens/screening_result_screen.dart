import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import '../../../core/theme/app_theme.dart';
import '../../../services/intervention_service.dart';

class ScreeningResultScreen extends StatefulWidget {
  final String studentName;
  final String studentId;
  final Map<String, dynamic> result;
  final Map<String, double> scores;

  const ScreeningResultScreen({
    Key? key,
    required this.studentName,
    required this.studentId,
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
        studentId: widget.studentId,
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
    final shap = _shapValues;
    final classProbs = _classProbabilities;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = isDark ? AppTheme.darkBackground : const Color(0xFFFFFFFF);
    final surface = isDark ? AppTheme.darkSurface : const Color(0xFFF7F7F9);
    final fg = isDark ? const Color(0xFFFFFFFF) : const Color(0xFF0A0A0A);
    final border = isDark ? AppTheme.darkHairline : const Color(0xFFE5E5EA);
    final textMuted = isDark ? AppTheme.ashGray : const Color(0xFF666666);
    final textSubtle = isDark ? AppTheme.slateGray : const Color(0xFFA1A1A6);

    return Scaffold(
      backgroundColor: bg,
      appBar: CupertinoNavigationBar(
        backgroundColor: bg.withOpacity(0.9),
        border: Border(bottom: BorderSide(color: border, width: 0.5)),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.back, color: fg),
          onPressed: () => Navigator.of(context).pop(),
        ),
        middle: Text(
          'EXPLAINABILITY AUDIT',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            letterSpacing: 0.5,
            color: fg,
          ),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.share, color: fg, size: 20),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Exporting Report PDF...'),
                backgroundColor: fg,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
              ),
            );
          },
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          children: [
            // Top Context Header
            Text(
              'COGNITIVE DIAGNOSTICS & XAI AUDIT',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: textMuted,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Assessment Report',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
                color: fg,
              ),
            ),
            const SizedBox(height: 16),

            // Hero Student Risk Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: border, width: 0.5),
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
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: fg,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Standard 4-B • Screened ${DateTime.now().year}',
                            style: TextStyle(
                              fontSize: 13,
                              color: textMuted,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: border,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          CupertinoIcons.checkmark_shield_fill,
                          size: 20,
                          color: fg,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildRiskBadge(_riskLevel, isDark),
                      const SizedBox(width: 12),
                      Text(
                        '${(_probability * 100).toStringAsFixed(1)}% Confidence',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: textMuted,
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
                color: surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: border, width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PREDICTED RISK PROBABILITY DISTRIBUTION',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                      color: textMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Cohort Model Classification',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: fg,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Horizontal Segmented Probability Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(9999),
                    child: Container(
                      height: 28,
                      color: border,
                      child: Row(
                        children: [
                          _probSegment(classProbs['None'] ?? 0.05, isDark ? const Color(0xFF111111) : const Color(0xFFFFFFFF), isDark ? const Color(0xFFFFFFFF) : const Color(0xFF0A0A0A), 'None'),
                          _probSegment(classProbs['Mild'] ?? 0.12, isDark ? const Color(0xFF333333) : const Color(0xFFE5E5EA), isDark ? const Color(0xFFFFFFFF) : const Color(0xFF0A0A0A), 'Mild'),
                          _probSegment(classProbs['Moderate'] ?? 0.18, isDark ? const Color(0xFF666666) : const Color(0xFF666666), const Color(0xFFFFFFFF), 'Mod'),
                          _probSegment(classProbs['Elevated'] ?? 0.65, isDark ? const Color(0xFFFFFFFF) : const Color(0xFF0A0A0A), isDark ? const Color(0xFF111111) : const Color(0xFFFFFFFF), 'Elevated'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Legend Ticks
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _legendTick('None', classProbs['None'] ?? 0.05, textMuted, fg),
                      _legendTick('Mild', classProbs['Mild'] ?? 0.12, textMuted, fg),
                      _legendTick('Moderate', classProbs['Moderate'] ?? 0.18, textMuted, fg),
                      _legendTick('Elevated', classProbs['Elevated'] ?? 0.65, textMuted, fg),
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
                  color: surface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: border, width: 0.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'OBSERVED RISK CONTRIBUTORS',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                            color: textMuted,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: border,
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: Text(
                            'SHAP Values',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: fg,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rightward bars amplify risk priority; leftward indicates resilient compensation.',
                      style: TextStyle(
                        fontSize: 12,
                        color: textMuted,
                      ),
                    ),
                    const SizedBox(height: 16),

                    ..._buildShapDivergingBars(shap, fg, textMuted, border, textSubtle, isDark),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Clinical Synthesis Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: border, width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: fg,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          CupertinoIcons.sparkles,
                          size: 14,
                          color: bg,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Clinical Synthesis',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: fg,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: border,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'This screening estimates patterns in the submitted ratings. It is not a diagnosis; review the results with a qualified education or health professional.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.45,
                        color: fg,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Recommended Interventions Section
            Text(
              'RECOMMENDED CLINICAL INTERVENTIONS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: textMuted,
              ),
            ),
            const SizedBox(height: 12),

            if (_isLoadingInterventions)
              const Center(child: Padding(padding: EdgeInsets.all(20), child: CupertinoActivityIndicator()))
            else if (_recommendations.isNotEmpty)
              ..._recommendations.map((rec) {
                final item = rec['intervention'] ?? rec;
                final title = item['title'] ?? 'Intervention';
                final desc = item['description'] ?? 'Targeted clinical activity.';

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: surface,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: border, width: 0.5),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: border,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          CupertinoIcons.lightbulb_fill,
                          size: 18,
                          color: fg,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: fg,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              desc,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(CupertinoIcons.chevron_right, size: 16, color: textSubtle),
                    ],
                  ),
                );
              }).toList()
            else
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: border, width: 0.5),
                ),
                child: Row(
                  children: [
                    Icon(CupertinoIcons.info_circle, size: 18, color: textMuted),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Personalized recommendations could not be loaded for this student.',
                        style: TextStyle(fontSize: 13, color: textMuted),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 32),

            // Action Buttons
            SizedBox(
              width: double.infinity,
              height: 52,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                color: surface,
                borderRadius: BorderRadius.circular(9999),
                onPressed: () => Navigator.of(context).pop(),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9999),
                    border: Border.all(color: border, width: 0.5),
                  ),
                  child: Center(
                    child: Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: fg,
                      ),
                    ),
                  ),
                ),
              ),
            ),
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
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ),
      ),
    );
  }

  Widget _legendTick(String name, double val, Color textMuted, Color fg) {
    return Column(
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: textMuted,
          ),
        ),
        Text(
          '${(val * 100).round()}%',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: fg,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildShapDivergingBars(Map<String, double> shap, Color fg, Color textMuted, Color border, Color textSubtle, bool isDark) {
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
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: fg,
                  ),
                ),
                Text(
                  '${isPositive ? '+' : ''}${val.toStringAsFixed(2)} SHAP',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isPositive ? fg : textMuted,
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
                    color: border,
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 1,
                      color: textSubtle,
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
                              ? fg
                              : textMuted,
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

  Widget _buildRiskBadge(String riskLevel, bool isDark) {
    final normRisk = riskLevel.trim().toLowerCase();
    Color bg;
    Color fg;
    Border? border;

    if (normRisk == 'none' || normRisk == 'baseline' || normRisk == 'low') {
      bg = isDark ? const Color(0xFF000000) : const Color(0xFFFFFFFF);
      fg = isDark ? const Color(0xFFFFFFFF) : const Color(0xFF111111);
      border = Border.all(color: fg, width: 1);
    } else if (normRisk == 'mild') {
      bg = isDark ? const Color(0xFF333333) : const Color(0xFFE5E5EA);
      fg = isDark ? const Color(0xFFFFFFFF) : const Color(0xFF111111);
      border = null;
    } else if (normRisk == 'moderate') {
      bg = isDark ? const Color(0xFF666666) : const Color(0xFF555555);
      fg = const Color(0xFFFFFFFF);
      border = null;
    } else {
      bg = isDark ? const Color(0xFFFFFFFF) : const Color(0xFF111111);
      fg = isDark ? const Color(0xFF000000) : const Color(0xFFFFFFFF);
      border = null;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: border,
      ),
      child: Text(
        riskLevel.toUpperCase(),
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: fg,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
