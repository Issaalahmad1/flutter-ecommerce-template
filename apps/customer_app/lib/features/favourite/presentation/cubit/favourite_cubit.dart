import 'dart:async';

import 'package:decoze_core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'favourite_state.dart';

class FavouriteCubit extends Cubit<FavouriteState> {
  final FavouriteRepository _favouriteRepository;
  final ProductRepository _productRepository;

  String? _uid;
  StreamSubscription<List<String>>? _subscription;

  FavouriteCubit({
    required FavouriteRepository favouriteRepository,
    required ProductRepository productRepository,
  })  : _favouriteRepository = favouriteRepository,
        _productRepository = productRepository,
        super(const FavouriteInitial());

  /// نفس نمط CartCubit.attachUser بالظبط — بيتفعّل من BlocListener
  /// على AuthCubit في main.dart.
  void attachUser(String? uid) {
    _subscription?.cancel();
    _uid = uid;

    if (uid == null) {
      emit(const FavouriteInitial());
      return;
    }

    _subscription = _favouriteRepository.watchFavoriteIds(uid).listen(
      (ids) async {
        final products = await _loadProducts(ids);
        emit(FavouriteLoaded(favoriteIds: ids, products: products));
      },
      onError: (_) => emit(const FavouriteError('حدث خطأ في تحميل المفضلة.')),
    );
  }

  Future<List<ProductEntity>> _loadProducts(List<String> ids) async {
    final futures = ids.map((id) async {
      try {
        return await _productRepository.getProductById(id);
      } catch (_) {
        return null;
      }
    });
    final results = await Future.wait(futures);
    return results.whereType<ProductEntity>().toList();
  }

  /// دالة واحدة بتتبع الحالة الحالية وتقرر تضيف ولا تشيل — الشاشة
  /// مش محتاجة تعرف الفرق، بس تنده "toggle" على أي منتج.
  ///
  /// بتحدّث الحالة محليًا فورًا (عشان القلب يتغيّر لون في نفس اللحظة
  /// من غير أي انتظار)، وتبعت الكتابة الفعلية لـ Firestore في الخلفية.
  /// [product] اختياري — لو موجود (زي لما بننده من كارت منتج فيه
  /// النسخة كاملة أصلاً) بيتضاف فورًا لقايمة المفضلة المعروضة.
  Future<void> toggleFavorite(String productId, {ProductEntity? product}) async {
    final uid = _uid;
    final currentState = state;
    if (uid == null) return;

    final isFav = currentState is FavouriteLoaded && currentState.isFavorite(productId);

    if (currentState is FavouriteLoaded) {
      if (isFav) {
        emit(FavouriteLoaded(
          favoriteIds: currentState.favoriteIds.where((id) => id != productId).toList(),
          products: currentState.products.where((p) => p.id != productId).toList(),
        ));
      } else {
        emit(FavouriteLoaded(
          favoriteIds: [...currentState.favoriteIds, productId],
          products: product != null ? [...currentState.products, product] : currentState.products,
        ));
      }
    }

    if (isFav) {
      unawaited(_favouriteRepository.removeFavorite(uid, productId));
    } else {
      unawaited(_favouriteRepository.addFavorite(uid, productId));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
