import '../entities/address_entity.dart';

abstract class AddressRepository {
  Stream<List<AddressEntity>> watchAddresses(String uid);

  Future<void> addAddress(String uid, AddressEntity address);

  Future<void> updateAddress(String uid, AddressEntity address);

  Future<void> deleteAddress(String uid, String addressId);

  /// بيحدّد عنوان معيّن كافتراضي، وبيشيل العلامة دي من أي عنوان تاني
  /// كان محدّد قبل كده — مفيش أكتر من عنوان افتراضي واحد في نفس الوقت.
  Future<void> setDefaultAddress(String uid, String addressId);
}
