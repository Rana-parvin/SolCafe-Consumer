import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solcafe/core/theme/solcafe_colors.dart';
import 'package:solcafe/features/home/presentation/providers/bottom_nav_provider.dart';
import 'package:solcafe/features/menu/presentation/screens/menu_tabs_screen.dart';
import 'package:solcafe/features/order/presentation/screens/order_history_screen.dart';
import 'package:solcafe/features/payment/presentation/screens/payment_history_screen.dart';
import 'package:solcafe/features/settings/presentation/screens/settings_screen.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
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
    final colors = context.solcafeColors;

    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: pages,
        onPageChanged: (index) {
          ref.read(bottomNavProvider.notifier).setIndex(index);
        },
      ),
      bottomNavigationBar: StylishBottomBar(
        backgroundColor: colors.navBarBackground,
        option: DotBarOptions(
          dotStyle: DotStyle.circle,
          gradient: LinearGradient(
            colors: [colors.navBarSelected, colors.accentGold],
          ),
        ),
        items: [
          BottomBarItem(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            selectedColor: colors.navBarSelected,
            unSelectedColor: colors.navBarUnselected,
            title: const Text("Home"),
          ),
          BottomBarItem(
            icon: const Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: const Icon(Icons.account_balance_wallet),
            selectedColor: colors.navBarSelected,
            unSelectedColor: colors.navBarUnselected,
            title: const Text("Payment"),
          ),
          BottomBarItem(
            icon: const Icon(Icons.shopping_bag_outlined),
            selectedIcon: const Icon(Icons.shopping_bag),
            selectedColor: colors.navBarSelected,
            unSelectedColor: colors.navBarUnselected,
            title: const Text("Orders"),
          ),
          BottomBarItem(
            icon: const Icon(Icons.settings_suggest_outlined),
            selectedIcon: const Icon(Icons.settings_suggest),
            selectedColor: colors.navBarSelected,
            unSelectedColor: colors.navBarUnselected,
            title: const Text("Settings"),
          ),
        ],
        currentIndex: currentIndex,
        onTap: (value) {
          ref.read(bottomNavProvider.notifier).setIndex(value);
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

// Typedef alias for backward compatibility
typedef Bottomnavstylish = MainScreen;
