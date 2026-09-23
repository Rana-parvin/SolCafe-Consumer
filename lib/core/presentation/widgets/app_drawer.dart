import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solcafe/core/presentation/widgets/auth_logo.dart';
import 'package:solcafe/core/theme/solcafe_colors.dart';
import 'package:solcafe/core/utils/string_utils.dart';
import 'package:solcafe/features/auth/presentation/providers/auth_provider.dart';
import 'package:solcafe/features/auth/presentation/screens/login_screen.dart';
import 'package:solcafe/features/auth/presentation/screens/my_account_screen.dart';
import 'package:solcafe/features/offers/presentation/screens/offers_screen.dart';
import 'package:solcafe/features/order/presentation/screens/order_history_screen.dart';
import 'package:solcafe/features/referral/presentation/screens/referral_screen.dart';

class Menuoptions extends ConsumerStatefulWidget {
  const Menuoptions({super.key});

  @override
  ConsumerState<Menuoptions> createState() => _MenuoptionsState();
}

class _MenuoptionsState extends ConsumerState<Menuoptions> {
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
      if (!mounted) return;
      setState(() {
        profileimage = File(imagepath);
      });
    }
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final emailid = currentUser?.email;
    final username = currentUser?.displayName;
    final colors = context.solcafeColors;

    return Drawer(
      backgroundColor: colors.drawerBackground,
      child: Column(
        children: [
          // 1. Branded Header (Top)
          Container(
            padding: const EdgeInsets.fromLTRB(20, 52, 20, 20),
            decoration: BoxDecoration(color: colors.drawerHeaderBackground),
            child: Row(
              children: [
                const DrawerLogo(size: 44),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "SolCafe",
                      style: GoogleFonts.readexPro(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "COFFEE & MORE",
                      style: GoogleFonts.readexPro(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: colors.accentGold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 2. Middle Navigation Section (Expanded Scrollable)
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                ListTile(
                  leading: Icon(Icons.home_outlined, color: colors.textPrimary),
                  title: Text('Home', style: TextStyle(color: colors.textPrimary)),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),

                ListTile(
                  leading: Icon(Icons.local_offer_outlined, color: colors.textPrimary),
                  title: Text('Offers', style: TextStyle(color: colors.textPrimary)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const OffersScreen()),
                    );
                  },
                ),

                ListTile(
                  leading: Icon(Icons.group_add_outlined, color: colors.textPrimary),
                  title: Text('Refer a friend', style: TextStyle(color: colors.textPrimary)),
                  onTap: () {
                    final code = generateReferralCode(6);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Your referral code: $code')),
                    );
                  },
                ),

                ListTile(
                  leading: Icon(Icons.person_pin, color: colors.textPrimary),
                  title: Text('My Account', style: TextStyle(color: colors.textPrimary)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyAccountScreen()),
                    );
                  },
                ),

                ListTile(
                  leading: Icon(Icons.shopping_bag_outlined, color: colors.textPrimary),
                  title: Text('Order History', style: TextStyle(color: colors.textPrimary)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
                    );
                  },
                ),

                ListTile(
                  leading: Icon(Icons.help_outline, color: colors.textPrimary),
                  title: Text('Help & Support', style: TextStyle(color: colors.textPrimary)),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (modalContext) {
                        final modalColors = modalContext.solcafeColors;
                        return Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Help & Support',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: modalColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 15),
                              ListTile(
                                leading: Icon(Icons.email, color: modalColors.accentGold),
                                title: Text('Support Email', style: TextStyle(color: modalColors.textPrimary)),
                                subtitle: Text('support@solcafe.com', style: TextStyle(color: modalColors.textSecondary)),
                              ),
                              ListTile(
                                leading: Icon(Icons.phone, color: modalColors.accentGold),
                                title: Text('Customer Care', style: TextStyle(color: modalColors.textPrimary)),
                                subtitle: Text('+1 800 555 0199', style: TextStyle(color: modalColors.textSecondary)),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(modalContext),
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),

          // 3. Bottom Section (Profile & Logout)
          Divider(color: colors.borderSubtle, thickness: 1, height: 1),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: colors.surfaceSecondary,
                      backgroundImage: profileimage != null ? FileImage(profileimage!) : null,
                      child: profileimage == null
                          ? Icon(Icons.person, size: 26, color: colors.textPrimary)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            StringUtils.capitalizeFullName(username ?? "Guest User") ?? "Guest User",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: colors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            emailid ?? "",
                            style: TextStyle(
                              fontSize: 12,
                              color: colors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.logout, color: colors.statusCancelledText),
                  title: Text('Logout', style: TextStyle(color: colors.statusCancelledText)),
                  onTap: () => logout(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    try {
      final logoutUseCase = ref.read(logoutUseCaseProvider);
      await logoutUseCase();

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Logged out successfully")),
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
          content: Text("Logout failed! $e"),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}
