import 'package:decoze_core/core.dart';

class AddressRepositoryImpl implements AddressRepository {
  final AddressRemoteDataSource remoteDataSource;

  AddressRepositoryImpl({AddressRemoteDataSource? remoteDataSource})
      : remoteDataSource = remoteDataSource ?? AddressRemoteDataSource();

  @override
  Stream<List<AddressEntity>> watchAddresses(String uid) {
    return remoteDataSource
        .watchAddresses(uid)
        .map((docs) => docs.map((d) => AddressEntity.fromJson(d.id, d.data())).toList());
  }

  @override
  Future<void> addAddress(String uid, AddressEntity address) {
    return remoteDataSource.addAddress(uid, address.toJson());
  }

  @override
  Future<void> updateAddress(String uid, AddressEntity address) {
    return remoteDataSource.updateAddress(uid, address.id, address.toJson());
  }

  @override
  Future<void> deleteAddress(String uid, String addressId) {
    return remoteDataSource.deleteAddress(uid, addressId);
  }

  @override
  Future<void> setDefaultAddress(String uid, String addressId) {
    return remoteDataSource.setDefaultAddress(uid, addressId);
  }
}
