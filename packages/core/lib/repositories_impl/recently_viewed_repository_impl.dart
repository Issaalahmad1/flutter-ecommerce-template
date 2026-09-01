import 'package:decoze_core/core.dart';

class RecentlyViewedRepositoryImpl implements RecentlyViewedRepository {
  final RecentlyViewedRemoteDataSource remoteDataSource;

  RecentlyViewedRepositoryImpl({RecentlyViewedRemoteDataSource? remoteDataSource})
      : remoteDataSource = remoteDataSource ?? RecentlyViewedRemoteDataSource();

  @override
  Stream<List<String>> watchRecentlyViewedIds(String uid) {
    return remoteDataSource.watchRecentlyViewedIds(uid);
  }

  @override
  Future<void> recordView(String uid, String productId) {
    return remoteDataSource.recordView(uid, productId);
  }
}
