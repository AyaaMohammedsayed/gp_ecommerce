import 'package:flutter/material.dart';
import 'package:gp_ecommerce/core/constants/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../onboarding_screen/onboarding_screen.dart';
import 'package:gp_ecommerce/features/Auth/view/screens/auth_screen.dart';
import 'package:gp_ecommerce/features/Home/view/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = '/splash';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _controller.forward();
    _checkNavigation();
  }

  Future<void> _checkNavigation() async {
    final prefs = await SharedPreferences.getInstance();

    final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
    final token = prefs.getString('token');

    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;

    if (!hasSeenOnboarding) {
      Navigator.pushReplacementNamed(context,OnboardingScreen.routeName);
    } else if (token != null && token.isNotEmpty) {
      Navigator.pushReplacementNamed(context,HomeScreen.routeName);
    } else {
      Navigator.pushReplacementNamed(context,AuthScreen.routeName);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Image.asset(
              'assets/icon/app_icon.png',
              width: 130,
              height: 130,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}