import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solcafe/features/auth/presentation/providers/auth_provider.dart';
import 'package:solcafe/features/order/domain/entities/order_entity.dart';
import 'package:solcafe/features/order/presentation/providers/order_provider.dart';

Future<String?> createCashOnDeliveryOrder({
  required WidgetRef ref,
  required String itemId,
  required String size,
  required int quantity,
  required String totalPrice,
  required String image,
  required String itemname,
  String? userId,
}) async {
  try {
    final currentUser = ref.read(currentUserProvider);
    final uid = userId ?? currentUser?.uid ?? '';
    if (uid.isEmpty) return null;

    final order = OrderEntity(
      id: '',
      userId: uid,
      itemId: itemId,
      itemName: itemname,
      image: image,
      size: size,
      quantity: quantity,
      totalPrice: double.tryParse(totalPrice) ?? 0.0,
      status: 'pending',
      paymentMethod: 'Cash on delivery',
      orderDate: DateTime.now(),
    );

    return await ref.read(orderPaymentNotifierProvider.notifier).placeOrder(order);
  } catch (e) {
    return null;
  }
}
