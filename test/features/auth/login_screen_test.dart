import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solcafe/features/auth/presentation/screens/login_screen.dart';
import 'package:solcafe/features/auth/presentation/widgets/auth_background.dart';

void main() {
  Widget createTestWidget() {
    return const ProviderScope(
      child: MaterialApp(
        home: LoginScreen(),
      ),
    );
  }

  group('LoginScreen Responsive Layout & RenderFlex Overflow Tests', () {
    testWidgets('renders cleanly on narrow viewports (width: 215.2px) without RenderFlex overflow',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(215.2, 600.0);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text("Access your account"), findsOneWidget);
      expect(find.text("Don't have an account?"), findsOneWidget);
      expect(find.text("Sign up"), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders cleanly on compact phones (width: 320px) without RenderFlex overflow',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(320.0, 640.0);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text("Access your account"), findsOneWidget);
      expect(find.text("Don't have an account?"), findsOneWidget);
      expect(find.text("Sign up"), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders cleanly on standard phones (width: 360px) without RenderFlex overflow',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360.0, 800.0);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text("Access your account"), findsOneWidget);
      expect(find.text("Don't have an account?"), findsOneWidget);
      expect(find.text("Sign up"), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders cleanly on tablets (width: 768px) without RenderFlex overflow',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(768.0, 1024.0);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text("Access your account"), findsOneWidget);
      expect(find.text("Don't have an account?"), findsOneWidget);
      expect(find.text("Sign up"), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders cleanly on Flutter Web / Desktop (width: 1280px) without RenderFlex overflow',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280.0, 800.0);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text("Access your account"), findsOneWidget);
      expect(find.text("Don't have an account?"), findsOneWidget);
      expect(find.text("Sign up"), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('contains AuthBackground shell and toggles between Login and Sign Up in-place',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800.0, 950.0);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify AuthBackground is rendered in the widget tree
      expect(find.byType(AuthBackground), findsOneWidget);
      expect(find.text("Access your account"), findsOneWidget);

      // Ensure visible & Tap Sign up
      final signUpFinder = find.text("Sign up");
      await tester.ensureVisible(signUpFinder);
      await tester.pumpAndSettle();
      await tester.tap(signUpFinder);
      await tester.pumpAndSettle();

      // Verify transitioned to Sign Up card in place
      expect(find.text("Welcome! Let's get started"), findsOneWidget);
      expect(find.byType(AuthBackground), findsOneWidget);

      // Ensure visible & Tap Login
      final loginFinder = find.text("Login");
      await tester.ensureVisible(loginFinder);
      await tester.pumpAndSettle();
      await tester.tap(loginFinder);
      await tester.pumpAndSettle();

      // Verify transitioned back to Login card in place
      expect(find.text("Access your account"), findsOneWidget);
      expect(find.byType(AuthBackground), findsOneWidget);
    });
  });
}
