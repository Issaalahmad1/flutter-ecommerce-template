import 'package:customer_app/features/favourite/presentation/screens/favourite_screen.dart';
import 'package:customer_app/features/notifications/presentation/cubit/notification_center_cubit.dart';
import 'package:customer_app/features/notifications/presentation/cubit/notification_center_state.dart';
import 'package:customer_app/features/notifications/presentation/screens/notification_center_screen.dart';
import 'package:customer_app/features/search/presentation/screens/search_screen.dart';
import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/home_cubit.dart';

class HomeAppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  final BrandConfig brand;

  const HomeAppbarWidget({super.key, required this.brand});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Directionality(
        textDirection: TextDirection.ltr,
        // اللوجو والاسم بيتنقلوا كوحدة واحدة بين RTL/LTR (مش بينقلبوا)،
        // والضغط عليهم بيحدّث الصفحة الرئيسية — بديل سريع لسحب الصفحة
        // لتحت (Pull-to-refresh) لمين مش عارف الحركة دي.
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => context.read<HomeCubit>().loadHome(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(brand.logoAssetPath, height: 30),
              const SizedBox(width: 8),
              Text(
                brand.appName,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: brand.accent),
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search_outlined),
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const SearchScreen()));
          },
        ),
        IconButton(
          icon: const Icon(Icons.favorite_border),
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const FavouriteScreen()));
          },
        ),
        BlocBuilder<NotificationCenterCubit, NotificationCenterState>(
          builder: (context, state) {
            final unreadCount = state is NotificationCenterLoaded
                ? state.unreadCount
                : 0;
            return IconButton(
              icon: Badge(
                isLabelVisible: unreadCount > 0,
                label: Text('$unreadCount'),
                child: const Icon(Icons.notifications_outlined),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const NotificationCenterScreen(),
                  ),
                );
              },
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
