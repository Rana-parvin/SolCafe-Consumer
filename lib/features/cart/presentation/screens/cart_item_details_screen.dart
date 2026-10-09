import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solcafe/core/presentation/widgets/responsive_layout.dart';
import 'package:solcafe/core/theme/solcafe_colors.dart';
import 'package:solcafe/features/order/presentation/screens/confirm_order_screen.dart';
import 'package:solcafe/features/settings/presentation/providers/currency_provider.dart';

class CartItemDetailsScreen extends ConsumerWidget {
  final String itemId;
  final Map<String, dynamic> itemData;

  final String image;
  final String name;
  final String description;
  final double price;
  final String size;
  final int quantity;

  const CartItemDetailsScreen({
    super.key,
    required this.image,
    required this.name,
    required this.description,
    required this.price,
    required this.size,
    required this.quantity,
    required this.itemId,
    required this.itemData,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.solcafeColors;
    final imageHeight = SolCafeBreakpoints.isLandscape(context) ? 160.0 : 250.0;
    final currency = ref.watch(currencySymbolProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(name, style: GoogleFonts.readexPro(fontSize: 20)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedCenterContainer(
            maxWidth: 700,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      color: colors.surfaceSecondary,
                      constraints: BoxConstraints(maxHeight: imageHeight),
                      width: double.infinity,
                      child: image.isNotEmpty
                          ? (image.startsWith('http')
                              ? Image.network(image, fit: BoxFit.cover)
                              : Image.asset(image, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Icon(Icons.coffee, size: 80, color: colors.textMuted)))
                          : Icon(Icons.coffee, size: 80, color: colors.textMuted),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.readexPro(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "$currency${price.toStringAsFixed(price.truncateToDouble() == price ? 0 : 2)}",
                      style: GoogleFonts.openSans(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colors.accentGold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (description.isNotEmpty) ...[
                  Text(
                    "Description",
                    style: GoogleFonts.readexPro(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: GoogleFonts.openSans(
                      fontSize: 14,
                      height: 1.5,
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Selected Size",
                      style: GoogleFonts.readexPro(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                    ),
                    Text(
                      size,
                      style: GoogleFonts.openSans(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Quantity",
                      style: GoogleFonts.readexPro(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                    ),
                    Text(
                      quantity.toString(),
                      style: GoogleFonts.openSans(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Confirmorder(
                            itemid: itemId,
                            itemdata: itemData,
                            quantity: quantity,
                            size: size,
                            image: image,
                            name: name,
                          ),
                        ),
                      );
                    },
                    child: const Text("Order Now"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

typedef CartItemDetailsPage = CartItemDetailsScreen;
