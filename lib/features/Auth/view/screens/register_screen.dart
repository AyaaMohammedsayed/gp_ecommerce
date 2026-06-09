import 'package:flutter/material.dart';
import 'package:gp_ecommerce/core/constants/app_colors.dart';
import '../widgets/auth_field.dart';
import '../widgets/label_text.dart';
import 'package:flutter/gestures.dart';

class RegisterScreen extends StatelessWidget {
  static String routeName = '/register';

  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            children: [
              const SizedBox(height: 18),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'KINETIC',
                    style: textTheme.displayLarge?.copyWith(
                      color: AppColors.logo,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Help',
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.textLight,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 42),

              Text(
                'Create Account',
                style: textTheme.displayLarge?.copyWith(
                  color: AppColors.logo,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Join Kinetic and start exploring.',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textLight,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 34),

              const LabelText(text: 'FULL NAME'),
              const SizedBox(height: 8),
              const AuthField(
                hint: 'Full name',
                icon: Icons.person_outline,
              ),

              const SizedBox(height: 18),

              const LabelText(text: 'EMAIL ADDRESS'),
              const SizedBox(height: 8),
              const AuthField(
                hint: 'name@company.com',
                icon: Icons.mail_outline,
              ),

              const SizedBox(height: 18),

              const LabelText(text: 'PASSWORD'),
              const SizedBox(height: 8),
              const AuthField(
                hint: '••••••••',
                icon: Icons.lock_outline,
                suffixIcon: Icons.visibility_outlined,
                obscureText: true,
              ),

              const SizedBox(height: 18),

              const LabelText(text: 'CONFIRM PASSWORD'),
              const SizedBox(height: 8),
              const AuthField(
                hint: '••••••••',
                icon: Icons.lock_outline,
                suffixIcon: Icons.visibility_outlined,
                obscureText: true,
              ),

              const SizedBox(height: 34),

              Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.logo,
                      AppColors.primary,
                    ],
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35),
                    ),
                  ),
                  child: Text(
                    'Create Account',
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppColors.background,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              RichText(
                text: TextSpan(
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textLight,
                    fontSize: 12,
                  ),
                  children:[
                    TextSpan(text: 'Already have an account? '),
                    TextSpan(
                      text: 'Sign in',
                      style: const TextStyle(
                        color: AppColors.logo,
                        fontWeight: FontWeight.w700,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pop(context);
                        },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}