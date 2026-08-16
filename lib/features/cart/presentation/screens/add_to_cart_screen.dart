import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solcafe/features/cart/data/models/cart_item_model.dart';
import 'package:solcafe/features/cart/presentation/providers/cart_provider.dart';
import 'package:solcafe/features/cart/presentation/screens/cart_screen.dart';
import 'package:solcafe/features/cart/presentation/widgets/added_to_cart_dialog.dart';

class AddToCartScreen extends ConsumerStatefulWidget {
  final String itemId;
  final String size;
  final int quantity;
  final Map<String, dynamic> itemData;

  const AddToCartScreen({
    super.key,
    required this.itemId,
    required this.itemData,
    required this.quantity,
    required this.size,
  });

  @override
  ConsumerState<AddToCartScreen> createState() => _AddToCartScreenState();
}

class _AddToCartScreenState extends ConsumerState<AddToCartScreen> {
  bool _isLoading = false;

  Future<void> handleAddToCart(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please login first")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final String itemName = widget.itemData['name'] ?? widget.itemData['title'] ?? 'Item';
      final String imagePath = widget.itemData['image'] ?? '';
      final double price = double.tryParse(widget.itemData['price']?.toString() ?? '0') ?? 0.0;

      final cartItem = CartItemModel(
        id: '',
        userId: user.uid,
        itemId: widget.itemId,
        name: itemName,
        price: price,
        image: imagePath,
        quantity: widget.quantity,
        size: widget.size,
      );

      final addToCartUseCase = ref.read(addToCartUseCaseProvider);
      await addToCartUseCase(cartItem);

      await addedToCart(
        itemId: widget.itemId,
        itemName: itemName,
        price: price,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Item added to cart")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CartScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add to cart: $e")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String name = widget.itemData['name'] ?? widget.itemData['title'] ?? 'Item';
    final String image = widget.itemData['image'] ?? '';
    final priceVal = widget.itemData['price'];
    final String description = widget.itemData['description'] ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Add to Cart')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: image.isNotEmpty
                      ? (image.startsWith('http')
                          ? Image.network(image, height: 320, width: double.infinity, fit: BoxFit.cover)
                          : Image.asset(image, height: 320, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.coffee, size: 100)))
                      : const Icon(Icons.coffee, size: 100),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                color: const Color(0xFF251806),
                child: ListTile(
                  title: Text(
                    name,
                    style: GoogleFonts.adventPro(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFF5E1C0),
                    ),
                  ),
                  subtitle: Text(
                    '\$ $priceVal',
                    style: GoogleFonts.openSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFDAA520),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (description.isNotEmpty) ...[
                const Text(
                  'Description',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: GoogleFonts.openSans(fontSize: 14, height: 1.5),
                ),
                const SizedBox(height: 16),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Selected Size',
                    style: GoogleFonts.openSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(widget.size),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'Quantity',
                    style: GoogleFonts.openSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF251806),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.quantity.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : () => handleAddToCart(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF251806),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Add to Cart',
                          style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Backward compatibility alias
typedef AddToCartPage = AddToCartScreen;
