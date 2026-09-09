import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:solcafe/core/theme/solcafe_colors.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  final List<bool> isTapped = List.generate(5, (_) => false);

  @override
  Widget build(BuildContext context) {
    final colors = context.solcafeColors;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Exclusive Offers 🔥",
          style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            SizedBox(
              height: 90,
              width: 90,
              child: Lottie.asset("assets/anims/Gift premium animation.json", fit: BoxFit.contain),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        isTapped[index] = !isTapped[index];
                      });
                    },
                    child: AnimatedScale(
                      scale: isTapped[index] ? 1.03 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [
                              colors.accentGold,
                              colors.accentGold.withValues(alpha: 0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: colors.cardBorder,
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.local_offer_rounded, color: colors.textOnAccent, size: 36),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Flat 50% OFF",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: colors.textOnAccent,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Get discount on all premium items",
                                    style: TextStyle(
                                      color: colors.textOnAccent.withValues(alpha: 0.85),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios_rounded, color: colors.textOnAccent, size: 18),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

typedef Offers = OffersScreen;
