import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solcafe/core/theme/solcafe_colors.dart';
import 'package:solcafe/core/theme/theme_provider.dart';
import 'package:solcafe/features/auth/presentation/screens/edit_profile_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeNotifierProvider);
    final isLight = themeMode.isLight(context);
    final colors = context.solcafeColors;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: GoogleFonts.readexPro(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
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
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                      height: 140,
                      width: 140,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isLight
                              ? [const Color(0xFFF5E1C0), const Color(0xFFC68B27)]
                              : [const Color(0xFF3A2518), const Color(0xFF1C120C)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: colors.cardBorder,
                            offset: const Offset(4, 4),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          child: Icon(
                            isLight ? Icons.wb_sunny_rounded : Icons.nights_stay_rounded,
                            key: ValueKey(isLight),
                            size: 60,
                            color: isLight ? const Color(0xFFC68B27) : const Color(0xFFE5B25D),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
              Expanded(
                child: ListView(
                  children: [
                    _buildSettingsCard(
                      context,
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
                      context,
                      icon: isLight ? Icons.wb_sunny_outlined : Icons.nights_stay_outlined,
                      iconColor: colors.accentGold,
                      title: "Theme Mode",
                      trailing: SegmentedButton<SolCafeThemeMode>(
                        segments: const [
                          ButtonSegment(value: SolCafeThemeMode.cream, label: Text('Light')),
                          ButtonSegment(value: SolCafeThemeMode.brown, label: Text('Dark')),
                        ],
                        selected: {themeMode == SolCafeThemeMode.system ? (isLight ? SolCafeThemeMode.cream : SolCafeThemeMode.brown) : themeMode},
                        onSelectionChanged: (newSelection) {
                          ref.read(themeNotifierProvider.notifier).setThemeMode(newSelection.first);
                        },
                      ),
                    ),
                    _buildSettingsCard(
                      context,
                      icon: Icons.notifications_none,
                      title: "Notifications",
                    ),
                    _buildSettingsCard(
                      context,
                      icon: Icons.language,
                      title: "Language",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
    Color? iconColor,
  }) {
    final colors = context.solcafeColors;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Card(
        child: ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: Icon(icon, color: iconColor ?? colors.textPrimary),
          title: Text(
            title,
            style: GoogleFonts.readexPro(fontSize: 15, fontWeight: FontWeight.w600, color: colors.textPrimary),
          ),
          trailing: trailing,
        ),
      ),
    );
  }
}

typedef Settingspage = SettingsScreen;
