import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/city_management/city_management_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/cities/premium_cities_view.dart';

/// Cities Management Page - Premium Design
///
/// Features:
/// - Premium curved header with navy gradient
/// - Animated stats bar with city counts
/// - Filter chips (All, Active, Inactive)
/// - Premium city cards with status badges
/// - Staggered entrance animations
/// - Pull-to-refresh
/// - Empty and error states
/// - All logic handled by CityManagementCubit
class CitiesPage extends StatelessWidget {
  const CitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CityManagementCubit>()..loadCities(),
      child: const PremiumCitiesView(),
    );
  }
}
