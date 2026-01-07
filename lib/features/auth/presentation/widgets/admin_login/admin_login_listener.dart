import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';

/// Handles auth state changes for admin login
abstract class AdminLoginListener {
  static void handle(BuildContext context, AuthState state) {
    if (state is AuthError) {
      SnackbarHelper.showError(context, state.message);
    } else if (state is Authenticated) {
      _handleAuthenticated(context, state);
    }
  }

  static void _handleAuthenticated(BuildContext context, Authenticated state) {
    if (state.user.isSuperAdmin) {
      context.goNamed('superAdminDashboard');
    } else if (state.user.isAdmin) {
      context.goNamed('ownerDashboard');
    } else {
      SnackbarHelper.showError(context, context.l10n.adminAccessDenied);
      context.read<AuthCubit>().logout();
    }
  }
}
