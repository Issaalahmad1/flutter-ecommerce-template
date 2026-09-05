import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class _SlideData {
  final String? assetPath;
  final String? imageUrl;
  final String title;
  final String description;

  const _SlideData({this.assetPath, this.imageUrl, required this.title, required this.description});

  Widget buildImage() {
    if (imageUrl != null) {
      return Image.network(imageUrl!, fit: BoxFit.contain);
    }
    return Image.asset(assetPath!, fit: BoxFit.contain);
  }
}

/// 3 سلايدات جاهزة تظهر فورًا (مفيش انتظار)، ولو الأدمن ضاف سلايدات
/// مخصّصة من لوحة التحكم بتتحمّل في الخلفية وتستبدلها تلقائيًا.
List<_SlideData> _defaultSlides(AppStrings strings) => [
  _SlideData(
    assetPath: 'assets/onboarding/onboarding1.png',
    title: strings.onboardingTitle1,
    description: strings.onboardingDescription1,
  ),
  _SlideData(
    assetPath: 'assets/onboarding/Group 5407.png',
    title: strings.onboardingTitle2,
    description: strings.onboardingDescription2,
  ),
  _SlideData(
    assetPath: 'assets/onboarding/Group 5408.png',
    title: strings.onboardingTitle3,
    description: strings.onboardingDescription3,
  ),
];

List<_SlideData> _remoteSlidesToData(List<OnboardingSlideEntity> slides, String languageCode) =>
    slides
        .map(
          (s) => _SlideData(
            imageUrl: s.imageUrl,
            title: s.title(languageCode),
            description: s.description(languageCode),
          ),
        )
        .toList();

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;
  List<OnboardingSlideEntity> _remoteSlides = [];

  @override
  void initState() {
    super.initState();
    _loadRemoteSlides();
  }

  Future<void> _loadRemoteSlides() async {
    try {
      final slides = await OnboardingSlideRepositoryImpl().getSlides();
      if (mounted && slides.isNotEmpty) {
        // بنرجّع لأول سلايد عشان نضمن إن _currentPage ميبقاش خارج حدود
        // القائمة الجديدة لو عدد السلايدات المخصّصة مختلف عن الافتراضي.
        setState(() {
          _remoteSlides = slides;
          _currentPage = 0;
        });
        if (_pageController.hasClients) {
          _pageController.jumpToPage(0);
        }
      }
    } catch (_) {
      // فشل التحميل — نفضل عارضين السلايدات الافتراضية من غير أي إزعاج
      // للمستخدم.
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToSignUp() {
    context.go('/sign-up');
  }

  void _next(int slideCount) {
    if (_currentPage == slideCount - 1) {
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
    final strings = context.strings;
    final languageCode = Localizations.localeOf(context).languageCode;
    final slides = _remoteSlides.isNotEmpty
        ? _remoteSlidesToData(_remoteSlides, languageCode)
        : _defaultSlides(strings);
    final isLastPage = _currentPage == slides.length - 1;

    return Scaffold(
      body: SafeArea(
        child: ResponsiveContent(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: slides.length,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  itemBuilder: (context, index) {
                    final slide = slides[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          // Expanded (مش حجم ثابت) عشان الصورة تنكمش لو
                          // المساحة الرأسية المتاحة قليلة (شاشات قصيرة)
                          // بدل ما تعمل Overflow.
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: slide.buildImage(),
                            ),
                          ),
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
                  slides.length,
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
                  onPressed: () => _next(slides.length),
                  child: Text(isLastPage ? strings.getStarted : strings.next),
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
                  child: Text(strings.skip),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
