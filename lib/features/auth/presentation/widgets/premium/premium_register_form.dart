import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/register_cubit.dart';
import 'package:spo_kick/features/auth/presentation/widgets/premium/password_strength_indicator.dart';
import 'package:spo_kick/features/auth/presentation/widgets/premium/premium_auth_text_field.dart';
import 'package:spo_kick/features/auth/presentation/widgets/premium/premium_social_buttons.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
              _NameField(controller: _nameController),
              const SizedBox(height: 18),
              _EmailField(controller: _emailController),
              const SizedBox(height: 18),
              _PhoneField(controller: _phoneController),
              const SizedBox(height: 18),
              _PasswordField(
                controller: _passwordController,
                isVisible: state.isPasswordVisible,
              ),
              if (state.password.isNotEmpty) ...[
                const SizedBox(height: 12),
                PasswordStrengthIndicator(
                  password: state.password,
                  showRequirements: true,
                ),
              ],
              const SizedBox(height: 18),
              _ConfirmPasswordField(
                controller: _confirmPasswordController,
                passwordController: _passwordController,
                isVisible: state.isConfirmPasswordVisible,
              ),
              const SizedBox(height: 20),
              _TermsCheckbox(isAccepted: state.acceptedTerms),
              const SizedBox(height: 28),
              _RegisterButton(
                formKey: _formKey,
                nameController: _nameController,
                emailController: _emailController,
                phoneController: _phoneController,
                passwordController: _passwordController,
                acceptedTerms: state.acceptedTerms,
              ),
              const SizedBox(height: 24),
              PremiumSocialButtons(
                onGooglePressed: () {
                  // TODO: Implement Google registration
                },
                onFacebookPressed: () {
                  // TODO: Implement Facebook registration
                },
              ),
              const SizedBox(height: 24),
              const _LoginLink(),
            ],
          ),
        );
      },
    );
  }
}

class _NameField extends StatelessWidget {
  final TextEditingController controller;

  const _NameField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return PremiumAuthTextField(
      label: context.l10n.fullName,
      hintText: context.l10n.enterYourFullName,
      controller: controller,
      prefixIcon: Icons.person_outline,
      textInputAction: TextInputAction.next,
      isDark: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return context.l10n.nameIsRequired;
        }
        if (value.length < 2) {
          return context.l10n.nameIsTooShort;
        }
        return null;
      },
    );
  }
}

class _EmailField extends StatelessWidget {
  final TextEditingController controller;

  const _EmailField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return PremiumAuthTextField(
      label: context.l10n.email,
      hintText: context.l10n.exampleEmailCom,
      controller: controller,
      prefixIcon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      isDark: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return context.l10n.emailIsRequired;
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return context.l10n.pleaseEnterAValidEmail;
        }
        return null;
      },
    );
  }
}

class _PhoneField extends StatelessWidget {
  final TextEditingController controller;

  const _PhoneField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return PremiumAuthTextField(
      label: context.l10n.phone,
      hintText: context.l10n.phoneHint,
      controller: controller,
      prefixIcon: Icons.phone_outlined,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      isDark: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return context.l10n.phoneNumberIsRequired;
        }
        if (value.length < 10) {
          return context.l10n.pleaseEnterAValidPhoneNumber;
        }
        return null;
      },
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool isVisible;

  const _PasswordField({required this.controller, required this.isVisible});

  @override
  Widget build(BuildContext context) {
    return PremiumAuthTextField(
      label: context.l10n.password,
      hintText: context.l10n.createAStrongPassword,
      controller: controller,
      isPassword: true,
      obscureText: !isVisible,
      onTogglePassword: () =>
          context.read<RegisterCubit>().togglePasswordVisibility(),
      prefixIcon: Icons.lock_outline,
      textInputAction: TextInputAction.next,
      isDark: true,
      onChanged: (value) => context.read<RegisterCubit>().updatePassword(value),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return context.l10n.passwordIsRequired;
        }
        if (value.length < 8) {
          return context.l10n.passwordMustBeAtLeast8Characters;
        }
        return null;
      },
    );
  }
}

class _ConfirmPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final TextEditingController passwordController;
  final bool isVisible;

  const _ConfirmPasswordField({
    required this.controller,
    required this.passwordController,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumAuthTextField(
      label: context.l10n.confirmPassword,
      hintText: context.l10n.reenterPassword,
      controller: controller,
      isPassword: true,
      obscureText: !isVisible,
      onTogglePassword: () =>
          context.read<RegisterCubit>().toggleConfirmPasswordVisibility(),
      prefixIcon: Icons.lock_outline,
      textInputAction: TextInputAction.done,
      isDark: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return context.l10n.pleaseConfirmYourPassword;
        }
        if (value != passwordController.text) {
          return context.l10n.passwordsDoNotMatch;
        }
        return null;
      },
    );
  }
}

class _TermsCheckbox extends StatelessWidget {
  final bool isAccepted;

  const _TermsCheckbox({required this.isAccepted});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<RegisterCubit>().toggleTermsAccepted(),
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
              color: isAccepted ? AppColors.accentCyan : Colors.transparent,
              border: Border.all(
                color: isAccepted
                    ? AppColors.accentCyan
                    : Colors.white.withValues(alpha: 0.4),
                width: 2,
              ),
            ),
            child: isAccepted
                ? const Icon(Icons.check, size: 14, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text.rich(
              TextSpan(
                text: context.l10n.iAgreeToThe,
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                ),
                children: [
                  TextSpan(
                    text: context.l10n.termsOfService,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.accentCyan,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(text: context.l10n.and),
                  TextSpan(
                    text: context.l10n.privacyPolicy,
                    style: AppTextStyles.labelSmall.copyWith(
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
    );
  }
}

class _RegisterButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final bool acceptedTerms;

  const _RegisterButton({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.acceptedTerms,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumButton(
      label: context.l10n.createAccount,
      onPressed: () {
        if (!acceptedTerms) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.pleaseAcceptTheTermsAndConditions),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
          return;
        }
        if (formKey.currentState?.validate() ?? false) {
          context.read<AuthCubit>().register(
            fullName: nameController.text.trim(),
            email: emailController.text.trim(),
            password: passwordController.text,
            phone: phoneController.text.trim(),
          );
        }
      },
      icon: Icons.person_add_outlined,
      fullWidth: true,
    );
  }
}

class _LoginLink extends StatelessWidget {
  const _LoginLink();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.l10n.alreadyHaveAnAccount,
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
        GestureDetector(
          onTap: () => context.pop(),
          child: Text(
            context.l10n.signIn,
            style: AppTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.accentCyan,
            ),
          ),
        ),
      ],
    );
  }
}
