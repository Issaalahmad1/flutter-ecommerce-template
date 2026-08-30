import 'package:decoze_core/core.dart';
import 'package:equatable/equatable.dart';

/// يجمع بيانات المنتج الكاملة مع الكمية المطلوبة في السلة —
/// موديل عرض (View Model) بيعيش هنا بس، مش جزء من decoze_core،
/// لأنه مش شيء بيتخزن في Firestore، مجرد تجميعة مؤقتة للعرض.
class CartLineItem extends Equatable {
  final ProductEntity product;
  final int quantity;
  final int? discountPercent;

  const CartLineItem({
    required this.product,
    required this.quantity,
    this.discountPercent,
  });

  /// السعر الفعلي للوحدة بعد تطبيق الخصم (لو موجود وساري).
  double get unitPrice => DiscountCalculator.applyDiscount(product.price, discountPercent);

  double get lineTotal => unitPrice * quantity;

  /// قيمة الخصم الإجمالية على السطر ده (للعرض في الفاتورة).
  double get discountAmount => (product.price - unitPrice) * quantity;

  @override
  List<Object?> get props => [product, quantity, discountPercent];
}

sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {
  const CartInitial();
}

class CartLoading extends CartState {
  const CartLoading();
}

class CartLoaded extends CartState {
  static const double taxAmount = 25;
  static const double deliveryFee = 100;

  final List<CartLineItem> items;

  const CartLoaded({required this.items});

  double get subtotal => items.fold(0, (sum, item) => sum + item.lineTotal);
  double get totalDiscount => items.fold(0, (sum, item) => sum + item.discountAmount);
  double get tax => items.isEmpty ? 0 : taxAmount;
  double get delivery => items.isEmpty ? 0 : deliveryFee;
  double get total => subtotal + tax + delivery;

  @override
  List<Object?> get props => [items];
}
class CartError extends CartState {
  final String message;
  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}