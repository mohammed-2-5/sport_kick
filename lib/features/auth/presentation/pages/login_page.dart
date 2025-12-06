import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_strings.dart';
import 'package:spo_kick/features/auth/presentation/constants/auth_strings.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/core/widgets/loading_indicator.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/auth/presentation/utils/auth_navigation_handler.dart';
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
              // Use the auth navigation handler
              AuthNavigationHandler.handleUserLogin(
                context: context,
                user: state.user,
                loginMode: _loginMode,
              );
            } else if (state is AuthError) {
              // Print error to console
              debugPrint('🔴 Login Error (UI): ${state.message}');
              // Show error message using SnackbarHelper
              SnackbarHelper.showError(
                context,
                'Login Failed: ${state.message}',
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
                      AppStrings.welcomeBack,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      AuthStrings.loginSubtitle,
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
                            AuthStrings.or,
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
                          AppStrings.dontHaveAccount,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextButton(
                          onPressed: () {
                            context.pushNamed('register');
                          },
                          child: const Text(AppStrings.signUp),
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
