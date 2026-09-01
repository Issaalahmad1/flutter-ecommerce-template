import 'package:decoze_core/core.dart';
import 'package:equatable/equatable.dart';

sealed class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object?> get props => [];
}

class AddressInitial extends AddressState {
  const AddressInitial();
}

class AddressLoaded extends AddressState {
  final List<AddressEntity> addresses;

  const AddressLoaded({required this.addresses});

  AddressEntity? get defaultAddress {
    for (final address in addresses) {
      if (address.isDefault) return address;
    }
    return addresses.isEmpty ? null : addresses.first;
  }

  @override
  List<Object?> get props => [addresses];
}

class AddressError extends AddressState {
  final String message;
  const AddressError(this.message);

  @override
  List<Object?> get props => [message];
}
