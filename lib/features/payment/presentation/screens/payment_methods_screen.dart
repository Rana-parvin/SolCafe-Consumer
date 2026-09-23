import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solcafe/core/presentation/widgets/responsive_layout.dart';
import 'package:solcafe/core/theme/solcafe_colors.dart';
import 'package:solcafe/features/order/presentation/screens/order_history_screen.dart';
import 'package:solcafe/features/payment/presentation/screens/cod_payment_screen.dart';
import 'package:solcafe/features/payment/presentation/screens/credit_card_payment_screen.dart';
import 'package:solcafe/features/payment/presentation/screens/net_banking_payment_screen.dart';
import 'package:solcafe/features/payment/presentation/screens/upi_payment_screen.dart';
import 'package:solcafe/features/payment/presentation/widgets/payment_option_card.dart';

class PaymentMethodsScreen extends ConsumerStatefulWidget {
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
  ConsumerState<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends ConsumerState<PaymentMethodsScreen> {
  String selectedoption = "";

  @override
  Widget build(BuildContext context) {
    final colors = context.solcafeColors;
    final iconSize = SolCafeBreakpoints.isLandscape(context) ? 65.0 : 100.0;

    return Scaffold(
      appBar: AppBar(title: const Text("Payment Methods")),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: ConstrainedCenterContainer(
              maxWidth: 480,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: colors.cardBackground,
                  border: Border.all(color: colors.cardBorder),
                  boxShadow: [
                    BoxShadow(
                      color: colors.cardBorder,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "assets/images/cup icon.png",
                      height: iconSize,
                      width: iconSize,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Choose payment method",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.readexPro(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    PaymentOptionCard(
                      value: "Credit card / Debit card",
                      groupValue: selectedoption,
                      onChanged: (val) => setState(() => selectedoption = val),
                      trailing: Icon(Icons.credit_card, color: colors.accentGold),
                    ),
                    PaymentOptionCard(
                      value: "Net banking",
                      groupValue: selectedoption,
                      onChanged: (val) => setState(() => selectedoption = val),
                      trailing: Icon(Icons.account_balance, color: colors.accentGold),
                    ),
                    PaymentOptionCard(
                      value: "UPI",
                      groupValue: selectedoption,
                      onChanged: (val) => setState(() => selectedoption = val),
                      trailing: Icon(Icons.phone_android, color: colors.accentGold),
                    ),
                    PaymentOptionCard(
                      value: "Cash on delivery",
                      groupValue: selectedoption,
                      onChanged: (val) => setState(() => selectedoption = val),
                      trailing: Icon(Icons.money, color: colors.accentGold),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: selectedoption.isEmpty
                            ? null
                            : () => handleProceed(context),
                        child: const Text("Proceed"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> handleProceed(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      if (selectedoption == "Credit card / Debit card") {
        navigator.push(
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
        navigator.push(
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
        final success = await upiPayment(
          ref: ref,
          itemId: widget.itemid,
          size: widget.selectedsize,
          quantity: widget.selectedquantity,
          totalPrice: widget.totalprice,
          image: widget.image,
          itemname: widget.name,
        );
        if (!context.mounted) return;
        if (success) {
          messenger.showSnackBar(
            const SnackBar(content: Text("UPI payment completed successfully!")),
          );
          navigator.push(
            MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
          );
        } else {
          messenger.showSnackBar(
            const SnackBar(content: Text("UPI payment failed! Please try again.")),
          );
        }
      } else {
        final success = await createCashOnDeliveryOrder(
          ref: ref,
          itemId: widget.itemid,
          size: widget.selectedsize,
          quantity: widget.selectedquantity,
          totalPrice: widget.totalprice,
          image: widget.image,
          itemname: widget.name,
        );
        if (!context.mounted) return;
        if (success) {
          messenger.showSnackBar(
            const SnackBar(
              content: Text(
                "Your order has been placed successfully! Thank you for choosing SolCafe.",
              ),
            ),
          );
          navigator.push(
            MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
          );
        } else {
          messenger.showSnackBar(
            const SnackBar(content: Text("Failed to place order! Please try again.")),
          );
        }
      }
    } catch (e) {
      if (!context.mounted) return;
      messenger.showSnackBar(
        const SnackBar(
          content: Text(
            "Sorry, we couldn't place your order! Please try again.",
          ),
        ),
      );
    }
  }
}

typedef Paymentmethod = PaymentMethodsScreen;
