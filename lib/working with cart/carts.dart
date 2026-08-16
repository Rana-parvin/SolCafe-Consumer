import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:solcafe/working%20with%20cart/cart%20item%20show.dart';

// Cart item model
class CartItem {
  final String id;
  final String name;
  final double price;
  final String image;
  final int quantity;
  final String size;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.quantity,
    required this.size,
  });
}

class CartsPage extends StatelessWidget {
  const CartsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('User not logged in')),
      );
    }

    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final cartStream = FirebaseFirestore.instance
        .collection('cart items')
        .where(Filter.or(
          Filter('userId', isEqualTo: user.uid),
          Filter('userId', isEqualTo: userRef),
        ))
        .snapshots();

    return Scaffold(
      appBar: AppBar(title: const Text("Cart items")),
      body: StreamBuilder<QuerySnapshot>(
        stream: cartStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Cart is empty'));
          }

          final cartDocs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: cartDocs.length,
            itemBuilder: (context, index) {
              final doc = cartDocs[index];
              final data = doc.data() as Map<String, dynamic>;
              
              // Safe extraction of item document reference or ID
              DocumentReference? itemRef;
              if (data['itemId'] is DocumentReference) {
                itemRef = data['itemId'] as DocumentReference;
              } else if (data['itemId'] is String && (data['itemId'] as String).isNotEmpty) {
                itemRef = FirebaseFirestore.instance.collection('items').doc(data['itemId'] as String);
              }

              final String itemIdStr = itemRef?.id ?? doc.id;
              final Future<DocumentSnapshot<Map<String, dynamic>>?> itemFuture = itemRef != null
                  ? itemRef.get().then((d) => d as DocumentSnapshot<Map<String, dynamic>>)
                  : Future.value(null);

              return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
                future: itemFuture,
                builder: (context, itemSnapshot) {
                  final itemData = itemSnapshot.data?.data() ?? data;
                  final String itemName = itemData['name'] ?? itemData['title'] ?? data['name'] ?? 'Item';
                  final String itemImage = itemData['image'] ?? data['image'] ?? 'assets/images/coffee.jpg';
                  final double itemPrice = double.tryParse(itemData['price']?.toString() ?? data['price']?.toString() ?? '0') ?? 0.0;


                  final cartItem = CartItem(
                    id: doc.id,
                    name: itemName,
                    price: itemPrice, 
                    image: itemImage,
                    quantity: data['quantity'] is int ? data['quantity'] as int : int.tryParse(data['quantity']?.toString() ?? '1') ?? 1,
                    size: data['size']?.toString() ?? 'M',
                  );

                  return InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CartItemDetailsPage(
                            image: cartItem.image,
                            name: cartItem.name,
                            description: itemData['description'] ?? '',
                            price: cartItem.price,
                            size: cartItem.size,
                            quantity: cartItem.quantity,
                            itemId: itemIdStr,
                            itemData: itemData,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Item image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: cartItem.image.isNotEmpty
                                  ? Image.asset(
                                      cartItem.image,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(Icons.image, size: 80),
                            ),
                            const SizedBox(width: 12),
                            // Item details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(cartItem.name,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 6),
                                  Text("Size: ${cartItem.size}"),
                                  const SizedBox(height: 4),
                                  Text("Quantity: ${cartItem.quantity}"),
                                  const SizedBox(height: 4),
                                  Text(
                                      "Price: ₹${cartItem.price.toStringAsFixed(2)}"),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Total: ₹${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
