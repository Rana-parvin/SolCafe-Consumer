import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solcafe/core/presentation/widgets/app_drawer.dart';
import 'package:solcafe/core/presentation/widgets/auth_logo.dart';

import 'package:solcafe/features/auth/presentation/providers/auth_provider.dart';

void main() {
  testWidgets('Customer App Drawer (Menuoptions) renders correctly', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentUserProvider.overrideWithValue(null),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              child: Menuoptions(),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(DrawerLogo), findsOneWidget);
    expect(find.text("SolCafe"), findsOneWidget);
    expect(find.text("COFFEE & MORE"), findsOneWidget);
    expect(find.text("Home"), findsOneWidget);
    expect(find.text("Offers"), findsOneWidget);
    expect(find.text("Refer a friend"), findsOneWidget);
    expect(find.text("My Account"), findsOneWidget);
    expect(find.text("Order History"), findsOneWidget);
    expect(find.text("Help & Support"), findsOneWidget);
    expect(find.text("Guest User"), findsOneWidget);
    expect(find.text("Logout"), findsOneWidget);
  });
}
