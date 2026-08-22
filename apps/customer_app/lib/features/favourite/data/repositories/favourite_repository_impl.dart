import 'package:decoze_core/core.dart';

import '../datasources/favourite_remote_datasource.dart';

class FavouriteRepositoryImpl implements FavouriteRepository {
  final FavouriteRemoteDataSource remoteDataSource;

  FavouriteRepositoryImpl({FavouriteRemoteDataSource? remoteDataSource})
      : remoteDataSource = remoteDataSource ?? FavouriteRemoteDataSource();

  @override
  Stream<List<String>> watchFavoriteIds(String uid) {
    return remoteDataSource.watchFavoriteIds(uid);
  }

  @override
  Future<void> addFavorite(String uid, String productId) {
    return remoteDataSource.addFavorite(uid, productId);
  }

  @override
  Future<void> removeFavorite(String uid, String productId) {
    return remoteDataSource.removeFavorite(uid, productId);
  }
}