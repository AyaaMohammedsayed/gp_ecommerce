import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinetic/core/constants/app_colors.dart';
import 'package:kinetic/features/Auth/view_model/cubit.dart';
import '../../view_model/states.dart';
import '../widgets/auth_field.dart';
import '../widgets/label_text.dart';

class RegisterScreen extends StatefulWidget {
  static String routeName = '/register';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isPasswordHidden = true;
  bool isConfirmPasswordHidden = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthRegisterSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );

          Navigator.pop(context);
        }

        if (state is AuthRegisterError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
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
                  AuthField(
                    controller: nameController,
                    hint: 'Full name',
                    icon: Icons.person_outline,
                  ),

                  const SizedBox(height: 18),

                  const LabelText(text: 'EMAIL ADDRESS'),
                  const SizedBox(height: 8),
                  AuthField(
                    controller: emailController,
                    hint: 'name@company.com',
                    icon: Icons.mail_outline,
                  ),

                  const SizedBox(height: 18),

                  const LabelText(text: 'PASSWORD'),
                  const SizedBox(height: 8),
                  AuthField(
                    controller: passwordController,
                    hint: '••••••••',
                    icon: Icons.lock_outline,
                    suffixIcon: isPasswordHidden
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    obscureText: isPasswordHidden,
                    onSuffixTap: () {
                      setState(() {
                        isPasswordHidden = !isPasswordHidden;
                      });
                    },
                  ),

                  const SizedBox(height: 18),

                  const LabelText(text: 'CONFIRM PASSWORD'),
                  const SizedBox(height: 8),
                  AuthField(
                    controller: confirmPasswordController,
                    hint: '••••••••',
                    icon: Icons.lock_outline,
                    suffixIcon: isConfirmPasswordHidden
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    obscureText: isConfirmPasswordHidden,
                    onSuffixTap: () {
                      setState(() {
                        isConfirmPasswordHidden = !isConfirmPasswordHidden;
                      });
                    },
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
                      onPressed: state is AuthRegisterLoading
                          ? null
                          : () {
                        if (nameController.text.trim().isEmpty ||
                            emailController.text.trim().isEmpty ||
                            passwordController.text.trim().isEmpty ||
                            confirmPasswordController.text
                                .trim()
                                .isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill all fields'),
                            ),
                          );
                          return;
                        }

                        if (passwordController.text.trim() !=
                            confirmPasswordController.text.trim()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Passwords do not match'),
                            ),
                          );
                          return;
                        }

                        context.read<AuthCubit>().register(
                          name: nameController.text.trim(),
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
                      child: state is AuthRegisterLoading
                          ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.background,
                        ),
                      )
                          : Text(
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
                      children: [
                        const TextSpan(
                          text: 'Already have an account? ',
                        ),
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
      },
    );
  }
}