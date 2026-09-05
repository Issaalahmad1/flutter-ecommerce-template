import 'package:cloud_firestore/cloud_firestore.dart';

class OnboardingSlideRemoteDataSource {
  final FirebaseFirestore firestore;

  OnboardingSlideRemoteDataSource({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getSlides() async {
    final snapshot = await firestore.collection('onboardingSlides').orderBy('order').get();
    return snapshot.docs;
  }

  Future<void> createSlide(Map<String, dynamic> data) {
    return firestore.collection('onboardingSlides').add(data);
  }

  Future<void> updateSlide(String id, Map<String, dynamic> data) {
    return firestore.collection('onboardingSlides').doc(id).update(data);
  }

  Future<void> deleteSlide(String id) {
    return firestore.collection('onboardingSlides').doc(id).delete();
  }
}
