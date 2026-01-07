import 'package:flutter/material.dart';
import 'package:spo_kick/features/auth/presentation/widgets/login/login_body_email_field.dart';
import 'package:spo_kick/features/auth/presentation/widgets/login/login_body_password_field.dart';
import 'package:spo_kick/features/auth/presentation/widgets/login/login_body_submit_button.dart';
import 'package:spo_kick/features/auth/presentation/widgets/login/login_divider_with_or.dart';
import 'package:spo_kick/features/auth/presentation/widgets/login/login_mode_switcher.dart';
import 'package:spo_kick/features/auth/presentation/widgets/login/login_register_link.dart';
import 'package:spo_kick/features/auth/presentation/widgets/login/login_remember_forgot_row.dart';

/// Login Body Widget
///
/// Contains the form layout and delegates interactions to cubits.
class LoginBody extends StatelessWidget {
  const LoginBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LoginModeSwitcher(),
          SizedBox(height: 32),
          LoginBodyEmailField(),
          SizedBox(height: 20),
          LoginBodyPasswordField(),
          SizedBox(height: 12),
          LoginRememberForgotRow(),
          SizedBox(height: 32),
          LoginBodySubmitButton(),
          SizedBox(height: 24),
          LoginDividerWithOr(),
          SizedBox(height: 24),
          LoginRegisterLink(),
        ],
      ),
    );
  }
}
