import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_difficulty_screening/localization/app_localizations.dart';
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
    final theme = Theme.of(context);

    final List<Map<String, String>> auditLogs = [
      {'user': 'Teacher (T001)', 'action': 'Viewed student STU001 profile', 'time': '2026-08-29 23:15'},
      {'user': 'Parent (P001)', 'action': 'Completed screening assessment for Alex', 'time': '2026-08-29 22:50'},
      {'user': 'Admin (A001)', 'action': 'Added new reading intervention activity', 'time': '2026-08-29 21:00'},
      {'user': 'Teacher (T001)', 'action': 'Saved educational note for Rahul Verma', 'time': '2026-08-29 18:30'},
      {'user': 'System', 'action': 'Reloaded machine learning model RF-1.2', 'time': '2026-08-29 00:05'},
    ];

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        title: Text(
          "Admin Dashboard",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            tooltip: localizations.logout,
            onPressed: () => _logout(context, ref),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // System Health Panel
              Text(
                localizations.systemHealth,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(24),
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
                  children: [
                    _buildHealthRow(localizations.database, true, localizations, theme),
                    const Divider(height: 24),
                    _buildHealthRow(localizations.mlModel, true, localizations, theme),
                    const Divider(height: 24),
                    _buildHealthRow(localizations.xaiService, true, localizations, theme),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          localizations.modelVersion,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "RF-1.2 (Prototype)",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Admin controls grid
              Text(
                "System Actions",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 2.2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _buildAdminActionCard(
                    icon: Icons.people_outline,
                    label: "Manage Accounts",
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Account management is disabled in Phase 1."),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    theme: theme,
                  ),
                  _buildAdminActionCard(
                    icon: Icons.menu_book_outlined,
                    label: "Interventions",
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Intervention database customizer is disabled in Phase 1."),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    theme: theme,
                  ),
                  _buildAdminActionCard(
                    icon: Icons.quiz_outlined,
                    label: "Questionnaires",
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Questionnaire editor is disabled in Phase 1."),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    theme: theme,
                  ),
                  _buildAdminActionCard(
                    icon: Icons.analytics_outlined,
                    label: "Model Settings",
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Model configuration parameters are disabled in Phase 1."),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    theme: theme,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // System Audit Logs
              Text(
                localizations.auditLogs,
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
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  itemCount: auditLogs.length,
                  itemBuilder: (ctx, index) {
                    final log = auditLogs[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.history_toggle_off,
                              size: 20,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  log['action']!,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${log['user']!} • ${log['time']!}",
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onBackground.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHealthRow(String title, bool active, AppLocalizations localizations, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: active ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (active ? const Color(0xFF10B981) : const Color(0xFFEF4444)).withOpacity(0.3),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              active ? localizations.active : localizations.inactive,
              style: TextStyle(
                color: active ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildAdminActionCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 28,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
