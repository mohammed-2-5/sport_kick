import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/auth/presentation/constants/auth_constants.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/widgets/change_password/change_password_form.dart';
import 'package:spo_kick/features/auth/presentation/widgets/change_password/change_password_loading_state.dart';

/// Change Password Page
///
/// Allows users to change their password:
/// - Current password input
/// - New password with validation
/// - Confirm password
/// - Password strength indicators
/// - Updates password_changed field to true
class ChangePasswordPage extends StatefulWidget {
  /// Whether this is a first-time password change (mandatory)
  final bool isFirstLogin;

  const ChangePasswordPage({super.key, this.isFirstLogin = false});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AuthConstants.changePasswordTitle),
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        // Prevent back navigation on first login
        automaticallyImplyLeading: !widget.isFirstLogin,
      ),
      body: SafeArea(
        child: _isLoading
            ? const ChangePasswordLoadingState()
            : ChangePasswordForm(
                formKey: _formKey,
                currentPasswordController: _currentPasswordController,
                newPasswordController: _newPasswordController,
                confirmPasswordController: _confirmPasswordController,
                isFirstLogin: widget.isFirstLogin,
                onSubmit: _handleChangePassword,
              ),
      ),
    );
  }

  Future<void> _handleChangePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Implement password change logic using Supabase
      await context.read<AuthCubit>().changePassword(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AuthConstants.changePasswordSuccessMsg),
          backgroundColor: AppColors.success,
        ),
      );

      // Navigate back or to dashboard
      if (widget.isFirstLogin) {
        // Navigate to dashboard
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
