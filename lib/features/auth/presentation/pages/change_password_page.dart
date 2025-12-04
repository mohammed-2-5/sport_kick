import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/auth/presentation/constants/auth_constants.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';

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

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
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
      body: SafeArea(child: _isLoading ? _buildLoadingState() : _buildForm()),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: AuthConstants.formFieldSpacing),
          Text(AuthConstants.loadingChangePasswordMsg),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AuthConstants.formPadding),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.isFirstLogin) ...[
              _buildFirstLoginBanner(),
              const SizedBox(height: AuthConstants.formFieldSpacing * 2),
            ],

            // Header
            Text(
              AuthConstants.changePasswordSubtitle,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AuthConstants.formFieldSpacing * 2),

            // Current Password (skip if first login)
            if (!widget.isFirstLogin) ...[
              _buildCurrentPasswordField(),
              const SizedBox(height: AuthConstants.formFieldSpacing),
            ],

            // New Password
            _buildNewPasswordField(),
            const SizedBox(height: 8),
            _buildPasswordRequirements(),
            const SizedBox(height: AuthConstants.formFieldSpacing),

            // Confirm Password
            _buildConfirmPasswordField(),
            const SizedBox(height: AuthConstants.formFieldSpacing * 2),

            // Submit Button
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildFirstLoginBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.infoLight,
        borderRadius: BorderRadius.circular(AuthConstants.borderRadius),
        border: Border.all(color: AppColors.info),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.info),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AuthConstants.firstLoginMsg,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.info),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentPasswordField() {
    return TextFormField(
      controller: _currentPasswordController,
      obscureText: _obscureCurrentPassword,
      decoration: InputDecoration(
        labelText: AuthConstants.currentPasswordLabel,
        prefixIcon: const Icon(Icons.lock_outlined),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureCurrentPassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          onPressed: () {
            setState(() {
              _obscureCurrentPassword = !_obscureCurrentPassword;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AuthConstants.borderRadius),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AuthConstants.currentPasswordRequiredMsg;
        }
        return null;
      },
    );
  }

  Widget _buildNewPasswordField() {
    return TextFormField(
      controller: _newPasswordController,
      obscureText: _obscureNewPassword,
      decoration: InputDecoration(
        labelText: AuthConstants.newPasswordLabel,
        prefixIcon: const Icon(Icons.lock_reset),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureNewPassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          onPressed: () {
            setState(() {
              _obscureNewPassword = !_obscureNewPassword;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AuthConstants.borderRadius),
        ),
      ),
      validator: _validateNewPassword,
      onChanged: (_) => setState(() {}), // Trigger rebuild for requirements
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: _obscureConfirmPassword,
      decoration: InputDecoration(
        labelText: AuthConstants.confirmPasswordLabel,
        prefixIcon: const Icon(Icons.lock_outlined),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureConfirmPassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          onPressed: () {
            setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AuthConstants.borderRadius),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AuthConstants.confirmPasswordRequiredMsg;
        }
        if (value != _newPasswordController.text) {
          return AuthConstants.passwordMismatchMsg;
        }
        return null;
      },
    );
  }

  Widget _buildPasswordRequirements() {
    final password = _newPasswordController.text;
    final hasMinLength = password.length >= AuthConstants.minPasswordLength;
    final hasUppercase = RegExp(
      AuthConstants.uppercasePattern,
    ).hasMatch(password);
    final hasLowercase = RegExp(
      AuthConstants.lowercasePattern,
    ).hasMatch(password);
    final hasNumber = RegExp(AuthConstants.numberPattern).hasMatch(password);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AuthConstants.passwordRequirementsTitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        _RequirementItem(
          text: AuthConstants.requirement8Chars,
          isMet: hasMinLength,
        ),
        _RequirementItem(
          text: AuthConstants.requirementUppercase,
          isMet: hasUppercase,
        ),
        _RequirementItem(
          text: AuthConstants.requirementLowercase,
          isMet: hasLowercase,
        ),
        _RequirementItem(
          text: AuthConstants.requirementNumber,
          isMet: hasNumber,
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      height: AuthConstants.buttonHeight,
      child: ElevatedButton(
        onPressed: _handleChangePassword,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AuthConstants.borderRadius),
          ),
        ),
        child: const Text(
          AuthConstants.changePasswordButtonLabel,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  String? _validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return AuthConstants.newPasswordRequiredMsg;
    }

    if (value.length < AuthConstants.minPasswordLength) {
      return AuthConstants.passwordTooShortMsg;
    }

    if (AuthConstants.requireUppercase &&
        !RegExp(AuthConstants.uppercasePattern).hasMatch(value)) {
      return AuthConstants.passwordUppercaseMsg;
    }

    if (AuthConstants.requireLowercase &&
        !RegExp(AuthConstants.lowercasePattern).hasMatch(value)) {
      return AuthConstants.passwordLowercaseMsg;
    }

    if (AuthConstants.requireNumber &&
        !RegExp(AuthConstants.numberPattern).hasMatch(value)) {
      return AuthConstants.passwordNumberMsg;
    }

    return null;
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

class _RequirementItem extends StatelessWidget {
  final String text;
  final bool isMet;

  const _RequirementItem({required this.text, required this.isMet});

  static const double _iconSize = 16.0;
  static const double _spacing = 8.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.circle_outlined,
            size: _iconSize,
            color: isMet ? AppColors.success : AppColors.lightGrey,
          ),
          const SizedBox(width: _spacing),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isMet ? AppColors.success : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
