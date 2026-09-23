class PaymentEntity {
  final String id;
  final String orderId;
  final String userId;
  final String itemId;
  final String paymentMethod;
  final double amount;
  final String status;
  final DateTime timestamp;

  const PaymentEntity({
    required this.id,
    required this.orderId,
    required this.userId,
    required this.itemId,
    required this.paymentMethod,
    required this.amount,
    required this.status,
    required this.timestamp,
  });
}
