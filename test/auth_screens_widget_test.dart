import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinetic/features/Auth/view/screens/auth_screen.dart';
import 'package:kinetic/features/Auth/view/screens/register_screen.dart';
import 'package:kinetic/features/Auth/view_model/cubit.dart';

Widget createTestWidget(Widget child) {
  return BlocProvider(
    create: (_) => AuthCubit(),
    child: MaterialApp(
      home: child,
      routes: {
        AuthScreen.routeName: (context) => const AuthScreen(),
        RegisterScreen.routeName: (context) => const RegisterScreen(),
      },
    ),
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

  group('Login Screen Widget Tests', () {
    testWidgets('shows validation message when login fields are empty',
            (WidgetTester tester) async {
          await setTestScreenSize(tester);

          await tester.pumpWidget(createTestWidget(const AuthScreen()));
          await tester.pumpAndSettle();

          final signInButton = find.text('Sign In to Kinetic');
          expect(signInButton, findsOneWidget);

          await tester.tap(signInButton);
          await tester.pump();
          await tester.pump(const Duration(seconds: 1));

          expect(find.text('Please enter email and password!'), findsOneWidget);
        });

    testWidgets('password visibility icon toggles password field',
            (WidgetTester tester) async {
          await setTestScreenSize(tester);

          await tester.pumpWidget(createTestWidget(const AuthScreen()));
          await tester.pumpAndSettle();

          final textFields = find.byType(TextField);
          expect(textFields, findsNWidgets(2));

          final passwordFieldBefore =
          tester.widget<TextField>(textFields.at(1));

          expect(passwordFieldBefore.obscureText, true);

          final eyeIcon = find.byIcon(Icons.visibility_outlined);
          expect(eyeIcon, findsOneWidget);

          await tester.tap(eyeIcon);
          await tester.pumpAndSettle();

          final passwordFieldAfter =
          tester.widget<TextField>(find.byType(TextField).at(1));

          expect(passwordFieldAfter.obscureText, false);
          expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
        });
  });

  group('Register Screen Widget Tests', () {
    testWidgets('shows validation message when register fields are empty',
            (WidgetTester tester) async {
          await setTestScreenSize(tester);

          await tester.pumpWidget(createTestWidget(const RegisterScreen()));
          await tester.pumpAndSettle();

          final createButton = find.text('Create Account').last;

          await tester.ensureVisible(createButton);
          await tester.tap(createButton);
          await tester.pump();
          await tester.pump(const Duration(seconds: 1));

          expect(find.text('Please fill all fields'), findsOneWidget);
        });

    testWidgets('shows password mismatch message',
            (WidgetTester tester) async {
          await setTestScreenSize(tester);

          await tester.pumpWidget(createTestWidget(const RegisterScreen()));
          await tester.pumpAndSettle();

          final fields = find.byType(TextField);
          expect(fields, findsNWidgets(4));

          await tester.enterText(fields.at(0), 'Test User');
          await tester.enterText(fields.at(1), 'test@test.com');
          await tester.enterText(fields.at(2), '12345678');
          await tester.enterText(fields.at(3), '87654321');

          final createButton = find.text('Create Account').last;

          await tester.ensureVisible(createButton);
          await tester.tap(createButton);
          await tester.pump();
          await tester.pump(const Duration(seconds: 1));

          expect(find.text('Passwords do not match'), findsOneWidget);
        });

    testWidgets('register password visibility icons toggle password fields',
            (WidgetTester tester) async {
          await setTestScreenSize(tester);

          await tester.pumpWidget(
            createTestWidget(const RegisterScreen()),
          );

          await tester.pumpAndSettle();

          final textFields = find.byType(TextField);

          expect(textFields, findsNWidgets(4));

          final passwordFieldBefore =
          tester.widget<TextField>(textFields.at(2));
          final confirmPasswordFieldBefore =
          tester.widget<TextField>(textFields.at(3));

          expect(passwordFieldBefore.obscureText, true);
          expect(confirmPasswordFieldBefore.obscureText, true);

          final eyeIcons = find.byIcon(Icons.visibility_outlined);

          expect(eyeIcons, findsNWidgets(2));

          await tester.tap(eyeIcons.at(0));
          await tester.pumpAndSettle();

          final passwordFieldAfter =
          tester.widget<TextField>(find.byType(TextField).at(2));

          expect(passwordFieldAfter.obscureText, false);

          await tester.tap(find.byIcon(Icons.visibility_outlined).first);
          await tester.pumpAndSettle();

          final confirmPasswordFieldAfter =
          tester.widget<TextField>(find.byType(TextField).at(3));

          expect(confirmPasswordFieldAfter.obscureText, false);

          expect(find.byIcon(Icons.visibility_off_outlined), findsNWidgets(2));
        });
  });
}