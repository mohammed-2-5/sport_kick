import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/widgets/loading_indicator.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_profile/owner_profile_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_profile/owner_profile_state.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/profile/premium_edit_profile_sheet.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/profile/premium_owner_profile_actions.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/profile/premium_owner_profile_header.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/profile/premium_owner_profile_stats.dart';

/// Premium owner profile view.
///
/// Features:
/// - Navy gradient header with glassmorphism
/// - Profile avatar with stats
/// - Revenue statistics
/// - Action buttons (edit, change password, settings, logout)
/// - Pull-to-refresh
/// - All logic handled by OwnerProfileCubit
class PremiumOwnerProfileView extends StatefulWidget {
  const PremiumOwnerProfileView({super.key});

  @override
  State<PremiumOwnerProfileView> createState() =>
      _PremiumOwnerProfileViewState();
}

class _PremiumOwnerProfileViewState extends State<PremiumOwnerProfileView> {
  @override
  void initState() {
    super.initState();
    context.read<OwnerProfileCubit>().loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, authState) {
        if (authState is Unauthenticated) {
          context.goNamed('login');
        } else if (authState is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authState.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      },
      builder: (context, authState) {
        if (authState is! Authenticated) {
          return const Scaffold(
            body: Center(child: Text('Please login to view your profile')),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.backgroundLight,
          body: BlocConsumer<OwnerProfileCubit, OwnerProfileState>(
            listener: (context, state) {
              // Reload profile data after successful auth actions
              if (context.read<AuthCubit>().state is Authenticated) {
                final currentAuthState = context.read<AuthCubit>().state;
                if (currentAuthState is Authenticated) {
                  context.read<OwnerProfileCubit>().refresh();
                }
              }
            },
            builder: (context, state) {
              return RefreshIndicator(
                onRefresh: () async {
                  await context.read<OwnerProfileCubit>().refresh();
                },
                color: AppColors.accentCyan,
                child: _buildContent(context, authState, state),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    Authenticated authState,
    OwnerProfileState state,
  ) {
    return CustomScrollView(
      slivers: [
        // Premium Header
        SliverToBoxAdapter(child: _buildHeader(authState, state)),

        // Content
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Revenue Card
              if (state is OwnerProfileLoaded && state.revenue != null)
                PremiumOwnerProfileStats(revenue: state.revenue),

              if (state is OwnerProfileLoading)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: LoadingIndicator.inline(
                    message: 'Loading statistics...',
                  ),
                ),

              if (state is OwnerProfileError) _buildErrorState(context, state),

              const SizedBox(height: 20),

              // Action Buttons
              PremiumOwnerProfileActions(
                onEditProfile: () => _showEditProfileSheet(context, authState),
                onChangePassword: () => context.pushNamed('changePassword'),
                onSettings: () => context.pushNamed('ownerSettings'),
                onLogout: () => _handleLogout(context),
              ),

              const SizedBox(height: 32),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(Authenticated authState, OwnerProfileState state) {
    int fieldsCount = 0;
    int bookingsCount = 0;

    if (state is OwnerProfileLoaded) {
      fieldsCount = state.fieldsCount;
      bookingsCount = state.bookingsCount;
    }

    return PremiumOwnerProfileHeader(
      name: authState.user.fullName ?? authState.user.email,
      email: authState.user.email,
      avatarUrl: authState.user.avatarUrl,
      fieldsCount: fieldsCount,
      bookingsCount: bookingsCount,
      onEditTap: () => _showEditProfileSheet(context, authState),
    );
  }

  Widget _buildErrorState(BuildContext context, OwnerProfileError state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            state.message,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.read<OwnerProfileCubit>().loadProfile(),
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentCyan,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditProfileSheet(BuildContext context, Authenticated authState) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PremiumEditProfileSheet(user: authState.user),
    );
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Logout',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthCubit>().logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text(
              'Logout',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
