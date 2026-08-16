import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    try {
      final logoutUseCase = ref.read(logoutUseCaseProvider);
      await logoutUseCase();

      // Clear the local profile image cache path upon logout to avoid privacy leaks when another user logs in
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('profile_image_path');

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Logged out successfully")),
      );

      // Clean up navigation stack and return to Login Screen
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign Out failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final authState = ref.watch(authStateChangesProvider);

    return Scaffold(
      backgroundColor: theme.surface,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'My Account',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: authState.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text("No user details available"));
          }
          final formattedName = StringUtils.capitalizeFullName(user.displayName) ?? 'Guest User';

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              children: [
                // Profile Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [theme.primary, theme.secondary],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.primary.withOpacity(.35),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.white.withOpacity(.25),
                        backgroundImage: profileImage != null
                            ? FileImage(profileImage!)
                            : null,
                        child: profileImage == null
                            ? const Icon(
                                Icons.person_rounded,
                                size: 50,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        formattedName,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        user.email,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // Info Cards
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
                    loadImage(); // Reload image in case it was updated
                  },
                ),
                const SizedBox(height: 25),
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
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
    );
  }

  Widget _infoTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    final theme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: theme.secondary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: theme.primary.withOpacity(.15),
            child: Icon(icon, color: theme.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 13, color: theme.primary),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: theme.primary,
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
    final theme = Theme.of(context).colorScheme;

    // Fixed contrast: Destructive buttons use red background with white text, others use amber/brown accents
    final Color buttonBg = isDestructive ? Colors.red.shade800 : Colors.brown.shade800;
    final Color textIconColor = Colors.white;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: buttonBg,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textIconColor),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: textIconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
