import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gp_ecommerce/features/Cart/view/screens/cart_screen.dart';
import 'package:gp_ecommerce/features/Categories/view/screens/category_detials_screen.dart';
import 'package:gp_ecommerce/features/Categories/view/screens/category_screen.dart';
import 'package:gp_ecommerce/features/Home/view/screens/home_screen.dart';
import 'package:gp_ecommerce/features/payment/view/screens/payment_screen.dart';
import 'package:gp_ecommerce/features/product_details/view/screens/product_details.dart';

import 'core/constants/app_theme.dart';
import 'features/Auth/view/screens/auth_screen.dart';
import 'features/Auth/view/screens/forgot_password_screen.dart';
import 'features/Auth/view/screens/register_screen.dart';
import 'features/onboarding_screen/onboarding_screen.dart';
import 'features/splash_screen/splash_screen.dart';

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
          initialRoute: CategoriesScreen.routeName,
          routes: {
            SplashScreen.routeName: (context) => const SplashScreen(),
            OnboardingScreen.routeName: (context) => const OnboardingScreen(),
            AuthScreen.routeName: (context) => const AuthScreen(),
            RegisterScreen.routeName: (context) => const RegisterScreen(),
            CartScreen.routeName: (context) => const CartScreen(),
            ForgotPasswordScreen.routeName: (context) =>
                const ForgotPasswordScreen(),
            HomeScreen.routeName: (context) => const HomeScreen(),
            PaymentScreen.routeName: (context) => const PaymentScreen(),
            CategoriesScreen.routeName: (context) => const CategoriesScreen(),
            ProductDetailsScreen.routeName: (context) => ProductDetailsScreen(),
            CategoryDetialsScreen.routeName: (context) =>
                CategoryDetialsScreen(),
          },
        );
      },
    );
  }
}
