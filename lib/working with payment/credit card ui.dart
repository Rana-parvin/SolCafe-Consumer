import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//itemid, total,

class Creditcard extends StatefulWidget {
  final String itemid;
  final String totalprice;
  final int quantity;
  final String size;
  final String name;
  final String image;
  const Creditcard({
    super.key,
    required this.itemid,
    required this.totalprice,
    required this.quantity,
    required this.size,
    required this.name,
    required this.image,
  });

  @override
  State<Creditcard> createState() => _CreditcardState();
}

class _CreditcardState extends State<Creditcard>
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

    //card Flip animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Listen to CVV focus
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
            // Flip Animation Card
            SizedBox(
              height: 265,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  final angle = _animation.value * 3.1416; // radians
                  final isFront = angle <= 3.1416 / 2;

                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001) // perspective
                      ..rotateY(angle),
                    child: isFront
                        ? creditfront(
                            cardnumber: cardnumbercontroller.text,
                            expiry: expirydatecontroller.text,
                            cardholder: cardholdercontroller.text,
                          )
                        : Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()..rotateY(3.1416),
                            child: creditBack(cvv: cvvcontroller.text),
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

                  // Card Number
                  CustomTextFormField(
                    keyboardtype: TextInputType.numberWithOptions(),
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

                  // Card Holder Name
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
                    onChanged: (value) =>
                        setState(() => cardholdername = value),
                  ),

                  // Expiry Date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          padding: const EdgeInsets.fromLTRB(
                            20,
                            5,
                            5,
                            5,
                          ), // ← Reduce bottom padding

                          keyboardtype: TextInputType.datetime,
                          controller: expirydatecontroller,
                          labelText: "Valid Upto (MM/YY)",
                          hintText: "MM/YY",
                          prefixIcon: Icons.calendar_today,
                          maxLength: 5,
                          suffixText: "5",
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                          ),
                          validator: (value) {
                            if (value == null || value.length != 5) {
                              return "Please enter expiry date in MM/YY format";
                            }
                            return null;
                          },
                          onChanged: (value) =>
                              setState(() => expirydate = value),
                        ),
                      ),

                      // CVV
                      Expanded(
                        child: CustomTextFormField(
                          padding: const EdgeInsets.fromLTRB(
                            5,
                            5,
                            20,
                            5,
                          ), // ← Reduce bottom padding

                          keyboardtype: TextInputType.number,
                          controller: cvvcontroller,
                          labelText: "CVV",
                          hintText: "***",
                          prefixIcon: Icons.lock_outline,
                          maxLength: 3,
                          suffixText: "3",
                          obscureText: true,
                          focusNode: cvvFocusNode,
                          borderRadius: BorderRadius.only(
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

                  // Submit Button
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

  Future<void> placingorder({
    required String itemId,
    required String size,
    required int quantity,
    required String totalPrice,
    required String image,
    required String itemname,
  }) async {
    String rawCardNumber = cardnumbercontroller.text.replaceAll(' ', '');
    print('Card Number: $rawCardNumber');
    print('Expiry Date: $expirydate');
    print('CVV: $cvv');
    print('Card Holder Name: $cardholdername');
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
        "payment method":"credit card"
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
    } catch (e) {
      print("Error ordering the item $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error ordering the item $e")));
    }
  }
}

//  TEXT FIELD
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
    return Padding(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        keyboardType: keyboardtype,
        maxLength: maxLength,
        validator: validator,
        onChanged: onChanged,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          counterText: "",
          suffixText: suffixText,
          labelText: labelText,

          hintText: hintText,
          labelStyle: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
          prefixIcon: Icon(
            prefixIcon,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color:
                  Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey,
            ),
            borderRadius: borderRadius,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color:
                  Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey,
            ),
            borderRadius: borderRadius,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color:
                  Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey,
            ),
            borderRadius: borderRadius,
          ),
        ),
      ),
    );
  }
}

// CREDIT CARD FRONT
class creditfront extends StatelessWidget {
  final String cardnumber;
  final String expiry;
  final String cardholder;
  creditfront({
    super.key,
    required this.cardnumber,
    required this.expiry,
    required this.cardholder,
  });

  @override
  Widget build(BuildContext context) {
    String displaycardnumber = cardnumber.replaceAll(' ', '').length >= 4
        ? '**** **** **** ${cardnumber.replaceAll(' ', '').substring(cardnumber.replaceAll(' ', '').length - 4)}'
        : '**** **** **** XXXX';

    return Center(
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.all(16),
        child: Container(
          width: 380,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: getCardGradient(context),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  "Credit Card",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.labelMedium?.color,
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
                    style: TextStyle(
                      letterSpacing: 4,
                      fontSize: 20,
                      color: Theme.of(context).textTheme.labelMedium?.color,
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
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).textTheme.labelMedium?.color,
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        fontSize: 16,
                        color: Theme.of(context).textTheme.labelMedium?.color,
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
    );
  }

  LinearGradient forcreamtheme = const LinearGradient(
    tileMode: TileMode.repeated,
    colors: [
      Color(0xFF4E342E),
      Color(0xFF4E342E),
      Color(0xFF8D6E63),
      Color(0xFFBCAAA4),
    ],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
  );

  LinearGradient forbrowntheme = const LinearGradient(
    tileMode: TileMode.repeated,
    colors: [
      Color(0xFFFFF8E1),
      Color(0xFFFFF8E1),
      Color(0xFFB09288),
      Color(0xFF6F564D),
    ],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
  );

  LinearGradient getCardGradient(BuildContext context) {
    final theme = Theme.of(context);
    return theme.brightness == Brightness.light ? forcreamtheme : forbrowntheme;
  }
}

//  CREDIT CARD BACK
class creditBack extends StatelessWidget {
  final String cvv;
  const creditBack({super.key, required this.cvv});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.all(16),
      child: Container(
        width: 380,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: creditfront(
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
              ), // magnetic strip
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
