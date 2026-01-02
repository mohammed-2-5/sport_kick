import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/auth/presentation/widgets/profile/profile_body.dart';
import 'package:spo_kick/features/auth/presentation/widgets/profile/profile_header.dart';

/// Profile page with premium curved design and overlapping avatar.
///
/// Uses [ProfileHeader] and [ProfileBody] for layout.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) => _handleStateChange(context, state),
        builder: (context, state) {
          if (state is! Authenticated) {
            return Center(child: Text(context.l10n.pleaseLoginToViewProfile));
          }

          final user = state.user;

          return SingleChildScrollView(
            child: Column(
              children: [
                ProfileHeader(
                  avatarUrl: user.avatarUrl,
                  initials: user.initials,
                  onBackPressed: () => Navigator.pop(context),
                ),
                ProfileBody(user: user),
              ],
            ),
          );
        },
      ),
    );
  }

  void _handleStateChange(BuildContext context, AuthState state) {
    if (state is Unauthenticated) {
      context.goNamed('login');
    } else if (state is AuthError) {
      SnackbarHelper.showError(context, state.message);
    } else if (state is ProfileUpdated) {
      SnackbarHelper.showSuccess(context, context.l10n.profileUpdated);
    }
  }
}
