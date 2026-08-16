import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NetBankingPaymentScreen extends StatefulWidget {
  final String itemid;
  final int quantity;
  final String size;
  final String totalprice;
  final String itemname;
  final String image;

  const NetBankingPaymentScreen({
    super.key,
    required this.itemid,
    required this.quantity,
    required this.size,
    required this.totalprice,
    required this.itemname,
    required this.image,
  });

  @override
  State<NetBankingPaymentScreen> createState() => _NetBankingPaymentScreenState();
}

class _NetBankingPaymentScreenState extends State<NetBankingPaymentScreen> {
  String? selectedBank;

  final List<Map<String, dynamic>> banks = [
    {"name": "HDFC Bank", "icon": Icons.account_balance},
    {"name": "SBI", "icon": Icons.account_balance_outlined},
    {"name": "ICICI Bank", "icon": Icons.account_balance},
    {"name": "Axis Bank", "icon": Icons.account_balance_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Net Banking",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      theme.primaryColor,
                      theme.primaryColor.withValues(alpha: 0.8),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Amount Payable",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "₹${widget.totalprice}",
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Popular Banks",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: banks.length,
                  itemBuilder: (context, index) {
                    final bank = banks[index];
                    final isSelected = selectedBank == bank["name"];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedBank = bank["name"];
                          });
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? theme.primaryColor
                                  : Colors.grey.shade300,
                              width: isSelected ? 2 : 1,
                            ),
                            color: isSelected
                                ? theme.primaryColor.withValues(alpha: 0.05)
                                : Colors.white,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                bank["icon"],
                                color: isSelected
                                    ? theme.primaryColor
                                    : Colors.grey,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  bank["name"],
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check_circle,
                                  color: theme.primaryColor,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: selectedBank == null
                      ? null
                      : () async {
                          await _processOrder(context);
                        },
                  child: Text(
                    "Pay via $selectedBank",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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

  Future<void> _processOrder(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      final uid = user.uid;

      final firestore = FirebaseFirestore.instance;
      final batch = firestore.batch();

      DocumentReference orderRef = firestore.collection("making_orders").doc();
      DocumentReference itemRef = firestore.collection("ordered items").doc();
      DocumentReference paymentRef = firestore.collection("payments").doc();

      batch.set(orderRef, {
        "userid": uid,
        "item id": widget.itemid,
        "size": widget.size,
        "total price": widget.totalprice,
        "status": "pending",
        "date": DateTime.now(),
      });

      batch.set(itemRef, {
        "order id": orderRef.id,
        "item id": widget.itemid,
        "size": widget.size,
        "quantity": widget.quantity,
        "totalprice": widget.totalprice,
        "ordered date": DateTime.now(),
        "userid": uid,
        "itemname": widget.itemname,
        "image": widget.image,
        "payment method": "net banking"
      });

      batch.set(paymentRef, {
        "order id": orderRef.id,
        "item id": widget.itemid,
        "size": widget.size,
        "quantity": widget.quantity,
        "total amount": widget.totalprice,
        "ordered date": DateTime.now(),
        "userid": uid,
      });

      await batch.commit();

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Order processed successfully")),
      );
      Navigator.popUntil(context, (route) => route.isFirst);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error processing order: $e")),
      );
    }
  }
}

// Backward compatibility alias
typedef Netbanking = NetBankingPaymentScreen;
