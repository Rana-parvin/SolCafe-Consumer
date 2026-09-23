class OrderEntity {
  final String id;
  final String userId;
  final String itemId;
  final String itemName;
  final String image;
  final String size;
  final int quantity;
  final double totalPrice;
  final String status;
  final String paymentMethod;
  final DateTime orderDate;

  const OrderEntity({
    required this.id,
    required this.userId,
    required this.itemId,
    required this.itemName,
    required this.image,
    required this.size,
    required this.quantity,
    required this.totalPrice,
    required this.status,
    required this.paymentMethod,
    required this.orderDate,
  });
}
