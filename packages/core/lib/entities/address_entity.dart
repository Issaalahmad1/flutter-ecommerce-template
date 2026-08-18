import 'package:equatable/equatable.dart';

class AddressEntity extends Equatable {
  final String id;
  final String label; // "Home", "Office"...
  final String addressLine;
  final String city;
  final bool isDefault;

  const AddressEntity({
    required this.id,
    required this.label,
    required this.addressLine,
    required this.city,
    this.isDefault = false,
  });

  factory AddressEntity.fromJson(String id, Map<String, dynamic> json) {
    return AddressEntity(
      id: id,
      label: json['label'] as String? ?? '',
      addressLine: json['addressLine'] as String? ?? '',
      city: json['city'] as String? ?? '',
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'addressLine': addressLine,
      'city': city,
      'isDefault': isDefault,
    };
  }

  @override
  List<Object?> get props => [id, label, addressLine, city, isDefault];
}
