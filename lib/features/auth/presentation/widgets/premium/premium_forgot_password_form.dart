import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/widgets/premium/premium_auth_text_field.dart';

/// Premium forgot password form.
///
/// Features:
/// - Glass text field
/// - Animated success state
/// - Responsive layout
class PremiumForgotPasswordForm extends StatefulWidget {
  final VoidCallback onSuccess;

  const PremiumForgotPasswordForm({super.key, required this.onSuccess});

  @override
  State<PremiumForgotPasswordForm> createState() =>
      _PremiumForgotPasswordFormState();
}

class _PremiumForgotPasswordFormState extends State<PremiumForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().resetPassword(_emailController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Info text
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.accentCyan.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.accentCyan.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppColors.accentCyan,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    context.l10n.resetPasswordSubtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.8),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // Email field
          PremiumAuthTextField(
            label: context.l10n.emailAddress,
            hintText: context.l10n.enterYourEmail,
            controller: _emailController,
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            isDark: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.l10n.fieldRequired;
              }
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value)) {
                return context.l10n.enterValidEmail;
              }
              return null;
            },
          ),

          const SizedBox(height: 32),

          // Submit button
          PremiumButton(
            label: context.l10n.sendResetLink,
            onPressed: _onSubmit,
            icon: Icons.send,
            fullWidth: true,
          ),

          const SizedBox(height: 24),

          // Back to login
          Center(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.arrow_back,
                    size: 18,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    context.l10n.backToLogin,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.7),
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

/// Success screen after email sent.
class PremiumForgotPasswordSuccess extends StatefulWidget {
  final String email;
  final VoidCallback onBackToLogin;

  const PremiumForgotPasswordSuccess({
    super.key,
    required this.email,
    required this.onBackToLogin,
  });

  @override
  State<PremiumForgotPasswordSuccess> createState() =>
      _PremiumForgotPasswordSuccessState();
}

class _PremiumForgotPasswordSuccessState
    extends State<PremiumForgotPasswordSuccess>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.3, 1.0)),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success icon
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppColors.accentCyan, AppColors.accentCyanDark],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentCyan.withValues(alpha: 0.4),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.mark_email_read_outlined,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Title
            FadeTransition(
              opacity: _opacityAnimation,
              child: Text(
                context.l10n.resetEmailSentTitle,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Message
            FadeTransition(
              opacity: _opacityAnimation,
              child: Text(
                context.l10n.resetEmailSentMessage,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 8),

            // Email
            FadeTransition(
              opacity: _opacityAnimation,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.email,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accentCyan,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Instructions
            FadeTransition(
              opacity: _opacityAnimation,
              child: Text(
                context.l10n.resetLinkExpires,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.6),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 40),

            // Back to login button
            FadeTransition(
              opacity: _opacityAnimation,
              child: SizedBox(
                width: 200,
                child: PremiumButton(
                  label: context.l10n.backToLogin,
                  onPressed: widget.onBackToLogin,
                  icon: Icons.login,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Didn't receive email
            FadeTransition(
              opacity: _opacityAnimation,
              child: Text(
                context.l10n.checkSpamFolder,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
