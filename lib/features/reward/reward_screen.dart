import 'package:daily_chore_chart_kids/core/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';

import '../../core/models/sticker.dart';
import '../../utils/hive_keys.dart';
import '../sticker/sticker_collection_screen.dart';
import '../premium/premium_dialog.dart';

class RewardScreen extends StatefulWidget {
  const RewardScreen({super.key});

  @override
  State<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  Sticker? earnedSticker;
  late ConfettiController _confetti;

  final List<String> _stickerNames = [
    'Space Cat',
    'Rainbow Bunny',
    'Super Star',
    'Smiley Cloud',
    'Rocket Sloth',
    'Bubble Fish',
  ];

  final List<String> _stickerImages = [
    'assets/stickers/space_cat.png',
    'assets/stickers/rainbow_bunny.png',
    'assets/stickers/super_star.png',
    'assets/stickers/smiley_cloud.png',
    'assets/stickers/rocket_sloth.png',
    'assets/stickers/bubble_fish.png',
  ];

  final int freeStickerLimit = 3;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 3));
    _unlockSticker();
    _confetti.play();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  void _unlockSticker() async {
    Hive.box<Sticker>(HiveBoxKeys.stickers);
    final isPremium =
        Hive.box(HiveBoxKeys.appState).get(HiveBoxKeys.hasPremium) == true;

    final availableCount = isPremium ? _stickerNames.length : freeStickerLimit;
    final index = DateTime.now().millisecondsSinceEpoch % availableCount;

    // If not premium and rolled locked sticker, redirect to upgrade
    if (!isPremium && index >= freeStickerLimit) {
      Future.delayed(Duration.zero, () {
        if (mounted) {
          showDialog(
            context: context,
            builder: (_) => const PremiumDialog(),
          ).then((_) {
            if (mounted) {
              Navigator.pop(context);
            }
          });
        }
      });
      return;
    }

    final newSticker = Sticker(
      id: const Uuid().v4(),
      name: _stickerNames[index],
      imagePath: _stickerImages[index],
      earned: true,
    );

    await _completeRewardFlow(newSticker);
  }

  Future<void> _completeRewardFlow(Sticker newSticker) async {
    final box = Hive.box<Sticker>(HiveBoxKeys.stickers);
    await box.put(newSticker.id, newSticker);

    setState(() {
      earnedSticker = newSticker;
    });

    // Schedule tomorrow’s reminder
    await NotificationService.scheduleDailyReminder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (earnedSticker != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "🎉 Awesome Job!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: Colors.deepOrange[400],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "You just earned a new sticker!",
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 32),
                    if (earnedSticker != null)
                      Image.asset(
                        earnedSticker!.imagePath,
                        width: 140,
                        height: 140,
                      ).animate().scale(
                        duration: 600.ms,
                        curve: Curves.elasticOut,
                        begin: const Offset(0.5, 0.5),
                        end: const Offset(1.0, 1.0),
                      ),
                    const SizedBox(height: 16),
                    if (earnedSticker != null)
                      Text(
                        earnedSticker!.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Back to Chores"),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const StickerCollectionScreen(),
                          ),
                        );
                      },
                      child: const Text("View My Stickers"),
                    ),
                  ],
                ),
              ),
            ),

          // Confetti from top
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confetti,
              blastDirection: 3.14 / 2,
              maxBlastForce: 20,
              minBlastForce: 8,
              emissionFrequency: 0.1,
              numberOfParticles: 20,
              gravity: 0.4,
              shouldLoop: false,
            ),
          ),
        ],
      ),
    );
  }
}
