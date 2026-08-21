import 'package:decoze_core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRepository _orderRepository;

  OrderCubit({required OrderRepository orderRepository})
      : _orderRepository = orderRepository,
        super(const OrderInitial());

  Future<void> placeOrder(OrderEntity order) async {
    emit(const OrderProcessing());
    try {
      final placed = await _orderRepository.placeOrder(order);
      emit(OrderReady(placed));
    } catch (e) {
      emit(const OrderError('حدث خطأ أثناء تنفيذ الطلب، حاول مرة أخرى.'));
    }
  }

  Future<void> loadOrder(String orderId) async {
    emit(const OrderProcessing());
    try {
      final order = await _orderRepository.getOrderById(orderId);
      emit(OrderReady(order));
    } catch (e) {
      emit(const OrderError('تعذّر تحميل تفاصيل الطلب.'));
    }
  }
}