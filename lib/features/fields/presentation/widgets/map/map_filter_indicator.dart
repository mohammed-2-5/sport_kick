import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/fields/presentation/cubit/map_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/map_state.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Indicator widget showing that map filters are active.
class MapFilterIndicator extends StatelessWidget {
  const MapFilterIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapCubit, MapState>(
      builder: (context, state) {
        final hasFilters = context.read<MapCubit>().filters.hasActiveFilters;
        if (!hasFilters) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.filter_alt, color: Colors.white, size: 16),
              const SizedBox(width: 4),
              Text(
                context.l10n.filtered,
                style: AppTextStyles.labelSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () {
                  context.read<MapCubit>().clearFilters();
                },
                child: const Icon(Icons.close, color: Colors.white, size: 16),
              ),
            ],
          ),
        );
      },
    );
  }
}
