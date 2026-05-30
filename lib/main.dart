import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/app_theme.dart';
import 'features/onboarding_screen/onboarding_screen.dart';
import 'features/splash_screen/splash_screen.dart';
import 'features/Auth/view/screens/auth_screen.dart';
import 'features/Auth/view/screens/forgot_password_screen.dart';
import 'features/Auth/view/screens/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'E-Commerce App',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          initialRoute: SplashScreen.routeName,
          routes: {
            SplashScreen.routeName: (context) => const SplashScreen(),
            OnboardingScreen.routeName: (context) => const OnboardingScreen(),
            AuthScreen.routeName: (context) => const AuthScreen(),
            RegisterScreen.routeName: (context) => const RegisterScreen(),
            ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
          },
        );
      },
    );
  }
}