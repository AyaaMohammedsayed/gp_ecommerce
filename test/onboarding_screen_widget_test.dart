import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gp_ecommerce/features/onboarding_screen/onboarding_screen.dart';
import 'package:gp_ecommerce/features/Auth/view/screens/auth_screen.dart';

class FakeAuthPage extends StatelessWidget {
  const FakeAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Auth Page'),
      ),
    );
  }
}

Widget createTestApp() {
  return MaterialApp(
    home: const OnboardingScreen(),
    routes: {
      AuthScreen.routeName: (context) => const FakeAuthPage(),
    },
  );
}

Future<void> setTestScreenSize(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(430, 932));
  tester.view.devicePixelRatio = 1.0;

  addTearDown(() async {
    await tester.binding.setSurfaceSize(null);
    tester.view.resetDevicePixelRatio();
  });
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Onboarding Screen Widget Tests', () {
    testWidgets('onboarding screen displays enter showroom button',
            (WidgetTester tester) async {
          await setTestScreenSize(tester);

          SharedPreferences.setMockInitialValues({});

          await tester.pumpWidget(createTestApp());
          await tester.pumpAndSettle();

          expect(find.text('ENTER SHOWROOM'), findsOneWidget);
        });

    testWidgets('enter showroom saves onboarding and navigates to auth',
            (WidgetTester tester) async {
          await setTestScreenSize(tester);

          SharedPreferences.setMockInitialValues({});

          await tester.pumpWidget(createTestApp());
          await tester.pumpAndSettle();

          final button = find.text('ENTER SHOWROOM');

          expect(button, findsOneWidget);

          await tester.tap(button);
          await tester.pumpAndSettle();

          final prefs = await SharedPreferences.getInstance();

          expect(prefs.getBool('hasSeenOnboarding'), true);
          expect(find.text('Auth Page'), findsOneWidget);
        });
  });
}