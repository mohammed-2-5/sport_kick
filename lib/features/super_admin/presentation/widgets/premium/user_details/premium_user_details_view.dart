import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/user_details/user_details_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/user_details/user_details_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/user_details/premium_status_toggle_dialog.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/user_details/premium_user_action_buttons.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/user_details/premium_user_booking_list.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/user_details/premium_user_profile_header.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/user_details/premium_user_stats_grid.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Premium user details view.
///
/// Features:
/// - Premium profile header
/// - Statistics grid
/// - Booking history
/// - Action buttons
/// - Status toggle dialog
/// - All logic handled by UserDetailsCubit
class PremiumUserDetailsView extends StatefulWidget {
  final UserEntity user;

  const PremiumUserDetailsView({super.key, required this.user});

  @override
  State<PremiumUserDetailsView> createState() => _PremiumUserDetailsViewState();
}

class _PremiumUserDetailsViewState extends State<PremiumUserDetailsView> {
  @override
  void initState() {
    super.initState();
    context.read<UserDetailsCubit>().initialize(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserDetailsCubit, UserDetailsState>(
      listener: (context, state) {
        if (state is UserDetailsError) {
          SnackbarHelper.showError(context, state.message);
        } else if (state is UserStatusToggled) {
          SnackbarHelper.showSuccess(context, state.message);
          // Restore to loaded state with updated user
          final cubit = context.read<UserDetailsCubit>();
          if (cubit.state is UserStatusToggled) {
            final toggledState = cubit.state as UserStatusToggled;
            cubit.restoreAfterToggle(toggledState.user, []);
          }
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: AppColors.backgroundLight,
              body: _buildBody(context, state),
            ),

            // Status toggle dialog
            if (state is UserDetailsLoaded && state.showStatusDialog)
              PremiumStatusToggleDialog(
                user: state.user,
                onConfirm: () =>
                    context.read<UserDetailsCubit>().toggleUserStatus(),
                onCancel: () =>
                    context.read<UserDetailsCubit>().hideStatusToggleDialog(),
              ),
          ],
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, UserDetailsState state) {
    if (state is UserDetailsLoading) {
      return const _LoadingState();
    }

    if (state is UserDetailsError && state.user == null) {
      return _ErrorState(
        message: state.message,
        onRetry: () => context.read<UserDetailsCubit>().initialize(widget.user),
      );
    }

    final user = _getUserFromState(state);
    final stats = _getStatsFromState(state);
    final bookings = _getBookingsFromState(state);
    final isTogglingStatus = _getIsTogglingStatus(state);
    final cubit = context.read<UserDetailsCubit>();

    return CustomScrollView(
      slivers: [
        // Back button
        SliverToBoxAdapter(
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: _BackButton(onTap: () => context.pop()),
              ),
            ),
          ),
        ),

        // Profile header
        SliverToBoxAdapter(
          child: PremiumUserProfileHeader(
            user: user,
            memberSince: cubit.getMemberSinceFormatted(user.createdAt),
          ),
        ),

        // Content
        SliverPadding(
          padding: const EdgeInsets.only(top: 20, bottom: 32),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Action buttons
              PremiumUserActionButtons(
                user: user,
                isTogglingStatus: isTogglingStatus,
                onToggleStatus: () => cubit.showStatusToggleDialog(),
              ),
              const SizedBox(height: 24),

              // Stats grid
              if (stats != null) ...[
                PremiumUserStatsGrid(stats: stats),
                const SizedBox(height: 24),
              ],

              // Booking history
              PremiumUserBookingList(bookings: bookings),
            ]),
          ),
        ),
      ],
    );
  }

  UserEntity _getUserFromState(UserDetailsState state) {
    if (state is UserDetailsLoaded) return state.user;
    if (state is UserStatusToggled) return state.user;
    if (state is UserDetailsError && state.user != null) return state.user!;
    return widget.user;
  }

  UserDetailsStats? _getStatsFromState(UserDetailsState state) {
    if (state is UserDetailsLoaded) return state.stats;
    return null;
  }

  List<BookingEntity> _getBookingsFromState(UserDetailsState state) {
    if (state is UserDetailsLoaded) return state.bookings;
    return [];
  }

  bool _getIsTogglingStatus(UserDetailsState state) {
    if (state is UserDetailsLoaded) return state.isTogglingStatus;
    return false;
  }
}

/// Back button widget.
class _BackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
      ),
    );
  }
}

/// Loading state widget.
class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.navyDeep, AppColors.navyLight],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.premiumGold),
      ),
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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.navyDeep, AppColors.navyLight],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyLargeWhite,
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: onRetry,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.premiumGold,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    context.l10n.retry,
                    style: AppTextStyles.labelLargeWhite,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
