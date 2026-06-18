import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gp_ecommerce/core/constants/app_colors.dart';
import 'package:gp_ecommerce/features/Auth/view_model/cubit.dart';
import '../../view_model/states.dart';
import '../widgets/auth_field.dart';
import '../widgets/footer_text.dart';
import '../widgets/label_text.dart';
import 'package:flutter/gestures.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';


class AuthScreen extends StatefulWidget {
  static String routeName = '/auth';

  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoginSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          print("Login Success");

          /*Navigator.pushReplacementNamed(
            context,
            '/home',
          );*/
        }

        if (state is AuthLoginError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Padding(
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

                  const SizedBox(height: 80),

                  Text(
                    'WELCOME',
                    style: textTheme.displayLarge?.copyWith(
                      color: AppColors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Sign in to your professional account.',
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.textLight,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 38),

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/auth_images/google.png',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/auth_images/apple.png',
                              width: 30,
                              height: 30,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  Row(
                    children: [
                      const Expanded(
                          child: Divider(
                            color: AppColors.surface,
                            thickness: 2,
                          )
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Text(
                          'OR CONTINUE WITH',
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.textLight,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const Expanded(
                          child: Divider(
                            color: AppColors.surface,
                            thickness: 2,
                          )
                      ),
                    ],
                  ),

                  const SizedBox(height: 26),

                  const LabelText(text: 'EMAIL ADDRESS'),

                  const SizedBox(height: 8),

                  AuthField(
                    controller: emailController,
                    hint: 'name@company.com',
                    icon: Icons.mail_outline,
                  ),

                  const SizedBox(height: 18),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const LabelText(text: 'PASSWORD'),
                      RichText(
                        text: TextSpan(
                          text: 'Forgot?',
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.logo,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(
                                context,
                                ForgotPasswordScreen.routeName,
                              );
                            },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  AuthField(
                    controller: passwordController,
                    hint: '••••••••',
                    icon: Icons.lock_outline,
                    suffixIcon: Icons.visibility_outlined,
                    obscureText: true,
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Container(
                        width: 17,
                        height: 17,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Remember this device for 30 days',
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.textLight,
                          fontSize: 12,
                        ),
                      ),
                    ],
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
                      onPressed: state is AuthLoginLoading
                          ? null
                          : () {
                        if (emailController.text.trim().isEmpty ||
                            passwordController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter email and password!'),
                            ),
                          );
                          return;
                        }

                        context.read<AuthCubit>().login(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35),
                        ),
                      ),
                      child: state is AuthLoginLoading
                          ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.background,
                        ),
                      )
                          : Text(
                        'Sign In to Kinetic',
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
                      children: [
                        const TextSpan(
                          text: "Don't have an account? ",
                        ),
                        TextSpan(
                          text: 'Create account',
                          style: const TextStyle(
                            color: AppColors.logo,
                            fontWeight: FontWeight.w700,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(
                                context,
                                RegisterScreen.routeName,
                              );
                            },
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  const Padding(
                    padding: EdgeInsets.only(bottom: 26),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        FooterText(text: 'Terms of Service'),
                        FooterText(text: 'Privacy Policy'),
                        FooterText(text: 'Contact Support'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}