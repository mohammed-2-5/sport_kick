import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/presentation/widgets/details/premium/reviews/reviews_content.dart';
import 'package:spo_kick/features/reviews/presentation/cubit/reviews_cubit.dart';

/// Premium reviews preview section.
///
/// This is the main entry point for the reviews section in field details.
/// It provides the ReviewsCubit and delegates rendering to ReviewsContent.
class PremiumReviewsPreview extends StatelessWidget {
  final FieldEntity field;

  const PremiumReviewsPreview({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<ReviewsCubit>()..loadFieldReviews(fieldId: field.id, limit: 3),
      child: ReviewsContent(field: field),
    );
  }
}
