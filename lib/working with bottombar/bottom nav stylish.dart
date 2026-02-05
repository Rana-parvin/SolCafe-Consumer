import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solcafe/working%20with%20bottombar/bottom%20nav%20provider/bottom%20nav_provider.dart';
import 'package:solcafe/working%20with%20payment/All%20payments.dart';
import 'package:solcafe/working%20with%20order/orders.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:solcafe/settings/settings%20page.dart';
import 'package:solcafe/working with tabbar/tabpage.dart';


class Bottomnavstylish extends ConsumerStatefulWidget {
  const Bottomnavstylish({super.key});

  @override
  ConsumerState<Bottomnavstylish> createState() => _BottomnavstylishState();
}

class _BottomnavstylishState extends ConsumerState<Bottomnavstylish> {
  late PageController _pageController;
  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      const Tabpage(),
      const Allpayments(),
      const Orders(),
      const Settingspage(),
    ];
    _pageController = PageController(initialPage: ref.read(bottomNavProvider));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(bottomNavProvider);

    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: pages,
        onPageChanged: (index) {
          ref.read(bottomNavProvider.notifier).state = index;
        },
      ),
      bottomNavigationBar: StylishBottomBar(
        backgroundColor: Colors.brown[700],
        items: [
          BottomBarItem(icon: Icon(Icons.home_outlined), title: Text("Home")),
          BottomBarItem(icon: Icon(Icons.account_balance_wallet_outlined), title: Text("Payment")),
          BottomBarItem(icon: Icon(Icons.shopping_bag_outlined), title: Text("Orders")),
          BottomBarItem(icon: Icon(Icons.settings_suggest_outlined), title: Text("Settings")),
        ],
        option: DotBarOptions(dotStyle: DotStyle.circle),
        currentIndex: currentIndex,
        onTap: (value) {
          ref.read(bottomNavProvider.notifier).state = value;
          _pageController.animateToPage(
            value,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      ),
    );
  }
}
