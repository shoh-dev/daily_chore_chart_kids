import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../core/models/sticker.dart';
import '../../utils/hive_keys.dart';
import '../premium/premium_dialog.dart';

class StickerCollectionScreen extends StatelessWidget {
  const StickerCollectionScreen({super.key});

  static const int freeStickerLimit = 3;

  final List<String> _stickerNames = const [
    'Space Cat',
    'Rainbow Bunny',
    'Super Star',
    'Smiley Cloud',
    'Rocket Sloth',
    'Bubble Fish',
  ];

  final List<String> _stickerImages = const [
    'assets/stickers/space_cat.png',
    'assets/stickers/rainbow_bunny.png',
    'assets/stickers/super_star.png',
    'assets/stickers/smiley_cloud.png',
    'assets/stickers/rocket_sloth.png',
    'assets/stickers/bubble_fish.png',
  ];

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Sticker>(HiveBoxKeys.stickers);
    final isPremium =
        Hive.box(HiveBoxKeys.appState).get(HiveBoxKeys.hasPremium) == true;

    return Scaffold(
      appBar: AppBar(title: const Text("My Stickers")),
      backgroundColor: Colors.yellow[50],
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _stickerNames.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (_, index) {
          final name = _stickerNames[index];
          final image = _stickerImages[index];
          final isUnlocked = isPremium || index < freeStickerLimit;
          final isEarned = box.values.any((s) => s.name == name);

          Widget display = Image.asset(
            image,
            width: 60,
            height: 60,
            fit: BoxFit.contain,
          );

          // Locked (premium-only)
          if (!isUnlocked) {
            display = Stack(
              children: [
                display,
                Container(color: Colors.white.withOpacity(0.6)),
                const Center(
                  child: Icon(Icons.lock, size: 32, color: Colors.red),
                ),
              ],
            );
          }
          // Not yet earned (free)
          else if (!isEarned) {
            display = Opacity(opacity: 0.4, child: display);
          }

          return GestureDetector(
            onTap: () {
              if (!isUnlocked) {
                showDialog(
                  context: context,
                  builder: (_) => const PremiumDialog(),
                );
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                display,
                const SizedBox(height: 8),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
