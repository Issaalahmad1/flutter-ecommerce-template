import 'package:decoze_core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'orders_list_state.dart';

class OrdersListCubit extends Cubit<OrdersListState> {
  final OrderRepository _orderRepository;

  OrdersListCubit({required OrderRepository orderRepository})
      : _orderRepository = orderRepository,
        super(const OrdersListInitial());

  Future<void> loadOrders(String uid) async {
    emit(const OrdersListLoading());
    try {
      final orders = await _orderRepository.getOrders(uid);
      emit(OrdersListLoaded(orders));
    } catch (e) {
      emit(const OrdersListError('حدث خطأ في تحميل الطلبات.'));
    }
  }
}