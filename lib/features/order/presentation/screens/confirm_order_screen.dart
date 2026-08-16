import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: widget.image.isNotEmpty
                      ? (widget.image.startsWith('http')
                          ? Image.network(widget.image, height: 329, width: double.infinity, fit: BoxFit.cover)
                          : Image.asset(widget.image, height: 329, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.coffee, size: 100)))
                      : const Icon(Icons.coffee, size: 100),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                color: const Color.fromARGB(255, 37, 24, 6),
                child: ListTile(
                  title: Text(
                    widget.name,
                    style: GoogleFonts.adventPro(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFF5E1C0),
                    ),
                  ),
                  subtitle: Text(
                    "Total: \$ $totalprice",
                    style: GoogleFonts.openSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFDAA520),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Description",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Text(
                    widget.itemdata["description"] ?? '',
                    style: GoogleFonts.openSans(
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Selected Size",
                      style: GoogleFonts.openSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(widget.size),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    "Quantity",
                    style: GoogleFonts.openSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 37, 24, 6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.quantity.toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
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
                  child: const Text('Confirm Order'),
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
typedef Confirmorder = ConfirmOrderScreen;
