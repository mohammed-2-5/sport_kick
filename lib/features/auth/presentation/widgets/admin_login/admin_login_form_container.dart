import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/auth/presentation/cubit/admin_login_cubit.dart';
import 'package:spo_kick/features/auth/presentation/widgets/admin_login/admin_login_form_field.dart';
import 'package:spo_kick/features/auth/presentation/widgets/admin_login/admin_login_button.dart';

/// Admin login form container with glassmorphism
class AdminLoginFormContainer extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final VoidCallback onSubmit;

  const AdminLoginFormContainer({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AdminLoginFormField(
            label: l10n.email,
            hint: l10n.enterYourEmail,
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
          ),
          const SizedBox(height: 20),
          BlocBuilder<AdminLoginCubit, AdminLoginState>(
            builder: (context, state) {
              return AdminLoginFormField(
                label: l10n.password,
                hint: l10n.enterPassword,
                controller: passwordController,
                obscureText: !state.isPasswordVisible,
                prefixIcon: Icons.lock_outline,
                suffixIcon: IconButton(
                  icon: Icon(
                    state.isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.white.withValues(alpha: 0.7),
                    size: 20,
                  ),
                  onPressed: () => context
                      .read<AdminLoginCubit>()
                      .togglePasswordVisibility(),
                ),
              );
            },
          ),
          const SizedBox(height: 28),
          AdminLoginButton(isLoading: isLoading, onPressed: onSubmit),
        ],
      ),
    );
  }
}
