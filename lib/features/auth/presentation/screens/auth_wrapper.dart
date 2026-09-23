import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solcafe/features/auth/presentation/providers/auth_provider.dart';
import 'package:solcafe/features/auth/presentation/screens/login_screen.dart';
import 'package:solcafe/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:solcafe/features/home/presentation/providers/bottom_nav_provider.dart';
import 'package:solcafe/features/home/presentation/screens/main_screen.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          return const BottomNavHolder();
        }
        if (kIsWeb) {
          return const LoginScreen();
        }
        return const Dopemain();
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, stack) => Scaffold(
        body: Center(child: Text("Auth Error: $e")),
      ),
    );
  }
}

class BottomNavHolder extends ConsumerWidget {
  const BottomNavHolder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Keep reference to bottom nav provider for bottom navigation state sync
    ref.watch(bottomNavProvider);
    return const Bottomnavstylish();
  }
}
