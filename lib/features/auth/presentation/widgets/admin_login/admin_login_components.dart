import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

class AdminEmailField extends StatelessWidget {
  final TextEditingController controller;

  const AdminEmailField({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: l10n.email,
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return l10n.fieldRequired;
        }
        final emailRegex = RegExp(
          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
        );
        if (!emailRegex.hasMatch(value)) {
          return l10n.invalidEmail;
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
    final l10n = context.l10n;
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: l10n.password,
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return l10n.fieldRequired;
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
        child: Text(
          context.l10n.forgotPassword,
          style: const TextStyle(color: AppColors.primary),
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
    final l10n = context.l10n;
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          l10n.login,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
        Text(context.l10n.notAnAdmin),
        TextButton(
          onPressed: () {
            context.goNamed('login');
          },
          child: Text(
            context.l10n.userLogin,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
