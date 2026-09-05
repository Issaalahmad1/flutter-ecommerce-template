import '../entities/onboarding_slide_entity.dart';

abstract class OnboardingSlideRepository {
  Future<List<OnboardingSlideEntity>> getSlides();

  /// دوال أدمن — مطلوبة لـ admin_app بس.
  Future<void> createSlide(OnboardingSlideEntity slide);
  Future<void> updateSlide(OnboardingSlideEntity slide);
  Future<void> deleteSlide(String id);
}
