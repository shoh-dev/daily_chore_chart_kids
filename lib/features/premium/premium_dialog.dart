import 'package:flutter/material.dart';

class PremiumDialog extends StatelessWidget {
  const PremiumDialog({super.key});

  @override
  Widget build(BuildContext context) {
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
          onPressed: () {
            // TODO: Hook into IAP flow
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
