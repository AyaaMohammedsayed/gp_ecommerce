import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gp_ecommerce/features/Home/view/screens/home_screen.dart';
import 'package:gp_ecommerce/features/Home/view_model/home_cubit.dart';
import 'core/app_theme.dart';


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
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => HomeCubit()),
          ],
          child: MaterialApp(
            title: 'E-Commerce App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            home: const HomeScreen(),
          ),
        );
      },
    );
  }
}
