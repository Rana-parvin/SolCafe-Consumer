import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:solcafe/core/presentation/providers/size_logic_provider.dart';
import 'package:solcafe/core/presentation/widgets/responsive_layout.dart';
import 'package:solcafe/core/theme/solcafe_colors.dart';
import 'package:solcafe/core/utils/price_parser.dart';
import 'package:solcafe/features/auth/presentation/providers/auth_provider.dart';
import 'package:solcafe/features/cart/data/models/cart_item_model.dart';
import 'package:solcafe/features/cart/presentation/providers/cart_provider.dart';
import 'package:solcafe/features/cart/presentation/screens/cart_screen.dart';
import 'package:solcafe/features/cart/presentation/widgets/added_to_cart_dialog.dart';
import 'package:solcafe/features/order/presentation/screens/confirm_order_screen.dart';
import 'package:solcafe/features/settings/presentation/providers/currency_provider.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String itemid;
  final Map<String, dynamic> itemdata;

  const ProductDetailScreen({
    super.key,
    required this.itemid,
    required this.itemdata,
  });

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen>
    with TickerProviderStateMixin {
  bool isfavorite = false;
  int quantity = 1;
  String selectedsize = "";
  String selectedtype = "";
  bool _isAddingToCart = false;

  late final AnimationController favController;
  bool showAnim = false;

  @override
  void initState() {
    super.initState();
    favController = AnimationController(vsync: this);

    final category = widget.itemdata['category']?.toString().toLowerCase() ?? "";
    final List<String> sizes = Sizelogic.sizesfor(category);
    if (sizes.isNotEmpty) {
      selectedsize = sizes.first;
    }
  }

  void incrementq() => setState(() {
        quantity++;
      });

  void decrementq() => setState(() {
        if (quantity > 1) {
          quantity--;
        }
      });

  @override
  void dispose() {
    favController.dispose();
    super.dispose();
  }

  Future<void> _handleAddToCart({
    required BuildContext context,
    required String name,
    required String image,
    required double unitPrice,
    required String formattedTotalPrice,
  }) async {
    if (_isAddingToCart) return;

    final user = ref.read(currentUserProvider);
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please login first to add items to cart")),
      );
      return;
    }

    setState(() => _isAddingToCart = true);

    try {
      final cartItem = CartItemModel(
        id: '',
        userId: user.uid,
        itemId: widget.itemid,
        name: name.isNotEmpty ? name : 'Item',
        price: unitPrice,
        image: image,
        quantity: quantity,
        size: selectedsize,
      );

      final addToCartUseCase = ref.read(addToCartUseCaseProvider);
      await addToCartUseCase(cartItem);

      await addedToCart(
        itemId: widget.itemid,
        itemName: name.isNotEmpty ? name : 'Item',
        price: unitPrice,
      );

      if (!context.mounted) return;
      _showAddToCartSuccessBottomSheet(
        context: context,
        name: name.isNotEmpty ? name : 'Item',
        image: image,
        size: selectedsize,
        quantity: quantity,
        formattedTotal: formattedTotalPrice,
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add to cart: $e")),
      );
    } finally {
      if (mounted) {
        setState(() => _isAddingToCart = false);
      }
    }
  }

  void _showAddToCartSuccessBottomSheet({
    required BuildContext context,
    required String name,
    required String image,
    required String size,
    required int quantity,
    required String formattedTotal,
  }) {
    final colors = context.solcafeColors;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: colors.surfacePrimary,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: colors.cardBorder),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.borderSubtle,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Success Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50).withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_circle_rounded,
                          color: Color(0xFF4CAF50),
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Added to your cart",
                              style: GoogleFonts.readexPro(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: colors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Item is ready in your cart",
                              style: GoogleFonts.openSans(
                                fontSize: 12.5,
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Compact Item Preview Card
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colors.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colors.cardBorder),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: 54,
                            height: 54,
                            color: colors.surfaceSecondary,
                            padding: const EdgeInsets.all(4),
                            child: image.isNotEmpty
                                ? (image.startsWith('http')
                                    ? Image.network(image, fit: BoxFit.contain)
                                    : Image.asset(image, fit: BoxFit.contain, errorBuilder: (_, __, ___) => Icon(Icons.cake, color: colors.accentGold, size: 28)))
                                : Icon(Icons.cake, color: colors.accentGold, size: 28),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.readexPro(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: colors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                "${size.isNotEmpty ? '$size  •  ' : ''}Qty: $quantity",
                                style: GoogleFonts.openSans(
                                  fontSize: 12.5,
                                  color: colors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          formattedTotal,
                          style: GoogleFonts.readexPro(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colors.accentGold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Action Buttons Row
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              side: BorderSide(color: colors.cardBorder, width: 1.2),
                              foregroundColor: colors.textPrimary,
                            ),
                            onPressed: () => Navigator.pop(ctx),
                            child: Text(
                              "Continue Shopping",
                              style: GoogleFonts.readexPro(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.accentGold,
                              foregroundColor: colors.textOnAccent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(ctx);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const CartScreen()),
                              );
                            },
                            child: Text(
                              "View Cart",
                              style: GoogleFonts.readexPro(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final category = widget.itemdata['category']?.toString().toLowerCase() ?? "";
    final List<String> sizeoptions = Sizelogic.sizesfor(category);
    final colors = context.solcafeColors;
    final isWide = MediaQuery.of(context).size.width >= 600;

    final double basePrice = parsePrice(widget.itemdata['price']);
    final double unitPrice = Sizelogic.calculateUnitPrice(basePrice, selectedsize, category);
    final double totalPrice = unitPrice * quantity;
    final String currency = ref.watch(currencySymbolProvider);

    final String name = widget.itemdata['name'] ?? widget.itemdata['title'] ?? widget.itemdata['itemname'] ?? '';
    final String image = widget.itemdata['image'] ?? '';
    final String? rawDesc = widget.itemdata['description'];
    final String description = (rawDesc != null && rawDesc.trim().isNotEmpty) ? rawDesc.trim() : '';

    final String formattedUnitPrice = "$currency${unitPrice.toStringAsFixed(unitPrice.truncateToDouble() == unitPrice ? 0 : 2)}";
    final String formattedTotalPrice = "$currency${totalPrice.toStringAsFixed(totalPrice.truncateToDouble() == totalPrice ? 0 : 2)}";

    return Scaffold(
      backgroundColor: colors.surfacePrimary,
      appBar: AppBar(
        backgroundColor: colors.surfacePrimary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isfavorite ? Icons.favorite : Icons.favorite_border,
              color: isfavorite ? Colors.redAccent : colors.textPrimary,
            ),
            onPressed: () async {
              setState(() => isfavorite = !isfavorite);

              if (isfavorite) {
                setState(() => showAnim = true);
                await favController.forward(from: 0);
                setState(() => showAnim = false);
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: SolCafeBreakpoints.getResponsivePadding(
                    context,
                    horizontal: SolCafeBreakpoints.isSmallPhone(context) ? 12 : 16,
                    vertical: 8,
                  ),
                  child: ConstrainedCenterContainer(
                    maxWidth: 900,
                    child: isWide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 5,
                                child: ItemeImageWidget(imagepath: image),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                flex: 6,
                                child: _buildDetailsContent(
                                  context,
                                  colors,
                                  sizeoptions,
                                  name,
                                  description,
                                  category,
                                  basePrice,
                                  unitPrice,
                                  totalPrice,
                                  currency,
                                  formattedUnitPrice,
                                  formattedTotalPrice,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ItemeImageWidget(imagepath: image),
                              const SizedBox(height: 16),
                              _buildDetailsContent(
                                context,
                                colors,
                                sizeoptions,
                                name,
                                description,
                                category,
                                basePrice,
                                unitPrice,
                                totalPrice,
                                currency,
                                formattedUnitPrice,
                                formattedTotalPrice,
                              ),
                            ],
                          ),
                  ),
                ),
              ),

              // Bottom Action Area matching reference screen 1
              _buildBottomActionBar(
                context,
                colors,
                unitPrice,
                totalPrice,
                currency,
                image,
                name,
                formattedTotalPrice,
              ),
            ],
          ),
          if (showAnim)
            IgnorePointer(
              child: Center(
                child: Lottie.asset(
                  "assets/anims/Hearts feedback.json",
                  controller: favController,
                  width: 240,
                  height: 240,
                  onLoaded: (comp) {
                    favController.duration = comp.duration;
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailsContent(
    BuildContext context,
    SolCafeColors colors,
    List<String> sizeoptions,
    String name,
    String description,
    String category,
    double basePrice,
    double unitPrice,
    double totalPrice,
    String currency,
    String formattedUnitPrice,
    String formattedTotalPrice,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Name & Price Header
        if (name.isNotEmpty) ...[
          Text(
            name,
            style: GoogleFonts.readexPro(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
        ],
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              formattedUnitPrice,
              style: GoogleFonts.readexPro(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: colors.accentGold,
              ),
            ),
            if (selectedsize.isNotEmpty) ...[
              const SizedBox(width: 6),
              Text(
                "/ $selectedsize",
                style: GoogleFonts.openSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colors.textSecondary,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),

        // Rating Line
        Row(
          children: [
            Icon(Icons.star_rounded, color: colors.accentGold, size: 18),
            const SizedBox(width: 4),
            Text(
              "4.8",
              style: GoogleFonts.openSans(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              "(124 reviews)",
              style: GoogleFonts.openSans(
                fontSize: 13,
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),

        // Description Section (only shown if description exists)
        if (description.isNotEmpty) ...[
          Text(
            "Description",
            style: GoogleFonts.readexPro(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: GoogleFonts.openSans(
              fontSize: 13.5,
              height: 1.45,
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
        ],

        // Size Selection Section with Card Treatment
        if (sizeoptions.isNotEmpty) ...[
          Text(
            "Size",
            style: GoogleFonts.readexPro(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: sizeoptions.map((s) {
              final isSelected = selectedsize == s;
              final sizePrice = Sizelogic.calculateUnitPrice(basePrice, s, category);
              final String sizePriceStr = "$currency${sizePrice.toStringAsFixed(sizePrice.truncateToDouble() == sizePrice ? 0 : 2)}";

              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => setState(() => selectedsize = s),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      width: 105,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? colors.accentGold : colors.cardBackground,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? colors.accentGold : colors.cardBorder,
                          width: 1.2,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            s,
                            style: GoogleFonts.readexPro(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? colors.textOnAccent : colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            sizePriceStr,
                            style: GoogleFonts.openSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? colors.textOnAccent : colors.accentGold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
        ],

        // Quantity Stepper Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Quantity",
              style: GoogleFonts.readexPro(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: colors.cardBackground,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: colors.cardBorder, width: 1.2),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove, size: 18, color: colors.textPrimary),
                    onPressed: quantity > 1 ? decrementq : null,
                    splashRadius: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      quantity.toString(),
                      style: GoogleFonts.readexPro(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add, size: 18, color: colors.textPrimary),
                    onPressed: incrementq,
                    splashRadius: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Price Summary Breakdown Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.cardBorder),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Unit Price",
                    style: GoogleFonts.openSans(
                      fontSize: 13,
                      color: colors.textSecondary,
                    ),
                  ),
                  Text(
                    formattedUnitPrice,
                    style: GoogleFonts.openSans(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Quantity",
                    style: GoogleFonts.openSans(
                      fontSize: 13,
                      color: colors.textSecondary,
                    ),
                  ),
                  Text(
                    quantity.toString(),
                    style: GoogleFonts.openSans(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(height: 1, thickness: 1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: GoogleFonts.readexPro(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                  ),
                  Text(
                    formattedTotalPrice,
                    style: GoogleFonts.readexPro(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colors.accentGold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildBottomActionBar(
    BuildContext context,
    SolCafeColors colors,
    double unitPrice,
    double totalPrice,
    String currency,
    String image,
    String name,
    String formattedTotalPrice,
  ) {
    final Map<String, dynamic> updatedItemData = Map<String, dynamic>.from(widget.itemdata);
    updatedItemData['price'] = unitPrice;
    updatedItemData['totalPrice'] = totalPrice;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.surfacePrimary,
        border: Border(
          top: BorderSide(color: colors.borderSubtle, width: 1.0),
        ),
      ),
      child: SafeArea(
        top: false,
        bottom: true,
        child: ConstrainedCenterContainer(
          maxWidth: 900,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      side: BorderSide(color: colors.cardBorder, width: 1.2),
                      foregroundColor: colors.textPrimary,
                    ),
                    icon: _isAddingToCart
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colors.accentGold,
                            ),
                          )
                        : Icon(Icons.shopping_cart_outlined, size: 18, color: colors.textPrimary),
                    onPressed: _isAddingToCart
                        ? null
                        : () => _handleAddToCart(
                              context: context,
                              name: name,
                              image: image,
                              unitPrice: unitPrice,
                              formattedTotalPrice: formattedTotalPrice,
                            ),
                    label: Text(
                      _isAddingToCart ? "Adding..." : "Add to Cart",
                      style: GoogleFonts.readexPro(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.accentGold,
                      foregroundColor: colors.textOnAccent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Confirmorder(
                            itemdata: updatedItemData,
                            size: selectedsize,
                            quantity: quantity,
                            itemid: widget.itemid,
                            image: image,
                            name: name,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "Order Now",
                      style: GoogleFonts.readexPro(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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

class ItemeImageWidget extends StatelessWidget {
  final String imagepath;
  const ItemeImageWidget({
    super.key,
    required this.imagepath,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.solcafeColors;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        color: colors.cardBackground,
        width: double.infinity,
        child: AspectRatio(
          aspectRatio: 1.0,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: colors.cardBorder),
              borderRadius: BorderRadius.circular(20),
            ),
            child: imagepath.isNotEmpty
                ? (imagepath.startsWith('http://') || imagepath.startsWith('https://'))
                    ? Image.network(imagepath, fit: BoxFit.contain)
                    : Image.asset(
                        imagepath,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.cake,
                          size: 80,
                          color: colors.accentGold,
                        ),
                      )
                : Icon(
                    Icons.cake,
                    size: 80,
                    color: colors.accentGold,
                  ),
          ),
        ),
      ),
    );
  }
}

typedef Viewindetail = ProductDetailScreen;
