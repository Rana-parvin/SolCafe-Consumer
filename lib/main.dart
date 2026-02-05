import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solcafe/theme%20management/theme_provider.dart';
import 'package:solcafe/firebase_options.dart';
import 'package:solcafe/user%20authentication/splash%20screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider); 
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
    
      home: const UserSplash(), 
    );
  }
}
