import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solcafe/core/theme/solcafe_colors.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final colors = context.solcafeColors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Text(
          "Looks like your wallet hasn’t been used here yet. Ready to order your first cup?",
          textAlign: TextAlign.center,
          style: GoogleFonts.readexPro(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            height: 1.6,
            color: colors.textSecondary,
          ),
        ),
      ),
    );
  }
}

typedef Allpayments = PaymentHistoryScreen;
