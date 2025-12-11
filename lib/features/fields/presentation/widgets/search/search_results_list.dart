import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/presentation/widgets/shared/field_card.dart';
import 'package:spo_kick/features/fields/presentation/widgets/search/search_empty_results.dart';

/// Search results list widget.
/// Displays search results with count header and field cards.
class SearchResultsList extends StatelessWidget {
  final String query;
  final List<FieldEntity> results;

  const SearchResultsList({
    super.key,
    required this.query,
    required this.results,
  });

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return SearchEmptyResults(query: query);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Results header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            '${results.length} result${results.length == 1 ? '' : 's'} for "$query"',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),

        // Results list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: results.length,
            itemBuilder: (context, index) {
              final field = results[index];
              return FieldCard(
                field: field,
                onTap: () {
                  context.pushNamed(
                    'fieldDetails',
                    pathParameters: {'fieldId': field.id},
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
