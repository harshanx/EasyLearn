import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
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
      MaterialPageRoute(
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final filteredList = _students.where((student) {
      final matchesSearch = student['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          student['id'].toLowerCase().contains(_searchQuery.toLowerCase());
      if (!matchesSearch) return false;

      if (_selectedFilter == 'all') return true;
      return student['category'] == _selectedFilter;
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBackground : AppTheme.offWhiteSurface,
      appBar: AppBar(
        backgroundColor: (isDark ? AppTheme.darkBackground : AppTheme.offWhiteSurface).withOpacity(0.9),
        elevation: 0,
        title: Text(
          'Classroom 4-B',
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.gear, size: 20),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.square_arrow_right, size: 20),
            onPressed: _logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: AppTheme.slateGray,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'St. Mary\'s Academy • 28 Learners',
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 13,
                        color: AppTheme.slateGray,
                      ),
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: isDark ? AppTheme.pureWhite : AppTheme.pitchBlack,
                  child: Text(
                    '4B',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppTheme.pitchBlack : AppTheme.pureWhite,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Metric Overview Inset Mosaic (3 columns)
            Row(
              children: [
                _metricBox('Screened', '24/28', '85% Complete', isDark, theme),
                const SizedBox(width: 8),
                _metricBox('Priority', '3', 'Immediate Review', isDark, theme, isAlert: true),
                const SizedBox(width: 8),
                _metricBox('Sessions', '11', '+2 this week', isDark, theme),
              ],
            ),
            const SizedBox(height: 16),

            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkSurface : AppTheme.pureWhite,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? AppTheme.darkHairline : AppTheme.paleHairline,
                  width: 0.5,
                ),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) => setState(() => _searchQuery = val),
                style: GoogleFonts.hankenGrotesk(fontSize: 14, color: theme.colorScheme.onSurface),
                decoration: InputDecoration(
                  hintText: 'Search student name or roll #...',
                  hintStyle: GoogleFonts.hankenGrotesk(fontSize: 14, color: AppTheme.ashGray),
                  prefixIcon: const Icon(CupertinoIcons.search, size: 18, color: AppTheme.slateGray),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Status Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _filterChip('all', 'All (28)', isDark),
                  const SizedBox(width: 8),
                  _filterChip('elevated', 'Elevated (3)', isDark),
                  const SizedBox(width: 8),
                  _filterChip('moderate', 'Moderate (5)', isDark),
                  const SizedBox(width: 8),
                  _filterChip('pending', 'Pending (4)', isDark),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Learner Directory Roster
            Container(
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'LEARNER DIRECTORY',
                          style: GoogleFonts.hankenGrotesk(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                            color: AppTheme.slateGray,
                          ),
                        ),
                        Text(
                          'Cohort Tiering',
                          style: GoogleFonts.hankenGrotesk(
                            fontSize: 11,
                            color: AppTheme.slateGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  ...filteredList.map((student) {
                    final isLast = student['id'] == filteredList.last['id'];
                    return Column(
                      children: [
                        InkWell(
                          onTap: () => _openScreeningForStudent(student),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: isDark ? AppTheme.darkSurfaceContainer : AppTheme.surfaceContainerLow,
                                  child: Text(
                                    student['name'].split(' ').map((e) => e[0]).take(2).join(),
                                    style: GoogleFonts.hankenGrotesk(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: theme.colorScheme.onSurface,
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
                                            style: GoogleFonts.manrope(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: theme.colorScheme.onSurface,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            student['roll'] as String,
                                            style: GoogleFonts.hankenGrotesk(
                                              fontSize: 11,
                                              color: AppTheme.slateGray,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      AppTheme.buildRiskBadge(student['riskLevel'] as String),
                                    ],
                                  ),
                                ),
                                const Icon(CupertinoIcons.chevron_right, size: 16, color: AppTheme.ashGray),
                              ],
                            ),
                          ),
                        ),
                        if (!isLast) const Divider(height: 1),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Start Screening Queue Action Banner
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
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.darkSurfaceContainer : AppTheme.surfaceContainerLow,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      CupertinoIcons.doc_checkmark,
                      size: 20,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Screening Queue',
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          '4 learners awaiting diagnostics',
                          style: GoogleFonts.hankenGrotesk(
                            fontSize: 12,
                            color: AppTheme.slateGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _openScreeningForStudent(_students.first),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? AppTheme.pureWhite : AppTheme.pitchBlack,
                      foregroundColor: isDark ? AppTheme.pitchBlack : AppTheme.pureWhite,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      minimumSize: Size.zero,
                    ),
                    child: Text(
                      'Start Screen',
                      style: GoogleFonts.hankenGrotesk(fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _metricBox(String label, String value, String sub, bool isDark, ThemeData theme, {bool isAlert = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkSurface : AppTheme.pureWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppTheme.darkHairline : AppTheme.paleHairline,
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: GoogleFonts.hankenGrotesk(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppTheme.slateGray,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              sub,
              style: GoogleFonts.hankenGrotesk(
                fontSize: 10,
                color: isAlert ? (isDark ? AppTheme.pureWhite : AppTheme.pitchBlack) : AppTheme.slateGray,
                fontWeight: isAlert ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String filterKey, String label, bool isDark) {
    final isSelected = _selectedFilter == filterKey;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = filterKey),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppTheme.pureWhite : AppTheme.pitchBlack)
              : (isDark ? AppTheme.darkSurface : AppTheme.pureWhite),
          borderRadius: BorderRadius.circular(9999),
          border: Border.all(
            color: isSelected
                ? (isDark ? AppTheme.pureWhite : AppTheme.pitchBlack)
                : (isDark ? AppTheme.darkHairline : AppTheme.paleHairline),
            width: 0.5,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.hankenGrotesk(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? (isDark ? AppTheme.pitchBlack : AppTheme.pureWhite)
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
