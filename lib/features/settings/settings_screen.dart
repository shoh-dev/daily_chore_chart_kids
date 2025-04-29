import 'package:daily_chore_chart_kids/core/models/sticker.dart';
import 'package:daily_chore_chart_kids/core/services/iap_service.dart';
import 'package:daily_chore_chart_kids/features/home/home_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../core/models/chore.dart';
import '../../utils/hive_keys.dart';
import '../premium/premium_dialog.dart';
import 'add_edit_chore_screen.dart';

final settingsChoreListProvider = StateProvider<List<Chore>>((ref) {
  return Hive.box<Chore>(HiveBoxKeys.chores).values.toList();
});

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const int freeChoreLimit = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chores = ref.watch(settingsChoreListProvider);
    final isPremium =
        Hive.box(HiveBoxKeys.appState).get(HiveBoxKeys.hasPremium) == true;

    return Scaffold(
      appBar: AppBar(title: const Text('Parent Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Existing chore list...
          ...chores.map((chore) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.orange[100],
              child: ListTile(
                title: Text(
                  chore.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await chore.delete();

                    final updated =
                        Hive.box<Chore>(HiveBoxKeys.chores).values.toList();

                    ref.read(settingsChoreListProvider.notifier).state =
                        updated;
                    ref.read(choreListProvider.notifier).state = updated;
                  },
                ),
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddEditChoreScreen(chore: chore),
                      ),
                    ),
              ),
            );
          }),
          const SizedBox(height: 24),

          // Add new chore (limited if not premium)
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: Text(
              isPremium
                  ? 'Add Chore'
                  : 'Add Chore (${chores.length}/$freeChoreLimit)',
            ),
            onPressed: () {
              if (!isPremium && chores.length >= freeChoreLimit) {
                showDialog(
                  context: context,
                  builder: (_) => const PremiumDialog(),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddEditChoreScreen()),
                );
              }
            },
          ),

          const Divider(height: 32),

          // Unlock Premium & Restore (unchanged)...
          ListTile(
            leading: const Icon(Icons.star, color: Colors.amber),
            title: const Text('Unlock Premium'),
            subtitle: const Text('Unlimited chores, stickers & profiles'),
            trailing:
                isPremium
                    ? const Icon(Icons.check, color: Colors.green)
                    : const Icon(Icons.lock_open),
            onTap: () {
              if (!isPremium) {
                showDialog(
                  context: context,
                  builder: (_) => const PremiumDialog(),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.restore),
            title: const Text('Restore Purchase'),
            onTap: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Checking for previous purchases..."),
                ),
              );

              await IAPService.restorePurchases(
                onSuccess: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("✅ Premium restored!")),
                  );
                },
                onNothingRestored: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("No previous purchase found."),
                    ),
                  );
                },
                onFailure: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Failed to restore purchase."),
                    ),
                  );
                },
              );
            },
          ),

          if (kDebugMode) ...[
            const Divider(height: 32),
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
    );
  }
}
