import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gp_ecommerce/core/constants/app_theme.dart';
import 'package:gp_ecommerce/core/constants/dio_helper.dart';
import 'package:gp_ecommerce/core/auth_local_storage.dart';
import 'package:gp_ecommerce/features/Auth/view/screens/auth_screen.dart';
import 'package:gp_ecommerce/features/Auth/view/screens/register_screen.dart';
import 'package:gp_ecommerce/features/Auth/view_model/cubit.dart';
import 'package:gp_ecommerce/features/Home/view_model/home_cubit.dart';
import 'package:gp_ecommerce/features/product_details/view_model/product_cubit.dart';
import 'package:gp_ecommerce/features/profile/data/data.dart';
import 'package:gp_ecommerce/features/profile/view/screens/screen.dart';
import 'package:gp_ecommerce/features/profile/view_model/cubit.dart';
import 'features/onboarding_screen/onboarding_screen.dart';
import 'features/splash_screen/splash_screen.dart';
import 'package:gp_ecommerce/features/Cart/view/screens/cart_screen.dart';
import 'package:gp_ecommerce/features/Categories/view/screens/category_detials_screen.dart';
import 'package:gp_ecommerce/features/Categories/view/screens/category_screen.dart';
import 'package:gp_ecommerce/features/Categories/view_model/category_cubit.dart';
import 'package:gp_ecommerce/features/Home/view/screens/home_screen.dart';
import 'package:gp_ecommerce/features/payment/view/screens/payment_screen.dart';
import 'package:gp_ecommerce/features/product_details/view/screens/product_details.dart';
import 'package:gp_ecommerce/features/Cart/view_model/cubit.dart';
import 'package:gp_ecommerce/features/Favorites/view_model/cubit.dart';
import 'package:gp_ecommerce/features/Favorites/view/screens/screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  await AuthLocalStorage.init();
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
            BlocProvider(create: (_) => HomeCubit()),
            BlocProvider(create: (_) => AuthCubit()),
            BlocProvider(create: (_) => CategoriesCubit()),
            BlocProvider(create: (_) => ProductsCubit()),
            BlocProvider(create: (_) => CartCubit()),
            BlocProvider(create: (_) => FavoritesCubit()),
            BlocProvider(create: (_) => ProfileCubit(ProfileRepositoryImpl())),
          ],
          child: MaterialApp(
            title: 'Kinetic - Electronics Store',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            initialRoute: SplashScreen.routeName,
            routes: {
              SplashScreen.routeName: (context) => const SplashScreen(),
              OnboardingScreen.routeName: (context) => const OnboardingScreen(),
              AuthScreen.routeName: (context) => const AuthScreen(),
              RegisterScreen.routeName: (context) => const RegisterScreen(),
              CartScreen.routeName: (context) => const CartScreen(),
              HomeScreen.routeName: (context) => const HomeScreen(),
              FavoritesScreen.routeName: (context) => const FavoritesScreen(),
              PaymentScreen.routeName: (context) => const PaymentScreen(),
              CategoriesScreen.routeName: (context) => const CategoriesScreen(),
              ProductDetailsScreen.routeName: (context) =>
                  ProductDetailsScreen(),
              CategoryDetialsScreen.routeName: (context) =>
                  CategoryDetialsScreen(),
              ProfileScreen.routeName: (context) => const ProfileScreen(),
            },
          ),
        );
      },
    );
  }
}
