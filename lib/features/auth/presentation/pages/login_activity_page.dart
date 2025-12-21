import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/auth/presentation/cubit/login_activity_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/login_activity_state.dart';
import 'package:spo_kick/features/auth/presentation/widgets/login_activity/login_activity_list.dart';

/// Login Activity Page
///
/// Displays the user's login history for security monitoring.
class LoginActivityPage extends StatelessWidget {
  const LoginActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = sl<LoginActivityCubit>();
        final authState = context.read<AuthCubit>().state;
        if (authState is Authenticated) {
          if (authState.user.role == 'super_admin') {
            cubit.loadAllLoginActivity();
          } else {
            cubit.loadLoginActivity(authState.user.id);
          }
        }
        return cubit;
      },
      child: const _LoginActivityContent(),
    );
  }
}

/// Login activity page content.
class _LoginActivityContent extends StatelessWidget {
  const _LoginActivityContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: PremiumCurvedHeader(
              title: context.l10n.loginActivityTitle,
              subtitle: context.l10n.loginActivitySubtitle,
              showBackButton: true,
            ),
          ),
          SliverFillRemaining(
            child: BlocBuilder<LoginActivityCubit, LoginActivityState>(
              builder: (context, state) {
                if (state is LoginActivityLoading) {
                  return const _LoadingState();
                }

                if (state is LoginActivityError) {
                  return _ErrorState(
                    message: state.message,
                    onRetry: () => context.read<LoginActivityCubit>().refresh(),
                  );
                }

                if (state is LoginActivityLoaded) {
                  return LoginActivityList(
                    activities: state.activities,
                    hasMore: state.hasMore,
                    isLoadingMore: state.isLoadingMore,
                    onLoadMore: () =>
                        context.read<LoginActivityCubit>().loadMore(),
                    onRefresh: () =>
                        context.read<LoginActivityCubit>().refresh(),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Loading state widget.
class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.premiumGold),
    );
  }
}

/// Error state widget.
class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(context.l10n.retry),
            ),
          ],
        ),
      ),
    );
  }
}
