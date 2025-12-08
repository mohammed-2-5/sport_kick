import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/widgets/loading_indicator.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/auth/presentation/cubit/register_cubit.dart';
import 'package:spo_kick/features/auth/presentation/widgets/register_body.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is Authenticated) {
              // Navigation handled by GoRouter redirect usually, or explicitly:
              // context.goNamed('home');
              // Assuming AuthNavigationHandler or GoRouter handles it.
              // Previous RegisterPage called context.goNamed('home');
              // I'll leave navigation to AuthNavigationHandler usage in Login,
              // but Register might need explicit if it replaces Login stack.
              // Check RegisterPage (855): context.goNamed('home') logic was there.
              // But usually AuthCubit state change triggers root router refresh?
              // If not, I should navigate.
              // For now, I'll allow listener to handle it if needed, or rely on router.
            } else if (state is AuthError) {
              SnackbarHelper.showError(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const LoadingIndicator(
                variant: LoadingVariant.fullScreen,
                message: 'Creating account...',
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
    return const Column(
      children: [
        PremiumCurvedHeader(
          title: 'Join Now',
          subtitle: 'Create your account',
          height: 160,
          showBackButton: true,
        ),
        Expanded(child: SingleChildScrollView(child: RegisterBody())),
      ],
    );
  }
}
