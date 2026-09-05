import 'package:decoze_core/core.dart';

class OnboardingSlideRepositoryImpl implements OnboardingSlideRepository {
  final OnboardingSlideRemoteDataSource remoteDataSource;

  OnboardingSlideRepositoryImpl({OnboardingSlideRemoteDataSource? remoteDataSource})
      : remoteDataSource = remoteDataSource ?? OnboardingSlideRemoteDataSource();

  @override
  Future<List<OnboardingSlideEntity>> getSlides() async {
    final docs = await remoteDataSource.getSlides();
    return docs.map((doc) => OnboardingSlideEntity.fromJson(doc.id, doc.data())).toList();
  }

  @override
  Future<void> createSlide(OnboardingSlideEntity slide) {
    return remoteDataSource.createSlide(slide.toJson());
  }

  @override
  Future<void> updateSlide(OnboardingSlideEntity slide) {
    return remoteDataSource.updateSlide(slide.id, slide.toJson());
  }

  @override
  Future<void> deleteSlide(String id) {
    return remoteDataSource.deleteSlide(id);
  }
}
