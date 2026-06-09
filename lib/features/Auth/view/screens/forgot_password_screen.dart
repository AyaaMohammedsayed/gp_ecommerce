import 'package:flutter/material.dart';
import 'package:gp_ecommerce/core/constants/app_colors.dart';
import '../widgets/auth_field.dart';
import '../widgets/label_text.dart';
import 'package:flutter/gestures.dart';


class ForgotPasswordScreen extends StatelessWidget {
  static String routeName = '/forgot-password';

  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            children: [
              const SizedBox(height: 18),

              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: AppColors.logo,
                    size: 20,
                  ),
                ),
              ),

              const SizedBox(height: 80),

              Text(
                'Forgot Password?',
                style: textTheme.displayLarge?.copyWith(
                  color: AppColors.logo,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'Enter your email address and we will send\nyou a reset password link.',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textLight,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 42),

              const LabelText(text: 'EMAIL ADDRESS'),

              const SizedBox(height: 8),

              const AuthField(
                hint: 'name@company.com',
                icon: Icons.mail_outline,
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
                    'Send Reset Link',
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
                  text: 'Back to Sign In',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.logo,
                    fontWeight: FontWeight.w700,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pop(context);
                    },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}