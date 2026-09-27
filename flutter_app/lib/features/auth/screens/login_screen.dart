import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        builder: (_) => Scaffold(
          appBar: isSuperAdmin
              ? CupertinoNavigationBar(
                  backgroundColor: Colors.white.withOpacity(0.9),
                  border: const Border(
                    bottom: BorderSide(color: Color(0xFFE5E5EA), width: 0.5),
                  ),
                  middle: Text(
                    '${role.label.toUpperCase()} PORTAL',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      letterSpacing: 0.5,
                      color: Color(0xFF0A0A0A),
                    ),
                  ),
                  trailing: PopupMenuButton<AppRole>(
                    icon: const Icon(
                      CupertinoIcons.arrow_2_squarepath,
                      color: Color(0xFF0A0A0A),
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
                                Icon(r.icon, size: 18, color: const Color(0xFF0A0A0A)),
                                const SizedBox(width: 10),
                                Text('Switch to ${r.label}'),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                )
              : null,
          body: destination,
        ),
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
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
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
                  const Center(
                    child: Text(
                      'EasyLearn',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.8,
                        color: Color(0xFF0A0A0A),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Center(
                    child: Text(
                      'AI Learning Difficulty Screening & Explainability',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Monochrome Inset Card containing Dropdown + TextFields
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F7F9),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: const Color(0xFFE5E5EA), width: 0.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Dropdown Selector Row
                        Row(
                          children: [
                            Icon(
                              _selectedRole.icon,
                              color: const Color(0xFF0A0A0A),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<AppRole>(
                                  value: _selectedRole,
                                  isExpanded: true,
                                  icon: const Icon(
                                    CupertinoIcons.chevron_down,
                                    size: 16,
                                    color: Color(0xFF0A0A0A),
                                  ),
                                  dropdownColor: const Color(0xFFFFFFFF),
                                  borderRadius: BorderRadius.circular(16),
                                  items: AppRole.values.map((role) {
                                    return DropdownMenuItem<AppRole>(
                                      value: role,
                                      child: Text(
                                        'Login as ${role.label}',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF0A0A0A),
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

                        const Divider(color: Color(0xFFE5E5EA), height: 1),

                        // Email / User ID Field
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(fontSize: 15, color: Color(0xFF0A0A0A)),
                          decoration: InputDecoration(
                            hintText: _selectedRole == AppRole.student
                                ? 'Student ID or Roll Number'
                                : 'Email Address',
                            hintStyle: const TextStyle(
                              color: Color(0xFFA1A1A6),
                              fontSize: 15,
                            ),
                            prefixIcon: const Icon(
                              CupertinoIcons.mail,
                              color: Color(0xFF0A0A0A),
                              size: 18,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),

                        const Divider(color: Color(0xFFE5E5EA), height: 1),

                        // Password Field
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: const TextStyle(fontSize: 15, color: Color(0xFF0A0A0A)),
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: const TextStyle(
                              color: Color(0xFFA1A1A6),
                              fontSize: 15,
                            ),
                            prefixIcon: const Icon(
                              CupertinoIcons.lock,
                              color: Color(0xFF0A0A0A),
                              size: 18,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? CupertinoIcons.eye_slash
                                    : CupertinoIcons.eye,
                                color: const Color(0xFF666666),
                                size: 18,
                              ),
                              onPressed: () =>
                                  setState(() => _obscurePassword = !_obscurePassword),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Primary Sign In Button
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0A0A0A),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                      ),
                      onPressed: _isLoading ? null : _handleLogin,
                      child: _isLoading
                          ? const CupertinoActivityIndicator(color: Colors.white)
                          : Text(
                              'Sign In as ${_selectedRole.label}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.2,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Settings Link
                  Center(
                    child: TextButton.icon(
                      icon: const Icon(
                        CupertinoIcons.gear,
                        size: 16,
                        color: Color(0xFF666666),
                      ),
                      label: const Text(
                        'Display & Accessibility Settings',
                        style: TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(builder: (_) => const SettingsScreen()),
                        );
                      },
                    ),
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