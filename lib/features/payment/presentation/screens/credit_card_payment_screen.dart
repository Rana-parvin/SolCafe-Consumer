import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solcafe/core/theme/solcafe_colors.dart';
import 'package:solcafe/features/auth/presentation/providers/auth_provider.dart';
import 'package:solcafe/features/order/domain/entities/order_entity.dart';
import 'package:solcafe/features/order/presentation/providers/order_provider.dart';

class CreditCardPaymentScreen extends ConsumerStatefulWidget {
  final String itemid;
  final String totalprice;
  final int quantity;
  final String size;
  final String name;
  final String image;

  const CreditCardPaymentScreen({
    super.key,
    required this.itemid,
    required this.totalprice,
    required this.quantity,
    required this.size,
    required this.name,
    required this.image,
  });

  @override
  ConsumerState<CreditCardPaymentScreen> createState() => _CreditCardPaymentScreenState();
}

class _CreditCardPaymentScreenState extends ConsumerState<CreditCardPaymentScreen>
    with SingleTickerProviderStateMixin {
  final formkey = GlobalKey<FormState>();

  final TextEditingController cardnumbercontroller = TextEditingController();
  final TextEditingController expirydatecontroller = TextEditingController();
  final TextEditingController cvvcontroller = TextEditingController();
  final TextEditingController cardholdercontroller = TextEditingController();

  final FocusNode cvvFocusNode = FocusNode();

  late AnimationController _controller;
  late Animation<double> _animation;

  String cardnumber = '';
  String expirydate = '';
  String cvv = '';
  String cardholdername = '';

  @override
  void initState() {
    super.initState();
    cardnumbercontroller.addListener(_formatCardNumber);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    cvvFocusNode.addListener(() {
      if (cvvFocusNode.hasFocus) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _formatCardNumber() {
    String text = cardnumbercontroller.text.replaceAll(' ', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      if (i % 4 == 0 && i != 0) buffer.write(' ');
      buffer.write(text[i]);
    }

    final formatted = buffer.toString();
    if (formatted != cardnumbercontroller.text) {
      cardnumbercontroller.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  @override
  void dispose() {
    cardnumbercontroller.dispose();
    expirydatecontroller.dispose();
    cvvcontroller.dispose();
    cardholdercontroller.dispose();
    cvvFocusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> placingorder({
    required String itemId,
    required String size,
    required int quantity,
    required String totalPrice,
    required String image,
    required String itemname,
  }) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      final currentUser = ref.read(currentUserProvider);
      final uid = currentUser?.uid ?? '';
      if (uid.isEmpty) return;

      final order = OrderEntity(
        id: '',
        userId: uid,
        itemId: itemId,
        itemName: itemname,
        image: image,
        size: size,
        quantity: quantity,
        totalPrice: double.tryParse(totalPrice) ?? 0.0,
        status: 'pending',
        paymentMethod: 'credit card',
        orderDate: DateTime.now(),
      );

      final success = await ref.read(orderPaymentNotifierProvider.notifier).placeOrder(order);

      if (!mounted) return;
      if (success) {
        messenger.showSnackBar(
          const SnackBar(content: Text("Payment processed successfully!")),
        );
        navigator.popUntil((route) => route.isFirst);
      } else {
        messenger.showSnackBar(
          const SnackBar(content: Text("Failed to process payment")),
        );
      }
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text("Error ordering item: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Credit card details",
          style: GoogleFonts.readexPro(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 265,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  final angle = _animation.value * 3.1416;
                  final isFront = angle <= 3.1416 / 2;

                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(angle),
                    child: isFront
                        ? CreditFront(
                            cardnumber: cardnumbercontroller.text,
                            expiry: expirydatecontroller.text,
                            cardholder: cardholdercontroller.text,
                          )
                        : Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()..rotateY(3.1416),
                            child: CreditBack(cvv: cvvcontroller.text),
                          ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            Form(
              key: formkey,
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "Credit card details",
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  CustomTextFormField(
                    keyboardtype: const TextInputType.numberWithOptions(),
                    controller: cardnumbercontroller,
                    labelText: "Card number",
                    hintText: "XXXX XXXX XXXX XXXX",
                    prefixIcon: Icons.credit_card_outlined,
                    maxLength: 19,
                    suffixText: "16",
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    validator: (value) {
                      String cleaned = value?.replaceAll(' ', '') ?? '';
                      if (cleaned.length != 16) {
                        return "Please enter a valid 16-digit card number";
                      }
                      return null;
                    },
                    onChanged: (value) => setState(() => cardnumber = value),
                  ),
                  CustomTextFormField(
                    controller: cardholdercontroller,
                    labelText: "Card holder name",
                    hintText: "Name surname",
                    prefixIcon: Icons.person_outline,
                    borderRadius: BorderRadius.zero,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter card holder name";
                      }
                      return null;
                    },
                    onChanged: (value) => setState(() => cardholdername = value),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          padding: const EdgeInsets.fromLTRB(20, 5, 5, 5),
                          keyboardtype: TextInputType.datetime,
                          controller: expirydatecontroller,
                          labelText: "Valid Upto (MM/YY)",
                          hintText: "MM/YY",
                          prefixIcon: Icons.calendar_today,
                          maxLength: 5,
                          suffixText: "5",
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                          ),
                          validator: (value) {
                            if (value == null || value.length != 5) {
                              return "Please enter expiry date in MM/YY format";
                            }
                            return null;
                          },
                          onChanged: (value) => setState(() => expirydate = value),
                        ),
                      ),
                      Expanded(
                        child: CustomTextFormField(
                          padding: const EdgeInsets.fromLTRB(5, 5, 20, 5),
                          keyboardtype: TextInputType.number,
                          controller: cvvcontroller,
                          labelText: "CVV",
                          hintText: "***",
                          prefixIcon: Icons.lock_outline,
                          maxLength: 3,
                          suffixText: "3",
                          obscureText: true,
                          focusNode: cvvFocusNode,
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(10),
                          ),
                          validator: (value) {
                            if (value == null || value.length != 3) {
                              return "Please enter a valid 3-digit CVV";
                            }
                            return null;
                          },
                          onChanged: (value) => setState(() => cvv = value),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF432D25),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      if (formkey.currentState!.validate()) {
                        await placingorder(
                          itemId: widget.itemid,
                          size: widget.size,
                          quantity: widget.quantity,
                          totalPrice: widget.totalprice,
                          image: widget.image,
                          itemname: widget.name,
                        );
                      }
                    },
                    child: const Text(
                      "Process Payment",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String? label;
  final TextInputType? keyboardtype;
  final IconData prefixIcon;
  final int? maxLength;
  final String? suffixText;
  final bool obscureText;
  final BorderRadius borderRadius;
  final String? Function(String?) validator;
  final Function(String)? onChanged;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? padding;

  const CustomTextFormField({
    super.key,
    this.padding,
    this.label,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    this.keyboardtype,
    this.maxLength,
    this.suffixText,
    this.obscureText = false,
    this.borderRadius = BorderRadius.zero,
    required this.validator,
    this.onChanged,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.solcafeColors;

    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        keyboardType: keyboardtype,
        maxLength: maxLength,
        validator: validator,
        onChanged: onChanged,
        style: TextStyle(color: colors.textPrimary),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          counterText: "",
          suffixText: suffixText,
          labelText: labelText,
          hintText: hintText,
          labelStyle: TextStyle(color: colors.textSecondary),
          prefixIcon: Icon(prefixIcon, color: colors.accentGold),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colors.borderSubtle),
            borderRadius: borderRadius,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colors.borderFocused, width: 1.5),
            borderRadius: borderRadius,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: colors.borderSubtle),
            borderRadius: borderRadius,
          ),
        ),
      ),
    );
  }
}

