import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/fields/presentation/cubit/map_cubit.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Empty state widget for the map page.
class MapEmptyState extends StatelessWidget {
  final bool hasFilters;

  const MapEmptyState({super.key, required this.hasFilters});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            hasFilters ? Icons.filter_list_off : Icons.location_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            hasFilters
                ? context.l10n.noFieldsMatchFilters
                : context.l10n.noFieldsWithLocation,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          if (hasFilters) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<MapCubit>().clearFilters();
              },
              child: Text(context.l10n.clearFilters),
            ),
          ],
        ],
      ),
    );
  }
}
