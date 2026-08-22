import 'package:decoze_core/core.dart';
import 'package:equatable/equatable.dart';

sealed class OrdersListState extends Equatable {
  const OrdersListState();

  @override
  List<Object?> get props => [];
}

class OrdersListInitial extends OrdersListState {
  const OrdersListInitial();
}

class OrdersListLoading extends OrdersListState {
  const OrdersListLoading();
}

class OrdersListLoaded extends OrdersListState {
  final List<OrderEntity> orders;
  const OrdersListLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}

class OrdersListError extends OrdersListState {
  final String message;
  const OrdersListError(this.message);

  @override
  List<Object?> get props => [message];
}