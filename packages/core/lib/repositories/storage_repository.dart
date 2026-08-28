import 'dart:typed_data';

abstract class StorageRepository {
  /// بيرفع بايتات صورة لمسار معين في Firebase Storage، وبيرجّع
  /// الرابط العام (Download URL) اللي نقدر نخزّنه في Firestore.
  Future<String> uploadImage({
    required Uint8List bytes,
    required String path,
  });
}