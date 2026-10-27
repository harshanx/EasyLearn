import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_difficulty_screening/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/settings_provider.dart';
import '../../../shared/widgets/risk_indicator.dart';
import '../../screening/screens/screening_questionnaire_screen.dart';

class ParentDashboard extends ConsumerStatefulWidget {
  const ParentDashboard({Key? key}) : super(key: key);

  @override
  ConsumerState<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends ConsumerState<ParentDashboard> {
  String? _selectedChildId;

  final List<Map<String, dynamic>> _children = [
    {
      'id': 'C001',
      'name': 'Alex',
      'grade': 'Grade 5',
      'risk': 0.82,
      'factors': [
        {'area': 'Reading', 'impact': 'High'},
        {'area': 'Memory', 'impact': 'Moderate'},
        {'area': 'Writing', 'impact': 'Moderate'},
      ],
      'activities': [
        {'title': 'Guided Reading Practice', 'category': 'Reading', 'status': 'Started', 'progress': 0.6},
        {'title': 'Short-Term Memory Match', 'category': 'Memory', 'status': 'Completed', 'progress': 1.0},
        {'title': 'Structured Sentence Cards', 'category': 'Writing', 'status': 'Not Started', 'progress': 0.0},
      ]
    },
    {
      'id': 'C002',
      'name': 'Rahul',
      'grade': 'Grade 2',
      'risk': 0.22,
      'factors': [
        {'area': 'Attention', 'impact': 'Low'},
      ],
      'activities': [
        {'title': 'Visual Attention Focus', 'category': 'Attention', 'status': 'Completed', 'progress': 1.0},
      ]
    }
  ];

  void _logout() {
    ref.read(settingsProvider.notifier).setLoggedInRole(null);
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = isDark ? AppTheme.darkBackground : const Color(0xFFFFFFFF);
    final surface = isDark ? AppTheme.darkSurface : const Color(0xFFF7F7F9);
    final fg = isDark ? const Color(0xFFFFFFFF) : const Color(0xFF0A0A0A);
    final border = isDark ? AppTheme.darkHairline : const Color(0xFFE5E5EA);
    final textMuted = isDark ? AppTheme.ashGray : const Color(0xFF666666);
    final textSubtle = isDark ? AppTheme.slateGray : const Color(0xFFA1A1A6);

    final childData = _selectedChildId != null
        ? _children.firstWhere((c) => c['id'] == _selectedChildId)
        : null;

    return Scaffold(
      backgroundColor: bg,
      appBar: CupertinoNavigationBar(
        backgroundColor: bg.withOpacity(0.9),
        border: Border(bottom: BorderSide(color: border, width: 0.5)),
        leading: _selectedChildId != null
            ? CupertinoButton(
                padding: EdgeInsets.zero,
                child: Icon(CupertinoIcons.back, color: fg),
                onPressed: () => setState(() => _selectedChildId = null),
              )
            : null,
        middle: Text(
          _selectedChildId != null ? "${childData!['name']}'s Profile".toUpperCase() : "PARENT PORTAL",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            letterSpacing: 0.5,
            color: fg,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: Icon(CupertinoIcons.gear, color: fg, size: 22),
              onPressed: () => Navigator.pushNamed(context, '/settings'),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: Icon(CupertinoIcons.arrow_right_square, color: fg, size: 22),
              onPressed: _logout,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: childData == null
            ? _buildProfilesList(context, localizations, bg, surface, fg, border, textMuted, textSubtle, isDark)
            : _buildChildDetail(context, localizations, childData, bg, surface, fg, border, textMuted, textSubtle, isDark),
      ),
      floatingActionButton: _selectedChildId != null
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => ScreeningQuestionnaireScreen(
                      studentId: childData!['id'],
                      studentName: childData['name'],
                    ),
                  ),
                );
              },
              backgroundColor: fg,
              foregroundColor: bg,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
              icon: const Icon(CupertinoIcons.doc_text_search),
              label: const Text(
                'New Screening',
                style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: -0.2),
              ),
            )
          : null,
    );
  }

  Widget _buildProfilesList(BuildContext context, AppLocalizations localizations, Color bg, Color surface, Color fg, Color border, Color textMuted, Color textSubtle, bool isDark) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      children: [
        Text(
          "My Children",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
            color: fg,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Monitor learning progress and activities.",
          style: TextStyle(
            fontSize: 14,
            color: textMuted,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 24),
        ..._children.map((child) => _buildChildCard(child, surface, fg, bg, border, textMuted, textSubtle, isDark)).toList(),
        const SizedBox(height: 24),
        CupertinoButton(
          padding: const EdgeInsets.symmetric(vertical: 16),
          color: surface,
          borderRadius: BorderRadius.circular(22),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(CupertinoIcons.add, color: fg, size: 20),
              const SizedBox(width: 8),
              Text(
                "Add Child Profile",
                style: TextStyle(
                  color: fg,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Feature 'Add Child' not implemented in demo."),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildChildCard(Map<String, dynamic> child, Color surface, Color fg, Color bg, Color border, Color textMuted, Color textSubtle, bool isDark) {
    final riskScore = child['risk'] as double;
    final riskLabel = riskScore > 0.7 ? "Elevated Risk" : (riskScore > 0.4 ? "Moderate Risk" : "Low Risk");
    final riskColor = riskScore > 0.7 ? const Color(0xFFEF4444) : (riskScore > 0.4 ? const Color(0xFFF59E0B) : const Color(0xFF10B981));

    return GestureDetector(
      onTap: () => setState(() => _selectedChildId = child['id']),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: border, width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: border,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Center(
                child: Text(
                  child['name'][0],
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: fg,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    child['name'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.4,
                      color: fg,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    child['grade'],
                    style: TextStyle(
                      fontSize: 14,
                      color: textMuted,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: riskColor.withOpacity(isDark ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                riskLabel,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isDark ? riskColor : riskColor.withOpacity(0.9),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChildDetail(BuildContext context, AppLocalizations localizations, Map<String, dynamic> child, Color bg, Color surface, Color fg, Color border, Color textMuted, Color textSubtle, bool isDark) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      children: [
        // Profile Header
        Center(
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: border,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    child['name'][0],
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: fg,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                child['name'],
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                  color: fg,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "${child['grade']} • Student ID: ${child['id']}",
                style: TextStyle(
                  fontSize: 14,
                  color: textMuted,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // Core Metrics
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: border, width: 0.5),
                ),
                child: Column(
                  children: [
                    Text(
                      "RISK FACTOR",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: textMuted,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 64,
                      height: 64,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: child['risk'],
                            strokeWidth: 4,
                            backgroundColor: border,
                            valueColor: AlwaysStoppedAnimation<Color>(fg),
                          ),
                          Text(
                            '${(child['risk'] * 100).toInt()}%',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: fg,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: border, width: 0.5),
                ),
                child: Column(
                  children: [
                    Text(
                      "COMPLETED",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: textMuted,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: border,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          "12",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: fg,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // Activity Plan
        Text(
          "Personalized Activity Plan",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: fg,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: border, width: 0.5),
          ),
          child: Column(
            children: (child['activities'] as List).asMap().entries.map((entry) {
              final index = entry.key;
              final act = entry.value;
              final isLast = index == (child['activities'] as List).length - 1;
              final progress = act['progress'] as double;

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: border,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            progress == 1.0 ? CupertinoIcons.check_mark : CupertinoIcons.play_arrow_solid,
                            color: fg,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                act['title'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: fg,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                act['category'],
                                style: TextStyle(
                                  fontSize: 13,
                                  color: textMuted,
                                ),
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: progress,
                                backgroundColor: border,
                                valueColor: AlwaysStoppedAnimation<Color>(fg),
                                minHeight: 4,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isLast) Divider(color: border, height: 1, thickness: 0.5),
                ],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 80),
      ],
    );
  }
}
