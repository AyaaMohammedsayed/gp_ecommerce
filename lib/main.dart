

import 'package:flutter/material.dart';
import 'package:gp_ecommerce/core/app_theme.dart';
import 'package:gp_ecommerce/features/Auth/view/screens/screen.dart';
import 'package:gp_ecommerce/features/Cart/view/screens/screen.dart';
import 'package:gp_ecommerce/features/Categories/view/screens/screen.dart';
import 'package:gp_ecommerce/features/Favorites/view/screens/screen.dart';
import 'package:gp_ecommerce/features/Home/view/screens/screen.dart';
import 'package:gp_ecommerce/features/Payment/view/screens/screen.dart';
import 'package:gp_ecommerce/features/product_details/view/screens/screen.dart';
import 'package:gp_ecommerce/features/profile/view/screens/screen.dart';
import 'package:gp_ecommerce/features/splash_screen/splash_screen.dart';

void main() {
  runApp(EcommerceApp());
}

class EcommerceApp extends StatelessWidget {
  const EcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
             SplashScreen.routeName: (_) => SplashScreen(),
             AuthScreen.routeName: (_) => AuthScreen(),
             CartScreen.routeName: (_) => CartScreen(),
             CategoriesScreen.routeName: (_) => CategoriesScreen(),
             FavoritesScreen.routeName: (_) => FavoritesScreen(),
             HomeScreen.routeName: (_) => HomeScreen(),
             PaymentScreen.routeName: (_) => PaymentScreen(),
             ProductDetailsScreen.routeName: (_) => ProductDetailsScreen(),
             ProfileScreen.routeName: (_) => ProfileScreen(),

      },
      initialRoute: SplashScreen.routeName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
    );
  }
}
