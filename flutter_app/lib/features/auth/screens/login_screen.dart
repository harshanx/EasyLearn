import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../providers/settings_provider.dart';
import '../../admin/screens/admin_dashboard.dart';
import '../../parent/screens/parent_dashboard.dart';
import '../../settings/screens/settings_screen.dart';
import '../../student/screens/student_dashboard.dart';
import '../../teacher/screens/teacher_dashboard.dart';

enum AppRole {
  teacher('Teacher', CupertinoIcons.book),
  parent('Parent', CupertinoIcons.person_2),
  student('Student', CupertinoIcons.sparkles),
  admin('Admin', CupertinoIcons.shield);

  final String label;
  final IconData icon;
  const AppRole(this.label, this.icon);
}

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  AppRole _selectedRole = AppRole.teacher;
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _navigateToRole(AppRole role, {bool isSuperAdmin = false}) {
    ref.read(settingsProvider.notifier).setLoggedInRole(role.name);

    Widget destination;
    switch (role) {
      case AppRole.teacher:
        destination = const TeacherDashboard();
        break;
      case AppRole.parent:
        destination = const ParentDashboard();
        break;
      case AppRole.student:
        destination = const StudentDashboard();
        break;
      case AppRole.admin:
        destination = const AdminDashboard();
        break;
    }

    Navigator.of(context).pushReplacement(
      CupertinoPageRoute(
        builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final bg = isDark ? AppTheme.darkBackground : const Color(0xFFFFFFFF);
          final fg = isDark ? const Color(0xFFFFFFFF) : const Color(0xFF0A0A0A);
          final border = isDark ? AppTheme.darkHairline : const Color(0xFFE5E5EA);

          return Scaffold(
            appBar: isSuperAdmin
                ? CupertinoNavigationBar(
                    backgroundColor: bg.withOpacity(0.9),
                    border: Border(
                      bottom: BorderSide(color: border, width: 0.5),
                    ),
                    middle: Text(
                      '${role.label.toUpperCase()} PORTAL',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        letterSpacing: 0.5,
                        color: fg,
                      ),
                    ),
                    trailing: PopupMenuButton<AppRole>(
                      icon: Icon(
                        CupertinoIcons.arrow_2_squarepath,
                        color: fg,
                        size: 20,
                      ),
                      tooltip: 'Master Role Switcher',
                      onSelected: (target) =>
                          _navigateToRole(target, isSuperAdmin: true),
                      itemBuilder: (context) => AppRole.values
                          .map(
                            (r) => PopupMenuItem(
                              value: r,
                              child: Row(
                                children: [
                                  Icon(r.icon, size: 18, color: fg),
                                  const SizedBox(width: 10),
                                  Text('Switch to ${r.label}', style: TextStyle(color: fg)),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                      color: isDark ? AppTheme.darkSurface : const Color(0xFFFFFFFF),
                    ),
                  )
                : null,
            body: destination,
          );
        },
      ),
    );
  }

  Future<void> _handleLogin() async {
    final identifier = _emailController.text.trim();
    final password = _passwordController.text;

    if (identifier.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email and password.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Master Super-Admin Bypass for Developer
      if (identifier.toLowerCase() == 'harshanpv3@gmail.com') {
        await Future.delayed(const Duration(milliseconds: 300));
        if (mounted) {
          _navigateToRole(_selectedRole, isSuperAdmin: true);
        }
        return;
      }

      // Standard API Login
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        _navigateToRole(_selectedRole, isSuperAdmin: false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign in failed: ${e.toString()}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),

                  // Brand Header
                  Center(
                    child: Text(
                      'EasyLearn',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.8,
                        color: fg,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Center(
                    child: Text(
                      'AI Learning Difficulty Screening & Explainability',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: textMuted,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Monochrome Inset Card containing Dropdown + TextFields
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: border, width: 0.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Dropdown Selector Row
                        Row(
                          children: [
                            Icon(
                              _selectedRole.icon,
                              color: fg,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<AppRole>(
                                  value: _selectedRole,
                                  isExpanded: true,
                                  icon: Icon(
                                    CupertinoIcons.chevron_down,
                                    size: 16,
                                    color: fg,
                                  ),
                                  dropdownColor: surface,
                                  borderRadius: BorderRadius.circular(16),
                                  items: AppRole.values.map((role) {
                                    return DropdownMenuItem<AppRole>(
                                      value: role,
                                      child: Text(
                                        'Login as ${role.label}',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: fg,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (AppRole? newRole) {
                                    if (newRole != null) {
                                      setState(() => _selectedRole = newRole);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(height: 1, color: border, thickness: 0.5),
                        
                        // Email Field
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(fontSize: 15, color: fg),
                          decoration: InputDecoration(
                            hintText: 'Email Address',
                            hintStyle: TextStyle(fontSize: 15, color: textSubtle),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 18),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Icon(CupertinoIcons.mail, size: 20, color: textMuted),
                            ),
                            prefixIconConstraints: const BoxConstraints(minWidth: 32),
                          ),
                        ),
                        Divider(height: 1, color: border, thickness: 0.5),

                        // Password Field
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: TextStyle(fontSize: 15, color: fg),
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: TextStyle(fontSize: 15, color: textSubtle),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 18),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Icon(CupertinoIcons.lock, size: 20, color: textMuted),
                            ),
                            prefixIconConstraints: const BoxConstraints(minWidth: 32),
                            suffixIcon: CupertinoButton(
                              padding: EdgeInsets.zero,
                              minSize: 0,
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                              child: Icon(
                                _obscurePassword ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                                size: 18,
                                color: textSubtle,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Master Dev Override Hint
                  Center(
                    child: Text(
                      'Dev Tip: Use harshanpv3@gmail.com for Master Bypass',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: textSubtle,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Login Action Button
                  if (_isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: CupertinoActivityIndicator(),
                      ),
                    )
                  else
                    SizedBox(
                      height: 52,
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        color: fg,
                        borderRadius: BorderRadius.circular(9999),
                        onPressed: _handleLogin,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9999),
                            border: Border.all(color: fg, width: 1),
                          ),
                          child: Center(
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: bg,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: 32),
                  
                  // Footer Links
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: textMuted,
                        ),
                      ),
                      Container(
                        width: 4,
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: border,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Text(
                        'Request Access',
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
          ),
        ),
      ),
    );
  }
}