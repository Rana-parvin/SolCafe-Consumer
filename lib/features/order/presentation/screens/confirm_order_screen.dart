import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solcafe/core/theme/solcafe_colors.dart';
import 'package:solcafe/core/utils/price_parser.dart';
import 'package:solcafe/features/payment/presentation/screens/payment_methods_screen.dart';

class ConfirmOrderScreen extends StatefulWidget {
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
  State<ConfirmOrderScreen> createState() => _ConfirmOrderScreenState();
}

class _ConfirmOrderScreenState extends State<ConfirmOrderScreen> {
  double totalprice = 0;

  @override
  void initState() {
    super.initState();
    totalprice = widget.quantity * parsePrice(widget.itemdata['price']);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.solcafeColors;

    return Scaffold(
      appBar: AppBar(title: const Text("Confirm Order")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    color: colors.surfaceSecondary,
                    child: widget.image.isNotEmpty
                        ? (widget.image.startsWith('http')
                            ? Image.network(widget.image, height: 280, width: double.infinity, fit: BoxFit.cover)
                            : Image.asset(widget.image, height: 280, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Icon(Icons.coffee, size: 100, color: colors.textMuted)))
                        : Icon(Icons.coffee, size: 100, color: colors.textMuted),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                child: ListTile(
                  title: Text(
                    widget.name,
                    style: GoogleFonts.readexPro(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    "Total: \$${totalprice.toStringAsFixed(2)}",
                    style: GoogleFonts.openSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colors.accentGold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (widget.itemdata["description"] != null && widget.itemdata["description"].toString().isNotEmpty) ...[
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
                  widget.itemdata["description"],
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
                    "Selected Size",
                    style: GoogleFonts.readexPro(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                  ),
                  Text(
                    widget.size,
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: colors.accentGoldSubtle,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colors.accentGold),
                    ),
                    child: Text(
                      widget.quantity.toString(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colors.accentGold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Paymentmethod(
                          totalprice: totalprice.toString(),
                          itemid: widget.itemid,
                          selectedsize: widget.size,
                          selectedquantity: widget.quantity,
                          image: widget.image,
                          name: widget.name,
                        ),
                      ),
                    );
                  },
                  child: const Text('Proceed to Payment'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

typedef Confirmorder = ConfirmOrderScreen;
