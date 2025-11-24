import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/utils/validators.dart';
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
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
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
            label: 'Full Name',
            hint: 'Enter your full name',
            controller: _fullNameController,
            type: TextFieldType.text,
            keyboardType: TextInputType.name,
            prefixIcon: Icons.person_outline,
            validator: Validators.required,
            textInputAction: TextInputAction.next,
          ),

          const SizedBox(height: 16),

          // Email Field
          CustomTextField(
            label: 'Email',
            hint: 'Enter your email',
            controller: _emailController,
            type: TextFieldType.email,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
            validator: Validators.email,
            textInputAction: TextInputAction.next,
          ),

          const SizedBox(height: 16),

          // Phone Field (Optional)
          CustomTextField(
            label: 'Phone Number (Optional)',
            hint: 'Enter your phone number',
            controller: _phoneController,
            type: TextFieldType.phone,
            keyboardType: TextInputType.phone,
            prefixIcon: Icons.phone_outlined,
            validator: (value) {
              // Phone is optional, but if provided, should be valid
              if (value == null || value.isEmpty) {
                return null; // Valid - optional field
              }
              return Validators.egyptianPhone(value);
            },
            textInputAction: TextInputAction.next,
          ),

          const SizedBox(height: 16),

          // Password Field
          CustomTextField(
            label: 'Password',
            hint: 'Create a password',
            controller: _passwordController,
            type: TextFieldType.password,
            prefixIcon: Icons.lock_outline,
            validator: Validators.password,
            textInputAction: TextInputAction.next,
          ),

          const SizedBox(height: 16),

          // Confirm Password Field
          CustomTextField(
            label: 'Confirm Password',
            hint: 'Re-enter your password',
            controller: _confirmPasswordController,
            type: TextFieldType.password,
            prefixIcon: Icons.lock_outline,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null; // Valid
            },
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _handleRegister(),
          ),

          const SizedBox(height: 8),

          // Password Requirements Text
          Text(
            'Password must be at least 6 characters',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
          ),

          const SizedBox(height: 32),

          // Register Button
          CustomButton(
            text: 'Create Account',
            onPressed: _handleRegister,
            variant: ButtonVariant.primary,
          ),

          const SizedBox(height: 16),

          // Terms and Privacy Text
          Text(
            'By creating an account, you agree to our Terms of Service and Privacy Policy',
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
