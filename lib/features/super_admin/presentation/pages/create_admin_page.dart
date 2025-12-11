import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/admin_form/admin_form_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/create_admin/premium_create_admin_view.dart';

/// Create Admin Account Page - Premium Design
///
/// Features:
/// - Premium curved header with gold theme
/// - Info card explaining the process
/// - Premium form fields with real-time validation
/// - Animated submit button with gradient
/// - Success overlay with invitation credentials
/// - Copy link functionality
/// - All logic handled by AdminFormCubit
class CreateAdminPage extends StatelessWidget {
  const CreateAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AdminFormCubit>(),
      child: const PremiumCreateAdminView(),
    );
  }
}
