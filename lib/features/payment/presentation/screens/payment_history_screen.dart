import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Text(
          "Looks like your wallet hasn’t been used here yet. Ready to order your first cup?",
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            height: 2,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// Backward compatibility alias
typedef Allpayments = PaymentHistoryScreen;
