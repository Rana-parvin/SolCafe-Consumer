import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solcafe/features/auth/presentation/providers/auth_provider.dart';
import 'package:solcafe/features/order/domain/entities/order_entity.dart';
import 'package:solcafe/features/order/presentation/providers/order_provider.dart';

Future<bool> upiPayment({
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
    if (uid.isEmpty) return false;

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
      paymentMethod: 'UPI payment',
      orderDate: DateTime.now(),
    );

    final orderId = await ref.read(orderPaymentNotifierProvider.notifier).placeOrder(order);
    return orderId != null;
  } catch (e) {
    return false;
  }
}

// Backward compatibility alias
// ignore: non_constant_identifier_names
final UPIpayment = upiPayment;
