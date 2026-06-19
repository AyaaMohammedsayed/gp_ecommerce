import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gp_ecommerce/features/Cart/view/screens/cart_screen.dart';
import 'package:gp_ecommerce/features/Categories/data/api_service/api_service.dart';
import 'package:gp_ecommerce/features/Categories/view/screens/category_detials_screen.dart';
import 'package:gp_ecommerce/features/Categories/view/screens/category_screen.dart';
import 'package:gp_ecommerce/features/Categories/view_model/category_cubit.dart';
import 'package:gp_ecommerce/features/Home/view/screens/home_screen.dart';
import 'package:gp_ecommerce/features/payment/view/screens/payment_screen.dart';
import 'package:gp_ecommerce/features/product_details/data/api_service.dart';
import 'package:gp_ecommerce/features/product_details/view/screens/product_details.dart';
import 'package:gp_ecommerce/features/product_details/view_model/product_cubit.dart';

import 'core/constants/app_theme.dart';
import 'features/Auth/view/screens/auth_screen.dart';
import 'features/Auth/view/screens/forgot_password_screen.dart';
import 'features/Auth/view/screens/register_screen.dart';
import 'features/onboarding_screen/onboarding_screen.dart';
import 'features/splash_screen/splash_screen.dart';
import 'features/Home/view_model/home_cubit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
        return MultiBlocProvider(
      providers: [
    BlocProvider(
      create: (_) => HomeCubit(),
    ),
    BlocProvider(
      create: (_) => CategoriesCubit(
   
      ),
    ),
    BlocProvider(
      create: (_) => ProductsCubit(
   
      ),
    ),
  ],
          child: MaterialApp(
            title: 'Kinetic - Electronics Store',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            home: const HomeScreen(),
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
          ),
        );
      },
    );
  }
}
