import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';
import 'package:spo_kick/core/widgets/premium/premium_text_field.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/login_cubit.dart';

/// Login Body Widget
///
/// Contains the form logic and UI interactions for login.
class LoginBody extends StatefulWidget {
  const LoginBody({super.key});

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Login Mode Switcher (User / Admin)
                _buildModeSwitcher(context, state.loginMode),
                const SizedBox(height: 32),

                // Email
                PremiumTextField(
                  label: context.l10n.email,
                  hintText: context.l10n.enterYourEmail,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  textInputAction: TextInputAction.next,
                  errorText: !state.isEmailValid
                      ? context.l10n.invalidEmail
                      : null,
                ),
                const SizedBox(height: 20),

                // Password
                PremiumTextField(
                  label: context.l10n.password,
                  hintText: context.l10n.enterPassword,
                  controller: _passwordController,
                  isPassword: true,
                  obscureText: !state.isPasswordVisible,
                  prefixIcon: Icons.lock_outline,
                  textInputAction: TextInputAction.done,
                  onTogglePassword: () =>
                      context.read<LoginCubit>().togglePasswordVisibility(),
                ),
                const SizedBox(height: 12),

                // Forgot Password & Remember Me
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: state.rememberMe,
                          activeColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          onChanged: (_) =>
                              context.read<LoginCubit>().toggleRememberMe(),
                        ),
                        Text(
                          context.l10n.rememberMe,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        context.pushNamed('forgot-password');
                      },
                      child: Text(
                        context.l10n.forgotPassword,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Login Button
                PremiumButton(
                  label: context.l10n.login,
                  onPressed: () => _onLoginPressed(context),
                  icon: Icons.login,
                ),

                const SizedBox(height: 24),

                // Divider
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        context.l10n.or,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: 24),

                // Register Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.l10n.dontHaveAccount,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 15,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.pushNamed('register'),
                      child: Text(
                        context.l10n.signUp,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildModeSwitcher(BuildContext context, String currentMode) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          _buildModeOption(
            context,
            label: context.l10n.user,
            isSelected: currentMode == 'user',
            onTap: () => context.read<LoginCubit>().changeLoginMode('user'),
          ),
          _buildModeOption(
            context,
            label: context.l10n.fieldOwner,
            isSelected: currentMode == 'admin',
            onTap: () => context.read<LoginCubit>().changeLoginMode('admin'),
          ),
        ],
      ),
    );
  }

  Widget _buildModeOption(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
