import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solcafe/core/presentation/widgets/responsive_layout.dart';
import 'package:solcafe/core/theme/solcafe_colors.dart';
import 'package:solcafe/features/home/presentation/providers/bottom_nav_provider.dart';
import 'package:solcafe/features/order/presentation/screens/order_history_screen.dart';
import 'package:solcafe/features/payment/presentation/screens/cod_payment_screen.dart';
import 'package:solcafe/features/payment/presentation/screens/credit_card_payment_screen.dart';
import 'package:solcafe/features/payment/presentation/screens/net_banking_payment_screen.dart';
import 'package:solcafe/features/payment/presentation/screens/upi_payment_screen.dart';
import 'package:solcafe/features/payment/presentation/widgets/payment_option_card.dart';
import 'package:solcafe/features/settings/presentation/providers/currency_provider.dart';

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
  String selectedoption = "Cash on delivery";
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.solcafeColors;
    final isLandscape = SolCafeBreakpoints.isLandscape(context);
    final iconSize = isLandscape ? 48.0 : 64.0;

    final bool isCod = selectedoption == "Cash on delivery";
    final String buttonText = isCod
        ? (_isSubmitting ? "Placing Order..." : "Place Order")
        : "Proceed to Payment";

    return Scaffold(
      backgroundColor: colors.surfacePrimary,
      appBar: AppBar(
        backgroundColor: colors.surfacePrimary,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Payment Methods",
          style: GoogleFonts.readexPro(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: ConstrainedCenterContainer(
                  maxWidth: 550,
                  child: Column(
                    children: [
                      // Header Card matching reference screen 3
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                        decoration: BoxDecoration(
                          color: colors.cardBackground,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: colors.cardBorder),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/images/cup icon.png",
                              height: iconSize,
                              width: iconSize,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.coffee,
                                size: iconSize,
                                color: colors.accentGold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "Choose payment method",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.readexPro(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: colors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Select how you would like to pay for your order.",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.openSans(
                                fontSize: 13,
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // 4 Payment Options matching reference screen 3
                      PaymentOptionCard(
                        value: "Credit Card / Debit Card",
                        subtitle: "Pay securely with your card",
                        icon: Icons.credit_card_outlined,
                        groupValue: selectedoption,
                        onChanged: (val) => setState(() => selectedoption = val),
                      ),
                      PaymentOptionCard(
                        value: "Net Banking",
                        subtitle: "Pay through your bank",
                        icon: Icons.account_balance_outlined,
                        groupValue: selectedoption,
                        onChanged: (val) => setState(() => selectedoption = val),
                      ),
                      PaymentOptionCard(
                        value: "UPI",
                        subtitle: "Pay using UPI apps",
                        icon: Icons.phone_android_outlined,
                        groupValue: selectedoption,
                        onChanged: (val) => setState(() => selectedoption = val),
                      ),
                      PaymentOptionCard(
                        value: "Cash on Delivery",
                        subtitle: "Pay when your order arrives",
                        icon: Icons.payments_outlined,
                        groupValue: selectedoption,
                        onChanged: (val) => setState(() => selectedoption = val),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Action Bar with Pill Button matching reference screen 3
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
                  maxWidth: 550,
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
                      onPressed: (selectedoption.isEmpty || _isSubmitting)
                          ? null
                          : () => handleProceed(context),
                      child: _isSubmitting
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  buttonText,
                                  style: GoogleFonts.readexPro(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  isCod ? Icons.shopping_bag_outlined : Icons.arrow_forward_rounded,
                                  size: 18,
                                  color: const Color(0xFF1C120C),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  buttonText,
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

  Future<void> handleProceed(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final currency = ref.read(currencySymbolProvider);

    try {
      if (selectedoption == "Credit Card / Debit Card") {
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
      } else if (selectedoption == "Net Banking") {
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
        // Cash on delivery
        setState(() => _isSubmitting = true);

        final orderId = await createCashOnDeliveryOrder(
          ref: ref,
          itemId: widget.itemid,
          size: widget.selectedsize,
          quantity: widget.selectedquantity,
          totalPrice: widget.totalprice,
          image: widget.image,
          itemname: widget.name,
        );

        if (!context.mounted) return;
        setState(() => _isSubmitting = false);

        if (orderId != null && orderId.isNotEmpty) {
          final displayOrderId = orderId.length >= 6
              ? "#SC-${orderId.substring(0, 6).toUpperCase()}"
              : "#SC-$orderId";

          _showOrderSuccessBottomSheet(
            context: context,
            displayOrderId: displayOrderId,
            formattedTotal: "$currency${double.tryParse(widget.totalprice)?.toStringAsFixed(2) ?? widget.totalprice}",
          );
        } else {
          messenger.showSnackBar(
            const SnackBar(content: Text("Failed to place order! Please try again.")),
          );
        }
      }
    } catch (e) {
      if (mounted) setState(() => _isSubmitting = false);
      if (!context.mounted) return;
      messenger.showSnackBar(
        const SnackBar(
          content: Text("Sorry, we couldn't place your order! Please try again."),
        ),
      );
    }
  }

  void _showOrderSuccessBottomSheet({
    required BuildContext context,
    required String displayOrderId,
    required String formattedTotal,
  }) {
    final colors = context.solcafeColors;

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return Container(
          decoration: BoxDecoration(
            color: colors.cardBackground,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: colors.accentGold.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: colors.accentGold,
                  size: 44,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                "Order Placed Successfully! 🎉",
                textAlign: TextAlign.center,
                style: GoogleFonts.readexPro(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Thank you for your order. We are preparing it with care.",
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(
                  fontSize: 13,
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),

              // Order Summary Container
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.surfaceSecondary,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.borderSubtle),
                ),
                child: Column(
                  children: [
                    _buildSuccessDetailRow(colors, "Order ID", displayOrderId),
                    const Divider(height: 16),
                    _buildSuccessDetailRow(colors, "Item", widget.name),
                    const Divider(height: 16),
                    _buildSuccessDetailRow(colors, "Size & Quantity", "${widget.selectedsize} (x${widget.selectedquantity})"),
                    const Divider(height: 16),
                    _buildSuccessDetailRow(colors, "Total Amount", formattedTotal, isBold: true),
                    const Divider(height: 16),
                    _buildSuccessDetailRow(colors, "Payment Method", "Cash on Delivery"),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.accentGold,
                    foregroundColor: colors.textOnAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(modalContext).pop();
                    ref.read(bottomNavProvider.notifier).setIndex(2);
                    Navigator.of(context).popUntil((route) => route.isFirst);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Order $displayOrderId placed successfully!"),
                      ),
                    );
                  },
                  child: Text(
                    "View Order",
                    style: GoogleFonts.readexPro(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSuccessDetailRow(SolCafeColors colors, String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.openSans(
            fontSize: 13,
            color: colors.textSecondary,
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.openSans(
              fontSize: 13.5,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: isBold ? colors.accentGold : colors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

typedef Paymentmethod = PaymentMethodsScreen;
