import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/widgets/loading_indicator.dart';
import 'package:spo_kick/core/widgets/language_switcher_button.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/auth/presentation/cubit/register_cubit.dart';
import 'package:spo_kick/features/auth/presentation/widgets/register/register_body.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(authCubit: context.read<AuthCubit>()),
      child: Scaffold(
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is Authenticated) {
              // Navigation handled by GoRouter redirect usually
            } else if (state is AuthError) {
              SnackbarHelper.showError(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return LoadingIndicator(
                variant: LoadingVariant.fullScreen,
                message: context.l10n.creatingAccount,
              );
            }
            return const _RegisterPageContent();
          },
        ),
      ),
    );
  }
}

class _RegisterPageContent extends StatelessWidget {
  const _RegisterPageContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PremiumCurvedHeader(
          title: context.l10n.joinNow,
          subtitle: context.l10n.createYourAccount,
          height: 160,
          showBackButton: true,
          trailing: const LanguageSwitcherButton(dark: true),
        ),
        const Expanded(child: SingleChildScrollView(child: RegisterBody())),
      ],
    );
  }
}
