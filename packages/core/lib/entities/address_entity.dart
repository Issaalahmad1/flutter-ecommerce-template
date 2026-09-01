import 'package:equatable/equatable.dart';

/// عنوان شحن منظّم في حقول منفصلة (مش سطر واحد حر) — عشان المستخدم
/// ميضيعش وهو بيكتب، وعشان البيانات تبقى قابلة للتحليل مستقبلًا (زي
/// "أكتر منطقة بيوصلها طلبات" مثلاً) بدل ما تكون نص حر مالوش بنية.
class AddressEntity extends Equatable {
  final String id;
  final String label; // "المنزل"، "العمل"...
  final String fullName;
  final String phone;
  final String country;
  final String city;
  final String area;
  final String street;
  final String buildingNumber;
  final String? floor;
  final String? apartment;
  final String? landmark;
  final bool isDefault;

  const AddressEntity({
    required this.id,
    required this.label,
    required this.fullName,
    required this.phone,
    required this.country,
    required this.city,
    required this.area,
    required this.street,
    required this.buildingNumber,
    this.floor,
    this.apartment,
    this.landmark,
    this.isDefault = false,
  });

  /// سطر واحد ملخّص للعرض السريع (كارت العنوان، شاشة الدفع...).
  String get summaryLine {
    final parts = [
      street,
      buildingNumber.isEmpty ? null : 'مبنى $buildingNumber',
      if (floor != null && floor!.isNotEmpty) 'الدور $floor',
      if (apartment != null && apartment!.isNotEmpty) 'شقة $apartment',
      area,
      city,
    ].whereType<String>().where((s) => s.isNotEmpty);
    return parts.join('، ');
  }

  factory AddressEntity.fromJson(String id, Map<String, dynamic> json) {
    return AddressEntity(
      id: id,
      label: json['label'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      country: json['country'] as String? ?? '',
      city: json['city'] as String? ?? '',
      area: json['area'] as String? ?? '',
      street: json['street'] as String? ?? '',
      buildingNumber: json['buildingNumber'] as String? ?? '',
      floor: json['floor'] as String?,
      apartment: json['apartment'] as String?,
      landmark: json['landmark'] as String?,
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'fullName': fullName,
      'phone': phone,
      'country': country,
      'city': city,
      'area': area,
      'street': street,
      'buildingNumber': buildingNumber,
      'floor': floor,
      'apartment': apartment,
      'landmark': landmark,
      'isDefault': isDefault,
    };
  }

  @override
  List<Object?> get props => [
        id,
        label,
        fullName,
        phone,
        country,
        city,
        area,
        street,
        buildingNumber,
        floor,
        apartment,
        landmark,
        isDefault,
      ];
}
