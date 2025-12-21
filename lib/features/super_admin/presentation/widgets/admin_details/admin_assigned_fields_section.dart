import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_state.dart';
import 'package:spo_kick/features/super_admin/presentation/constants/admin_ui_constants.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/admin_details/admin_empty_fields_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/admin_details/admin_field_card.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Displays the assigned fields section for an admin.
class AdminAssignedFieldsSection extends StatelessWidget {
  final UserEntity admin;
  final VoidCallback onAssignField;

  const AdminAssignedFieldsSection({
    super.key,
    required this.admin,
    required this.onAssignField,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AdminUIConstants.paddingHorizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.assignedFields,
                style: AppTextStyles.bold(AppTextStyles.titleLarge),
              ),
              TextButton.icon(
                onPressed: onAssignField,
                icon: const Icon(Icons.add, size: 18),
                label: Text(context.l10n.assign),
              ),
            ],
          ),
          const SizedBox(height: AdminUIConstants.listItemSpacing),
          BlocBuilder<FieldsCubit, FieldsState>(
            builder: (context, state) {
              if (state is FieldsLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(AdminUIConstants.emptyStatePadding),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (state is FieldsLoaded) {
                final adminFields = _getAdminFields(state.fields);

                if (adminFields.isEmpty) {
                  return AdminEmptyFieldsState(onAssignField: onAssignField);
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: adminFields.length,
                  itemBuilder: (context, index) {
                    return AdminFieldCard(
                      field: adminFields[index],
                      onTap: () {
                        context.pushNamed(
                          'fieldDetails',
                          pathParameters: {'fieldId': adminFields[index].id},
                        );
                      },
                    );
                  },
                );
              }

              return AdminEmptyFieldsState(onAssignField: onAssignField);
            },
          ),
        ],
      ),
    );
  }

  List<FieldEntity> _getAdminFields(List<FieldEntity> fields) {
    return fields.where((field) => field.ownerId == admin.id).toList();
  }
}
