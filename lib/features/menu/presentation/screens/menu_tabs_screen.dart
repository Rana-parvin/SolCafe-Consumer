import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solcafe/core/presentation/widgets/app_drawer.dart';
import 'package:solcafe/features/cart/presentation/screens/cart_screen.dart';
import 'package:solcafe/features/menu/presentation/screens/search_screen.dart';
import 'package:solcafe/features/menu/presentation/widgets/menu_item_card.dart';

class MenuTabsScreen extends StatefulWidget {
  const MenuTabsScreen({super.key});

  @override
  State<MenuTabsScreen> createState() => _MenuTabsScreenState();
}

class _MenuTabsScreenState extends State<MenuTabsScreen> with TickerProviderStateMixin {
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
        backgroundColor: const Color(0xFF301F19),
        iconTheme: const IconThemeData(color: Color(0xFFEBE2DE)),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                "Good to see you🍵",
                style: GoogleFonts.rancho(
                  color: const Color(0xFFF5F5DC),
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                  fontSize: 19,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: FirestoreSearchDelegate());
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
        ],
        bottom: TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorColor: Colors.white,
          unselectedLabelColor: Colors.grey[400],
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.amber,
          ),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
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
      drawer: const Menuoptions(),
      body: TabBarView(
        controller: tabcontrol,
        children: const [
          MenuItemCard(),
          MenuItemCard(category: "coffee"),
          MenuItemCard(category: "non coffee"),
          MenuItemCard(category: "cake"),
          MenuItemCard(category: "pastry"),
          MenuItemCard(category: "other items"),
        ],
      ),
    );
  }
}

// Backward compatibility alias
typedef Tabpage = MenuTabsScreen;
