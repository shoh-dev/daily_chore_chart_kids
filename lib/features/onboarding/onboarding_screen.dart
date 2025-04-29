// lib/features/onboarding/onboarding_screen.dart

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../utils/hive_keys.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  final List<_OnboardPageData> _pages = [
    _OnboardPageData(
      title: "Let's make chores fun!",
      image: Icons.star_rounded,
      description: "Build great habits with a little joy each day.",
    ),
    _OnboardPageData(
      title: "Complete chores",
      image: Icons.check_circle,
      description: "Tap to mark chores done when finished.",
    ),
    _OnboardPageData(
      customContent: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Earn These Cute Stickers!",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children:
                [
                  "space_cat",
                  "rainbow_bunny",
                  "super_star",
                  "smiley_cloud",
                  "rocket_sloth",
                  "bubble_fish",
                ].map((name) {
                  return Image.asset(
                    'assets/stickers/$name.png',
                    width: 60,
                    height: 60,
                  );
                }).toList(),
          ),
          const SizedBox(height: 24),
          const Text(
            "Collect them all by completing your daily chores!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    ),
  ];

  void _finishOnboarding() async {
    await Hive.box(
      HiveBoxKeys.appState,
    ).put(HiveBoxKeys.hasSeenOnboarding, true);
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child:
                        page.customContent != null
                            ? Center(child: page.customContent!)
                            : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  page.image!,
                                  size: 100,
                                  color: Colors.orange[300],
                                ),
                                const SizedBox(height: 32),
                                Text(
                                  page.title!,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  page.description!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SmoothPageIndicator(
                    controller: _controller,
                    count: _pages.length,
                    effect: WormEffect(
                      activeDotColor: Colors.orange.shade400,
                      dotHeight: 12,
                      dotWidth: 12,
                    ),
                  ),
                  ElevatedButton(
                    onPressed:
                        _page == _pages.length - 1
                            ? _finishOnboarding
                            : () {
                              _controller.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            },
                    child: Text(
                      _page == _pages.length - 1 ? "Get Started" : "Next",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardPageData {
  final String? title;
  final String? description;
  final IconData? image;
  final Widget? customContent;

  _OnboardPageData({
    this.title,
    this.description,
    this.image,
    this.customContent,
  });
}
