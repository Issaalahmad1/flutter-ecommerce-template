import 'dart:async';

import 'package:decoze_core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  final AddressRepository _addressRepository;

  String? _uid;
  StreamSubscription<List<AddressEntity>>? _subscription;

  AddressCubit({required AddressRepository addressRepository})
      : _addressRepository = addressRepository,
        super(const AddressInitial());

  void attachUser(String? uid) {
    _subscription?.cancel();
    _uid = uid;

    if (uid == null) {
      emit(const AddressInitial());
      return;
    }

    _subscription = _addressRepository.watchAddresses(uid).listen(
      (addresses) => emit(AddressLoaded(addresses: addresses)),
      onError: (_) => emit(const AddressError('حدث خطأ في تحميل العناوين.')),
    );
  }

  Future<void> addAddress(AddressEntity address) async {
    final uid = _uid;
    if (uid == null) return;
    await _addressRepository.addAddress(uid, address);
  }

  Future<void> updateAddress(AddressEntity address) async {
    final uid = _uid;
    if (uid == null) return;
    await _addressRepository.updateAddress(uid, address);
  }

  Future<void> deleteAddress(String addressId) async {
    final uid = _uid;
    if (uid == null) return;
    await _addressRepository.deleteAddress(uid, addressId);
  }

  Future<void> setDefaultAddress(String addressId) async {
    final uid = _uid;
    if (uid == null) return;
    await _addressRepository.setDefaultAddress(uid, addressId);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
