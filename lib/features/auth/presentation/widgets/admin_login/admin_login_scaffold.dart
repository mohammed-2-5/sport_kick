import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/widgets/admin_login/admin_login_animated_content.dart';

/// Admin login scaffold with navy gradient background
class AdminLoginScaffold extends StatefulWidget {
  final bool isLoading;

  const AdminLoginScaffold({super.key, required this.isLoading});

  @override
  State<AdminLoginScaffold> createState() => _AdminLoginScaffoldState();
}

class _AdminLoginScaffoldState extends State<AdminLoginScaffold> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.navyDeep, AppColors.navyLight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: AdminLoginAnimatedContent(
              isLoading: widget.isLoading,
              emailController: _emailController,
              passwordController: _passwordController,
              onSubmit: () {
                HapticFeedback.mediumImpact();
                context.read<AuthCubit>().login(
                  email: _emailController.text.trim(),
                  password: _passwordController.text,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
