import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinetic/features/Auth/view/screens/auth_screen.dart';
import 'package:kinetic/features/Home/view/screens/home_screen.dart';
import 'package:kinetic/features/onboarding_screen/onboarding_screen.dart';
import 'package:kinetic/features/splash_screen/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakePage extends StatelessWidget {
  final String title;

  const FakePage(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(title),
      ),
    );
  }
}

Widget createTestApp() {
  return MaterialApp(
    home: const SplashScreen(),
    routes: {
      OnboardingScreen.routeName: (context) =>
      const FakePage('Onboarding Page'),
      AuthScreen.routeName: (context) =>
      const FakePage('Auth Page'),
      HomeScreen.routeName: (context) =>
      const FakePage('Home Page'),
    },
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Splash Screen Widget Tests', () {
    testWidgets('first time user navigates to onboarding',
            (WidgetTester tester) async {
          SharedPreferences.setMockInitialValues({});

          await tester.pumpWidget(createTestApp());

          await tester.pump(const Duration(seconds: 2));
          await tester.pumpAndSettle();

          expect(find.text('Onboarding Page'), findsOneWidget);
        });

    testWidgets('user who saw onboarding but has no token navigates to auth',
            (WidgetTester tester) async {
          SharedPreferences.setMockInitialValues({
            'hasSeenOnboarding': true,
          });

          await tester.pumpWidget(createTestApp());

          await tester.pump(const Duration(seconds: 2));
          await tester.pumpAndSettle();

          expect(find.text('Auth Page'), findsOneWidget);
        });

    testWidgets('logged in user navigates to home',
            (WidgetTester tester) async {
          SharedPreferences.setMockInitialValues({
            'hasSeenOnboarding': true,
            'token': 'fake_token',
          });

          await tester.pumpWidget(createTestApp());

          await tester.pump(const Duration(seconds: 2));
          await tester.pumpAndSettle();

          expect(find.text('Home Page'), findsOneWidget);
        });
  });
}