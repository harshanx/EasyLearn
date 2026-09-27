import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learning_difficulty_screening/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBackground : AppTheme.offWhiteSurface,
      appBar: AppBar(
        backgroundColor: (isDark ? AppTheme.darkBackground : AppTheme.offWhiteSurface).withOpacity(0.9),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.chevron_back, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          localizations.settings,
          style: GoogleFonts.manrope(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Done',
              style: GoogleFonts.hankenGrotesk(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Title Block
            Text(
              'ACCESSIBILITY & DISPLAY PREFERENCES',
              style: GoogleFonts.hankenGrotesk(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: AppTheme.slateGray,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Settings & Accessibility',
              style: GoogleFonts.manrope(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),

            // Live Dynamic Text Preview Card
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppTheme.pitchBlack,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'LIVE PREVIEW',
                            style: GoogleFonts.hankenGrotesk(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                              color: AppTheme.slateGray,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          color: isDark ? AppTheme.darkSurfaceContainer : AppTheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: Text(
                          'Scale: ${(settings.textSizeMultiplier * 100).toInt()}%',
                          style: GoogleFonts.hankenGrotesk(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.darkSurfaceContainer : AppTheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'The quick brown fox jumps over the lazy dog. AI empowers personalized learning.',
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 14 * settings.textSizeMultiplier,
                        height: 1.45,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Inset Grouped Section 1: Appearance & Theme
            Text(
              'CANVAS PALETTE & THEME',
              style: GoogleFonts.hankenGrotesk(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: AppTheme.slateGray,
              ),
            ),
            const SizedBox(height: 8),
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
                children: [
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.light,
                    groupValue: settings.themeMode,
                    title: Text('Pure White (Light Mode)', style: GoogleFonts.hankenGrotesk(fontSize: 14, fontWeight: FontWeight.w600)),
                    activeColor: isDark ? AppTheme.pureWhite : AppTheme.pitchBlack,
                    onChanged: (mode) { if (mode != null) notifier.setThemeMode(mode); },
                  ),
                  const Divider(height: 1),
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.dark,
                    groupValue: settings.themeMode,
                    title: Text('Deep OLED (Dark Mode)', style: GoogleFonts.hankenGrotesk(fontSize: 14, fontWeight: FontWeight.w600)),
                    activeColor: isDark ? AppTheme.pureWhite : AppTheme.pitchBlack,
                    onChanged: (mode) { if (mode != null) notifier.setThemeMode(mode); },
                  ),
                  const Divider(height: 1),
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.system,
                    groupValue: settings.themeMode,
                    title: Text('System Automatic', style: GoogleFonts.hankenGrotesk(fontSize: 14, fontWeight: FontWeight.w600)),
                    activeColor: isDark ? AppTheme.pureWhite : AppTheme.pitchBlack,
                    onChanged: (mode) { if (mode != null) notifier.setThemeMode(mode); },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Inset Grouped Section 2: Reading & Typography Scale
            Text(
              'READING & TYPOGRAPHY SCALE',
              style: GoogleFonts.hankenGrotesk(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: AppTheme.slateGray,
              ),
            ),
            const SizedBox(height: 8),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Text Scale',
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        '${(settings.textSizeMultiplier * 100).toInt()}%',
                        style: GoogleFonts.hankenGrotesk(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.slateGray,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: isDark ? AppTheme.pureWhite : AppTheme.pitchBlack,
                      inactiveTrackColor: isDark ? AppTheme.darkSurfaceContainer : AppTheme.surfaceContainerHigh,
                      thumbColor: isDark ? AppTheme.pureWhite : AppTheme.pitchBlack,
                      trackHeight: 4,
                    ),
                    child: Slider(
                      min: 1.0,
                      max: 1.4,
                      divisions: 2,
                      value: settings.textSizeMultiplier,
                      onChanged: (val) => notifier.setTextSizeMultiplier(val),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Normal (100%)', style: GoogleFonts.hankenGrotesk(fontSize: 11, color: AppTheme.slateGray)),
                      Text('Large (120%)', style: GoogleFonts.hankenGrotesk(fontSize: 11, color: AppTheme.slateGray)),
                      Text('Extra (140%)', style: GoogleFonts.hankenGrotesk(fontSize: 11, color: AppTheme.slateGray)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Inset Grouped Section 3: High Contrast & Motion
            Text(
              'ACCESSIBILITY & SENSORY CALM',
              style: GoogleFonts.hankenGrotesk(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: AppTheme.slateGray,
              ),
            ),
            const SizedBox(height: 8),
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
                children: [
                  SwitchListTile(
                    title: Text('High-Contrast Outlines', style: GoogleFonts.hankenGrotesk(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: Text('Enforce crisp 1.5pt borders around interactive components.', style: GoogleFonts.hankenGrotesk(fontSize: 12, color: AppTheme.slateGray)),
                    activeColor: isDark ? AppTheme.pureWhite : AppTheme.pitchBlack,
                    value: settings.highContrast,
                    onChanged: (val) => notifier.setHighContrast(val),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: Text('Reduce Motion & Sensory Calm', style: GoogleFonts.hankenGrotesk(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: Text('Minimizes spring physics and high-frequency visual stimuli.', style: GoogleFonts.hankenGrotesk(fontSize: 12, color: AppTheme.slateGray)),
                    activeColor: isDark ? AppTheme.pureWhite : AppTheme.pitchBlack,
                    value: settings.reduceMotion,
                    onChanged: (val) => notifier.setReduceMotion(val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Inset Grouped Section 4: Localization
            Text(
              'LOCALIZATION & TRILINGUAL SUPPORT',
              style: GoogleFonts.hankenGrotesk(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: AppTheme.slateGray,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkSurface : AppTheme.pureWhite,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppTheme.darkHairline : AppTheme.paleHairline,
                  width: 0.5,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: settings.locale.languageCode,
                  icon: const Icon(CupertinoIcons.chevron_down, size: 16, color: AppTheme.slateGray),
                  onChanged: (langCode) {
                    if (langCode != null) {
                      notifier.setLocale(Locale(langCode));
                    }
                  },
                  items: [
                    DropdownMenuItem(
                      value: 'en',
                      child: Text('English (US)', style: GoogleFonts.hankenGrotesk(fontSize: 14, fontWeight: FontWeight.w600)),
                    ),
                    DropdownMenuItem(
                      value: 'ml',
                      child: Text('മലയാളം (Malayalam)', style: GoogleFonts.hankenGrotesk(fontSize: 14, fontWeight: FontWeight.w600)),
                    ),
                    DropdownMenuItem(
                      value: 'hi',
                      child: Text('हिन्दी (Hindi)', style: GoogleFonts.hankenGrotesk(fontSize: 14, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }
}
