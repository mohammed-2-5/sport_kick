import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/reviews/presentation/cubit/reviews_cubit.dart';

/// Write review button that appears for authenticated users.
///
/// Features:
/// - Only visible for authenticated users
/// - Opens create review page
/// - Refreshes reviews list after successful review submission
class WriteReviewButton extends StatelessWidget {
  final FieldEntity field;
  final ColorScheme colorScheme;

  const WriteReviewButton({
    super.key,
    required this.field,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        if (authState is Authenticated) {
          return SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                final result = await context.pushNamed(
                  'createReview',
                  extra: {'fieldId': field.id, 'fieldName': field.name},
                );

                if (result == true && context.mounted) {
                  context.read<ReviewsCubit>().loadFieldReviews(
                    fieldId: field.id,
                    limit: 3,
                  );
                }
              },
              icon: const Icon(Icons.rate_review),
              label: Text(context.l10n.writeAReview),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
