import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_difficulty_screening/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/settings_provider.dart';

class AdminDashboard extends ConsumerWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  void _logout(BuildContext context, WidgetRef ref) {
    ref.read(settingsProvider.notifier).setLoggedInRole(null);
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = isDark ? AppTheme.darkBackground : const Color(0xFFFFFFFF);
    final surface = isDark ? AppTheme.darkSurface : const Color(0xFFF7F7F9);
    final fg = isDark ? const Color(0xFFFFFFFF) : const Color(0xFF0A0A0A);
    final border = isDark ? AppTheme.darkHairline : const Color(0xFFE5E5EA);
    final textMuted = isDark ? AppTheme.ashGray : const Color(0xFF666666);
    final textSubtle = isDark ? AppTheme.slateGray : const Color(0xFFA1A1A6);

    final List<Map<String, String>> auditLogs = [
      {'user': 'Teacher (T001)', 'action': 'Viewed student STU001 profile', 'time': '2026-08-29 23:15'},
      {'user': 'Parent (P001)', 'action': 'Completed screening assessment for Alex', 'time': '2026-08-29 22:50'},
      {'user': 'Admin (A001)', 'action': 'Added new reading intervention activity', 'time': '2026-08-29 21:00'},
      {'user': 'Teacher (T001)', 'action': 'Saved educational note for Rahul Verma', 'time': '2026-08-29 18:30'},
      {'user': 'System', 'action': 'Reloaded machine learning model RF-1.2', 'time': '2026-08-29 00:05'},
    ];

    return Scaffold(
      backgroundColor: bg,
      appBar: CupertinoNavigationBar(
        backgroundColor: bg.withOpacity(0.9),
        border: Border(bottom: BorderSide(color: border, width: 0.5)),
        middle: Text(
          "ADMIN PORTAL",
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
              onPressed: () => _logout(context, ref),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          children: [
            // System Health Section
            Text(
              "System Health",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.8,
                color: fg,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Monitor platform services and ML performance.",
              style: TextStyle(
                fontSize: 14,
                color: textMuted,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: border, width: 0.5),
              ),
              child: Column(
                children: [
                  _buildHealthRow(localizations.database, true, localizations, fg, textMuted),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Divider(color: border, height: 1, thickness: 0.5),
                  ),
                  _buildHealthRow(localizations.mlModel, true, localizations, fg, textMuted),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Divider(color: border, height: 1, thickness: 0.5),
                  ),
                  _buildHealthRow(localizations.xaiService, true, localizations, fg, textMuted),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Divider(color: border, height: 1, thickness: 0.5),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Model Version",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: fg,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: fg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "RF-1.2 (Prototype)",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: bg,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 32),

            // System Actions
            Text(
              "System Actions",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: textMuted,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildAdminActionCard(
                    icon: CupertinoIcons.person_2,
                    label: "Accounts",
                    surface: surface,
                    fg: fg,
                    border: border,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Account management disabled in demo."), behavior: SnackBarBehavior.floating),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildAdminActionCard(
                    icon: CupertinoIcons.book,
                    label: "Interventions",
                    surface: surface,
                    fg: fg,
                    border: border,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Intervention editor disabled in demo."), behavior: SnackBarBehavior.floating),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildAdminActionCard(
                    icon: CupertinoIcons.doc_text,
                    label: "Forms",
                    surface: surface,
                    fg: fg,
                    border: border,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Form builder disabled in demo."), behavior: SnackBarBehavior.floating),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildAdminActionCard(
                    icon: CupertinoIcons.slider_horizontal_3,
                    label: "ML Settings",
                    surface: surface,
                    fg: fg,
                    border: border,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("ML settings disabled in demo."), behavior: SnackBarBehavior.floating),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Audit Logs
            Text(
              "Recent Activity Audit",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
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
                children: auditLogs.asMap().entries.map((entry) {
                  final index = entry.key;
                  final log = entry.value;
                  final isLast = index == auditLogs.length - 1;

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: border,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                CupertinoIcons.shield_lefthalf_fill,
                                size: 14,
                                color: textMuted,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        log['user']!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: fg,
                                        ),
                                      ),
                                      Text(
                                        log['time']!.split(' ')[1],
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: textSubtle,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    log['action']!,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!isLast)
                        Padding(
                          padding: const EdgeInsets.only(left: 60),
                          child: Divider(color: border, height: 1, thickness: 0.5),
                        ),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthRow(String label, bool isOk, AppLocalizations localizations, Color fg, Color textMuted) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: fg,
          ),
        ),
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: isOk ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              isOk ? 'Operational' : 'Issue Detected',
              style: TextStyle(
                fontSize: 13,
                color: textMuted,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdminActionCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color surface,
    required Color fg,
    required Color border,
  }) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border, width: 0.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: fg),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: fg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
