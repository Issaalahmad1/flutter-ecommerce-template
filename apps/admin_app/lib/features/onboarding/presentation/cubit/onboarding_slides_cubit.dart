import 'package:decoze_core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'onboarding_slides_state.dart';

class OnboardingSlidesCubit extends Cubit<OnboardingSlidesState> {
  final OnboardingSlideRepository _repository;

  OnboardingSlidesCubit({required OnboardingSlideRepository repository})
      : _repository = repository,
        super(const OnboardingSlidesInitial());

  Future<void> loadSlides() async {
    emit(const OnboardingSlidesLoading());
    try {
      final slides = await _repository.getSlides();
      emit(OnboardingSlidesLoaded(slides));
    } catch (e) {
      emit(const OnboardingSlidesError('حدث خطأ في تحميل شاشات الـ Onboarding.'));
    }
  }

  Future<void> createSlide(OnboardingSlideEntity slide) async {
    await _repository.createSlide(slide);
    await loadSlides();
  }

  Future<void> updateSlide(OnboardingSlideEntity slide) async {
    await _repository.updateSlide(slide);
    await loadSlides();
  }

  Future<void> deleteSlide(String id) async {
    await _repository.deleteSlide(id);
    await loadSlides();
  }
}
