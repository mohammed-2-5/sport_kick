import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_fields/owner_fields_cubit.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/fields/premium_owner_fields_view.dart';

/// Owner Fields Management Page - Premium Design
///
/// Features:
/// - Navy-themed premium header with glassmorphism
/// - Search functionality with blur effect
/// - Stats chips showing field counts
/// - Filter chips (All, Active, Inactive)
/// - Pull-to-refresh
/// - Edit/Delete actions with confirmation dialogs
/// - Premium field cards with images
/// - Empty states with icons
/// - Premium floating add button
/// - All logic handled by OwnerFieldsCubit
class OwnerFieldsPage extends StatelessWidget {
  const OwnerFieldsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OwnerFieldsCubit>(),
      child: const PremiumOwnerFieldsView(),
    );
  }
}
