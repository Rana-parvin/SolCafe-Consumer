import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solcafe/core/theme/theme_provider.dart';
import 'package:solcafe/core/theme/app_theme.dart';
import 'package:solcafe/features/auth/presentation/screens/edit_profile_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool get _isLightTheme => ref.read(themeProvider) == creamTheme;

  void _handleToggleTheme() async {
    ref.read(themeProvider.notifier).setTheme(
      _isLightTheme ? brownTheme : creamTheme,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Settings",
          style: GoogleFonts.readexPro(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          color: theme.scaffoldBackgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 600),
                tween: Tween<double>(begin: 0.9, end: 1.0),
                curve: Curves.elasticOut,
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      height: 160,
                      width: 160,
                      decoration: BoxDecoration(
                        gradient: _isLightTheme
                            ? const LinearGradient(
                                colors: [Colors.orangeAccent, Colors.brown],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : const LinearGradient(
                                colors: [Colors.indigo, Colors.black87],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _isLightTheme
                                ? Colors.brown.shade200
                                : Colors.black54,
                            offset: const Offset(4, 4),
                            blurRadius: 10,
                          ),
                          BoxShadow(
                            color: _isLightTheme ? Colors.white : Colors.grey.shade900,
                            offset: const Offset(-4, -4),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 600),
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: ScaleTransition(scale: animation, child: child),
                            );
                          },
                          child: Icon(
                            _isLightTheme
                                ? Icons.sunny
                                : Icons.nights_stay_sharp,
                            key: ValueKey(_isLightTheme),
                            size: 70,
                            color: _isLightTheme
                                ? Colors.yellowAccent
                                : Colors.lightBlueAccent,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.05),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: _buildSettingsList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsList() {
    return ListView(
      key: ValueKey(_isLightTheme),
      children: [
        _buildSettingsCard(
          icon: Icons.edit_outlined,
          title: "Edit Profile",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EditProfileScreen()),
            );
          },
        ),
        _buildSettingsCard(
          icon: _isLightTheme ? Icons.sunny : Icons.nights_stay_sharp,
          iconColor: _isLightTheme ? Colors.amber[800] : Colors.lightBlueAccent,
          title: "Toggle Theme",
          trailing: Switch.adaptive(
            value: _isLightTheme,
            onChanged: (_) => _handleToggleTheme(),
          ),
        ),
        _buildSettingsCard(icon: Icons.notifications_none, title: "Notifications"),
        _buildSettingsCard(icon: Icons.language, title: "Language"),
      ],
    );
  }

  Widget _buildSettingsCard({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
    Color? iconColor,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(icon, color: iconColor ?? Theme.of(context).iconTheme.color),
        title: Text(
          title,
          style: GoogleFonts.readexPro(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: trailing,
      ),
    );
  }
}

// Backward compatibility alias
typedef Settingspage = SettingsScreen;
