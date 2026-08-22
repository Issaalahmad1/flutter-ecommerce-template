import 'package:decoze_core/core.dart';
import 'package:equatable/equatable.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardState {
  final double totalRevenue;
  final int totalOrders;
  final int totalProducts;
  final List<OrderEntity> recentOrders;

  const DashboardLoaded({
    required this.totalRevenue,
    required this.totalOrders,
    required this.totalProducts,
    required this.recentOrders,
  });

  @override
  List<Object?> get props => [totalRevenue, totalOrders, totalProducts, recentOrders];
}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}