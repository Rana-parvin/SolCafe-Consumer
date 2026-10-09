import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solcafe/core/presentation/widgets/responsive_layout.dart';
import 'package:solcafe/core/theme/solcafe_colors.dart';
import 'package:solcafe/features/auth/presentation/providers/auth_provider.dart';
import 'package:solcafe/features/cart/data/models/cart_item_model.dart';
import 'package:solcafe/features/cart/presentation/providers/cart_provider.dart';
import 'package:solcafe/features/cart/presentation/screens/cart_screen.dart';
import 'package:solcafe/features/cart/presentation/widgets/added_to_cart_dialog.dart';
import 'package:solcafe/features/settings/presentation/providers/currency_provider.dart';

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
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final user = ref.read(currentUserProvider);

    if (user == null) {
      messenger.showSnackBar(
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
      messenger.showSnackBar(
        const SnackBar(content: Text("Item added to cart")),
      );

      navigator.pushReplacement(
        MaterialPageRoute(builder: (_) => const CartScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
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
    final colors = context.solcafeColors;
    final imageHeight = SolCafeBreakpoints.isLandscape(context) ? 160.0 : 250.0;
    final currency = ref.watch(currencySymbolProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Add to Cart')),
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
                Card(
                  child: ListTile(
                    title: Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.readexPro(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      '$currency$priceVal',
                      style: GoogleFonts.openSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colors.accentGold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (description.isNotEmpty) ...[
                  Text(
                    'Description',
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
                  const SizedBox(height: 16),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Selected Size',
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                    Text(
                      widget.size,
                      style: TextStyle(color: colors.textSecondary, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      'Quantity',
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: colors.accentGoldSubtle,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colors.accentGold),
                      ),
                      child: Text(
                        widget.quantity.toString(),
                        style: TextStyle(color: colors.accentGold, fontSize: 16, fontWeight: FontWeight.bold),
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
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Add to Cart'),
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

typedef AddToCartPage = AddToCartScreen;
