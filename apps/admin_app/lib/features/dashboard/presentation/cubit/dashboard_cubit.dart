import 'package:decoze_core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final OrderRepository _orderRepository;
  final ProductRepository _productRepository;

  DashboardCubit({
    required OrderRepository orderRepository,
    required ProductRepository productRepository,
  })  : _orderRepository = orderRepository,
        _productRepository = productRepository,
        super(const DashboardInitial());

  Future<void> loadDashboard() async {
    emit(const DashboardLoading());
    try {
      final results = await Future.wait([
        _orderRepository.getAllOrders(),
        _productRepository.getProducts(),
      ]);
      final orders = results[0] as List<OrderEntity>;
      final products = results[1] as List<ProductEntity>;

      final totalRevenue = orders.fold<double>(0, (sum, order) => sum + order.total);

      emit(DashboardLoaded(
        totalRevenue: totalRevenue,
        totalOrders: orders.length,
        totalProducts: products.length,
        recentOrders: orders.take(5).toList(),
      ));
    } catch (e) {
      emit(const DashboardError('حدث خطأ في تحميل بيانات لوحة التحكم.'));
    }
  }
}