import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_profile/owner_profile_cubit.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/premium_owner_profile_view.dart';

/// Owner Profile Page - Premium Design
///
/// Features:
/// - Navy gradient header with glassmorphism
/// - Profile avatar with stats
/// - Revenue statistics
/// - Action buttons (edit, change password, settings, logout)
/// - Pull-to-refresh
/// - All logic handled by OwnerProfileCubit
class OwnerProfilePage extends StatelessWidget {
  const OwnerProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OwnerProfileCubit>(),
      child: const PremiumOwnerProfileView(),
    );
  }
}
