import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/auth/presentation/utils/auth_navigation_handler.dart';
import 'package:spo_kick/features/auth/presentation/widgets/admin_login/admin_login_form.dart';
import 'package:spo_kick/features/auth/presentation/widgets/admin_login/admin_login_loading_state.dart';

/// Admin Login Page
///
/// Separate login page for field owners and administrators:
/// - Admin-specific branding
/// - Role validation (must be admin or super_admin)
/// - First-login detection (force password change)
/// - Forgot password link
class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: _handleAuthStateChange,
          builder: (context, state) {
            if (state is AuthLoading) {
              return const AdminLoginLoadingState();
            }

            return AdminLoginForm(
              formKey: _formKey,
              emailController: _emailController,
              passwordController: _passwordController,
              onSubmit: _handleLogin,
            );
          },
        ),
      ),
    );
  }

  void _handleAuthStateChange(BuildContext context, AuthState state) {
    if (state is Authenticated) {
      // Use auth navigation handler
      final shouldContinue = AuthNavigationHandler.handleAdminLogin(
        context: context,
        user: state.user,
      );

      // If validation failed, logout
      if (!shouldContinue) {
        context.read<AuthCubit>().logout();
      }
    } else if (state is AuthError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Login Failed: ${state.message}',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 6),
        ),
      );
    }
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }
}