class CreditFront extends StatelessWidget {
  final String cardnumber;
  final String expiry;
  final String cardholder;

  const CreditFront({
    super.key,
    required this.cardnumber,
    required this.expiry,
    required this.cardholder,
  });

  static const LinearGradient forcreamtheme = LinearGradient(
    tileMode: TileMode.repeated,
    colors: [
      Color(0xFF3E2723),
      Color(0xFF4E342E),
      Color(0xFF6F4E37),
      Color(0xFF8D6E63),
    ],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
  );

  static const LinearGradient forbrowntheme = LinearGradient(
    tileMode: TileMode.repeated,
    colors: [
      Color(0xFF261810),
      Color(0xFF3A2518),
      Color(0xFF4A3222),
      Color(0xFF6F4E37),
    ],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
  );

  LinearGradient getCardGradient(BuildContext context) {
    final theme = Theme.of(context);
    return theme.brightness == Brightness.light ? forcreamtheme : forbrowntheme;
  }

  @override
  Widget build(BuildContext context) {
    String displaycardnumber = cardnumber.replaceAll(' ', '').length >= 4
        ? '**** **** **** ${cardnumber.replaceAll(' ', '').substring(cardnumber.replaceAll(' ', '').length - 4)}'
        : '**** **** **** XXXX';

    return Center(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: getCardGradient(context),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Credit Card",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFF5E1C0),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Image.asset(
                    "assets/images/credit chip.jpg",
                    height: 40,
                    width: 50,
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      displaycardnumber,
                      style: const TextStyle(
                        letterSpacing: 4,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF5E1C0),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          "Valid\n Upto: $expiry",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFFD8BEB4),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        cardholder.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          fontSize: 15,
                          color: Color(0xFFF5E1C0),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.asset(
                          "assets/images/visa.png",
                          fit: BoxFit.cover,
                          height: 40,
                          width: 50,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class CreditBack extends StatelessWidget {
  final String cvv;
  const CreditBack({super.key, required this.cvv});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: const CreditFront(
              cardnumber: '',
              expiry: '',
              cardholder: '',
            ).getCardGradient(context),
          ),
        child: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50,
                width: double.maxFinite,
                color: Colors.black87,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Container(
                  width: 250,
                  color: const Color.fromARGB(255, 211, 201, 201),
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
                  child: Text(
                    cvv.isEmpty ? "***" : cvv,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
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
}

// Backward compatibility aliases
typedef Creditcard = CreditCardPaymentScreen;
// ignore: camel_case_types
typedef creditfront = CreditFront;
// ignore: camel_case_types
typedef creditBack = CreditBack;

