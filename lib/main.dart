import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solcafe/core/theme/app_theme.dart';
import 'package:solcafe/core/theme/solcafe_colors.dart';
import 'package:solcafe/core/theme/theme_provider.dart';
import 'package:solcafe/features/auth/presentation/screens/splash_screen.dart';
import 'package:solcafe/firebase_options.dart';

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
    final solCafeMode = ref.watch(themeNotifierProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SolCafe',
      theme: creamTheme,
      darkTheme: brownTheme,
      themeMode: solCafeMode.flutterThemeMode,
      builder: (context, child) {
        // Synchronize platform System UI overlay style (status bar & nav bar) with active theme
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final solcafeCols = isDark ? SolCafeColors.dark : SolCafeColors.light;

        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
            statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
            systemNavigationBarColor: solcafeCols.navBarBackground,
            systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          ),
        );
        return child!;
      },
      home: const UserSplash(),
    );
  }
}
