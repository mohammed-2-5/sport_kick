import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';
import 'package:spo_kick/core/widgets/premium/premium_text_field.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/register_cubit.dart';

class RegisterBody extends StatefulWidget {
  const RegisterBody({super.key});

  @override
  State<RegisterBody> createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<RegisterBody> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegisterPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.passwordsDoNotMatch)),
        );
        return;
      }

      context.read<AuthCubit>().register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: _fullNameController.text.trim(),
        phone: _phoneController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Full Name
                PremiumTextField(
                  label: context.l10n.fullName,
                  controller: _fullNameController,
                  prefixIcon: Icons.person_outline,
                  textInputAction: TextInputAction.next,
                  validator: (value) => value == null || value.isEmpty
                      ? context.l10n.fieldRequired
                      : null,
                ),
                const SizedBox(height: 20),

                // Email
                PremiumTextField(
                  label: context.l10n.email,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  textInputAction: TextInputAction.next,
                  validator: (value) => value == null || !value.contains('@')
                      ? context.l10n.invalidEmail
                      : null,
                ),
                const SizedBox(height: 20),

                // Phone
                PremiumTextField(
                  label: context.l10n.phone,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_outlined,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 20),

                // Password
                PremiumTextField(
                  label: context.l10n.password,
                  controller: _passwordController,
                  isPassword: true,
                  obscureText: !state.isPasswordVisible,
                  prefixIcon: Icons.lock_outline,
                  textInputAction: TextInputAction.next,
                  onTogglePassword: () =>
                      context.read<RegisterCubit>().togglePasswordVisibility(),
                  validator: (value) => value == null || value.length < 6
                      ? context.l10n.passwordRequirementText
                      : null,
                ),
                const SizedBox(height: 20),

                // Confirm Password
                PremiumTextField(
                  label: context.l10n.confirmPassword,
                  controller: _confirmPasswordController,
                  isPassword: true,
                  obscureText: !state.isConfirmPasswordVisible,
                  prefixIcon: Icons.lock_outline,
                  textInputAction: TextInputAction.done,
                  onTogglePassword: () => context
                      .read<RegisterCubit>()
                      .toggleConfirmPasswordVisibility(),
                  validator: (value) => value == null || value.isEmpty
                      ? context.l10n.pleaseConfirmPassword
                      : null,
                ),
                const SizedBox(height: 32),

                // Register Button
                PremiumButton(
                  label: context.l10n.createAccount,
                  onPressed: _onRegisterPressed,
                  icon: Icons.person_add,
                ),

                const SizedBox(height: 24),

                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.l10n.alreadyHaveAccount,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.pop(),
                      child: Text(
                        context.l10n.login,
                        style: AppTextStyles.labelLarge.copyWith(
                          fontWeight: FontWeight.bold,
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
}
