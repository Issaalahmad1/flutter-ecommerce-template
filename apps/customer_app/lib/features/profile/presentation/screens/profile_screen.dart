import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../settings/presentation/screens/language_screen.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_grid.dart';
import '../widgets/profile_menu_tile.dart';
import '../widgets/profile_quick_actions.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.profileTitle),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is! AuthAuthenticated) return const SizedBox.shrink();
          return _ProfileBody(user: state.user);
        },
      ),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  final UserEntity user;

  const _ProfileBody({required this.user});

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;
    final strings = context.strings;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        ProfileHeader(user: user),
        const SizedBox(height: 24),
        const ProfileQuickActions(),
        const SizedBox(height: 24),
        const ProfileMenuGrid(),
        const SizedBox(height: 16),
        ProfileMenuTile(
          icon: Icons.language_outlined,
          title: strings.languageTitle,
          trailing: Text(
            user.language == 'en' ? strings.languageEnglish : strings.languageArabic,
            style: TextStyle(color: brand.textSecondary),
          ),
          onTap: () =>
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LanguageScreen())),
        ),
        const SizedBox(height: 8),
        ProfileMenuTile(
          icon: Icons.logout,
          title: strings.logout,
          titleColor: Colors.red,
          onTap: () => _confirmLogout(context),
        ),
      ],
    );
  }

  void _confirmLogout(BuildContext context) {
    final strings = context.strings;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(strings.confirmLogout),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(strings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<AuthCubit>().signOut();
            },
            child: Text(strings.logout, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
