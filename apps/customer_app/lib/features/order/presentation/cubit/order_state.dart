import 'package:decoze_core/core.dart';
import 'package:equatable/equatable.dart';

sealed class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {
  const OrderInitial();
}

/// نفس الحالة بتتستخدم وقت "جاري حفظ الطلب" و"جاري تحميل الطلب" —
/// الاتنين مفهوميًا "جاري تنفيذ عملية"، مفيش داعي لحالتين منفصلتين.
class OrderProcessing extends OrderState {
  const OrderProcessing();
}

class OrderReady extends OrderState {
  final OrderEntity order;
  const OrderReady(this.order);

  @override
  List<Object?> get props => [order];
}

class OrderError extends OrderState {
  final String message;
  const OrderError(this.message);

  @override
  List<Object?> get props => [message];
}