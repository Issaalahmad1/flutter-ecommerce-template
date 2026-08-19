import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';

import '../../../auth/presentation/screens/sign_up_screen.dart';

class _SlideData {
  final IconData icon;
  final String title;
  final String description;
  const _SlideData(this.icon, this.title, this.description);
}

const List<_SlideData> _slides = [
  _SlideData(
    Icons.explore_outlined,
    'Effortlessly organize your decor\nand shopping with decoze',
    'Confidently navigate your decor journey, ensuring a stylish '
        'and productive path to your dream space.',
  ),
  _SlideData(
    Icons.groups_outlined,
    'Stay connected with design team\nanytime, anywhere with decoze',
    'In today\'s dynamic decor world, staying connected with '
        'your design team is key to success.',
  ),
  _SlideData(
    Icons.auto_awesome_outlined,
    'Discover all the features\ndecoze has to offer',
    'Dive into decoze\'s multitude of features by exploring '
        'its diverse functionalities.',
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToSignUp() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const SignUpScreen()),
    );
  }

  void _next() {
    if (_currentPage == _slides.length - 1) {
      _goToSignUp();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;
    final isLastPage = _currentPage == _slides.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: _goToSignUp,
                  child: const Text('Skip'),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(slide.icon, size: 100, color: brand.accent),
                        const SizedBox(height: 32),
                        Text(
                          slide.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          slide.description,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: brand.textSecondary),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _slides.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 20 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? brand.accent
                        : brand.textSecondary.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: ElevatedButton(
                onPressed: _next,
                child: Text(isLastPage ? 'Get Started' : 'Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}