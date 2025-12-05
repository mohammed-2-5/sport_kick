import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/auth/presentation/constants/auth_constants.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/auth/presentation/widgets/forgot_password/forgot_password_form.dart';
import 'package:spo_kick/features/auth/presentation/widgets/forgot_password/forgot_password_loading_state.dart';
import 'package:spo_kick/features/auth/presentation/widgets/forgot_password/forgot_password_success_screen.dart';

/// Forgot Password Page
///
/// Allows users to request a password reset:
/// - Email input
/// - Send reset link via Supabase
/// - Success confirmation screen
/// - Link back to login
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AuthConstants.forgotPasswordTitle),
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is PasswordResetEmailSent) {
              setState(() {
                _emailSent = true;
              });
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            if (_emailSent) {
              return ForgotPasswordSuccessScreen(
                email: _emailController.text,
                onBackToLogin: () => Navigator.of(context).pop(),
              );
            }
            if (state is AuthLoading) {
              return const ForgotPasswordLoadingState();
            }
            return ForgotPasswordForm(
              formKey: _formKey,
              emailController: _emailController,
              onSubmit: _handleSendResetLink,
              onBackToLogin: () => Navigator.of(context).pop(),
            );
          },
        ),
      ),
    );
  }

  void _handleSendResetLink() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().resetPassword(_emailController.text.trim());
    }
  }
}
