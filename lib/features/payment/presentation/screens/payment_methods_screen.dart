import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solcafe/features/order/presentation/screens/order_history_screen.dart';
import 'package:solcafe/features/payment/presentation/screens/cod_payment_screen.dart';
import 'package:solcafe/features/payment/presentation/screens/credit_card_payment_screen.dart';
import 'package:solcafe/features/payment/presentation/screens/net_banking_payment_screen.dart';
import 'package:solcafe/features/payment/presentation/screens/upi_payment_screen.dart';
import 'package:solcafe/features/payment/presentation/widgets/payment_option_card.dart';

class PaymentMethodsScreen extends StatefulWidget {
  final String totalprice;
  final String itemid;
  final String selectedsize;
  final int selectedquantity;
  final String image;
  final String name;

  const PaymentMethodsScreen({
    super.key,
    required this.totalprice,
    required this.itemid,
    required this.selectedsize,
    required this.selectedquantity,
    required this.image,
    required this.name,
  });

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  String selectedoption = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromARGB(255, 245, 242, 242),
              ),
              height: 600,
              width: 500,
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/cup icon.jpg",
                    height: 130,
                    width: 130,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "Choose payment method",
                      style: GoogleFonts.adventPro(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[900],
                      ),
                    ),
                  ),
                  PaymentOptionCard(
                    value: "Credit card / Debit card",
                    groupValue: selectedoption,
                    onChanged: (val) => setState(() => selectedoption = val),
                    trailing: const Icon(Icons.credit_card, color: Colors.brown),
                    radioColor: const Color(0xFF381507),
                  ),
                  PaymentOptionCard(
                    value: "Net banking",
                    groupValue: selectedoption,
                    onChanged: (val) => setState(() => selectedoption = val),
                    trailing: const Icon(Icons.account_balance, color: Colors.brown),
                    radioColor: const Color(0xFF381507),
                  ),
                  PaymentOptionCard(
                    value: "UPI",
                    groupValue: selectedoption,
                    onChanged: (val) => setState(() => selectedoption = val),
                    trailing: const Icon(Icons.phone_android, color: Colors.brown),
                    radioColor: const Color(0xFF381507),
                  ),
                  PaymentOptionCard(
                    value: "Cash on delivery",
                    groupValue: selectedoption,
                    onChanged: (val) => setState(() => selectedoption = val),
                    trailing: const Icon(Icons.money, color: Colors.brown),
                    radioColor: const Color(0xFF381507),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF381507),
                        ),
                        onPressed: selectedoption.isEmpty
                            ? null
                            : () => handleProceed(context),
                        child: const Text(
                          "Proceed",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> handleProceed(BuildContext context) async {
    try {
      if (selectedoption == "Credit card / Debit card") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreditCardPaymentScreen(
              image: widget.image,
              itemid: widget.itemid,
              name: widget.name,
              quantity: widget.selectedquantity,
              size: widget.selectedsize,
              totalprice: widget.totalprice,
            ),
          ),
        );
      } else if (selectedoption == "Net banking") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NetBankingPaymentScreen(
              itemid: widget.itemid,
              quantity: widget.selectedquantity,
              size: widget.selectedsize,
              totalprice: widget.totalprice,
              itemname: widget.name,
              image: widget.image,
            ),
          ),
        );
      } else if (selectedoption == "UPI") {
        await upiPayment(
          itemId: widget.itemid,
          size: widget.selectedsize,
          quantity: widget.selectedquantity,
          totalPrice: widget.totalprice,
          image: widget.image,
          itemname: widget.name,
        );
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("UPI payment completed successfully!")),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
        );
      } else {
        await createCashOnDeliveryOrder(
          itemId: widget.itemid,
          size: widget.selectedsize,
          quantity: widget.selectedquantity,
          totalPrice: widget.totalprice,
          image: widget.image,
          itemname: widget.name,
        );
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Your order has been placed successfully! Thank you for choosing SolCafe.",
            ),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Sorry, we couldn't place your order! Please try again.",
          ),
        ),
      );
    }
  }
}

// Backward compatibility alias
typedef Paymentmethod = PaymentMethodsScreen;
