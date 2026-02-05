
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solcafe/working%20with%20order/orders.dart';
import 'package:solcafe/working%20with%20payment/UPI%20payment.dart';
import 'package:solcafe/working%20with%20payment/net%20banking.dart';
import 'package:solcafe/working%20with%20payment/cash%20on%20delivery%20model.dart';
import 'package:solcafe/working%20with%20payment/credit%20card%20ui.dart';
import 'package:solcafe/working%20with%20payment/payment%20option%20card.dart';

class Paymentmethod extends StatefulWidget {
  final String totalprice;
  final String itemid;
  final String selectedsize;
  final int selectedquantity;
  final String image;
  final String name;

  const Paymentmethod({
    super.key,
    required this.totalprice,
    required this.itemid,
    required this.selectedsize,
    required this.selectedquantity,
    required this.image,
    required this.name,
  });

  @override
  State<Paymentmethod> createState() => _PaymentmethodState();
}

class _PaymentmethodState extends State<Paymentmethod> {
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
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        color: Colors.brown[900],
                      ),
                    ),
                  ),

                  // UPI
                  PaymentOptionCard(
                    value: "UPI",
                    groupValue: selectedoption,
                    onChanged: (val) => setState(() {
                      selectedoption = val;
                    }),
                    trailing: Icon(Icons.book_online, color: Colors.brown[900]),
                    radioColor: const Color(0xFF553529),
                  ),

                  // Cash on delivery
                  PaymentOptionCard(
                    value: "Cash on delivery",
                    groupValue: selectedoption,
                    onChanged: (val) => setState(() {
                      selectedoption = val;
                    }),
                    trailing: SizedBox(
                      height: 35,
                      width: 35,
                      child: Image.asset("assets/images/cash on delivery.png"),
                    ),
                    radioColor: const Color.fromARGB(255, 85, 53, 41),
                  ),

                  // Net banking
                  PaymentOptionCard(
                    value: "Net banking",
                    groupValue: selectedoption,
                    onChanged: (val) => setState(() {
                      selectedoption = val;
                    }),
                    trailing: CircleAvatar(
                      radius: 17,
                      backgroundColor: const Color(0xFF553529),
                      child: Icon(Icons.account_balance, color: Colors.white),
                    ),
                    radioColor: const Color(0xFF553529),
                  ),

                  // Credit/Debit card
                  PaymentOptionCard(
                    value: "Credit/Debit",
                    groupValue: selectedoption,
                    onChanged: (val) => setState(() {
                      selectedoption = val;
                    }),
                    trailing: CircleAvatar(
                      backgroundColor: const Color(0xFF553529),
                      radius: 17,
                      child: Icon(Icons.credit_card, color: Colors.white),
                    ),
                    radioColor: const Color(0xFF553529),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SizedBox(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          await paymentnavigation();
                        },

                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                            const Color(0xFF432D25),
                          ),
                        ),
                        child: Text(
                          selectedoption == "Cash on delivery"
                              ? "Place Order"
                              : "Confirm Payment",

                          style: TextStyle(
                            color: const Color(0xFFFCF7EF),
                            fontWeight: FontWeight.bold,
                          ),
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

  Future<void> paymentnavigation() async {
    try {
      if (selectedoption == "Credit/Debit") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Creditcard(
              itemid: widget.itemid,
              totalprice: widget.totalprice,
              quantity: widget.selectedquantity,
              size: widget.selectedsize,
              name: widget.name,
              image: widget.image,
            ),
          ),
        );
      } else if (selectedoption == "Net banking") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Netbanking(
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
        await UPIpayment(
          itemId: widget.itemid,
          size: widget.selectedsize,
          quantity: widget.selectedquantity,
          totalPrice: widget.totalprice,
          image: widget.image,
          itemname: widget.name,
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Your order has been placed successfully!Thank you for choosing SolCafe.",
            ),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Orders()),
        );
      }
    } catch (e) {
      print("Error $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Sorry,we couldn't place your order!Please try again or contact our support team if the issue persists",
          ),
        ),
      );
    }
  }
}

//first making_orders,then ordered items,and last payments


//Why inserting data into making_orders first?

//ordered_items.orderId needs a reference.

// payments.orderId also needs a reference.

// So we must generate orderId first.



// Why ordered items second?

// This contains orderId from making_orders.

// Without creating making_orders first, you cannot insert items here.

// Each item stored here helps calculate the final total.



// Why payments last?

// payments.amount = total from ordered_items

// payments.orderId = reference from making_orders

// payments.userId = reference from users