import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:solcafe/core/presentation/providers/size_logic_provider.dart';
import 'package:solcafe/core/theme/solcafe_colors.dart';
import 'package:solcafe/features/cart/presentation/screens/add_to_cart_screen.dart';
import 'package:solcafe/features/order/presentation/screens/confirm_order_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final String itemid;
  final Map<String, dynamic> itemdata;

  const ProductDetailScreen({
    super.key,
    required this.itemid,
    required this.itemdata,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with TickerProviderStateMixin {
  bool isfavorite = false;
  int quantity = 1;
  String selectedsize = "";
  String selectedtype = "";

  late final AnimationController favController;
  bool showAnim = false;

  @override
  void initState() {
    super.initState();
    favController = AnimationController(vsync: this);

    final category = widget.itemdata['category']?.toLowerCase() ?? "";
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

  @override
  Widget build(BuildContext context) {
    final category = widget.itemdata['category']?.toLowerCase() ?? "";
    final List<String> sizeoptions = Sizelogic.sizesfor(category);
    final colors = context.solcafeColors;

    return Scaffold(
      appBar: AppBar(
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
          if (showAnim)
            Center(
              child: Lottie.asset(
                "assets/anims/Hearts feedback.json",
                controller: favController,
                width: 300,
                height: 300,
                onLoaded: (comp) {
                  favController.duration = comp.duration;
                },
              ),
            ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ItemeImageWidget(imagepath: widget.itemdata["image"] ?? ''),
                  const SizedBox(height: 16),
                  Card(
                    child: ListTile(
                      title: Text(
                        widget.itemdata['name'] ?? widget.itemdata['title'] ?? 'Item',
                        style: GoogleFonts.readexPro(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                      subtitle: widget.itemdata['price'] != null
                          ? Text(
                              "\$${widget.itemdata['price']}",
                              style: GoogleFonts.openSans(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: colors.accentGold,
                              ),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (widget.itemdata['category'] == 'others')
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Select Type",
                            style: GoogleFonts.readexPro(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 10,
                            children: [
                              for (var t in [
                                "Option 1",
                                "Option 2",
                                "Option 3",
                              ])
                                ChoiceChip(
                                  label: Text(t),
                                  selected: selectedtype == t,
                                  selectedColor: colors.accentGold,
                                  labelStyle: TextStyle(
                                    color: selectedtype == t ? colors.textOnAccent : colors.textPrimary,
                                  ),
                                  onSelected: (_) {
                                    setState(() => selectedtype = t);
                                  },
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
                    widget.itemdata["description"] ?? '',
                    style: GoogleFonts.openSans(
                      fontSize: 14,
                      height: 1.5,
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (sizeoptions.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Choose Size",
                            style: GoogleFonts.readexPro(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: colors.textPrimary,
                            ),
                          ),
                          ToggleButtons(
                            borderRadius: BorderRadius.circular(12),
                            selectedColor: colors.textOnAccent,
                            color: colors.textPrimary,
                            fillColor: colors.accentGold,
                            borderColor: colors.borderSubtle,
                            selectedBorderColor: colors.accentGold,
                            onPressed: (index) {
                              setState(() => selectedsize = sizeoptions[index]);
                            },
                            isSelected: sizeoptions
                                .map((s) => s == selectedsize)
                                .toList(),
                            children: sizeoptions
                                .map(
                                  (size) => Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 14),
                                    child: Text(
                                      size,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 12),
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
                          color: colors.surfaceSecondary,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: colors.borderSubtle),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: decrementq,
                              icon: Icon(Icons.remove, color: colors.textPrimary, size: 18),
                            ),
                            Text(
                              quantity.toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: colors.textPrimary,
                              ),
                            ),
                            IconButton(
                              onPressed: incrementq,
                              icon: Icon(Icons.add, color: colors.textPrimary, size: 18),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddToCartScreen(
                                  itemData: widget.itemdata,
                                  size: selectedsize,
                                  quantity: quantity,
                                  itemId: widget.itemid,
                                ),
                              ),
                            );
                          },
                          child: const Text("Add to Cart"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Confirmorder(
                                  itemdata: widget.itemdata,
                                  size: selectedsize,
                                  quantity: quantity,
                                  itemid: widget.itemid,
                                  image: widget.itemdata['image'] ?? '',
                                  name: widget.itemdata['name'] ?? widget.itemdata['title'] ?? 'Item',
                                ),
                              ),
                            );
                          },
                          child: const Text("Order Now"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ItemeImageWidget extends StatelessWidget {
  final String imagepath;
  const ItemeImageWidget({super.key, required this.imagepath});

  @override
  Widget build(BuildContext context) {
    final colors = context.solcafeColors;
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          color: colors.surfaceSecondary,
          child: imagepath.isNotEmpty
              ? (imagepath.startsWith('http://') || imagepath.startsWith('https://')
                  ? Image.network(imagepath, height: 280, width: double.infinity, fit: BoxFit.cover)
                  : Image.asset(imagepath, height: 280, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Icon(Icons.coffee, size: 100, color: colors.textMuted)))
              : Icon(Icons.coffee, size: 100, color: colors.textMuted),
        ),
      ),
    );
  }
}

typedef Viewindetail = ProductDetailScreen;
