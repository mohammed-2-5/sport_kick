import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/user_details/user_details_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/user_details/premium_user_details_view.dart';

/// User Details Page - Premium Design
///
/// Comprehensive view of a regular user account showing:
/// - Profile information with premium header
/// - Booking history with premium cards
/// - Spending statistics
/// - Actions (Deactivate/Activate) with premium buttons
class UserDetailsPage extends StatelessWidget {
  final UserEntity user;

  const UserDetailsPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<UserDetailsCubit>()),
        BlocProvider(create: (_) => sl<SuperAdminCubit>()..loadAllBookings()),
      ],
      child: PremiumUserDetailsView(user: user),
    );
  }
}
