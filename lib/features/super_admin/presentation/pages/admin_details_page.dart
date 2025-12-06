import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/admin_details/admin_details_view.dart';

/// Admin Details Page
///
/// Comprehensive view of a field owner (admin) account showing:
/// - Profile information
/// - Assigned fields
/// - Performance statistics
/// - Actions (Assign Field, Deactivate/Activate)
class AdminDetailsPage extends StatelessWidget {
  final UserEntity admin;

  const AdminDetailsPage({super.key, required this.admin});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<FieldsCubit>()..loadAllFields()),
        BlocProvider(create: (_) => sl<SuperAdminCubit>()),
      ],
      child: AdminDetailsView(admin: admin),
    );
  }
}
