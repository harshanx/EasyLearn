import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:learning_difficulty_screening/main.dart';
import 'package:learning_difficulty_screening/providers/settings_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Login screen loads and displays branding', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsProvider.overrideWith((ref) => SettingsNotifier(prefs)),
        ],
        child: const MyApp(),
      ),
    );

    // Rebuild after localizations load
    await tester.pumpAndSettle();

    // Verify main branding assets and layouts are visible
    expect(find.byIcon(Icons.psychology), findsOneWidget);
    expect(find.text('DEMO ROLE BYPASS'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2)); // Email and Password inputs
  });
}
