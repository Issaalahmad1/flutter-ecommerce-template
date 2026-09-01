import 'dart:typed_data';

import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../auth/presentation/cubit/auth_cubit.dart';

class EditProfileScreen extends StatefulWidget {
  final UserEntity user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneController;
  DateTime? _dob;
  String? _gender;

  Uint8List? _pickedImageBytes;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.user.firstName);
    _lastNameController = TextEditingController(text: widget.user.lastName);
    _phoneController = TextEditingController(text: widget.user.phone ?? '');
    _dob = widget.user.dob;
    _gender = widget.user.gender;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      imageQuality: 85,
    );
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    setState(() => _pickedImageBytes = bytes);
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(now.year - 20),
      firstDate: DateTime(now.year - 100),
      lastDate: now,
    );
    if (picked != null) setState(() => _dob = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      String? photoUrl = widget.user.photoUrl;
      if (_pickedImageBytes != null) {
        final path = 'users/${widget.user.uid}/profile.jpg';
        photoUrl = await StorageRepositoryImpl().uploadImage(
          bytes: _pickedImageBytes!,
          path: path,
        );
      }

      if (!mounted) return;
      await context.read<AuthCubit>().updateProfile(
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
            dob: _dob,
            gender: _gender,
            photoUrl: photoUrl,
          );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.strings.profileUpdated)),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;
    final strings = context.strings;

    return Scaffold(
      appBar: AppBar(title: Text(strings.editProfileTitle)),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: brand.surface,
                        backgroundImage: _pickedImageBytes != null
                            ? MemoryImage(_pickedImageBytes!)
                            : (widget.user.photoUrl != null
                                ? NetworkImage(widget.user.photoUrl!)
                                : null) as ImageProvider?,
                        child: _pickedImageBytes == null && widget.user.photoUrl == null
                            ? Icon(Icons.person, size: 50, color: brand.textSecondary)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: brand.accent,
                            shape: BoxShape.circle,
                            border: Border.all(color: brand.primaryBackground, width: 2),
                          ),
                          child: Icon(Icons.edit, size: 16, color: brand.onAccent),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: strings.firstNameHint),
                validator: (v) => (v == null || v.trim().isEmpty) ? strings.fieldRequired : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: strings.lastNameHint),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: widget.user.email,
                enabled: false,
                decoration: InputDecoration(labelText: strings.emailHint),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _pickDob,
                child: InputDecorator(
                  decoration: InputDecoration(labelText: strings.dateOfBirthHint),
                  child: Text(
                    _dob == null
                        ? ''
                        : '${_dob!.year}-${_dob!.month.toString().padLeft(2, '0')}-${_dob!.day.toString().padLeft(2, '0')}',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: strings.phoneNumberHint),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _gender,
                decoration: InputDecoration(labelText: strings.genderHint),
                items: [
                  DropdownMenuItem(value: 'male', child: Text(strings.male)),
                  DropdownMenuItem(value: 'female', child: Text(strings.female)),
                ],
                onChanged: (value) => setState(() => _gender = value),
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
}
