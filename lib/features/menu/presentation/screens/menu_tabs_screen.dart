import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solcafe/core/presentation/widgets/app_drawer.dart';
import 'package:solcafe/core/theme/solcafe_colors.dart';
import 'package:solcafe/features/cart/presentation/screens/cart_screen.dart';
import 'package:solcafe/features/menu/presentation/providers/menu_provider.dart';
import 'package:solcafe/features/menu/presentation/screens/search_screen.dart';
import 'package:solcafe/features/menu/presentation/widgets/menu_item_card.dart';

class MenuTabsScreen extends ConsumerStatefulWidget {
  const MenuTabsScreen({super.key});

  @override
  ConsumerState<MenuTabsScreen> createState() => _MenuTabsScreenState();
}

class _MenuTabsScreenState extends ConsumerState<MenuTabsScreen> with TickerProviderStateMixin {
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
    final colors = context.solcafeColors;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Good to see you 🍵",
          style: GoogleFonts.readexPro(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: colors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              final searchUseCase = ref.read(searchMenuItemsUseCaseProvider);
              showSearch(
                context: context,
                delegate: FirestoreSearchDelegate(searchMenuItemsUseCase: searchUseCase),
              );
            },
            icon: Icon(Icons.search, color: colors.textPrimary),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
            icon: Icon(Icons.shopping_cart_outlined, color: colors.textPrimary),
          ),
        ],
        bottom: TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorColor: colors.accentGold,
          labelColor: colors.accentGold,
          unselectedLabelColor: colors.textSecondary,
          labelStyle: GoogleFonts.openSans(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          unselectedLabelStyle: GoogleFonts.openSans(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          controller: tabcontrol,
          isScrollable: true,
          tabs: const [
            Tab(text: "All"),
            Tab(text: "Coffee"),
            Tab(text: "Non Coffee"),
            Tab(text: "Cake"),
            Tab(text: "Pastry"),
            Tab(text: "Others"),
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

typedef Tabpage = MenuTabsScreen;
