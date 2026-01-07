import 'package:flutter/material.dart';
import 'package:spo_kick/features/auth/presentation/widgets/register/register_confirm_password_field.dart';
import 'package:spo_kick/features/auth/presentation/widgets/register/register_email_field.dart';
import 'package:spo_kick/features/auth/presentation/widgets/register/register_full_name_field.dart';
import 'package:spo_kick/features/auth/presentation/widgets/register/register_login_link.dart';
import 'package:spo_kick/features/auth/presentation/widgets/register/register_password_field.dart';
import 'package:spo_kick/features/auth/presentation/widgets/register/register_phone_field.dart';
import 'package:spo_kick/features/auth/presentation/widgets/register/register_submit_button.dart';

/// Body widget for the register page.
class RegisterBody extends StatelessWidget {
  const RegisterBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RegisterFullNameField(),
          SizedBox(height: 20),
          RegisterEmailField(),
          SizedBox(height: 20),
          RegisterPhoneField(),
          SizedBox(height: 20),
          RegisterPasswordField(),
          SizedBox(height: 20),
          RegisterConfirmPasswordField(),
          SizedBox(height: 32),
          RegisterSubmitButton(),
          SizedBox(height: 24),
          RegisterLoginLink(),
        ],
      ),
    );
  }
}
