import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = isDark ? AppTheme.darkBackground : const Color(0xFFFFFFFF);
    final surface = isDark ? AppTheme.darkSurface : const Color(0xFFF7F7F9);
    final fg = isDark ? const Color(0xFFFFFFFF) : const Color(0xFF0A0A0A);
    final border = isDark ? AppTheme.darkHairline : const Color(0xFFE5E5EA);
    final textMuted = isDark ? AppTheme.ashGray : const Color(0xFF666666);
    final textSubtle = isDark ? AppTheme.slateGray : const Color(0xFFA1A1A6);

    return Scaffold(
      backgroundColor: bg,
      appBar: CupertinoNavigationBar(
        backgroundColor: bg.withOpacity(0.9),
        border: Border(bottom: BorderSide(color: border, width: 0.5)),
        middle: Text(
          localizations.settings.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            letterSpacing: 0.5,
            color: fg,
          ),
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.back, color: fg),
          onPressed: () => Navigator.pop(context),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text('Done', style: TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: 15)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          children: [
            // Header Title Block
            Text(
              'ACCESSIBILITY & DISPLAY PREFERENCES',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: textMuted,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Settings & Accessibility',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
                color: fg,
              ),
            ),
            const SizedBox(height: 16),

            // Live Dynamic Text Preview Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: border, width: 0.5),
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
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'LIVE PREVIEW',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.0,
                              color: textMuted,
                            ),
                          ),
                        ],
                      ),
                      Icon(CupertinoIcons.textformat_size, size: 14, color: textSubtle),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'The quick brown fox jumps over the lazy dog.',
                    style: TextStyle(
                      fontSize: 16 * settings.textSizeMultiplier,
                      color: fg,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Reading metrics and visual tracking exercises will render text at this exact scale.',
                    style: TextStyle(
                      fontSize: 12 * settings.textSizeMultiplier,
                      color: textMuted,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Base Settings Group
            Container(
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: border, width: 0.5),
              ),
              child: Column(
                children: [
                  // High Contrast Mode Toggle
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: fg,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(CupertinoIcons.circle_lefthalf_fill, size: 16, color: bg),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'High Contrast Mode',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: fg,
                                ),
                              ),
                              Text(
                                'Increases border thickness & stroke weight.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        CupertinoSwitch(
                          value: settings.highContrast,
                          activeColor: fg,
                          trackColor: border,
                          thumbColor: bg,
                          onChanged: (val) => notifier.setHighContrast(val),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 60),
                    child: Divider(height: 1, color: border, thickness: 0.5),
                  ),

                  // Reduce Motion Toggle
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: border,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(CupertinoIcons.wind, size: 16, color: fg),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Reduce Motion',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: fg,
                                ),
                              ),
                              Text(
                                'Minimizes animations and screen transitions.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        CupertinoSwitch(
                          value: settings.reduceMotion,
                          activeColor: fg,
                          trackColor: border,
                          thumbColor: bg,
                          onChanged: (val) => notifier.setReduceMotion(val),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 60),
                    child: Divider(height: 1, color: border, thickness: 0.5),
                  ),

                  // Theme Mode Toggle
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: fg,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(CupertinoIcons.moon_fill, size: 16, color: bg),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Dark Mode',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: fg,
                                ),
                              ),
                              Text(
                                'Switch between light and dark themes.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        CupertinoSwitch(
                          value: settings.themeMode == ThemeMode.dark,
                          activeColor: fg,
                          trackColor: border,
                          thumbColor: bg,
                          onChanged: (val) {
                            notifier.setThemeMode(val ? ThemeMode.dark : ThemeMode.light);
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 60),
                    child: Divider(height: 1, color: border, thickness: 0.5),
                  ),

                  // Language Selection
                  CupertinoButton(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    onPressed: () => _showLanguagePicker(context, settings, notifier, bg, surface, fg, border, textMuted),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: border,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(CupertinoIcons.globe, size: 16, color: fg),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                localizations.language,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: fg,
                                ),
                              ),
                              Text(
                                _getLanguageName(settings.locale.languageCode),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(CupertinoIcons.chevron_right, size: 16, color: textSubtle),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Display Scaling
            Text(
              'DISPLAY SCALING',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
                color: textMuted,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: border, width: 0.5),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(CupertinoIcons.textformat_size, size: 16, color: textMuted),
                      Text(
                        '${(settings.textSizeMultiplier * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: fg,
                        ),
                      ),
                      Icon(CupertinoIcons.textformat_size, size: 24, color: fg),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 24,
                    child: SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 2.0,
                        activeTrackColor: fg,
                        inactiveTrackColor: border,
                        thumbColor: fg,
                        overlayColor: fg.withOpacity(0.1),
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0),
                      ),
                      child: Slider(
                        value: settings.textSizeMultiplier,
                        min: 0.8,
                        max: 1.5,
                        divisions: 7,
                        onChanged: (val) => notifier.setTextSizeMultiplier(val),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Adjust to increase legibility across clinical and interactive screens.',
                    style: TextStyle(fontSize: 11, color: textMuted),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // App Version Info
            Center(
              child: Column(
                children: [
                  Text(
                    'EasyLearn System',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: fg,
                    ),
                  ),
                  Text(
                    'Phase 1 Architecture • Version 1.0.0 (Build 42)',
                    style: TextStyle(
                      fontSize: 11,
                      color: textMuted,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'hi': return 'हिंदी (Hindi)';
      case 'ta': return 'தமிழ் (Tamil)';
      case 'ml': return 'മലയാളം (Malayalam)';
      case 'te': return 'తెలుగు (Telugu)';
      case 'kn': return 'ಕನ್ನಡ (Kannada)';
      case 'mr': return 'मराठी (Marathi)';
      case 'bn': return 'বাংলা (Bengali)';
      case 'gu': return 'ગુજરાતી (Gujarati)';
      default: return 'English';
    }
  }

  void _showLanguagePicker(BuildContext context, SettingsState settings, SettingsNotifier notifier, Color bg, Color surface, Color fg, Color border, Color textMuted) {
    final languages = [
      {'code': 'en', 'name': 'English'},
      {'code': 'hi', 'name': 'हिंदी (Hindi)'},
      {'code': 'ta', 'name': 'தமிழ் (Tamil)'},
      {'code': 'ml', 'name': 'മലയാളം (Malayalam)'},
      {'code': 'te', 'name': 'తెలుగు (Telugu)'},
      {'code': 'kn', 'name': 'ಕನ್ನಡ (Kannada)'},
      {'code': 'mr', 'name': 'मराठी (Marathi)'},
      {'code': 'bn', 'name': 'বাংলা (Bengali)'},
      {'code': 'gu', 'name': 'ગુજરાતી (Gujarati)'},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              'Select Language',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: fg,
              ),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: languages.length,
                itemBuilder: (context, index) {
                  final lang = languages[index];
                  final isSelected = lang['code'] == settings.locale.languageCode;
                  return CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      notifier.setLocale(Locale(lang['code']!));
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            lang['name']!,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                              color: isSelected ? fg : textMuted,
                            ),
                          ),
                          if (isSelected)
                            Icon(CupertinoIcons.checkmark_alt, color: fg, size: 20),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
