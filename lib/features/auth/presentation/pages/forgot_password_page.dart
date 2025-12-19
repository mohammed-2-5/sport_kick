import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/loading_indicator.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/auth/presentation/cubit/forgot_password_cubit.dart';
import 'package:spo_kick/features/auth/presentation/widgets/forgot_password/forgot_password_body.dart';
import 'package:spo_kick/features/auth/presentation/widgets/forgot_password/forgot_password_success_screen.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgotPasswordCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is PasswordResetEmailSent) {
              context.read<ForgotPasswordCubit>().markEmailSent();
            } else if (state is AuthError) {
              SnackbarHelper.showError(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return LoadingIndicator(
                variant: LoadingVariant.fullScreen,
                message: context.l10n.sendingResetLink,
              );
            }
            return const _ForgotPasswordContent();
          },
        ),
      ),
    );
  }
}

class _ForgotPasswordContent extends StatelessWidget {
  const _ForgotPasswordContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      builder: (context, state) {
        if (state.isEmailSent) {
          return ForgotPasswordSuccessScreen(
            email: state.email,
            onBackToLogin: () => Navigator.of(context).pop(),
          );
        }

        return Column(
          children: [
            PremiumCurvedHeader(
              title: context.l10n.resetPasswordTitle,
              subtitle: context.l10n.recoverAccount,
              height: 160,
              showBackButton: true,
            ),
            const Expanded(
              child: SingleChildScrollView(child: ForgotPasswordBody()),
            ),
          ],
        );
      },
    );
  }
}
