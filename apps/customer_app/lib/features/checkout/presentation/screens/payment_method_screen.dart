import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../cart/presentation/cubit/cart_state.dart';
import '../../../order/presentation/cubit/order_cubit.dart';
import '../../../order/presentation/cubit/order_state.dart';
import 'payment_success_screen.dart';

class PaymentMethodScreen extends StatelessWidget {
  final AddressEntity address;
  final String shippingType;

  const PaymentMethodScreen({
    super.key,
    required this.address,
    required this.shippingType,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderCubit(orderRepository: OrderRepositoryImpl()),
      child: _PaymentMethodBody(address: address, shippingType: shippingType),
    );
  }
}

class _PaymentMethodBody extends StatefulWidget {
  final AddressEntity address;
  final String shippingType;

  const _PaymentMethodBody({required this.address, required this.shippingType});

  @override
  State<_PaymentMethodBody> createState() => _PaymentMethodBodyState();
}

class _PaymentMethodBodyState extends State<_PaymentMethodBody> {
  String _selectedMethod = 'card';

  void _pay(BuildContext context) {
    final cartState = context.read<CartCubit>().state;
    final authState = context.read<AuthCubit>().state;

    if (cartState is! CartLoaded || authState is! AuthAuthenticated) return;

    final order = OrderEntity(
      id: '', // بيتجاهل — Firestore بيولّد الـ id الحقيقي وقت الحفظ.
      userId: authState.user.uid,
      items: cartState.items
          .map((line) => OrderItemEntity(
                productId: line.product.id,
                name: line.product.name,
                imageUrl: line.product.thumbnail,
                price: line.product.price,
                quantity: line.quantity,
              ))
          .toList(),
      subtotal: cartState.subtotal,
      tax: cartState.tax,
      deliveryFee: cartState.delivery,
      total: cartState.total,
      shippingAddress: widget.address,
      paymentMethod: _selectedMethod,
      status: OrderStatus.processing,
      // خطوات تتبّع أولية — أول خطوة مكتملة فورًا (تم قبول الطلب)،
      // والباقي هيتحدث لاحقًا (يدويًا من لوحة الأدمن، أو تلقائيًا
      // لو حبينا نحاكي التقدم بمرور الوقت في نسخة أكتر تفصيلاً).
      trackingSteps: [
        TrackingStepEntity(
          title: 'Your order has been accepted',
          isCompleted: true,
          timestamp: DateTime.now(),
        ),
        const TrackingStepEntity(title: 'Order has been processed and is ready to be shipped'),
        const TrackingStepEntity(title: 'The delivery is on his way'),
        const TrackingStepEntity(title: 'Your order has been delivered'),
      ],
      createdAt: DateTime.now(),
    );

    context.read<OrderCubit>().placeOrder(order);
  }

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;
    final strings = context.strings;

    return Scaffold(
      appBar: AppBar(title: Text(strings.paymentMethodTitle)),
      body: BlocConsumer<OrderCubit, OrderState>(
        listener: (context, state) {
          if (state is OrderReady) {
            // الدفع محاكاة (Mock) — راجع قسم 07 في الدليل. لو اتحوّل
            // لبوابة دفع حقيقية بعدين، هنا بالظبط مكان الاستدعاء الفعلي
            // لـ Stripe/PayPal قبل تأكيد الطلب.
            context.read<CartCubit>().clearCart();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => PaymentSuccessScreen(orderId: state.order.id),
              ),
            );
          } else if (state is OrderError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          final isProcessing = state is OrderProcessing;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.selectPaymentMethod,
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 12),
                RadioListTile<String>(
                  value: 'card',
                  groupValue: _selectedMethod,
                  onChanged: (v) => setState(() => _selectedMethod = v!),
                  title: const Text('•••• •••• •••• 4679'),
                  activeColor: brand.accent,
                ),
                RadioListTile<String>(
                  value: 'paypal',
                  groupValue: _selectedMethod,
                  onChanged: (v) => setState(() => _selectedMethod = v!),
                  title: Text(strings.paypal),
                  activeColor: brand.accent,
                ),
                RadioListTile<String>(
                  value: 'cash',
                  groupValue: _selectedMethod,
                  onChanged: (v) => setState(() => _selectedMethod = v!),
                  title: Text(strings.cashMoney),
                  activeColor: brand.accent,
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: isProcessing ? null : () => _pay(context),
                  child: isProcessing
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(strings.payment),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}