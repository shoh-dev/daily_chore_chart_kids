// lib/features/home/home_screen.dart

import 'package:daily_chore_chart_kids/core/services/notification_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../core/models/chore.dart';
import '../../core/models/sticker.dart';
import '../../features/reward/reward_screen.dart';
import '../../ui/widgets/math_lock_dialog.dart';
import '../../utils/hive_keys.dart';
import '../sticker/sticker_collection_screen.dart';

final choreListProvider = StateProvider<List<Chore>>((ref) {
  final box = Hive.box<Chore>(HiveBoxKeys.chores);
  return box.values.toList();
});

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool hasShownReward = false;

  @override
  Widget build(BuildContext context) {
    final chores = ref.watch(choreListProvider);
    final appStateBox = Hive.box(HiveBoxKeys.appState);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final today = DateTime.now();
      final todayKey = "${today.year}-${today.month}-${today.day}";
      final lastRewardDate =
          appStateBox.get(HiveBoxKeys.rewardShownDate) as String?;
      final allDone = chores.isNotEmpty && chores.every((c) => c.isCompleted);

      if (allDone && !hasShownReward && lastRewardDate != todayKey) {
        hasShownReward = true;
        await appStateBox.put(HiveBoxKeys.rewardShownDate, todayKey);

        // Cancel notification
        await NotificationService.cancelAll();

        if (!context.mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RewardScreen()),
        ).then((_) => hasShownReward = false);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Today\'s Chores'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.card_giftcard),
            tooltip: 'My Stickers',
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const StickerCollectionScreen(),
                  ),
                ),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              final unlocked = await showMathLockDialog(context);

              if (unlocked && context.mounted) {
                Navigator.pushNamed(context, '/settings');
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (chores.isEmpty)
              const Expanded(child: Center(child: Text("No chores yet!")))
            else
              Expanded(
                child: ListView.separated(
                  itemCount: chores.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final chore = chores[index];
                    return GestureDetector(
                      onTap: () {
                        chore.isCompleted = !chore.isCompleted;
                        chore.save();
                        ref.read(choreListProvider.notifier).state = List.from(
                          Hive.box<Chore>(HiveBoxKeys.chores).values,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:
                              chore.isCompleted
                                  ? Colors.greenAccent
                                  : Colors.blueAccent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              chore.isCompleted
                                  ? Icons.check_circle_outline
                                  : Icons.circle_outlined,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                chore.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            if (chore.isCompleted)
                              const Icon(Icons.done, color: Colors.white),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

            if (kDebugMode) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.delete_forever),
                label: const Text("Clear All Data (Dev Only)"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  try {
                    // Clear each open box without reopening
                    await Hive.box<Chore>(HiveBoxKeys.chores).clear();
                    await Hive.box<Sticker>(HiveBoxKeys.stickers).clear();
                    await Hive.box(HiveBoxKeys.appState).clear();

                    // Update UI state
                    ref.read(choreListProvider.notifier).state = [];
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("All data cleared.")),
                      );
                    }
                  } catch (e) {
                    debugPrint('Error clearing data: $e');
                  }
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
