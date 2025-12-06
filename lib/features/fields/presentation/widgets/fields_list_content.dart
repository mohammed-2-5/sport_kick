import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/widgets/field_card.dart';

class FieldsListContent extends StatelessWidget {
  final List<dynamic>
  fields; // Using dynamic because it can be FieldEntity or similar

  const FieldsListContent({super.key, required this.fields});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<FieldsCubit>().refresh();
      },
      child: AnimationLimiter(
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          itemCount: fields.length,
          itemBuilder: (context, index) {
            final field = fields[index];
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: FieldCard(
                    field: field,
                    onTap: () {
                      context.pushNamed(
                        'fieldDetails',
                        pathParameters: {'fieldId': field.id},
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
