import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solcafe/cart%20services/analytic%20service.dart';
import 'package:solcafe/cart%20services/cart%20service.dart';
import 'package:solcafe/models/cart%20item%20model.dart';
import 'package:solcafe/working%20with%20cart/carts.dart';

class AddToCartPage extends StatefulWidget {
  final String itemId;
  final String size;
  final int quantity;
  final Map<String, dynamic> itemData;

  const AddToCartPage({
    super.key,
    required this.itemId,
    required this.itemData,
    required this.quantity,
    required this.size,
  });

  @override
  State<AddToCartPage> createState() => _AddToCartPageState();
}

class _AddToCartPageState extends State<AddToCartPage> {
  double get _price {
    final value = widget.itemData['price'];

    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;

    return 0.0;
  }

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add to Cart')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _itemImage(),
              const SizedBox(height: 20),
              _itemTitleCard(),
              const SizedBox(height: 16),
              _descriptionSection(),
              const SizedBox(height: 16),
              _sizeRow(),
              const SizedBox(height: 16),
              _quantityRow(),
              const SizedBox(height: 24),
              _addToCartButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemImage() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          widget.itemData['image'],
          height: 320,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _itemTitleCard() {
    return Card(
      color: const Color(0xFF251806),
      child: ListTile(
        title: Text(
          widget.itemData['name'],
          style: GoogleFonts.adventPro(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFF5E1C0),
          ),
        ),
        subtitle: Text(
          '\$ ${widget.itemData['price']}',
          style: GoogleFonts.openSans(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFDAA520),
          ),
        ),
      ),
    );
  }

  Widget _descriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(
          widget.itemData['description'],
          style: GoogleFonts.openSans(fontSize: 14, height: 1.5),
        ),
      ],
    );
  }

  Widget _sizeRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Selected Size',
          style: GoogleFonts.openSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(widget.size),
      ],
    );
  }

  Widget _quantityRow() {
    return Row(
      children: [
        Text(
          'Quantity',
          style: GoogleFonts.openSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF251806),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            widget.quantity.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ],
    );
  }

  Widget _addToCartButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          await handleaddtocart(context);
        },
        child: const Text('Add to Cart'),
      ),
    );
  }

  // Future<void> _addToCart() async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user == null) throw Exception('User not logged in');

  //   final cartRef = FirebaseFirestore.instance.collection('cart items');

  //   final query = await cartRef
  //       .where('userId', isEqualTo: user.uid)
  //       .where('itemId', isEqualTo: widget.itemId)
  //       .where('size', isEqualTo: widget.size)
  //       .limit(1)
  //       .get();

  //   if (query.docs.isNotEmpty) {
  //     await query.docs.first.reference.update({
  //       'quantity': FieldValue.increment(widget.quantity),
  //     });
  //   } else {
  //     await cartRef.add({
  //       'userId': user.uid,
  //       'itemId': widget.itemId,
  //       // 'name': widget.itemData['name'],
  //       // 'price': widget.itemData['price'],
  //       // 'image': widget.itemData['image'],
  //       'size': widget.size,
  //       'quantity': widget.quantity,
  //       // 'addedAt': Timestamp.now(),
  //     });
  //   }
  // }

  final Cartservice _cartservice = Cartservice();
  final Analyticservice _analyticservice = Analyticservice();

  Future<void> handleaddtocart(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please login first")));
      return;
    }

    final cartitem = Cartitemmodel(
      image: widget.itemData["image"],
      itemid: widget.itemId,
      name: widget.itemData["name"],
      price: widget.itemData['price'],
      quantity: widget.quantity,
      size: widget.size,
      userid: user.uid,
    );

    final result = await _cartservice.addToCart(cartitem);

    if (!mounted) return;
    if (result == addtocartresult.addednew) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Item added to cart")));
    } else if (result == addtocartresult.updatedquantity) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Cart updated")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to add to the cart")),
      );
      return; // ❗ stop execution for failure
    }

    // ✅ Runs only for new add & update
    await _analyticservice.logAddToCart(
      itemid: widget.itemId,
      name: widget.itemData["name"],
      price: widget.itemData["price"],
      quantity: widget.quantity,
    );

    await Future.delayed(Duration(seconds: 3));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const CartsPage()),
    );
  }

  // Future<void> _logAnalytics() async {
  //   await _analytics.logAddToCart(
  //     items: [
  //       AnalyticsEventItem(
  //         itemId: widget.itemId,
  //         itemName: widget.itemData['name'],
  //         price:_price,
  //         quantity: widget.quantity,
  //       ),
  //     ],
  //   );
  // }
}
