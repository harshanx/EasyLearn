import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_difficulty_screening/localization/app_localizations.dart';
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
    final theme = Theme.of(context);

    final childData = _selectedChildId != null
        ? _children.firstWhere((c) => c['id'] == _selectedChildId)
        : null;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        title: Text(
          _selectedChildId != null ? "${childData!['name']}'s Profile" : localizations.appTitle,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: _selectedChildId != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => _selectedChildId = null),
              )
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            tooltip: localizations.logout,
            onPressed: _logout,
          ),
        ],
      ),
      body: SafeArea(
        child: childData == null
            ? _buildProfilesList(context, localizations, theme)
            : _buildChildDetail(context, localizations, theme, childData),
      ),
    );
  }

  Widget _buildProfilesList(
      BuildContext context, AppLocalizations localizations, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.family_restroom,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.myChildren,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Select a child profile to view details",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Children List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _children.length,
            itemBuilder: (ctx, index) {
              final child = _children[index];
              final probability = child['risk'] as double;
              String status;
              Color statusColor;

              if (probability < 0.40) {
                status = localizations.lowRisk;
                statusColor = const Color(0xFF10B981);
              } else if (probability < 0.70) {
                status = localizations.moderateRisk;
                statusColor = const Color(0xFFF59E0B);
              } else {
                status = localizations.elevatedRisk;
                statusColor = const Color(0xFFEF4444);
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedChildId = child['id'] as String;
                    });
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    statusColor.withOpacity(0.2),
                                    statusColor.withOpacity(0.1),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Text(
                                  child['name'][0] as String,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: statusColor,
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
                                    child['name'] as String,
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    child['grade'] as String,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onBackground.withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "${(probability * 100).toInt()}%",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: statusColor,
                                    ),
                                  ),
                                  Text(
                                    status,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: statusColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(
                              Icons.assignment_outlined,
                              size: 18,
                              color: theme.colorScheme.onBackground.withOpacity(0.5),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "${child['activities'].length} Activities Assigned",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onBackground.withOpacity(0.6),
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: theme.colorScheme.primary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Demo Mode Indicator
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    localizations.demoModeActive,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildDetail(
      BuildContext context, AppLocalizations localizations, ThemeData theme, Map<String, dynamic> child) {
    final factors = child['factors'] as List<Map<String, String>>;
    final activities = child['activities'] as List<Map<String, dynamic>>;
    final probability = child['risk'] as double;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Risk Indicator Panel
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  probability > 0.7 
                      ? const Color(0xFFEF4444).withOpacity(0.1)
                      : (probability > 0.4 
                          ? const Color(0xFFF59E0B).withOpacity(0.1)
                          : const Color(0xFF10B981).withOpacity(0.1)),
                  probability > 0.7 
                      ? const Color(0xFFEF4444).withOpacity(0.05)
                      : (probability > 0.4 
                          ? const Color(0xFFF59E0B).withOpacity(0.05)
                          : const Color(0xFF10B981).withOpacity(0.05)),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: probability > 0.7 
                    ? const Color(0xFFEF4444).withOpacity(0.3)
                    : (probability > 0.4 
                        ? const Color(0xFFF59E0B).withOpacity(0.3)
                        : const Color(0xFF10B981).withOpacity(0.3)),
                width: 1.5,
              ),
            ),
            child: RiskIndicator(
              probability: child['risk'] as double,
              disclaimerText: localizations.medicalDisclaimer,
              titleText: localizations.screeningRisk,
              probabilityLabelText: localizations.screeningProbability,
              riskLabels: {
                'low': localizations.lowRisk,
                'moderate': localizations.moderateRisk,
                'elevated': localizations.elevatedRisk,
              },
            ),
          ),
          const SizedBox(height: 24),

          // Areas of Difficulty
          Text(
            localizations.areasOfDifficulty,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: factors.map((f) {
                final String areaName = f['area']!;
                final String impact = f['impact']!;
                Color impactColor = const Color(0xFF10B981);
                if (impact == 'High') impactColor = const Color(0xFFEF4444);
                if (impact == 'Moderate') impactColor = const Color(0xFFF59E0B);

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: impactColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          areaName == 'Reading'
                              ? localizations.reading
                              : (areaName == 'Writing'
                                  ? localizations.writing
                                  : (areaName == 'Memory'
                                      ? localizations.memory
                                      : areaName)),
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: impactColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          impact,
                          style: TextStyle(
                            color: impactColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // Recommended Interventions
          Text(
            localizations.recommendedInterventions,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length,
            itemBuilder: (ctx, index) {
              final act = activities[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      act['category'] == 'Reading'
                          ? Icons.menu_book_outlined
                          : (act['category'] == 'Memory' 
                              ? Icons.psychology_outlined 
                              : Icons.edit_outlined),
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  title: Text(
                    act['title'] as String,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      "Status: ${act['status']}",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onBackground.withOpacity(0.6),
                      ),
                    ),
                  ),
                  trailing: act['progress'] == 1.0
                      ? Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.check_circle,
                            color: Color(0xFF10B981),
                            size: 20,
                          ),
                        )
                      : SizedBox(
                          width: 32,
                          height: 32,
                          child: CircularProgressIndicator(
                            value: act['progress'] as double,
                            strokeWidth: 3,
                            backgroundColor: theme.colorScheme.onBackground.withOpacity(0.1),
                            valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                          ),
                        ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("PDF report downloads will be enabled in a future update."),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.picture_as_pdf_outlined),
                  label: Text(localizations.generateReport),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ScreeningQuestionnaireScreen(
                          studentId: child['id'] as String,
                          studentName: child['name'] as String,
                        ),

                      ),
                    );
                  },
                  icon: const Icon(Icons.analytics_outlined),
                  label: const Text('New Screening'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
