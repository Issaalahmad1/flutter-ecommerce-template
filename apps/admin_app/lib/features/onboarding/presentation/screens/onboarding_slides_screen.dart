import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/onboarding_slides_cubit.dart';
import '../cubit/onboarding_slides_state.dart';
import '../widgets/onboarding_slide_form_dialog.dart';

/// إدارة سلايدات شاشة الـ Onboarding في customer_app (اللي بتظهر
/// بعد شاشة الترحيب) — لو القائمة فاضية، customer_app بيرجع
/// تلقائيًا للسلايدات الافتراضية المكتوبة في كوده، مش هتفضل الشاشة
/// فاضية عنده.
class OnboardingSlidesScreen extends StatelessWidget {
  const OnboardingSlidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingSlidesCubit(repository: OnboardingSlideRepositoryImpl())
        ..loadSlides(),
      child: const _OnboardingSlidesBody(),
    );
  }
}

class _OnboardingSlidesBody extends StatelessWidget {
  const _OnboardingSlidesBody();

  void _openForm(BuildContext context, {OnboardingSlideEntity? slide}) {
    final cubit = context.read<OnboardingSlidesCubit>();
    showDialog(
      context: context,
      builder: (_) => OnboardingSlideFormDialog(
        slide: slide,
        onSubmit: (result) async {
          if (slide == null) {
            await cubit.createSlide(result);
          } else {
            await cubit.updateSlide(result);
          }
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, OnboardingSlideEntity slide) {
    final cubit = context.read<OnboardingSlidesCubit>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('حذف "${slide.titleEn}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              cubit.deleteSlide(slide.id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingSlidesCubit, OnboardingSlidesState>(
      builder: (context, state) {
        return switch (state) {
          OnboardingSlidesInitial() || OnboardingSlidesLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          OnboardingSlidesError(:final message) => Center(child: Text(message)),
          OnboardingSlidesLoaded(:final slides) => SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Onboarding slides', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(width: 24),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(minimumSize: const Size(160, 44)),
                      onPressed: () => _openForm(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Add slide'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'لو القائمة دي فاضية، تطبيق العملاء بيعرض 3 سلايدات افتراضية جاهزة.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 20),
                if (slides.isEmpty)
                  const Text('لا توجد سلايدات مخصّصة بعد.')
                else
                  ...slides.map(
                    (slide) => Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: slide.imageUrl != null
                            ? CircleAvatar(backgroundImage: NetworkImage(slide.imageUrl!))
                            : const CircleAvatar(child: Icon(Icons.image_outlined)),
                        title: Text('#${slide.order} — ${slide.titleEn}'),
                        subtitle: Text(slide.descriptionEn, maxLines: 1, overflow: TextOverflow.ellipsis),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, size: 18),
                              onPressed: () => _openForm(context, slide: slide),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                              onPressed: () => _confirmDelete(context, slide),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        };
      },
    );
  }
}
