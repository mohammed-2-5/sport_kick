import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/widgets/loading_indicator.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/auth/presentation/cubit/login_cubit.dart';
import 'package:spo_kick/features/auth/presentation/utils/auth_navigation_handler.dart';
import 'package:spo_kick/features/auth/presentation/widgets/login/login_body.dart';

/// Login Page
///
/// Features:
/// - Premium Curved Header
/// - Logic delegated to LoginCubit
/// - Form extracted to LoginBody
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is Authenticated) {
                  // Get login mode from the LoginCubit available in this context
                  final loginMode = context.read<LoginCubit>().state.loginMode;
                  AuthNavigationHandler.handleUserLogin(
                    context: context,
                    user: state.user,
                    loginMode: loginMode,
                  );
                } else if (state is AuthError) {
                  SnackbarHelper.showError(context, state.message);
                }
              },
              builder: (context, state) {
                if (state is AuthLoading) {
                  return const LoadingIndicator(
                    variant: LoadingVariant.fullScreen,
                    message: 'Logging in...',
                  );
                }

                return const Column(
                  children: [
                    PremiumCurvedHeader(
                      title: 'Welcome Back',
                      subtitle: 'Sign in to continue',
                      height: 180,
                      showBackButton: false,
                    ),
                    Expanded(child: SingleChildScrollView(child: LoginBody())),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
