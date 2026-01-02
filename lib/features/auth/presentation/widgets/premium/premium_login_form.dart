import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/login_cubit.dart';
import 'package:spo_kick/features/auth/presentation/widgets/premium/premium_auth_text_field.dart';
import 'package:spo_kick/features/auth/presentation/widgets/premium/premium_mode_switcher.dart';
import 'package:spo_kick/features/auth/presentation/widgets/premium/premium_social_buttons.dart';

/// Premium login form with glassmorphism styling.
///
/// Features:
/// - Mode switcher (User/Admin)
/// - Glass text fields
/// - Remember me checkbox
/// - Social login buttons
/// - Responsive layout
class PremiumLoginForm extends StatefulWidget {
  const PremiumLoginForm({super.key});

  @override
  State<PremiumLoginForm> createState() => _PremiumLoginFormState();
}

class _PremiumLoginFormState extends State<PremiumLoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
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
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Mode Switcher
              PremiumModeSwitcher(
                currentMode: state.loginMode,
                onModeChanged: (mode) {
                  context.read<LoginCubit>().changeLoginMode(mode);
                },
              ),

              const SizedBox(height: 28),

              // Email field
              PremiumAuthTextField(
                label: context.l10n.email,
                hintText: context.l10n.enterYourEmail,
                controller: _emailController,
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                isDark: true,
                errorText:
                    !state.isEmailValid && _emailController.text.isNotEmpty
                    ? context.l10n.enterValidEmail
                    : null,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.l10n.fieldRequired;
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Password field
              PremiumAuthTextField(
                label: context.l10n.password,
                hintText: context.l10n.enterPassword,
                controller: _passwordController,
                isPassword: true,
                obscureText: !state.isPasswordVisible,
                onTogglePassword: () {
                  context.read<LoginCubit>().togglePasswordVisibility();
                },
                prefixIcon: Icons.lock_outline,
                textInputAction: TextInputAction.done,
                isDark: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.l10n.fieldRequired;
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Remember me & Forgot password
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Remember me
                  GestureDetector(
                    onTap: () => context.read<LoginCubit>().toggleRememberMe(),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: state.rememberMe
                                ? Theme.of(context).colorScheme.secondary
                                : Colors.transparent,
                            border: Border.all(
                              color: state.rememberMe
                                  ? Theme.of(context).colorScheme.secondary
                                  : Colors.white.withValues(alpha: 0.4),
                              width: 2,
                            ),
                          ),
                          child: state.rememberMe
                              ? const Icon(
                                  Icons.check,
                                  size: 14,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          context.l10n.rememberMe,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Forgot password
                  GestureDetector(
                    onTap: () => context.pushNamed('forgot-password'),
                    child: Text(
                      context.l10n.forgotPassword,
                      style: AppTextStyles.labelMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.accentCyan,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Login button
              PremiumButton(
                label: context.l10n.signIn,
                onPressed: _onLogin,
                icon: Icons.login,
                fullWidth: true,
              ),

              const SizedBox(height: 28),

              // Social login
              PremiumSocialButtons(
                onGooglePressed: () {
                  // TODO: Implement Google login
                },
                onFacebookPressed: () {
                  // TODO: Implement Facebook login
                },
              ),

              const SizedBox(height: 28),

              // Register link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${context.l10n.dontHaveAccount} ',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.pushNamed('register'),
                    child: Text(
                      context.l10n.signUp,
                      style: AppTextStyles.labelLarge.copyWith(
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
