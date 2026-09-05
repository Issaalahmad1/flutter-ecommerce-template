import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';

import '../screens/edit_profile_screen.dart';

/// صورة البروفايل (بشارة تعديل صغيرة فوقها) + الاسم/الإيميل —
/// الضغط على الصورة بياخد لصفحة تعديل البيانات.
class ProfileHeader extends StatelessWidget {
  final UserEntity user;

  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;

    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => EditProfileScreen(user: user)),
            ),
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 44,
                  backgroundColor: brand.surface,
                  backgroundImage: user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
                  child: user.photoUrl == null
                      ? Icon(Icons.person, size: 44, color: brand.textSecondary)
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: brand.accent,
                      shape: BoxShape.circle,
                      border: Border.all(color: brand.primaryBackground, width: 2),
                    ),
                    child: Icon(Icons.edit, size: 14, color: brand.onAccent),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            user.fullName.trim().isEmpty ? user.email : user.fullName,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: brand.accent, fontWeight: FontWeight.bold),
          ),
          if (user.fullName.trim().isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(user.email, style: TextStyle(fontSize: 12, color: brand.textSecondary)),
          ],
        ],
      ),
    );
  }
}
