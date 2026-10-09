import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solcafe/core/presentation/widgets/responsive_layout.dart';
import 'package:solcafe/core/theme/solcafe_colors.dart';
import 'package:solcafe/features/auth/presentation/providers/auth_provider.dart';
import 'package:solcafe/features/order/domain/entities/order_entity.dart';
import 'package:solcafe/features/order/presentation/providers/order_provider.dart';
import 'package:solcafe/features/settings/presentation/providers/currency_provider.dart';

class NetBankingPaymentScreen extends ConsumerStatefulWidget {
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
  ConsumerState<NetBankingPaymentScreen> createState() => _NetBankingPaymentScreenState();
}

class _NetBankingPaymentScreenState extends ConsumerState<NetBankingPaymentScreen> {
  String? selectedBank;

  final List<Map<String, dynamic>> banks = [
    {"name": "HDFC Bank", "icon": Icons.account_balance},
    {"name": "SBI", "icon": Icons.account_balance_outlined},
    {"name": "ICICI Bank", "icon": Icons.account_balance},
    {"name": "Axis Bank", "icon": Icons.account_balance_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.solcafeColors;
    final paymentState = ref.watch(orderPaymentNotifierProvider);
    final isLoading = paymentState.isLoading;
    final currency = ref.watch(currencySymbolProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Net Banking",
          style: GoogleFonts.readexPro(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ConstrainedCenterContainer(
            maxWidth: 600,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [
                        colors.accentGold,
                        colors.accentGold.withValues(alpha: 0.8),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colors.cardBorder,
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
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          color: colors.textOnAccent,
                        ),
                      ),
                      Text(
                        "$currency${widget.totalprice}",
                        style: GoogleFonts.readexPro(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: colors.textOnAccent,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "Popular Banks",
                  style: GoogleFonts.readexPro(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
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
                        padding: const EdgeInsets.only(bottom: 10),
                        child: InkWell(
                          onTap: isLoading
                              ? null
                              : () {
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
                                color: isSelected ? colors.accentGold : colors.cardBorder,
                                width: isSelected ? 2 : 1,
                              ),
                              color: isSelected ? colors.accentGoldSubtle : colors.cardBackground,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  bank["icon"],
                                  color: isSelected ? colors.accentGold : colors.textSecondary,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    bank["name"],
                                    style: GoogleFonts.openSans(
                                      fontSize: 16,
                                      color: colors.textPrimary,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  Icon(
                                    Icons.check_circle,
                                    color: colors.accentGold,
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
                  height: 50,
                  child: ElevatedButton(
                    onPressed: (selectedBank == null || isLoading)
                        ? null
                        : () async {
                            await _processOrder();
                          },
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Text("Pay via ${selectedBank ?? ''}"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _processOrder() async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final currentUser = ref.read(currentUserProvider);
    final uid = currentUser?.uid ?? '';
    if (uid.isEmpty) return;

    final order = OrderEntity(
      id: '',
      userId: uid,
      itemId: widget.itemid,
      itemName: widget.itemname,
      image: widget.image,
      size: widget.size,
      quantity: widget.quantity,
      totalPrice: double.tryParse(widget.totalprice) ?? 0.0,
      status: 'pending',
      paymentMethod: 'net banking',
      orderDate: DateTime.now(),
    );

    final orderId = await ref.read(orderPaymentNotifierProvider.notifier).placeOrder(order);
    final success = orderId != null;

    if (!mounted) return;
    if (success) {
      messenger.showSnackBar(
        const SnackBar(content: Text("Order processed successfully")),
      );
      navigator.popUntil((route) => route.isFirst);
    } else {
      messenger.showSnackBar(
        const SnackBar(content: Text("Failed to process order")),
      );
    }
  }
}

typedef Netbanking = NetBankingPaymentScreen;
