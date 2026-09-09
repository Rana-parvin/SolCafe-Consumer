import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solcafe/core/theme/solcafe_colors.dart';
import 'package:solcafe/core/utils/string_utils.dart';
import 'package:solcafe/features/auth/presentation/providers/auth_provider.dart';
import 'package:solcafe/features/auth/presentation/screens/edit_profile_screen.dart';
import 'package:solcafe/features/auth/presentation/screens/login_screen.dart';

class MyAccountScreen extends ConsumerStatefulWidget {
  const MyAccountScreen({super.key});

  @override
  ConsumerState<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends ConsumerState<MyAccountScreen> {
  File? profileImage;

  @override
  void initState() {
    super.initState();
    loadImage();
  }

  Future<void> loadImage() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('profile_image_path');
    if (path != null && File(path).existsSync()) {
      setState(() => profileImage = File(path));
    }
  }

  Future<void> handleSignOut() async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      final logoutUseCase = ref.read(logoutUseCaseProvider);
      await logoutUseCase();

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('profile_image_path');

      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text("Logged out successfully")),
      );

      navigator.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text("Sign Out failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.solcafeColors;
    final authState = ref.watch(authStateChangesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
        centerTitle: true,
      ),
      body: authState.when(
        data: (user) {
          if (user == null) {
            return Center(
              child: Text("No user details available", style: TextStyle(color: colors.textSecondary)),
            );
          }
          final formattedName = StringUtils.capitalizeFullName(user.displayName) ?? 'Guest User';

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                // Profile Header Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [colors.surfaceSecondary, colors.cardBackground],
                    ),
                    border: Border.all(color: colors.cardBorder),
                    boxShadow: [
                      BoxShadow(
                        color: colors.cardBorder.withValues(alpha: 0.5),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: colors.accentGoldSubtle,
                        backgroundImage: profileImage != null ? FileImage(profileImage!) : null,
                        child: profileImage == null
                            ? Icon(
                                Icons.person_rounded,
                                size: 50,
                                color: colors.accentGold,
                              )
                            : null,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        formattedName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: TextStyle(
                          color: colors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Info Tiles
                _infoTile(
                  context,
                  icon: Icons.email_rounded,
                  title: 'Email',
                  value: user.email,
                ),
                const SizedBox(height: 12),
                _infoTile(
                  context,
                  icon: Icons.phone_rounded,
                  title: 'Phone',
                  value: user.phoneNumber.isEmpty ? 'Not provided' : user.phoneNumber,
                ),

                const SizedBox(height: 30),

                // Action Buttons
                _actionButton(
                  context,
                  icon: Icons.edit_rounded,
                  label: 'Edit Profile',
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                    );
                    loadImage();
                  },
                ),
                const SizedBox(height: 14),
                _actionButton(
                  context,
                  icon: Icons.logout_rounded,
                  label: 'Sign Out',
                  isDestructive: true,
                  onTap: handleSignOut,
                ),
              ],
            ),
          );
        },
        loading: () => Center(child: CircularProgressIndicator(color: colors.accentGold)),
        error: (e, _) => Center(
          child: Text("Error: $e", style: TextStyle(color: colors.statusCancelledText)),
        ),
      ),
    );
  }

  Widget _infoTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    final colors = context.solcafeColors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.cardBorder),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: colors.accentGoldSubtle,
            child: Icon(icon, color: colors.accentGold, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 12, color: colors.textMuted),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final colors = context.solcafeColors;
    final Color buttonBg = isDestructive ? colors.statusCancelledBackground : colors.cardBackground;
    final Color textIconColor = isDestructive ? colors.statusCancelledText : colors.textPrimary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: buttonBg,
          border: Border.all(color: isDestructive ? colors.statusCancelledText.withValues(alpha: 0.3) : colors.cardBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textIconColor, size: 20),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: textIconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
