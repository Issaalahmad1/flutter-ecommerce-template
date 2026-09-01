import 'dart:async';

import 'package:decoze_core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'recommendation_state.dart';

/// نفس نمط CartCubit/FavouriteCubit.attachUser — بيتفعّل من BlocListener
/// على AuthCubit في main.dart. بيجمع 3 إشارات (المشتريات، المفضلة،
/// آخر منتجات اتشافت) ويمررها لـ RecommendationEngine (utility بسيط
/// قائم على الفئة، من غير أي نداء لخدمة خارجية) كل ما أي إشارة تتغيّر.
class RecommendationCubit extends Cubit<RecommendationState> {
  final ProductRepository _productRepository;
  final OrderRepository _orderRepository;
  final FavouriteRepository _favouriteRepository;
  final RecentlyViewedRepository _recentlyViewedRepository;

  String? _uid;
  StreamSubscription<List<String>>? _favSubscription;
  StreamSubscription<List<String>>? _viewedSubscription;

  List<ProductEntity> _allProducts = [];
  List<String> _purchasedIds = [];
  List<String> _favoriteIds = [];
  List<String> _recentlyViewedIds = [];

  RecommendationCubit({
    required ProductRepository productRepository,
    required OrderRepository orderRepository,
    required FavouriteRepository favouriteRepository,
    required RecentlyViewedRepository recentlyViewedRepository,
  })  : _productRepository = productRepository,
        _orderRepository = orderRepository,
        _favouriteRepository = favouriteRepository,
        _recentlyViewedRepository = recentlyViewedRepository,
        super(const RecommendationInitial());

  Future<void> attachUser(String? uid) async {
    _favSubscription?.cancel();
    _viewedSubscription?.cancel();
    _uid = uid;

    if (uid == null) {
      _allProducts = [];
      _purchasedIds = [];
      _favoriteIds = [];
      _recentlyViewedIds = [];
      emit(const RecommendationInitial());
      return;
    }

    try {
      final results = await Future.wait([
        _productRepository.getProducts(),
        _orderRepository.getOrders(uid),
      ]);
      if (_uid != uid) return; // المستخدم اتغيّر تاني قبل ما الطلب يخلص.
      _allProducts = results[0] as List<ProductEntity>;
      final orders = results[1] as List<OrderEntity>;
      _purchasedIds = orders.expand((o) => o.items.map((item) => item.productId)).toSet().toList();
    } catch (_) {
      // لو فشل التحميل، هنكمّل بالإشارتين التانيين (مفضلة + تصفح) بس —
      // أفضل من ما القسم يختفي خالص.
    }

    _favSubscription = _favouriteRepository.watchFavoriteIds(uid).listen((ids) {
      _favoriteIds = ids;
      _recompute();
    });
    _viewedSubscription = _recentlyViewedRepository.watchRecentlyViewedIds(uid).listen((ids) {
      _recentlyViewedIds = ids;
      _recompute();
    });
  }

  void _recompute() {
    emit(RecommendationLoaded(RecommendationEngine.recommend(
      allProducts: _allProducts,
      purchasedProductIds: _purchasedIds,
      favoriteProductIds: _favoriteIds,
      recentlyViewedProductIds: _recentlyViewedIds,
    )));
  }

  @override
  Future<void> close() {
    _favSubscription?.cancel();
    _viewedSubscription?.cancel();
    return super.close();
  }
}
