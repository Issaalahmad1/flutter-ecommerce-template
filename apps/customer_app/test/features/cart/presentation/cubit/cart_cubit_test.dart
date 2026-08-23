import 'package:bloc_test/bloc_test.dart';
import 'package:decoze_core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:customer_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:customer_app/features/cart/presentation/cubit/cart_state.dart';

class MockCartRepository extends Mock implements CartRepository {}

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late MockCartRepository cartRepository;
  late MockProductRepository productRepository;

  final testProduct = ProductEntity(
    id: 'p1',
    name: 'Wooden Sideboard Table',
    description: 'test',
    price: 100,
    images: const ['https://example.com/img.jpg'],
    categoryId: 'bedroom',
    stock: 10,
    createdAt: DateTime(2026, 1, 1),
  );

  setUp(() {
    cartRepository = MockCartRepository();
    productRepository = MockProductRepository();
  });

  group('CartCubit', () {
    blocTest<CartCubit, CartState>(
      'يحسب subtotal وtotal صح لما فيه منتج بكمية 2',
      build: () {
        when(() => cartRepository.watchCart('uid1')).thenAnswer(
          (_) => Stream.value([const CartItemEntity(productId: 'p1', quantity: 2)]),
        );
        when(() => productRepository.getProductById('p1'))
            .thenAnswer((_) async => testProduct);

        return CartCubit(
          cartRepository: cartRepository,
          productRepository: productRepository,
        );
      },
      act: (cubit) => cubit.attachUser('uid1'),
      expect: () => [
        const CartLoading(),
        isA<CartLoaded>()
            .having((s) => s.subtotal, 'subtotal', 200) // 100 * 2
            .having((s) => s.tax, 'tax', 25)
            .having((s) => s.delivery, 'delivery', 100)
            .having((s) => s.total, 'total', 325), // 200 + 25 + 100
      ],
    );

    blocTest<CartCubit, CartState>(
      'السلة الفاضية مفيهاش ضريبة ولا شحن',
      build: () {
        when(() => cartRepository.watchCart('uid1'))
            .thenAnswer((_) => Stream.value([]));
        return CartCubit(
          cartRepository: cartRepository,
          productRepository: productRepository,
        );
      },
      act: (cubit) => cubit.attachUser('uid1'),
      expect: () => [
        const CartLoading(),
        isA<CartLoaded>()
            .having((s) => s.items, 'items', isEmpty)
            .having((s) => s.tax, 'tax', 0)
            .having((s) => s.delivery, 'delivery', 0),
      ],
    );
  });
}