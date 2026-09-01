import 'package:decoze_core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'admin_orders_state.dart';

class AdminOrdersCubit extends Cubit<AdminOrdersState> {
  final OrderRepository _orderRepository;

  AdminOrdersCubit({required OrderRepository orderRepository})
      : _orderRepository = orderRepository,
        super(const AdminOrdersInitial());

  Future<void> loadOrders() async {
    emit(const AdminOrdersLoading());
    try {
      final orders = await _orderRepository.getAllOrders();
      emit(AdminOrdersLoaded(orders));
    } catch (e) {
      emit(const AdminOrdersError('حدث خطأ في تحميل الطلبات.'));
    }
  }

  Future<void> updateStatus(OrderEntity order, OrderStatus status) async {
    await _orderRepository.updateOrderStatus(order, status);
    await loadOrders();
  }
}