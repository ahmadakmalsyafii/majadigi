import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:majadigi/core/di/di.dart' as di;
import 'package:majadigi/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:majadigi/features/auth/presentation/pages/login_page.dart';

void main() {
  setUpAll(() async {
    // Initialize dependency injection before running tests
    di.init();
  });

  tearDownAll(() {
    // Clean up after tests
    di.sl.reset();
  });

  group('LoginPage Widget Tests', () {
    testWidgets('LoginPage renders without errors', (WidgetTester tester) async {
      // Set device size for testing
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      tester.binding.window.physicalSizeTestValue = const Size(540, 960);

      // Build the widget tree with proper wrapping
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>(
            create: (context) => di.sl<AuthBloc>(),
            child: const LoginPage(),
          ),
        ),
      );

      // Wait for all animations and async operations to complete
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify UI elements are rendered properly
      expect(find.text('Sign in to your'), findsOneWidget);
      expect(find.text('Account'), findsOneWidget);
      expect(find.text('Enter your email and password to log in'), findsOneWidget);
      expect(find.text('Email'), findsWidgets);
      expect(find.text('Password'), findsWidgets);
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('Password visibility toggle works', (WidgetTester tester) async {
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      tester.binding.window.physicalSizeTestValue = const Size(540, 960);

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>(
            create: (context) => di.sl<AuthBloc>(),
            child: const LoginPage(),
          ),
        ),
      );

      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify visibility toggle button exists
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);

      // Tap the visibility toggle
      await tester.tap(find.byIcon(Icons.visibility_off_outlined));
      await tester.pumpAndSettle();

      // Verify icon changed
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    });
  });
}
