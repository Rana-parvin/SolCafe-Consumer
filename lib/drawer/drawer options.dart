import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solcafe/Offers/offers.dart';
import 'package:solcafe/refer%20a%20friend/give%20code.dart';
import 'package:solcafe/user%20authentication/login.dart';
import 'package:solcafe/user%20authentication/my%20account.dart';
import 'package:solcafe/working%20with%20order/orders.dart';

class Menuoptions extends StatefulWidget {
  const Menuoptions({super.key});

  @override
  State<Menuoptions> createState() => _MenuoptionsState();
}

class _MenuoptionsState extends State<Menuoptions> {
  File? profileimage;

  String? capitalizeFullName(String? name) {
    if (name == null || name.trim().isEmpty) return name;

    return name
        .trim()
        .split(' ')
        .map(
          (word) => word.isNotEmpty
              ? word[0].toUpperCase() + word.substring(1).toLowerCase()
              : '',
        )
        .join(' ');
  }

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
            decoration: BoxDecoration(
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
                        color: Color(0xFFF5E1C0),
                      ),
                    ),
                    Icon(
                      Icons.coffee_outlined,
                      size: 40,
                      color: Color(0xFFF5E1C0),
                    ),
                  ],
                ),
                SizedBox(height: 25),

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
                          ? Icon(
                              Icons.person_outline,
                              color: Colors.brown,
                              size: 28,
                            )
                          : null,
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          capitalizeFullName(username) ?? "",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          emailid.toString(),
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            leading: Tooltip(
              message: 'My Account',
              child: Icon(Icons.person_pin, color: Colors.white),
            ),
            title: Text('My Account', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyAccount()),
              );
            },
          ),

          ListTile(
            leading: Tooltip(
              message: "Order history",
              child: Icon(Icons.shopping_bag_outlined, color: Colors.white),
            ),
            title: Text('Order History', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Orders()),
              );
            },
          ),

          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Offers()),
              );
            },
            leading: Tooltip(
              message: "Offers and coupons",
              child: Icon(Icons.card_giftcard_outlined, color: Colors.white),
            ),
            title: Text(
              'Offers and coupons',
              style: TextStyle(color: Colors.white),
            ),
          ),
          ListTile(
            leading: Tooltip(
              message: "Share",
              child: Icon(Icons.share_outlined, color: Colors.white),
            ),
            title: Text(
              'Refer a friend',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // Share logic
              generateReferralCode(8);
            },
          ),
          ListTile(
            leading: Tooltip(
              message: "About",
              child: Icon(Icons.info_outline, color: Colors.white),
            ),
            title: Text('About Us', style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
          ListTile(
            leading: Tooltip(
              message: "Rate me",
              child: Icon(Icons.star_rate_outlined, color: Colors.white),
            ),
            title: Text('Rate us', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Rate us logic
            },
          ),
          Divider(thickness: 1.2, color: Colors.white30),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.white),
            title: Text('Logout', style: TextStyle(color: Colors.white)),
            onTap: () => logout(context),
          ),
        ],
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Logged out successfully",
            style: TextStyle(color: const Color.fromARGB(255, 41, 21, 14)),
          ),
          backgroundColor: Color(0xFFF5E1C0),
        ),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Logout failed!$e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
