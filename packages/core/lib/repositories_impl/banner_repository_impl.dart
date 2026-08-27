import '../entities/banner_entity.dart';
import '../repositories/banner_repository.dart';
import '../datasources/banner_remote_datasource.dart';

class BannerRepositoryImpl implements BannerRepository {
  final BannerRemoteDataSource remoteDataSource;

  BannerRepositoryImpl({BannerRemoteDataSource? remoteDataSource})
      : remoteDataSource = remoteDataSource ?? BannerRemoteDataSource();

  @override
Future<List<BannerEntity>> getBanners({bool activeOnly = true}) async {
  final docs = await remoteDataSource.getBanners();
  final banners = docs.map((d) => BannerEntity.fromJson(d.id, d.data())).toList();

  if (!activeOnly) return banners; // لوحة الأدمن بتشوف كل حاجة (حتى المنتهي)

  final now = DateTime.now();
  return banners.where((b) {
    if (!b.isActive) return false;
    if (b.expiresAt != null && b.expiresAt!.isBefore(now)) return false;
    return true;
  }).toList();
}

  @override
  Future<void> createBanner(BannerEntity banner) {
    return remoteDataSource.createBanner(banner.toJson());
  }

  @override
  Future<void> updateBanner(BannerEntity banner) {
    return remoteDataSource.updateBanner(banner.id, banner.toJson());
  }

  @override
  Future<void> deleteBanner(String id) {
    return remoteDataSource.deleteBanner(id);
  }
}