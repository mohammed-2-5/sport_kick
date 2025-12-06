import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/create_admin/create_admin_view.dart';

/// Create Admin Account Page
///
/// Allows super admin to create new field owner accounts.
class CreateAdminPage extends StatelessWidget {
  const CreateAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SuperAdminCubit>(),
      child: const CreateAdminView(),
    );
  }
}
