import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/auth/presentation/constants/auth_constants.dart';

class AdminEmailField extends StatelessWidget {
  final TextEditingController controller;

  const AdminEmailField({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: AuthConstants.emailLabel,
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AuthConstants.borderRadius),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return AuthConstants.emailRequiredMsg;
        }
        final emailRegex = RegExp(AuthConstants.emailPattern);
        if (!emailRegex.hasMatch(value)) {
          return AuthConstants.emailInvalidMsg;
        }
        return null;
      },
    );
  }
}

class AdminPasswordField extends StatefulWidget {
  final TextEditingController controller;

  const AdminPasswordField({required this.controller, super.key});

  @override
  State<AdminPasswordField> createState() => _AdminPasswordFieldState();
}

class _AdminPasswordFieldState extends State<AdminPasswordField> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: AuthConstants.passwordLabel,
        prefixIcon: const Icon(Icons.lock_outlined),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AuthConstants.borderRadius),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AuthConstants.passwordRequiredMsg;
        }
        return null;
      },
    );
  }
}

class AdminForgotPasswordLink extends StatelessWidget {
  const AdminForgotPasswordLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          context.pushNamed('forgotPassword');
        },
        child: const Text(
          AuthConstants.forgotPasswordLabel,
          style: TextStyle(color: AppColors.primary),
        ),
      ),
    );
  }
}

class AdminLoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AdminLoginButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AuthConstants.buttonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AuthConstants.borderRadius),
          ),
        ),
        child: const Text(
          AuthConstants.loginButtonLabel,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class AdminUserLoginLink extends StatelessWidget {
  const AdminUserLoginLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Not an admin?'),
        TextButton(
          onPressed: () {
            context.goNamed('login');
          },
          child: const Text(
            'User Login',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
