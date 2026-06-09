import 'package:flutter/material.dart';
import 'package:gp_ecommerce/core/app_colors.dart';

import '../Auth/view/screens/auth_screen.dart';

class OnboardingScreen extends StatelessWidget {
  static String routeName = '/onboarding';

  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.surfaceVariant,
              AppColors.background,
              AppColors.background,
              AppColors.surfaceVariant,
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 30,
              right: -50,
              child: Opacity(
                opacity: 0.3,
                child: Transform.rotate(
                  angle: 0.2,
                  child: Image.asset(
                    'assets/onboarding_images/watch.png',
                    width: 180,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'KINETIC',
                          style: textTheme.displayLarge?.copyWith(
                            color: AppColors.logo,
                            fontSize: 43,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -2,
                          ),
                        ),
                        Text(
                          '.',
                          style: textTheme.displayLarge?.copyWith(
                            color: AppColors.primary,
                            fontSize: 43,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 24,
                          child: Divider(
                            color: AppColors.surfaceVariant,
                            thickness: 1,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'INDUSTRIAL ART',
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.textLight,
                            fontSize: 12,
                            letterSpacing: 5,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const SizedBox(
                          width: 24,
                          child: Divider(
                            color: AppColors.surfaceVariant,
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    Text(
                      'Welcome to the\nKinetic Gallery.',
                      textAlign: TextAlign.center,
                      style: textTheme.displayLarge?.copyWith(
                        color: AppColors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: 18),

                    Text(
                      'Experience the precision of high-end\nindustrial design and the pulse of\nnext-generation technology.',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.textLight,
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 52),

                    Container(
                      width: 200,
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xFFB8C8FF),
                            AppColors.primary,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.25),
                            blurRadius: 20,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(40),
                          onTap: () {
                            Navigator.pushNamed(context, AuthScreen.routeName);
                          },
                          child: Center(
                            child: Text(
                              'ENTER SHOWROOM',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppColors.background,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.8,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 14,
                          backgroundColor: AppColors.logo,
                          child: Icon(
                            Icons.person,
                            size: 20,
                            color: AppColors.background,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const CircleAvatar(
                          radius: 14,
                          backgroundColor: AppColors.surfaceVariant,
                          child: Icon(
                            Icons.person,
                            size: 20,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(width: 2),
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.surfaceVariant,
                          child: Text(
                            '+2k',
                            style: textTheme.bodyMedium?.copyWith(
                              color: AppColors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'JOIN THE INNER CIRCLE',
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.textLight,
                            fontSize: 13,
                            letterSpacing: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}