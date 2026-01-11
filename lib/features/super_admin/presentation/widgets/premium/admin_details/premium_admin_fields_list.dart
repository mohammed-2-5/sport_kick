import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/admin_details/components/add_field_button.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/admin_details/components/field_card.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/admin_details/components/empty_fields_state.dart';

/// Premium admin assigned fields list.
///
/// Features:
/// - Staggered animations
/// - Field cards with status
/// - Add field button
/// - Empty state
class PremiumAdminFieldsList extends StatelessWidget {
  final List<FieldEntity> fields;
  final VoidCallback onAssignField;
  final Function(FieldEntity) onFieldTap;

  const PremiumAdminFieldsList({
    super.key,
    required this.fields,
    required this.onAssignField,
    required this.onFieldTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with add button
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.accentCyan, AppColors.accentCyanDark],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.sports_soccer,
                  size: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  context.l10n.assignedFields,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              AddFieldButton(onTap: onAssignField),
            ],
          ),

          const SizedBox(height: 16),

          // Content
          if (fields.isEmpty)
            const EmptyFieldsState()
          else
            AnimationLimiter(
              child: Column(
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 375),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(child: widget),
                  ),
                  children: fields
                      .map(
                        (field) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: FieldCard(
                            field: field,
                            onTap: () => onFieldTap(field),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
