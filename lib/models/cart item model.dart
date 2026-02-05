class Cartitemmodel {
  final String userid;
  final String itemid;
  final String name;
  final String image;
  final double price;
  final String size;
  final int quantity;

  Cartitemmodel({
    required this.image,
    required this.itemid,
    required this.name,
    required this.price,
    required this.quantity,
    required this.size,
    required this.userid,
  });

  Map<String, dynamic> tojson() {
    return {
      "userId": userid,
      "itemId": itemid,
      "name": name,
      "image": image,
      "price": price,
      "size": size,
      "quantity": quantity,
    };
  }
}
