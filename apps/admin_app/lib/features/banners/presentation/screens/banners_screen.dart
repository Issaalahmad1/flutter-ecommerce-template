import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/banners_cubit.dart';
import '../cubit/banners_state.dart';
import '../widgets/banner_form_dialog.dart';

class BannersScreen extends StatelessWidget {
  const BannersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BannersCubit(
        bannerRepository: BannerRepositoryImpl(),
        categoryRepository: CategoryRepositoryImpl(),
      )..loadBanners(),
      child: const _BannersScreenBody(),
    );
  }
}

class _BannersScreenBody extends StatelessWidget {
  const _BannersScreenBody();

  void _openForm(BuildContext context, List<CategoryEntity> categories,
      {BannerEntity? banner}) {
    final cubit = context.read<BannersCubit>();
    showDialog(
      context: context,
      builder: (_) => BannerFormDialog(
        categories: categories,
        banner: banner,
        onSubmit: (result) async {
          if (banner == null) {
            await cubit.createBanner(result);
          } else {
            await cubit.updateBanner(result);
          }
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, BannerEntity banner) {
    final cubit = context.read<BannersCubit>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('حذف "${banner.title}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              cubit.deleteBanner(banner.id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BannersCubit, BannersState>(
      builder: (context, state) {
        return switch (state) {
          BannersInitial() || BannersLoading() =>
            const Center(child: CircularProgressIndicator()),
          BannersError(:final message) => Center(child: Text(message)),
          BannersLoaded(:final banners, :final categories) =>
            SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Banners', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(width: 24),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(minimumSize: const Size(160, 44)),
                        onPressed: () => _openForm(context, categories),
                        icon: const Icon(Icons.add),
                        label: const Text('Add banner'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (banners.isEmpty)
                    const Text('لا توجد بانرات بعد.')
                  else
                    ...banners.map((banner) => Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            title: Text('${banner.title} — ${banner.discountLabel}'),
                            subtitle: Text(banner.subtitle),
                            leading: Icon(
                              banner.isActive ? Icons.visibility : Icons.visibility_off,
                              color: banner.isActive ? Colors.green : Colors.grey,
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 18),
                                  onPressed: () =>
                                      _openForm(context, categories, banner: banner),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                                  onPressed: () => _confirmDelete(context, banner),
                                ),
                              ],
                            ),
                          ),
                        )),
                ],
              ),
            ),
        };
      },
    );
  }
}