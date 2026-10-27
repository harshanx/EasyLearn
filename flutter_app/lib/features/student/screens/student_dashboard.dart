import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_difficulty_screening/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/settings_provider.dart';

class StudentDashboard extends ConsumerWidget {
  const StudentDashboard({Key? key}) : super(key: key);

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

    final List<Map<String, dynamic>> activities = [
      {'title': 'Letter Recognition Sound Puzzle', 'icon': CupertinoIcons.music_note_2, 'done': true},
      {'title': 'Card Memory Matching Challenge', 'icon': CupertinoIcons.square_stack_3d_up, 'done': true},
      {'title': 'Trace and Write Letters', 'icon': CupertinoIcons.pencil, 'done': false},
      {'title': 'Deconstruct Numbers Game', 'icon': CupertinoIcons.number_square, 'done': false},
    ];

    final completedCount = activities.where((a) => a['done']).length;
    final totalCount = activities.length;
    final progress = completedCount / totalCount;

    return Scaffold(
      backgroundColor: bg,
      appBar: CupertinoNavigationBar(
        backgroundColor: bg.withOpacity(0.9),
        border: Border(bottom: BorderSide(color: border, width: 0.5)),
        middle: Text(
          "STUDENT PORTAL",
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
            // Welcome Header
            Text(
              "Welcome back, Student",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.8,
                color: fg,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Let's complete your daily exercises and collect stars.",
              style: TextStyle(
                fontSize: 14,
                color: textMuted,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 32),

            // Progress Card (Monochrome Flat)
            Text(
              "My Progress",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
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
              child: Row(
                children: [
                  SizedBox(
                    height: 56,
                    width: 56,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 4,
                      backgroundColor: border,
                      valueColor: AlwaysStoppedAnimation<Color>(fg),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$completedCount / $totalCount Activities",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                            color: fg,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Keep going! You are doing awesome.",
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
            const SizedBox(height: 32),

            // Activities List (Monochrome Inset Group)
            Text(
              "Today's Activities",
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
                children: activities.asMap().entries.map((entry) {
                  final index = entry.key;
                  final act = entry.value;
                  final isLast = index == activities.length - 1;
                  final done = act['done'] as bool;

                  return Column(
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Starting: ${act['title']}'),
                              backgroundColor: fg,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: done ? fg : border,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  act['icon'],
                                  color: done ? bg : fg,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  act['title'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: done ? FontWeight.w500 : FontWeight.w600,
                                    color: done ? textMuted : fg,
                                    decoration: done ? TextDecoration.lineThrough : null,
                                  ),
                                ),
                              ),
                              if (done)
                                Icon(CupertinoIcons.check_mark_circled_solid, color: fg, size: 24)
                              else
                                Icon(CupertinoIcons.chevron_right, color: textSubtle, size: 18),
                            ],
                          ),
                        ),
                      ),
                      if (!isLast)
                        Padding(
                          padding: const EdgeInsets.only(left: 76),
                          child: Divider(color: border, height: 1, thickness: 0.5),
                        ),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
