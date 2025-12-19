import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_constants.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/widgets/custom_button.dart';
import 'package:spo_kick/core/widgets/custom_text_field.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';

/// Registration form widget with all required fields.
///
/// Handles form validation and submission for new user registration.
class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Check if passwords match
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.passwordsDoNotMatch)));
      return;
    }

    // Trigger registration
    context.read<AuthCubit>().register(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      fullName: _fullNameController.text.trim(),
      phone: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Full Name Field
          CustomTextField(
            label: context.l10n.fullName,
            hint: context.l10n.enterFullName,
            controller: _fullNameController,
            type: TextFieldType.text,
            keyboardType: TextInputType.name,
            prefixIcon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return context.l10n.fieldRequired;
              }
              if (value.trim().length < 2) {
                return context.l10n.nameTooShort;
              }
              return null;
            },
            textInputAction: TextInputAction.next,
          ),

          const SizedBox(height: 16),

          // Email Field
          CustomTextField(
            label: context.l10n.email,
            hint: context.l10n.enterYourEmail,
            controller: _emailController,
            type: TextFieldType.email,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return context.l10n.fieldRequired;
              }
              final trimmed = value.trim();
              final regex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!regex.hasMatch(trimmed)) {
                return context.l10n.invalidEmail;
              }
              return null;
            },
            textInputAction: TextInputAction.next,
          ),

          const SizedBox(height: 16),

          // Phone Field (Optional)
          CustomTextField(
            label: context.l10n.phoneOptional,
            hint: context.l10n.enterPhoneNumber,
            controller: _phoneController,
            type: TextFieldType.phone,
            keyboardType: TextInputType.phone,
            prefixIcon: Icons.phone_outlined,
            validator: (value) {
              // Phone is optional, but if provided, should be valid
              if (value == null || value.isEmpty) {
                return null; // Valid - optional field
              }
              final cleaned = value.replaceAll(RegExp(r'[\s\-]'), '');
              if (cleaned.length != AppConstants.phoneNumberLength ||
                  !RegExp(r'^\d+$').hasMatch(cleaned) ||
                  !cleaned.startsWith('01')) {
                return context.l10n.invalidPhone;
              }
              return null;
            },
            textInputAction: TextInputAction.next,
          ),

          const SizedBox(height: 16),

          // Password Field
          CustomTextField(
            label: context.l10n.password,
            hint: context.l10n.createPassword,
            controller: _passwordController,
            type: TextFieldType.password,
            prefixIcon: Icons.lock_outline,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.l10n.fieldRequired;
              }
              if (value.length < AppConstants.minPasswordLength) {
                return context.l10n.passwordTooShort;
              }
              return null;
            },
            textInputAction: TextInputAction.next,
          ),

          const SizedBox(height: 16),

          // Confirm Password Field
          CustomTextField(
            label: context.l10n.confirmPassword,
            hint: context.l10n.reenterPassword,
            controller: _confirmPasswordController,
            type: TextFieldType.password,
            prefixIcon: Icons.lock_outline,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.l10n.pleaseConfirmPassword;
              }
              if (value != _passwordController.text) {
                return context.l10n.passwordsDoNotMatch;
              }
              return null; // Valid
            },
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _handleRegister(),
          ),

          const SizedBox(height: 8),

          // Password Requirements Text
          Text(
            context.l10n.passwordRequirementText,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
          ),

          const SizedBox(height: 32),

          // Register Button
          CustomButton(
            text: context.l10n.createAccount,
            onPressed: _handleRegister,
            variant: ButtonVariant.primary,
          ),

          const SizedBox(height: 16),

          // Terms and Privacy Text
          Text(
            context.l10n.termsAndPrivacyNote,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
