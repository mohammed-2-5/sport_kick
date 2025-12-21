import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/routes/route_builders.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/pages/admin_login_page.dart';
import 'package:spo_kick/features/auth/presentation/pages/change_password_page.dart';
import 'package:spo_kick/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:spo_kick/features/auth/presentation/pages/login_page.dart';
import 'package:spo_kick/features/auth/presentation/pages/profile_page.dart';
import 'package:spo_kick/features/auth/presentation/pages/register_page.dart';
import 'package:spo_kick/features/auth/presentation/pages/login_activity_page.dart';
import 'package:spo_kick/features/auth/presentation/widgets/profile/edit_profile_dialog.dart';

/// Authentication-related routes (login, register, profile, etc.)
final List<GoRoute> authRoutes = [
  // ==================== AUTH ROUTES ====================
  GoRoute(
    path: '/login',
    name: 'login',
    pageBuilder: (context, state) =>
        buildPage(child: const LoginPage(), state: state),
  ),
  GoRoute(
    path: '/register',
    name: 'register',
    pageBuilder: (context, state) =>
        buildPage(child: const RegisterPage(), state: state),
  ),
  GoRoute(
    path: '/admin-login',
    name: 'adminLogin',
    pageBuilder: (context, state) =>
        buildPage(child: const AdminLoginPage(), state: state),
  ),
  GoRoute(
    path: '/change-password',
    name: 'changePassword',
    pageBuilder: (context, state) {
      final isFirstLogin = state.uri.queryParameters['isFirstLogin'] == 'true';
      return buildSlidePage(
        child: ChangePasswordPage(isFirstLogin: isFirstLogin),
        state: state,
      );
    },
  ),
  GoRoute(
    path: '/forgot-password',
    name: 'forgotPassword',
    pageBuilder: (context, state) =>
        buildSlidePage(child: const ForgotPasswordPage(), state: state),
  ),

  // ==================== PROFILE ====================
  GoRoute(
    path: '/profile',
    name: 'profile',
    pageBuilder: (context, state) =>
        buildPage(child: const ProfilePage(), state: state),
  ),
  GoRoute(
    path: '/edit-profile',
    name: 'editProfile',
    pageBuilder: (context, state) =>
        buildPage(child: const _EditProfilePageWrapper(), state: state),
  ),

  // ==================== LOGIN ACTIVITY ====================
  GoRoute(
    path: '/login-activity',
    name: 'loginActivity',
    pageBuilder: (context, state) =>
        buildSlidePage(child: const LoginActivityPage(), state: state),
  ),
];

/// Wrapper page that shows EditProfileDialog and pops when done.
class _EditProfilePageWrapper extends StatefulWidget {
  const _EditProfilePageWrapper();

  @override
  State<_EditProfilePageWrapper> createState() =>
      _EditProfilePageWrapperState();
}

class _EditProfilePageWrapperState extends State<_EditProfilePageWrapper> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showEditDialog();
    });
  }

  Future<void> _showEditDialog() async {
    if (!mounted) return;

    await showDialog<void>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<AuthCubit>(),
        child: const EditProfileDialog(),
      ),
    );

    if (mounted && context.canPop()) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
