import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Netbanking extends StatefulWidget {
  final String itemid;
  final int quantity;
  final String size;
  final String totalprice;
  final String itemname;
  final String image;

  const Netbanking({
    super.key,
    required this.itemid,
    required this.quantity,
    required this.size,
    required this.totalprice,
    required this.itemname,
    required this.image,
  });

  @override
  State<Netbanking> createState() => _NetbankingState();
}

class _NetbankingState extends State<Netbanking> {
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
              /// Order summary card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary.withOpacity(0.5),
                      theme.colorScheme.secondary.withOpacity(0.5),
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Amount",
                          style: GoogleFonts.poppins(fontSize: 13),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "₹ ${widget.totalprice}",
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colorScheme.secondary,
                      ),
                      child: Icon(
                        Icons.lock_outline,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// Select bank title
              Text(
                "Choose your bank",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 20),

              /// Bank list
              Expanded(
                child: ListView.builder(
                  itemCount: banks.length,
                  itemBuilder: (context, index) {
                    final bank = banks[index];
                    final isSelected = selectedBank == bank['name'];

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: isSelected
                            ? theme.colorScheme.primary.withOpacity(0.08)
                            : theme.colorScheme.surface,
                        border: isSelected
                            ? Border.all(color: Colors.white, width: 2)
                            : null,
                      ),

                      child: ListTile(
                        onTap: () {
                          setState(() {
                            selectedBank = bank['name'];
                          });
                        },
                        leading: CircleAvatar(
                          backgroundColor: theme.colorScheme.secondary,
                          child: Icon(
                            bank['icon'],
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        title: Text(
                          bank['name'],
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(
                                Icons.check_circle,
                                color: theme.colorScheme.secondary,
                              )
                            : const Icon(Icons.chevron_right),
                      ),
                    );
                  },
                ),
              ),

              /// Pay button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: selectedBank == null
                      ? null
                      : () async {
                          await placeorder(
                            itemId: widget.itemid,
                            size: widget.size,
                            quantity: widget.quantity,
                            totalPrice: widget.totalprice,
                            image: widget.image,
                            itemname: widget.itemname,
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    "Proceed to Pay",
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

  Future<void> placeorder({
    required String itemId,
    required String size,
    required int quantity,
    required String totalPrice,
    required String image,
    required String itemname,
  }) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      final firestore = FirebaseFirestore.instance;

      // Create order document
      DocumentReference orderRef = firestore.collection("making_orders").doc();

      await orderRef.set({
        "userid": uid,
        "item id": itemId,
        "size": size,
        "total price": totalPrice,
        "status": "pending",
        "date": DateTime.now(),
      });

      await firestore.collection("ordered items").doc().set({
        "order id": orderRef.id,
        "item id": itemId,
        "size": size,
        "quantity": quantity,
        "totalprice": totalPrice,
        "ordered date": DateTime.now(),
        "userid": uid,
        "itemname": itemname,
        "image": image,
        "payment method":"net banking"
      });

      await firestore.collection("payments").doc().set({
        "order id": orderRef.id,
        "item id": itemId,
        "size": size,
        "quantity": quantity,
        "total amount": totalPrice,
        "ordered date": DateTime.now(),
        "userid": uid,
      });

      print("Order created successfully!");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Ordered successfully")));
    } catch (e) {
      print("Error creating order: $e");
    }
  }
}


// first store order data in firestore

//then payment data to firestore

//UX step - redirecting to bank ,do not press "back" button: message

//After 2–3 seconds:

    //✅ Success → update payment + order
             //pyment status:success

    //❌ Failure → show retry option

//navigate to order success page or show order success message     