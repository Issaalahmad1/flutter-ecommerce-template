import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/address_cubit.dart';

/// فورم إضافة/تعديل عنوان — الحقول منفصلة عمدًا (شارع، مبنى، دور،
/// شقة...) بدل سطر واحد حر، عشان المستخدم يعرف بالظبط كل جزء يتحط
/// فين، وعشان البيانات تبقى منظّمة وقابلة للتحليل بعدين (زي "أكتر
/// مدينة بتطلب" مثلاً) مش مجرد نص حر.
class AddressFormScreen extends StatefulWidget {
  final AddressEntity? existing;

  const AddressFormScreen({super.key, this.existing});

  @override
  State<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _labelController;
  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _countryController;
  late final TextEditingController _cityController;
  late final TextEditingController _areaController;
  late final TextEditingController _streetController;
  late final TextEditingController _buildingController;
  late final TextEditingController _floorController;
  late final TextEditingController _apartmentController;
  late final TextEditingController _landmarkController;
  bool _isSaving = false;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final a = widget.existing;
    _labelController = TextEditingController(text: a?.label ?? '');
    _fullNameController = TextEditingController(text: a?.fullName ?? '');
    _phoneController = TextEditingController(text: a?.phone ?? '');
    _countryController = TextEditingController(text: a?.country ?? '');
    _cityController = TextEditingController(text: a?.city ?? '');
    _areaController = TextEditingController(text: a?.area ?? '');
    _streetController = TextEditingController(text: a?.street ?? '');
    _buildingController = TextEditingController(text: a?.buildingNumber ?? '');
    _floorController = TextEditingController(text: a?.floor ?? '');
    _apartmentController = TextEditingController(text: a?.apartment ?? '');
    _landmarkController = TextEditingController(text: a?.landmark ?? '');
  }

  @override
  void dispose() {
    _labelController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _areaController.dispose();
    _streetController.dispose();
    _buildingController.dispose();
    _floorController.dispose();
    _apartmentController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final address = AddressEntity(
      id: widget.existing?.id ?? '',
      label: _labelController.text.trim(),
      fullName: _fullNameController.text.trim(),
      phone: _phoneController.text.trim(),
      country: _countryController.text.trim(),
      city: _cityController.text.trim(),
      area: _areaController.text.trim(),
      street: _streetController.text.trim(),
      buildingNumber: _buildingController.text.trim(),
      floor: _floorController.text.trim().isEmpty
          ? null
          : _floorController.text.trim(),
      apartment: _apartmentController.text.trim().isEmpty
          ? null
          : _apartmentController.text.trim(),
      landmark: _landmarkController.text.trim().isEmpty
          ? null
          : _landmarkController.text.trim(),
      isDefault: widget.existing?.isDefault ?? false,
    );

    final cubit = context.read<AddressCubit>();
    if (_isEditing) {
      await cubit.updateAddress(address);
    } else {
      await cubit.addAddress(address);
    }

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.strings.addressSaved)));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? strings.editAddress : strings.addAddress),
      ),
      body: ResponsiveContent(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              TextFormField(
                controller: _labelController,
                decoration: InputDecoration(
                  labelText: strings.addressLabelHint,
                ),
                validator: _required(strings),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(labelText: strings.fullNameHint),
                validator: _required(strings),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: strings.phoneNumberHint),
                validator: _required(strings),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _countryController,
                      decoration: InputDecoration(
                        labelText: strings.countryHint,
                      ),
                      validator: _required(strings),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _cityController,
                      decoration: InputDecoration(labelText: strings.cityHint),
                      validator: _required(strings),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _areaController,
                decoration: InputDecoration(labelText: strings.areaHint),
                validator: _required(strings),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _streetController,
                decoration: InputDecoration(labelText: strings.streetHint),
                validator: _required(strings),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _buildingController,
                      decoration: InputDecoration(
                        labelText: strings.buildingNumberHint,
                      ),
                      validator: _required(strings),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _floorController,
                      decoration: InputDecoration(labelText: strings.floorHint),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _apartmentController,
                      decoration: InputDecoration(
                        labelText: strings.apartmentHint,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _landmarkController,
                decoration: InputDecoration(labelText: strings.landmarkHint),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isSaving ? null : _submit,
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(strings.continueLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? Function(String?) _required(AppStrings strings) {
    return (v) =>
        (v == null || v.trim().isEmpty) ? strings.fieldRequired : null;
  }
}
