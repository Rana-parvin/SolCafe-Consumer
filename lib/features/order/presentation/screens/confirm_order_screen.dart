import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solcafe/core/presentation/providers/size_logic_provider.dart';
import 'package:solcafe/core/presentation/widgets/responsive_layout.dart';
import 'package:solcafe/core/theme/solcafe_colors.dart';
import 'package:solcafe/core/utils/price_parser.dart';
import 'package:solcafe/features/payment/presentation/screens/payment_methods_screen.dart';
import 'package:solcafe/features/settings/presentation/providers/currency_provider.dart';

class ConfirmOrderScreen extends ConsumerStatefulWidget {
  final String itemid;
  final String size;
  final int quantity;
  final String image;
  final String name;
  final Map<String, dynamic> itemdata;

  const ConfirmOrderScreen({
    super.key,
    required this.itemid,
    required this.itemdata,
    required this.quantity,
    required this.size,
    required this.image,
    required this.name,
  });

  @override
  ConsumerState<ConfirmOrderScreen> createState() => _ConfirmOrderScreenState();
}

class _ConfirmOrderScreenState extends ConsumerState<ConfirmOrderScreen> {
  late String currentSize;
  late int currentQuantity;
  late double basePrice;

  @override
  void initState() {
    super.initState();
    currentSize = widget.size;
    currentQuantity = widget.quantity;
    basePrice = parsePrice(widget.itemdata['price']);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.solcafeColors;
    final category = widget.itemdata['category']?.toString().toLowerCase() ?? "";
    final List<String> sizeOptions = Sizelogic.sizesfor(category);
    final String currency = ref.watch(currencySymbolProvider);

    final double unitPrice = Sizelogic.calculateUnitPrice(basePrice, currentSize, category);
    final double totalPrice = unitPrice * currentQuantity;

    final String formattedUnitPrice = "$currency${unitPrice.toStringAsFixed(unitPrice.truncateToDouble() == unitPrice ? 0 : 2)}";
    final String formattedTotalPrice = "$currency${totalPrice.toStringAsFixed(totalPrice.truncateToDouble() == totalPrice ? 0 : 2)}";

    final String? rawDesc = widget.itemdata['description'];
    final String description = (rawDesc != null && rawDesc.trim().isNotEmpty) ? rawDesc.trim() : '';

    return Scaffold(
      backgroundColor: colors.surfacePrimary,
      appBar: AppBar(
        backgroundColor: colors.surfacePrimary,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Confirm Order",
          style: GoogleFonts.readexPro(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border, color: colors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: SolCafeBreakpoints.getResponsivePadding(
                  context,
                  horizontal: SolCafeBreakpoints.isSmallPhone(context) ? 12 : 16,
                  vertical: 10,
                ),
                child: ConstrainedCenterContainer(
                  maxWidth: 650,
                  child: Column(
                    children: [
                      // Top Product Summary Card matching reference screen 2
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: colors.cardBackground,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: colors.cardBorder),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Container(
                                width: 90,
                                height: 90,
                                color: colors.surfaceSecondary,
                                padding: const EdgeInsets.all(6),
                                child: widget.image.isNotEmpty
                                    ? (widget.image.startsWith('http')
                                        ? Image.network(widget.image, fit: BoxFit.contain)
                                        : Image.asset(widget.image, fit: BoxFit.contain, errorBuilder: (_, __, ___) => Icon(Icons.cake, size: 44, color: colors.accentGold)))
                                    : Icon(Icons.cake, size: 44, color: colors.accentGold),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.name,
                                    style: GoogleFonts.readexPro(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: colors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        formattedUnitPrice,
                                        style: GoogleFonts.readexPro(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: colors.accentGold,
                                        ),
                                      ),
                                      if (currentSize.isNotEmpty) ...[
                                        const SizedBox(width: 4),
                                        Text(
                                          "/ $currentSize",
                                          style: GoogleFonts.openSans(
                                            fontSize: 12.5,
                                            color: colors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  if (description.isNotEmpty) ...[
                                    const SizedBox(height: 6),
                                    Text(
                                      description,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.openSans(
                                        fontSize: 12,
                                        height: 1.4,
                                        color: colors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Size and Quantity Selector Card matching reference screen 2
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: colors.cardBackground,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: colors.cardBorder),
                        ),
                        child: Column(
                          children: [
                            // Size Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Size",
                                  style: GoogleFonts.readexPro(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.bold,
                                    color: colors.textPrimary,
                                  ),
                                ),
                                if (sizeOptions.isNotEmpty)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: colors.surfaceSecondary,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: colors.cardBorder),
                                    ),
                                    child: Text(
                                      currentSize,
                                      style: GoogleFonts.readexPro(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.bold,
                                        color: colors.textPrimary,
                                      ),
                                    ),
                                  )
                                else
                                  Text(
                                    currentSize,
                                    style: GoogleFonts.openSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: colors.textPrimary,
                                    ),
                                  ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Divider(height: 1, thickness: 1),
                            ),

                            // Quantity Row with dropdown styling
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Quantity",
                                  style: GoogleFonts.readexPro(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.bold,
                                    color: colors.textPrimary,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: colors.surfaceSecondary,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: colors.cardBorder),
                                  ),
                                  child: PopupMenuButton<int>(
                                    onSelected: (val) => setState(() => currentQuantity = val),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    color: colors.cardBackground,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          currentQuantity.toString(),
                                          style: GoogleFonts.readexPro(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: colors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          size: 20,
                                          color: colors.textSecondary,
                                        ),
                                      ],
                                    ),
                                    itemBuilder: (context) => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((q) {
                                      return PopupMenuItem<int>(
                                        value: q,
                                        child: Text(
                                          q.toString(),
                                          style: GoogleFonts.readexPro(
                                            color: colors.textPrimary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Price Summary Calculation Box matching reference screen 2
                      Container(
                        padding: const EdgeInsets.all(14),
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
                                  currentQuantity.toString(),
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
                      const SizedBox(height: 14),

                      // Delivery Truck Note Box matching reference screen 2
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5DFB8),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(color: const Color(0xFF3E2A1E), width: 1.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.local_shipping_outlined,
                                color: Color(0xFF3E2A1E),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "You will pay when your order is delivered.",
                                style: GoogleFonts.openSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF3E2A1E),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Action Area with Pill Button matching reference screen 2
            Container(
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
                  maxWidth: 650,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.accentGold,
                        foregroundColor: colors.textOnAccent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: () {
                        final Map<String, dynamic> updatedItemData = Map<String, dynamic>.from(widget.itemdata);
                        updatedItemData['price'] = unitPrice;
                        updatedItemData['totalPrice'] = totalPrice;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Paymentmethod(
                              totalprice: totalPrice.toStringAsFixed(2),
                              itemid: widget.itemid,
                              selectedsize: currentSize,
                              selectedquantity: currentQuantity,
                              image: widget.image,
                              name: widget.name,
                            ),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Color(0xFF1C120C),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward_rounded,
                              size: 14,
                              color: Color(0xFFE5B25D),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Proceed to Payment",
                            style: GoogleFonts.readexPro(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1C120C),
                            ),
                          ),
                        ],
                      ),
                    ),
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

typedef Confirmorder = ConfirmOrderScreen;
