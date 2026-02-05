import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:solcafe/size%20and%20quantity%20logics/size%20logic.dart';
import 'package:solcafe/working with order/add to cart.dart';
import 'package:solcafe/working with order/confirm order.dart';

class Viewindetail extends StatefulWidget {
  final String itemid;
  final Map<String, dynamic> itemdata;
  const Viewindetail({super.key, required this.itemid, required this.itemdata});

  @override
  State<Viewindetail> createState() => _ViewindetailState();
}

class _ViewindetailState extends State<Viewindetail>
    with TickerProviderStateMixin {
  bool isfavorite = false;
  int quantity = 1;
  String selectedsize = "";
  String selectedtype = "";


  late final AnimationController favController;
  bool showAnim = false;



  @override
  void initState() {
    super.initState();
    favController = AnimationController(vsync: this);

    final category = widget.itemdata['category']?.toLowerCase() ?? "";
    final List<String> sizes = Sizelogic.sizesfor(category);
    if (sizes.isNotEmpty) {
      selectedsize = sizes.first;
    }
  }

  void incrementq() => setState(() {
    quantity++;
  });

  void decrementq() => setState(() {
    if (quantity > 1) {
      quantity--;
    }
  });

  @override
  void dispose() {
    favController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final category = widget.itemdata['category']?.toLowerCase() ?? "";
    final List<String> sizeoptions = Sizelogic.sizesfor(category);

    
    return Scaffold(
      appBar: AppBar(
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: Icon(
                  isfavorite ? Icons.favorite : Icons.favorite_border,
                  color: const Color.fromARGB(255, 255, 231, 222),
                ),
                onPressed: () async {
                  setState(() => isfavorite = !isfavorite);

                  if (isfavorite) {
                    setState(() => showAnim = true);
                    await favController.forward(from: 0);
                    setState(() => showAnim = false);
                  }
                },
              ),
            ],
          ),
        ],
      ),

      body: Stack(
        children: [
          if (showAnim)
            Center(
              child: Lottie.asset(
                "assets/anims/Hearts feedback.json",
                controller: favController,
                width: 500,
                height: 500,
                onLoaded: (comp) {
                  favController.duration = comp.duration;
                },
              ),
            ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ItemeImageWidget(imagepath: widget.itemdata["image"]),
                  const SizedBox(height: 20),

                  Card(
                    color: const Color.fromARGB(255, 37, 24, 6),
                    child: ListTile(
                      title: Text(
                        widget.itemdata['name'],
                        style: GoogleFonts.adventPro(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFF5E1C0),
                        ),
                      ),
                      subtitle: widget.itemdata['price'] != null
                          ? Text(
                              "\$ ${widget.itemdata['price']}",
                              style: GoogleFonts.openSans(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFDAA520),
                              ),
                            )
                          : null,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Show Type selection only when category == others
                  if (widget.itemdata['category'] == 'others')
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Select Type",
                            style: GoogleFonts.openSans(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 10,
                            children: [
                              for (var t in [
                                "Option 1",
                                "Option 2",
                                "Option 3",
                              ])
                                ChoiceChip(
                                  label: Text(t),
                                  selected: selectedtype == t,
                                  onSelected: (_) {
                                    setState(() => selectedtype = t);
                                  },
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 10),

                  Text(
                    "Description",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 10),
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Text(
                        widget.itemdata["description"],
                        style: GoogleFonts.openSans(fontSize: 14, height: 1.5),
                      ),
                    ),
                  ),

                  // CATEGORY-BASED SIZE SELECTOR
                  if (sizeoptions.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Choose Size",
                            style: GoogleFonts.openSans(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ToggleButtons(
                            borderRadius: BorderRadius.circular(12),
                            selectedColor: Colors.white,
                            fillColor: const Color(0xFF6F4E37),
                            borderColor: Colors.brown,
                            selectedBorderColor: const Color(0xFFF5E1C0),
                            onPressed: (index) {
                              setState(() => selectedsize = sizeoptions[index]);
                            },
                            isSelected: sizeoptions
                                .map((s) => s == selectedsize)
                                .toList(),
                            children: sizeoptions
                                .map(
                                  (size) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                    ),
                                    child: Text(
                                      size,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 12),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Quantity",
                          style: GoogleFonts.openSans(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 37, 24, 6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  decrementq();
                                },
                                icon: const Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                quantity.toString(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  incrementq();
                                },
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 150,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Confirmorder(
                                  itemdata: widget.itemdata,
                                  size: selectedsize,
                                  quantity: quantity,
                                  itemid: widget.itemid,
                                  image: widget.itemdata['image'],
                                  name: widget.itemdata['name'],
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            "Order Now",
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddToCartPage(
                                  itemData: widget.itemdata,
                                  size: selectedsize,
                                  quantity: quantity,
                                  itemId: widget.itemid,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            "Add to cart",
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ItemeImageWidget extends StatelessWidget {
  final String imagepath;
  const ItemeImageWidget({super.key, required this.imagepath});


  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          imagepath,
          height: 325,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
