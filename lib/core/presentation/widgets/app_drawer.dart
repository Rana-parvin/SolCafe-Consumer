import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solcafe/features/offers/presentation/screens/offers_screen.dart';
import 'package:solcafe/features/referral/presentation/screens/referral_screen.dart';
import 'package:solcafe/core/utils/string_utils.dart';
import 'package:solcafe/features/auth/presentation/screens/login_screen.dart';
import 'package:solcafe/features/auth/presentation/screens/my_account_screen.dart';
import 'package:solcafe/features/order/presentation/screens/order_history_screen.dart';

class Menuoptions extends StatefulWidget {
  const Menuoptions({super.key});

  @override
  State<Menuoptions> createState() => _MenuoptionsState();
}

class _MenuoptionsState extends State<Menuoptions> {
  File? profileimage;

  @override
  void initState() {
    super.initState();
    loadimage();
  }

  Future<void> loadimage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagepath = prefs.getString('profile_image_path');
    if (imagepath != null && File(imagepath).existsSync()) {
      setState(() {
        profileimage = File(imagepath);
      });
    }
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var emailid = FirebaseAuth.instance.currentUser?.email;
  var username = FirebaseAuth.instance.currentUser?.displayName;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF352520),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.brown, // header color
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Solcafe",
                      style: GoogleFonts.playpenSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: const Color(0xFFF5E1C0),
                      ),
                    ),
                    const Icon(
                      Icons.coffee_outlined,
                      size: 40,
                      color: Color(0xFFF5E1C0),
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: profileimage != null
                          ? FileImage(profileimage!)
                          : null,
                      radius: 24,
                      child: profileimage == null
                          ? const Icon(
                              Icons.person_outline,
                              color: Colors.brown,
                              size: 28,
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          StringUtils.capitalizeFullName(username) ?? "",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          emailid.toString(),
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Tooltip(
              message: 'My Account',
              child: Icon(Icons.person_pin, color: Colors.white),
            ),
            title: const Text('My Account', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyAccountScreen()),
              );
            },
          ),

          ListTile(
            leading: const Tooltip(
              message: "Order history",
              child: Icon(Icons.shopping_bag_outlined, color: Colors.white),
            ),
            title: const Text('Order History', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Orders()),
              );
            },
          ),

          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Offers()),
              );
            },
            leading: const Tooltip(
              message: "Offers and coupons",
              child: Icon(Icons.card_giftcard_outlined, color: Colors.white),
            ),
            title: const Text(
              'Offers and coupons',
              style: TextStyle(color: Colors.white),
            ),
          ),
          ListTile(
            leading: const Tooltip(
              message: "Share",
              child: Icon(Icons.share_outlined, color: Colors.white),
            ),
            title: const Text(
              'Refer a friend',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // Share logic
              generateReferralCode(8);
            },
          ),
          ListTile(
            leading: const Tooltip(
              message: "About",
              child: Icon(Icons.info_outline, color: Colors.white),
            ),
            title: const Text('About Us', style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
          ListTile(
            leading: const Tooltip(
              message: "Rate me",
              child: Icon(Icons.star_rate_outlined, color: Colors.white),
            ),
            title: const Text('Rate us', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Rate us logic
            },
          ),
          const Divider(thickness: 1.2, color: Colors.white30),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.white),
            title: const Text('Logout', style: TextStyle(color: Colors.white)),
            onTap: () => logout(context),
          ),
        ],
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Logged out successfully",
            style: TextStyle(color: Color.fromARGB(255, 41, 21, 14)),
          ),
          backgroundColor: Color(0xFFF5E1C0),
        ),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Logout failed!$e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
