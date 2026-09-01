import 'package:cloud_firestore/cloud_firestore.dart';

class AddressRemoteDataSource {
  final FirebaseFirestore firestore;

  AddressRemoteDataSource({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _addressesRef(String uid) =>
      firestore.collection('users').doc(uid).collection('addresses');

  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> watchAddresses(String uid) {
    return _addressesRef(uid).snapshots().map((snapshot) => snapshot.docs);
  }

  Future<void> addAddress(String uid, Map<String, dynamic> data) async {
    // لو ده أول عنوان للمستخدم، نخليه الافتراضي تلقائيًا.
    if (data['isDefault'] != true) {
      final existing = await _addressesRef(uid).limit(1).get();
      if (existing.docs.isEmpty) {
        data = {...data, 'isDefault': true};
      }
    }
    if (data['isDefault'] == true) {
      await _clearOtherDefaults(uid, null);
    }
    await _addressesRef(uid).add(data);
  }

  Future<void> updateAddress(String uid, String addressId, Map<String, dynamic> data) async {
    if (data['isDefault'] == true) {
      await _clearOtherDefaults(uid, addressId);
    }
    await _addressesRef(uid).doc(addressId).set(data, SetOptions(merge: true));
  }

  Future<void> deleteAddress(String uid, String addressId) {
    return _addressesRef(uid).doc(addressId).delete();
  }

  Future<void> setDefaultAddress(String uid, String addressId) async {
    await _clearOtherDefaults(uid, addressId);
    await _addressesRef(uid).doc(addressId).set({'isDefault': true}, SetOptions(merge: true));
  }

  Future<void> _clearOtherDefaults(String uid, String? exceptId) async {
    final docs = await _addressesRef(uid).where('isDefault', isEqualTo: true).get();
    for (final doc in docs.docs) {
      if (doc.id == exceptId) continue;
      await doc.reference.set({'isDefault': false}, SetOptions(merge: true));
    }
  }
}
