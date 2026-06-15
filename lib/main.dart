import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/app_theme.dart';
import 'features/Home/cubit/home_cubit.dart';
import 'features/Home/home_screen.dart';

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
          providers: [BlocProvider(create: (context) => HomeCubit())],
          child: MaterialApp(
            title: 'Kinetic - Electronics Store',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            home: const HomeScreen(),
          ),
        );
      },
    );
  }
}
