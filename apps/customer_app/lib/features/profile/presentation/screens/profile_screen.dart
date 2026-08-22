import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../favourite/presentation/screens/favourite_screen.dart';
import '../../../order/presentation/screens/orders_screen.dart';
import '../../../settings/presentation/screens/language_screen.dart';
import '../../../settings/presentation/screens/notifications_screen.dart';
import '../../../settings/presentation/screens/payment_methods_screen.dart';
import '../../../settings/presentation/screens/security_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is! AuthAuthenticated) {
            return const SizedBox.shrink();
          }
          final user = state.user;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: brand.surface,
                      backgroundImage:
                          user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
                      child: user.photoUrl == null
                          ? Icon(Icons.person, size: 40, color: brand.textSecondary)
                          : null,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user.fullName.trim().isEmpty ? user.email : user.fullName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _MenuTile(
                icon: Icons.favorite_border,
                title: 'Favourite',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const FavouriteScreen()),
                ),
              ),
              _MenuTile(
                icon: Icons.receipt_long_outlined,
                title: 'Orders',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const OrdersScreen()),
                ),
              ),
              _MenuTile(
                icon: Icons.credit_card_outlined,
                title: 'Payments',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PaymentMethodsScreen()),
                ),
              ),
              _MenuTile(
                icon: Icons.notifications_outlined,
                title: 'Notification',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                ),
              ),
              _MenuTile(
                icon: Icons.security_outlined,
                title: 'Security',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SecurityScreen()),
                ),
              ),
              _MenuTile(
                icon: Icons.language_outlined,
                title: 'Language',
                trailing: Text(user.language == 'en' ? 'English (US)' : user.language),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const LanguageScreen()),
                ),
              ),
              const SizedBox(height: 16),
              _MenuTile(
                icon: Icons.logout,
                title: 'Logout',
                titleColor: Colors.red,
                onTap: () => _confirmLogout(context),
              ),
            ],
          );
        },
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<AuthCubit>().signOut();
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final Color? titleColor;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.titleColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: titleColor),
      title: Text(title, style: TextStyle(color: titleColor)),
      trailing: trailing ?? const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }
}