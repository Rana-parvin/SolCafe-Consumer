import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solcafe/core/presentation/widgets/responsive_layout.dart';
import 'package:solcafe/core/theme/solcafe_colors.dart';
import 'package:solcafe/features/auth/presentation/providers/auth_provider.dart';
import 'package:solcafe/features/order/presentation/providers/order_provider.dart';
import 'package:solcafe/features/settings/presentation/providers/currency_provider.dart';

class OrderHistoryScreen extends ConsumerWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.solcafeColors;
    final user = ref.watch(currentUserProvider);
    final currency = ref.watch(currencySymbolProvider);

    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text(
            'User not logged in',
            style: GoogleFonts.openSans(color: colors.textSecondary),
          ),
        ),
      );
    }

    final ordersAsync = ref.watch(userOrderHistoryStreamProvider(user.uid));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Orders",
          style: GoogleFonts.readexPro(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ordersAsync.when(
          data: (orders) {
            if (orders.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 64,
                        color: colors.accentGold.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Looks like your order list is lonely.\nHow about a warm welcome cup?",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.readexPro(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          height: 1.5,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ConstrainedCenterContainer(
              maxWidth: 800,
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  final String orderDateStr = order.orderDate.toString().length >= 16
                      ? order.orderDate.toString().substring(0, 16)
                      : order.orderDate.toString();

                  final String statusText = order.status.toUpperCase();
                  final bool isPending = order.status.toLowerCase() == 'pending';
                  final Color statusBg = isPending ? Colors.orange.withValues(alpha: 0.15) : Colors.green.withValues(alpha: 0.15);
                  final Color statusColor = isPending ? Colors.orange : Colors.green;

                  final String formattedTotal = "$currency${order.totalPrice.toStringAsFixed(order.totalPrice.truncateToDouble() == order.totalPrice ? 0 : 2)}";

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Card(
                      color: colors.cardBackground,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: colors.cardBorder),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: SizedBox(
                                width: 64,
                                height: 64,
                                child: order.image.isNotEmpty
                                    ? (order.image.startsWith('http')
                                        ? Image.network(order.image, fit: BoxFit.cover)
                                        : Image.asset(order.image, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Icon(Icons.coffee, color: colors.accentGold, size: 36)))
                                    : Icon(Icons.coffee, color: colors.accentGold, size: 36),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          order.itemName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.readexPro(
                                            color: colors.textPrimary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.5,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        formattedTotal,
                                        style: GoogleFonts.readexPro(
                                          color: colors.accentGold,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      if (order.size.isNotEmpty) ...[
                                        Text(
                                          "Size: ${order.size}",
                                          style: GoogleFonts.openSans(
                                            color: colors.textSecondary,
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                      ],
                                      Text(
                                        "Qty: ${order.quantity}",
                                        style: GoogleFonts.openSans(
                                          color: colors.textSecondary,
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        orderDateStr,
                                        style: GoogleFonts.openSans(
                                          color: colors.textMuted,
                                          fontSize: 11.5,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: statusBg,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          statusText,
                                          style: GoogleFonts.openSans(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.bold,
                                            color: statusColor,
                                          ),
                                        ),
                                      ),
                                    ],
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
              ),
            );
          },
          loading: () => Center(
            child: CircularProgressIndicator(color: colors.accentGold),
          ),
          error: (err, stack) => Center(
            child: Text(
              err.toString(),
              style: TextStyle(color: colors.statusCancelledText),
            ),
          ),
        ),
      ),
    );
  }
}

typedef Orders = OrderHistoryScreen;
