import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class _SlideData {
  final String icon;
  final String title;
  final String description;
  const _SlideData(this.icon, this.title, this.description);
}

const List<_SlideData> _slides = [
  _SlideData(
    'assets/onboarding/onboarding1.png',
    'Effortlessly organize your decor \nand shopping with decoze',
    'Confidently navigate your decor journey, ensuring a \nstylish and productive path to your dream space \nwith decoze',
  ),
  _SlideData(
    'assets/onboarding/Group 5407.png',
    'Stay connected with design team \nanytime, anywhere with decoze',
    "In today's dynamic decor world, staying connected \nwith your design team is key to success with \ndecoze.",
  ),
  _SlideData(
    'assets/onboarding/Group 5408.png',
    'Discover all the features \ndecoze has to offer',
    "Dive into decoze's multitude of features by \nexploring its diverse functionalities.",
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
    context.go('/sign-up');
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
                        Image.asset(slide.icon),
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
            Padding(
              padding: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: brand.surface,
                  foregroundColor: brand.accent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                    side: BorderSide(color: brand.textSecondary),
                  ),
                ),
                onPressed: _goToSignUp,
                child: Text("Skip"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
