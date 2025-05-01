import 'package:daily_chore_chart_kids/core/services/iap_service.dart';
import 'package:daily_chore_chart_kids/ui/widgets/math_lock_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PremiumDialog extends ConsumerWidget {
  const PremiumDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        "Unlock Premium",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Get access to all stickers, unlimited chores,\nand extra rewards for your kids!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          const Icon(Icons.star_rounded, size: 64, color: Colors.amber),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Maybe later"),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.lock_open),
          label: const Text("Upgrade Now"),
          onPressed: () async {
            final unlocked = await showMathLockDialog(context);
            if (!unlocked || !context.mounted) return;

            Navigator.pop(context);

            // Start purchase
            await IAPService.purchasePremium(
              onSuccess: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("✅ Premium Unlocked!")),
                );
              },
              onFailure: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Purchase failed.")),
                );
              },
              ref: ref,
            );
          },
        ),
      ],
    );
  }
}
