import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_strings.dart';
import 'package:spo_kick/core/routes/app_router.dart';
import 'package:spo_kick/core/widgets/loading_indicator.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/auth/presentation/widgets/login_form.dart';

/// Login page for user authentication.
///
/// Allows users to:
/// - Login with email and password
/// - Choose login mode (User or Admin)
/// - Navigate to registration page
/// - Request password reset
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Global key to access the LoginForm state
  final _formKey = GlobalKey<LoginFormState>();

  // Track login mode
  String _loginMode = 'user';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is Authenticated) {
              // Use the tracked login mode
              final userRole = state.user.role;

              // Check if user selected "admin" mode and has admin/super_admin role
              if (_loginMode == 'admin') {
                if (userRole == 'super_admin') {
                  // Super admin goes to super admin dashboard
                  Navigator.pushReplacementNamed(
                    context,
                    AppRouter.superAdminDashboard,
                  );
                } else if (userRole == 'admin') {
                  // Field owner goes to owner dashboard
                  Navigator.pushReplacementNamed(
                    context,
                    AppRouter.ownerDashboard,
                  );
                } else {
                  // User selected admin but doesn't have admin role
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Access Denied: You don\'t have admin privileges. Redirecting to user dashboard.',
                      ),
                      backgroundColor: AppColors.error,
                      duration: Duration(seconds: 4),
                    ),
                  );
                  // Navigate to home anyway
                  Navigator.pushReplacementNamed(context, AppRouter.home);
                }
              } else {
                // Regular user login - navigate to home
                Navigator.pushReplacementNamed(context, AppRouter.home);
              }
            } else if (state is AuthError) {
              // Print error to console
              print('🔴 Login Error (UI): ${state.message}');

              // Show error message
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
                  action: SnackBarAction(
                    label: 'Dismiss',
                    textColor: Colors.white,
                    onPressed: () {},
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const LoadingIndicator(
                variant: LoadingVariant.fullScreen,
                message: 'Logging in...',
              );
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 60),

                    // App Logo/Icon
                    const Icon(
                      Icons.sports_soccer,
                      size: 80,
                      color: AppColors.primary,
                    ),

                    const SizedBox(height: 16),

                    // App Name
                    Text(
                      AppStrings.appName,
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 8),

                    // Tagline
                    Text(
                      AppStrings.appTagline,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 48),

                    // Welcome Text
                    Text(
                      'Welcome Back!',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Login to continue booking your favorite sports fields',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Login Form
                    LoginForm(
                      key: _formKey,
                      onLoginModeChanged: (mode) {
                        setState(() {
                          _loginMode = mode;
                        });
                      },
                    ),

                    const SizedBox(height: 24),

                    // Divider
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'OR',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.textSecondary),
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
                          "Don't have an account? ",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRouter.register);
                          },
                          child: const Text('Sign Up'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
