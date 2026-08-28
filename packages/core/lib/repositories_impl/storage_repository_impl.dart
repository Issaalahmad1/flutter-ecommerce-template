import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

import '../repositories/storage_repository.dart';

class StorageRepositoryImpl implements StorageRepository {
  final FirebaseStorage storage;

  StorageRepositoryImpl({FirebaseStorage? storage})
      : storage = storage ?? FirebaseStorage.instance;

  @override
  Future<String> uploadImage({
    required Uint8List bytes,
    required String path,
  }) async {
    final ref = storage.ref().child(path);
    final task = await ref.putData(bytes);
    return task.ref.getDownloadURL();
  }
}