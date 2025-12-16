import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/admin_details/admin_details_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/admin_details/premium_admin_details_view.dart';

/// Admin Details Page - Premium Design
///
/// Comprehensive view of a field owner (admin) account showing:
/// - Profile information with premium header
/// - Assigned fields with premium cards
/// - Performance statistics
/// - Actions (Assign Field, Deactivate/Activate) with premium buttons
class AdminDetailsPage extends StatelessWidget {
  final UserEntity admin;

  const AdminDetailsPage({super.key, required this.admin});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AdminDetailsCubit>()),
        BlocProvider(create: (_) => sl<FieldsCubit>()..loadAllFields()),
        BlocProvider(create: (_) => sl<SuperAdminCubit>()),
      ],
      child: PremiumAdminDetailsView(admin: admin),
    );
  }
}
