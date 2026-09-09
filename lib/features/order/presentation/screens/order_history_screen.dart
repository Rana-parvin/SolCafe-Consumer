import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solcafe/core/theme/solcafe_colors.dart';
import 'package:solcafe/features/auth/presentation/providers/auth_provider.dart';
import 'package:solcafe/features/order/presentation/providers/order_provider.dart';

class OrderHistoryScreen extends ConsumerWidget {
  const OrderHistoryScreen({super.key});

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

    final ordersAsync = ref.watch(userOrderHistoryStreamProvider(user.uid));

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
        centerTitle: true,
      ),
      body: ordersAsync.when(
        data: (orders) {
          if (orders.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  "Looks like your order list is lonely.\nHow about a warm welcome cup?",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.readexPro(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    height: 1.6,
                    color: colors.textSecondary,
                  ),
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: order.image.isNotEmpty
                            ? (order.image.startsWith('http')
                                ? Image.network(order.image, fit: BoxFit.cover)
                                : Image.asset(order.image, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Icon(Icons.coffee, color: colors.accentGold)))
                            : Icon(Icons.coffee, color: colors.accentGold),
                      ),
                    ),
                    title: Text(
                      order.itemName,
                      style: GoogleFonts.readexPro(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      "Ordered on ${order.orderDate.toString().substring(0, 16)}",
                      style: GoogleFonts.openSans(color: colors.textSecondary, fontSize: 13),
                    ),
                    trailing: Text(
                      "\$${order.totalPrice.toStringAsFixed(2)}",
                      style: GoogleFonts.openSans(
                        color: colors.accentGold,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator(color: colors.accentGold)),
        error: (err, stack) => Center(
          child: Text(
            err.toString(),
            style: TextStyle(color: colors.statusCancelledText),
          ),
        ),
      ),
    );
  }
}

typedef Orders = OrderHistoryScreen;
