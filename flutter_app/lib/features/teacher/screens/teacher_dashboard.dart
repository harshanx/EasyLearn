import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/settings_provider.dart';
import '../../screening/screens/screening_questionnaire_screen.dart';

class TeacherDashboard extends ConsumerStatefulWidget {
  const TeacherDashboard({Key? key}) : super(key: key);

  @override
  ConsumerState<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends ConsumerState<TeacherDashboard> {
  String _selectedFilter = 'all';
  String _searchQuery = '';
  final _searchController = TextEditingController();

  final List<Map<String, dynamic>> _students = [
    {
      'id': 'STU001',
      'name': 'Rohan V.',
      'roll': '#12',
      'grade': '4th Std',
      'category': 'elevated',
      'riskLevel': 'Elevated',
      'riskScore': 0.85,
      'statusLabel': 'Elevated Risk • Dyslexia',
    },
    {
      'id': 'STU002',
      'name': 'Ananya Nair',
      'roll': '#04',
      'grade': '4th Std',
      'category': 'moderate',
      'riskLevel': 'Moderate',
      'riskScore': 0.55,
      'statusLabel': 'Moderate • Attention',
    },
    {
      'id': 'STU003',
      'name': 'Aarav Sharma',
      'roll': '#14',
      'grade': '4th Std',
      'category': 'elevated',
      'riskLevel': 'Elevated',
      'riskScore': 0.89,
      'statusLabel': 'Elevated Support Advised',
    },
    {
      'id': 'STU004',
      'name': 'Kavya Patel',
      'roll': '#22',
      'grade': '4th Std',
      'category': 'moderate',
      'riskLevel': 'Mild',
      'riskScore': 0.32,
      'statusLabel': 'Mild • Spatial Reasoning',
    },
    {
      'id': 'STU005',
      'name': 'Dev Menon',
      'roll': '#08',
      'grade': '4th Std',
      'category': 'pending',
      'riskLevel': 'None',
      'riskScore': 0.12,
      'statusLabel': 'On Track • Low Risk',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _logout() {
    ref.read(settingsProvider.notifier).setLoggedInRole(null);
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _openScreeningForStudent(Map<String, dynamic> student) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => ScreeningQuestionnaireScreen(
          studentId: student['id'] as String,
          studentName: student['name'] as String,
          grade: student['grade'] as String,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = isDark ? AppTheme.darkBackground : const Color(0xFFFFFFFF);
    final surface = isDark ? AppTheme.darkSurface : const Color(0xFFF7F7F9);
    final fg = isDark ? const Color(0xFFFFFFFF) : const Color(0xFF0A0A0A);
    final border = isDark ? AppTheme.darkHairline : const Color(0xFFE5E5EA);
    final textMuted = isDark ? AppTheme.ashGray : const Color(0xFF666666);
    final textSubtle = isDark ? AppTheme.slateGray : const Color(0xFFA1A1A6);

    final filteredList = _students.where((student) {
      final matchesSearch = student['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          student['id'].toLowerCase().contains(_searchQuery.toLowerCase());
      if (!matchesSearch) return false;

      if (_selectedFilter == 'all') return true;
      return student['category'] == _selectedFilter;
    }).toList();

    return Scaffold(
      backgroundColor: bg,
      appBar: CupertinoNavigationBar(
        backgroundColor: bg.withOpacity(0.9),
        border: Border(bottom: BorderSide(color: border, width: 0.5)),
        middle: Text(
          "CLASSROOM 4-B",
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
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          children: [
            // Header Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CLASSROOM MANAGEMENT',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: textMuted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'St. Mary\'s Academy • 28 Learners',
                      style: TextStyle(
                        fontSize: 13,
                        color: textMuted,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: fg,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '4B',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: bg,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Metric Overview Inset Mosaic (3 columns)
            Row(
              children: [
                _metricBox('Screened', '24/28', '85% Complete', surface, border, textMuted, fg),
                const SizedBox(width: 8),
                _metricBox('Priority', '3', 'Review Needed', surface, border, textMuted, fg, isAlert: true),
                const SizedBox(width: 8),
                _metricBox('Sessions', '11', '+2 this week', surface, border, textMuted, fg),
              ],
            ),
            const SizedBox(height: 24),

            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: border, width: 0.5),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) => setState(() => _searchQuery = val),
                style: TextStyle(fontSize: 14, color: fg),
                decoration: InputDecoration(
                  hintText: 'Search student name or roll #...',
                  hintStyle: TextStyle(fontSize: 14, color: textSubtle),
                  prefixIcon: Icon(CupertinoIcons.search, size: 18, color: textMuted),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Status Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _filterChip('all', 'All (28)', surface, fg, bg, border),
                  const SizedBox(width: 8),
                  _filterChip('elevated', 'Elevated (3)', surface, fg, bg, border),
                  const SizedBox(width: 8),
                  _filterChip('moderate', 'Moderate (5)', surface, fg, bg, border),
                  const SizedBox(width: 8),
                  _filterChip('pending', 'Pending (4)', surface, fg, bg, border),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Learner Directory Roster
            Text(
              "LEARNER DIRECTORY",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
                color: textMuted,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: border, width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: filteredList.asMap().entries.map((entry) {
                  final index = entry.key;
                  final student = entry.value;
                  final isLast = index == filteredList.length - 1;

                  return Column(
                    children: [
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        onPressed: () => _openScreeningForStudent(student),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: border,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  student['name'].split(' ').map((e) => e[0]).take(2).join(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: fg,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        student['name'] as String,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: fg,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        student['roll'] as String,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  _buildRiskBadge(student['riskLevel'] as String, isDark),
                                ],
                              ),
                            ),
                            Icon(CupertinoIcons.chevron_right, size: 16, color: textSubtle),
                          ],
                        ),
                      ),
                      if (!isLast)
                        Padding(
                          padding: const EdgeInsets.only(left: 64),
                          child: Divider(color: border, height: 1, thickness: 0.5),
                        ),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 32),

            // Start Screening Queue Action Banner
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
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: border,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      CupertinoIcons.doc_checkmark,
                      size: 20,
                      color: fg,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Screening Queue',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: fg,
                          ),
                        ),
                        Text(
                          '4 learners awaiting diagnostics',
                          style: TextStyle(
                            fontSize: 12,
                            color: textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CupertinoButton(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    color: fg,
                    borderRadius: BorderRadius.circular(9999),
                    minSize: 0,
                    onPressed: () => _openScreeningForStudent(_students.first),
                    child: Text(
                      'Start Screen',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: bg),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metricBox(String label, String value, String sub, Color surface, Color border, Color textMuted, Color fg, {bool isAlert = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: textMuted,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: fg,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              sub,
              style: TextStyle(
                fontSize: 10,
                color: isAlert ? fg : textMuted,
                fontWeight: isAlert ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String filterKey, String label, Color surface, Color fg, Color bg, Color border) {
    final isSelected = _selectedFilter == filterKey;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = filterKey),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? fg : surface,
          borderRadius: BorderRadius.circular(9999),
          border: Border.all(
            color: isSelected ? fg : border,
            width: 0.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? bg : fg,
          ),
        ),
      ),
    );
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
