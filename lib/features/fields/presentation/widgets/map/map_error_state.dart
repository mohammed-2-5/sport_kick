import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Error state widget for the map page.
class MapErrorState extends StatelessWidget {
  final String message;

  const MapErrorState({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: AppColors.error),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              context.read<FieldsCubit>().loadAllFields();
            },
            icon: const Icon(Icons.refresh),
            label: Text(context.l10n.retry),
          ),
        ],
      ),
    );
  }
}
