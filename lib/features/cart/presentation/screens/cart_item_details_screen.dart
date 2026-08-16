import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solcafe/features/order/presentation/screens/confirm_order_screen.dart';

class CartItemDetailsScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF251806),
        title: Text(name, style: GoogleFonts.adventPro(fontSize: 22)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: image.isNotEmpty
                    ? (image.startsWith('http')
                        ? Image.network(image, height: 300, width: double.infinity, fit: BoxFit.cover)
                        : Image.asset(image, height: 300, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.coffee, size: 100)))
                    : const Icon(Icons.coffee, size: 100),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: GoogleFonts.adventPro(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "₹${price.toStringAsFixed(2)}",
                  style: GoogleFonts.openSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFDAA520),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (description.isNotEmpty) ...[
              Text(
                "Description",
                style: GoogleFonts.openSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: GoogleFonts.openSans(fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 20),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Selected Size",
                  style: GoogleFonts.openSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  size,
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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
                  style: GoogleFonts.openSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  quantity.toString(),
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 45, 29, 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Order Now",
                  style: GoogleFonts.openSans(
                    color: Colors.amber,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Backward compatibility alias
typedef CartItemDetailsPage = CartItemDetailsScreen;
