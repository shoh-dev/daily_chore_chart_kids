import 'package:daily_chore_chart_kids/features/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/models/kid_profile.dart';
import 'core/models/chore.dart';
import 'core/models/sticker.dart';
import 'features/home/home_screen.dart';
import 'features/settings/settings_screen.dart';
import 'utils/app_themes.dart';
import 'utils/hive_keys.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(KidProfileAdapter());
  Hive.registerAdapter(ChoreAdapter());
  Hive.registerAdapter(StickerAdapter());

  // Open boxes
  await Hive.openBox<KidProfile>(HiveBoxKeys.kidProfiles);
  final choresBox = await Hive.openBox<Chore>(HiveBoxKeys.chores);
  await Hive.openBox<Sticker>(HiveBoxKeys.stickers);
  final appStateBox = await Hive.openBox(HiveBoxKeys.appState);
  final bool hasSeenOnboarding = await appStateBox.get(
    HiveBoxKeys.hasSeenOnboarding,
    defaultValue: false,
  );

  // Daily reset logic
  final today = DateTime.now();
  final lastResetString = appStateBox.get('lastResetDate') as String?;
  DateTime? lastResetDate =
      lastResetString != null ? DateTime.tryParse(lastResetString) : null;
  final isNewDay =
      lastResetDate == null ||
      lastResetDate.year != today.year ||
      lastResetDate.month != today.month ||
      lastResetDate.day != today.day;

  if (isNewDay) {
    for (var chore in choresBox.values) {
      chore.isCompleted = false;
      await chore.save();
    }
    final isoDate =
        '${today.year.toString().padLeft(4, '0')}-'
        '${today.month.toString().padLeft(2, '0')}-'
        '${today.day.toString().padLeft(2, '0')}';
    await appStateBox.put('lastResetDate', isoDate);
  }

  runApp(
    ProviderScope(child: ChoreChartApp(hasSeenOnboarding: hasSeenOnboarding)),
  );
}

class ChoreChartApp extends StatelessWidget {
  const ChoreChartApp({super.key, required this.hasSeenOnboarding});

  final bool hasSeenOnboarding;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daily Chore Chart',
      theme: AppThemes.lightTheme,
      initialRoute: hasSeenOnboarding ? '/' : '/onboarding',
      routes: {
        '/': (_) => const HomeScreen(),
        '/settings': (_) => const SettingsScreen(),
        '/onboarding': (_) => const OnboardingScreen(),
      },
    );
  }
}
