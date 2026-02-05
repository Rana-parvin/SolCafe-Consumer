import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solcafe/utils/price%20parser.dart';
import 'package:solcafe/working%20with%20payment/payment%20method.dart';

class Confirmorder extends StatefulWidget {
  final String itemid;
  final String size;
  final int quantity;
  final String image;
  final String name;
  final Map<String, dynamic> itemdata;

  const Confirmorder({
    super.key,
    required this.itemid,
    required this.itemdata,
    required this.quantity,
    required this.size, required this.image, required this.name,
  });

  @override
  State<Confirmorder> createState() => _ConfirmorderState();
}

class _ConfirmorderState extends State<Confirmorder> {
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
              //image
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),

                  child: Image.asset(
                    widget.itemdata["image"],
                    height: 329,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20),

              Card(
                color: Color.fromARGB(255, 37, 24, 6),
                child: ListTile(
                  title: Text(
                    widget.itemdata['name'],
                    style: GoogleFonts.adventPro(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFF5E1C0), // High contrast cream
                    ),
                  ),
                  subtitle: widget.itemdata['price'] != null
                      ? Text(
                          "Total: \$ $totalprice",
                          style: GoogleFonts.openSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFDAA520), // Golden color
                          ),
                        )
                      : null,
                  // No subtitle if price is null
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Description",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: 10),
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 600,
                  ), // or 300–400 for mobile
                  child: Text(
                    widget.itemdata["description"],
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
                    SizedBox(height: 12),
                    Text(widget.size),
                  ],
                ),
              ),
              SizedBox(height: 12),

              Row(
                children: [
                  Text(
                    "Quantity",
                    style: GoogleFonts.openSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 37, 24, 6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.quantity.toString(),
                          style: TextStyle(
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
                padding: EdgeInsets.all(8),
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
                          selectedquantity: widget.quantity, image: widget.image, name: widget.name,
                        ),
                      ),
                    );
                  },
                  child: Text('Confirm Order'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
