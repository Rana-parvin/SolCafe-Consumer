import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solcafe/features/order/presentation/providers/order_provider.dart';

class OrderHistoryScreen extends ConsumerWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('User not logged in')),
      );
    }

    final ordersAsync = ref.watch(userOrderHistoryStreamProvider(user.uid));

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          "My Orders",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ordersAsync.when(
        data: (orders) {
          if (orders.isEmpty) {
            return Center(
              child: Text(
                "Looks like your order list is lonely.\nHow about a warm welcome cup?",
                textAlign: TextAlign.center,
                style: GoogleFonts.raleway(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  height: 2,
                  color: Colors.white,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];

              return Card(
                color: Colors.brown.shade800,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: order.image.isNotEmpty
                        ? (order.image.startsWith('http')
                            ? Image.network(order.image, width: 50, height: 50, fit: BoxFit.cover)
                            : Image.asset(order.image, width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.coffee, color: Colors.white)))
                        : const Icon(Icons.coffee, color: Colors.white),
                  ),
                  title: Text(
                    order.itemName,
                    style: GoogleFonts.raleway(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "Ordered on ${order.orderDate.toString().substring(0, 16)}",
                    style: GoogleFonts.raleway(color: Colors.white70),
                  ),
                  trailing: Text(
                    "₹${order.totalPrice.toStringAsFixed(2)}",
                    style: GoogleFonts.raleway(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text(
            err.toString(),
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}

// Backward compatibility alias
typedef Orders = OrderHistoryScreen;
