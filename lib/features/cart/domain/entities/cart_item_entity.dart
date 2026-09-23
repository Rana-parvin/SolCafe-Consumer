class CartItemEntity {
  final String id;
  final String userId;
  final String itemId;
  final String name;
  final double price;
  final String image;
  final int quantity;
  final String size;

  const CartItemEntity({
    required this.id,
    required this.userId,
    required this.itemId,
    required this.name,
    required this.price,
    required this.image,
    required this.quantity,
    required this.size,
  });

  double get totalPrice => price * quantity;
}
