import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/register_cubit.dart';
import 'package:spo_kick/features/auth/presentation/widgets/premium/password_strength_indicator.dart';
import 'package:spo_kick/features/auth/presentation/widgets/premium/premium_auth_text_field.dart';
import 'package:spo_kick/features/auth/presentation/widgets/premium/premium_social_buttons.dart';

/// Premium register form with glassmorphism styling.
///
/// Features:
/// - Glass text fields
/// - Password strength indicator
/// - Terms checkbox
/// - Social registration buttons
/// - Responsive layout
class PremiumRegisterForm extends StatefulWidget {
  const PremiumRegisterForm({super.key});

  @override
  State<PremiumRegisterForm> createState() => _PremiumRegisterFormState();
}

class _PremiumRegisterFormState extends State<PremiumRegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _acceptedTerms = false;
  String _currentPassword = '';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the Terms & Conditions'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().register(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        phone: _phoneController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Full Name
              PremiumAuthTextField(
                label: 'Full Name',
                hintText: 'Enter your full name',
                controller: _nameController,
                prefixIcon: Icons.person_outline,
                textInputAction: TextInputAction.next,
                isDark: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required';
                  }
                  if (value.length < 2) {
                    return 'Name is too short';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 18),

              // Email
              PremiumAuthTextField(
                label: 'Email',
                hintText: 'example@email.com',
                controller: _emailController,
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                isDark: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 18),

              // Phone
              PremiumAuthTextField(
                label: 'Phone Number',
                hintText: '01XXXXXXXXX',
                controller: _phoneController,
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                isDark: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone number is required';
                  }
                  if (value.length < 10) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 18),

              // Password
              PremiumAuthTextField(
                label: 'Password',
                hintText: 'Create a strong password',
                controller: _passwordController,
                isPassword: true,
                obscureText: !state.isPasswordVisible,
                onTogglePassword: () {
                  context.read<RegisterCubit>().togglePasswordVisibility();
                },
                prefixIcon: Icons.lock_outline,
                textInputAction: TextInputAction.next,
                isDark: true,
                onChanged: (value) {
                  setState(() {
                    _currentPassword = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
              ),

              // Password strength indicator
              if (_currentPassword.isNotEmpty) ...[
                const SizedBox(height: 12),
                PasswordStrengthIndicator(
                  password: _currentPassword,
                  showRequirements: true,
                ),
              ],

              const SizedBox(height: 18),

              // Confirm Password
              PremiumAuthTextField(
                label: 'Confirm Password',
                hintText: 'Re-enter your password',
                controller: _confirmPasswordController,
                isPassword: true,
                obscureText: !state.isConfirmPasswordVisible,
                onTogglePassword: () {
                  context
                      .read<RegisterCubit>()
                      .toggleConfirmPasswordVisibility();
                },
                prefixIcon: Icons.lock_outline,
                textInputAction: TextInputAction.done,
                isDark: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Terms checkbox
              GestureDetector(
                onTap: () {
                  setState(() {
                    _acceptedTerms = !_acceptedTerms;
                  });
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 22,
                      height: 22,
                      margin: const EdgeInsets.only(top: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: _acceptedTerms
                            ? AppColors.accentCyan
                            : Colors.transparent,
                        border: Border.all(
                          color: _acceptedTerms
                              ? AppColors.accentCyan
                              : Colors.white.withValues(alpha: 0.4),
                          width: 2,
                        ),
                      ),
                      child: _acceptedTerms
                          ? const Icon(
                              Icons.check,
                              size: 14,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: 'I agree to the ',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                          children: const [
                            TextSpan(
                              text: 'Terms of Service',
                              style: TextStyle(
                                color: AppColors.accentCyan,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                color: AppColors.accentCyan,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Register button
              PremiumButton(
                label: 'Create Account',
                onPressed: _onRegister,
                icon: Icons.person_add_outlined,
                fullWidth: true,
              ),

              const SizedBox(height: 24),

              // Social registration
              PremiumSocialButtons(
                onGooglePressed: () {
                  // TODO: Implement Google registration
                },
                onFacebookPressed: () {
                  // TODO: Implement Facebook registration
                },
              ),

              const SizedBox(height: 24),

              // Login link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accentCyan,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
