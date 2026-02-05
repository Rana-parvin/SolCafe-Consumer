import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solcafe/dope introduction/dope main.dart';
import 'package:solcafe/working%20with%20bottombar/bottom%20nav%20provider/bottom%20nav_provider.dart';
import 'package:solcafe/working with bottombar/bottom nav stylish.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return const BottomNavHolder();
        }
        return const Dopemain();
      },
    );
  }
}




class BottomNavHolder extends ConsumerWidget {
  const BottomNavHolder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavProvider);

    return Bottomnavstylish(
      
    );
  }
}
