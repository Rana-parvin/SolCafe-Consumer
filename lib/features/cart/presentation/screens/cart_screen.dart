import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solcafe/core/presentation/widgets/responsive_layout.dart';
import 'package:solcafe/core/theme/solcafe_colors.dart';
import 'package:solcafe/features/auth/presentation/providers/auth_provider.dart';
import 'package:solcafe/features/cart/domain/entities/cart_item_entity.dart';
import 'package:solcafe/features/cart/presentation/providers/cart_provider.dart';
import 'package:solcafe/features/cart/presentation/screens/cart_item_details_screen.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.solcafeColors;
    final user = ref.watch(currentUserProvider);
    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text('User not logged in', style: TextStyle(color: colors.textSecondary)),
        ),
      );
    }

    final cartAsync = ref.watch(userCartStreamProvider(user.uid));

    return Scaffold(
      appBar: AppBar(title: const Text("Cart Items")),
      body: SafeArea(
        child: cartAsync.when(
          data: (items) {
            if (items.isEmpty) {
              return Center(
                child: Text('Your cart is empty', style: TextStyle(color: colors.textSecondary)),
              );
            }

            return ConstrainedCenterContainer(
              maxWidth: 800,
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final cartItem = items[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Card(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
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
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: SizedBox(
                                  width: 70,
                                  height: 70,
                                  child: cartItem.image.isNotEmpty
                                      ? (cartItem.image.startsWith('http')
                                          ? Image.network(cartItem.image, fit: BoxFit.cover)
                                          : Image.asset(cartItem.image, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Icon(Icons.coffee, size: 40, color: colors.accentGold)))
                                      : Icon(Icons.coffee, size: 40, color: colors.accentGold),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cartItem.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: colors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text("Size: ${cartItem.size}", style: TextStyle(color: colors.textSecondary, fontSize: 13)),
                                    Text("Quantity: ${cartItem.quantity}", style: TextStyle(color: colors.textSecondary, fontSize: 13)),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Total: \$${cartItem.totalPrice.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: colors.accentGold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
          loading: () => Center(child: CircularProgressIndicator(color: colors.accentGold)),
          error: (err, stack) => Center(
            child: Text("Error: $err", style: TextStyle(color: colors.statusCancelledText)),
          ),
        ),
      ),
    );
  }
}

typedef CartsPage = CartScreen;
typedef CartItem = CartItemEntity;
