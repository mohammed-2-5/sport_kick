import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/user_details/user_details_view.dart';

/// User Details Page
///
/// Comprehensive view of a regular user account showing:
/// - Profile information
/// - Booking history
/// - Spending statistics
/// - Actions (Deactivate/Activate)
class UserDetailsPage extends StatelessWidget {
  final UserEntity user;

  const UserDetailsPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SuperAdminCubit>()..loadAllBookings(),
      child: UserDetailsView(user: user),
    );
  }
}
