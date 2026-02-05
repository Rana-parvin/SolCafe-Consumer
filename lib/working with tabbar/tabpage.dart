import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solcafe/working%20with%20cart/carts.dart';
import 'package:solcafe/drawer/drawer%20options.dart';
import 'package:solcafe/working%20with%20tabbar/common.dart';
import 'package:solcafe/working%20with%20search%20bar/custom%20saerch.dart';
class Tabpage extends StatefulWidget {
  const Tabpage({super.key});

  @override
  State<Tabpage> createState() => _TabpageState();
}

class _TabpageState extends State<Tabpage> with TickerProviderStateMixin {
  late TabController tabcontrol;

  @override
  void initState() {
    super.initState();
    tabcontrol = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    tabcontrol.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF301F19),
        iconTheme: IconThemeData(color: Color(0xFFEBE2DE)),

        title: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                "Good to see you🍵",
                style: GoogleFonts.rancho(
                  color: Color(0xFFF5F5DC),
                  fontWeight: FontWeight.w800,letterSpacing:2,
                  fontSize: 19
                ),
              ),
            ),
        
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            //for search
            onPressed: () {
              
              showSearch(context: context, delegate: FirestoreSearchDelegate());
            },
            icon: const Icon(Icons.search),
          ),

          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartsPage()),
              );
            },
            icon: Icon(Icons.shopping_cart_outlined),
          ), 
        ],
        bottom: TabBar(
         
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorColor: Colors.white,

          unselectedLabelColor: Colors.grey[400],
          labelStyle: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.amber,
          ),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400),
          controller: tabcontrol,
          isScrollable: true,
          tabs: const [
            Tab(text: "All"),
            Tab(text: "Coffee"),
            Tab(text: "Non coffee"),
            Tab(text: "Cake"),
            Tab(text: "Pastry"),
            Tab(text: "others"),
          ],
        ),
      ),
      drawer: Menuoptions(),
      body: TabBarView(
  controller: tabcontrol,
  children: [
    Common(),
    Common(category: "coffee"),
    Common(category: "non coffee"),
    Common(category: "cake"),
    Common(category: "pastry"),
    Common(category: "other items"),
  ],
),

    );
  }
}
