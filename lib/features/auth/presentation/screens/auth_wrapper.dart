import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solcafe/features/auth/presentation/providers/auth_provider.dart';
import 'package:solcafe/dope%20introduction/dope%20main.dart';
import 'package:solcafe/working%20with%20bottombar/bottom%20nav%20provider/bottom%20nav_provider.dart';
import 'package:solcafe/working%20with%20bottombar/bottom%20nav%20stylish.dart';

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
