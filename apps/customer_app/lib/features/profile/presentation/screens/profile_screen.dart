import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../address/presentation/screens/address_list_screen.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../cart/presentation/screens/cart_screen.dart';
import '../../../favourite/presentation/screens/favourite_screen.dart';
import '../../../order/presentation/screens/orders_screen.dart';
import '../../../settings/presentation/screens/language_screen.dart';
import '../../../settings/presentation/screens/notifications_screen.dart';
import '../../../settings/presentation/screens/payment_methods_screen.dart';
import '../../../settings/presentation/screens/security_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;
    final strings = context.strings;

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.profileTitle),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is! AuthAuthenticated) {
            return const SizedBox.shrink();
          }
          final user = state.user;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => EditProfileScreen(user: user),
                        ),
                      ),
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 44,
                            backgroundColor: brand.surface,
                            backgroundImage: user.photoUrl != null
                                ? NetworkImage(user.photoUrl!)
                                : null,
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
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: brand.accent,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (user.fullName.trim().isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        user.email,
                        style: TextStyle(fontSize: 12, color: brand.textSecondary),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // اختصارات سريعة للمفضلة والسلة — نفس الفكرة موجودة أصلاً في
              // شريط التنقل السفلي، دي بس وصول أسرع من صفحة الحساب مباشرة.
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _QuickAction(
                    icon: Icons.favorite_border,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const FavouriteScreen()),
                    ),
                  ),
                  const SizedBox(width: 20),
                  _QuickAction(
                    icon: Icons.shopping_bag_outlined,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const CartScreen()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: brand.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _MenuLink(
                            label: strings.ordersTitle,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const OrdersScreen()),
                            ),
                          ),
                        ),
                        Expanded(
                          child: _MenuLink(
                            label: strings.paymentMethodsTitle,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const PaymentMethodsScreen(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _MenuLink(
                            label: strings.addressesTitle,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const AddressListScreen(),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: _MenuLink(
                            label: strings.notificationsTitle,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const NotificationsScreen(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _MenuLink(
                            label: strings.securityTitle,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const SecurityScreen()),
                            ),
                          ),
                        ),
                        const Expanded(child: SizedBox.shrink()),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _MenuTile(
                icon: Icons.language_outlined,
                title: strings.languageTitle,
                trailing: Text(
                  user.language == 'en' ? strings.languageEnglish : strings.languageArabic,
                  style: TextStyle(color: brand.textSecondary),
                ),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const LanguageScreen()),
                ),
              ),
              const SizedBox(height: 8),
              _MenuTile(
                icon: Icons.logout,
                title: strings.logout,
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

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QuickAction({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: brand.surface,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: brand.textPrimary),
      ),
    );
  }
}

/// رابط نصي بس (من غير أيقونة) — بيتحط جوّه شبكة 2×2 داخل كارت واحد،
/// زي التصميم بالظبط.
class _MenuLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _MenuLink({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: brand.textPrimary, fontWeight: FontWeight.w500),
        ),
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
    const brand = BrandConfig.decoze;

    return Container(
      decoration: BoxDecoration(
        color: brand.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        leading: Icon(icon, color: titleColor),
        title: Text(title, style: TextStyle(color: titleColor)),
        trailing: trailing ?? const Icon(Icons.chevron_right, size: 20),
        onTap: onTap,
      ),
    );
  }
}
