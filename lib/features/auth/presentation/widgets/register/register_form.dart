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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _FullNameField(controller: _fullNameController),
          const SizedBox(height: 16),
          _EmailField(controller: _emailController),
          const SizedBox(height: 16),
          _PhoneField(controller: _phoneController),
          const SizedBox(height: 16),
          _PasswordField(controller: _passwordController),
          const SizedBox(height: 16),
          _ConfirmPasswordField(
            controller: _confirmPasswordController,
            passwordController: _passwordController,
          ),
          const SizedBox(height: 8),
          const _PasswordRequirementsText(),
          const SizedBox(height: 32),
          _RegisterButton(
            formKey: _formKey,
            fullNameController: _fullNameController,
            emailController: _emailController,
            phoneController: _phoneController,
            passwordController: _passwordController,
            confirmPasswordController: _confirmPasswordController,
          ),
          const SizedBox(height: 16),
          const _TermsText(),
        ],
      ),
    );
  }
}

class _FullNameField extends StatelessWidget {
  final TextEditingController controller;

  const _FullNameField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: context.l10n.fullName,
      hint: context.l10n.enterFullName,
      controller: controller,
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
    );
  }
}

class _EmailField extends StatelessWidget {
  final TextEditingController controller;

  const _EmailField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: context.l10n.email,
      hint: context.l10n.enterYourEmail,
      controller: controller,
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
    );
  }
}

class _PhoneField extends StatelessWidget {
  final TextEditingController controller;

  const _PhoneField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: context.l10n.phoneOptional,
      hint: context.l10n.enterPhoneNumber,
      controller: controller,
      type: TextFieldType.phone,
      keyboardType: TextInputType.phone,
      prefixIcon: Icons.phone_outlined,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return null;
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
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;

  const _PasswordField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: context.l10n.password,
      hint: context.l10n.createPassword,
      controller: controller,
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
    );
  }
}

class _ConfirmPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final TextEditingController passwordController;

  const _ConfirmPasswordField({
    required this.controller,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: context.l10n.confirmPassword,
      hint: context.l10n.reenterPassword,
      controller: controller,
      type: TextFieldType.password,
      prefixIcon: Icons.lock_outline,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return context.l10n.pleaseConfirmPassword;
        }
        if (value != passwordController.text) {
          return context.l10n.passwordsDoNotMatch;
        }
        return null;
      },
      textInputAction: TextInputAction.done,
    );
  }
}

class _PasswordRequirementsText extends StatelessWidget {
  const _PasswordRequirementsText();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.passwordRequirementText,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class _RegisterButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const _RegisterButton({
    required this.formKey,
    required this.fullNameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: context.l10n.createAccount,
      onPressed: () {
        if (!formKey.currentState!.validate()) {
          return;
        }
        if (passwordController.text != confirmPasswordController.text) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.passwordsDoNotMatch)),
          );
          return;
        }
        context.read<AuthCubit>().register(
          email: emailController.text.trim(),
          password: passwordController.text,
          fullName: fullNameController.text.trim(),
          phone: phoneController.text.trim().isEmpty
              ? null
              : phoneController.text.trim(),
        );
      },
      variant: ButtonVariant.primary,
    );
  }
}

class _TermsText extends StatelessWidget {
  const _TermsText();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.termsAndPrivacyNote,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      textAlign: TextAlign.center,
    );
  }
}
