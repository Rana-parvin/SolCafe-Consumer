import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solcafe/features/cart/domain/entities/cart_item_entity.dart';
import 'package:solcafe/features/cart/presentation/providers/cart_provider.dart';
import 'package:solcafe/features/cart/presentation/screens/cart_item_details_screen.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('User not logged in')),
      );
    }

    final cartAsync = ref.watch(userCartStreamProvider(user.uid));

    return Scaffold(
      appBar: AppBar(title: const Text("Cart items")),
      body: cartAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('Cart is empty'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final cartItem = items[index];

              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CartItemDetailsScreen(
                        image: cartItem.image,
                        name: cartItem.name,
                        description: '',
                        price: cartItem.price,
                        size: cartItem.size,
                        quantity: cartItem.quantity,
                        itemId: cartItem.itemId,
                        itemData: {
                          'name': cartItem.name,
                          'image': cartItem.image,
                          'price': cartItem.price,
                          'size': cartItem.size,
                        },
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: cartItem.image.isNotEmpty
                              ? (cartItem.image.startsWith('http')
                                  ? Image.network(cartItem.image, width: 80, height: 80, fit: BoxFit.cover)
                                  : Image.asset(cartItem.image, width: 80, height: 80, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.coffee, size: 80)))
                              : const Icon(Icons.image, size: 80),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cartItem.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text("Size: ${cartItem.size}"),
                              const SizedBox(height: 4),
                              Text("Quantity: ${cartItem.quantity}"),
                              const SizedBox(height: 4),
                              Text("Price: ₹${cartItem.price.toStringAsFixed(2)}"),
                              const SizedBox(height: 4),
                              Text(
                                "Total: ₹${cartItem.totalPrice.toStringAsFixed(2)}",
                                style: const TextStyle(fontWeight: FontWeight.bold),
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
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
      ),
    );
  }
}

// Backward compatibility aliases
typedef CartsPage = CartScreen;
typedef CartItem = CartItemEntity;
