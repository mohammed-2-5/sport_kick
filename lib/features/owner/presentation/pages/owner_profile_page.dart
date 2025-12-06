import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/core/widgets/custom_button.dart';
import 'package:spo_kick/core/widgets/loading_indicator.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_state.dart';
import 'package:spo_kick/features/owner/presentation/utils/logout_dialog.dart';
import 'package:spo_kick/features/owner/presentation/utils/profile_dialogs.dart';
import 'package:spo_kick/features/owner/presentation/widgets/owner_profile_header.dart';
import 'package:spo_kick/features/owner/presentation/widgets/owner_profile_stats.dart';

/// Owner profile page displaying owner information and statistics.
///
/// Shows:
/// - Owner personal information
/// - Owner statistics (fields, bookings, revenue)
/// - Edit profile option
/// - Logout option
class OwnerProfilePage extends StatefulWidget {
  const OwnerProfilePage({super.key});

  @override
  State<OwnerProfilePage> createState() => _OwnerProfilePageState();
}

class _OwnerProfilePageState extends State<OwnerProfilePage> {
  @override
  void initState() {
    super.initState();
    // Load owner data using cubit
    final authState = context.read<AuthCubit>().state;
    if (authState is Authenticated) {
      context.read<OwnerCubit>().loadDashboardData(authState.user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), centerTitle: true),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, authState) {
          if (authState is Unauthenticated) {
            context.goNamed('login');
          } else if (authState is AuthError) {
            SnackbarHelper.showError(context, authState.message);
          }
        },
        builder: (context, authState) {
          if (authState is! Authenticated) {
            return const Center(
              child: Text('Please login to view your profile'),
            );
          }

          return BlocConsumer<OwnerCubit, OwnerState>(
            listener: (context, state) {
              if (state is OwnerError) {
                SnackbarHelper.showError(context, state.message);
              } else if (state is OwnerActionSuccess) {
                SnackbarHelper.showSuccess(context, state.message);
                // Refresh user data from AuthCubit after profile update
                context.read<AuthCubit>().checkAuthStatus();
                final authSt = context.read<AuthCubit>().state;
                if (authSt is Authenticated) {
                  context.read<OwnerCubit>().loadDashboardData(authSt.user.id);
                }
              }
            },
            builder: (context, ownerState) {
              return RefreshIndicator(
                onRefresh: () async {
                  final authSt = context.read<AuthCubit>().state;
                  if (authSt is Authenticated) {
                    context.read<OwnerCubit>().loadDashboardData(
                      authSt.user.id,
                    );
                  }
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),

                      // Owner Header (Avatar, Name, Email)
                      OwnerProfileHeader(user: authState.user),

                      const SizedBox(height: 32),

                      // Owner Statistics
                      if (ownerState is OwnerDataLoaded ||
                          ownerState is OwnerFieldsLoaded ||
                          ownerState is OwnerRevenueLoaded)
                        OwnerProfileStats(
                          fieldsCount: ownerState is OwnerDataLoaded
                              ? ownerState.fields.length
                              : (ownerState is OwnerFieldsLoaded
                                    ? ownerState.fields.length
                                    : 0),
                          revenue: ownerState is OwnerDataLoaded
                              ? ownerState.revenue
                              : (ownerState is OwnerRevenueLoaded
                                    ? ownerState.revenue
                                    : null),
                        )
                      else if (ownerState is OwnerLoading)
                        const Padding(
                          padding: EdgeInsets.all(20),
                          child: LoadingIndicator.inline(
                            message: 'Loading statistics...',
                          ),
                        ),

                      const SizedBox(height: 32),

                      // Action Buttons
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CustomButton(
                              text: 'Edit Profile',
                              onPressed: () =>
                                  ProfileDialogs.showEditProfileDialog(
                                    context,
                                    authState.user,
                                  ),
                              variant: ButtonVariant.outline,
                              icon: Icons.edit_outlined,
                            ),
                            const SizedBox(height: 12),
                            CustomButton(
                              text: 'Change Password',
                              onPressed: () {
                                context.pushNamed('changePassword');
                              },
                              variant: ButtonVariant.outline,
                              icon: Icons.lock_outline,
                            ),
                            const SizedBox(height: 12),
                            CustomButton(
                              text: 'Logout',
                              onPressed: () => LogoutDialog.show(context),
                              variant: ButtonVariant.text,
                              icon: Icons.logout,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
